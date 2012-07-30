Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2G3RcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:32:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2G3Rb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:31:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>
Subject: [ 13/41] vmscan: shrinker->nr updates race and go wrong
Date: Mon, 30 Jul 2012 10:31:12 -0700
Message-Id: <20120730172902.354851303@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit acf92b485cccf028177f46918e045c0c4e80ee10 upstream.

Stable note: Not tracked in Bugzilla. This patch reduces excessive
	reclaim of slab objects reducing the amount of information
	that has to be brought back in from disk.

shrink_slab() allows shrinkers to be called in parallel so the
struct shrinker can be updated concurrently. It does not provide any
exclusio for such updates, so we can get the shrinker->nr value
increasing or decreasing incorrectly.

As a result, when a shrinker repeatedly returns a value of -1 (e.g.
a VFS shrinker called w/ GFP_NOFS), the shrinker->nr goes haywire,
sometimes updating with the scan count that wasn't used, sometimes
losing it altogether. Worse is when a shrinker does work and that
update is lost due to racy updates, which means the shrinker will do
the work again!

Fix this by making the total_scan calculations independent of
shrinker->nr, and making the shrinker->nr updates atomic w.r.t. to
other updates via cmpxchg loops.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -251,17 +251,29 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long total_scan;
 		unsigned long max_pass;
 		int shrink_ret = 0;
+		long nr;
+		long new_nr;
 
+		/*
+		 * copy the current shrinker scan count into a local variable
+		 * and zero it so that other concurrent shrinker invocations
+		 * don't also do this scanning work.
+		 */
+		do {
+			nr = shrinker->nr;
+		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+
+		total_scan = nr;
 		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
-		shrinker->nr += delta;
-		if (shrinker->nr < 0) {
+		total_scan += delta;
+		if (total_scan < 0) {
 			printk(KERN_ERR "shrink_slab: %pF negative objects to "
 			       "delete nr=%ld\n",
-			       shrinker->shrink, shrinker->nr);
-			shrinker->nr = max_pass;
+			       shrinker->shrink, total_scan);
+			total_scan = max_pass;
 		}
 
 		/*
@@ -269,13 +281,10 @@ unsigned long shrink_slab(struct shrink_
 		 * never try to free more than twice the estimate number of
 		 * freeable entries.
 		 */
-		if (shrinker->nr > max_pass * 2)
-			shrinker->nr = max_pass * 2;
-
-		total_scan = shrinker->nr;
-		shrinker->nr = 0;
+		if (total_scan > max_pass * 2)
+			total_scan = max_pass * 2;
 
-		trace_mm_shrink_slab_start(shrinker, shrink, total_scan,
+		trace_mm_shrink_slab_start(shrinker, shrink, nr,
 					nr_pages_scanned, lru_pages,
 					max_pass, delta, total_scan);
 
@@ -296,9 +305,19 @@ unsigned long shrink_slab(struct shrink_
 			cond_resched();
 		}
 
-		shrinker->nr += total_scan;
-		trace_mm_shrink_slab_end(shrinker, shrink_ret, total_scan,
-					 shrinker->nr);
+		/*
+		 * move the unused scan count back into the shrinker in a
+		 * manner that handles concurrent updates. If we exhausted the
+		 * scan, there is no need to do an update.
+		 */
+		do {
+			nr = shrinker->nr;
+			new_nr = total_scan + nr;
+			if (total_scan <= 0)
+				break;
+		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
+
+		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
 	}
 	up_read(&shrinker_rwsem);
 out:


