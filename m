Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2FFHH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:07:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2FFHH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:07:27 -0400
Date: Wed, 6 Jun 2012 00:07:01 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-37073f9e449bc430e6c40b9cffc2558002a0256a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1338380624-7443-4-git-send-email-jolsa@redhat.com>
References: <1338380624-7443-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel:
  Fix 32 bit values endianity swap for sample_id_all header
Git-Commit-ID: 37073f9e449bc430e6c40b9cffc2558002a0256a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:07:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37073f9e449bc430e6c40b9cffc2558002a0256a
Gitweb:     http://git.kernel.org/tip/37073f9e449bc430e6c40b9cffc2558002a0256a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 30 May 2012 14:23:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 11:59:01 -0300

perf evsel: Fix 32 bit values endianity swap for sample_id_all header

We swap the sample_id_all header by u64 pointers. Some members of the
header happen to be 32 bit values. We need to handle them separatelly.

Together with other endianity patches, this change fixies perf report
discrepancies on origin and target systems as described in test 1 below,
e.g. following perf report diff:

...
      0.12%               ps  [kernel.kallsyms]    [k] clear_page
-     0.12%              awk  bash                 [.] alloc_word_desc
+     0.12%              awk  bash                 [.] yyparse
      0.11%   beah-rhts-task  libpython2.6.so.1.0  [.] 0x5560e
      0.10%             perf  libc-2.12.so         [.] __ctype_toupper_loc
-     0.09%  rhts-test-runne  bash                 [.] maybe_make_export_env
+     0.09%  rhts-test-runne  bash                 [.] 0x385a0
      0.09%               ps  [kernel.kallsyms]    [k] page_fault
...

Note, running following to test perf endianity handling:
test 1)
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338380624-7443-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 91d1913..9f6cebd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -494,16 +494,24 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
-				       struct perf_sample *sample)
+				       struct perf_sample *sample,
+				       bool swapped)
 {
 	const u64 *array = event->sample.array;
+	union u64_swap u;
 
 	array += ((event->header.size -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
 	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		sample->cpu = *p;
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+		}
+
+		sample->cpu = u.val32[0];
 		array--;
 	}
 
@@ -523,9 +531,16 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		sample->pid = p[0];
-		sample->tid = p[1];
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+		}
+
+		sample->pid = u.val32[0];
+		sample->tid = u.val32[1];
 	}
 
 	return 0;
@@ -562,7 +577,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
 			return 0;
-		return perf_event__parse_id_sample(event, type, data);
+		return perf_event__parse_id_sample(event, type, data, swapped);
 	}
 
 	array = event->sample.array;
