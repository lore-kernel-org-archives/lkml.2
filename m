Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2KLRen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:34:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab2KLRei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:34:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf tool: Omit group members from perf_evlist__disable/enable
Date: Mon, 12 Nov 2012 18:34:03 +0100
Message-Id: <1352741644-16809-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to disable/enable ordinary group member events,
because they are initialy enabled and get scheduled by the leader.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 04acae0..e9d2d5d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -222,6 +222,8 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
+			if (pos->leader)
+				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
@@ -236,6 +238,8 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
+			if (pos->leader)
+				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
-- 
1.7.11.7

