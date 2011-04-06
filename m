Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1DFLOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:14:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1DFLOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:14:19 -0400
Date: Wed, 6 Apr 2011 11:14:00 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110330092559.2132.78634.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092559.2132.78634.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix to find recursively inlined function
Message-ID: <tip-1d878083c253fb2e2471b39e825447aca66fc05c@git.kernel.org>
Git-Commit-ID: 1d878083c253fb2e2471b39e825447aca66fc05c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 11:14:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d878083c253fb2e2471b39e825447aca66fc05c
Gitweb:     http://git.kernel.org/tip/1d878083c253fb2e2471b39e825447aca66fc05c
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 30 Mar 2011 18:25:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Apr 2011 15:36:47 -0300

perf probe: Fix to find recursively inlined function

Fix die_find_inlinefunc() to return correct innermost inlined function
at given address. Without this fix, it returns the outermost inlined
function.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110330092559.2132.78634.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5473f11..689ab46 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -497,7 +497,20 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem)
 {
-	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
+	Dwarf_Die tmp_die;
+
+	sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr, &tmp_die);
+	if (!sp_die)
+		return NULL;
+
+	/* Inlined function could be recursive. Trace it until fail */
+	while (sp_die) {
+		memcpy(die_mem, sp_die, sizeof(Dwarf_Die));
+		sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr,
+					&tmp_die);
+	}
+
+	return die_mem;
 }
 
 /* Walker on lines (Note: line number will not be sorted) */
