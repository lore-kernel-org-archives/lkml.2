Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663Ab2EOCSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:40 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53116 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909Ab2EOCQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 052/179] lockdep: Fix lock_is_held() on recursion
Date: Mon, 14 May 2012 22:12:28 -0400
Message-ID: <1337048075-6132-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d upstream.

The main lock_is_held() user is lockdep_assert_held(), avoid false
assertions in lockdep_off() sections by unconditionally reporting the
lock is taken.

[ the reason this is important is a lockdep_assert_held() in ttwu()
  which triggers a warning under lockdep_off() as in printk() which
  can trigger another wakeup and lock up due to spinlock
  recursion, as reported and heroically debugged by Arne Jansen ]

Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1307398759.2497.966.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..1571452 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3240,7 +3240,7 @@ int lock_is_held(struct lockdep_map *lock)
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
-- 
1.7.9.6

