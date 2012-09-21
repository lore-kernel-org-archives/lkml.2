Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2IUJb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:31:29 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33564 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab2IUJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:31:26 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@infradead.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] fs/inode.c: always take i_lock before calling filesystem's test() method
Date: Fri, 21 Sep 2012 17:31:06 +0800
Message-Id: <1348219866-1799-5-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12092109-2674-0000-0000-000006100246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In insert_inode_locked4(), we call test() without i_lock held, it's
inconsistent with other places that calling test(). Though this
function is only used by reiserfs, in which case i_lock is unnecessary,
we should provide test() a consistent locking context.

This patch calls test() under the protection of i_lock in
insert_inode_locked4().

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 89d2bcc..4c7e6e2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1312,9 +1312,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
-			if (!test(old, data))
-				continue;
 			spin_lock(&old->i_lock);
+			if (!test(old, data)) {
+				spin_unlock(&old->i_lock);
+				continue;
+			}
 			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
 				spin_unlock(&old->i_lock);
 				continue;
-- 
1.7.9.5

