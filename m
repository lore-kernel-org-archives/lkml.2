Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2LHO7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:59:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab2LHO7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:59:03 -0500
Date: Sat, 8 Dec 2012 06:58:40 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-2711926a416733b853977a0e014c713955ad0d8a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352741644-16809-4-git-send-email-jolsa@redhat.com>
References: <1352741644-16809-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Ensure single disable call per event in record comand
Git-Commit-ID: 2711926a416733b853977a0e014c713955ad0d8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:58:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2711926a416733b853977a0e014c713955ad0d8a
Gitweb:     http://git.kernel.org/tip/2711926a416733b853977a0e014c713955ad0d8a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 12 Nov 2012 18:34:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:52:09 -0300

perf tools: Ensure single disable call per event in record comand

It's possible we issue the event disable ioctl multiple times until we
read the final portion of the mmap buffer.

Ensuring just single disable ioctl call for event, because there's no
need to do that more than once.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352741644-16809-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 268b356..f3151d3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -502,6 +502,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	struct perf_evlist *evsel_list = rec->evlist;
 	const char *output_name = rec->output_name;
 	struct perf_session *session;
+	bool disabled = false;
 
 	rec->progname = argv[0];
 
@@ -735,8 +736,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		 * die with the process and we wait for that. Thus no need to
 		 * disable events in this case.
 		 */
-		if (done && !perf_target__none(&opts->target))
+		if (done && !disabled && !perf_target__none(&opts->target)) {
 			perf_evlist__disable(evsel_list);
+			disabled = true;
+		}
 	}
 
 	if (quiet || signr == SIGUSR1)
