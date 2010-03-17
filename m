Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0CQLbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:31:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:36229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab0CQLbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:31:32 -0400
Date: Wed, 17 Mar 2010 11:30:29 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
References: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix !dwarf build
Message-ID: <tip-3b0d516463f8deb897a55cb81e9dbbe58a2490ed@git.kernel.org>
Git-Commit-ID: 3b0d516463f8deb897a55cb81e9dbbe58a2490ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 11:30:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b0d516463f8deb897a55cb81e9dbbe58a2490ed
Gitweb:     http://git.kernel.org/tip/3b0d516463f8deb897a55cb81e9dbbe58a2490ed
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 17 Mar 2010 12:13:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 12:13:28 +0100

perf probe: Fix !dwarf build

Fix the !drawf build.

This uses the existing NO_DWARF_SUPPORT mechanism we use for that,
but it's really fragile and needs a cleanup. (in a separate patch)

1) Such uses:

 #ifndef NO_DWARF_SUPPORT

are double inverted logic a'la 'not not'. Instead the flag should
be called DWARF_SUPPORT.

2) Furthermore, assymetric #ifdef polluted code flow like:

        if (need_dwarf)
 #ifdef NO_DWARF_SUPPORT
                die("Debuginfo-analysis is not supported");
 #else   /* !NO_DWARF_SUPPORT */
                pr_debug("Some probes require debuginfo.\n");

        fd = open_vmlinux();

is very fragile and not acceptable. Instead of that helper functions
should be created and the dwarf/no-dwarf logic should be separated more
cleanly.

3) Local variable #ifdefs like this:

 #ifndef NO_DWARF_SUPPORT
        int fd;
 #endif

Are fragile as well and should be eliminated. Helper functions achieve
that too.

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 64dea6c..f333269 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1012,8 +1012,10 @@ end_dwarf:
 	if (!sym)
 		die("Kernel symbol \'%s\' not found - probe not added.",
 		    tev->point.symbol);
+#ifndef NO_DWARF_SUPPORT
 found:
 	close(fd);
+#endif
 	return ntevs;
 }
 
@@ -1172,10 +1174,13 @@ void show_line_range(struct line_range *lr)
 	unsigned int l = 1;
 	struct line_node *ln;
 	FILE *fp;
+#ifndef NO_DWARF_SUPPORT
 	int fd, ret;
+#endif
 
 	/* Search a line range */
 	init_vmlinux();
+#ifndef NO_DWARF_SUPPORT
 	fd = open_vmlinux();
 	if (fd < 0)
 		die("Could not open debuginfo file.");
@@ -1183,6 +1188,7 @@ void show_line_range(struct line_range *lr)
 	if (ret <= 0)
 		die("Source line is not found.\n");
 	close(fd);
+#endif
 
 	setup_pager();
 
