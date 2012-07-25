Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GYTRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:17:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2GYTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:17:41 -0400
Date: Wed, 25 Jul 2012 12:17:25 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-5cd95c2db479aa7a66f6fa572dfa410c6314c78e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1342826756-64663-3-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Set name for VM process in guest machine
Git-Commit-ID: 5cd95c2db479aa7a66f6fa572dfa410c6314c78e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:17:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cd95c2db479aa7a66f6fa572dfa410c6314c78e
Gitweb:     http://git.kernel.org/tip/5cd95c2db479aa7a66f6fa572dfa410c6314c78e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 20 Jul 2012 17:25:47 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:27:55 -0300

perf kvm: Set name for VM process in guest machine

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
