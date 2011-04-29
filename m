Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab1D2OXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:23:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab1D2OXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:23:44 -0400
Date: Fri, 29 Apr 2011 16:23:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf stat branch: perf stat fails on unsupported event
Message-ID: <20110429142336.GA9971@elte.hu>
References: <4DBAC59F.2020009@gmail.com>
 <20110429141103.GA4106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429141103.GA4106@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Does the patch below allow the other events to be counted?

That patch was buggy - the one below should work better.

Thanks,

	Ingo

---------->
>From 370faf1dd0461ad811852c8abbbcd3d73b1e4fc4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Apr 2011 16:11:03 +0200
Subject: [PATCH] perf stat: Fail softly on unsupported events

David Ahern reported this perf stat failure:

> # /tmp/build-perf/perf stat -- sleep 1
>   Error: stalled-cycles-frontend event is not supported.
>   Fatal: Not all events could be opened.
>
> This is a Dell R410 with an E5620 processor.

Fail in a softer fashion on unknown/unsupported events.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9e596ab..c8b535b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -377,7 +377,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
-			if (errno == EINVAL || errno == ENOSYS)
+			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT)
 				continue;
 
 			if (errno == EPERM || errno == EACCES) {
@@ -385,8 +385,6 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
-			} else if (errno == ENOENT) {
-				error("%s event is not supported. ", event_name(counter));
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
