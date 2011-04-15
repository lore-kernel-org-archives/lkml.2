Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1DOUrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:47:52 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25070 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753948Ab1DOUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CpgCoe4VM1lYIM_3OSlqCb2Pt2_WV17Tpd4Ctv8mnad.7lh
 gTM.XFvFMFde0GT87mNQwk2OuetyJDafGcwiGCRAhi.Dk.4eingsUxQ3ETU.
 8xWeeKkxC9VIA_QefE8T42LQ3t5qCIhHZbVqWiFPrJrd65.SZAZY5nzAlUP7
 5fJXilco2FmLuwjiN8XtLRj9RtRracic4iEuLB8qKnZ2Nyz4Mq3EB6TS9YJO
 1iEhIHWgjLUlvQ1cdLbtrQXGWDcwVGcsEPEoGkyPjxvRY4sUliu3pkOb4Nea
 EXY7somobtYoy3ugGPgV.W4nQ.H6DQkpX.l2frRgZe8Gt3phovGX5P_23H1u
 qbbZg0IFPUgtqP5UI
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204747.236923828@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:32 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 02/21] slub: get_map() function to establish map of free objects in a slab
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=slub_slowpath_get_map
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit map of free objects in a slab page is determined in various functions
if debugging is enabled.

Provide a common function for that purpose.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-03-30 14:09:27.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-03-30 14:30:24.000000000 -0500
@@ -271,10 +271,6 @@ static inline void set_freepointer(struc
 	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
 			__p += (__s)->size)
 
-/* Scan freelist */
-#define for_each_free_object(__p, __s, __free) \
-	for (__p = (__free); __p; __p = get_freepointer((__s), __p))
-
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
 {
@@ -330,6 +326,21 @@ static inline int oo_objects(struct kmem
 	return x.x & OO_MASK;
 }
 
+/*
+ * Determine a map of object in use on a page.
+ *
+ * Slab lock or node listlock must be held to guarantee that the page does
+ * not vanish from under us.
+ */
+static void get_map(struct kmem_cache *s, struct page *page, unsigned long *map)
+{
+	void *p;
+	void *addr = page_address(page);
+
+	for (p = page->freelist; p; p = get_freepointer(s, p))
+		set_bit(slab_index(p, s, addr), map);
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 /*
  * Debug settings:
@@ -2673,9 +2684,8 @@ static void list_slab_objects(struct kme
 		return;
 	slab_err(s, page, "%s", text);
 	slab_lock(page);
-	for_each_free_object(p, s, page->freelist)
-		set_bit(slab_index(p, s, addr), map);
 
+	get_map(s, page, map);
 	for_each_object(p, s, addr, page->objects) {
 
 		if (!test_bit(slab_index(p, s, addr), map)) {
@@ -3610,10 +3620,11 @@ static int validate_slab(struct kmem_cac
 	/* Now we know that a valid freelist exists */
 	bitmap_zero(map, page->objects);
 
-	for_each_free_object(p, s, page->freelist) {
-		set_bit(slab_index(p, s, addr), map);
-		if (!check_object(s, page, p, SLUB_RED_INACTIVE))
-			return 0;
+	get_map(s, page, map);
+	for_each_object(p, s, addr, page->objects) {
+		if (test_bit(slab_index(p, s, addr), map))
+			if (!check_object(s, page, p, SLUB_RED_INACTIVE))
+				return 0;
 	}
 
 	for_each_object(p, s, addr, page->objects)
@@ -3821,8 +3832,7 @@ static void process_slab(struct loc_trac
 	void *p;
 
 	bitmap_zero(map, page->objects);
-	for_each_free_object(p, s, page->freelist)
-		set_bit(slab_index(p, s, addr), map);
+	get_map(s, page, map);
 
 	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))

