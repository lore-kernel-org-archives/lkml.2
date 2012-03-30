Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966217Ab2C3VWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:22:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966189Ab2C3VWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:25 -0400
Message-Id: <20120330194846.793866062@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Hadig <thomas@intapp.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 106/175] cifs: fix issue mounting of DFS ROOT when redirecting from one domain controller to the next
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 1daaae8fa4afe3df78ca34e724ed7e8187e4eb32 upstream.

This patch fixes an issue when cifs_mount receives a
STATUS_BAD_NETWORK_NAME error during cifs_get_tcon but is able to
continue after an DFS ROOT referral. In this case, the return code
variable is not reset prior to trying to mount from the system referred
to. Thus, is_path_accessible is not executed and the final DFS referral
is not performed causing a mount error.

Use case: In DNS, example.com  resolves to the secondary AD server
ad2.example.com Our primary domain controller is ad1.example.com and has
a DFS redirection set up from \\ad1\share\Users to \\files\share\Users.
Mounting \\example.com\share\Users fails.

Regression introduced by commit 724d9f1.

Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru
Signed-off-by: Thomas Hadig <thomas@intapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3368,7 +3368,7 @@ cifs_ra_pages(struct cifs_sb_info *cifs_
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
-	int rc = 0;
+	int rc;
 	int xid;
 	struct cifs_ses *pSesInfo;
 	struct cifs_tcon *tcon;
@@ -3395,6 +3395,7 @@ try_mount_again:
 		FreeXid(xid);
 	}
 #endif
+	rc = 0;
 	tcon = NULL;
 	pSesInfo = NULL;
 	srvTcp = NULL;


