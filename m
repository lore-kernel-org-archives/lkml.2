Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2IDIRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:17:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2400 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab2IDIRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:17:13 -0400
From: Andrew Vagin <avagin@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: criu@openvz.org, linux-kernel@vger.kernel.org, avagin@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] kernel: limit a value of ns_last_pid to (0, max_pid)
Date: Tue,  4 Sep 2012 12:17:12 +0400
Message-Id: <1346746632-3025128-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel doesn't check pid on a negative values, so if
you would try to write -2 in /proc/sys/kernel/ns_last_pid,
you will get a kernel panic.

In this case the next pid is -1, and alloc_pidmap will try to access
to a nonexistent pidmap.

map = &pid_ns->pidmap[pid/BITS_PER_PAGE];

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/pid_namespace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index b3c7fd5..6144bab 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -232,15 +232,19 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 	 */
 
 	tmp.data = &current->nsproxy->pid_ns->last_pid;
-	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 }
 
+extern int pid_max;
+static int zero = 0;
 static struct ctl_table pid_ns_ctl_table[] = {
 	{
 		.procname = "ns_last_pid",
 		.maxlen = sizeof(int),
 		.mode = 0666, /* permissions are checked in the handler */
 		.proc_handler = pid_ns_ctl_handler,
+		.extra1 = &zero,
+		.extra2 = &pid_max,
 	},
 	{ }
 };
-- 
1.7.1

