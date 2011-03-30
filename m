Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1C3Jcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41649 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1C3Jco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:44 -0400
X-AuditID: b753bd60-a274aba0000001d0-d2-4d92f8b97530
X-AuditID: b753bd60-a274aba0000001d0-d2-4d92f8b97530
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 04/12] [BUGFIX]perf probe: Fix to find recursively
	inlined function
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:25:59 +0900
Message-ID: <20110330092559.2132.78634.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix die_find_inlinefunc() to return correct innermost inlined
function at given address. Without this fix, it returns the
outermost inlined function.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 8bb50b9..d6cf0ac 100644
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

