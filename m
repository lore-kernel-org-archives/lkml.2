Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2JTA57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:57:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2JTA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:57:58 -0400
Date: Fri, 19 Oct 2012 17:57:34 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ffe10c6f95412da01695e659e967747333d5e812@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1350272383-7016-1-git-send-email-namhyung@kernel.org>
References: <1350272383-7016-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix segfault when using srcline sort key
Git-Commit-ID: ffe10c6f95412da01695e659e967747333d5e812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 17:57:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffe10c6f95412da01695e659e967747333d5e812
Gitweb:     http://git.kernel.org/tip/ffe10c6f95412da01695e659e967747333d5e812
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 15 Oct 2012 12:39:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 13:05:07 -0300

perf tools: Fix segfault when using srcline sort key

The srcline sort key is for grouping samples based on their source file
and line number.  It use addr2line tool to get the information but it
requires dso name.  It caused a segfault when a sample does not have the
name by dereferencing a NULL pointer.  Fix it by using raw ip addresses
for those samples.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1350272383-7016-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b92..dd68f11 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -260,6 +260,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (path != NULL)
 		goto out_path;
 
+	if (!self->ms.map)
+		goto out_ip;
+
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
