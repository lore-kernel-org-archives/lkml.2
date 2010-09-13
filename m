Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0IMPTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:19:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:42019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0IMPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:19:48 -0400
Date: Mon, 13 Sep 2010 15:19:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix free_event()
Message-ID: <tip-0c67b40872326a5340cab51d79a192a5fbaeb484@git.kernel.org>
Git-Commit-ID: 0c67b40872326a5340cab51d79a192a5fbaeb484
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 15:19:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c67b40872326a5340cab51d79a192a5fbaeb484
Gitweb:     http://git.kernel.org/tip/0c67b40872326a5340cab51d79a192a5fbaeb484
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 13 Sep 2010 11:15:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Sep 2010 17:08:42 +0200

perf: Fix free_event()

With the context rework stuff we can actually end up freeing an event
before it gets attached to a context.

Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bc46bff..440f9ca 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2150,7 +2150,9 @@ static void free_event(struct perf_event *event)
 	if (event->destroy)
 		event->destroy(event);
 
-	put_ctx(event->ctx);
+	if (event->ctx)
+		put_ctx(event->ctx);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
