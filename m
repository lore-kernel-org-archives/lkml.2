Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HAQSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:18:44 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:37191 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab1HAQSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:18:39 -0400
X-Greylist: delayed 1015 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Aug 2011 12:18:39 EDT
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: shm updates broke UML
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 01 Aug 2011 18:01:30 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: Richard Weinberger <richard@nod.at>, <serge.hallyn@canonical.com>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <toralf.foerster@gmx.de>
Organization: Metropolis
In-Reply-To: <20110801134911.GA11705@albatros>
References: <201108011541.59640.richard@nod.at> <20110801134911.GA11705@albatros>
Message-ID: <43e4e9e98b32d3d3eb06ab837a019ad8@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: segoon@openwall.com, richard@nod.at, serge.hallyn@canonical.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 1 Aug 2011 17:49:11 +0400, Vasiliy Kulikov <segoon@openwall.com>
wrote:
> Hi Richard,
> 
> On Mon, Aug 01, 2011 at 15:41 +0200, Richard Weinberger wrote:
>> 5774ed01 (shm: handle separate PID namespaces case)
>> b34a6b1d (ipc: introduce shm_rmid_forced sysctl)
>> 4c677e2e (shm: optimize locking and ipc_namespace getting)
>> 
>> broke UML on i386.
>> It crashes while starting up by SIGSEGV.
>> exit_shm() seems to be the evil doer.
> 
> I was reported 20 mins ago that it's reproducable on MIPS too.
> 
>> Reverting all three patches make UML work again.
> 
> Can you confirm that 5774ed01 breaks the boot? (it is for MIPS)

It also breaks ARM (at least 11MPCore and Cortex A9).
The same workaround gets the kernel booting again.

For the record:
[...]
CPU: Testing write buffer coherency: ok
Calibrating local timer... 104.99MHz.
CPU1: Booted secondary processor
CPU1: Unknown IPI message 0x1
CPU2: Booted secondary processor
CPU2: Unknown IPI message 0x1
CPU3: Booted secondary processor
CPU3: Unknown IPI message 0x1
Brought up 4 CPUs
SMP: Total of 4 processors activated (333.92 BogoMIPS).
Unable to handle kernel NULL pointer dereference at virtual address
00000000
NET: Registered protocol family 16
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1] SMP
Modules linked in:
CPU: 2    Not tainted  (3.0.0-next-20110801+ #801)
PC is at __down_write_nested+0x88/0xe0
LR is at __down_write_nested+0x18/0xe0
pc : [<c0320090>]    lr : [<c0320020>]    psr: 60000093
sp : df883f68  ip : 00000000  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : c04474dc
r7 : c04474d8  r6 : 00000000  r5 : 00000002  r4 : df884000
r3 : df884008  r2 : 00000000  r1 : 60000013  r0 : c04474e0
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5787f  Table: 7000400a  DAC: 00000015
Process kworker/u:0 (pid: 18, stack limit = 0xdf882270)
Stack: (0xdf883f68 to 0xdf884000)
3f60:                   c04474e0 df8b0004 df884000 00000002 c04474d8
c0447474
3f80: 00000000 00000000 df8b0000 c015da08 df884000 00000000 00000000
c002e550
3fa0: 00000000 00000000 df882000 00000001 00000000 00000000 00000000
00000000
3fc0: 00000000 df8238c0 df8a7000 fffffffe 00000013 00000000 00000000
00000000
3fe0: 00000000 c003eaac df8238c0 c003e970 c000f630 c000f630 00000000
00000000
[<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>]
(exit_shm+0x28/0x48)
[<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>] (do_exit+0x59c/0x750)
[<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>]
(____call_usermodehelper+0x13c/0x154)
[<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>]
(kernel_thread_exit+0x0/0x8)
Code: 1afffffa e597c00c e58d0000 e587d00c (e58cd000) 
---[ end trace 1b75b31a2719ed1c ]---

        M.
-- 
Who you jivin' with that Cosmik Debris?
