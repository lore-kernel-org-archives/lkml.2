Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2CHVdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:33:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59442 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab2CHVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:33:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <20120130222717.GA6393@kroah.com>
	<m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
	<m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	<m1wr87ywex.fsf@fess.ebiederm.org>
	<m1ehueyz20.fsf_-_@fess.ebiederm.org>
	<CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	<CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	<4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
	<m1r4x2wzdt.fsf_-_@fess.ebiederm.org>
Date: Thu, 08 Mar 2012 13:36:34 -0800
In-Reply-To: <m1r4x2wzdt.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 08 Mar 2012 13:34:22 -0800")
Message-ID: <m1linawza5.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1iq46XYt7UpXaD2vIJSWu5uhKvvN/4MI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: **
Subject: [PATCH 2/3] sysfs: Maintain usable nlink directory counts.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When it is easy keep fully accurate nlink counts for sysfs directories,
when it is not easy set nlink to 1.  This maintains as much compatibility
with unix programs that expect directories to have a usable nlink count
as possible, without trying to do the impossible.

Directory nlink count overflows in sysfs are inevitable by design
so only bother to use a byte to store the directory nlink count.
A directory with 254 entries is larger than any sysfs directory
in a normal configruation but small enough we should see tools that
care about large sysfs directories should experience nlink == 1
during their testing.

This fixes libsensors and possibly other applications that get
confused if all sysfs directories return nlink == 1.  The lm_sensors
code that got confused was just wrong is fixed in the lm_sensors
trunk and a fixed version should be released sometime soon.

The nlink of all deleted directories is set to 0.  Returning for the
first time a correct nlink count for deleted sysfs directories.

Once a directory nlink count drops below 2 refuse to increment or decrement
it as there is not enough information available.  It is important that
this works for nlink == 0 as well as nlink == 1 because currently
sysfs supports deleting non-empty directories (the PCI layer requires this behavior).

For tagged directories set the nlink count == 1 because we currently
have one sysfs_dirent and multiple logical sysfs directories making
pre computing nlink impossible.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |   14 ++++++++++++++
 fs/sysfs/inode.c |    1 +
 fs/sysfs/sysfs.h |   16 ++++++++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index dd3779c..1526567 100644
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
 
@@ -366,6 +372,9 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	sd->s_name = name;
 	sd->s_mode = mode;
 	sd->s_flags = type;
+	sd->s_nlink = 1;
+	if (sysfs_type(sd) == SYSFS_DIR)
+		sd->s_nlink = 2;
 
 	return sd;
 
@@ -536,6 +545,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
 	}
 
+	sd->s_nlink = 0;
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->u.removed_list = acxt->removed;
 	acxt->removed = sd;
@@ -660,6 +670,10 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd->s_ns = ns;
 	sd->s_dir.kobj = kobj;
 
+	/* Accurate nlink count impossible (one field mutiple dirs) */
+	if (sysfs_ns_type(sd))
+		sd->s_nlink = 1;
+
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4291fd1..f6ebda8 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -216,6 +216,7 @@ static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 					    iattrs->ia_secdata,
 					    iattrs->ia_secdata_len);
 	}
+	set_nlink(inode, sd->s_nlink);
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c76c932..71f9bf7 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -76,6 +76,7 @@ struct sysfs_dirent {
 		struct sysfs_elem_bin_attr	s_bin_attr;
 	};
 
+	unsigned char		s_nlink;
 	unsigned char		s_flags;
 	umode_t 		s_mode;
 	unsigned int		s_ino;
@@ -127,6 +128,21 @@ do {								\
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
 #endif
 
+static inline void sysfs_inc_nlink(struct sysfs_dirent *sd)
+{
+	if (sd->s_nlink <= 1)
+		return;
+	sd->s_nlink++;
+	if (sd->s_nlink == 0)
+		sd->s_nlink = 1;
+}
+static inline void sysfs_dec_nlink(struct sysfs_dirent *sd)
+{
+	if (sd->s_nlink <= 1)
+		return;
+	sd->s_nlink--;
+}
+
 /*
  * Context structure to be used while adding/removing nodes.
  */
-- 
1.7.2.5

