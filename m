Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2EUHkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:40:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2EUHka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:40:30 -0400
Date: Mon, 21 May 2012 00:39:59 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-a0187060f4ab68cf1aa533446b906cae5b14eb48@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1337151548-2396-8-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Fix callchain ip printf format
Git-Commit-ID: a0187060f4ab68cf1aa533446b906cae5b14eb48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:40:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0187060f4ab68cf1aa533446b906cae5b14eb48
Gitweb:     http://git.kernel.org/tip/a0187060f4ab68cf1aa533446b906cae5b14eb48
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 16 May 2012 08:59:08 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 May 2012 13:18:19 -0300

perf hists: Fix callchain ip printf format

The callchain address is stored as u64. Current code uses following
format string to display callchain address:

  "%p\n", (void *)(long)chain->ip

This way we lose upper 32 bits if we report 64 bit addresses in 32 bit
environment. Fixing this to always display whole 64 bits.

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
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337151548-2396-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9f6d630..1293b5e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -599,7 +599,7 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 	if (chain->ms.sym)
 		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
 	else
-		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);
 
 	return ret;
 }
