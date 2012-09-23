Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2IWT32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:29:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39030 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2IWT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:29:24 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 3/4] perf annotate: configure objdump path at compile time
Date: Sun, 23 Sep 2012 22:27:25 +0300
Message-Id: <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

The default name for objdump is "objdump". For cross-compiling the name of
objdump will be different (e.g. arm-eabi-objdump in Android).

Set the default objdump name in the Makefile with DEFAULT_OBJDUMP_PATH.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile        |    4 ++++
 tools/perf/util/annotate.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fae52c8..7a3f572 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -140,6 +140,7 @@ ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
 PERF_TMP_DIR = /tmp
+OBJDUMP = $(CROSS_COMPILE)objdump
 
 export prefix bindir sharedir sysconfdir
 
@@ -883,6 +884,9 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
+$(OUTPUT)util/annotate.o: util/annotate.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_OBJDUMP_PATH='"$(OBJDUMP)"' $<
+
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..d7036b3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -824,7 +824,7 @@ fallback:
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -d %s %s -C %s|grep -v %s|expand",
-		 objdump_path ? objdump_path : "objdump",
+		 objdump_path ? objdump_path : DEFAULT_OBJDUMP_PATH,
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
-- 
1.7.9.5

