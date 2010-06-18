Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab0FRQwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:52:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52190 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736Ab0FRQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=o/vZECl+k76+QlO7wINXdLh/IE7fqS9HZ3zP23ZWw3MIB1fh/NPLi7bfLrVoylij+W
         DwUU2Nc11ydsGvyq5AUeCZOvQHWjeDb9cfr0eydcgK/gJfSdfEwepu4UE/KttyObmdwm
         xnbGnvZYAdUKNyYqnKDvICujNQaW2wPYCGylQ=
MIME-Version: 1.0
In-Reply-To: <20100618172121.528f2e09@lxorguk.ukuu.org.uk>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<201006172348.08180.arnd@arndb.de>
	<20100617220926.GC5345@nowhere>
	<201006181458.07687.arnd@arndb.de>
	<20100618172121.528f2e09@lxorguk.ukuu.org.uk>
Date: Fri, 18 Jun 2010 09:52:44 -0700
X-Google-Sender-Auth: YaESmd7pEU1oh0HYVKsN-8K4ZsM
Message-ID: <AANLkTikfqHO1x0P_iyYTsGGjDcZGCEmZFPUDWiKzk2SQ@mail.gmail.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
From: Tony Luck <tony.luck@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 9:21 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> So I ack this patch - it's the only way to find out 8)

Here's the results from this patch on top of next-20100618

The "WARNING: at include/linux/tty.h:589 tty_open+0x9d0/0xc60()" messages
are back, two of them, both with same stack trace:


Call Trace:
 [<a0000001000159d0>] show_stack+0x50/0xa0
 [<a00000010090f270>] dump_stack+0x30/0x50
 [<a00000010008e2c0>] warn_slowpath_common+0xc0/0x120
 [<a00000010008e360>] warn_slowpath_null+0x40/0x60
 [<a00000010053eb40>] tty_open+0x160/0xc60
 [<a0000001001af9b0>] chrdev_open+0x310/0x360
 [<a0000001001a58b0>] __dentry_open+0x350/0x680
 [<a0000001001a5d80>] nameidata_to_filp+0x80/0xc0
 [<a0000001001bfee0>] finish_open+0x160/0x380
 [<a0000001001c0cc0>] do_last+0xbc0/0xce0
 [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
 [<a0000001001a5290>] do_sys_open+0x90/0x200
 [<a0000001001a54d0>] sys_open+0x50/0x80
 [<a000000100b907e0>] kernel_init+0x340/0x420
 [<a000000100013c10>] kernel_thread_helper+0x30/0x60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40

The tty_release() ones have all gone though.

I've also just noticed that the serial console output gets garbled
(like it is at the wrong baud rate) when userland code starts
printing messages. Stays garbled until /sbin/agetty starts up
to print the "Welcome ... login:" banner.

Similar garbage when shutting down with "reboot" command.
I can see "INIT", then it all goes to pieces until I see the kernel
print "Restarting system".

-Tony
