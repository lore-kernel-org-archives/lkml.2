Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2HVInj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:43:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36030 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2HVIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:26 -0400
X-AuditID: b753bd60-991dcba000000c4c-83-50349bab67ef
X-AuditID: b753bd60-991dcba000000c4c-83-50349bab67ef
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 2/5] trace-cmd: Use tracing directory to count CPUs
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
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date: Wed, 22 Aug 2012 17:43:12 +0900
Message-ID: <20120822084312.17293.47596.stgit@ltc189.sdl.hitachi.co.jp>
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

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Count debugfs/tracing/per_cpu/cpu* to determine the
number of CPUs.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 trace-record.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index 9dc18a9..ed18951 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -1179,6 +1179,41 @@ static void expand_event_list(void)
 	}
 }
 
+static int count_tracingdir_cpus(void)
+{
+	char *tracing_dir = NULL;
+	char *percpu_dir = NULL;
+	struct dirent **namelist;
+	int count = 0, n;
+
+	/* Count cpus in per_cpu directory */
+	tracing_dir = tracecmd_find_tracing_dir();
+	if (!tracing_dir)
+		return 0;
+	percpu_dir = malloc_or_die(strlen(tracing_dir) + 9);
+	if (!percpu_dir)
+		goto err;
+
+	sprintf(percpu_dir, "%s/per_cpu", tracing_dir);
+
+	n = scandir(percpu_dir, &namelist, NULL, alphasort);
+	if (n > 0) {
+		while (n--) {
+			if (strncmp("cpu", namelist[n]->d_name, 3) == 0)
+				count++;
+			free(namelist[n]);
+		}
+		free(namelist);
+	}
+
+	if (percpu_dir)
+		free(percpu_dir);
+err:
+	if (tracing_dir)
+		free(tracing_dir);
+	return count;
+}
+
 static int count_cpus(void)
 {
 	FILE *fp;
@@ -1189,6 +1224,12 @@ static int count_cpus(void)
 	size_t n;
 	int r;
 
+	cpus = count_tracingdir_cpus();
+	if (cpus > 0)
+		return cpus;
+
+	warning("failed to use tracing_dir to determine number of CPUS");
+
 	cpus = sysconf(_SC_NPROCESSORS_CONF);
 	if (cpus > 0)
 		return cpus;


