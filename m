Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595Ab2FHFHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761484Ab2FHFHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:40 -0400
Message-Id: <20120608041841.312685387@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 03/82] cifs: Include backup intent search flags during searches {try #2)
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 2608bee744a92d60d15ff4e6e0b913d8b406aedd upstream.

As observed and suggested by Tushar Gosavi...

---------
readdir calls these function to send TRANS2_FIND_FIRST and
TRANS2_FIND_NEXT command to the server. The current cifs module is
not specifying CIFS_SEARCH_BACKUP_SEARCH flag while sending these
command when backupuid/backupgid is specified. This can be resolved
by specifying CIFS_SEARCH_BACKUP_SEARCH flag.
---------

Reported-and-Tested-by: Tushar Gosavi <tugosavi@in.ibm.com>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsproto.h |    6 ++++--
 fs/cifs/cifssmb.c   |   12 +++++-------
 fs/cifs/readdir.c   |   15 +++++++++++++--
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index eeb789d..0a3fa96 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -192,11 +192,13 @@ extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 
 extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
 		const char *searchName, const struct nls_table *nls_codepage,
-		__u16 *searchHandle, struct cifs_search_info *psrch_inf,
+		__u16 *searchHandle, __u16 search_flags,
+		struct cifs_search_info *psrch_inf,
 		int map, const char dirsep);
 
 extern int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
-		__u16 searchHandle, struct cifs_search_info *psrch_inf);
+		__u16 searchHandle, __u16 search_flags,
+		struct cifs_search_info *psrch_inf);
 
 extern int CIFSFindClose(const int, struct cifs_tcon *tcon,
 			const __u16 search_handle);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 45633da..3563c93 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4238,7 +4238,7 @@ int
 CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
 	      const char *searchName,
 	      const struct nls_table *nls_codepage,
-	      __u16 *pnetfid,
+	      __u16 *pnetfid, __u16 search_flags,
 	      struct cifs_search_info *psrch_inf, int remap, const char dirsep)
 {
 /* level 257 SMB_ */
@@ -4310,8 +4310,7 @@ findFirstRetry:
 	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM |
 			ATTR_DIRECTORY);
 	pSMB->SearchCount = cpu_to_le16(CIFSMaxBufSize/sizeof(FILE_UNIX_INFO));
-	pSMB->SearchFlags = cpu_to_le16(CIFS_SEARCH_CLOSE_AT_END |
-		CIFS_SEARCH_RETURN_RESUME);
+	pSMB->SearchFlags = cpu_to_le16(search_flags);
 	pSMB->InformationLevel = cpu_to_le16(psrch_inf->info_level);
 
 	/* BB what should we set StorageType to? Does it matter? BB */
@@ -4381,8 +4380,8 @@ findFirstRetry:
 	return rc;
 }
 
-int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
-		 __u16 searchHandle, struct cifs_search_info *psrch_inf)
+int CIFSFindNext(const int xid, struct cifs_tcon *tcon, __u16 searchHandle,
+		 __u16 search_flags, struct cifs_search_info *psrch_inf)
 {
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
@@ -4425,8 +4424,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
 		cpu_to_le16(CIFSMaxBufSize / sizeof(FILE_UNIX_INFO));
 	pSMB->InformationLevel = cpu_to_le16(psrch_inf->info_level);
 	pSMB->ResumeKey = psrch_inf->resume_key;
-	pSMB->SearchFlags =
-	      cpu_to_le16(CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME);
+	pSMB->SearchFlags = cpu_to_le16(search_flags);
 
 	name_len = psrch_inf->resume_name_len;
 	params += name_len;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index e2bbc68..0a8224d 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -219,6 +219,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 
 static int initiate_cifs_search(const int xid, struct file *file)
 {
+	__u16 search_flags;
 	int rc = 0;
 	char *full_path = NULL;
 	struct cifsFileInfo *cifsFile;
@@ -270,8 +271,12 @@ ffirst_retry:
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
 	}
 
+	search_flags = CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
+	if (backup_cred(cifs_sb))
+		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
+
 	rc = CIFSFindFirst(xid, pTcon, full_path, cifs_sb->local_nls,
-		&cifsFile->netfid, &cifsFile->srch_inf,
+		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
 		cifs_sb->mnt_cifs_flags &
 			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
 	if (rc == 0)
@@ -502,11 +507,13 @@ static int cifs_save_resume_key(const char *current_entry,
 static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 	struct file *file, char **ppCurrentEntry, int *num_to_ret)
 {
+	__u16 search_flags;
 	int rc = 0;
 	int pos_in_buf = 0;
 	loff_t first_entry_in_buffer;
 	loff_t index_to_find = file->f_pos;
 	struct cifsFileInfo *cifsFile = file->private_data;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	/* check if index in the buffer */
 
 	if ((cifsFile == NULL) || (ppCurrentEntry == NULL) ||
@@ -560,10 +567,14 @@ static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 						cifsFile);
 	}
 
+	search_flags = CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
+	if (backup_cred(cifs_sb))
+		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
+
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
 	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
 		cFYI(1, "calling findnext2");
-		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid,
+		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid, search_flags,
 				  &cifsFile->srch_inf);
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
 		if (cifsFile->srch_inf.last_entry)


