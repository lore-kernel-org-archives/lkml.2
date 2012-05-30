Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2E3MY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:24:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2E3MYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:24:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf, tool: Fix 32 bit values endianity swap for sample_id_all header
Date: Wed, 30 May 2012 14:23:44 +0200
Message-Id: <1338380624-7443-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1338380624-7443-1-git-send-email-jolsa@redhat.com>
References: <1338380624-7443-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We swap the sample_id_all header by u64 pointers. Some members
of the header happen to be 32 bit values. We need to handle them
separatelly.

Together with other endianity patches, this change fixies perf report
discrepancies on origin and target systems as described in test 1
below, e.g. following perf report diff:

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
---
 tools/perf/util/evsel.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 57e4ce5..7aa266f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -404,16 +404,24 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
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
 
@@ -433,9 +441,16 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
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
@@ -472,7 +487,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
 			return 0;
-		return perf_event__parse_id_sample(event, type, data);
+		return perf_event__parse_id_sample(event, type, data, swapped);
 	}
 
 	array = event->sample.array;
-- 
1.7.7.6

