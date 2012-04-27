Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2D0Hlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:41:35 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40060 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2D0Hld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:41:33 -0400
Message-ID: <4F9A4DA6.8060507@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 15:41:26 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [PATCH 2/2] linsched: add the ability to read proc setting from proc.conf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042707-8878-0000-0000-000002326E89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add the ability to read proc setting from: 
tools/linsched/tests/proc.conf

The style in the proc.conf is like: 
proname value

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/linux_linsched.c |   30 ++++++++++++++++++++++++++++++
 tools/linsched/tests/proc.conf  |    5 +++++
 2 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 tools/linsched/tests/proc.conf

diff --git a/tools/linsched/linux_linsched.c b/tools/linsched/linux_linsched.c
index 6c24578..81825b9 100644
--- a/tools/linsched/linux_linsched.c
+++ b/tools/linsched/linux_linsched.c
@@ -76,6 +76,35 @@ void linsched_init_root_cgroup(struct cgroup *root)
 
 void init_stop_tasks(void);
 
+#define PROC_CONFIGURE_PATH	"./proc.conf"
+#define CONFIGURE_BUFFER_SIZE	77
+#define CONFIGURE_MAX_LINE	77
+void linsched_read_proc_configure(void)
+{
+	int line = 0;
+	char buffer[CONFIGURE_BUFFER_SIZE];
+	char procname[CONFIGURE_BUFFER_SIZE];
+	unsigned long value;
+	
+	FILE *file = fopen(PROC_CONFIGURE_PATH, "r");
+	if (!file) {
+		return;
+	}
+
+	while (fgets(buffer, CONFIGURE_BUFFER_SIZE, file)
+		&& line < CONFIGURE_MAX_LINE) {
+		line++;	
+		if (buffer[0] == '#')
+			continue;
+		if (!sscanf(buffer, "%s %lu", procname, &value))
+			goto out;
+		set_linsched_proc(procname, value);
+	}
+
+out:
+	fclose(file);
+}
+
 void linsched_init(struct linsched_topology *topo)
 {
 	curr_task_id = 1;
@@ -98,6 +127,7 @@ void linsched_init(struct linsched_topology *topo)
 
 	init_lb_info();
 	init_stop_tasks();
+	linsched_read_proc_configure();
 }
 
 void linsched_default_callback(void)
diff --git a/tools/linsched/tests/proc.conf b/tools/linsched/tests/proc.conf
new file mode 100644
index 0000000..b7276da
--- /dev/null
+++ b/tools/linsched/tests/proc.conf
@@ -0,0 +1,5 @@
+#style: procname value
+sched_child_runs_first 1;
+sched_latency_ns 6000000;
+sched_min_granularity_ns 750000;
+sched_wakeup_granularity_ns 1000000;
-- 
1.7.1

