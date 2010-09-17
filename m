Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0IQL2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:28:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab0IQL2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:28:31 -0400
Date: Fri, 17 Sep 2010 11:27:49 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100917093009.360420946@chello.nl>
References: <20100917093009.360420946@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix broken event grouping
Message-ID: <tip-d14b12d7adbf214f33eb59f800b5c3d5ed9268e8@git.kernel.org>
Git-Commit-ID: d14b12d7adbf214f33eb59f800b5c3d5ed9268e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 11:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d14b12d7adbf214f33eb59f800b5c3d5ed9268e8
Gitweb:     http://git.kernel.org/tip/d14b12d7adbf214f33eb59f800b5c3d5ed9268e8
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 17 Sep 2010 11:28:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Sep 2010 12:48:47 +0200

perf_events: Fix broken event grouping

Events were not grouped anymore. The reason was that in
perf_event_open(), the field event->group_leader was
initialized before the function looked up the group_fd
to find the event leader. This patch fixes this by
reordering the code correctly.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <20100917093009.360420946@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 86f394e..ce95617 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5550,17 +5550,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (event_fd < 0)
 		return event_fd;
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
-	if (IS_ERR(event)) {
-		err = PTR_ERR(event);
-		goto err_fd;
-	}
-
 	if (group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
 			err = PTR_ERR(group_leader);
-			goto err_alloc;
+			goto err_fd;
 		}
 		group_file = group_leader->filp;
 		if (flags & PERF_FLAG_FD_OUTPUT)
@@ -5569,6 +5563,12 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
+	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
+		goto err_fd;
+	}
+
 	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
@@ -5653,7 +5653,6 @@ err_context:
 	put_ctx(ctx);
 err_group_fd:
 	fput_light(group_file, fput_needed);
-err_alloc:
 	free_event(event);
 err_fd:
 	put_unused_fd(event_fd);
