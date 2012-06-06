Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2FFG6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:58:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2FFG6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:58:41 -0400
Date: Tue, 5 Jun 2012 23:58:19 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-52deff71bc2b2c24587ab71f588ff5e4c9279349@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, akihiro.nagai.hw@hitachi.com,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1338353906-60706-1-git-send-email-dsahern@gmail.com>
References: <1338353906-60706-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script:
  Fix regression in callchain dso name
Git-Commit-ID: 52deff71bc2b2c24587ab71f588ff5e4c9279349
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 23:58:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52deff71bc2b2c24587ab71f588ff5e4c9279349
Gitweb:     http://git.kernel.org/tip/52deff71bc2b2c24587ab71f588ff5e4c9279349
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 29 May 2012 22:58:26 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 May 2012 14:24:38 -0300

perf script: Fix regression in callchain dso name

$ perf script -i /tmp/perf.data
...
gcc 13623 544315.062858: context-switches:
    ffffffff815f65c9 __schedule ([kernel.kallsyms])
    ffffffff81087cea __cond_resched ([kernel.kallsyms])
    ffffffff815f6b92 _cond_resched ([kernel.kallsyms])
    ffffffff815fb87a do_page_fault ([kernel.kallsyms])
    ffffffff815f8465 page_fault ([kernel.kallsyms])
        2b7a71ea0303 _dl_lookup_symbol_x ([kernel.kallsyms])
        2b7a71ea1eb5 _dl_relocate_object ([kernel.kallsyms])
        2b7a71e99b2e dl_main ([kernel.kallsyms])
        2b7a71eab7f4 _dl_sysdep_start ([kernel.kallsyms])

All DSO's in a callchain are printed as [kernel.kallsyms].

git bisect chased it to:

547a92e0aedb88129e7fbd804697a11949de2e5a is the first bad commit
commit 547a92e0aedb88129e7fbd804697a11949de2e5a
Author: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Date:   Mon Jan 30 13:42:57 2012 +0900

    perf script: Unify the expressions indicating "unknown"

    The perf script command uses various expressions to indicate "unknown".

    It is unfriendly for user scripts to parse it. So, this patch unifies
    the expressions to "[unknown]".

Looks like a copy-paste in that the other references use al.map but this one
should be node->map.

With this patch you get:

$ perf script -i /tmp/perf.data
...
gcc 13623 544315.062858: context-switches:
    ffffffff815f65c9 __schedule ([kernel.kallsyms])
    ffffffff81087cea __cond_resched ([kernel.kallsyms])
    ffffffff815f6b92 _cond_resched ([kernel.kallsyms])
    ffffffff815fb87a do_page_fault ([kernel.kallsyms])
    ffffffff815f8465 page_fault ([kernel.kallsyms])
        2b7a71ea0303 _dl_lookup_symbol_x (/lib64/ld-2.14.90.so)
        2b7a71ea1eb5 _dl_relocate_object (/lib64/ld-2.14.90.so)
        2b7a71e99b2e dl_main (/lib64/ld-2.14.90.so)
        2b7a71eab7f4 _dl_sysdep_start (/lib64/ld-2.14.90.so)

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1338353906-60706-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 93d355d..4820614 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1460,7 +1460,7 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 			}
 			if (print_dso) {
 				printf(" (");
-				map__fprintf_dsoname(al.map, stdout);
+				map__fprintf_dsoname(node->map, stdout);
 				printf(")");
 			}
 			printf("\n");
