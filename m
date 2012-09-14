Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2INF6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:58:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2INF6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:58:34 -0400
Date: Thu, 13 Sep 2012 22:58:19 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-bdde37163e1fd474509aab90f5eaacee46100107@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1347295819-23177-2-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do backtrace post unwind only if we regs and stack were captured
Git-Commit-ID: bdde37163e1fd474509aab90f5eaacee46100107
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:58:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdde37163e1fd474509aab90f5eaacee46100107
Gitweb:     http://git.kernel.org/tip/bdde37163e1fd474509aab90f5eaacee46100107
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 10 Sep 2012 18:50:16 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 12:01:15 -0300

perf tools: Do backtrace post unwind only if we regs and stack were captured

Bail out without error if we want to do backtrace post unwind, but were
not able to capture user registers or user stack during the record
phase, which is possible and valid case.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3806ea4..0ecd62b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -388,6 +388,11 @@ int machine__resolve_callchain(struct machine *machine,
 	      (evsel->attr.sample_type & PERF_SAMPLE_STACK_USER)))
 		return 0;
 
+	/* Bail out if nothing was captured. */
+	if ((!sample->user_regs.regs) ||
+	    (!sample->user_stack.size))
+		return 0;
+
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
 				   thread, evsel->attr.sample_regs_user,
 				   sample);
