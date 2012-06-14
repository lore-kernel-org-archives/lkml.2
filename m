Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2FNRfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:35:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45923 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2FNRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:35:49 -0400
From: David Ahern <dsahern@gmail.com>
To: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com
Cc: namhyung.kim@lge.com, mingo@kernel.org, peterz@infradead.org,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 2/2] perf: add support for trace-cmd plugins
Date: Thu, 14 Jun 2012 11:35:33 -0600
Message-Id: <1339695333-64591-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improves pretty printing of events when using perf-script. e.g.,
perf record -p 8731 -e kvm:* -fo /tmp/perf.data -- sleep 1

Currently when dumping kvm events you ugliness like this:
$ perf script -i /tmp/perf.data
Warning: bad op token {
Warning: failed to read event print fmt for kvm_emulate_insn
...
        qemu-kvm  8734 [006] 826443.468554: kvm_emulate_insn:
<...>-8734  [006]     0.000000000: kvm_emulate_insn:
[FAILED TO PARSE] rip=18446744071579001937 csbase=0 len=6
insn=<89><B7> flags=9 failed=0

Ignoring the duplication of data the event is not readable.
With this patch and using the kvm plugin for trace-cmd you get:

        qemu-kvm  8734 [006] 826443.468554: kvm_emulate_insn:
0:ffffffff81026451: mov %esi, 0xff5fb000(%rdi)

which is a bit more readable.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..7b149c5 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -27,6 +27,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "tracecmd-plugins.h"
 
 int header_page_size_size;
 int header_page_ts_size;
@@ -36,6 +37,7 @@ struct pevent *perf_pevent;
 static struct pevent *pevent;
 
 bool latency_format;
+struct plugin_list *list;
 
 int read_trace_init(int file_bigendian, int host_bigendian)
 {
@@ -45,6 +47,8 @@ int read_trace_init(int file_bigendian, int host_bigendian)
 	perf_pevent = pevent_alloc();
 	pevent = perf_pevent;
 
+	list = tracecmd_load_plugins(pevent);
+
 	pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
 	pevent_set_file_bigendian(pevent, file_bigendian);
 	pevent_set_host_bigendian(pevent, host_bigendian);
-- 
1.7.10.1

