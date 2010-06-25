Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0FYCSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 22:18:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0FYCSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 22:18:38 -0400
Message-ID: <4C24119B.60200@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 10:16:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl
Subject: [PATCH 2/3] perf: Remove dead code in buildin-record.c
References: <4C241140.9090008@cn.fujitsu.com>
In-Reply-To: <4C241140.9090008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

group_fd related code is dead here, remove them.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 tools/perf/builtin-record.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index abaf0f8..84d58b7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -45,7 +45,6 @@ static int			freq				=   1000;
 static int			output;
 static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
-static int			group				=      0;
 static int			realtime_prio			=      0;
 static bool			raw_samples			=  false;
 static bool			system_wide			=  false;
@@ -203,8 +202,6 @@ static void sig_atexit(void)
 	kill(getpid(), signr);
 }
 
-static int group_fd;
-
 static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int nr)
 {
 	struct perf_header_attr *h_attr;
@@ -291,7 +288,7 @@ static void create_counter(int counter, int cpu)
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
 		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
-				all_tids[thread_index], cpu, group_fd, 0);
+				all_tids[thread_index], cpu, -1, 0);
 
 		if (fd[nr_cpu][counter][thread_index] < 0) {
 			int err = errno;
@@ -359,12 +356,6 @@ try_again:
 		assert(fd[nr_cpu][counter][thread_index] >= 0);
 		fcntl(fd[nr_cpu][counter][thread_index], F_SETFL, O_NONBLOCK);
 
-		/*
-		 * First counter acts as the group leader:
-		 */
-		if (group && group_fd == -1)
-			group_fd = fd[nr_cpu][counter][thread_index];
-
 		if (counter || thread_index) {
 			ret = ioctl(fd[nr_cpu][counter][thread_index],
 					PERF_EVENT_IOC_SET_OUTPUT,
@@ -406,7 +397,6 @@ static void open_counters(int cpu)
 {
 	int counter;
 
-	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
 		create_counter(counter, cpu);
 
-- 1.6.5.2 
