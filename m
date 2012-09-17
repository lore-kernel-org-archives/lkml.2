Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2IQAvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab2IQAvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:37 -0400
Message-Id: <20120917003630.419920585@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [ 030/135] UBI: fix a horrible memory deallocation bug
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 78b495c39add820ab66ab897af9bd77a5f2e91f6 upstream.

UBI was mistakingly using 'kfree()' instead of 'kmem_cache_free()' when
freeing "attach eraseblock" structures in vtbl.c. Thankfully, this happened
only when we were doing auto-format, so many systems were unaffected. However,
there are still many users affected.

It is strange, but the system did not crash and nothing bad happened when
the SLUB memory allocator was used. However, in case of SLOB we observed an
crash right away.

This problem was introduced in 2.6.39 by commit
"6c1e875 UBI: add slab cache for ubi_scan_leb objects"

A note for stable trees:
  Because variable were renamed, this won't cleanly apply to older kernels.
  Changing names like this should help:
	1. ai -> si
	2. aeb_slab_cache -> seb_slab_cache
	3. new_aeb -> new_seb

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Tested-by: Richard Genoud <richard.genoud@gmail.com>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
[bwh: Backported to 3.2: aeb_slab_cache was actually named scan_leb_slab]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/ubi/vtbl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -346,7 +346,7 @@ retry:
 	 */
 	err = ubi_scan_add_used(ubi, si, new_seb->pnum, new_seb->ec,
 				vid_hdr, 0);
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
 
@@ -359,7 +359,7 @@ write_error:
 		list_add(&new_seb->u.list, &si->erase);
 		goto retry;
 	}
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;


