Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0KXEhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:37:42 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:20436 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752187Ab0KXEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:37:41 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GU.dFb0VM1n4G_Ep2ke4Hkd4UcqYjRu1Bw6nC_Bg4FzA6C7
 Dc.NUumTg.paBouKFlm9rrEfEh4DbHstson.USHp_QV3OPJ__Ae031cIIHDm
 xFp5Y2f9.LVCWWIVo0zyMC9k0HJKN89GZYInX397qMITve5HUNOddFDPdtpl
 PEJcM3BhZYX91JrRvVl2ZvMRiQgptOqdb2rSGSNgrSCBhCx0wvbq1HPw0Xhx
 ZYMPmguFwwpATAZGuNyidTVb578p0BJ2rEhvRQqyTKscpwcO4kOLroqQGgli
 g7wUv6O8o882gV.Cf.g_o
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 23 Nov 2010 22:37:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <alpine.DEB.2.00.1011232111350.7446@router.home>
Message-ID: <alpine.DEB.2.00.1011232236500.12034@router.home>
References: <20101123235139.908255844@linux.com>  <20101123235201.758191189@linux.com> <1290558144.2866.122.camel@edumazet-laptop> <alpine.DEB.2.00.1011232111350.7446@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power of two increment in all cases.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-11-23 22:22:03.596998064 -0600
+++ linux-2.6/mm/slub.c	2010-11-23 21:53:09.422591631 -0600
@@ -1490,19 +1490,21 @@
  * during cmpxchg. The transactions start with the cpu number and are then
  * incremented by CONFIG_NR_CPUS.
  */
+#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
+
 static inline unsigned long next_tid(unsigned long tid)
 {
-	return tid + CONFIG_NR_CPUS;
+	return tid + TID_STEP;
 }

 static inline unsigned int tid_to_cpu(unsigned long tid)
 {
-	return tid % CONFIG_NR_CPUS;
+	return tid % TID_STEP;
 }

 static inline unsigned long tid_to_event(unsigned long tid)
 {
-	return tid / CONFIG_NR_CPUS;
+	return tid / TID_STEP;
 }

 static inline unsigned int init_tid(int cpu)

