Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1AUOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:34:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62399 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1AUOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=bBpJjULCuuhWPwIQ5dLKYNzkBoSmYAGKDCaVrzhkwq2Rr5V+n2faHrkZLKOuXGtmnL
         1gLXboK3j2zJB9dlt3X7W2aoiMo7frLHr1+PbP/Pv4XIU51DiEfVLWOYC3rdO6iB/Jgp
         vB+MBbi5Xtq1aq6J11kgjsoXn4peqG2g3jM/o=
Date: Fri, 21 Jan 2011 14:34:12 +0000 (GMT)
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] adfs: add hexadecimal filetype suffix option
In-Reply-To: <20110119154915.a0bb2878.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101211431490.3490@dc5850.croftnuisk.local>
References: <4D2DEDDB.1070605@gmail.com> <20110119154915.a0bb2878.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] adfs: add hexadecimal filetype suffix option

ADFS (FileCore) storage complies with the RISC OS filetype specification
(12 bits of file type information is stored in the file load address, rather
than using a file extension).  The existing driver largely ignores this
information and does not present it to the end user.

It is desirable that stored filetypes be made visible to the end user to
facilitate a precise copy of data and metadata from a hard disc (or image
thereof) into a RISC OS emulator (such as RPCEmu) or to a network share which
can be accessed by real Acorn systems.

This patch implements a per-mount filetype suffix option (use -o ftsuffix=1)
to present any filetype as a ,xyz hexadecimal suffix on each file.  This type
suffix is compatible with that used by RISC OS systems that access network
servers using NFS client software and by RPCemu's host filing system.

Signed-off-by: Stuart Swales <stuart.swales.croftnuisk@gmail.com>

---

Bugzilla # 26492
(ADFS filesystem filetype metadata lost)

Test files are attached in Bugzilla issue.

NB. Updated patch with style fixes as suggested by Andrew.


diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/Documentation/filesystems/adfs.txt linux-2.6.37-sks-adfs/Documentation/filesystems/adfs.txt
--- linux-2.6.37-vanilla/Documentation/filesystems/adfs.txt	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/Documentation/filesystems/adfs.txt	2011-01-21 14:10:27.000000000 +0000
@@ -9,6 +9,9 @@ Mount options for ADFS
 		will be nnn.  Default 0700.
   othmask=nnn	The permission mask for ADFS 'other' permissions
 		will be nnn.  Default 0077.
+  ftsuffix=n	When ftsuffix=0, no file type suffix will be applied.
+		When ftsuffix=1, a hexadecimal suffix corresponding to
+		the RISC OS file type will be added.  Default 0.

 Mapping of ADFS permissions to Linux permissions
 ------------------------------------------------
@@ -55,3 +58,18 @@ Mapping of ADFS permissions to Linux per

   You can therefore tailor the permission translation to whatever you
   desire the permissions should be under Linux.
