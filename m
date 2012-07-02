Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab2GBKLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab2GBKLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:11:01 -0400
Date: Mon, 2 Jul 2012 12:10:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
Message-ID: <20120702101010.GB967@krava.redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <1340960907-3725-3-git-send-email-jolsa@redhat.com>
 <87bojync4b.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bojync4b.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:13:56AM +0900, Namhyung Kim wrote:
> On Fri, 29 Jun 2012 11:08:26 +0200, Jiri Olsa wrote:
> > This patch adds a functionality that allows to create event groups
> > based on the way they are specified on the command line. Adding
> > functionality to the '{}' group syntax introduced in earlier patch.
> >
> > The current '--group/-g' option behaviour remains intact.  If you
> > specify it for record/stat/top command, all the specified events
> > become members of a single group with the first event as a group
> > leader.
> >
> > With the new '{}' group syntax you can create group like:
> >   # perf record -e '{cycles,faults}' ls
> >
> > resulting in single event group containing 'cycles' and 'faults'
> > events, with cycles event as group leader.
> >
> > All groups are created with regards to threads and cpus. Thus
> > recording an event group within a 2 threads on server with
> > 4 CPUs will create 8 separate groups.
> >
> > Examples (first event in brackets is group leader):
> >
> >   # 1 group (cpu-clock,task-clock)
> >   perf record --group -e cpu-clock,task-clock ls
> >   perf record -e '{cpu-clock,task-clock}' ls
> >
> >   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
> >   perf record -e '{cpu-clock,task-clock},{minor-faults,major-faults}' ls
> >
> >   # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
> >   perf record --group -e cpu-clock,task-clock -e minor-faults,major-faults ls
> >   perf record -e '{cpu-clock,task-clock,minor-faults,major-faults}' ls
> >
> >   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
> >   perf record -e '{cpu-clock,task-clock} -e '{minor-faults,major-faults}' \
> >    -e instructions ls
> >
> >   # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
> >   perf record --group -e cpu-clock,task-clock \
> >    -e minor-faults,major-faults -e instructions ls
> >   perf record -e '{cpu-clock,task-clock,minor-faults,major-faults,instructions}' ls
> >
> > It's possible to use standard event modifier for a group, which spans
> > over all events in the group and overrides any event modifier settings,
> > for example:
> >
> >   # perf record -r '{faults:k,cache-references}:u'
> >
> > resulting in ':u' modifier being used for both 'faults' and 'cache-references'
> > events, regardless of their modifier setup (':k' for faults event).
> >
> 
> So the faults event would get only 'u' for the modifier not 'uk', right?

right

jirka
