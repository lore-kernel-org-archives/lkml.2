Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab2IGDev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:34:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47812 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305Ab2IGDet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:34:49 -0400
MIME-Version: 1.0
Date: Fri, 7 Sep 2012 11:34:49 +0800
Message-ID: <CADu=CFpMKkAW5+=Us9J2GOxZTBDN91FTeteCgbyh8c7fsP837g@mail.gmail.com>
Subject: [PATCH v2] A trivial memory leak fix while calling system_path
From: liang xie <xieliang007@gmail.com>
To: acme@ghostprotocols.net
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org, balbi@ti.com,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A trivial memory leak fix while calling system_path

Since v1: Remove an unnecessary null pointer check per Felipe's comments

Signed-off-by: Liang Xie <xieliang@xiaomi.com>
---
 tools/perf/util/exec_cmd.c |    4 +++-
 tools/perf/util/help.c     |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 7adf4ad..d041407 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -83,8 +83,9 @@ void setup_path(void)
 {
 	const char *old_path = getenv("PATH");
 	struct strbuf new_path = STRBUF_INIT;
+	const char *exec_path = perf_exec_path();

-	add_path(&new_path, perf_exec_path());
+	add_path(&new_path, exec_path);
 	add_path(&new_path, argv0_path);

 	if (old_path)
@@ -95,6 +96,7 @@ void setup_path(void)
 	setenv("PATH", new_path.buf, 1);

 	strbuf_release(&new_path);
+	free((void *)exec_path);
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
