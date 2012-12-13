Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2LMOFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2LMOFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 073/241] UBIFS: fix mounting problems after power cuts
Date: Thu, 13 Dec 2012 11:57:18 -0200
Message-Id: <1355407206-17100-74-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit a28ad42a4a0c6f302f488f26488b8b37c9b30024 upstream.

This is a bugfix for a problem with the following symptoms:

1. A power cut happens
2. After reboot, we try to mount UBIFS
3. Mount fails with "No space left on device" error message

UBIFS complains like this:

UBIFS error (pid 28225): grab_empty_leb: could not find an empty LEB

The root cause of this problem is that when we mount, not all LEBs are
categorized. Only those which were read are. However, the
'ubifs_find_free_leb_for_idx()' function assumes that all LEBs were
categorized and 'c->freeable_cnt' is valid, which is a false assumption.

This patch fixes the problem by teaching 'ubifs_find_free_leb_for_idx()'
to always fall back to LPT scanning if no freeable LEBs were found.

This problem was reported by few people in the past, but Brent Taylor
was able to reproduce it and send me a flash image which cannot be mounted,
which made it easy to hunt the bug. Kudos to Brent.

Reported-by: Brent Taylor <motobud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ubifs/find.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/find.c b/fs/ubifs/find.c
index 28ec13a..2dcf3d4 100644
--- a/fs/ubifs/find.c
+++ b/fs/ubifs/find.c
@@ -681,8 +681,16 @@ int ubifs_find_free_leb_for_idx(struct ubifs_info *c)
 	if (!lprops) {
 		lprops = ubifs_fast_find_freeable(c);
 		if (!lprops) {
-			ubifs_assert(c->freeable_cnt == 0);
-			if (c->lst.empty_lebs - c->lst.taken_empty_lebs > 0) {
+			/*
+			 * The first condition means the following: go scan the
+			 * LPT if there are uncategorized lprops, which means
+			 * there may be freeable LEBs there (UBIFS does not
+			 * store the information about freeable LEBs in the
+			 * master node).
+			 */
+			if (c->in_a_category_cnt != c->main_lebs ||
+			    c->lst.empty_lebs - c->lst.taken_empty_lebs > 0) {
+				ubifs_assert(c->freeable_cnt == 0);
 				lprops = scan_for_leb_for_idx(c);
 				if (IS_ERR(lprops)) {
 					err = PTR_ERR(lprops);
-- 
1.7.9.5

