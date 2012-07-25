Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2GYTTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:19:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2GYTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:19:29 -0400
Date: Wed, 25 Jul 2012 12:19:10 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-adb5d2a487c55e5ca2ecc0b73c8f592e95d292c7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1342826756-64663-5-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix bug resolving guest kernel syms
Git-Commit-ID: adb5d2a487c55e5ca2ecc0b73c8f592e95d292c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:19:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adb5d2a487c55e5ca2ecc0b73c8f592e95d292c7
Gitweb:     http://git.kernel.org/tip/adb5d2a487c55e5ca2ecc0b73c8f592e95d292c7
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 20 Jul 2012 17:25:49 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:30:13 -0300

perf kvm: Fix bug resolving guest kernel syms

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
