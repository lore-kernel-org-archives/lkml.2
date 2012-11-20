Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2KTErz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:47:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57417 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2KTErs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:47:48 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-13-50ab0b727f6b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] perf annotate: Fix warning message on vmlinux
Date: Tue, 20 Nov 2012 13:47:22 +0900
Message-Id: <1353386842-9547-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353386842-9547-1-git-send-email-namhyung@kernel.org>
References: <1353386842-9547-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When perf report runs with perf.data which was recorded on a different
kernel, it fails to run annotate browser with the kernel symbol and it
recommends to run perf buildid-cache with proper vmlinux.

But running perf buildid-cache -av vmlinux as the message gives me
a following error:

  $ perf buildid-cache -av /home/namhyung/build/kernel/vmlinux
  Couldn't add v: No such file or directory

Since the -a option receives a parameter, 'v' should not be after the
option.

In addition -a option is not work for this case since the build-id
cache already has a kallsyms with same build-id so it'll fail with
EEXIST.  Use recently added -u (--update) option for it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 07aaeea60000..d33fe937e6f1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -809,7 +809,7 @@ fallback:
 		pr_err("Can't annotate %s:\n\n"
 		       "No vmlinux file%s\nwas found in the path.\n\n"
 		       "Please use:\n\n"
-		       "  perf buildid-cache -av vmlinux\n\n"
+		       "  perf buildid-cache -vu vmlinux\n\n"
 		       "or:\n\n"
 		       "  --vmlinux vmlinux\n",
 		       sym->name, build_id_msg ?: "");
-- 
1.7.11.7

