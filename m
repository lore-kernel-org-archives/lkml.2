Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab1EZSQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:16:50 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47984 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757665Ab1EZSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LNYR0pMVM1l2YyzWHacfsWBu7c1v.DtMzAOhOVIt9KwvC3r
 2UeXgh_n8ImfI2J7QGCJEfLmUbvydv05xzTusbi_VVKzgW9Or3US8ycPBegQ
 oP6amuQmuGhA0jkwnDOIKwHJ8lbqua2WKuWCpbXkFyuCyv.F28fkofrLDiPV
 5Nl24x7T44chJeLzOILO7w1OV8SZZBs8W1RiKSFYCj3dx2F1Hk.70hK_lCcw
 XljnQkeEg8_4JmlKfC.FpFTRrStXsBu1cS6jkUk0kV4bwF7N1c6dgX6_AP0I
 Ajjtb0uF9l7iIs5JLbIfVEyoaZw_mSD.aPLvRhl88CA7zh8gymqqv_Rfg4S5
 zu61I_SbKYXNR_NsU0dLDb5e2
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181507.730428591@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:53 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 11/17] slub: Disable interrupts in free_debug processing
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=irqoff_in_free_debug_processing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will be calling free_debug_processing with interrupts disabled
in some case when the later patches are applied. Some of the
functions called by free_debug_processing expect interrupts to be
off.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:40:54.274875052 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:40:57.434875035 -0500
@@ -1035,6 +1035,10 @@ bad:
 static noinline int free_debug_processing(struct kmem_cache *s,
 		 struct page *page, void *object, unsigned long addr)
 {
+	unsigned long flags;
+	int rc = 0;
+
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (!check_slab(s, page))
@@ -1051,7 +1055,7 @@ static noinline int free_debug_processin
 	}
 
 	if (!check_object(s, page, object, SLUB_RED_ACTIVE))
-		return 0;
+		goto out;
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page)) {
@@ -1072,13 +1076,15 @@ static noinline int free_debug_processin
 		set_track(s, object, TRACK_FREE, addr);
 	trace(s, page, object, 0);
 	init_object(s, object, SLUB_RED_INACTIVE);
+	rc = 1;
+out:
 	slab_unlock(page);
-	return 1;
+	local_irq_restore(flags);
+	return rc;
 
 fail:
 	slab_fix(s, "Object at 0x%p not freed", object);
-	slab_unlock(page);
-	return 0;
+	goto out;
 }
 
 static int __init setup_slub_debug(char *str)

