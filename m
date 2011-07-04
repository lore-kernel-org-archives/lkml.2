Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1GDWEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:04:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57864 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1GDWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:04:05 -0400
X-Nat-Received: from [202.181.97.72]:57019 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309817029.1115
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1309779003-8668-1-git-send-email-richard@nod.at>
	<201107042342.HDH34381.OFtHSLOMVFJFOQ@I-love.SAKURA.ne.jp>
	<201107041659.32707.richard@nod.at>
	<201107041707.23165.richard@nod.at>
In-Reply-To: <201107041707.23165.richard@nod.at>
Message-Id: <201107050703.EGJ13561.OFQHOOVMJtLFSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 5 Jul 2011 07:03:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04072011 #5661302, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> Am Montag 04 Juli 2011, 16:59:32 schrieb Richard Weinberger:
> > Here the second boot log:
> > http://userweb.kernel.org/~rw/boot2.log
> > 
> > The interesting part is:
> > ---cut---
> > VFS: Mounted root (ext2 filesystem) readonly on device 98:0.
> > Calling request_module() swapper 1 /sbin/init 1 3
> > Calling request_module() kworker/u:0 211 /sbin/modprobe 4 3
> > ...
> > Calling request_module() kworker/u:0 8741 /sbin/modprobe 4 3
> > ---cut---
> > 
> > After the last "Calling request_module..." message no more messages appear
> > and the kernel seems to loop for ever.
> > 
> 
> Please ignore this.
> The "Calling request_module..." messages continue for ever.
> In the first case my terminal locked up...
> current->pid also wraps around.
> 
Please note that the each PID is printed for twice.
This means that each thread within the loop tries to create a thread.
Therefore, it will repeat for (1 << MAX_KMOD_CONCURRENT) times.
It is large enough to wrap the PID.
Well, try with smaller MAX_KMOD_CONCURRENT (e.g. 3).

Calling request_module() kworker/u:0 299 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 301 /sbin/modprobe 4 3 **** 301 1st loop
Calling request_module() kworker/u:0 303 /sbin/modprobe 4 3 **** 303 1st loop
Calling request_module() kworker/u:0 305 /sbin/modprobe 4 3 **** 305 1st loop
Calling request_module() kworker/u:0 307 /sbin/modprobe 4 3 **** 307 1st loop
Calling request_module() kworker/u:0 309 /sbin/modprobe 4 3 **** 309 1st loop
request_module: runaway loop modprobe binfmt-464c
Calling request_module() kworker/u:0 309 /sbin/modprobe 4 3 **** 309 2nd loop
request_module: runaway loop modprobe binfmt-464c
Calling request_module() kworker/u:0 307 /sbin/modprobe 4 3 **** 307 2nd loop
Calling request_module() kworker/u:0 311 /sbin/modprobe 4 3 **** 311 1st loop
request_module: runaway loop modprobe binfmt-464c
Calling request_module() kworker/u:0 311 /sbin/modprobe 4 3 **** 311 2nd loop
request_module: runaway loop modprobe binfmt-464c
Calling request_module() kworker/u:0 305 /sbin/modprobe 4 3 **** 305 2nd loop
Calling request_module() kworker/u:0 313 /sbin/modprobe 4 3 **** 313 1st loop
Calling request_module() kworker/u:0 315 /sbin/modprobe 4 3 **** 315 1st loop
request_module: runaway loop modprobe binfmt-464c
Calling request_module() kworker/u:0 315 /sbin/modprobe 4 3 **** 315 2nd loop
Calling request_module() kworker/u:0 313 /sbin/modprobe 4 3 **** 313 2nd loop
Calling request_module() kworker/u:0 317 /sbin/modprobe 4 3 **** 317 1st loop
Calling request_module() kworker/u:0 317 /sbin/modprobe 4 3 **** 317 2nd loop
Calling request_module() kworker/u:0 303 /sbin/modprobe 4 3 **** 303 2nd loop
Calling request_module() kworker/u:0 319 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 321 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 323 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 323 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 321 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 325 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 325 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 319 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 327 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 329 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 329 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 327 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 331 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 331 /sbin/modprobe 4 3
Calling request_module() kworker/u:0 301 /sbin/modprobe 4 3 **** 301 2nd loop
Calling request_module() kworker/u:0 333 /sbin/modprobe 4 3
