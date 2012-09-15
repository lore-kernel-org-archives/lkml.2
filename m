Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2IOOrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 10:47:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38399 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751845Ab2IOOro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 10:47:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18dTBwExdIdWDC7mVTzpvazsWwgcJSo8EyHZ5Ocus
	R7r0DChLHauKG2
Message-ID: <1347720459.7256.11.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 16:47:39 +0200
In-Reply-To: <20120915104451.GC12364@liondog.tnic>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <1347682262.4340.160.camel@marge.simpson.net>
	 <20120915104451.GC12364@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-15 at 12:44 +0200, Borislav Petkov wrote: 
> On Sat, Sep 15, 2012 at 06:11:02AM +0200, Mike Galbraith wrote:
> > My wild (and only) theory is that this is userspace spinlock related.
> > If so, starting the server and benchmark SCHED_BATCH should not only
> > kill the regression, but likely improve throughput as well.
> 
> FWIW,
> 
> I went and tried it. Here are the exact steps:
> 
> $ ps ax | grep postgres
>  2066 ?        S      0:01 /usr/lib/postgresql/9.1/bin/postgres -D /var/lib/postgresql/9.1/main -c config_file=/etc/postgresql/9.1/main/postgresql.conf
>  2070 ?        Ss     0:07 postgres: writer process
>  2071 ?        Ss     0:05 postgres: wal writer process
>  2072 ?        Ss     0:01 postgres: autovacuum launcher process
>  2073 ?        Ss     0:01 postgres: stats collector process
>  5788 pts/0    S+     0:00 grep postgres
> 
> # set to SCHED_BATCH
> $ schedtool -B 2066 2070 2071 2072 2073
> 
> # verify:
> $ schedtool 2066 2070 2071 2072 2073
> PID  2066: PRIO   0, POLICY B: SCHED_BATCH   , NICE   0, AFFINITY 0x3f
> PID  2070: PRIO   0, POLICY B: SCHED_BATCH   , NICE   0, AFFINITY 0x3f
> PID  2071: PRIO   0, POLICY B: SCHED_BATCH   , NICE   0, AFFINITY 0x3f
> PID  2072: PRIO   0, POLICY B: SCHED_BATCH   , NICE   0, AFFINITY 0x3f
> PID  2073: PRIO   0, POLICY B: SCHED_BATCH   , NICE   0, AFFINITY 0x3f
> 
> $ su - postgres
> postgres@hhost:~$ export PATH=$PATH:/usr/lib/postgresql/9.1/bin/
> postgres@hhost:~$ schedtool -B -e pgbench -i pgbench && pgbench -c 10 -t 10000 pgbench
> 
> ...
> 
> tps = 4388.118940 (including connections establishing)
> tps = 4391.771875 (excluding connections establishing)
> 
> => even better than the results with 3.5 (had something around 3900ish
> on that particular configuration).

Increasing /proc/sys/kernel/sched_min_granularity_ns to roughly half of
sched_latency_ns should also help.  That will allow LAST_BUDDY to do
it's job, try to hand the CPU back to a preempted task if possible.  The
change that increased sched_nr_latency to 8 should have injured
postgress as well.  ATM, it's disabled unless you're massively loaded.

I _think_ it's about preemption, but it doesn't matter, patch is toast.

-Mike

