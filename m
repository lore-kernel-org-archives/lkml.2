Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0LQNQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:16:53 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60507 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0LQNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:16:51 -0500
X-AuditID: b753bd60-a62feba000000f8d-73-4d0b62c0702b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 2/4] [BUGFIX]perf: Fix strlist__parse_list to handle
	const string
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Dec 2010 22:12:06 +0900
Message-ID: <20101217131206.24123.87394.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix strlist__parse_list to handle const string. Without
this patch, strlist__parse_list() causes SEGV when
caller passes a constant string.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/strlist.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 6783a20..caa7884 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -136,13 +136,19 @@ static int strlist__parse_list_entry(struct strlist *self, const char *s)
 
 int strlist__parse_list(struct strlist *self, const char *s)
 {
-	char *sep;
+	char *sep, *tmp;
 	int err;
 
+	/* This method requires strdup, because this changes given string */
+	if (!self->dupstr)
+		return -EINVAL;
+
 	while ((sep = strchr(s, ',')) != NULL) {
-		*sep = '\0';
-		err = strlist__parse_list_entry(self, s);
-		*sep = ',';
+		tmp = strndup(s, sep - s);
+		if (tmp == NULL)
+			return -ENOMEM;
+		err = strlist__parse_list_entry(self, tmp);
+		free(tmp);
 		if (err != 0)
 			return err;
 		s = sep + 1;

