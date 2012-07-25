Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2GYRlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:41:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2GYRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/19] perf kvm: Fix bug resolving guest kernel syms
Date: Wed, 25 Jul 2012 14:41:19 -0300
Message-Id: <1343238094-12481-5-git-send-email-acme@infradead.org>
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

Guest kernel symbols are not resolved despite passing the information
needed to resolve them. e.g.,

perf kvm --guest --guestmount=/tmp/guest-mount record -a -- sleep 1
perf kvm --guest --guestmount=/tmp/guest-mount report --stdio

    36.55%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
    33.19%  [guest/10474]  [unknown]         [g] 0x00000000c0116e00
    30.26%  [guest/11094]  [unknown]         [g] 0xffffffff8100a288
    43.69%  [guest/10474]  [unknown]         [g] 0x00000000c0103d90
    37.38%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
    12.24%  [guest/11094]  [unknown]         [g] 0xffffffff810aa91d
     6.69%  [guest/11094]  [unknown]         [u] 0x00007fa784d721c3

which is just pathetic.

After a maddening 2 days sifting through perf minutia I found it --
id_hdr_size is not initialized for guest machines. This shows up on the
report side as random garbage for the cpu and timestamp, e.g.,

29816 7310572949125804849 0x1ac0 [0x50]: PERF_RECORD_MMAP ...

That messes up the sample sorting such that synthesized guest maps are
processed last.

With this patch you get a much more helpful report:

  12.11%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] irqtime_account_process_tick
  10.58%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] run_timer_softirq
   6.95%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] printk_needs_cpu
   6.50%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] do_timer
   6.45%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] idle_balance
   4.90%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] native_read_tsc
    ...

v2:
- changed rbtree walk to use rb_first per Namhyung's suggestion

Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342826756-64663-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c     |   13 +++++++++++++
 tools/perf/util/map.h     |    1 +
 tools/perf/util/session.c |    1 +
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8668569..16d783d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -729,3 +729,16 @@ char *machine__mmap_name(struct machine *self, char *bf, size_t size)
 
 	return bf;
 }
+
+void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size)
+{
+	struct rb_node *node;
+	struct machine *machine;
+
+	for (node = rb_first(machines); node; node = rb_next(node)) {
+		machine = rb_entry(node, struct machine, rb_node);
+		machine->id_hdr_size = id_hdr_size;
+	}
+
+	return;
+}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index c14c665..03a1e9b 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -151,6 +151,7 @@ struct machine *machines__add(struct rb_root *self, pid_t pid,
 struct machine *machines__find_host(struct rb_root *self);
 struct machine *machines__find(struct rb_root *self, pid_t pid);
 struct machine *machines__findnew(struct rb_root *self, pid_t pid);
+void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size);
 char *machine__mmap_name(struct machine *self, char *bf, size_t size);
 int machine__init(struct machine *self, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *self);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 90ee39d..8e4f075 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -87,6 +87,7 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	machines__set_id_hdr_size(&self->machines, self->id_hdr_size);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
-- 
1.7.1

