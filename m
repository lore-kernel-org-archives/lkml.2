Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1LULwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:52:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab1LULtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:49:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/8] ftrace: Fix possible NULL dereferencing in __ftrace_hash_rec_update
Date: Wed, 21 Dec 2011 12:48:50 +0100
Message-Id: <1324468136-3997-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check the existence of the other_hash before
we touch its count variable.

This issue is hit only when non global ftrace_ops is used.
The global ftrace_ops is initialized with empty hashes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 09007c0..7eb702f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1372,7 +1372,8 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (filter_hash && in_hash && !in_other_hash)
 				match = 1;
 			else if (!filter_hash && in_hash &&
-				 (in_other_hash || !other_hash->count))
+				 (in_other_hash ||
+				  !other_hash || !other_hash->count))
 				match = 1;
 		}
 		if (!match)
-- 
1.7.1

