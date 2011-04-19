Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1DSI6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:58:22 -0400
Received: from smtp.nokia.com ([147.243.1.47]:52656 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DSI6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:58:18 -0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roman Borisov <ext-roman.borisov@nokia.com>
Subject: [PATCH] [resend] fs: bound mount propagation fix
Date: Tue, 19 Apr 2011 13:00:03 +0400
Message-Id: <2e2f4623b6f52e52c8a7737649caa615b666358c.1303202237.git.ext-roman.borisov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 19 Apr 2011 08:58:16.0136 (UTC) FILETIME=[EBD10480:01CBFE6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed MS_SHARED, MS_SLAVE, MS_UNBINDABLE option handling; Existing options check
doesn't allow to have any options combinations because of integer comparison 
(not bitwise).

The issue was reported in "2.6.35-rc4: mount results with and without MS_SILENT differ"
thread where it has been discovered that MS_SILENT bit affects the mount behavior.

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
---
 fs/namespace.c |    2 +-
 fs/pnode.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7dba2ed..99fa501 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1743,7 +1743,7 @@ static int do_change_type(struct path *path, int flag)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
-	if (type == MS_SHARED) {
+	if (type & MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
 			goto out_unlock;
diff --git a/fs/pnode.c b/fs/pnode.c
index d42514e..e1b676b 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -131,15 +131,15 @@ static int do_make_slave(struct vfsmount *mnt)
  */
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

