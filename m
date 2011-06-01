Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab1FAR1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:27:51 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:42829 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759018Ab1FAR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UCoehNMVM1nHrBczaOzgb71V1UC2_ZBBdiNyrRT.sqbS7lA
 _ITQ9MEb7zPopOnPmDmL.vmMGyZSvQHOYOvhNWf4LIBFtB.uD.qAAwmtxXOF
 a9SN5YsMRmeg3rWv.uaz7gCt4c_wMSMV1cwpK9QRYE0CB4Nnkjdn1LQkEV9n
 c8f8UPg3wZuMf4lcGerfA7k9AaXMymYqSd2DPzP69DBRpR9Tl3.uBiJUjAf6
 1G9z5V3fbb_liFIfWg1EBSbSiPPZ5grp7wKkuvNDXSnKFuR5fMKwCU7XrT0M
 dFPORzwyV2.jw9C_xEgEHU3g_4XjeC240mQX0XT0Wyj2mm8ki2K1lg.2JepV
 Z6MEVWDjFC4wLLaeIKhZdhvwf
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172619.255924426@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:56 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 13/17] slub: Get rid of the another_slab label
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=eliminate_another_slab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid deactivate slab in special cases if we do the
deactivation of slabs in each code flow that leads to new_slab.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 14:27:11.362880110 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 14:27:12.002880106 -0500
@@ -1965,8 +1965,10 @@ static void *__slab_alloc(struct kmem_ca
 	if (!page)
 		goto new_slab;
 
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
+	if (unlikely(!node_match(c, node))) {
+		deactivate_slab(s, c);
+		goto new_slab;
+	}
 
 	stat(s, ALLOC_SLOWPATH);
 
@@ -1986,7 +1988,7 @@ load_freelist:
 	VM_BUG_ON(!page->frozen);
 
 	if (unlikely(!object))
-		goto another_slab;
+		goto new_slab;
 
 	stat(s, ALLOC_REFILL);
 
@@ -1995,9 +1997,6 @@ load_freelist:
 	local_irq_restore(flags);
 	return object;
 
-another_slab:
-	deactivate_slab(s, c);
-
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {

