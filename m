Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0ERRt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:49:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:4385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab0ERRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:49:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="519032704"
Subject: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:49:52 +0000
Message-Id: <1274233792.3036.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a temporary patch to show how to use the pmu sysfs interface...

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/builtin-top.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index adc179d..eaa9405 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1206,6 +1206,7 @@ static void start_counter(int i, int counter)
 	struct perf_event_attr *attr;
 	int cpu;
 	int thread_index;
+	int sys_fd;
 
 	cpu = profile_cpu;
 	if (target_tid == -1 && profile_cpu == -1)
@@ -1226,9 +1227,21 @@ static void start_counter(int i, int counter)
 
 	for (thread_index = 0; thread_index < thread_num; thread_index++) {
 try_again:
+		/*
+		 * This is just an ugly demo of how to use the sysfs interface.
+		 * You can also parse the <event-name> and open sys file as,
+		 * sys_fd = open("/sys/devices/system/cpu/events/<event-name>/event_source/id", O_RDONLY);
+		 */
+		sys_fd = open("/sys/devices/system/cpu/event_source/id", O_RDONLY);
+		if (sys_fd != -1)
+			attr->type |= (sys_fd << PERF_EVENT_ATTR_TYPE_BITS) | PERF_EVENT_FD;
+
 		fd[i][counter][thread_index] = sys_perf_event_open(attr,
 				all_tids[thread_index], cpu, group_fd, 0);
 
+		if (sys_fd != -1)
+			close(sys_fd);
+
 		if (fd[i][counter][thread_index] < 0) {
 			int err = errno;
 




