Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2CYCPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 22:15:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58806 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2CYCPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 22:15:03 -0400
Date: Sun, 25 Mar 2012 04:14:56 +0200
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
Message-ID: <20120325021451.GA14971@somewhere.redhat.com>
References: <1331746607-6706-1-git-send-email-asharma@fb.com>
 <20120315141402.GA550@somewhere.redhat.com>
 <4F622DCE.4090608@fb.com>
 <20120319155742.GF2660@somewhere>
 <4F691289.7080505@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F691289.7080505@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 04:28:09PM -0700, Arun Sharma wrote:
> On 3/19/12 8:57 AM, Frederic Weisbecker wrote:
> 
> >>>Each hist have a period of 1, but the total period is 1.
> >>>So the end result should be (IIUC):
> >>>
> >>>100%    foo     a
> >>>100%    foo     b
> >>>                 |
> >>>                 --- a
> >>>100%    foo     c
> >>>                 |
> >>>                 --- b
> >>>                     |
> >>>                     --- c
> >>>
> >>
> >>That is correct. The first column no longer adds up to 100%.
> >
> >So do we really want this?
> >
> 
> I think so. It's a different way of presenting the data. Pie chart
> vs a bar chart of OS market share where people may be using more
> than one OS.
> 
> I'll post some documentation updates.

Ok this is one way to do this. The -b option has chosen to use a
period of 1 for everyone.

But both are doing the same thing, except that in the case of
callchains we also rewind the stacktrace at each entry.

But otherwise they deal with the same idea. I wish we have
a unified way of representing both. Either both should use
a period of 1 and add to the total period, or we should use
your way, I don't know. But I have the feeling they shouldn't
be treated differently.

> 
> >>If we don't do this, total_period will be inflated.
> >
> >Yeah right I've just tried and callchains look right. I'm just puzzled
> >by the percentages:
> >
> 
> Thanks for testing this!
> 
> >+  98,99%  [k] execve
> >+  98,99%  [k] stub_execve
> >+  98,99%  [k] do_execve
> >+  98,99%  [k] do_execve_common
> >+  98,99%  [k] sys_execve
> >+  53,12%  [k] __libc_start_main
> >+  53,12%  [k] cmd_record
> 
> These look like they belong to the perf binary and are incorrectly
> classified as kernel samples. Problem is that callchain_get() is not
> populating the privilege level - it's simply propagating the
> privilege level of the sample:

Ah so you should perhaps rather look at the raw callchain from the
sample. It contains the PERF_CONTEXT_* things

> >>>Also this feature reminds me a lot the -b option in perf report.
> >>>Branch sorting and callchain inclusive sorting are a bit different in
> >>>the way they handle the things but the core idea is the same. Callchains
> >>>are branches as well.
> >>>
> >>
> >>Yes - I kept asking why the branch stack stuff doesn't use the
> >>existing callchain logic.
> >
> >Because I fear that loops branches could make the tree representation useless.
> >
> 
> The loops could happen in callgraphs too right (eg: recursive
> programs)?

Right but loops are a common construct used in most programs.
recursive functions are more rare. enough for us to assume
than we can build a tree where branches are often hit more
than one time.

Another thing with callchains VS branches: with callchain we generalize
the sample IPs to the symbol of the function they are contained. We
want this kind of generalization on callchains.

This is not true with branches where details are zoomed. There are less
chances for different branch samples to match each other inside a tree.

> The other problem in branch stacks/LBR is that they're
> sampled branches. Just because I got a sample with:
> 
> a -> b
> b -> c
> 
> doesn't necessarily mean that the callchain was a -> b -> c.

Not sure what you mean. If you have a -> b, b -> c in single
LBR sample it means you got a -> b -> c.

> 
> I still don't have the branch stack setup working properly. But I'm
> now more sympathetic to the view that last branch sampling and
> callchains may have different representations in perf.
> 
>  -Arun
