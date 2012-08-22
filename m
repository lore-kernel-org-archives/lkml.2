Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2HVIon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:44:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40416 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2HVInr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:47 -0400
X-AuditID: b753bd60-932c5ba0000047ca-e1-50349bbf728b
X-AuditID: b753bd60-932c5ba0000047ca-e1-50349bbf728b
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 4/5] trace-cmd: Add non-blocking option for open() and
 splice_read()
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
Date: Wed, 22 Aug 2012 17:43:32 +0900
Message-ID: <20120822084332.17293.84508.stgit@ltc189.sdl.hitachi.co.jp>
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

Add non-blocking option for open() and splice_read() for avoiding block to read
trace data of a guest from FIFO.

If SIGINT comes to read/write processes from the parent process in the case
where FIFO as a read I/F is assigned, then reading is normally blocked for
splice_read(). So, we added nonblock option to open() and splice_read().

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 trace-recorder.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/trace-recorder.c b/trace-recorder.c
index 3b750e9..6577fe8 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -124,7 +124,7 @@ struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu)
 		goto out_free;
 
 	sprintf(path, "%s/per_cpu/cpu%d/trace_pipe_raw", tracing, cpu);
-	recorder->trace_fd = open(path, O_RDONLY);
+	recorder->trace_fd = open(path, O_RDONLY | O_NONBLOCK);
 	if (recorder->trace_fd < 0)
 		goto out_free;
 
@@ -172,14 +172,17 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	long ret;
 
 	ret = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		     recorder->page_size, 1 /* SPLICE_F_MOVE */);
+		     recorder->page_size, SPLICE_F_MOVE | SPLICE_F_NONBLOCK);
 	if (ret < 0) {
-		warning("recorder error in splice input");
-		return -1;
+		if (errno != EAGAIN) {
+			warning("recorder error in splice input");
+			return -1;
+		}
+		return 0; /* Buffer is empty */
 	}
 
 	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
-		     recorder->page_size, 3 /* and NON_BLOCK */);
+		     recorder->page_size, SPLICE_F_MOVE | SPLICE_F_NONBLOCK);
 	if (ret < 0) {
 		if (errno != EAGAIN) {
 			warning("recorder error in splice output");


