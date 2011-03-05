Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1CEBFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:05:31 -0500
Received: from kroah.org ([198.145.64.141]:47750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab1CEBFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:53 2011
Message-Id: <20110305010353.590838435@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [18/18] CIFS: Fix oplock break handling (try #2)
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 12fed00de963433128b5366a21a55808fab2f756 upstream.

When we get oplock break notification we should set the appropriate
value of OplockLevel field in oplock break acknowledge according to
the oplock level held by the client in this time. As we only can have
level II oplock or no oplock in the case of oplock break, we should be
aware only about clientCanCacheRead field in cifsInodeInfo structure.

Also fix bug connected with wrong interpretation of OplockLevel field
during oplock break notification processing.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    4 +++-
 fs/cifs/file.c      |   17 +++++++++--------
 3 files changed, 13 insertions(+), 10 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -323,7 +323,7 @@ extern int CIFSSMBLock(const int xid, st
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag);
+			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1641,7 +1641,8 @@ int
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
+	    const __u32 numLock, const __u8 lockType,
+	    const bool waitFlag, const __u8 oplock_level)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1669,6 +1670,7 @@ CIFSSMBLock(const int xid, struct cifsTc
 	pSMB->NumberOfLocks = cpu_to_le16(numLock);
 	pSMB->NumberOfUnlocks = cpu_to_le16(numUnlock);
 	pSMB->LockType = lockType;
+	pSMB->OplockLevel = oplock_level;
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -825,12 +825,12 @@ int cifs_lock(struct file *file, int cmd
 
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
@@ -873,8 +873,8 @@ int cifs_lock(struct file *file, int cmd
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start,
-					0, numLock, lockType, wait_flag);
+					 pfLock->fl_start, 0, numLock, lockType,
+					 wait_flag, 0);
 
 			if (rc == 0) {
 				/* For Windows locks we must store them. */
@@ -894,9 +894,9 @@ int cifs_lock(struct file *file, int cmd
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
 
@@ -2314,7 +2314,8 @@ cifs_oplock_break(struct slow_work *work
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false);
+				 LOCKING_ANDX_OPLOCK_RELEASE, false,
+				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, ("Oplock release rc = %d", rc));
 	}
 }