+
+RISC OS file type suffix
+------------------------
+
+  RISC OS file types are stored in bits 19..8 of the file load address.
+
+  To enable non-RISC OS systems to be used to store files without losing
+  file type information, a file naming convention was devised (initially
+  for use with NFS) such that a hexadecimal suffix of the form ,xyz
+  denoted the file type: e.g. BasicFile,ffb is a BASIC (0xffb) file.  This
+  naming convention is now also used by RISC OS emulators such as RPCEmu.
+
+  Mounting an ADFS disc with option ftsuffix=1 will cause appropriate file
+  type suffixes to be appended to file names read from a directory.  If the
+  ftsuffix option is zero or omitted, no file type suffixes will be added.
diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/fs/adfs/adfs.h linux-2.6.37-sks-adfs/fs/adfs/adfs.h
--- linux-2.6.37-vanilla/fs/adfs/adfs.h	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/adfs.h	2011-01-21 13:50:12.000000000 +0000
@@ -50,6 +50,7 @@ struct adfs_sb_info {
 	gid_t		s_gid;		/* owner gid				 */
 	umode_t		s_owner_mask;	/* ADFS owner perm -> unix perm		 */
 	umode_t		s_other_mask;	/* ADFS other perm -> unix perm		 */
+	int		s_ftsuffix;	/* ,xyz hex filetype suffix option */

 	__u32		s_ids_per_zone;	/* max. no ids in one zone		 */
 	__u32		s_idlen;	/* length of ID in map			 */
@@ -89,7 +90,7 @@ struct adfs_dir {
 /*
  * This is the overall maximum name length
  */
-#define ADFS_MAX_NAME_LEN	256
+#define ADFS_MAX_NAME_LEN	(256 + 4) /* +4 for ,xyz hex filetype suffix */
 struct object_info {
 	__u32		parent_id;		/* parent object id	*/
 	__u32		file_id;		/* object id		*/
@@ -97,10 +98,26 @@ struct object_info {
 	__u32		execaddr;		/* execution address	*/
 	__u32		size;			/* size			*/
 	__u8		attr;			/* RISC OS attributes	*/
-	unsigned char	name_len;		/* name length		*/
+	unsigned int	name_len;		/* name length		*/
 	char		name[ADFS_MAX_NAME_LEN];/* file name		*/
+
+	/* RISC OS file type (12-bit: derived from loadaddr) */
+	__u16		filetype;
 };

+/* RISC OS 12-bit filetype converts to ,xyz hex filename suffix */
+static inline int append_filetype_suffix(char *buf, __u16 filetype)
+{
+	if (filetype == -1)
+		return 0;
+
+	*buf++ = ',';
+	*buf++ = hex_asc_lo(filetype >> 8);
+	*buf++ = hex_asc_lo(filetype >> 4);
+	*buf++ = hex_asc_lo(filetype >> 0);
+	return 4;
+}
+
 struct adfs_dir_ops {
 	int	(*read)(struct super_block *sb, unsigned int id, unsigned int sz, struct adfs_dir *dir);
 	int	(*setpos)(struct adfs_dir *dir, unsigned int fpos);
diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/fs/adfs/dir_f.c linux-2.6.37-sks-adfs/fs/adfs/dir_f.c
--- linux-2.6.37-vanilla/fs/adfs/dir_f.c	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/dir_f.c	2011-01-21 13:52:57.000000000 +0000
@@ -52,7 +52,6 @@ static inline int adfs_readname(char *bu
 			*buf++ = *ptr;
 		ptr++;
 	}
-	*buf = '\0';

 	return buf - old_buf;
 }
@@ -208,7 +207,8 @@ release_buffers:
  * convert a disk-based directory entry to a Linux ADFS directory entry
  */
 static inline void
-adfs_dir2obj(struct object_info *obj, struct adfs_direntry *de)
+adfs_dir2obj(struct adfs_dir *dir, struct object_info *obj,
+	struct adfs_direntry *de)
 {
 	obj->name_len =	adfs_readname(obj->name, de->dirobname, ADFS_F_NAME_LEN);
 	obj->file_id  = adfs_readval(de->dirinddiscadd, 3);
@@ -216,6 +216,23 @@ adfs_dir2obj(struct object_info *obj, st
 	obj->execaddr = adfs_readval(de->direxec, 4);
 	obj->size     = adfs_readval(de->dirlen,  4);
 	obj->attr     = de->newdiratts;
+	obj->filetype = -1;
+
+	/*
+	 * object is a file and is filetyped and timestamped?
+	 * RISC OS 12-bit filetype is stored in load_address[19:8]
+	 */
+	if ((0 == (obj->attr & ADFS_NDA_DIRECTORY)) &&
+		(0xfff00000 == (0xfff00000 & obj->loadaddr))) {
+		obj->filetype = (__u16) ((0x000fff00 & obj->loadaddr) >> 8);
+
+		/* optionally append the ,xyz hex filetype suffix */
+		if (ADFS_SB(dir->sb)->s_ftsuffix)
+			obj->name_len +=
+				append_filetype_suffix(
+					&obj->name[obj->name_len],
+					obj->filetype);
+	}
 }

 /*
@@ -260,7 +277,7 @@ __adfs_dir_get(struct adfs_dir *dir, int
 	if (!de.dirobname[0])
 		return -ENOENT;

-	adfs_dir2obj(obj, &de);
+	adfs_dir2obj(dir, obj, &de);

 	return 0;
 }
diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/fs/adfs/dir_fplus.c linux-2.6.37-sks-adfs/fs/adfs/dir_fplus.c
--- linux-2.6.37-vanilla/fs/adfs/dir_fplus.c	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/dir_fplus.c	2011-01-21 13:53:43.000000000 +0000
@@ -147,6 +147,24 @@ adfs_fplus_getnext(struct adfs_dir *dir,
 		if (obj->name[i] == '/')
 			obj->name[i] = '.';

+	obj->filetype = -1;
+
+	/*
+	 * object is a file and is filetyped and timestamped?
+	 * RISC OS 12-bit filetype is stored in load_address[19:8]
+	 */
+	if ((0 == (obj->attr & ADFS_NDA_DIRECTORY)) &&
+		(0xfff00000 == (0xfff00000 & obj->loadaddr))) {
+		obj->filetype = (__u16) ((0x000fff00 & obj->loadaddr) >> 8);
+
+		/* optionally append the ,xyz hex filetype suffix */
+		if (ADFS_SB(dir->sb)->s_ftsuffix)
+			obj->name_len +=
+				append_filetype_suffix(
+					&obj->name[obj->name_len],
+					obj->filetype);
+	}
+
 	dir->pos += 1;
 	ret = 0;
 out:
diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/fs/adfs/inode.c linux-2.6.37-sks-adfs/fs/adfs/inode.c
--- linux-2.6.37-vanilla/fs/adfs/inode.c	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/inode.c	2011-01-21 13:48:38.000000000 +0000
@@ -79,26 +79,13 @@ static const struct address_space_operat
 	.bmap		= _adfs_bmap
 };

-static inline unsigned int
-adfs_filetype(struct inode *inode)
-{
-	unsigned int type;
-
-	if (ADFS_I(inode)->stamped)
-		type = (ADFS_I(inode)->loadaddr >> 8) & 0xfff;
-	else
-		type = (unsigned int) -1;
-
-	return type;
-}
-
 /*
  * Convert ADFS attributes and filetype to Linux permission.
  */
 static umode_t
 adfs_atts2mode(struct super_block *sb, struct inode *inode)
 {
-	unsigned int filetype, attr = ADFS_I(inode)->attr;
+	unsigned int attr = ADFS_I(inode)->attr;
 	umode_t mode, rmask;
 	struct adfs_sb_info *asb = ADFS_SB(sb);

@@ -107,9 +94,7 @@ adfs_atts2mode(struct super_block *sb, s
 		return S_IFDIR | S_IXUGO | mode;
 	}

-	filetype = adfs_filetype(inode);
-
-	switch (filetype) {
+	switch (ADFS_I(inode)->filetype) {
 	case 0xfc0:	/* LinkFS */
 		return S_IFLNK|S_IRWXUGO;

@@ -280,7 +265,8 @@ adfs_iget(struct super_block *sb, struct
 	ADFS_I(inode)->loadaddr  = obj->loadaddr;
 	ADFS_I(inode)->execaddr  = obj->execaddr;
 	ADFS_I(inode)->attr      = obj->attr;
-	ADFS_I(inode)->stamped	  = ((obj->loadaddr & 0xfff00000) == 0xfff00000);
+	ADFS_I(inode)->filetype  = obj->filetype;
+	ADFS_I(inode)->stamped   = ((obj->loadaddr & 0xfff00000) == 0xfff00000);

 	inode->i_mode	 = adfs_atts2mode(sb, inode);
 	adfs_adfs2unix_time(&inode->i_mtime, inode);
diff -X linux-2.6.37-vanilla/Documentation/dontdiff -uprN linux-2.6.37-vanilla/fs/adfs/super.c linux-2.6.37-sks-adfs/fs/adfs/super.c
--- linux-2.6.37-vanilla/fs/adfs/super.c	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/super.c	2011-01-21 14:18:01.000000000 +0000
@@ -143,17 +143,20 @@ static int adfs_show_options(struct seq_
 		seq_printf(seq, ",ownmask=%o", asb->s_owner_mask);
 	if (asb->s_other_mask != ADFS_DEFAULT_OTHER_MASK)
 		seq_printf(seq, ",othmask=%o", asb->s_other_mask);
+	if (asb->s_ftsuffix != 0)
+		seq_printf(seq, ",ftsuffix=%u", asb->s_ftsuffix);

 	return 0;
 }

-enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_err};
+enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_ftsuffix, Opt_err};

 static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_ownmask, "ownmask=%o"},
 	{Opt_othmask, "othmask=%o"},
+	{Opt_ftsuffix, "ftsuffix=%u"},
 	{Opt_err, NULL}
 };

@@ -194,6 +197,11 @@ static int parse_options(struct super_bl
 				return -EINVAL;
 			asb->s_other_mask = option;
 			break;
+		case Opt_ftsuffix:
+			if (match_int(args, &option))
+				return -EINVAL;
+			asb->s_ftsuffix = option;
+			break;
 		default:
 			printk("ADFS-fs: unrecognised mount option \"%s\" "
 					"or missing value\n", p);
@@ -368,6 +376,7 @@ static int adfs_fill_super(struct super_
 	asb->s_gid = 0;
 	asb->s_owner_mask = ADFS_DEFAULT_OWNER_MASK;
 	asb->s_other_mask = ADFS_DEFAULT_OTHER_MASK;
+	asb->s_ftsuffix = 0;

 	if (parse_options(sb, data))
 		goto error;
@@ -447,11 +456,13 @@ static int adfs_fill_super(struct super_

 	root_obj.parent_id = root_obj.file_id = le32_to_cpu(dr->root);
 	root_obj.name_len  = 0;
-	root_obj.loadaddr  = 0;
-	root_obj.execaddr  = 0;
+	/* Set root object date as 01 Jan 1987 00:00:00 */
+	root_obj.loadaddr  = 0xfff0003f;
+	root_obj.execaddr  = 0xec22c000;
 	root_obj.size	   = ADFS_NEWDIR_SIZE;
 	root_obj.attr	   = ADFS_NDA_DIRECTORY   | ADFS_NDA_OWNER_READ |
 			     ADFS_NDA_OWNER_WRITE | ADFS_NDA_PUBLIC_READ;
+	root_obj.filetype  = -1;

 	/*
 	 * If this is a F+ disk with variable length directories,
@@ -466,6 +477,13 @@ static int adfs_fill_super(struct super_
 		asb->s_namelen = ADFS_F_NAME_LEN;
 	}

+	/*
+	 * ,xyz hex filetype suffix may be added by driver
+	 * to files that have valid RISC OS filetype
+	 */
+	if (asb->s_ftsuffix)
+		asb->s_namelen += 4;
+
 	root = adfs_iget(sb, &root_obj);
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
