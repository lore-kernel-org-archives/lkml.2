Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2IENs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:48:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64304 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2IENsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:48:55 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 21:48:54 +0800
Message-ID: <CADu=CFrNXPJV-DiMT0Ruw6jZNhbsqg+uwP6UQnu-xrAVMc7mQg@mail.gmail.com>
Subject: [PATCH] perf tool: fix trivial memory leak while calling system_path()
From: liang xie <xieliang007@gmail.com>
To: acme@ghostprotocols.net, mingo@elte.hu
Cc: paulus@samba.org, linux-perf-users@vger.kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A trivial memory leak fix while calling system_path

Signed-off-by: Liang Xie <xieliang@xiaomi.com>
---
 tools/perf/util/exec_cmd.c |    6 ++++--
 tools/perf/util/help.c     |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 7adf4ad..790cc95 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -83,8 +83,8 @@ void setup_path(void)
 {
 	const char *old_path = getenv("PATH");
 	struct strbuf new_path = STRBUF_INIT;
-
-	add_path(&new_path, perf_exec_path());
+	const char *exec_path = perf_exec_path();
+	add_path(&new_path, exec_path);
 	add_path(&new_path, argv0_path);

 	if (old_path)
@@ -95,6 +95,8 @@ void setup_path(void)
 	setenv("PATH", new_path.buf, 1);

 	strbuf_release(&new_path);
+	if (exec_path)
+		free((void *)exec_path);
 }

 static const char **prepare_perf_cmd(const char **argv)
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..798f66d 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -187,6 +187,7 @@ void load_command_list(const char *prefix,
 		uniq(other_cmds);
 	}
 	exclude_cmds(other_cmds, main_cmds);
+	free((void *)exec_path);
 }

 void list_commands(const char *title, struct cmdnames *main_cmds,
-- 
1.7.1
