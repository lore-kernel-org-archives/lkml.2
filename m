Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1KCG0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:26:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1KCG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:26:13 -0400
Message-ID: <1320301535.1346.6.camel@anarsoul-laptop.lan>
Subject: Re: [PATCH RESEND] Fix reboot regression on Acer Aspire One AOA110
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        stable@kernel.org,
        =?UTF-8?Q?Uro=C5=A1?= Vampl <mobile.leecher@gmail.com>
Date: Thu, 03 Nov 2011 09:25:35 +0300
In-Reply-To: <w4ehxqf0q1.wl%peter@chubb.wattle.id.au>
References: <1320240899-16889-1-git-send-email-anarsoul@gmail.com>
	 <w4ehxqf0q1.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:34 +1100, Peter Chubb wrote:

> That change was made in July to fix the broken ACPI reboot method.  It
> certainly works on my AOA110.  What BIOS do you have installed?
> (although looking at what's been published, I can't see any booting
> problems mentioned in the BIOS changelogs).

v0.3310 from Acer site. With BIOS reboot method AOA110 just hangs with
black screeen on reboot.

I'm not the only one who has this problem, take a look at this link:
https://bbs.archlinux.org/viewtopic.php?id=124136

> You don't need yet another table, just change the callback.
> 
> 
> Try this:

Sure, this patch should work. Will test tonight.

Regards
Vasily

> Index: linux-2.6/arch/x86/kernel/reboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/reboot.c	2011-10-31 14:35:50.105623537 +1100
> +++ linux-2.6/arch/x86/kernel/reboot.c	2011-11-03 11:54:12.487901547 +1100
> @@ -124,7 +124,7 @@
>   */
>  
>  /*
> - * Some machines require the "reboot=b"  commandline option,
> + * Some machines require the "reboot=b" or "reboot=k"  commandline options,
>   * this quirk makes that automatic.
>   */
>  static int __init set_bios_reboot(const struct dmi_system_id *d)
> @@ -136,6 +136,15 @@
>  	return 0;
>  }
>  
> +static int __init set_kbd_reboot(const struct dmi_system_id *d)
> +{
> +	if (reboot_type != BOOT_KBD) {
> +		reboot_type = BOOT_KBD;
> +		printk(KERN_INFO "%s series board detected. Selecting KBD-method for reboots.\n", d->ident);
> +	}
> +	return 0;
> +}
> +
>  static struct dmi_system_id __initdata reboot_dmi_table[] = {
>  	{	/* Handle problems with rebooting on Dell E520's */
>  		.callback = set_bios_reboot,
> @@ -295,7 +304,7 @@
>  		},
>  	},
>  	{ /* Handle reboot issue on Acer Aspire one */
> -		.callback = set_bios_reboot,
> +		.callback = set_kbd_reboot,
>  		.ident = "Acer Aspire One A110",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> --
> Dr Peter Chubb                                  peter DOT chubb AT nicta.com.au
> http://www.ertos.nicta.com.au               ERTOS within National ICT Australia
> All things shall perish from under the sky/Music alone shall live, never to die


