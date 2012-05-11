Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2EKGc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:32:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab2EKGc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:32:26 -0400
Date: Thu, 10 May 2012 23:32:06 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-770a34a38b74982724dbb099225944b415f90281@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1335417327-11796-7-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-7-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Check more combinations of PID/TID,
  UID and CPU switches
Git-Commit-ID: 770a34a38b74982724dbb099225944b415f90281
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:32:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  770a34a38b74982724dbb099225944b415f90281
Gitweb:     http://git.kernel.org/tip/770a34a38b74982724dbb099225944b415f90281
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Apr 2012 14:15:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:24:14 -0300

perf tools: Check more combinations of PID/TID, UID and CPU switches

There were some combinations of these switches that are not so
appropriate IMHO.

Since there are implicit priorities between them and they worked well
anyway, but it ends up opening useless duplicated events.

For example, 'perf stat -t <pid> -a' will open multiple events for the
thread instead of one.

Add explicit checks and warn user in perf_target__validate().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/usage.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 0a1a885..228f0a5 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -132,4 +132,18 @@ void perf_target__validate(struct perf_target *target)
 		sleep(1);
 		target->uid_str = NULL;
 	}
+
+	/* UID and CPU are mutually exclusive */
+	if (target->uid_str && target->cpu_list) {
+		ui__warning("UID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* PID/UID and SYSTEM are mutually exclusive */
+	if ((target->tid || target->uid_str) && target->system_wide) {
+		ui__warning("PID/TID/UID switch overriding CPU\n");
+		sleep(1);
+		target->system_wide = false;
+	}
 }
