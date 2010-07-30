Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab0G3TAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:00:10 -0400
Received: from kroah.org ([198.145.64.141]:51806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758332Ab0G3RTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.787587220@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [090/165] ext4: Handle -EDQUOT error on write
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 1db913823c0f8360fccbd24ca67eb073966a5ffd upstream (as of v2.6.33-rc6)

We need to release the journal before we do a write_inode.  Otherwise
we could deadlock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1877,24 +1877,12 @@ repeat:
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
-		/*
-		 * We tend to badly over-estimate the amount of
-		 * metadata blocks which are needed, so if we have
-		 * reserved any metadata blocks, try to force out the
-		 * inode and see if we have any better luck.
-		 */
-		if (md_reserved && retries++ <= 3)
-			goto retry;
+	if (vfs_dq_reserve_block(inode, md_needed + 1))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
 		vfs_dq_release_reservation_block(inode, md_needed + 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		retry:
-			if (md_reserved)
-				write_inode_now(inode, (retries == 3));
 			yield();
 			goto repeat;
 		}
@@ -3075,7 +3063,7 @@ static int ext4_da_write_begin(struct fi
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, retries = 0, quota_retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3134,6 +3122,22 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	if ((ret == -EDQUOT) &&
+	    EXT4_I(inode)->i_reserved_meta_blocks &&
+	    (quota_retries++ < 3)) {
+		/*
+		 * Since we often over-estimate the number of meta
+		 * data blocks required, we may sometimes get a
+		 * spurios out of quota error even though there would
+		 * be enough space once we write the data blocks and
+		 * find out how many meta data blocks were _really_
+		 * required.  So try forcing the inode write to see if
+		 * that helps.
+		 */
+		write_inode_now(inode, (quota_retries == 3));
+		goto retry;
+	}
 out:
 	return ret;
 }


