Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1KCNfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:35:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1KCNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:35:41 -0400
Date: Thu, 3 Nov 2011 14:35:37 +0100
From: Uros Vampl <mobile.leecher@gmail.com>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>
Subject: Re: [PATCH RESEND] Fix reboot regression on Acer Aspire One AOA110
Message-ID: <20111103133537.GA794@zverina>
References: <1320240899-16889-1-git-send-email-anarsoul@gmail.com>
 <w4ehxqf0q1.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w4ehxqf0q1.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.11.11 12:34, Peter Chubb wrote:
> >>>>> "Vasily" == Vasily Khoruzhick <anarsoul@gmail.com> writes:
> 
> Vasily> From: Uroš Vampl <mobile.leecher@gmail.com> Starting with
> Vasily> kernel 3.0, my Acer Aspire One AOA110 hangs on reboot. Doing
> Vasily> an internet search, I found that in git commit
> Vasily> b49c78d4827be8d7e67e5b94adac6b30a4a9ad14 the machine was made
> Vasily> to reboot with the bios method, but it does not work on most
> Vasily> (all?) AOA110s.
> 
> That change was made in July to fix the broken ACPI reboot method.  It
> certainly works on my AOA110.  What BIOS do you have installed?
> (although looking at what's been published, I can't see any booting
> problems mentioned in the BIOS changelogs).

My bios is v0.3309. An unpatched kernel will hang on a black screen at 
reboot, the only way out is holding the power button for 5 seconds to 
turn the machine off.

> 
> Vasily> This patch introduces new quirks section for machines that
> Vasily> only reboot with the kbd method and put the Aspire One into
> Vasily> it.
> 
> You don't need yet another table, just change the callback.
> 
> 
> Try this:

Yes, this works too.

Regards,
Uroš


> 
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
