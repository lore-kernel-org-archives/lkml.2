Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0K2RNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:13:16 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:46862 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751233Ab0K2RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:13:15 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lZWlcqEVM1kqMJBkKwVFstPBnUDnLulA3qGovvE8tTHpVwP
 lFC7gCvdSBnVWCwoY8Ukz56d5d5tePvue08c0TvJx_1rCZtlxpnRdSVPt0Qs
 6HYDhXwdk44wgI3XN7f9_WQwqX5vl2f3FujQLkw6ZEphgZfie3yymsaHd4c2
 bdhYZK1uSuB3vJBjxyVkKcCM0fMYpqL2CGkM_IpRa9.zSwHlzbioBPGlD5Om
 r0aenys61tsg-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 11:13:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
In-Reply-To: <alpine.DEB.2.00.1011291013460.3923@router.home>
Message-ID: <alpine.DEB.2.00.1011291111110.4836@router.home>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com> <20101127144949.GC15365@Krystal> <alpine.DEB.2.00.1011291013460.3923@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could do this with local cmpxchgs like in the following patch. This
would avoid preemption disable and interrupt disable (at least on x86).
Trouble is how do we make this fit for architectures that do not have
cmpxchg?


Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-29 10:58:52.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-29 11:11:34.000000000 -0600
@@ -169,18 +169,23 @@ void __mod_zone_page_state(struct zone *
 {
 	struct per_cpu_pageset __percpu *pcp = zone->pageset;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
-	long x;
-	long t;
+	long o, n, t, z;

-	x = delta + __this_cpu_read(*p);
+	do {
+		z = 0;
+		t = this_cpu_read(pcp->stat_threshold);
+		o = this_cpu_read(*p);
+		n = delta + o;
+
+		if (n > t || n < -t) {
+			/* Overflow must be added to zone counters */
+			z = n;
+			n = 0;
+		}
+	} while (o != n && this_cpu_cmpxchg(*p, o, n) != o);

-	t = __this_cpu_read(pcp->stat_threshold);
-
-	if (unlikely(x > t || x < -t)) {
-		zone_page_state_add(x, zone, item);
-		x = 0;
-	}
-	__this_cpu_write(*p, x);
+	if (z)
+		zone_page_state_add(z, zone, item);
 }
 EXPORT_SYMBOL(__mod_zone_page_state);

@@ -190,11 +195,7 @@ EXPORT_SYMBOL(__mod_zone_page_state);
 void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 					int delta)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
 	__mod_zone_page_state(zone, item, delta);
-	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(mod_zone_page_state);


