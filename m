Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab0HLAhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:37:37 -0400
Received: from kroah.org ([198.145.64.141]:43359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002Ab0HKX60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:26 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235500.394609171@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [053/111] Btrfs: Fix btrfs_drop_extent_cache for skip pinned case
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 55ef68990029fcd8d04d42fc184aa7fb18cf309e upstream.

The check for skip pinned case is wrong, it may breaks the
while loop too soon.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/file.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -179,18 +179,14 @@ int btrfs_drop_extent_cache(struct inode
 		}
 		flags = em->flags;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
-			if (em->start <= start &&
-			    (!testend || em->start + em->len >= start + len)) {
+			if (testend && em->start + em->len >= start + len) {
 				free_extent_map(em);
 				write_unlock(&em_tree->lock);
 				break;
 			}
-			if (start < em->start) {
-				len = em->start - start;
-			} else {
+			start = em->start + em->len;
+			if (testend)
 				len = start + len - (em->start + em->len);
-				start = em->start + em->len;
-			}
 			free_extent_map(em);
 			write_unlock(&em_tree->lock);
 			continue;


