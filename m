Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2FGEUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab2FGEUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:03 -0400
Message-Id: <20120607040344.937607770@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 59/82] ext4: fix potential NULL dereference in ext4_free_inodes_counts()
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bb3d132a24cd8bf5e7773b2d9f9baa58b07a7dae upstream.

The ext4_get_group_desc() function returns NULL on error, and
ext4_free_inodes_count() function dereferences it without checking.
There is a check on the next line, but it's too late.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -488,10 +488,12 @@ fallback_retry:
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, grp, NULL);
-		grp_free = ext4_free_inodes_count(sb, desc);
-		if (desc && grp_free && grp_free >= avefreei) {
-			*group = grp;
-			return 0;
+		if (desc) {
+			grp_free = ext4_free_inodes_count(sb, desc);
+			if (grp_free && grp_free >= avefreei) {
+				*group = grp;
+				return 0;
+			}
 		}
 	}
 


