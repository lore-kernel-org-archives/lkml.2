Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0D1S6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:58:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab0D1S57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:57:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>, lenb@kernel.org
Subject: Re: [PATCH] acpi: Fall back to manually changing SCI_EN
Date: Wed, 28 Apr 2010 20:58:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>
References: <1271711614-15527-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1271711614-15527-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004282058.20910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Matthew Garrett wrote:
> The ACPI spec tells us that the ACPI SCI_EN bit is under hardware control
> and shouldn't be touched by the OS. It seems that the Leading Other OS
> ignores this and some machines expect this behaviour. We have a blacklist
> for these, but given that we're able to detect the failure case and the
> alternative to breaking the spec is letting the machine crash and burn,
> let's try falling back when we know the alternative is a mostly-dead
> machine.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

I guess we can try that, but I'd prefer it if that went into .35.

It _should_ be safe, but ...

Anyway, Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/sleep.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index f74834a..79df8d4 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -227,6 +227,7 @@ static int acpi_suspend_begin(suspend_state_t pm_state)
>  static int acpi_suspend_enter(suspend_state_t pm_state)
>  {
>  	acpi_status status = AE_OK;
> +	acpi_status enable_status = AE_OK;
>  	unsigned long flags = 0;
>  	u32 acpi_state = acpi_target_sleep_state;
>  
> @@ -254,10 +255,19 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>  	}
>  
>  	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
> -	if (set_sci_en_on_resume)
> +	if (!set_sci_en_on_resume)
> +		enable_status = acpi_enable();
> +
> +	if (set_sci_en_on_resume || enable_status == AE_NO_HARDWARE_RESPONSE)
> +		/* If we're still in legacy mode then we have a problem. The
> +		 * spec tells us that this bit is under hardware control, but
> +		 * there's no plausible way that the OS can transition back to
> +		 * legacy mode so our choices here are to either ignore the
> +		 * spec or crash and burn horribly. The latter doesn't seem
> +		 * like it's ever going to be the preferable choice, so let's
> +		 * live dangerously.
> +		 */
>  		acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
> -	else
> -		acpi_enable();
>  
>  	/* Reprogram control registers and execute _BFS */
>  	acpi_leave_sleep_state_prep(acpi_state);
