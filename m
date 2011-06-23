Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab1FWSEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:04:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:34807 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab1FWRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 149/247] CIFS: Fix oplock break handling (try #2)
Date: Thu, 23 Jun 2011 13:33:37 -0400
Message-Id: <1308850515-15242-90-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 12fed00de963433128b5366a21a55808fab2f756 upstream.

When we get oplock break notification we should set the appropriate
value of OplockLevel field in oplock break acknowledge according to
the oplock level held by the client in this time. As we only can have
level II oplock or no oplock in the case of oplock break, we should be
aware only about clientCanCacheRead field in cifsInodeInfo structure.

Also fix bug connected with wrong interpretation of OplockLevel field
during oplock break notification processing.

[PG: above OplockLevel bug only exists via. e66673e39a which didn't
appear until v2.6.37-rc2, so cifs/misc.c hunk dropped.]

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    4 +++-
 fs/cifs/file.c      |   21 +++++++++++----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a6db615..ef0db18 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -329,7 +329,7 @@ extern int CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag);
+			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5d3f29f..62e49ab 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1642,7 +1642,8 @@ int
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
+	    const __u32 numLock, const __u8 lockType,
+	    const bool waitFlag, const __u8 oplock_level)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1670,6 +1671,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	pSMB->NumberOfLocks = cpu_to_le16(numLock);
 	pSMB->NumberOfUnlocks = cpu_to_le16(numUnlock);
 	pSMB->LockType = lockType;
+	pSMB->OplockLevel = oplock_level;
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4cbdb20..1ab7670 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -828,12 +828,12 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		/* BB we could chain these into one lock request BB */
 		rc = CIFSSMBLock(xid, tcon, netfid, length, pfLock->fl_start,
-				 0, 1, lockType, 0 /* wait flag */ );
+				 0, 1, lockType, 0 /* wait flag */, 0);
 		if (rc == 0) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
 					 pfLock->fl_start, 1 /* numUnlock */ ,
 					 0 /* numLock */ , lockType,
-					 0 /* wait flag */ );
+					 0 /* wait flag */, 0);
 			pfLock->fl_type = F_UNLCK;
 			if (rc != 0)
 				cERROR(1, ("Error unlocking previously locked "
@@ -850,13 +850,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 				rc = CIFSSMBLock(xid, tcon, netfid, length,
 					pfLock->fl_start, 0, 1,
 					lockType | LOCKING_ANDX_SHARED_LOCK,
-					0 /* wait flag */);
+					0 /* wait flag */, 0);
 				if (rc == 0) {
 					rc = CIFSSMBLock(xid, tcon, netfid,
 						length, pfLock->fl_start, 1, 0,
 						lockType |
 						LOCKING_ANDX_SHARED_LOCK,
-						0 /* wait flag */);
+						0 /* wait flag */, 0);
 					pfLock->fl_type = F_RDLCK;
 					if (rc != 0)
 						cERROR(1, ("Error unlocking "
@@ -900,8 +900,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start,
-					0, numLock, lockType, wait_flag);
+					 pfLock->fl_start, 0, numLock, lockType,
+					 wait_flag, 0);
 
 			if (rc == 0) {
 				/* For Windows locks we must store them. */
@@ -921,9 +921,9 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 						(pfLock->fl_start + length) >=
 						(li->offset + li->length)) {
 					stored_rc = CIFSSMBLock(xid, tcon,
-							netfid,
-							li->length, li->offset,
-							1, 0, li->type, false);
+							netfid, li->length,
+							li->offset, 1, 0,
+							li->type, false, 0);
 					if (stored_rc)
 						rc = stored_rc;
 
@@ -2340,7 +2340,8 @@ cifs_oplock_break(struct slow_work *work)
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false);
+				 LOCKING_ANDX_OPLOCK_RELEASE, false,
+				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, ("Oplock release rc = %d", rc));
 	}
 }
-- 
1.7.4.4

