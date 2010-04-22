Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab0DVUBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:01:48 -0400
Received: from kroah.org ([198.145.64.141]:59892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0DVUBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:10 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195414.570705258@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>,
       maximilian attems <max@stro.at>
Subject: [093/139] ocfs2: Change bg_chain check for ocfs2_validate_gd_parent.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <tao.ma@oracle.com>

commit 78c37eb0d5e6a9727b12ea0f1821795ffaa66cfe upstream.

In ocfs2_validate_gd_parent, we check bg_chain against the
cl_next_free_rec of the dinode. Actually in resize, we have
the chance of bg_chain == cl_next_free_rec. So add some
additional condition check for it.

I also rename paramter "clean_error" to "resize", since the
old one is not clearly enough to indicate that we should only
meet with this case in resize.

btw, the correpsonding bug is
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1230.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/suballoc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -152,7 +152,7 @@ static u32 ocfs2_bits_per_group(struct o
 
 #define do_error(fmt, ...)						\
 	do{								\
-		if (clean_error)					\
+		if (resize)					\
 			mlog(ML_ERROR, fmt "\n", ##__VA_ARGS__);	\
 		else							\
 			ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
@@ -160,7 +160,7 @@ static u32 ocfs2_bits_per_group(struct o
 
 static int ocfs2_validate_gd_self(struct super_block *sb,
 				  struct buffer_head *bh,
-				  int clean_error)
+				  int resize)
 {
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
@@ -211,7 +211,7 @@ static int ocfs2_validate_gd_self(struct
 static int ocfs2_validate_gd_parent(struct super_block *sb,
 				    struct ocfs2_dinode *di,
 				    struct buffer_head *bh,
-				    int clean_error)
+				    int resize)
 {
 	unsigned int max_bits;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
@@ -233,8 +233,11 @@ static int ocfs2_validate_gd_parent(stru
 		return -EINVAL;
 	}
 
-	if (le16_to_cpu(gd->bg_chain) >=
-	    le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) {
+	/* In resize, we may meet the case bg_chain == cl_next_free_rec. */
+	if ((le16_to_cpu(gd->bg_chain) >
+	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) ||
+	    ((le16_to_cpu(gd->bg_chain) ==
+	     le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) && !resize)) {
 		do_error("Group descriptor #%llu has bad chain %u",
 			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_chain));


