Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2GTX0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:26:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GTX0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:09 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/11] perf tool: add machine id to modules debug message
Date: Fri, 20 Jul 2012 17:25:46 -0600
Message-Id: <1342826756-64663-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current debug message is:
Problems creating module maps, continuing anyway...

When running multiple VMs it would be nice to know which machine the
message is referring to:

$ perf kvm --guest --guestmount=/tmp/guest-mount record -av -- sleep 10
Problems creating module maps for guest 6613, continuing anyway...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/symbol.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 90f6951..6802ef4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2567,8 +2567,15 @@ int machine__create_kernel_maps(struct machine *machine)
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
-- 
1.7.10.1

