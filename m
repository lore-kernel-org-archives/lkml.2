Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab1AGUSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:18:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57664 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1AGUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:18:07 -0500
Date: Fri, 7 Jan 2011 21:18:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: sparc boot failure due to perf init
Message-ID: <20110107201805.GA28104@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have upgraded my Sun Blade 100 to latest mainline,
and when it booted I hit an oops.

Relevant bits from the oops:
Mount-cache hash table entries: 512
Performance events: perf (null)    <<<<<<<<<<<<<<<<<<<
Unable to handle kernel NULL pointer dereference
tsk->{mm,active_mm}->context = 0000000000000000
tsk->{mm,active_mm}->pgd = fffff800003e4634
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
swapper(1): Oops [#1]
TSTATE: 0000004480001606 TPC: 000000000055c180 TNPC: 000000000055c184 Y: 00000000    Not tainted
TPC: <strcmp+0x0/0x40>
g0: fffff8000f03f800 g1: 00000000007df800 g2: 000000000078f918 g3: 0000000000799168
g4: fffff8000f0358c0 g5: fffff80000c22000 g6: fffff8000f038000 g7: 0000000000000001
o0: 0000000000000000 o1: 000000000073b050 o2: 0000000000000001 o3: 0000000000000001
o4: fffff8000f0356c8 o5: 0000000000000000 sp: fffff8000f03b531 ret_pc: 00000000007b9e30
RPC: <init_hw_perf_events+0x30/0x168>
l0: 0000000000000000 l1: 00000000007e0a80 l2: 00000000007e2140 l3: 0000000000000001
l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 0000000000777b78
i0: fffff80001402a80 i1: 0000000000000000 i2: 0000000000000001 i3: 0000000000000001
i4: 0000000000000000 i5: 0000000000000005 i6: fffff8000f03b5e1 i7: 00000000007b41c8
I7: <do_one_initcall+0x68/0x140>

The line mared "<<<<<<<<<<<<<" is added by my printf debugging.
It shows that sparc_pmu_type is NULL.

sparc_pmu_type is set in cpu_type_probe(void) which is:

   arch_initcall(cpu_type_probe);

But init_hw_perf_events() is:

   early_initcall(init_hw_perf_events);

So we end up calling init_hw_perf_events() before we call cpu_type_probe(),
and sparc_pmu_type is not set.

This was introduced by: 
"perf, arch: Cleanup perf-pmu init vs lockup-detector" - 004417a6d468e24399e383645c068b498eed84ad

I did not see any obvious fix.
(To avoid it is simple - I can disable it in my config).

	Sam

