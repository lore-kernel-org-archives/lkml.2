Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab2CTWg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867Ab2CTWg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:36:57 -0400
Date: Tue, 20 Mar 2012 23:36:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120320223636.GB1549@m>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332269081.18960.444.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 07:44:41PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-03-20 at 19:15 +0100, Jiri Olsa wrote:
> > Examples (first event in brackets is group leader):
> > 
> >   # 1 group (cpu-clock,task-clock)
> >   perf record --group -e cpu-clock,task-clock ls
> >   perf record --group parsed -e cpu-clock,task-clock ls
> > 
> >   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
> >   perf record --group parsed -e cpu-clock,task-clock \
> >    -e minor-faults,major-faults ls
> > 
> >   # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
> >   perf record --group -e cpu-clock,task-clock \
> >    -e minor-faults,major-faults ls
> > 
> >   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
> >   perf record --group parsed -e cpu-clock,task-clock \
> >    -e minor-faults,major-faults -e instructions ls
> > 
> >   # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
> >   perf record --group -e cpu-clock,task-clock \
> >    -e minor-faults,major-faults -e instructions ls 
> 
> I can't help but dislike the --group/--group parsed thing...
> 
> How about something like:
> 
>   event_group = "{", events, "}" , [ ":", event_group_mod ]
> 
> Such that you can write things like:
> 
>   perf record -e "{cpu-clock,cache-misses,cache-references}"
> 
>   perf stat -e "{cpu-clock,cycles},{cpu-clock,cache-misses,cache-references}"
>   perf stat -e "{cpu-clock,cycles}" -e "{cpu-clock,cache-misses,cache-references}"

there should be no problem with that

> 
> I'm not sure what the current behaviour of --group is, if you create a
> group like this, do they all sample?

I think so.. the --group switch just set the group_fd for the event syscall, nothing else

> 
> If so, we need some option like:
> 
>   perf record -e "{cpu-clock,cache-misses,cache-references}:1"
> 
> to mean, only sample on cpu-clock but use PERF_SAMPLE_READ and
> PERF_FORMAT_GROUP to read all siblings on every cpu-clock sample.

never happy, are you.. ;) seems like nice feature, will check

> 
> Now the disadvantage is that {} needs quotes on bash, the advantage is
> that its completely natural on how to construct groups, without weird
> --group/--group parsed. Also it provides a place for group modifiers.

looks like Arnaldo could use [] but I get different results:

[jolsa@dhcp-26-214 perf]$ ./perf stat -e [cycles,instructions] ls
invalid or unsupported event: 't'

need to check.. maybe escaping is small price for good readability,
but I'll think about some other way as well.

thanks for comments,
jirka
