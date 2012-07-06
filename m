Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab2GFLFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:05:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51676 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2GFLFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:05:39 -0400
Date: Fri, 6 Jul 2012 04:05:22 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-7ed97ad41ffa94040dfd593948962a7e9e7b0db9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1341241977-71535-1-git-send-email-dsahern@gmail.com>
References: <1341241977-71535-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm:
  Fix segfault with report and mixed guestmount use
Git-Commit-ID: 7ed97ad41ffa94040dfd593948962a7e9e7b0db9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:05:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ed97ad41ffa94040dfd593948962a7e9e7b0db9
Gitweb:     http://git.kernel.org/tip/7ed97ad41ffa94040dfd593948962a7e9e7b0db9
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 2 Jul 2012 09:12:57 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Jul 2012 14:03:50 -0300

perf kvm: Fix segfault with report and mixed guestmount use

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

The MMAP events in this case already contain the full path to the
module. No need to require it for the report path to.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1341241977-71535-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

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
