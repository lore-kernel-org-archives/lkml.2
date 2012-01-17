Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2AQUAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:00:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45029 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2AQUAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:00:51 -0500
Date: Tue, 17 Jan 2012 19:58:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
Message-ID: <20120117195841.48fe8236@pyramind.ukuu.org.uk>
In-Reply-To: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 10:16:03 -0500
Michael D Labriola <mlabriol@gdeb.com> wrote:

> This commit causes DMI checks for vendor specific reboot
> quirks to be skipped if the user passed in a reboot= arg
> on the command line.
> 
> Signed-off-by: Michael D Labriola <mlabriol@gdeb.com>
> ---
>  arch/x86/kernel/reboot.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 37a458b..4240d58 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -38,6 +38,7 @@ static const struct desc_ptr no_idt = {};
>  static int reboot_mode;
>  enum reboot_type reboot_type = BOOT_ACPI;
>  int reboot_force;
> +int reboot_user;

static ...

>                 case 'f':
>                         reboot_force = 1;
> +                       reboot_user = 1;

Cleaner would be to add a 

BOOT_ACPI_FORCE perhaps so you can tell ACPI v ACPI specified by user

>                         break;
>                 }
>  
> @@ -316,7 +322,10 @@ static struct dmi_system_id __initdata 
> reboot_dmi_table[] = {
>  
>  static int __init reboot_init(void)
>  {
> -       dmi_check_system(reboot_dmi_table);
> +       /* Skip the DMI check if user set reboot= on the command line */
> +       if (!reboot_user) {

then do

	if (reboot_type == BOOT_ACPI)
> +               dmi_check_system(reboot_dmi_table);
> +       }
