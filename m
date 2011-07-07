Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1GGLAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:00:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:46263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab1GGK77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:59:59 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mahesh@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, mingo@elte.hu,
        anton@samba.org, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
In-Reply-To: <20110707102107.GA16666@in.ibm.com>
References: <20110707102107.GA16666@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 12:59:35 +0200
Message-ID: <1310036375.3282.509.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 15:52 +0530, Mahesh J Salgaonkar wrote:
> 
> 2.6.39 booted fine on the system and a git bisect shows commit cd4ea6ae -
> "sched: Change NODE sched_domain group creation" as the cause.

Weird, there's no locking anywhere around there. The typical problems
with this patch-set were massive explosions due to bad pointers etc..
But not silent hangs.

The code its stuck at:

> [1]:
> POWER7 performance monitor hardware support registered
> Brought up 896 CPUs
> Enabling Asymmetric SMT scheduling
> BUG: soft lockup - CPU#0 stuck for 22s! [swapper:1]
> Modules linked in:
> NIP: c000000000074b90 LR: c00000000008a1c4 CTR: 0000000000000000
> REGS: c000000fae25f9c0 TRAP: 0901   Not tainted  (3.0.0-rc6)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000088  XER: 00000004
> TASK = c000000fae248490[1] 'swapper' THREAD: c000000fae25c000 CPU: 0
> GPR00: 0000e2a55cbeec50 c000000fae25fc40 c000000000e21f90 c000007b2b34cb00
> GPR04: 0000000000000100 0000000000000100 c000011adcf23418 0000000000000000
> GPR08: 0000000000000000 c000008b2b7d4480 c000007b2b35ef80 00000000000024ac
> GPR12: 0000000044000042 c00000000ebb0000
> NIP [c000000000074b90] .update_group_power+0x50/0x190
> LR [c00000000008a1c4] .build_sched_domains+0x434/0x490
> Call Trace:
> [c000000fae25fc40] [c000000fae25fce0] 0xc000000fae25fce0 (unreliable)
> [c000000fae25fce0] [c00000000008a1c4] .build_sched_domains+0x434/0x490
> [c000000fae25fdd0] [c000000000867370] .sched_init_smp+0xa8/0x224
> [c000000fae25fee0] [c000000000850274] .kernel_init+0x10c/0x1fc
> [c000000fae25ff90] [c000000000023884] .kernel_thread+0x54/0x70
> Instruction dump:
> f821ff61 ebc2b1a0 7c7f1b78 7c9c2378 e9230008 eba30010 2fa90000 419e0054
> e9490010 38000000 7d495378 60000000 <8169000c> e9290000 7faa4800 7c005a14

doesn't contains any locks, its simply looping over all the cpus, and
with that many I can imagine it takes a while, but getting 'stuck' there
is unexpected to say the least.

Surely this isn't the first multi-node P7 to boot a kernel with this
patch? If my git foo is any good it hit -next on 23rd of May.

I guess I'm asking is, do smaller P7 machines boot? And if so, is there
any difference except size?

How many nodes does the thing have anyway, 28? Hmm, that could mean its
the first machine with >16 nodes to boot this, which would make it
trigger the magic ALL_NODES crap.

Let me dig around there.
