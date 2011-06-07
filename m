Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1FGJjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:39:41 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:43802 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1FGJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:39:40 -0400
X-Yandex-Spam: 1
From: Dmitry Dmitriev <dimondmm@yandex.ru>
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM]: x86-32: Corrupted real-time signal frame when VDSO is disabled.
MIME-Version: 1.0
Message-Id: <419131307439578@web128.yandex.ru>
Date: Tue, 07 Jun 2011 13:39:38 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On x86 32 bit system, real-time signal frame become corrupted when VDSO is disabled. 
If we do following:
1) Disable VDSO( write 0 to the /proc/sys/vm/vdso_enabled )
2) Create new process
3) Setup handler for real-time signal in new process
4) Send real-time signal to new process.

Then new process will handle this signal and crash, because it signal frame is corrupted. This problem was observed on 2.6.35 kernel, but it seems that it still exist in 2.6.39 kernel( after examing of source code ).

The problem in __setup_rt_frame function( arch/x86/kernel/signal.c module, 2.6.39 kernel source ):
 347static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 348                            sigset_t *set, struct pt_regs *regs)
 349{
......
 380                /* Set up to return from userspace.  */
 381                restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
......
 411        return 0;
 412}

__setup_rt_frame set up return from userspace without checking of vdso( lines 380-381 ), i.e. if vdso is disabled, then process will not have VDSO context.

For non real-time signals similar action is performed in following way( __setup_frame function, arch/x86/kernel/signal.c module, 2.6.39 kernel source ):
 284static int
 285__setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 286              struct pt_regs *regs)
 287{
.......
 310        if (current->mm->context.vdso)
 311                restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
 312        else
 313                restorer = &frame->retcode;
.......
 344        return 0;
 345}

I think that similar construction must be add to the __setup_rt_frame function.

Regards,
Dmitry

