Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2BNOjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:39:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:53887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2BNOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:39:37 -0500
Date: Tue, 14 Feb 2012 12:38:53 -0200
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20120214143853.GC28614@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
 <4F39CBE0.6050806@gmail.com>
 <4F39D00D.2060206@gmail.com>
 <4F39ECDB.5090609@lge.com>
 <4F39EFBB.2010301@gmail.com>
 <20120214105018.GV22598@amd.com>
 <20120214131046.GA28614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214131046.GA28614@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 14, 2012 at 11:10:46AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Feb 14, 2012 at 11:50:18AM +0100, Joerg Roedel escreveu:
> > On Mon, Feb 13, 2012 at 10:23:07PM -0700, David Ahern wrote:
> > > On 2/13/12 10:10 PM, Namhyung Kim wrote:
> > > >It happened because I used old kernel version that isn't aware of the
> > > >exclude_guest bit. So the check on attr->__reserved_1 in
> > > >core.c::perf_copy_attr() failed and then ended up seeing EINVAL at
> > > >perf_evsel__open().
> 
> > > comes back to 1aed2671738785e8f5aea663a6fda91aa7ef59b5 again. See
> 
> > > https://lkml.org/lkml/2012/2/8/234
> 
> > Grr. I totally forgot that issue. Is there some way to detect the perf
> > kernel-features? Otherwise the only fix seems to be to drop the patch
> > changing the default. The crashes should be fixed by the other patch
> > already.
> 
> Well, we need to detect it like we do with sample_id_all. In this case
> we would try with exclude_guest, if it fails with EINVAL, we realise it
> is not available, clean that bit and try again.

The following patch should fix it, still untested tho, booting a machine
with an < 3.1 kernel to check...

- Arnaldo

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 08ed24b..d6c10e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -205,6 +205,9 @@ static void perf_record__open(struct perf_record *rec)
 
 		if (opts->group && pos != first)
 			group_fd = first->fd;
+fallback_missing_features:
+		if (opts->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -218,15 +221,23 @@ try_again:
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
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5a88c0d..02e11ff 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -872,6 +872,9 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = top->inherit;
+fallback_missing_features:
+		if (top->exclude_guest_missing)
+			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_avail ? 1 : 0;
 try_again:
@@ -883,12 +886,20 @@ try_again:
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
index 03a0456..8b9c436 100644
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
index 49eb848..7dea891 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -35,6 +35,7 @@ struct perf_top {
 	bool		   inherit;
 	bool		   group;
 	bool		   sample_id_all_avail;
+	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	const char	   *cpu_list;
 	struct hist_entry  *sym_filter_entry;
