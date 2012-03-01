Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab2CAUrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:47:07 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21258 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab2CAUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:47:05 -0500
Date: Thu, 1 Mar 2012 21:45:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-cifs@vger.kernel.org
cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>, sfrench@us.ibm.com
Subject: [PATCH] cifs: don't dereference potentially NULL variable in
 match_session()
Message-ID: <alpine.LNX.2.00.1203012143280.19443@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit of code:
...
		if (strncmp(ses->user_name,
			    vol->username ? vol->username : "",
			    MAX_USERNAME_SIZE))
			return 0;
...
implies that 'vol->username' may be NULL.
If it is NULL, then the 'strlen(vol->username)' that follows will
dereference a NULL pointer.

This patch should take care of that issue.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/cifs/connect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

 Compile tested only.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 602f77c..2f3cf02 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2014,8 +2014,9 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 			    vol->username ? vol->username : "",
 			    MAX_USERNAME_SIZE))
 			return 0;
-		if (strlen(vol->username) != 0 &&
-		    ses->password != NULL &&
+		if (vol->username &&
+		    strlen(vol->username) != 0 &&
+		    ses->password &&
 		    strncmp(ses->password,
 			    vol->password ? vol->password : "",
 			    MAX_PASSWORD_SIZE))
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

