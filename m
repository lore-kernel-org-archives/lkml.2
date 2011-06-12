Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1FLBRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 21:17:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60237 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1FLBRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 21:17:17 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        mp3project@sarijopen.student.utwente.nl, cmdkhh@gmail.com
Subject: [PATCH] cifs: correctly handle NULL tcon pointer in CIFSTCon
Date: Sat, 11 Jun 2011 21:17:10 -0400
Message-Id: <1307841430-9876-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long ago (in commit 00e485b0), I added some code to handle share-level
passwords in CIFSTCon. That code ignored the fact that it's legit to
pass in a NULL tcon pointer when connecting to the IPC$ share on the
server.

This wasn't really a problem until recently as we only called CIFSTCon
this way when the server returned -EREMOTE. With the introduction of
commit c1508ca2 however, it gets called this way on every mount, causing
an oops when share-level security is in effect.

Fix this by simply treating a NULL tcon pointer as if user-level
security were in effect. I'm not aware of any servers that protect the
IPC$ share with a specific password anyway. Also, add a comment to the
top of CIFSTCon to ensure that we don't make the same mistake again.

Cc: <stable@kernel.org>
Reported-by: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b6cad2..fa5a5d7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3174,6 +3174,10 @@ out:
 	return rc;
 }
 
+/*
+ * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the tcon
+ * pointer may be NULL.
+ */
 int
 CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	 const char *tree, struct cifs_tcon *tcon,
@@ -3208,7 +3212,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	pSMB->AndXCommand = 0xFF;
 	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr = &pSMB->Password[0];
-	if ((ses->server->sec_mode) & SECMODE_USER) {
+	if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
 		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
 		*bcc_ptr = 0; /* password is null byte */
 		bcc_ptr++;              /* skip password */
-- 
1.7.5.2

