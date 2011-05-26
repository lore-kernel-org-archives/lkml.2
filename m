Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1EZSQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:16:37 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32197 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933168Ab1EZSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AysTWSAVM1mo8oXHqouVSBoXIeEtTOGUpwX9CgmH.LntZVf
 jctyYxFEmtIWrMQRmgOu7QvyS6rY1k54mRUW1NiBAZ6zPZul62AWW5Dr5FJY
 jFG8KHnAvt_MRichoU2J.YqLYhhDYgR4HR1oxnoVavRPsbw_9JOFtMdkM7hC
 reutMKyANCchCEcTze6NiipgwvSy6PYYtTZZqc5ZctEad9Ca4f_EAFp9qxf8
 cFs67kqTvzeiFxDx2Li9n395DKI2uSbQLaUxhPdtjFNMUCrLau..C.jJVNpv
 5HiSmAGmlMfma9RdgDMtQLsFmEP_A7LE1uupTsQsW4WW3lGAd
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181508.874627701@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:55 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 13/17] slub: Get rid of the another_slab label
References: <20110526181442.789868308@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:41:00.194875015 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:41:03.744874994 -0500
@@ -1951,8 +1951,10 @@ static void *__slab_alloc(struct kmem_ca
 	if (!page)
 		goto new_slab;
 
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
+	if (unlikely(!node_match(c, node))) {
+		deactivate_slab(s, c);
+		goto new_slab;
+	}
 
 	stat(s, ALLOC_SLOWPATH);
 
@@ -1972,7 +1974,7 @@ load_freelist:
 	VM_BUG_ON(!page->frozen);
 
 	if (unlikely(!object))
-		goto another_slab;
+		goto new_slab;
 
 	stat(s, ALLOC_REFILL);
 
@@ -1981,9 +1983,6 @@ load_freelist:
 	local_irq_restore(flags);
 	return object;
 
-another_slab:
-	deactivate_slab(s, c);
-
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {

