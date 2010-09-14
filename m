Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0INOIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:08:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0INOIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:08:22 -0400
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
In-Reply-To: <4C8F4A3E.5070603@orcon.net.nz>
References: <new-submission>
	 <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>
	 <4C8B3AD3.5050309@orcon.net.nz> <1284198035.2251.29.camel@laptop>
	 <4C8C6611.20206@orcon.net.nz>  <1284380153.2275.261.camel@laptop>
	 <1284383927.2275.284.camel@laptop>  <4C8F4A3E.5070603@orcon.net.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Sep 2010 16:07:53 +0200
Message-ID: <1284473273.2275.514.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 22:11 +1200, Michael Cree wrote:
> 
> [  818.575752] Unable to handle kernel paging request at virtual address 
> 0000000000000060
> [  818.575752] perf(4935): Oops 0
> [  818.575752] pc = [<fffffc000036b8b8>]  ra = [<fffffc000036ba3c>]  ps 
> = 0000    Not tainted
> [  818.575752] pc is at put_ctx+0x18/0xb0
> [  818.575752] ra is at free_event+0xec/0x220
> [  818.575752] v0 = 0000000000000000  t0 = 0000000000000000  t1 = 
> 0000000000000002
> [  818.575752] t2 = 0000000000000000  t3 = 0000000000000000  t4 = 
> fffffc000063e4b0
> [  818.575752] t5 = fffffc0034837000  t6 = fffffc0034837000  t7 = 
> fffffc003abe0000
> [  818.575752] s0 = 0000000000000000  s1 = 0000000000000000  s2 = 
> 0000000000000000
> [  818.575752] s3 = ffffffffffffffff  s4 = 0000000000000000  s5 = 
> 0000000000000053
> [  818.575752] s6 = fffffc0034836c00
> [  818.575752] a0 = 0000000000000000  a1 = fffffc00311a6980  a2 = 
> 0000000000000000
> [  818.575752] a3 = 0000000000000001  a4 = fffffc0000797110  a5 = 
> 00000001200055f8
> [  818.575752] t8 = 0000000000000001  t9 = 00000001200396f4  t10= 
> 0000000000000000
> [  818.575752] t11= 000000000000000a  pv = fffffc000031d650  at = 
> fffffc000036f8bc
> [  818.575752] gp = fffffc00007d6e40  sp = fffffc003abe3e18
> [  818.575752] Disabling lock debugging due to kernel taint
> [  818.575752] Trace:
> [  818.575752] [<fffffc000036ba3c>] free_event+0xec/0x220
> [  818.575752] [<fffffc000036fa24>] SyS_perf_event_open+0x2a4/0x6f0
> [  818.575752] [<fffffc0000310c24>] entSys+0xa4/0xc0
> [  818.575752]
> [  818.575752] Code: 27bb0047  23bdb5a0  23defff0  b53e0008  b75e0000 
> 47f00409 <a8500060> 40403121 

Does the below cure that?

---
commit 0c67b40872326a5340cab51d79a192a5fbaeb484
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Sep 13 11:15:58 2010 +0200

    perf: Fix free_event()
    
    With the context rework stuff we can actually end up freeing an event
    before it gets attached to a context.
    
    Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bc46bff..440f9ca 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2150,7 +2150,9 @@ static void free_event(struct perf_event *event)
 	if (event->destroy)
 		event->destroy(event);
 
-	put_ctx(event->ctx);
+	if (event->ctx)
+		put_ctx(event->ctx);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 

