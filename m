Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1JZLSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 07:18:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64200 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab1JZLSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 07:18:31 -0400
Date: Wed, 26 Oct 2011 09:18:28 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
Message-ID: <20111026111828.GB9467@ghostprotocols.net>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
 <1319453820-12992-3-git-send-email-dczhu@mips.com>
 <20111024140328.GA5770@ghostprotocols.net>
 <20111025152309.GA7623@ghostprotocols.net>
 <4EA7A7FB.40304@mips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA7A7FB.40304@mips.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 26, 2011 at 02:26:03PM +0800, Deng-Cheng Zhu escreveu:
> On 10/25/2011 11:23 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Oct 24, 2011 at 12:03:28PM -0200, Arnaldo Carvalho de Melo escreveu:
> >>Em Mon, Oct 24, 2011 at 06:57:00PM +0800, Deng-Cheng Zhu escreveu:
> >>>__perf_evsel__open() is called per event, it does not work for all the
> >>>grouped events at one time. So, currently group_fd will alway be -1 for

<SNIP>

> >>>+			static int group_fd = -1;
> >>>  			if (!evsel->cgrp)
> >>>  				pid = threads->map[thread];

> >>Lets not do it that way, using statics for this is humm, ugly, IMHO.

> >Can you try this patch?

> >I tested it with:

> >[root@emilia ~]# perf top -e cycles -e instructions --group

> Your patch does fix the group fd issue. But to get event grouping
> workable, the event state fix is still needed. Please see the discussion

Can I have your "Reviewed-by:" or "Tested-by:" tag for this patch then?

> here: http://www.spinics.net/lists/mips/msg42190.html
 
> With _only_ your patch applied, I tested with the following commands on
> MIPS 74K (4 counters available in total):
> 
> perf stat -g -e
> L1-dcache-load-misses,cycles,LLC-load-misses,iTLB-loads,instructions
> find / >/dev/null
> 
> I tried to group up to 5 events in the hope of seeing NOSPC error. But
> the command didn't fail and output:
> 
>  Performance counter stats for 'find /':
> 
>            9300823 L1-dcache-load-misses
>      <not counted> cycles
>      <not counted> LLC-load-misses
>      <not counted> iTLB-loads
>      <not counted> instructions
> 
>        8.463207591 seconds time elapsed
> 
> This is due to the event state check in validate_group() filtering out
> the grouped events in OFF state. They are in OFF state because we are
> running the command with the perf tool as opposed to attaching to an
> existing task:
> 
> builtin-stat.c:create_perf_stat_counter():
> 
>         if (target_pid == -1 && target_tid == -1) {
>                 attr->disabled = 1;
>                 attr->enable_on_exec = 1;
>         }

But they should be in OFF state only till the target program gets
exec'ed, right?
 
> I suppose X86 has this issue too -- collect_events() in validate_group()
> won't do real work in the bottom half of the function.

I'm testing that now.

- Arnaldo
