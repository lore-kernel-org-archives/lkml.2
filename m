Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0K3TLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:11:45 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:33409 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754291Ab0K3TIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5LwMZ1IVM1ki.bkgUTgQlB4MUeYi_O81m8z.HIKpzvxqyXc
 .aEpN8WYQUJU9niBWyJtLd061Ym07JKk4Vi.BTPJnuLpWpMxHljIDb8vFaVm
 V9A5O4EOA80hc6JkSoLFtBcxivBb9kyvjlAOkG5S4q9MSaEcR7TDDsO.aIb7
 N2xEf3dYgqsrnM0YUxIxWhLpOHseSFDnx.JiqMYzdOkuiuYdgoUlFbnLIR66
 XjLexNukGxPKKJ3xTYQSB6_853rvg0JhKCXhaqTIF2XqAbZPDuk6UKfqaH7D
 6Ei53Qy25mV79cLnotWM9
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190844.623370797@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:13 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 06/18] vmstat: Use this_cpu_inc_return for vm statistics
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_add_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there. Code
size does not change.

V1->V2:
	- Fixed the location of the __per_cpu pointer attributes
	- Sparse checked
V2->V3:
	- Move fixes to __percpu attribute usage to earlier patch

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-29 10:36:16.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-29 10:38:50.000000000 -0600
@@ -227,9 +227,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_inc(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
 		s8 overstep = t >> 1;
@@ -251,9 +249,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_dec(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
 		s8 overstep = t >> 1;

