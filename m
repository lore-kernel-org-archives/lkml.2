Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2AJLQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:16:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38620 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2AJLQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:16:39 -0500
Message-ID: <1326194188.2442.106.camel@twins>
Subject: Re: perf event group siblings not counting in mainline
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@suse.de, Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Tue, 10 Jan 2012 12:16:28 +0100
In-Reply-To: <20120110110942.GB24180@mudshark.cambridge.arm.com>
References: <20111224125415.GA14559@mudshark.cambridge.arm.com>
	 <20120110110942.GB24180@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 11:09 +0000, Will Deacon wrote:
> On Sat, Dec 24, 2011 at 12:54:15PM +0000, Will Deacon wrote:
> > If I try using perf with event groups on a mainline kernel, only the group
> > leader counts:
> > 
> > 
> > linaro@mashed-potato:~$ perf stat --no-scale -g -e task-clock -e cpu-clock -e cs -- ls
> > hwb  linux
> > 
> >  Performance counter stats for 'ls':
> > 
> >          17.545541 task-clock                #    0.634 CPUs utilized
> >           0.000000 cpu-clock
> >                  0 cs                        #    0.000 M/sec
> > 
> >        0.027684984 seconds time elapsed
> > 
> > 
> > This is fixed by b79387ef ("perf: Fix enable_on_exec for sibling events")
> > in -next (20111222) but I can't see this queued anywhere for 3.2 (I thought
> > I might see it in -rc7).
> > 
> > Is this going in for the final cut, or will groups just be borked until 3.3?
> 
> Now that 3.2 is out with this regression, would it be possible to get this
> (b79387ef ("perf: Fix enable_on_exec for sibling events")) into -stable please?

How can this be a regression? Its always been like that. At worst its a
broken new feature.

Also, you really shouldn't set enable_on_exec on non group leaders,
that's just daft. But yes that patch sorts it. Something like the below
should too.

---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f5d2a63..623519f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -298,7 +298,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 						group, group_fd);
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
-		attr->enable_on_exec = 1;
+		attr->enable_on_exec = !group_fd;
 	}
 
 	return perf_evsel__open_per_thread(evsel, evsel_list->threads,

