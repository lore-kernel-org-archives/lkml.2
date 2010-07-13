Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0GMWaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:30:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57765 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0GMWaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:30:22 -0400
Date: Tue, 13 Jul 2010 15:30:21 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Yama: verify inode is symlink to avoid bind mounts
Message-ID: <20100713223021.GK6104@outflux.net>
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
 security/yama/yama_lsm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 3b76386..c70eb10 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -116,6 +116,10 @@ static int yama_inode_follow_link(struct dentry *dentry,
 	if (!protected_sticky_symlinks)
 		return 0;
 
+	/* if inode isn't a symlink, don't try to evaluate blocking it */
+	if (!S_ISLNK(inode->i_mode))
+		return 0;
+
 	/* owner and follower match? */
 	cred = current_cred();
 	inode = dentry->d_inode;
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
