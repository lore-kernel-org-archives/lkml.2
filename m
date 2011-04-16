Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1DPGkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 02:40:49 -0400
Received: from ozlabs.org ([203.10.76.45]:54167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1DPGks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 02:40:48 -0400
Date: Sat, 16 Apr 2011 16:40:22 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf annotate: Add config option for additional objdump
 arguments
Message-ID: <20110416164022.4ee0f8aa@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We sometimes need to pass arguments to objdump, for example to
specify a particular machine type. In the case below I am profiling
on POWER7 and perf annotate is unable to decode a POWER7 specific
instruction:

c000000000008ff0:       7f 45 26 98     .long 0x7f452698

With the patch below and the following in ~/.perfconfig:

[objdump]
	options = -Mpower7

perf annotate successfully decodes the instruction:

c000000000008ff0:       7f 45 26 98     lxvd2x  vs26,r5,r4

Signed-off-by: Anton Blanchard <anton@samba.org>
---

What do people think of objdump.options? Would annotate.objdump_options be
better?

Also we only look at the first occurance of the option, do we want to
parse everything found and concatenate them together?

Index: linux.trees.git/tools/perf/util/annotate.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/annotate.c	2011-04-16 16:00:31.000000000 +1000
+++ linux.trees.git/tools/perf/util/annotate.c	2011-04-16 16:26:46.000000000 +1000
@@ -16,10 +16,33 @@
 #include "annotate.h"
 #include <pthread.h>
 
+static char *objdump_options;
+
+static int perf_objdump_config(const char *var, const char *value, void *cb)
+{
+	if (objdump_options == NULL && !strcmp(var, "objdump.options")) {
+		size_t len = strlen(value);
+
+		objdump_options = zalloc(len + 1);
+		strncpy(objdump_options, value, len);
+
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	pthread_mutex_init(&notes->lock, NULL);
+
+	if (objdump_options == NULL) {
+		perf_config(perf_objdump_config, NULL);
+		if (objdump_options == NULL)
+			objdump_options = zalloc(1);
+	}
+
 	return 0;
 }
 
@@ -324,9 +347,11 @@ fallback:
 
 	snprintf(command, sizeof(command),
 		 "objdump --start-address=0x%016" PRIx64
-		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 " --stop-address=0x%016" PRIx64 " %s -dS -C %s|"
+		 "grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
+		 objdump_options,
 		 symfs_filename, filename);
 
 	pr_debug("Executing: %s\n", command);
