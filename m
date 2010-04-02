Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0DBTJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:09:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:38606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab0DBTJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:09:44 -0400
Date: Fri, 2 Apr 2010 19:08:53 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100402165059.23551.95587.stgit@localhost6.localdomain6>
References: <20100402165059.23551.95587.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to close dwarf when failing to analyze it
Message-ID: <tip-75ec5a245c7763c397f31ec8964d0a46c54a7386@git.kernel.org>
Git-Commit-ID: 75ec5a245c7763c397f31ec8964d0a46c54a7386
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:08:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75ec5a245c7763c397f31ec8964d0a46c54a7386
Gitweb:     http://git.kernel.org/tip/75ec5a245c7763c397f31ec8964d0a46c54a7386
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 2 Apr 2010 12:50:59 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:35:44 +0200

perf probe: Fix to close dwarf when failing to analyze it

Fix to close libdw routine when failing to analyze it in
find_perf_probe_point().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100402165059.23551.95587.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 59b0115..a851377 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -818,8 +818,10 @@ int find_perf_probe_point(int fd, unsigned long addr,
 		return -ENOENT;
 
 	/* Find cu die */
-	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie))
-		return -EINVAL;
+	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie)) {
+		ret = -EINVAL;
+		goto end;
+	}
 
 	/* Find a corresponding line */
 	line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)addr);
