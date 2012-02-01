Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2BAWTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:19:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37818 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2BAWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:19:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: [PATCH] sysfs:  Optionally count subdirectories to support buggy applications
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
	<20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
	<4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	<m1wr87ywex.fsf@fess.ebiederm.org>
Date: Wed, 01 Feb 2012 14:21:59 -0800
In-Reply-To: <m1wr87ywex.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 31 Jan 2012 21:06:46 -0800")
Message-ID: <m1ehueyz20.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ZdXbjkoMtDKWsAR7A9QMG9pABJJsbvqI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lm_sensors and possibly other applications get confused if all sysfs
directories return nlink == 1.  The lm_sensors code that got confused
was just wrong and a fixed version of lm_sensors should be released
shortly.

There may be other applications that have problems with sysfs return
nlink == 1 for directories.  To allow people to continue to use old
versions of userspace with new kernels add to sysfs a compile time
option to maintain mostly precise directory counts for those people who
don't mind the cost.

I have moved where we keep nlink in sysfs_dirent as compared to previous
versions of subdirectory counting to a location that packs better.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/Kconfig |   15 +++++++++++++++
 fs/sysfs/dir.c   |    8 ++++++++
 fs/sysfs/inode.c |    2 ++
 fs/sysfs/sysfs.h |   38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
index 8c41fea..9b403e9 100644
--- a/fs/sysfs/Kconfig
+++ b/fs/sysfs/Kconfig
@@ -21,3 +21,18 @@ config SYSFS
 	example, "root=03:01" for /dev/hda1.
 
 	Designers of embedded systems may wish to say N here to conserve space.
+
+config SYSFS_COUNT_LINKS
+	bool "sysfs count subdirectoires to support buggy applications"
+	default n
+	help
+
+	Increase the memory and cpu untilization of sysfs by maintaining
+	by maintaining a count of how hard links from subdirectories a
+	directory has.  This allows sysfs to report the directory nlink
+	as the number of subdirectories plus two.  With out this enabled
+	sysfs will report the nlink of all directories as 1, which is
+	the standard way of indicating that the number of subdirectoires
+	is not tracked.
+
+	Unless you know you need this say N here.
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index dd3779c..f30df7c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -91,6 +91,9 @@ static int sysfs_link_sibling(struct sysfs_dirent *sd)
 	struct rb_node **node = &sd->s_parent->s_dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
+	if (sysfs_type(sd) == SYSFS_DIR)
+		sysfs_inc_nlink(sd->s_parent);
+
 	while (*node) {
 		struct sysfs_dirent *pos;
 		int result;
@@ -123,6 +126,9 @@ static int sysfs_link_sibling(struct sysfs_dirent *sd)
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
+	if (sysfs_type(sd) == SYSFS_DIR)
+		sysfs_dec_nlink(sd->s_parent);
+
 	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
 }
 
@@ -367,6 +373,8 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	sd->s_mode = mode;
 	sd->s_flags = type;
 
+	sysfs_init_nlink(sd);
+
 	return sd;
 
  err_out2:
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4291fd1..782c66a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -216,6 +216,8 @@ static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 					    iattrs->ia_secdata,
 					    iattrs->ia_secdata_len);
 	}
+
+	set_nlink(inode, sysfs_read_nlink(sd));
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6289a00..4603506 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -69,6 +69,9 @@ struct sysfs_dirent {
 
 	const void		*s_ns; /* namespace tag */
 	unsigned int		s_hash; /* ns + name hash */
+#ifdef CONFIG_SYSFS_COUNT_LINKS
+	unsigned int		s_nlink;
+#endif
 	union {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
@@ -127,6 +130,41 @@ do {								\
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
 #endif
 
+#ifdef CONFIG_SYSFS_COUNT_LINKS
+static inline void sysfs_init_nlink(struct sysfs_dirent *sd)
+{
+	if (sysfs_type(sd) == SYSFS_DIR)
+		sd->s_nlink = 2;
+	else
+		sd->s_nlink = 1;
+}
+static inline void sysfs_inc_nlink(struct sysfs_dirent *sd)
+{
+	sd->s_nlink++;
+}
+static inline void sysfs_dec_nlink(struct sysfs_dirent *sd)
+{
+	sd->s_nlink++;
+}
+static inline unsigned int sysfs_read_nlink(struct sysfs_dirent *sd)
+{
+	return sd->s_nlink;
+}
+#else
+static inline void sysfs_init_nlink(struct sysfs_dirent *sd)
+{
+}
+static inline void sysfs_inc_nlink(struct sysfs_dirent *sd)
+{
+}
+static inline void sysfs_dec_nlink(struct sysfs_dirent *sd)
+{
+}
+static inline unsigned int sysfs_read_nlink(struct sysfs_dirent *sd)
+{
+	return 1;
+}
+#endif
 /*
  * Context structure to be used while adding/removing nodes.
  */
-- 
1.7.2.5

