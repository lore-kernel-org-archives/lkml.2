Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839Ab2DLCoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:44:11 -0400
Received: from mail4.comsite.net ([205.238.176.238]:4950 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2DLCoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:44:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failures with next-20120411
Message-Id: <next-20120411-oops@mdm.bga.com>
In-Reply-To: <20120411165835.415e546374a54ea94669b0c6@canb.auug.org.au>
References: <20120411165835.415e546374a54ea94669b0c6@canb.auug.org.au>
Date: Wed, 11 Apr 2012 21:44:08 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 about 16:58:35 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Some (not all) of my PowerPC boot tests have failed like this after
> getting into user mode (this one was just after udev started, but others
> are after other processes getting going):
> 
> Unable to handle kernel paging request for data at address 0xc0000003f9d550
> Faulting instruction address: 0xc0000000001b7f40
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in: ehea
> NIP: c0000000001b7f40 LR: c0000000001b7f14 CTR: c0000000000e04f0
> REGS: c0000003f68bf6b0 TRAP: 0300   Not tainted  (3.4.0-rc2-autokern1)
> MSR: 800000000280b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 24422424  XER: 20000001
> SOFTE: 1
> CFAR: 000000000000562c
> DAR: 00c0000003f9d550, DSISR: 40000000
> TASK = c0000003f8818000[3192] 'kdump' THREAD: c0000003f68bc000 CPU: 5
> GPR00: 0000000000000000 c0000003f68bf930 c000000000ce1d40 c0000003fe00ec00 
> GPR04: 00000000000002d0 0000000000000038 c0000003f8f935e8 c000000000e55280 
> GPR08: 0000000000000011 c000000000bcb280 c000000000bcb1e8 000000000028a000 
> GPR12: 0000000024422424 c00000000f33bc80 00000fffdd90a770 0000000000081000 
> GPR16: c0000003f846c000 000000000de4f7a0 f00000000de4f7a0 0000000000000000 
> GPR20: c0000003f8365408 c0000003f8365480 c0000003f8e5d110 0000000000000000 
> GPR24: 0000000000000100 c0000003f8365400 c0000000001e5424 00000000000002d0 
> GPR28: 0000000000000800 00c0000003f9d550 c000000000c5b718 c0000003fe00ec00 
> NIP [c0000000001b7f40] .__kmalloc+0x70/0x230
> LR [c0000000001b7f14] .__kmalloc+0x44/0x230
> Call Trace:
> [c0000003f68bf930] [c0000003f68bf9b0] 0xc0000003f68bf9b0 (unreliable)
> [c0000003f68bf9e0] [c0000000001e5424] .alloc_fdmem+0x24/0x70
> [c0000003f68bfa60] [c0000000001e54f8] .alloc_fdtable+0x88/0x130
> [c0000003f68bfaf0] [c0000000001e5924] .dup_fd+0x384/0x450
> [c0000003f68bfbd0] [c00000000009a310] .copy_process+0x880/0x11d0
> [c0000003f68bfcd0] [c00000000009aee0] .do_fork+0x70/0x400
> [c0000003f68bfdc0] [c0000000000141c4] .sys_clone+0x54/0x70
> [c0000003f68bfe30] [c000000000009aa0] .ppc_clone+0x8/0xc
> Instruction dump:
> 4bff9281 2ba30010 7c7f1b78 40dd00f4 e96d0040 e93f0000 7ce95a14 e9070008 
> 7fa9582a 2fbd0000 41de0054 e81f0022 <7f3d002a> 38000000 886d01f2 980d01f2 
> ---[ end trace 366fe6c7ced3bfb0 ]---
> This did not happen yesterday.  Just wondering if anyone can think of
> anything obvious.  Full console log at
> http://ozlabs.org/~sfr/next-20120411.log.bz2

Hi Steven.

The DAR print of the faulting address points out that the address
appears to be shifted right 8 bits.  Or more likely the address used
to load the register was decremented by one somewhere (Big Endian).

Although all the registers are multiples of 4 in the first dump,
looking at the later oops in the log would seem to confirm the
address being decremented, eg put_files struct dar of 
c0000003f9d547ff in oops #2, and dar 00000000ffffffff in #9, #12,
#14, and #16.

No idea if this is caused by a bad save/restore somewhere or a
decrement of a 32bit number in memory.

Anyone else with a wild -1 on a int, u32 or s32?

milton
