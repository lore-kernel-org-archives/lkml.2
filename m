Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1GEKrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:47:47 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41530 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1GEKrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:47:46 -0400
Date: Tue, 5 Jul 2011 14:47:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [Q x86-64] on kernel_eflags
Message-ID: <20110705104742.GO17941@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While were looking into ret_from_fork code I somehow wondered
about the global kernel_eflags variable here.

arch/x86/cpu/common.c
---------------------
unsigned long kernel_eflags;

void __cpuinit cpu_init(void)
{
	...
	raw_local_save_flags(kernel_eflags);
}

arch/x86/kernel/entry_64.S
--------------------------
ENTRY(ret_from_fork)
	DEFAULT_FRAME
	LOCK ; btr $TIF_FORK,TI_flags(%r8)
	pushq_cfi kernel_eflags(%rip)
	popfq_cfi                               # reset kernel eflags

Every call to cpu_init renew global kernel_eflags
and every task switching does use this variable in a
sake of cleaning carry bit of flags register as far as
I can tell.

Should not every cpu has own copy of kernel_eflags? Just
to be consistent in style? Or this would be space waisting
and an optimization is done here?

	Cyrill
