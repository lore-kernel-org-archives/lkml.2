Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0FOOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:47:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48883 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab0FOOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:47:10 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: prevent print_graph_duration buffer overflow
Date: Tue, 15 Jun 2010 10:47:04 -0400
Message-Id: <1276613224-19247-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
condition. We know the exact size of nsecs_str, so use it along with the
the math to determine the longest string size we want.

Note that an overflow isn't really possible given the format of the
string. However, glibc would abort due to a runtime check.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 trace-ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/trace-ftrace.c b/trace-ftrace.c
index af9ac8d..181a00f 100644
--- a/trace-ftrace.c
+++ b/trace-ftrace.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/param.h>
 
 #include "trace-cmd.h"
 
@@ -148,7 +149,7 @@ static void print_graph_duration(struct trace_seq *s, unsigned long long duratio
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if ((s->len - len) < 7) {
-		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
+		snprintf(nsecs_str, MIN(sizeof(nsecs_str), 8 - len), "%03lu", nsecs_rem);
 		trace_seq_printf(s, ".%s", nsecs_str);
 	}
 
-- 
1.7.0.4

