Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966591Ab0GSTNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:13:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53073 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966556Ab0GSTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:13:19 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V17 10/12] vfs: Export file system uuid via /proc/<pid>mountinfo
Date: Tue, 20 Jul 2010 00:42:05 +0530
Message-Id: <1279566727-16598-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc3.43.g24e7a
In-Reply-To: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add a per superblock uuid field. File systems should
update the uuid in the fill_super callback

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namespace.c     |   16 ++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 88058de..b43b33c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -833,6 +833,18 @@ const struct seq_operations mounts_op = {
 	.show	= show_vfsmnt
 };
 
+static int uuid_is_nil(u8 *uuid)
+{
+	int i;
+	u8  *cp = (u8 *)uuid;
+
+	for (i = 0; i < 16; i++) {
+		if (*cp++)
+			return 0;
+	}
+	return 1;
+}
+
 static int show_mountinfo(struct seq_file *m, void *v)
 {
 	struct proc_mounts *p = m->private;
@@ -871,6 +883,10 @@ static int show_mountinfo(struct seq_file *m, void *v)
 	if (IS_MNT_UNBINDABLE(mnt))
 		seq_puts(m, " unbindable");
 
+	if (!uuid_is_nil(mnt->mnt_sb->s_uuid))
+		/* print the uuid */
+		seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
+
 	/* Filesystem specific data */
 	seq_puts(m, " - ");
 	show_type(m, sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b791159..8c064d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1366,6 +1366,7 @@ struct super_block {
 	wait_queue_head_t	s_wait_unfrozen;
 
 	char s_id[32];				/* Informational name */
+	u8 s_uuid[16];				/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
-- 
1.7.2.rc3.43.g24e7a

