Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2E3E6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:58:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45154 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2E3E6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:58:34 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH] perf script: fix regression in dso name
Date: Tue, 29 May 2012 22:58:26 -0600
Message-Id: <1338353906-60706-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.7.10.1

