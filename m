Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0EKS01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:26:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab0EKS0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:26:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] acpi: Unconditionally set SCI_EN on resume
Date: Tue, 11 May 2010 20:27:36 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org
References: <1273600165-16681-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1273600165-16681-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201005112027.36923.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 May 2010, Matthew Garrett wrote:
> The ACPI spec tells us that the firmware will reenable SCI_EN on resume.
> Reality disagrees in some cases. The ACPI spec tells us that the only way
> to set SCI_EN is via an SMM call.
> https://bugzilla.kernel.org/show_bug.cgi?id=13745 shows us that doing so
> may break machines. Tracing the ACPI calls made by Windows shows that it
> unconditionally sets SCI_EN on resume with a direct register write, and
> therefore the overwhelming probability is that everything is fine with
> this behaviour.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/kernel/acpi/sleep.c |    2 -
>  drivers/acpi/sleep.c         |  157 +-----------------------------------------
>  include/linux/acpi.h         |    1 -
>  3 files changed, 2 insertions(+), 158 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index f996103..82e5086 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -162,8 +162,6 @@ static int __init acpi_sleep_setup(char *str)
>  #endif
>  		if (strncmp(str, "old_ordering", 12) == 0)
>  			acpi_old_suspend_ordering();
> -		if (strncmp(str, "sci_force_enable", 16) == 0)
> -			acpi_set_sci_en_on_resume();
>  		str = strchr(str, ',');
>  		if (str != NULL)
>  			str += strspn(str, ", \t");
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index baa76bb..4ab2275 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -80,22 +80,6 @@ static int acpi_sleep_prepare(u32 acpi_state)
>  
>  #ifdef CONFIG_ACPI_SLEEP
>  static u32 acpi_target_sleep_state = ACPI_STATE_S0;
> -/*
> - * According to the ACPI specification the BIOS should make sure that ACPI is
> - * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
> - * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
> - * on such systems during resume.  Unfortunately that doesn't help in
> - * particularly pathological cases in which SCI_EN has to be set directly on
> - * resume, although the specification states very clearly that this flag is
> - * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
> - * cases.
> - */
> -static bool set_sci_en_on_resume;
> -
> -void __init acpi_set_sci_en_on_resume(void)
> -{
> -	set_sci_en_on_resume = true;
> -}
>  
>  /*
>   * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
> @@ -253,11 +237,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>  		break;
>  	}
>  
> -	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
> -	if (set_sci_en_on_resume)
> -		acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
> -	else
> -		acpi_enable();
> +	/* This violates the spec but is required for bug compatibility. */
> +	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);

No, this breaks my MSI Wind U100 right away.

If you called acpi_enable() before that and do that depending on its result,
_that_ would work.

Thanks,
Rafael
