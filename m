Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2CTSpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:45:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2CTSpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:45:05 -0400
Message-ID: <1332269081.18960.444.camel@twins>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 20 Mar 2012 19:44:41 +0100
In-Reply-To: <1332267341-26338-4-git-send-email-jolsa@redhat.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
	 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 19:15 +0100, Jiri Olsa wrote:
> Examples (first event in brackets is group leader):
> 
>   # 1 group (cpu-clock,task-clock)
>   perf record --group -e cpu-clock,task-clock ls
>   perf record --group parsed -e cpu-clock,task-clock ls
> 
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record --group parsed -e cpu-clock,task-clock \
>    -e minor-faults,major-faults ls
> 
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
>   perf record --group -e cpu-clock,task-clock \
>    -e minor-faults,major-faults ls
> 
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record --group parsed -e cpu-clock,task-clock \
>    -e minor-faults,major-faults -e instructions ls
> 
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
>   perf record --group -e cpu-clock,task-clock \
>    -e minor-faults,major-faults -e instructions ls 

I can't help but dislike the --group/--group parsed thing...

How about something like:

  event_group = "{", events, "}" , [ ":", event_group_mod ]

Such that you can write things like:

  perf record -e "{cpu-clock,cache-misses,cache-references}"

  perf stat -e "{cpu-clock,cycles},{cpu-clock,cache-misses,cache-references}"
  perf stat -e "{cpu-clock,cycles}" -e "{cpu-clock,cache-misses,cache-references}"

I'm not sure what the current behaviour of --group is, if you create a
group like this, do they all sample?

If so, we need some option like:

  perf record -e "{cpu-clock,cache-misses,cache-references}:1"

to mean, only sample on cpu-clock but use PERF_SAMPLE_READ and
PERF_FORMAT_GROUP to read all siblings on every cpu-clock sample.

Now the disadvantage is that {} needs quotes on bash, the advantage is
that its completely natural on how to construct groups, without weird
--group/--group parsed. Also it provides a place for group modifiers.
