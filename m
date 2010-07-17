Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab0GQPU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 11:20:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004Ab0GQPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 11:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I+g8eXpuy6bJUGJKWQUroFDuw5G5nJvoVzqpyfpYBa6pqRBB59KyuveVDvtmeYmeE6
         kBPKl6uyJ9QPL9KRnHYJOJk8LRWHZPAJjb+L5ZPOX1rKkyxg7T4Duyuk8O05bP1gN7pv
         PfT0FRpcdWmnjuvlFSqtpaNbJNioh+BDwGrv0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] tools: perf: fix sign bug
Date: Sat, 17 Jul 2010 19:20:07 +0400
Message-Id: <1279380007-15272-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'i' is unsigned, so this code is wrong if ext is long enough:

    i = strlen(argv[0]) - strlen(ext);
    if (i > 0 && !strcmp(argv[0] + i, ext)) { ... }

Make it signed.


The semantic patch that finds this problem (many false-positive results):
(http://coccinelle.lip6.fr/)

// <smpl>
@ r1 @
identifier f;
@@
int f(...) { ... }

@@
identifier r1.f;
type T;
unsigned T x;
@@

*x = f(...)
 ...
*x > 0

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 tools/perf/perf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cdd6c03..cfb857f 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -332,7 +332,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "test",	cmd_test,	0 },
 		{ "inject",	cmd_inject,	0 },
 	};
-	unsigned int i;
+	int i;
 	static const char ext[] = STRIP_EXTENSION;
 
 	if (sizeof(ext) > 1) {
-- 
1.7.0.4

