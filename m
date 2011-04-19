Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1DSVEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:04:14 -0400
Received: from kroah.org ([198.145.64.141]:39316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1DSVEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:22 2011
Message-Id: <20110419210322.362418298@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [01/26] cifs: always do is_path_accessible check in cifs_mount
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 70945643722ffeac779d2529a348f99567fa5c33 upstream.

Currently, we skip doing the is_path_accessible check in cifs_mount if
there is no prefixpath. I have a report of at least one server however
that allows a TREE_CONNECT to a share that has a DFS referral at its
root. The reporter in this case was using a UNC that had no prefixpath,
so the is_path_accessible check was not triggered and the box later hit
a BUG() because we were chasing a DFS referral on the root dentry for
the mount.

This patch fixes this by removing the check for a zero-length
prefixpath.  That should make the is_path_accessible check be done in
this situation and should allow the client to chase the DFS referral at
mount time instead.

Reported-and-Tested-by: Yogesh Sharma <ysharma@cymer.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2554,7 +2554,7 @@ try_mount_again:
 
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
-	if (!rc && cifs_sb->prepathlen && tcon) {
+	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(cifs_sb);
 		if (full_path == NULL) {


