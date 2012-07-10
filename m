Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2GJVs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:48:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2GJVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:48:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/4] perf kvm: set name for VM process in guest machine
Date: Tue, 10 Jul 2012 15:48:11 -0600
Message-Id: <1341956894-69284-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
References: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COMM events are generated in the context of a guest machine, so the thread
name is never set for the VMM process. For example, the qemu-kvm name
applies to the process in the host machine. Samples for guest mode are
currently displayed as:

    99.67%     :5671  [unknown]         [g] 0xffffffff81366b41

where 5671 is the pid of the VMM. With this patch the samples in
guest mode are shown as:

    18.43%  [guest/5671]  [unknown]           [g] 0xffffffff810d68b7

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/map.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a1f4e36..8668569 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -7,6 +7,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include "map.h"
+#include "thread.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -585,7 +586,21 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid)
 	self->kmaps.machine = self;
 	self->pid	    = pid;
 	self->root_dir      = strdup(root_dir);
-	return self->root_dir == NULL ? -ENOMEM : 0;
+	if (self->root_dir == NULL)
+		return -ENOMEM;
+
+	if (pid != HOST_KERNEL_ID) {
+		struct thread *thread = machine__findnew_thread(self, pid);
+		char comm[64];
+
+		if (thread == NULL)
+			return -ENOMEM;
+
+		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
+		thread__set_comm(thread, comm);
+	}
+
+	return 0;
 }
 
 static void dsos__delete(struct list_head *self)
-- 
1.7.10.1

