Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2GBCSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:18:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58033 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2GBCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:18:12 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-ee-4ff104e14f0f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<1340960907-3725-3-git-send-email-jolsa@redhat.com>
Date: Mon, 02 Jul 2012 11:13:56 +0900
In-Reply-To: <1340960907-3725-3-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 29 Jun 2012 11:08:26 +0200")
Message-ID: <87bojync4b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012 11:08:26 +0200, Jiri Olsa wrote:
> This patch adds a functionality that allows to create event groups
> based on the way they are specified on the command line. Adding
> functionality to the '{}' group syntax introduced in earlier patch.
>
> The current '--group/-g' option behaviour remains intact.  If you
> specify it for record/stat/top command, all the specified events
> become members of a single group with the first event as a group
> leader.
>
> With the new '{}' group syntax you can create group like:
>   # perf record -e '{cycles,faults}' ls
>
> resulting in single event group containing 'cycles' and 'faults'
> events, with cycles event as group leader.
>
> All groups are created with regards to threads and cpus. Thus
> recording an event group within a 2 threads on server with
> 4 CPUs will create 8 separate groups.
>
> Examples (first event in brackets is group leader):
>
>   # 1 group (cpu-clock,task-clock)
>   perf record --group -e cpu-clock,task-clock ls
>   perf record -e '{cpu-clock,task-clock}' ls
>
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record -e '{cpu-clock,task-clock},{minor-faults,major-faults}' ls
>
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
>   perf record --group -e cpu-clock,task-clock -e minor-faults,major-faults ls
>   perf record -e '{cpu-clock,task-clock,minor-faults,major-faults}' ls
>
>   # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
>   perf record -e '{cpu-clock,task-clock} -e '{minor-faults,major-faults}' \
>    -e instructions ls
>
>   # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
>   perf record --group -e cpu-clock,task-clock \
>    -e minor-faults,major-faults -e instructions ls
>   perf record -e '{cpu-clock,task-clock,minor-faults,major-faults,instructions}' ls
>
> It's possible to use standard event modifier for a group, which spans
> over all events in the group and overrides any event modifier settings,
> for example:
>
>   # perf record -r '{faults:k,cache-references}:u'
>
> resulting in ':u' modifier being used for both 'faults' and 'cache-references'
> events, regardless of their modifier setup (':k' for faults event).
>

So the faults event would get only 'u' for the modifier not 'uk', right?

Thanks,
Namhyung

