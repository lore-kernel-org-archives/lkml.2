Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2HOT6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:58:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:37399 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab2HOTwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 122/165] NFS/sunrpc: don't use a credential with extra groups.
Date: Wed, 15 Aug 2012 15:47:46 -0400
Message-ID: <1345060109-9187-123-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dc6f55e9f8dac4b6479be67c5c9128ad37bb491f upstream.

The sunrpc layer keeps a cache of recently used credentials and
'unx_match' is used to find the credential which matches the current
process.

However unx_match allows a match when the cached credential has extra
groups at the end of uc_gids list which are not in the process group list.

So if a process with a list of (say) 4 group accesses a file and gains
access because of the last group in the list, then another process
with the same uid and gid, and a gid list being the first tree of the
gids of the original process tries to access the file, it will be
granted access even though it shouldn't as the wrong rpc credential
will be used.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/auth_unix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index aac2f8b..c16f25d 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -130,6 +130,9 @@ unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
 	for (i = 0; i < groups ; i++)
 		if (cred->uc_gids[i] != GROUP_AT(acred->group_info, i))
 			return 0;
+	if (groups < NFS_NGROUPS &&
+	    cred->uc_gids[groups] != NOGROUP)
+		return 0;
 	return 1;
 }
 
-- 
1.7.12.rc2

