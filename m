Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2CBK4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:56:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab2CBK4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:56:39 -0500
Date: Fri, 2 Mar 2012 11:56:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [tip:perf/core] perf tools: Allow multiple threads or processes
 in record, stat, top
Message-ID: <20120302105620.GA21762@elte.hu>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <tip-b52956c961be3a04182ae7b776623531601e0fb7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-b52956c961be3a04182ae7b776623531601e0fb7@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David,

* tip-bot for David Ahern <dsahern@gmail.com> wrote:

> Commit-ID:  b52956c961be3a04182ae7b776623531601e0fb7
> Gitweb:     http://git.kernel.org/tip/b52956c961be3a04182ae7b776623531601e0fb7
> Author:     David Ahern <dsahern@gmail.com>
> AuthorDate: Wed, 8 Feb 2012 09:32:52 -0700
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 13 Feb 2012 22:54:11 -0200
> 
> perf tools: Allow multiple threads or processes in record, stat, top
> 
> Allow a user to collect events for multiple threads or processes
> using a comma separated list.
> 
> e.g., collect data on a VM and its vhost thread:
>   perf top -p 21483,21485
>   perf stat -p 21483,21485 -ddd
>   perf record -p 21483,21485
> 
> or monitoring vcpu threads
>   perf top -t 21488,21489
>   perf stat -t 21488,21489 -ddd
>   perf record -t 21488,21489
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1328718772-16688-1-git-send-email-dsahern@gmail.com
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Documentation/perf-record.txt |    4 +-
>  tools/perf/Documentation/perf-stat.txt   |    4 +-
>  tools/perf/Documentation/perf-top.txt    |    4 +-
>  tools/perf/builtin-record.c              |   10 +--
>  tools/perf/builtin-stat.c                |   31 ++++----
>  tools/perf/builtin-test.c                |    2 -
>  tools/perf/builtin-top.c                 |   12 +--
>  tools/perf/perf.h                        |    4 +-
>  tools/perf/util/evlist.c                 |   10 +-
>  tools/perf/util/evlist.h                 |    4 +-
>  tools/perf/util/evsel.c                  |    2 +-
>  tools/perf/util/python-ext-sources       |    2 +
>  tools/perf/util/thread_map.c             |  128 ++++++++++++++++++++++++++++++
>  tools/perf/util/thread_map.h             |    4 +
>  tools/perf/util/top.c                    |   10 +-
>  tools/perf/util/top.h                    |    2 +-
>  tools/perf/util/usage.c                  |    6 +-
>  tools/perf/util/util.h                   |    2 +-
>  18 files changed, 185 insertions(+), 56 deletions(-)

I have a bigger NUMA testbox where perf sampling (perf top, perf 
record, etc.) stopped working (perf stat is fine), and I've 
bisected it back to the above commit.

 b52956c961be3a04182ae7b776623531601e0fb7 is the first bad commit

Checking out eca1c3e3f937 works fine, b52956c961b is broken, 
repeatedly - so the bisection is reliable.

One symptom is no sampling records in the perf.data:

phoenix:~> perf record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.023 MB perf.data (~988 samples) ]
phoenix:~> perf report --stdio
Warning:
The perf.data file has no samples!
# ========
# captured on: Fri Mar  2 12:01:41 2012
# hostname : phoenix
# os release : 3.3.0-rc5+
# perf version : 3.3.rc5.1698.g68a63a.dirty
# arch : x86_64
# nrcpus online : 16
# nrcpus avail : 16
# cpudesc : Quad-Core AMD Opteron(tm) Processor 8356
# cpuid : AuthenticAMD,16,2,3
# total memory : 33012240 kB
# cmdline : /home/mingo/bin/perf record -a sleep 1 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_k
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
phoenix:~> perf --version
perf version 3.3.rc5.1698.g68a63a.dirty
phoenix:~> 

The later fixes to b52956c9, such as:

  6b1bee9035d4: perf tools: fix broken perf record -a mode

did not fix this system - it's still broken as of today's -tip.

Another system running the same kernel does not exhibit this 
problem, so it's somehow specific to this system.

I have not looked deep into this, let me know if you need more 
data.

Thanks,

	Ingo
