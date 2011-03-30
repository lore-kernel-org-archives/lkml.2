Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040Ab1C3Vej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:34:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960Ab1C3VIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278316"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: piastryyy@gmail.com, sfrench@us.ibm.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [172/275] CIFS: Fix oplock break handling (try #2)
Message-Id: <20110330210654.CCB873E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Pavel Shilovsky <piastryyy@gmail.com>

commit 12fed00de963433128b5366a21a55808fab2f756 upstream.

When we get oplock break notification we should set the appropriate
value of OplockLevel field in oplock break acknowledge according to
the oplock level held by the client in this time. As we only can have
level II oplock or no oplock in the case of oplock break, we should be
aware only about clientCanCacheRead field in cifsInodeInfo structure.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    4 +++-
 fs/cifs/file.c      |   21 +++++++++++----------
 3 files changed, 15 insertions(+), 12 deletions(-)

Index: linux-2.6.35.y/fs/cifs/cifsproto.h
===================================================================
--- linux-2.6.35.y.orig/fs/cifs/cifsproto.h	2011-03-29 22:50:55.310843152 -0700
+++ linux-2.6.35.y/fs/cifs/cifsproto.h	2011-03-29 23:03:01.820253595 -0700
@@ -343,7 +343,7 @@
 			const __u16 netfid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
 			const __u32 numLock, const __u8 lockType,
-			const bool waitFlag);
+			const bool waitFlag, const __u8 oplock_level);
 extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u16 smb_file_id, const int get_flag,
 			const __u64 len, struct file_lock *,
Index: linux-2.6.35.y/fs/cifs/cifssmb.c
===================================================================
--- linux-2.6.35.y.orig/fs/cifs/cifssmb.c	2011-03-29 22:50:55.310843152 -0700
+++ linux-2.6.35.y/fs/cifs/cifssmb.c	2011-03-29 23:03:01.822253544 -0700
@@ -1647,7 +1647,8 @@
 CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	    const __u16 smb_file_id, const __u64 len,
 	    const __u64 offset, const __u32 numUnlock,
-	    const __u32 numLock, const __u8 lockType, const bool waitFlag)
+	    const __u32 numLock, const __u8 lockType,
+	    const bool waitFlag, const __u8 oplock_level)
 {
 	int rc = 0;
 	LOCK_REQ *pSMB = NULL;
@@ -1675,6 +1676,7 @@
 	pSMB->NumberOfLocks = cpu_to_le16(numLock);
 	pSMB->NumberOfUnlocks = cpu_to_le16(numUnlock);
 	pSMB->LockType = lockType;
+	pSMB->OplockLevel = oplock_level;
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = smb_file_id; /* netfid stays le */
 
Index: linux-2.6.35.y/fs/cifs/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/cifs/file.c	2011-03-29 22:50:55.310843152 -0700
+++ linux-2.6.35.y/fs/cifs/file.c	2011-03-29 23:03:01.825253466 -0700
@@ -796,12 +796,12 @@
 
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
 				cERROR(1, "Error unlocking previously locked "
@@ -818,13 +818,13 @@
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
 						cERROR(1, "Error unlocking "
@@ -868,8 +868,8 @@
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
-					pfLock->fl_start,
-					0, numLock, lockType, wait_flag);
+					 pfLock->fl_start, 0, numLock, lockType,
+					 wait_flag, 0);
 
 			if (rc == 0) {
 				/* For Windows locks we must store them. */
@@ -889,9 +889,9 @@
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
 					else {
@@ -2300,7 +2300,8 @@
 	 */
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false);
+				 LOCKING_ANDX_OPLOCK_RELEASE, false,
+				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
 }
