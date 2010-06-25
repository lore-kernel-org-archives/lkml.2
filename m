Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0FYOtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:49:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:50537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab0FYOtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:49:01 -0400
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20100625131356.GB4078@ghostprotocols.net>
References: <4C241140.9090008@cn.fujitsu.com>
	 <4C24119B.60200@cn.fujitsu.com>  <20100625131356.GB4078@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 16:48:05 +0200
Message-ID: <1277477285.32034.666.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 10:13 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 25, 2010 at 10:16:59AM +0800, Gui Jianfeng escreveu:
> > group_fd related code is dead here, remove them.
> 
> I agree it is dead at the moment, but I think Peter (or was it Ingo at
> the time?) had a reason for it to live, Peter, care to take a look?

Ah, yes, it would be nice for SH (which doesn't have a PMI) to couple a
software timer with their hardware counter to get samples.

Never got around to actually implementing that though, maybe Paul has a
minion interested in making that work?

> > Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> > ---
> >  tools/perf/builtin-record.c |   12 +-----------
> >  1 files changed, 1 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index abaf0f8..84d58b7 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -45,7 +45,6 @@ static int			freq				=   1000;
> >  static int			output;
> >  static int			pipe_output			=      0;
> >  static const char		*output_name			= "perf.data";
> > -static int			group				=      0;
> >  static int			realtime_prio			=      0;
> >  static bool			raw_samples			=  false;
> >  static bool			system_wide			=  false;
> > @@ -203,8 +202,6 @@ static void sig_atexit(void)
> >  	kill(getpid(), signr);
> >  }
> >  
> > -static int group_fd;
> > -
> >  static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int nr)
> >  {
> >  	struct perf_header_attr *h_attr;
> > @@ -291,7 +288,7 @@ static void create_counter(int counter, int cpu)
> >  	for (thread_index = 0; thread_index < thread_num; thread_index++) {
> >  try_again:
> >  		fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
> > -				all_tids[thread_index], cpu, group_fd, 0);
> > +				all_tids[thread_index], cpu, -1, 0);
> >  
> >  		if (fd[nr_cpu][counter][thread_index] < 0) {
> >  			int err = errno;
> > @@ -359,12 +356,6 @@ try_again:
> >  		assert(fd[nr_cpu][counter][thread_index] >= 0);
> >  		fcntl(fd[nr_cpu][counter][thread_index], F_SETFL, O_NONBLOCK);
> >  
> > -		/*
> > -		 * First counter acts as the group leader:
> > -		 */
> > -		if (group && group_fd == -1)
> > -			group_fd = fd[nr_cpu][counter][thread_index];
> > -
> >  		if (counter || thread_index) {
> >  			ret = ioctl(fd[nr_cpu][counter][thread_index],
> >  					PERF_EVENT_IOC_SET_OUTPUT,
> > @@ -406,7 +397,6 @@ static void open_counters(int cpu)
> >  {
> >  	int counter;
> >  
> > -	group_fd = -1;
> >  	for (counter = 0; counter < nr_counters; counter++)
> >  		create_counter(counter, cpu);
> >  
> > -- 1.6.5.2 

