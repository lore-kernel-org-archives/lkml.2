Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab2EJSFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:05:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53036 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2EJSFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:05:03 -0400
Date: Thu, 10 May 2012 14:04:55 -0400 (EDT)
Message-Id: <20120510.140455.1781747924240555033.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 3.4.0-rc4: ksoftirqd crash on sparc64 after IO errors and RCU
 stalls
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1204222352580.16791@math.ut.ee>
References: <alpine.SOC.1.00.1204222352580.16791@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 11:04:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 23 Apr 2012 00:33:07 +0300 (EEST)

> [  376.207537] Kernel unaligned access at TPC[42c0dc] arch_trigger_all_cpu_backtrace+0x13c/0x1c0
> [  376.319655] Unable to handle kernel paging request in mna handler
> [  376.397504]  at virtual address 000007f300000001
> [  376.460414] current->{active_,}mm->context = 000000000000086f
> [  376.535905] current->{active_,}mm->pgd = fffff8101d5d0000
> [  376.606819]               \|/ ____ \|/
> [  376.606822]               "@'/ .. \`@"
> [  376.606825]               /_| \__/ |_\
> [  376.606828]                  \__U_/
> [  376.800115] ksoftirqd/1(3): Oops [#1]
> [  376.848157] TSTATE: 0000009980e01600 TPC: 000000000042c0dc TNPC: 000000000042c0e0 Y: 00000000    Not tainted
> [  376.977422] TPC: <arch_trigger_all_cpu_backtrace+0x13c/0x1c0>
> [  377.052999] g0: 0000000000000001 g1: ffffffffffffffff g2: 00000000008f5060 g3: 000007f300000001
> [  377.167387] g4: fffff8101f071ec0 g5: fffff80000bf8000 g6: fffff8101f08c000 g7: 0000000000000003
> [  377.281766] o0: 000000000000000c o1: 0000000000000020 o2: 0000000000000000 o3: 0000004411001603
> [  377.396248] o4: 000000000064e920 o5: 000000000064e924 sp: fffff8101f08e2b1 ret_pc: 000000000042c0a0
> [  377.515306] RPC: <arch_trigger_all_cpu_backtrace+0x100/0x1c0>
> [  377.590781] l0: 000000000000000e l1: 00000000008f50b0 l2: 00000000008f50e0 l3: 00000000008f5068
> [  377.705171] l4: 00000000008f5000 l5: 0000000000a0cfc0 l6: 0000000000000000 l7: 0000000000000000
> [  377.819550] i0: 0000000000000001 i1: 0000000000983680 i2: 00000000009847bc i3: 000000000098ac00
> [  377.934032] i4: 0000000000a0cfc0 i5: 0000000000000000 i6: fffff8101f08e381 i7: 00000000004cf3b4
> [  378.048522] I7: <print_cpu_stall+0x54/0x120>

The thread pointer stored by one of the cpus is garbage.  It's being
inspected in %g3 at this point on the cpu which triggered the
backtrace.  It just tested it for NULL, which passed, so then we trust
it as a good kernel pointer but it's not, it's 000007f300000001.

And we take the unaligned trap when we try to dereference that thing.

Looking at the code which collects these registers, the bug is clear.
In arch/sparc/mm/ultra.S:xcall_fetch_glob_regs we go:

	sethi		%hi(global_reg_snapshot), %g1
	or		%g1, %lo(global_reg_snapshot), %g1
	__GET_CPUID(%g2)
	sllx		%g2, 6, %g3
	add		%g1, %g3, %g1

so far so good, %g2 holds the current cpu's number, and %g1 now holds
a pointer to the global_reg_snapshot entry we'll fill in.

But later in this routine:

	rdpr		%cwp, %g2
	sub		%g2, 1, %g7
	wrpr		%g7, %cwp
	mov		%i7, %g7
	wrpr		%g2, %cwp
	stx		%g7, [%g1 + GR_SNAP_RPC]

which on the surface looks fine, but the problem is we've clobbered
%g2 and then afterwards we go:

	sethi		%hi(trap_block), %g7
	or		%g7, %lo(trap_block), %g7
	sllx		%g2, TRAP_BLOCK_SZ_SHIFT, %g2
	add		%g7, %g2, %g7
	ldx		[%g7 + TRAP_PER_CPU_THREAD], %g3
	stx		%g3, [%g1 + GR_SNAP_THREAD]

This code assumes %g2 still holds the current cpu's number in it, but
as stated it's been clobbered with the %cwp read above.

That's why we read a garbage thread pointer, the index we use into
trap_block[] is wrong.

I'll work on a fix for this, thanks for the report.
