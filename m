Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161526Ab1FAIXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:23:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:44769 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162716Ab1FAIXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:23:20 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:46 2011
Message-Id: <20110601081145.588366003@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:03 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Lameter <cl@linux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [093/165] slub: Make CONFIG_DEBUG_PAGE_ALLOC work with new fastpath
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1498
Lines: 50

From: Christoph Lameter <cl@linux.com>

commit 1393d9a1857471f816d0be1ccc1d6433a86050f6 upstream.

Fastpath can do a speculative access to a page that CONFIG_DEBUG_PAGE_ALLOC may have
marked as invalid to retrieve the pointer to the next free object.

Use probe_kernel_read in that case in order not to cause a page fault.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -261,6 +261,18 @@ static inline void *get_freepointer(stru
 	return *(void **)(object + s->offset);
 }
 
+static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
+{
+	void *p;
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
+#else
+	p = get_freepointer(s, object);
+#endif
+	return p;
+}
+
 static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 {
 	*(void **)(object + s->offset) = fp;
@@ -1943,7 +1955,7 @@ redo:
 		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				object, tid,
-				get_freepointer(s, object), next_tid(tid)))) {
+				get_freepointer_safe(s, object), next_tid(tid)))) {
 
 			note_cmpxchg_failure("slab_alloc", s, tid);
 			goto redo;


