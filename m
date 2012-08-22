Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2HVInz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:43:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60326 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2HVIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:36 -0400
X-AuditID: b753bd60-8f6bfba0000047ca-56-50349bb5207e
X-AuditID: b753bd60-8f6bfba0000047ca-56-50349bb5207e
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 3/5] trace-cmd: Support trace-agent of virtio-trace
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
Date: Wed, 22 Aug 2012 17:43:22 +0900
Message-ID: <20120822084322.17293.70186.stgit@ltc189.sdl.hitachi.co.jp>
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

Add read path and control path to use trace-agent of virtio-trace.
When we use trace-agent, trace-cmd will be used as follows:
	# AGENT_READ_DIR=/tmp/virtio-trace/tracing \
	  AGENT_CTL=/tmp/virtio-trace/agent-ctl-path.in \
	  TRACING_DIR=/tmp/virtio-trace/debugfs/tracing \
	  trace-cmd record -e "sched:*"
Here, AGENT_READ_DIR is the path for a reading directory of virtio-trace,
AGENT_CTL is a control path of trace-agent, and TRACING_DIR is a debugfs path
of a guest.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 trace-cmd.h      |    1 +
 trace-recorder.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 trace-util.c     |   18 +++++++++++++++++
 3 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index f904dc5..75506ed 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -72,6 +72,7 @@ static inline int tracecmd_host_bigendian(void)
 }
 
 char *tracecmd_find_tracing_dir(void);
+char *guest_agent_tracing_read_dir(void);
 
 /* --- Opening and Reading the trace.dat file --- */
 
diff --git a/trace-recorder.c b/trace-recorder.c
index 215affc..3b750e9 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -33,6 +33,7 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <errno.h>
+#include <stdbool.h>
 
 #include "trace-cmd.h"
 
@@ -43,6 +44,8 @@ struct tracecmd_recorder {
 	int		page_size;
 	int		cpu;
 	int		stop;
+	int		ctl_fd;
+	bool		agent_existing;
 };
 
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
@@ -59,11 +62,29 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	free(recorder);
 }
 
+static char *use_trace_agent_dir(char *ctl_path,
+					struct tracecmd_recorder *recorder)
+{
+	ctl_path = strdup(ctl_path);
+	if (!ctl_path)
+		die("malloc");
+	warning("Use environmental control path: %s\n", ctl_path);
+
+	recorder->ctl_fd = open(ctl_path, O_WRONLY);
+	if (recorder->ctl_fd < 0)
+		return NULL;
+
+	recorder->agent_existing = true;
+
+	return guest_agent_tracing_read_dir();
+}
+
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu)
 {
 	struct tracecmd_recorder *recorder;
 	char *tracing = NULL;
 	char *path = NULL;
+	char *ctl_path = NULL;
 	int ret;
 
 	recorder = malloc_or_die(sizeof(*recorder));
@@ -76,12 +97,23 @@ struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu)
 	recorder->trace_fd = -1;
 	recorder->brass[0] = -1;
 	recorder->brass[1] = -1;
+	recorder->ctl_fd = -1;
+	recorder->agent_existing = false;
 
 	recorder->page_size = getpagesize();
 
 	recorder->fd = fd;
 
-	tracing = tracecmd_find_tracing_dir();
+	/*
+	 * The trace-agent on a guest is controlled to run or stop by a host,
+	 * so we need to assign the control path of the trace-agent to use
+	 * virtio-trace.
+	 */
+	ctl_path = getenv("AGENT_CTL");
+	if (ctl_path)
+		tracing = use_trace_agent_dir(ctl_path, recorder);
+	else
+		tracing = tracecmd_find_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		goto out_free;
@@ -182,6 +214,24 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 	return total;
 }
 
+static void operation_to_trace_agent(int ctl_fd, bool run_agent)
+{
+	if (run_agent == true)
+		write(ctl_fd, "1", 2);
+	else
+		write(ctl_fd, "0", 2);
+}
+
+static void run_operation_to_trace_agent(int ctl_fd)
+{
+	operation_to_trace_agent(ctl_fd, true);
+}
+
+static void stop_operation_to_trace_agent(int ctl_fd)
+{
+	operation_to_trace_agent(ctl_fd, false);
+}
+
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
 {
 	struct timespec req;
@@ -189,6 +239,9 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
 	recorder->stop = 0;
 
+	if (recorder->agent_existing)
+		run_operation_to_trace_agent(recorder->ctl_fd);
+	
 	do {
 		if (sleep) {
 			req.tv_sec = sleep / 1000000;
@@ -214,6 +267,8 @@ void tracecmd_stop_recording(struct tracecmd_recorder *recorder)
 	if (!recorder)
 		return;
 
+	if (recorder->agent_existing)
+		stop_operation_to_trace_agent(recorder->ctl_fd);
 	recorder->stop = 1;
 }
 
diff --git a/trace-util.c b/trace-util.c
index d5a3eb4..ff639be 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -304,6 +304,24 @@ static int mount_debugfs(void)
 	return ret;
 }
 
+char *guest_agent_tracing_read_dir(void)
+{
+	char *tracing_read_dir;
+
+	tracing_read_dir = getenv("AGENT_READ_DIR");
+	if (tracing_read_dir) {
+		tracing_read_dir = strdup(tracing_read_dir);
+		if (!tracing_read_dir)
+			die("malloc");
+		warning("Use environmental read directory of trace-agent: %s\n",
+							tracing_read_dir);
+		return tracing_read_dir;
+	}
+
+	warning("AGENT_READ_DIR was not declared");
+	return NULL;
+}
+
 char *tracecmd_find_tracing_dir(void)
 {
 	char debugfs[MAX_PATH+1];


