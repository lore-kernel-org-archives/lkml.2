Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab0J2J7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:59:10 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33879 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab0J2J7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:59:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 12/14] vfs: Export file system uuid via /proc/<pid>/mountinfo
Date: Fri, 29 Oct 2010 15:27:21 +0530
Message-Id: <1288346243-12211-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 8a415c9..9388a82 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -871,6 +871,18 @@ const struct seq_operations mounts_op = {
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
@@ -909,6 +921,10 @@ static int show_mountinfo(struct seq_file *m, void *v)
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
index 2ab3062..3143ba9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1398,6 +1398,7 @@ struct super_block {
 	wait_queue_head_t	s_wait_unfrozen;
 
 	char s_id[32];				/* Informational name */
+	u8 s_uuid[16];				/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
-- 
1.7.1

