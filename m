Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1KDJ3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:29:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50489 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1KDJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:28:59 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, bp@alien8.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 4/4] lockdep: fix race condition in __lock_set_class()
Date: Fri,  4 Nov 2011 17:26:30 +0800
Message-Id: <1320398790-21663-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When someone call lock_set_class() with valid key, nothing
protect the initializing of 'lockdep_map'; thus could lead
to flase positive warning from lockdep (such as "key not in
.data!"). This patch cure that potential issue.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3af87ad..fd4d816 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3290,8 +3290,12 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 found_it:
 	/* optimizing for lock_set_subclass() */
 	if (key) {
-		lockdep_init_map(lock, name, key, 0);
-		register_lock_class(lock, subclass, 0, 0);
+		if (!graph_lock())
+			return 0;
+
+		__lockdep_init_map(lock, name, key, 0);
+		/* will release graph_lock() there */
+		register_lock_class(lock, subclass, 0, 1);
 	}
 
 	curr->lockdep_depth = i;
-- 
1.7.5.4

