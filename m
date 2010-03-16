Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0CPVs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:48:56 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:1206 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab0CPVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:48:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOaZn0vCTtAn/2dsb2JhbACbBXO6boR2BA
Date: Tue, 16 Mar 2010 22:48:50 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH vfat] fix access to IOMEGA USB+network disks
Message-ID: <20100316214849.GA11342@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ogawa,

This is a better fix to accessing vfat entries with trailing dots created
by an external vfat driver (like the one in IOMEGA home network hard drives).
The approach here is to forbid removing those entries and to allow accessing
them and differentiating from their eventual trailing-dots-less counterparts.

Philippe

--

Some vfat-formatted network disks that are also usb disk do not discard
trailing dots when creating files or directories via ftp.
Connecting afterwards this drive via usb to a linux machine leads to many
problems, because getdents reports files where open, stat and the likes
will fail, and one could even access/remove the wrong file if there happens
to be two files in the same directory whose names differ only by the
absence/presence of trailing dots.

Avoid treating such entries the same as their trailing-dots-less counterparts,
and forbid removing/renaming/creating them.

This is done by by first trying to retrieve the entry with the full name,
and only if that fails and there are trailing dots in the searched name,
try then to find the truncated name.  When called with a name with trailing
dots by vfat_rmdir, vfat_rename, and vfat_unlink, pretend we did not find it
and return ENAMETOOLONG.  When called by vfat_lookup, which is not used to
remove the entry, succeed.

getdents users will now be able to open, stat, chdir those files;
rm, rmdir and mv will now explicitly fail;
and opening the file for reading and even truncating and writing will succeed.

some tests results :

phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> ls -l
total 384
-rwxr-xr-x 1 phdm root   910 2010-03-14 17:03 123456789
-rwxr-xr-x 1 phdm root   658 2010-03-15 22:54 123456789.
drwxr-xr-x 2 phdm root 32768 2010-03-15 21:02 Claude_Francois-Hommage...
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> rm 123456789.
rm: cannot remove `123456789.': File name too long
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> mv 123456789. xxx
mv: cannot move `123456789.' to `xxx': File name too long
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> ls Claude_Francois-Hommage.../
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> rmdir Claude_Francois-Hommage.../
rmdir: failed to remove `Claude_Francois-Hommage.../': File name too long
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> > 123456789.
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots> ls -l
total 352
-rwxr-xr-x 1 phdm root   910 2010-03-14 17:03 123456789
-rwxr-xr-x 1 phdm root     0 2010-03-16 22:28 123456789.
drwxr-xr-x 2 phdm root 32768 2010-03-15 21:02 Claude_Francois-Hommage...
phdm@linux-ellu:/media/IOMEGA_HDD/PUBLIC/trailing_dots>

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index c1ef501..cb1dfa2 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -138,9 +138,12 @@ static int vfat_cmpi(struct dentry *dentry, struct qstr *a, struct qstr *b)
 	struct nls_table *t = MSDOS_SB(dentry->d_inode->i_sb)->nls_io;
 	unsigned int alen, blen;
 
-	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = vfat_striptail_len(a);
-	blen = vfat_striptail_len(b);
+	/*
+	 * Do not remove trailing '.'s here, because we accept disks with
+	 * such entries
+	 */
+	alen = a->len;
+	blen = b->len;
 	if (alen == blen) {
 		if (nls_strnicmp(t, a->name, b->name, alen) == 0)
 			return 0;
@@ -155,9 +158,12 @@ static int vfat_cmp(struct dentry *dentry, struct qstr *a, struct qstr *b)
 {
 	unsigned int alen, blen;
 
-	/* A filename cannot end in '.' or we treat it like it has none */
-	alen = vfat_striptail_len(a);
-	blen = vfat_striptail_len(b);
+	/*
+	 * Do not remove trailing '.'s here, because we accept disks with
+	 * such entries
+	 */
+	alen = a->len;
+	blen = b->len;
 	if (alen == blen) {
 		if (strncmp(a->name, b->name, alen) == 0)
 			return 0;
@@ -693,11 +699,29 @@ cleanup:
 }
 
 static int vfat_find(struct inode *dir, struct qstr *qname,
-		     struct fat_slot_info *sinfo)
+		     struct fat_slot_info *sinfo, int for_removal)
 {
+	int err;
 	unsigned int len = vfat_striptail_len(qname);
+
 	if (len == 0)
 		return -ENOENT;
+	/* Some combined ethernet + usb external hard drive do not
+	 * remove the trailing dots when creating entries using the
+	 * ethernet interface.  (e.g. Iomega Home Network Hard Drive)
+	 * Make accessing those entries possible, but disallow removing them.
+	 */
+	/* Search for the name given by the user, not truncated */
+	err = fat_search_long(dir, qname->name, qname->len, sinfo);
+	if (!err) {
+		if (!for_removal || (len == qname->len))
+			return 0;
+		return -ENAMETOOLONG;
+	}
+	/* If truncated name is equal to original name, we have finished */
+	if (len == qname->len)
+		return err;
+	/* Search for the truncated name */
 	return fat_search_long(dir, qname->name, len, sinfo);
 }
 
@@ -721,7 +745,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 
 	lock_super(sb);
 
-	err = vfat_find(dir, &dentry->d_name, &sinfo);
+	err = vfat_find(dir, &dentry->d_name, &sinfo, 0);
 	if (err) {
 		if (err == -ENOENT) {
 			inode = NULL;
@@ -817,7 +841,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	err = fat_dir_empty(inode);
 	if (err)
 		goto out;
-	err = vfat_find(dir, &dentry->d_name, &sinfo);
+	err = vfat_find(dir, &dentry->d_name, &sinfo, 1);
 	if (err)
 		goto out;
 
@@ -844,7 +868,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 
 	lock_super(sb);
 
-	err = vfat_find(dir, &dentry->d_name, &sinfo);
+	err = vfat_find(dir, &dentry->d_name, &sinfo, 1);
 	if (err)
 		goto out;
 
@@ -923,7 +947,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
 	lock_super(sb);
-	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo);
+	err = vfat_find(old_dir, &old_dentry->d_name, &old_sinfo, 1);
 	if (err)
 		goto out;
 
