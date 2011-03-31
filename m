Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1CaMmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:42:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1CaMmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:42:35 -0400
Date: Thu, 31 Mar 2011 12:42:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix task_struct reference leak
Message-ID: <tip-fd1edb3aa2c1d92618d8f0c6d15d44ea41fcac6a@git.kernel.org>
Git-Commit-ID: fd1edb3aa2c1d92618d8f0c6d15d44ea41fcac6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:42:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd1edb3aa2c1d92618d8f0c6d15d44ea41fcac6a
Gitweb:     http://git.kernel.org/tip/fd1edb3aa2c1d92618d8f0c6d15d44ea41fcac6a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 28 Mar 2011 13:13:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:02:56 +0200

perf: Fix task_struct reference leak

sys_perf_event_open() had an imbalance in the number of task refs it
took causing memory leakage

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@kernel.org # .37+
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2616909..27960f1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6531,6 +6531,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if (task) {
+		put_task_struct(task);
+		task = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
