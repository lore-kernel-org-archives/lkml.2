Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477Ab2EOCg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:36:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:49818 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965395Ab2EOCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 140/179] cifs: clean up cifs_find_smb_ses (try #2)
Date: Mon, 14 May 2012 22:13:56 -0400
Message-ID: <1337048075-6132-141-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4ff67b720c02c36e54d55b88c2931879b7db1cd2 upstream.

This patch replaces the earlier patch by the same name. The only
difference is that MAX_PASSWORD_SIZE has been increased to attempt to
match the limits that windows enforces.

Do a better job of matching sessions by authtype. Matching by username
for a Kerberos session is incorrect, and anonymous sessions need special
handling.

Also, in the case where we do match by username, we also need to match
by password. That ensures that someone else doesn't "borrow" an existing
session without needing to know the password.

Finally, passwords can be longer than 16 bytes. Bump MAX_PASSWORD_SIZE
to 512 to match the size that the userspace mount helper allows.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
[PG: origin vs. in 2.6.34; ses <-- pSesInfo, server <-- srvTcp ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/connect.c  |   26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0c2fd17..23fc9ae 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -34,7 +34,7 @@
 #define MAX_SHARE_SIZE  64	/* used to be 20, this should still be enough */
 #define MAX_USERNAME_SIZE 32	/* 32 is to allow for 15 char names + null
 				   termination then *2 for unicode versions */
-#define MAX_PASSWORD_SIZE 16
+#define MAX_PASSWORD_SIZE 512  /* max for windows seems to be 256 wide chars */
 
 #define CIFS_MIN_RCV_POOL 4
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1f6aae0..4e134a7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1592,17 +1592,27 @@ out_err:
 }
 
 static struct cifsSesInfo *
-cifs_find_smb_ses(struct TCP_Server_Info *server, char *username)
+cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
-	struct list_head *tmp;
 	struct cifsSesInfo *ses;
 
 	write_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
-		if (strncmp(ses->userName, username, MAX_USERNAME_SIZE))
-			continue;
-
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		switch (server->secType) {
+		case Kerberos:
+			if (vol->linux_uid != ses->linux_uid)
+				continue;
+			break;
+		default:
+			/* anything else takes username/password */
+			if (strncmp(ses->userName, vol->username,
+				    MAX_USERNAME_SIZE))
+				continue;
+			if (strlen(vol->username) != 0 &&
+			    strncmp(ses->password, vol->password,
+				    MAX_PASSWORD_SIZE))
+				continue;
+		}
 		++ses->ses_count;
 		write_unlock(&cifs_tcp_ses_lock);
 		return ses;
@@ -2385,7 +2395,7 @@ try_mount_again:
 		goto out;
 	}
 
-	pSesInfo = cifs_find_smb_ses(srvTcp, volume_info->username);
+	pSesInfo = cifs_find_smb_ses(srvTcp, volume_info);
 	if (pSesInfo) {
 		cFYI(1, ("Existing smb sess found (status=%d)",
 			pSesInfo->status));
-- 
1.7.9.6

