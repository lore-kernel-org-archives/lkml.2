Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2EUHii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:38:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2EUHif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:38:35 -0400
Date: Mon, 21 May 2012 00:38:19 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-879d77d0cbe20ad1d6099a1e16f03b72c0649828@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
In-Reply-To: <1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
References: <1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert 'perf evlist: Fix creation of cpu map'
Git-Commit-ID: 879d77d0cbe20ad1d6099a1e16f03b72c0649828
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:38:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  879d77d0cbe20ad1d6099a1e16f03b72c0649828
Gitweb:     http://git.kernel.org/tip/879d77d0cbe20ad1d6099a1e16f03b72c0649828
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 16 May 2012 18:45:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 May 2012 12:12:05 -0300

Revert 'perf evlist: Fix creation of cpu map'

The commit 55261f46702c ("perf evlist: Fix creation of cpu map") changed
to create a per-task event when no cpu target is specified. However it
caused a problem since perf-task do not allow event inheritance due to
scalability issues so that the result will contain samples only from
parent, not from its children.

So we should use perf-task-per-cpu events anyway to get the right
result. Revert it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Analysed-by: Ingo Molnar <mingo@kernel.org>
Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337161549-9870-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 80bef28..87889f3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,10 +609,10 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_cpu(target))
-		evlist->cpus = cpu_map__new(target->cpu_list);
-	else
+	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else
+		evlist->cpus = cpu_map__new(target->cpu_list);
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;
