Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2BGD4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:56:16 -0500
Received: from ozlabs.org ([203.10.76.45]:51632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2BGD4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:56:15 -0500
Date: Tue, 7 Feb 2012 14:55:35 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
Message-ID: <20120207145535.71b9f22d@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A perf annotate of a kernel function written in assembly shows
very strange percentages:

         :      _GLOBAL(__copy_tofrom_user_base)

...

         :              addi    r3,r3,1
   99.67 :      c00000000004d78c:       addi    r3,r3,1
         :
    0.00 :      1:      bf      cr7*4+2,2f
    0.07 :      c00000000004d790:       bne-    cr7,c00000000004d7a4
         :      err1;   lhz     r0,0(r4)
    0.00 :      c00000000004d794:       lhz     r0,0(r4)
         :              addi    r4,r4,2
    0.00 :      c00000000004d798:       addi    r4,r4,2
         :      err1;   sth     r0,0(r3)
    0.00 :      c00000000004d79c:       sth     r0,0(r3)
         :              addi    r3,r3,2
   99.60 :      c00000000004d7a0:       addi    r3,r3,2
         :
    0.00 :      2:      bf      cr7*4+1,3f
    0.12 :      c00000000004d7a4:       ble-    cr7,c00000000004d7b8
         :      err1;   lwz     r0,0(r4)
    0.00 :      c00000000004d7a8:       lwz     r0,0(r4)
         :              addi    r4,r4,4
    0.00 :      c00000000004d7ac:       addi    r4,r4,4
         :      err1;   stw     r0,0(r3)
    0.00 :      c00000000004d7b0:       stw     r0,0(r3)
         :              addi    r3,r3,4
   99.48 :      c00000000004d7b4:       addi    r3,r3,4

~300% in one function. Urgh.

This is caused by the way we parse objdump -S output, eg:

        addi    r3,r3,1
c00000000004d78c:       addi    r3,r3,1

1:      bf      cr7*4+2,2f
c00000000004d790:       bne-    cr7,c00000000004d7a4 

We assume the asm label (1:) is an address, compute a bogus offset
into the function and then screw up the matching of samples to lines.
I notice this also fails with c inline assembly in a similar
manner.

We already have a sanity check that the address is not beyond the end
of the function, so add a check against the start too.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
Cc: <stable@kernel.org>

Index: linux-tip/tools/perf/util/annotate.c
===================================================================
--- linux-tip.orig/tools/perf/util/annotate.c	2012-01-09 17:45:09.056373433 +1100
+++ linux-tip/tools/perf/util/annotate.c	2012-02-07 13:53:01.610970209 +1100
@@ -244,7 +244,7 @@ static int symbol__parse_objdump_line(st
 		    end = map__rip_2objdump(map, sym->end);
 
 		offset = line_ip - start;
-		if (offset < 0 || (u64)line_ip > end)
+		if (offset < 0 || (u64)line_ip < start || (u64)line_ip > end)
 			offset = -1;
 	}
 
