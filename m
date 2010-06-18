Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab0FRSf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:35:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0FRSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:35:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
Date: Fri, 18 Jun 2010 20:35:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100618172121.528f2e09@lxorguk.ukuu.org.uk> <AANLkTikfqHO1x0P_iyYTsGGjDcZGCEmZFPUDWiKzk2SQ@mail.gmail.com>
In-Reply-To: <AANLkTikfqHO1x0P_iyYTsGGjDcZGCEmZFPUDWiKzk2SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006182035.17394.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+KOrm8P3Ssqca3Yrg/F23fimEsj7Fmfe1pGjh
 VzoSquaUddIeTO4lIYOPfiTn6GDeVHBGqkhYX5gUn2ppiBNkJb
 L1nmhkU8J5WDIeSvewKJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 June 2010, Tony Luck wrote:
> On Fri, Jun 18, 2010 at 9:21 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > So I ack this patch - it's the only way to find out 8)
> 
> Here's the results from this patch on top of next-20100618
> 
> The "WARNING: at include/linux/tty.h:589 tty_open+0x9d0/0xc60()" messages
> are back, two of them, both with same stack trace:
> 
> 
> Call Trace:
>  [<a0000001000159d0>] show_stack+0x50/0xa0
>  [<a00000010090f270>] dump_stack+0x30/0x50
>  [<a00000010008e2c0>] warn_slowpath_common+0xc0/0x120
>  [<a00000010008e360>] warn_slowpath_null+0x40/0x60
>  [<a00000010053eb40>] tty_open+0x160/0xc60
>  [<a0000001001af9b0>] chrdev_open+0x310/0x360
>  [<a0000001001a58b0>] __dentry_open+0x350/0x680
>  [<a0000001001a5d80>] nameidata_to_filp+0x80/0xc0
>  [<a0000001001bfee0>] finish_open+0x160/0x380
>  [<a0000001001c0cc0>] do_last+0xbc0/0xce0
>  [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
>  [<a0000001001a5290>] do_sys_open+0x90/0x200
>  [<a0000001001a54d0>] sys_open+0x50/0x80
>  [<a000000100b907e0>] kernel_init+0x340/0x420
>  [<a000000100013c10>] kernel_thread_helper+0x30/0x60
>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40

Ok, this is the same one you reported at first. I forgot to
mention that the other patch I sent as a reply to your report
is still needed and not yet in -next since I'm trying to
sort through the other BKL removal patches now.
This instance of the WARN_ON is completely harmless though,
you could consider this one a false positive.

> The tty_release() ones have all gone though.

ok, good.

> I've also just noticed that the serial console output gets garbled
> (like it is at the wrong baud rate) when userland code starts
> printing messages. Stays garbled until /sbin/agetty starts up
> to print the "Welcome ... login:" banner.
>
> Similar garbage when shutting down with "reboot" command.
> I can see "INIT", then it all goes to pieces until I see the kernel
> print "Restarting system".

Do you know if this was a problem with the original series or
something that got introduced by my last patch?
Also, if you don't mind, could you try if the problem also exists
with CONFIG_TTY_MUTEX enabled?
Which serial driver do you use?

I'll try to set up a serial console here to reproduce and bisect
this problem on my own system.

	Arnd
