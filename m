Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0FREfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:35:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48323 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0FREfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X28ra9IGuMvF/Zf4nyYtaPzUgduxJddoBuqxns6uw6A63/fyIgbt3cv9v2CuDVEP7j
         aH52GVfImY0QRs+1FG6qzgMdT+1juNulgqE7cHf5pEAYvFJZuapRZ/3Mx6jCXwVP1+oj
         STLZa+zpoNrtVXEC7juZFA8md+eE7y6mco2Ro=
Date: Fri, 18 Jun 2010 06:35:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 0/8] perf pmu interface
Message-ID: <20100618043540.GF5345@nowhere>
References: <20100616160027.590430763@chello.nl> <1276712372.1745.619.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276712372.1745.619.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:19:32PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-16 at 18:00 +0200, Peter Zijlstra wrote:
> > These patches prepare the perf code for multiple pmus (no user
> > interface yet, Lin Ming is working on that). These patches remove all
> > weak functions and rework the struct pmu interface.
> > 
> > The latter is inspired by the work Frederic is doing to to filter out
> > IRQ contexts.
> > 
> > These patches are very prelimenary, they haven't seen a compiler yet and
> > the last patch still needs sparc,ppc and arm converted.
> > 
> > But they patches seem to be in a good enough shape to see what people
> > think..
> 
> Another idea I was kicking about was to push find_get_context()
> partially into struct pmu, so that we can have context's per pmu.
> 
> For cpu-wide contexts its easy, for per-task contexts we need more
> pointers in task_struct, so I was thinking of something like:
> 
> enum {
>   perf_swevent_context = 0,
>   perf_cpu_context,
> #ifdef HW_BREAKPOINT
>   perf_bp_context,
> #endif
>   perf_nr_task_context
> };
> 
> struct task_struct {
>   ...
>   struct perf_event_context *perf_event_ctxs[perf_nr_task_context];
>   ...
> };
> 
> and have add for loops over the struct pmu list for the cpu-wide
> contexts and for loops over perf_nr_task_context for the task contexts.
> 
> It would add some extra code to the hot-paths, but its the best I can
> come up with.


I'm not sure what you mean. Would that be to optimize the start_txn / commit_txn ?
Then that sounds a good idea. But you'd only need two groups I think:

enum {
   perf_swevent_context = 0,
   perf_cpu_context,
   perf_nr_task_context
};


As only the cpu pmu needs the txn game, at least for now.

It seems that would drop the ability to gather hardware and software
events in a same group though.

