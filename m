Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2CBKrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:47:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45267 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab2CBKrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:47:20 -0500
Date: Fri, 2 Mar 2012 11:47:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120302104708.GA20012@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 5d85d97c9f6973ba854f35a2d5e80fe68272143e Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

 Thanks,

	Ingo

------------------>
David Ahern (1):
      perf tools: Ensure comm string is properly terminated

Namhyung Kim (2):
      perf/hwbp: Fix a possible memory leak
      perf evlist: Return first evsel for non-sample event on old kernel

Prashanth Nageshappa (2):
      perf probe: Ensure offset provided is not greater than function length
      perf probe: Ensure offset provided is not greater than function length without DWARF info too


 kernel/events/hw_breakpoint.c  |    4 ++--
 tools/perf/util/event.c        |    1 +
 tools/perf/util/evlist.c       |    4 ++++
 tools/perf/util/probe-event.c  |    6 ++++++
 tools/perf/util/probe-finder.c |   12 +++++++++++-
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b7971d6..ee706ce 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -651,10 +651,10 @@ int __init init_hw_breakpoint(void)
 
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
-		if (err_cpu == cpu)
-			break;
 		for (i = 0; i < TYPE_MAX; i++)
 			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+		if (err_cpu == cpu)
+			break;
 	}
 
 	return -ENOMEM;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2044324..2a6f33c 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -74,6 +74,7 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 			if (size >= len)
 				size = len - 1;
 			memcpy(comm, name, size);
+			comm[size] = '\0';
 
 		} else if (memcmp(bf, "Tgid:", 5) == 0) {
 			char *tgids = bf + 5;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3f16e08..ea32a06 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
 			return sid->evsel;
+
+	if (!perf_evlist__sample_id_all(evlist))
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	return NULL;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..e33554a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1867,6 +1867,12 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 			   tev->point.symbol);
 		ret = -ENOENT;
 		goto error;
+	} else if (tev->point.offset > sym->end - sym->start) {
+		pr_warning("Offset specified is greater than size of %s\n",
+			   tev->point.symbol);
+		ret = -ENOENT;
+		goto error;
+
 	}
 
 	return 1;
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..74bd2e6 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -672,7 +672,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 				  bool retprobe, struct probe_trace_point *tp)
 {
-	Dwarf_Addr eaddr;
+	Dwarf_Addr eaddr, highaddr;
 	const char *name;
 
 	/* Copy the name of probe point */
@@ -683,6 +683,16 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 				   dwarf_diename(sp_die));
 			return -ENOENT;
 		}
+		if (dwarf_highpc(sp_die, &highaddr) != 0) {
+			pr_warning("Failed to get end address of %s\n",
+				   dwarf_diename(sp_die));
+			return -ENOENT;
+		}
+		if (paddr > highaddr) {
+			pr_warning("Offset specified is greater than size of %s\n",
+				   dwarf_diename(sp_die));
+			return -EINVAL;
+		}
 		tp->symbol = strdup(name);
 		if (tp->symbol == NULL)
 			return -ENOMEM;
