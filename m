Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1EFSIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:08:31 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:23090 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756539Ab1EFSHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: U9uXk8gVM1nOqjELyzP9MTo.omNaghrT3ATT4WXhsGO29Cl
 7JeH3iJyN.QG1Z.4x4E68Ik67oLUa0RimMSzaY9bYaeLckxZtzZR3KkkWQjk
 Ug11GWRQW946hpYr2.tO6uF6fUGCTHzd48kXTEzD_I9whSZTv0bcl5S267KH
 j7lt0n0jCMKJ9sk3bAIpH9ALVyAHfoJF0NJMprZ0AZ_zPOJv5Alh0SYtmDpp
 lBXVxdgn2otXCv5aiMHTAbZXGzZhTifnXwwfdee0R.UcRbUI.bMC1RpVRzh1
 gnuWU8oSS6yBXejLeOaAtJfDjPVhDS_w_guNz2n4UOqMIQ1_p5GNbsxoxpX1
 xg3Zi.O.XnlE.E1QEkb6jKCJN
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180700.592920891@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:52 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 11/16] slub: Disable interrupts in free_debug processing
References: <20110506180541.990069206@linux.com>
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
 

