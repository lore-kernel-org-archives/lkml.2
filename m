Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2GNHv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:51:58 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62520 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2GNHv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:51:56 -0400
Date: Sat, 14 Jul 2012 09:51:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120714075150.GA9580@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 25c037d64e7a0a8effb562babb2b6218829134ac Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent

 Thanks,

	Ingo

------------------>
David Ahern (3):
      perf script: Fix format regression due to libtraceevent merge
      perf kvm: Fix regression with guest machine creation
      perf kvm: Fix segfault with report and mixed guestmount use

Vaibhav Nagarnaik (2):
      ring-buffer: Fix crash due to uninitialized new_pages list head
      ring-buffer: Fix accounting of entries when removing pages


 kernel/trace/ring_buffer.c          |    6 +++---
 tools/perf/util/map.c               |   29 +++++++++++++++--------------
 tools/perf/util/session.c           |    2 +-
 tools/perf/util/trace-event-parse.c |    3 +--
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..f765465 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1075,6 +1075,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	INIT_LIST_HEAD(&cpu_buffer->new_pages);
 
 	ret = rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
@@ -1346,10 +1347,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
 			 * If something was added to this page, it was full
 			 * since it is not the tail page. So we deduct the
 			 * bytes consumed in ring buffer from here.
-			 * No need to update overruns, since this page is
-			 * deleted from ring buffer and its entries are
-			 * already accounted for.
+			 * Increment overrun to account for the lost events.
 			 */
+			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 		}
 
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
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c3e399b..56142d0 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -926,7 +926,7 @@ static struct machine *
 		else
 			pid = event->ip.pid;
 
-		return perf_session__find_machine(session, pid);
+		return perf_session__findnew_machine(session, pid);
 	}
 
 	return perf_session__find_host_machine(session);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..5dd3b5e 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -198,9 +198,8 @@ void print_trace_event(int cpu, void *data, int size)
 	record.data = data;
 
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
+	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
-	printf("\n");
 }
 
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
