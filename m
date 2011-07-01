Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1GAJRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:17:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:32818 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab1GAJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:17:51 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 01/10] drm_mm: extract check_free_mm_node" has been added to staging queue
Date: Fri,  1 Jul 2011 10:17:42 +0100
Message-Id: <1309511862-2870-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 01/10] drm_mm: extract check_free_mm_node

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From d4a82251610c863bab7f457cb7a76a4bf01abb21 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Fri, 17 Jun 2011 10:04:19 -0500
Subject: [PATCH 01/10] drm_mm: extract check_free_mm_node

BugLink: http://bugs.launchpad.net/bugs/599017

There are already two copies of this logic. And the new scanning
stuff will add some more. So extract it into a small helper
function.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Thomas Hellstrom <thellstrom@vmwgfx.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
(backported from commit 7a6b2896f261894dde287d3faefa4b432cddca53 upstream)

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/drm_mm.c |   69 ++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 2ac074c8..4935e91 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -328,6 +328,27 @@ void drm_mm_put_block(struct drm_mm_node *cur)

 EXPORT_SYMBOL(drm_mm_put_block);

+static int check_free_mm_node(struct drm_mm_node *entry, unsigned long size,
+			      unsigned alignment)
+{
+	unsigned wasted = 0;
+
+	if (entry->size < size)
+		return 0;
+
+	if (alignment) {
+		register unsigned tmp = entry->start % alignment;
+		if (tmp)
+			wasted = alignment - tmp;
+	}
+
+	if (entry->size >= size + wasted) {
+		return 1;
+	}
+
+	return 0;
+}
+
 struct drm_mm_node *drm_mm_search_free(const struct drm_mm *mm,
 				       unsigned long size,
 				       unsigned alignment, int best_match)
@@ -337,31 +358,22 @@ struct drm_mm_node *drm_mm_search_free(const struct drm_mm *mm,
 	struct drm_mm_node *entry;
 	struct drm_mm_node *best;
 	unsigned long best_size;
-	unsigned wasted;

 	best = NULL;
 	best_size = ~0UL;

 	list_for_each(list, free_stack) {
 		entry = list_entry(list, struct drm_mm_node, fl_entry);
-		wasted = 0;

-		if (entry->size < size)
+		if (!check_free_mm_node(entry, size, alignment))
 			continue;

-		if (alignment) {
-			register unsigned tmp = entry->start % alignment;
-			if (tmp)
-				wasted += alignment - tmp;
-		}
+		if (!best_match)
+			return entry;

-		if (entry->size >= size + wasted) {
-			if (!best_match)
-				return entry;
-			if (entry->size < best_size) {
-				best = entry;
-				best_size = entry->size;
-			}
+		if (entry->size < best_size) {
+			best = entry;
+			best_size = entry->size;
 		}
 	}

@@ -381,38 +393,25 @@ struct drm_mm_node *drm_mm_search_free_in_range(const struct drm_mm *mm,
 	struct drm_mm_node *entry;
 	struct drm_mm_node *best;
 	unsigned long best_size;
-	unsigned wasted;

 	best = NULL;
 	best_size = ~0UL;

 	list_for_each(list, free_stack) {
 		entry = list_entry(list, struct drm_mm_node, fl_entry);
-		wasted = 0;
-
-		if (entry->size < size)
-			continue;

 		if (entry->start > end || (entry->start+entry->size) < start)
 			continue;

-		if (entry->start < start)
-			wasted += start - entry->start;
+		if (!check_free_mm_node(entry, size, alignment))
+			continue;

-		if (alignment) {
-			register unsigned tmp = (entry->start + wasted) % alignment;
-			if (tmp)
-				wasted += alignment - tmp;
-		}
+		if (!best_match)
+			return entry;

-		if (entry->size >= size + wasted &&
-		    (entry->start + wasted + size) <= end) {
-			if (!best_match)
-				return entry;
-			if (entry->size < best_size) {
-				best = entry;
-				best_size = entry->size;
-			}
+		if (entry->size < best_size) {
+			best = entry;
+			best_size = entry->size;
 		}
 	}

--
1.7.4.1

