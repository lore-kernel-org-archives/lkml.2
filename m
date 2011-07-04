Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1GDO7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:59:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:46884 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab1GDO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:59:44 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Mon, 4 Jul 2011 16:59:32 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107041420.31049.richard@nod.at> <201107042342.HDH34381.OFtHSLOMVFJFOQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201107042342.HDH34381.OFtHSLOMVFJFOQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041659.32707.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 Juli 2011, 16:42:09 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > > That's strange... Would you show us printk() output like
> > > 
> > > 	printk(KERN_INFO "Calling request_module()\n");
> > > 	request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
> > > 	printk(KERN_INFO "Returned from request_module()\n");
> > > 
> > > for demonstrating that __request_module() cannot stop at
> > > MAX_KMOD_CONCURRENT levels of nesting?
> > 
> > There you go!
> > http://userweb.kernel.org/~rw/boot.log
> > 
> > I did not count all messages, but they are more than 50. :-)
> 
> Thank you.
> 
> $ grep -F 'Calling request_module()' boot.log | wc -l
> 25819
> $ grep -F 'Returned from request_module()' boot.log | wc -l
> 25770

Ahh, the dela is 49. Got it!

> So, __request_module() is stopping at MAX_KMOD_CONCURRENT levels
> of nesting. Eventually the process that triggered the first
> request_module() will return from search_binary_handler().
> I don't think this is an infinite loop inside search_binary_handler().
> 
> But it would look like an infinite loop bug if the caller of execve()
> repeats forever. Printing additional information like
> 
>   printk(KERN_INFO "Calling request_module() %s %d %s %d %d\n",
> current->comm, current->pid, bprm->filename, bprm->argc, bprm->envc);
> 
> would help.

Here the second boot log:
http://userweb.kernel.org/~rw/boot2.log

The interesting part is:
---cut---
VFS: Mounted root (ext2 filesystem) readonly on device 98:0.
Calling request_module() swapper 1 /sbin/init 1 3
Calling request_module() kworker/u:0 211 /sbin/modprobe 4 3
...
Calling request_module() kworker/u:0 8741 /sbin/modprobe 4 3
---cut---

After the last "Calling request_module..." message no more messages appear and 
the kernel seems to loop for ever.

Maybe it takes just very long until all calls to /sbin/modprobe terminate?

Thanks,
//richard
