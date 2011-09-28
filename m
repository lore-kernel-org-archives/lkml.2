Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1I1KgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:36:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:44291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1I1KgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:36:08 -0400
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 28 Sep 2011 12:35:24 +0200
In-Reply-To: <20110928101357.5a90c2ab@de.ibm.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-5-git-send-email-glommer@parallels.com>
	 <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317206124.20318.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:13 +0200, Martin Schwidefsky wrote:
> On Wed, 28 Sep 2011 00:00:37 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> > > @@ -1039,6 +1035,8 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
> > >         INIT_LIST_HEAD(&tsk->cpu_timers[2]);
> > >  }
> > >  
> > > +struct task_group *task_group(struct task_struct *p);
> > 
> > That doesn't appear to be actually used in this file..
> > 
> > Also, since there's already a for_each_possible_cpu() loop in that
> > proc/stat function, would it yield some code improvement to make
> > total_forks a cpu_usage_stat?
> > 
> > I guess the whole cputime64_t crap gets in the way of that being
> > natural... 
> > 
> > We could of course kill off the cputime64_t thing, its pretty pointless
> > and its a u64 all over the board. I think Martin or Heiko created this
> > stuff (although I might be wrong, my git tree doesn't go back that far).
> 
> The reason to introduce cputime_t has been that different architecture
> needed differently sized integers for their respective representation
> of cputime. On x86-32 the number of ticks is recorded in a u32, on s390
> we needed a u64 for the cpu timer values. cputime64_t is needed for
> cpustat and other sums of cputime that would overflow a cputime_t
> (in particular on x86-32 with the u32 cputime_t and the u64 cputime64_t).
> 
> Now we would convert everything to u64 but that would cause x86-32 to
> use 64-bit arithmetic for the tick counter. If that is acceptable I
> can't say.

Right, so the main point was about cputime64_t, we might as well use a
u64 for that throughout and ditch the silly cputime64_$op() accessors
and write normal code.

But even if cputime_t differs between 32 and 64 bit machines, there is
no reason actually use cputime_add(), C can do this.

The only reason to use things like cputime_add() is if you use a non
simple type, but that doesn't seem to be the case.

So I think we can simplify the code lots by doing away with cputime64_t
and all the cputime_*() functions. We can keep cputime_t, or we can use
unsigned long, which I think will end up doing pretty much the same.

That is, am I missing some added value of all this cputime*() foo?
