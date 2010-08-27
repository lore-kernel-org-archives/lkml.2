Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0H0LEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:04:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57355 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0H0LEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:04:44 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V19 13/15] vfs: Export file system uuid via /proc/<pid>/mountinfo
Date: Fri, 27 Aug 2010 16:33:00 +0530
Message-Id: <1282906982-26918-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 2e10cb1..041645a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -837,6 +837,18 @@ const struct seq_operations mounts_op = {
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
@@ -875,6 +887,10 @@ static int show_mountinfo(struct seq_file *m, void *v)
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
index 8dde859..0f348f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1369,6 +1369,7 @@ struct super_block {
 	wait_queue_head_t	s_wait_unfrozen;
 
 	char s_id[32];				/* Informational name */
+	u8 s_uuid[16];				/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
-- 
1.7.0.4

