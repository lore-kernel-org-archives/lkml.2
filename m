Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1DAOqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:46:40 -0400
Received: from smtp.nokia.com ([147.243.1.48]:23397 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab1DAOqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:46:38 -0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, vda.linux@googlemail.com, cebbert@redhat.com,
        virtuoso@slind.org, Roman Borisov <ext-roman.borisov@nokia.com>
Subject: [PATCH] fs: bound mount propagation fix
Date: Fri,  1 Apr 2011 18:48:20 +0400
Message-Id: <7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201103262243.18031.vda.linux@googlemail.com>
References: <201103262243.18031.vda.linux@googlemail.com>
X-OriginalArrivalTime: 01 Apr 2011 14:46:24.0133 (UTC) FILETIME=[9298EB50:01CBF07B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think MS_SILENT shouldn't be cleared anywhere. I suppose the bug is in 
MS_SHARED options checking. Please see the patch below.

Fixed MS_SHARED, MS_SLAVE, MS_UNBINDABLE option handling; 
Existing options check doesn't allow to have any options combinations 
because of integer comparison (not bitwise).

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
---
 fs/namespace.c |    2 +-
 fs/pnode.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2beb0fb..e0cf263 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1434,7 +1434,7 @@ static int do_change_type(struct path *path, int flag)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
-	if (type == MS_SHARED) {
+	if (type & MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
 			goto out_unlock;
diff --git a/fs/pnode.c b/fs/pnode.c
index 8d5f392..0c9dc54 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -128,15 +128,15 @@ static int do_make_slave(struct vfsmount *mnt)
 
 void change_mnt_propagation(struct vfsmount *mnt, int type)
 {
-	if (type == MS_SHARED) {
+	if (type & MS_SHARED) {
 		set_mnt_shared(mnt);
 		return;
 	}
 	do_make_slave(mnt);
-	if (type != MS_SLAVE) {
+	if (!(type & MS_SLAVE)) {
 		list_del_init(&mnt->mnt_slave);
 		mnt->mnt_master = NULL;
-		if (type == MS_UNBINDABLE)
+		if (type & MS_UNBINDABLE)
 			mnt->mnt_flags |= MNT_UNBINDABLE;
 		else
 			mnt->mnt_flags &= ~MNT_UNBINDABLE;
-- 
1.7.0.4

