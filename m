Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2GBPNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:13:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62580 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2GBPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:13:05 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf kvm: fix segfault with report and mixed guestmount use
Date: Mon,  2 Jul 2012 09:12:57 -0600
Message-Id: <1341241977-71535-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the guestmount option on record:
    $ perf kvm --guest --host --guestmount=/tmp/guest-mount record -ag

But not the subsequent report:
    $ perf kvm report

causes a SEGFAULT in the usual place:
(gdb) bt
0  0x0000000000470356 in machine__mmap_name (self=0x0, bf=0x7fffffffbdb0 " z\370\367\377\177", size=
    4096) at util/map.c:712
1  0x00000000004453e8 in perf_event__process_kernel_mmap (tool=0x7fffffffde10, event=0x7ffff7f87e38,
    machine=0x0) at util/event.c:550
2  0x00000000004458c9 in perf_event__process_mmap (tool=0x7fffffffde10, event=0x7ffff7f87e38, sample=
    0x7fffffffd2a0, machine=0x0) at util/event.c:656
3  0x00000000004733e0 in perf_session_deliver_event (session=0x91aca0, event=0x7ffff7f87e38, sample=
    0x7fffffffd2a0, tool=0x7fffffffde10, file_offset=7736) at util/session.c:979
...

The MMAP events in this case already contain the full path to the module. No
need to require it for the report path to.

Signed-off-by: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/map.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 35ae568..a1f4e36 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -669,25 +669,26 @@ struct machine *machines__find(struct rb_root *self, pid_t pid)
 struct machine *machines__findnew(struct rb_root *self, pid_t pid)
 {
 	char path[PATH_MAX];
-	const char *root_dir;
+	const char *root_dir = "";
 	struct machine *machine = machines__find(self, pid);
 
-	if (!machine || machine->pid != pid) {
-		if (pid == HOST_KERNEL_ID || pid == DEFAULT_GUEST_KERNEL_ID)
-			root_dir = "";
-		else {
-			if (!symbol_conf.guestmount)
-				goto out;
-			sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
-			if (access(path, R_OK)) {
-				pr_err("Can't access file %s\n", path);
-				goto out;
-			}
-			root_dir = path;
+	if (machine && (machine->pid == pid))
+		goto out;
+
+	if ((pid != HOST_KERNEL_ID) &&
+	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
+	    (symbol_conf.guestmount)) {
+		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		if (access(path, R_OK)) {
+			pr_err("Can't access file %s\n", path);
+			machine = NULL;
+			goto out;
 		}
-		machine = machines__add(self, pid, root_dir);
+		root_dir = path;
 	}
 
+	machine = machines__add(self, pid, root_dir);
+
 out:
 	return machine;
 }
-- 
1.7.10.1

