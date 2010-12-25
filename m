Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0LYI6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 03:58:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:51246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab0LYI6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 03:58:38 -0500
Date: Sat, 25 Dec 2010 08:58:14 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        phan@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        phan@redhat.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Look forward for symbol aliases
Message-ID: <tip-d3678758048308049cdad31ec3eae063be17c0db@git.kernel.org>
Git-Commit-ID: d3678758048308049cdad31ec3eae063be17c0db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 25 Dec 2010 08:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3678758048308049cdad31ec3eae063be17c0db
Gitweb:     http://git.kernel.org/tip/d3678758048308049cdad31ec3eae063be17c0db
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 21 Dec 2010 23:38:37 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Dec 2010 20:31:59 -0200

perf test: Look forward for symbol aliases

Not just before, fixing these false positives:

[acme@mica linux]$ perf test -v 1
 1: vmlinux symtab matches kallsyms:
--- start ---
Looking at the vmlinux_path (6 entries long)
Using //lib/modules/2.6.37-rc5-00180-ge06b6bf/build/vmlinux for symbols
0xffffffff81058dc0: diff name v: sys_vm86old k: sys_ni_syscall
0xffffffff81058dc0: diff name v: sys_vm86 k: sys_ni_syscall
0xffffffff81058dc0: diff name v: sys_subpage_prot k: sys_ni_syscall
0xffffffff810b5f7c: diff name v: probe_kernel_write k: __probe_kernel_write
0xffffffff810b5fe5: diff name v: probe_kernel_read k: __probe_kernel_read
0xffffffff811bc380: diff name v: __memset k: memset
0xffffffff81384a98: diff name v: __sched_text_start k: sleep_on_common
0xffffffff81386750: diff name v: __sched_text_end k: _raw_spin_trylock
0xffffffff8138cee8: diff name v: __irqentry_text_start k: do_IRQ
0xffffffff8138f079: diff name v: __start_notes k: _etext
0xffffffff8138f079: diff name v: __stop_notes k: _etext
---- end ----
vmlinux symtab matches kallsyms: FAILED!

[acme@mica linux]$

Some are weak functions, others are just markers, etc. They get in the rb tree
with the same addr, so we need to look around to find the symbol with the same
name.

We were looking just at the previous entries with the same addr, look forward
too.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 035b9fa..e0c3f47 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -119,10 +119,16 @@ static int test__vmlinux_matches_kallsyms(void)
 	 * end addresses too.
 	 */
 	for (nd = rb_first(&vmlinux_map->dso->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pair;
+		struct symbol *pair, *first_pair;
+		bool backwards = true;
 
 		sym  = rb_entry(nd, struct symbol, rb_node);
-		pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
+
+		if (sym->start == sym->end)
+			continue;
+
+		first_pair = machine__find_kernel_symbol(&kallsyms, type, sym->start, NULL, NULL);
+		pair = first_pair;
 
 		if (pair && pair->start == sym->start) {
 next_pair:
@@ -143,8 +149,10 @@ next_pair:
 				pr_debug("%#Lx: diff end addr for %s v: %#Lx k: %#Lx\n",
 					 sym->start, sym->name, sym->end, pair->end);
 			} else {
-				struct rb_node *nnd = rb_prev(&pair->rb_node);
-
+				struct rb_node *nnd;
+detour:
+				nnd = backwards ? rb_prev(&pair->rb_node) :
+						  rb_next(&pair->rb_node);
 				if (nnd) {
 					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
 
@@ -153,6 +161,13 @@ next_pair:
 						goto next_pair;
 					}
 				}
+
+				if (backwards) {
+					backwards = false;
+					pair = first_pair;
+					goto detour;
+				}
+
 				pr_debug("%#Lx: diff name v: %s k: %s\n",
 					 sym->start, sym->name, pair->name);
 			}
