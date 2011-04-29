Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab1D2OLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:11:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1D2OLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:11:22 -0400
Date: Fri, 29 Apr 2011 16:11:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf stat branch: perf stat fails on unsupported event
Message-ID: <20110429141103.GA4106@elte.hu>
References: <4DBAC59F.2020009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAC59F.2020009@gmail.com>
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


* David Ahern <dsahern@gmail.com> wrote:

> Tried the perf stat branch this morning. perf stat fails with:
> 
> # /tmp/build-perf/perf stat -- sleep 1
>   Error: stalled-cycles-frontend event is not supported.
>   Fatal: Not all events could be opened.
> 
> This is a Dell R410 with an E5620 processor.

Does the patch below allow the other events to be counted?

Thanks,

	Ingo

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9e596ab..c11ec76 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -377,7 +377,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
-			if (errno == EINVAL || errno == ENOSYS)
+			if (errno == EINVAL || errno == ENOSYS || errno = ENOENT)
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
