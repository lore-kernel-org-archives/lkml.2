Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1CCGXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:23:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab1CCGXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:23:41 -0500
Message-ID: <4D6F346E.9070606@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 14:25:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] perf cgroup: Fix unmatched call to perf_detach_cgroup()
References: <4D6F3461.6060406@cn.fujitsu.com>
In-Reply-To: <4D6F3461.6060406@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:32,
	Serialize complete at 2011-03-03 14:22:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the failure path, we call perf_detach_cgroup(), but we didn't
call perf_get_cgroup() prio to it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4a955fd..dca92b2 100644
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
-- 
1.6.3
