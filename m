Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2KSPNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50234 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2KSPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:13:03 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:28 -0800
Message-Id: <1353337961-12962-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19QTNrcJdsli2qfyFnlgmDLThLvuJvImDc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1520]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 03/16] userns: Allow chown and setgid preservation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Allow chown if CAP_CHOWN is present in the current user namespace
  and the uid of the inode maps into the current user namespace, and
  the destination uid or gid maps into the current user namespace.

- Allow perserving setgid when changing an inode if CAP_FSETID is
  present in the current user namespace and the owner of the file has
  a mapping into the current user namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/attr.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index cce7df5..1449adb 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -49,14 +49,15 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
 	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	     !uid_eq(attr->ia_uid, inode->i_uid)) && !capable(CAP_CHOWN))
+	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
+	    !inode_capable(inode, CAP_CHOWN))
 		return -EPERM;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
 	    (!uid_eq(current_fsuid(), inode->i_uid) ||
 	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
-	    !capable(CAP_CHOWN))
+	    !inode_capable(inode, CAP_CHOWN))
 		return -EPERM;
 
 	/* Make sure a caller can chmod. */
@@ -65,7 +66,8 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 			return -EPERM;
 		/* Also check the setgid bit! */
 		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-				inode->i_gid) && !capable(CAP_FSETID))
+				inode->i_gid) &&
+		    !inode_capable(inode, CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -157,7 +159,8 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(inode->i_gid) &&
+		    !inode_capable(inode, CAP_FSETID))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
-- 
1.7.5.4

