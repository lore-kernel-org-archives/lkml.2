Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab0FKUmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:42:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54590 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab0FKUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wWv+Wq/wttM6B/1gEDZ8LltBxMPgwpifxMOvRm+C/zy8c2idm1DSmugAqTPCNCulG1
         cwyDe2HiJezUBFBHIz4XGsZrJIWmytx01gTidqr1e0itifTsBT4sGpO/VQo2fSCPVqb6
         NLhUslZKV4vykdf35KxQLg95LIOHgYW+eTuIM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/6]cifs Fix variable not set warnings
Date: Fri, 11 Jun 2010 13:41:06 -0700
Message-Id: <1276288869-16815-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes the warning messages from
gcc 4.6.0 and compiling the kernel.

  CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used

  CC [M]  fs/cifs/dir.o
fs/cifs/dir.c: In function 'cifs_lookup':
fs/cifs/dir.c:641:15: warning: variable 'filp' set but not used

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
  CC [M]  fs/cifs/cifs_debug.o


 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/cifs/cifssmb.c |    4 +---
 fs/cifs/dir.c     |    4 +---
 fs/cifs/file.c    |    6 +-----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..ca872c3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4852,7 +4852,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
-	char *data_offset;
 	struct file_end_of_file_info *parm_data;
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
@@ -4876,8 +4875,7 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
 	offset = param_offset + params;
 
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
-
+	
 	count = sizeof(struct file_end_of_file_info);
 	pSMB->MaxParameterCount = cpu_to_le16(2);
 	/* BB find exact max SMB PDU from sess structure BB */
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 391816b..cd409c0 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -638,8 +638,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct cifsTconInfo *pTcon;
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
-	struct file *filp;
-
+	
 	xid = GetXid();
 
 	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
@@ -734,7 +733,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			direntry->d_op = &cifs_dentry_ops;
 		d_add(direntry, newInode);
 		if (posix_open)
-			filp = lookup_instantiate_filp(nd, direntry, NULL);
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75541af..bbb66d5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1311,8 +1311,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	char *write_data;
 	int rc = -EFAULT;
 	int bytes_written = 0;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
 
@@ -1320,9 +1318,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 		return -EFAULT;
 
 	inode = page->mapping->host;
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
-
+		
 	offset += (loff_t)from;
 	write_data = kmap(page);
 	write_data += from;
-- 
1.7.1.rc1.21.gf3bd6

