Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1JQOHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:07:43 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:45873 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1JQOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:07:42 -0400
Date: Mon, 17 Oct 2011 16:07:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017160736.6fc6caef@de.ibm.com>
In-Reply-To: <1318847658.6594.40.camel@twins>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<20111007070842.GA27555@hostway.ca>
	<20111007174848.GA11011@hostway.ca>
	<1318010515.398.8.camel@twins>
	<20111008005035.GC22843@hostway.ca>
	<1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	<1318847658.6594.40.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 12:34:18 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > And
> > why does "cputime_add()" exist at all? It seems to always be just a
> > plain add, and nothing else would seem to ever make sense *anyway*?
> 
> Martin and me were discussing the merit of that only a few weeks ago ;-)

I took my old cputime debug patch and compiled the latest git tree with it.
The compiler found a few places where fishy things happen:

1) fs/proc/uptime.c
static int uptime_proc_show(struct seq_file *m, void *v)
{
	...
        cputime_t idletime = cputime_zero;

        for_each_possible_cpu(i)
                idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
	...
        cputime_to_timespec(idletime, &idle);
	...
}

idletime is a 32-bit integer on x86-32. The sum of the idle time over all
cpus will quickly overflow, e.g. consider HZ=1000 on a quad-core. It would
overflow after 12.42 days (2^32 / 1000 / 4 / 86400).

2) kernel/posix-cpu-timers.c
/*                                                                              
 * Divide and limit the result to res >= 1                                      
 *                                                                              
 * This is necessary to prevent signal delivery starvation, when the result of  
 * the division would be rounded down to 0.                                     
 */
static inline cputime_t cputime_div_non_zero(cputime_t time, unsigned long div)
{
        cputime_t res = cputime_div(time, div);

        return max_t(cputime_t, res, 1);
}

A cputime of 1 on s390 is 0.244 nano seconds, I have my doubts if that will
prevent signal starvation. Fortunately the function is unused and can be
removed.

3) kernel/itimer
enum hrtimer_restart it_real_fn(struct hrtimer *timer)
{
        struct signal_struct *sig =
                container_of(timer, struct signal_struct, real_timer);

        trace_itimer_expire(ITIMER_REAL, sig->leader_pid, 0);
        kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);

        return HRTIMER_NORESTART;
}

trace_itimer_expire take a cputime as third argument. That should be
cputime_zero in the current notation, same in do_setitimer. After the
conversion all cputime_zero occurences would be replaced with 0.

4) kernel/sched.c
#define CPUACCT_BATCH   \
        min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX)

If cputime_t is defined as an 64-bit type on a 32-bit architecture the
CPUACCT_BATCH definition can break. Should work for the existing code
though.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

