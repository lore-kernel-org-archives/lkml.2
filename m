Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2GASZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:25:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977Ab2GASQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:36 -0400
Message-Id: <20120701172007.694144055@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pravin B Shelar <pshelar@nicira.com>,
        Amey Bhide <abhide@nicira.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 07/48] mm: fix slab->page _count corruption when using slub
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

commit abca7c4965845924f65d40e0aa1092bdd895e314 upstream.

On arches that do not support this_cpu_cmpxchg_double() slab_lock is used
to do atomic cmpxchg() on double word which contains page->_count.  The
page count can be changed from get_page() or put_page() without taking
slab_lock.  That corrupts page counter.

Fix it by moving page->_count out of cmpxchg_double data.  So that slub
does no change it while updating slub meta-data in struct page.

[akpm@linux-foundation.org: use standard comment layout, tweak comment text]
Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mm_types.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index dad95bd..704a626 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -57,8 +57,18 @@ struct page {
 		};
 
 		union {
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
+	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
+#else
+			/*
+			 * Keep _count separate from slub cmpxchg_double data.
+			 * As the rest of the double word is protected by
+			 * slab_lock but _count is not.
+			 */
+			unsigned counters;
+#endif
 
 			struct {
 


