Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab1FWRgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:34328 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab1FWRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, dann frazier <dann.frazier@canonical.com>,
        Joel Becker <joel.becker@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 093/247] ocfs2_connection_find() returns pointer to bad structure
Date: Thu, 23 Jun 2011 13:32:41 -0400
Message-Id: <1308850515-15242-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dann frazier <dann.frazier@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 226291aa4641fa13cb5dec3bcb3379faa83009e2 upstream.

If ocfs2_live_connection_list is empty, ocfs2_connection_find() will return
a pointer to the LIST_HEAD, cast as a ocfs2_live_connection. This can cause
an oops when ocfs2_control_send_down() dereferences c->oc_conn:

Call Trace:
  [<ffffffffa00c2a3c>] ocfs2_control_message+0x28c/0x2b0 [ocfs2_stack_user]
  [<ffffffffa00c2a95>] ocfs2_control_write+0x35/0xb0 [ocfs2_stack_user]
  [<ffffffff81143a88>] vfs_write+0xb8/0x1a0
  [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
  [<ffffffff811442f1>] sys_write+0x51/0x80
  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b

Fix by explicitly returning NULL if no match is found.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ocfs2/stack_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 2dc57bc..22db114 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -191,7 +191,7 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*
-- 
1.7.4.4

