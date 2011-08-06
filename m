Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1HFAJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:09:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab1HFAJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:53 2011
Message-Id: <20110806000253.187960170@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [43/55] cifs: clean up cifs_find_smb_ses (try #2)
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

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
[dannf: backported to Debian's 2.6.32]
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/connect.c  |   26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -33,7 +33,7 @@
 #define MAX_SHARE_SIZE  64	/* used to be 20, this should still be enough */
 #define MAX_USERNAME_SIZE 32	/* 32 is to allow for 15 char names + null
 				   termination then *2 for unicode versions */
-#define MAX_PASSWORD_SIZE 16
+#define MAX_PASSWORD_SIZE 512  /* max for windows seems to be 256 wide chars */
 
 #define CIFS_MIN_RCV_POOL 4
 
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1588,17 +1588,27 @@ out_err:
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
@@ -2362,7 +2372,7 @@ try_mount_again:
 		goto out;
 	}
 
-	pSesInfo = cifs_find_smb_ses(srvTcp, volume_info->username);
+	pSesInfo = cifs_find_smb_ses(srvTcp, volume_info);
 	if (pSesInfo) {
 		cFYI(1, ("Existing smb sess found (status=%d)",
 			pSesInfo->status));


