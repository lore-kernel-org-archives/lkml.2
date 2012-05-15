Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab2EOCRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52818 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab2EOCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 011/179] jbd: Fix forever sleeping process in do_get_write_access()
Date: Mon, 14 May 2012 22:11:47 -0400
Message-ID: <1337048075-6132-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2842bb20eed2e25cde5114298edc62c8883a1d9a upstream.

In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
from shadow state. The waking code in journal_commit_transaction() has
a bug because it does not issue a memory barrier after the buffer is moved
from the shadow state and before wake_up_bit() is called. Thus a waitqueue
check can happen before the buffer is actually moved from the shadow state
and waiting process may never be woken. Fix the problem by issuing proper
barrier.

Reported-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd/commit.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index ecb44c9..1df9270 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -745,8 +745,13 @@ wait_for_iobuf:
                    required. */
 		JBUFFER_TRACE(jh, "file as BJ_Forget");
 		journal_file_buffer(jh, commit_transaction, BJ_Forget);
-		/* Wake up any transactions which were waiting for this
-		   IO to complete */
+		/*
+		 * Wake up any transactions which were waiting for this
+		 * IO to complete. The barrier must be here so that changes
+		 * by journal_file_buffer() take effect before wake_up_bit()
+		 * does the waitqueue check.
+		 */
+		smp_mb();
 		wake_up_bit(&bh->b_state, BH_Unshadow);
 		JBUFFER_TRACE(jh, "brelse shadowed buffer");
 		__brelse(bh);
-- 
1.7.9.6

