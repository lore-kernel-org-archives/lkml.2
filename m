Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1GJKmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:42:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56953 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1GJKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:42:07 -0400
X-AuditID: b753bd60-a3cafba0000019f4-9a-4e1981fcde66
X-AuditID: b753bd60-a3cafba0000019f4-9a-4e1981fcde66
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 3/5] [BUGFIX] perf probe: Fix to walk all inline instances
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sun, 10 Jul 2011 19:00:27 +0900
Message-ID: <20110710100027.2550.88279.stgit@fedora15>
In-Reply-To: <20110710100005.2550.83138.stgit@fedora15>
References: <20110710100005.2550.83138.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line-range collector to walk all instances of inlined
function, because some execution paths can be optimized out
depends on the function argument of instances.

E.g.)
inline_func (arg) {
	if (arg)
		do_something;
	else
		do_another;
}

func_A() {
	inline_func(1)
}

func_B() {
	inline_func(0)
}

In this case, func_A may have only do_something code and
func_B may have only do_another.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 52b87f3..222ba66 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1932,7 +1932,13 @@ static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 	struct dwarf_callback_param *param = data;
 
 	param->retval = find_line_range_by_line(in_die, param->data);
-	return DWARF_CB_ABORT;	/* No need to find other instances */
+
+	/*
+	 * We have to check all instances of inlined function, because
+	 * some execution paths can be optimized out depends on the
+	 * function argument of instances
+	 */
+	return DWARF_CB_OK;
 }
 
 /* Search function from function name */

