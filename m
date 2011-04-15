Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1DOUsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:48:05 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:26744 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756794Ab1DOUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: IgOllA0VM1mwARcPtEl8Tg7VkCvlen_HKLveeFwCNjK0T96
 EYIcCHPZ74QnRTvSq5u1UzqE3vE8io0ScYIdJKer86YWy8KpWGjRqHFthMd0
 R46GSd8GoCfwlozvgIYPtrWfN_DM0uCE1KSBkfR1y4vWCp9Q894yA7LsYoxW
 xw.rVqzXKlMBeNQ6DhqFYDW8kfXvTNdSqxirxbkpHqnHtTljW7g.HSS4AUqO
 FRwxQ23813f_gactZHU9Zf2Z1H5z1oeslGrni7Dr8FkFeBCX60ebA0a.wITQ
 mpFpyjfD16mSaKBDkE4zq3PFWwZLEQRkCayXGqAc.J2mAS6hFpMK03shQTzd
 0sSDbVdgaRvwmlTZo
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204755.344489667@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:46 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 16/21] slub: Disable interrupts in free_debug processing
References: <20110415204730.326790555@linux.com>
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
 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 13:15:04.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 13:15:06.000000000 -0500
@@ -1023,6 +1023,10 @@ bad:
 static noinline int free_debug_processing(struct kmem_cache *s,
 		 struct page *page, void *object, unsigned long addr)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
+
 	slab_lock(page);
 
 	if (!check_slab(s, page))
@@ -1061,11 +1065,13 @@ static noinline int free_debug_processin
 	trace(s, page, object, 0);
 	init_object(s, object, SLUB_RED_INACTIVE);
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return 1;
 
 fail:
 	slab_fix(s, "Object at 0x%p not freed", object);
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return 0;
 }
 

