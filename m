Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab2J3MMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:12:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:12:33 -0400
Date: Tue, 30 Oct 2012 05:11:46 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0089fa9831f3752869143c7928adb94ac6353085@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1350743599-4805-12-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-12-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix mmap error output condition
Git-Commit-ID: 0089fa9831f3752869143c7928adb94ac6353085
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:11:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0089fa9831f3752869143c7928adb94ac6353085
Gitweb:     http://git.kernel.org/tip/0089fa9831f3752869143c7928adb94ac6353085
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 20 Oct 2012 16:33:19 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 12:14:59 -0200

perf record: Fix mmap error output condition

The mmap_pages default value is not power of 2 (UINT_MAX).

Together with perf_evlist__mmap function returning error value different
from EPERM, we get misleading error message: "--mmap_pages/-m value must
be a power of two."

Fixing this by adding extra check for UINT_MAX value for this error
condition.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1350743599-4805-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 53c9892..5783c32 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -363,7 +363,8 @@ try_again:
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
 			       "(current value: %d)\n", opts->mmap_pages);
 			rc = -errno;
-		} else if (!is_power_of_2(opts->mmap_pages)) {
+		} else if (!is_power_of_2(opts->mmap_pages) &&
+			   (opts->mmap_pages != UINT_MAX)) {
 			pr_err("--mmap_pages/-m value must be a power of two.");
 			rc = -EINVAL;
 		} else {
