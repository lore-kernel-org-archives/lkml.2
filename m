Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab1FWSPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:15:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:34413 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab1FWRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 099/247] CRED: Fix memory and refcount leaks upon security_prepare_creds() failure
Date: Thu, 23 Jun 2011 13:32:47 -0400
Message-Id: <1308850515-15242-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fb2b2a1d37f80cc818fd4487b510f4e11816e5e1 upstream.

In prepare_kernel_cred() since 2.6.29, put_cred(new) is called without
assigning new->usage when security_prepare_creds() returned an error.  As a
result, memory for new and refcount for new->{user,group_info,tgcred} are
leaked because put_cred(new) won't call __put_cred() unless old->usage == 1.

Fix these leaks by assigning new->usage (and new->subscribers which was added
in 2.6.32) before calling security_prepare_creds().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/cred.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 9a85aee..aa66d6f 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -725,6 +725,8 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	validate_creds(old);
 
 	*new = *old;
+	atomic_set(&new->usage, 1);
+	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_group_info(new->group_info);
 
@@ -742,8 +744,6 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
 
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
 	validate_creds(new);
 	return new;
-- 
1.7.4.4

