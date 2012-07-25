Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2GYRln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:41:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GYRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/19] perf symbols: Add machine id to modules debug message
Date: Wed, 25 Jul 2012 14:41:16 -0300
Message-Id: <1343238094-12481-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.7.1

