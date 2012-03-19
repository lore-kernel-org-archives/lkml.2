Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248Ab2CSP5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:57:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52782 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2CSP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:57:51 -0400
Date: Mon, 19 Mar 2012 16:57:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v4)
Message-ID: <20120319155742.GF2660@somewhere>
References: <1331746607-6706-1-git-send-email-asharma@fb.com>
 <20120315141402.GA550@somewhere.redhat.com>
 <4F622DCE.4090608@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F622DCE.4090608@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:58:38AM -0700, Arun Sharma wrote:
> On 3/15/12 7:14 AM, Frederic Weisbecker wrote:
> 
> >I still feel concerned about this.
> >
> >If I have only one event with a period of 1 and with that callchain:
> >
> >	a ->  b ->  c
> >
> >Then I produce three hists
> >
> >	1) a ->  b ->  c
> >	2) a ->  b
> >	3) a
> >
> >Each hist have a period of 1, but the total period is 1.
> >So the end result should be (IIUC):
> >
> >100%    foo     a
> >100%    foo     b
> >                 |
> >                 --- a
> >100%    foo     c
> >                 |
> >                 --- b
> >                     |
> >                     --- c
> >
> 
> That is correct. The first column no longer adds up to 100%.

So do we really want this?

>  		
> >And the percentages on callchain branches will have the same kind
> >of weird things.
> 
> I expect --sort inclusive to be used with -g graph,0.5,caller. I can
> polish this in the next rev where a single top level flag will set this up.
>
> The percentages on the branches should still be accurate (as a
> percentage of total_period). Please let me know if this is not the
> case.
> >
> >So I'm not sure this is a good direction. I'd rather advocate to create
> >true hists for each callers, all having the same real period as the leaf.
> >
> 
> Please see the v5 I just posted. The callers have a true histogram
> entry in every sense, except that period_self == 0.
> 
> If we don't do this, total_period will be inflated.

Yeah right I've just tried and callchains look right. I'm just puzzled
by the percentages:

+  98,99%  [k] execve
+  98,99%  [k] stub_execve
+  98,99%  [k] do_execve
+  98,99%  [k] do_execve_common
+  98,99%  [k] sys_execve
+  53,12%  [k] __libc_start_main
+  53,12%  [k] cmd_record
+  53,12%  [k] T.101
+  53,12%  [k] main
+  53,12%  [k] run_builtin
+  52,11%  [k] perf_evlist__prepare_workload
+  52,09%  [k] T.1163

> 
> >Also this feature reminds me a lot the -b option in perf report.
> >Branch sorting and callchain inclusive sorting are a bit different in
> >the way they handle the things but the core idea is the same. Callchains
> >are branches as well.
> >
> 
> Yes - I kept asking why the branch stack stuff doesn't use the
> existing callchain logic.

Because I fear that loops branches could make the tree representation useless.

> 
> >Branch sorting (-b) adds a hist for every branch taken, and the period
> >is always 1. I wonder if this makes more sense than using the original
> >period of the event for all branches of the event. Not sure.
> >
> >Anyway I wonder if both features can be better integrated. After all
> >they are about the same thing. The difference is that the source of
> >the branches is not the same and that callchains can be depicted into
> >trees.
> >
> >So perhaps we can have -b specifying the desired source, in case both
> >are present: -b callchain and -b branch. Both at the same time wouldn't
> >make much sense I think.
> >
> >And the source could default to either if we don't have callchain and
> >branch at the same time in the events.
> >
> >Just an idea...
> 
> I haven't played much with the branch stack logic. Will do so and get back.
> 
> In the meanwhile, my impression is that there are two high level use cases:
> 
> * Compiler optimizers, tracing JITs etc
> 
> Which try to focus on a single branch and try to understand what
> happened with that branch
> 
> * Programmers who're trying to understand the behavior of the code
> they wrote in production
> 
> I think the branch-stack stuff primarily caters to the former and
> inclusive callchain stuff to the latter. I was thinking that getting
> the branch-stack data into callchains will make the data more useful
> to more people.

I don't know. "if/else" generated branch could be relevant when represented
in a tree like we do for callchains. But I fear this doesn't work anymore
once we deal with loops.

> 
>  -Arun
