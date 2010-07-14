Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0GNGSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:18:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53564 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0GNGSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:18:46 -0400
Date: Tue, 13 Jul 2010 23:18:45 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Yama: verify inode is symlink to avoid bind mounts
Message-ID: <20100714061845.GW6104@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode_follow_link LSM hook is called in bind mount situations as
well as for symlink situations, so we must explicitly check for the
inode being a symlink to not reject bind mounts in 1777 directories,
which seems to be a common NFSv4 configuration.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
v2:
 - actually set inode in time to use it.  *face palm*
---
 security/yama/yama_lsm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 3b76386..51c6a3a 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -116,9 +116,13 @@ static int yama_inode_follow_link(struct dentry *dentry,
 	if (!protected_sticky_symlinks)
 		return 0;
 
+	/* if inode isn't a symlink, don't try to evaluate blocking it */
+	inode = dentry->d_inode;
+	if (!S_ISLNK(inode->i_mode))
+		return 0;
+
 	/* owner and follower match? */
 	cred = current_cred();
-	inode = dentry->d_inode;
 	if (cred->fsuid == inode->i_uid)
 		return 0;
 
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
