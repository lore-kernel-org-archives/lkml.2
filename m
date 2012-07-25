Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2GYTRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:17:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2GYTRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:17:22 -0400
Date: Wed, 25 Jul 2012 12:16:32 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-f51304d3fe4fee475991ee424a4b7f85eec65a7b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1342826756-64663-2-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Add machine id to modules debug message
Git-Commit-ID: f51304d3fe4fee475991ee424a4b7f85eec65a7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:16:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f51304d3fe4fee475991ee424a4b7f85eec65a7b
Gitweb:     http://git.kernel.org/tip/f51304d3fe4fee475991ee424a4b7f85eec65a7b
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 20 Jul 2012 17:25:46 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Jul 2012 15:03:48 -0300

perf symbols: Add machine id to modules debug message

Current debug message is:
Problems creating module maps, continuing anyway...

When running multiple VMs it would be nice to know which machine the
message is referring to:

$ perf kvm --guest --guestmount=/tmp/guest-mount record -av -- sleep 10
Problems creating module maps for guest 6613, continuing anyway...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342826756-64663-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 50958bb..66c132e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2564,8 +2564,15 @@ int machine__create_kernel_maps(struct machine *machine)
 	    __machine__create_kernel_maps(machine, kernel) < 0)
 		return -1;
 
-	if (symbol_conf.use_modules && machine__create_modules(machine) < 0)
-		pr_debug("Problems creating module maps, continuing anyway...\n");
+	if (symbol_conf.use_modules && machine__create_modules(machine) < 0) {
+		if (machine__is_host(machine))
+			pr_debug("Problems creating module maps, "
+				 "continuing anyway...\n");
+		else
+			pr_debug("Problems creating module maps for guest %d, "
+				 "continuing anyway...\n", machine->pid);
+	}
+
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
