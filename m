Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2DJNUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2DJNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:20:33 -0400
Date: Tue, 10 Apr 2012 15:19:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120410131947.GC1650@m.brq.redhat.com>
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
> 
> I'm not sure what the current behaviour of --group is, if you create a
> group like this, do they all sample?
> 
> If so, we need some option like:
> 
>   perf record -e "{cpu-clock,cache-misses,cache-references}:1"
> 
> to mean, only sample on cpu-clock but use PERF_SAMPLE_READ and
> PERF_FORMAT_GROUP to read all siblings on every cpu-clock sample.
hi,

I'm looking on how to present this data in perf and it seems we need
to reset all siblings once we read/store them (in kernel) to the leader
sample.

My current thinking is to store siblings' sum values for each
hists entry of the sample (perf report count unit) .. and display
them in similar way we display callchains: for each hists entry
display the sum value for each sibling.

Could you provide more of your world examples? Your expectations about
presenting this..

Maybe we want to make the reset optional, and do some do some other
math with siblings' values..?

Thoughts? ;)

thanks,
jirka
