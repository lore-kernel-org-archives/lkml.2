Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2GYRpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:45:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2GYRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/19] perf kvm: Set name for VM process in guest machine
Date: Wed, 25 Jul 2012 14:41:17 -0300
Message-Id: <1343238094-12481-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

COMM events are not generated in the context of a guest machine, so the
thread name is never set for the VMM process. For example, the qemu-kvm
name applies to the process in the host machine, not the guest machine.
So, samples for guest machines are currently displayed as:

    99.67%     :5671  [unknown]         [g] 0xffffffff81366b41

where 5671 is the pid of the VMM. With this patch the samples in the guest
machine are shown as:

    18.43%  [guest/5671]  [unknown]           [g] 0xffffffff810d68b7

Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342826756-64663-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

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
1.7.1

