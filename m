Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0FUBX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:23:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45493 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab0FUBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FlaRSBK1EvHaiOyUB3onJpXdmKBaldXL2g59ME3TLNYn072jiZ8p3nl3FJofPV7Fzx
         cI6Z5pYDfsxaAVlZ5KGIp4W/GwOlsNd3e2jeuRWqV/dh6jjHGFwvUhFlLUvMuxZ1KzIJ
         3HCk4+iw/VzXzYPFkSxDPJyEWhBaMeYaBdjZU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jlayton@samba.org,
       linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/6 v3]cifs Fix warnings variables set but not used
Date: Sun, 20 Jun 2010 18:23:21 -0700
Message-Id: <1277083401-6459-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a redu from the original(or similar) fixing
gcc warningds generated while compiling:

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
 
  CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used

(the warning below is funky i.g. removing pTcon generates the warning below
but if I use the __unused option there is no warning at all).

 CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1314:23: warning: variable 'cifs_sb' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/cifs/cifssmb.c |    3 ---
 fs/cifs/file.c    |    4 ----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..4653aaa 100644
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
@@ -4876,8 +4875,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
 	offset = param_offset + params;
 
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
-
 	count = sizeof(struct file_end_of_file_info);
 	pSMB->MaxParameterCount = cpu_to_le16(2);
 	/* BB find exact max SMB PDU from sess structure BB */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75541af..661f868 100644
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
 
@@ -1320,8 +1318,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 		return -EFAULT;
 
 	inode = page->mapping->host;
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
 
 	offset += (loff_t)from;
 	write_data = kmap(page);
-- 
1.7.1.rc1.21.gf3bd6

