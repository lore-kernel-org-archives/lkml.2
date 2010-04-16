Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0DPOdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:33:38 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:16093 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0DPOdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:33:36 -0400
X-Spam-Processed: digidescorp.com, Fri, 16 Apr 2010 09:33:34 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.37.252
X-Return-Path: prvs=17226ac423=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [microblaze-uclinux] Re: [PATCH 1/2] microblaze: add stack
 unwinder
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <4BC820B2.6060604@monstr.eu>
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
	 <4BC820B2.6060604@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 16 Apr 2010 09:33:30 -0500
Message-Id: <1271428410.3366.23.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 10:32 +0200, Michal Simek wrote:
> Please apply this patch and do the same testing as I did.
> 
> diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
> index a1721a3..76f6587 100644
> --- a/arch/microblaze/kernel/reset.c
> +++ b/arch/microblaze/kernel/reset.c
> @@ -112,8 +112,8 @@ void of_platform_reset_gpio_probe(void)
>   void machine_restart(char *cmd)
>   {
>          printk(KERN_NOTICE "Machine restart...\n");
> +       machine_shutdown();
>          gpio_system_reset();
> -       dump_stack();
>          while (1)
>                  ;
>   }
> @@ -121,6 +121,7 @@ void machine_restart(char *cmd)
>   void machine_shutdown(void)
>   {
>          printk(KERN_NOTICE "Machine shutdown...\n");
> +       dump_stack();
>          while (1)
>                  ;
>   }

I get this:

Call Trace:
[<20003008>] microblaze_unwind+0x68/0x94
[<20002c24>] show_stack+0x134/0x174
[<20002c80>] dump_stack+0x1c/0x3c
[<20001d84>] machine_shutdown+0x30/0x40
[<20001dc0>] machine_restart+0x2c/0x48
[<2002a540>] kernel_restart+0x5c/0x80
[<2002a6b8>] sys_reboot+0x11c/0x218
SYSCALL
[<2d5c0248>] PID 118 [reboot]

Is your problem on a MMU or noMMU system?

If the unwinder stops early, it found a return address outside the
kernel text, or couldn't find the addik that creates a stack frame - but
there's not enough information here to tell what happened. In your case
the backtrace goes off the rails before getting to the frame for
dump_stack(), which is where the stack dump begins. We'd need to see the
21 words preceding the dump (show_stack's frame is 13 words, and
microblaze_unwind's is 8) to know why.

Can you uncomment the #define DEBUG in unwind.c and try it again?

Thanks,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


