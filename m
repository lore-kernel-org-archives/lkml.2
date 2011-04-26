Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1DZVOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:60444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DZVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327338"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jlayton@redhat.com, sfrench@us.ibm.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [53/106] cifs: always do is_path_accessible check in cifs_mount
Message-Id: <20110426211333.81C923E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/cifs/connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/cifs/connect.c
===================================================================
--- linux-2.6.35.y.orig/fs/cifs/connect.c
+++ linux-2.6.35.y/fs/cifs/connect.c
@@ -2606,7 +2606,7 @@ try_mount_again:
 
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
-	if (!rc && cifs_sb->prepathlen && tcon) {
+	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(cifs_sb);
 		if (full_path == NULL) {
