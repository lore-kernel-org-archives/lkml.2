Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab1CDLvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:51:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440Ab1CDLvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:51:52 -0500
Date: Fri, 4 Mar 2011 11:51:22 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6F346E.9070606@cn.fujitsu.com>
References: <4D6F346E.9070606@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf cgroup: Fix unmatched call to perf_detach_cgroup()
Message-ID: <tip-f75e18cb9627b1d3d752b83a0b5563da0042c50a@git.kernel.org>
Git-Commit-ID: f75e18cb9627b1d3d752b83a0b5563da0042c50a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:51:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f75e18cb9627b1d3d752b83a0b5563da0042c50a
Gitweb:     http://git.kernel.org/tip/f75e18cb9627b1d3d752b83a0b5563da0042c50a
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 3 Mar 2011 14:25:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:51 +0100

perf cgroup: Fix unmatched call to perf_detach_cgroup()

In the failure path, we call perf_detach_cgroup(), but we didn't
call perf_get_cgroup() prio to it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4D6F346E.9070606@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7c999e8..b002095 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -412,6 +412,9 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	cgrp = container_of(css, struct perf_cgroup, css);
 	event->cgrp = cgrp;
 
+	/* must be done before we fput() the file */
+	perf_get_cgroup(event);
+
 	/*
 	 * all events in a group must monitor
 	 * the same cgroup because a task belongs
@@ -420,9 +423,6 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	if (group_leader && group_leader->cgrp != cgrp) {
 		perf_detach_cgroup(event);
 		ret = -EINVAL;
-	} else {
-		/* must be done before we fput() the file */
-		perf_get_cgroup(event);
 	}
 out:
 	fput_light(file, fput_needed);
