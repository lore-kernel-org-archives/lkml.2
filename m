Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2EKGkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:40:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2EKGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:40:33 -0400
Date: Thu, 10 May 2012 23:39:39 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-55261f46702cec96911a81aacfb3cba13434d304@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336367344-28071-3-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix creation of cpu map
Git-Commit-ID: 55261f46702cec96911a81aacfb3cba13434d304
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:39:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55261f46702cec96911a81aacfb3cba13434d304
Gitweb:     http://git.kernel.org/tip/55261f46702cec96911a81aacfb3cba13434d304
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 7 May 2012 14:08:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 16:46:21 -0300

perf evlist: Fix creation of cpu map

Currently, 'perf record -- sleep 1' creates a cpu map for all online
cpus since it turns out calling cpu_map__new(NULL). Fix it.

Also it is guaranteed that cpu_list is NULL if PID/TID is given by
calling perf_target__validate(), so we can make the conditional bit
simpler.

This also fixes perf test 7 (Validate) failure on my 6 core machine:

  $ cat /sys/devices/system/cpu/online
  0-11
  $ ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields:
  --- start ---
  perf_evlist__mmap: Operation not permitted
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3032862..183b199 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,8 +609,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->uid != UINT_MAX ||
-	    (target->cpu_list == NULL && target->tid))
+	if (target->uid != UINT_MAX || target->tid)
+		evlist->cpus = cpu_map__dummy_new();
+	else if (!target->system_wide && target->cpu_list == NULL)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
