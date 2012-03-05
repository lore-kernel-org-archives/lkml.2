Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2CEJ1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:27:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45642 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab2CEJ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:27:41 -0500
Date: Mon, 5 Mar 2012 10:27:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120305092732.GA11197@elte.hu>
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

   HEAD: b7c924274c456499264d1cfa3d44063bb11eb5db Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

It contains three cherry-picked fixes from perf/core, which 
turned out to be more urgent than we originally thought.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf tools: Handle kernels that don't support attr.exclude_{guest,host}

David Ahern (1):
      perf record: No build id option fails

Joerg Roedel (1):
      perf tools: Change perf_guest default back to false


 tools/perf/builtin-record.c |   33 ++++++++++++++++++++++-----------
 tools/perf/builtin-top.c    |   23 +++++++++++++++++------
 tools/perf/perf.h           |    1 +
 tools/perf/util/top.h       |    1 +
 tools/perf/util/util.c      |    2 +-
 5 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0abfb18..227b6ae 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -204,6 +204,9 @@ static void perf_record__open(struct perf_record *rec)
 
 		if (opts->group && pos != first)
 			group_fd = first->fd;
+fallback_missing_features:
+		if (opts->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -217,15 +220,23 @@ try_again:
 			} else if (err ==  ENODEV && opts->cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == EINVAL && opts->sample_id_all_avail) {
-				/*
-				 * Old kernel, no attr->sample_id_type_all field
-				 */
-				opts->sample_id_all_avail = false;
-				if (!opts->sample_time && !opts->raw_samples && !time_needed)
-					attr->sample_type &= ~PERF_SAMPLE_TIME;
-
-				goto retry_sample_id;
+			} else if (err == EINVAL) {
+				if (!opts->exclude_guest_missing &&
+				    (attr->exclude_guest || attr->exclude_host)) {
+					pr_debug("Old kernel, cannot exclude "
+						 "guest or host samples.\n");
+					opts->exclude_guest_missing = true;
+					goto fallback_missing_features;
+				} else if (opts->sample_id_all_avail) {
+					/*
+					 * Old kernel, no attr->sample_id_type_all field
+					 */
+					opts->sample_id_all_avail = false;
+					if (!opts->sample_time && !opts->raw_samples && !time_needed)
+						attr->sample_type &= ~PERF_SAMPLE_TIME;
+
+					goto retry_sample_id;
+				}
 			}
 
 			/*
@@ -503,9 +514,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			return err;
 	}
 
-	if (!!rec->no_buildid
+	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
-		pr_err("Couldn't generating buildids. "
+		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd162aa..ecff312 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -857,6 +857,9 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = top->inherit;
+fallback_missing_features:
+		if (top->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -868,12 +871,20 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
-			} else if (err == EINVAL && top->sample_id_all_avail) {
-				/*
-				 * Old kernel, no attr->sample_id_type_all field
-				 */
-				top->sample_id_all_avail = false;
-				goto retry_sample_id;
+			} else if (err == EINVAL) {
+				if (!top->exclude_guest_missing &&
+				    (attr->exclude_guest || attr->exclude_host)) {
+					pr_debug("Old kernel, cannot exclude "
+						 "guest or host samples.\n");
+					top->exclude_guest_missing = true;
+					goto fallback_missing_features;
+				} else if (top->sample_id_all_avail) {
+					/*
+					 * Old kernel, no attr->sample_id_type_all field
+					 */
+					top->sample_id_all_avail = false;
+					goto retry_sample_id;
+				}
 			}
 			/*
 			 * If it's cycles then fall back to hrtimer
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 64f8bee..16e7d20 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -199,6 +199,7 @@ struct perf_record_opts {
 	bool	     sample_address;
 	bool	     sample_time;
 	bool	     sample_id_all_avail;
+	bool	     exclude_guest_missing;
 	bool	     system_wide;
 	bool	     period;
 	unsigned int freq;
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index a248f3c..f2eab81 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -34,6 +34,7 @@ struct perf_top {
 	bool		   inherit;
 	bool		   group;
 	bool		   sample_id_all_avail;
+	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..fb25d13 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = true;
+bool perf_guest = false;
 
 void event_attr_init(struct perf_event_attr *attr)
 {
