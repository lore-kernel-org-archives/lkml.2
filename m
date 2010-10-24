Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0JXVYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:24:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab0JXVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:24:14 -0400
From: Brian Gitonga Marete <marete@toshnix.com>
Cc: Brian Gitonga Marete <marete@toshnix.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] Fix a compile error with -fstack-protector, -Wstack-protector and -Werror.
Date: Mon, 25 Oct 2010 00:23:19 +0300
Message-Id: <1287955399-25354-1-git-send-email-marete@toshnix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20101019131152.GB3826@ghostprotocols.net>
References: <20101019131152.GB3826@ghostprotocols.net>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is as per Ingo's suggestion. Agains 2.6.36. Thanks.

In the function ui__dialog_yesno(), automatic buffers have to be used as long
as we are compiling perf with the -Wwrite-stings and -Werror options. This is because the
Newt library does not declare the string parameters in newtWinChoice() as
constant when it should.

But the automatic buffers are not large enough to benefit from ssp at least on some gcc versions, e.g. the one that comes with Ubuntu 9.0.4. This along with -Wstack-protector causes a compile warning which is turned into an error by
-Werror.

This patch works around this problem by making the buffers global and static.

Signed-off-by: Brian Gitonga Marete <marete@toshnix.com>
---
 tools/perf/util/ui/util.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 04600e2..c7dc022 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -11,6 +11,9 @@
 #include "helpline.h"
 #include "util.h"
 
+static char yes[] = "Yes";
+static char no[] = "No";
+
 newtComponent newt_form__new(void);
 
 static void newt_form__set_exit_keys(newtComponent self)
@@ -109,6 +112,5 @@ out_destroy_form:
 bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
-- 
1.7.1.1

