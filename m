Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1HNPnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1HNPnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:43:21 -0400
Date: Sun, 14 Aug 2011 15:42:55 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-36c0c588b9ea979b619d6ddced410f9551e4c5fa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        penberg@kernel.org, masami.hiramatsu@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, masami.hiramatsu@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811110247.19900.93702.stgit@fedora15>
References: <20110811110247.19900.93702.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to walk all inline instances
Git-Commit-ID: 36c0c588b9ea979b619d6ddced410f9551e4c5fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36c0c588b9ea979b619d6ddced410f9551e4c5fa
Gitweb:     http://git.kernel.org/tip/36c0c588b9ea979b619d6ddced410f9551e4c5fa
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 11 Aug 2011 20:02:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 09:25:38 -0300

perf probe: Fix to walk all inline instances

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
