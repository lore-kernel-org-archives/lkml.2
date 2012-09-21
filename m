Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2IUJbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:31:55 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37550 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab2IUJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:31:53 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@infradead.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] fs/inode.c: do not take i_lock when identify an inode
Date: Fri, 21 Sep 2012 17:31:05 +0800
Message-Id: <1348219866-1799-4-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12092109-3864-0000-0000-000004BA9BE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identity of an inode, which is defined by i_sb and i_ino or by individual
filesystem specific way, is not expected to be changed during inode's life
time. When identify an inode, taking i_lock _seems_ unnecessary. In source
code, we do have functions identifying an inode without i_lock held,
e.g. test_inode_iunique().

Then, fix those functions which take i_lock, e.g. find_inode_fast().

Note this change still put individual filesystem's test() method under
i_lock's protection. See next patch for more.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/inode.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 54e4b29..89d2bcc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -786,11 +786,9 @@ static struct inode *find_inode(struct super_block *sb,
 
 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_sb != sb) {
-			spin_unlock(&inode->i_lock);
+		if (inode->i_sb != sb)
 			continue;
-		}
+		spin_lock(&inode->i_lock);
 		if (!test(inode, data)) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -818,15 +816,11 @@ static struct inode *find_inode_fast(struct super_block *sb,
 
 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_ino != ino) {
-			spin_unlock(&inode->i_lock);
+		if (inode->i_ino != ino)
 			continue;
-		}
-		if (inode->i_sb != sb) {
-			spin_unlock(&inode->i_lock);
+		if (inode->i_sb != sb)
 			continue;
-		}
+		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
 			__wait_on_freeing_inode(inode);
 			goto repeat;
-- 
1.7.9.5

