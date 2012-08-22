Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2HVIoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:44:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36189 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2HVIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:56 -0400
X-AuditID: b753bd60-9255dba000007c38-2f-50349bc9a324
X-AuditID: b753bd60-9255dba000007c38-2f-50349bc9a324
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 5/5] trace-cmd: Use polling function
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date: Wed, 22 Aug 2012 17:43:43 +0900
Message-ID: <20120822084343.17293.28556.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use poll() for avoiding a busy loop to read trace data of a guest from FIFO.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 trace-recorder.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/trace-recorder.c b/trace-recorder.c
index 6577fe8..bdf9798 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -34,9 +34,12 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <poll.h>
 
 #include "trace-cmd.h"
 
+#define WAIT_MSEC 1
+
 struct tracecmd_recorder {
 	int		fd;
 	int		trace_fd;
@@ -235,9 +238,37 @@ static void stop_operation_to_trace_agent(int ctl_fd)
 	operation_to_trace_agent(ctl_fd, false);
 }
 
-int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
+static int wait_data(struct tracecmd_recorder *recorder, unsigned long sleep)
 {
+	struct pollfd poll_fd;
 	struct timespec req;
+	int ret = 0;
+
+	if (recorder->agent_existing) {
+		poll_fd.fd = recorder->trace_fd;
+		poll_fd.events = POLLIN;
+		while (1) {
+			ret = poll(&poll_fd, 1, WAIT_MSEC);
+
+			if(ret < 0) {
+				warning("polling error");
+				return ret;
+			}
+
+			if (ret)
+				break;
+		}
+	} else if (sleep) {
+		req.tv_sec = sleep / 1000000;
+		req.tv_nsec = (sleep % 1000000) * 1000;
+		nanosleep(&req, NULL);
+	}
+
+	return ret;
+}
+
+int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
+{
 	long ret;
 
 	recorder->stop = 0;
@@ -246,11 +277,10 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 		run_operation_to_trace_agent(recorder->ctl_fd);
 	
 	do {
-		if (sleep) {
-			req.tv_sec = sleep / 1000000;
-			req.tv_nsec = (sleep % 1000000) * 1000;
-			nanosleep(&req, NULL);
-		}
+		ret = wait_data(recorder, sleep);
+		if (ret < 0)
+			return ret;
+
 		ret = splice_data(recorder);
 		if (ret < 0)
 			return ret;


