Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab1HLQb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:31:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1HLQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/12] perf probe: Fix to walk all inline instances
Date: Fri, 12 Aug 2011 13:28:59 -0300
Message-Id: <1313166544-6209-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix line-range collector to walk all instances of inlined function,
because some execution paths can be optimized out depending on the
function argument of instances.

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

In this case, func_A may have only do_something code and func_B may have
only do_another.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110247.19900.93702.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 573c723..d6d5768 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1393,7 +1393,13 @@ static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
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
-- 
1.6.2.5

