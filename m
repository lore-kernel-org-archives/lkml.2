Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LILIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:08:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32217 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1LILIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:08:01 -0500
Message-ID: <4EE1EC0B.4020600@openvz.org>
Date: Fri, 09 Dec 2011 15:07:55 +0400
From: Andrey Vagin <avagin@openvz.org>
Reply-To: avagin@openvz.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere> <4EE01ACB.1000102@fb.com>
In-Reply-To: <4EE01ACB.1000102@fb.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arun,
>
> Agreed on remote callchains and maintaining consistency about what the
> tracepoints mean.
>
> As I said on the other thread, post-processing in userspace has the
> issue that we collect more info than we actually need and under load,
> perf record can't keep up.
>
> Attached is an alternative approach that does what you allude to above.

* Your method doesn't work for rt scheduler.
* It doesn't distinguish blocking time and sleeping time.
* This patch does a bit mess between subsystems...

Yes, this method may have the right to life. Could you correct this 
patch and send it in lkml as a separate mail?

>
> perf record -agPe sched:sched_switch --filter "delay > 1000000" -- sleep 1

Why do you need the option "-a" ?

>
> allows us to collect a lot less. For some reason, "perf script" shows

> the correct delay field, but the sample period still contains 1 (i.e
> __perf_count() hint is not working for me).

Which kernel do you use? Does it contain "[PATCH] event: don't divide 
events if it has field period"? It works fine with my kernel...

>
> -Arun


> +#ifdef CONFIG_SCHEDSTATS
> + 		__entry->delay		= next->se.statistics.block_start ? next->se.statistics.block_start
> + 					  : next->se.statistics.sleep_start ? next->se.statistics.sleep_start : 0;
The previous code is hard to read...
> + 		__entry->delay = __entry->delay ? now - __entry->delay : 0;
> +#else
> + 		__entry->delay = 0;
> +#endif
next->se.statistics.{block,sleep}_start should be zeroized here, 
otherwise a next sched_switch will report non-zero delay again.
> +	)
