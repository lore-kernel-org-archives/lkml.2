Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1BVPjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:39:13 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55520 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1BVPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:39:11 -0500
Message-ID: <4D63D685.2010401@dcl.info.waseda.ac.jp>
Date: Wed, 23 Feb 2011 00:30:13 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年02月23日 00:28, Hitoshi Mitake wrote:
> From: Hitoshi Mitake<h.mitake@gmail.com>
>
> Hi Frederic, really sorry for my slow work...
>
> This patch cleans the options passed for perf record(or cmd_record()).
> 1. remove ":r" at the tail of the name of events, because it is not supported now
> 2. remove "-f" deprecated option, because it is already default
>
> Signed-off-by: Hitoshi Mitake<h.mitake@gmail.com>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
> Cc: Steven Rostedt<rostedt@goodmis.org>
> ---
>   tools/perf/builtin-lock.c |    9 ++++-----
>   1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index e00d938..2359f52 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -926,13 +926,12 @@ static const struct option lock_options[] = {
>   static const char *record_args[] = {
>   	"record",
>   	"-R",
> -	"-f",
>   	"-m", "1024",
>   	"-c", "1",
> -	"-e", "lock:lock_acquire:r",
> -	"-e", "lock:lock_acquired:r",
> -	"-e", "lock:lock_contended:r",
> -	"-e", "lock:lock_release:r",
> +	"-e", "lock:lock_acquire",
> +	"-e", "lock:lock_acquired",
> +	"-e", "lock:lock_contended",
> +	"-e", "lock:lock_release",
>   };
>
>   static int __cmd_record(int argc, const char **argv)


BTW, I have a proposal of changing the way of tracing lock event.

Currently, lockdep functions generate lock events (e.g. lock_acquire
and trace_lock_acquire). I don't think that lockdep is an optimal
place for lock event tracing, because:

1. Some subsystems (e.g. workqueue) uses lockdep for their own
validation. It is confusing for modeling locking sequence. I don't
think that the events from lockdep is needless, this might be useful
for trouble shooting or other purposes. But it is not suitable for 
performance analyzing oriented tracing.

2. Currently, every type of lock (spinlock, rwlock, mutex, rwsem)
employs common event tracing. This is not suitable from the perspective 
of the overhead of tracing. Even if a user only looks at the one type
of locks, tracing produces the overhead of the entire. This is harmful 
because lock event is high frequency. <type>_acquire (e.g.
spin_acquire) might be suitable place for putting tracing.

So making new classes of lock event per types is suitable. Tracing
the one of them or combination of them will be better from the 
perspectives of both of modeling and performance.

How do you think about it?

# Shamefully, I still cannot show the concrete example of performance
# improvement by perf lock. It is another big problem... :(

Thanks,
	Hitoshi
