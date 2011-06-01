Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1FAR0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:26:23 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47122 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758490Ab1FAR0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: n8itWdIVM1kVHwGCilvxeggD0QjBDHNgerqAe61wl4ESvOL
 kziL0D.9ok6uDuy4kzRxAGHyAGwVlg4lBDCbbgouHBmGr3mh93WRGQJjc4jx
 Cy3mYvLQfyXgaN3HZIenVHXpZnCWvYryGUSJVg7nytmAekPd5xdBpHHyJ9eu
 MDaCWNESmJgzDaTv5Jvbj9or9JxwPCteUzJeEAaaLnMlcpLudIpLPZ7Drkvq
 pi6oyV3y9smmEPaXc6w9wvyaYctnHGxZMd_IaHKinNx4VTeKEuMg6uMUHnyr
 re12HG_s19ZEuF7RjqwPwZlyQaAT_d72xy2iG.vBfJ6VoSzrM4gwZBBRR5JJ
 15hGZ3jKTZY8ymjK60hNEi4nu
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172618.122270344@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:54 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 11/17] slub: Disable interrupts in free_debug processing
References: <20110601172543.437240675@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-05-31 10:20:05.472975031 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 10:20:09.792975006 -0500
@@ -1040,6 +1040,10 @@ bad:
 static noinline int free_debug_processing(struct kmem_cache *s,
 		 struct page *page, void *object, unsigned long addr)
 {
+	unsigned long flags;
+	int rc = 0;
+
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (!check_slab(s, page))
@@ -1056,7 +1060,7 @@ static noinline int free_debug_processin
 	}
 
 	if (!check_object(s, page, object, SLUB_RED_ACTIVE))
-		return 0;
+		goto out;
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page)) {
@@ -1077,13 +1081,15 @@ static noinline int free_debug_processin
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

