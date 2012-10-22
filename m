Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2JVLrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:47:11 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:44332 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2JVLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:47:09 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 982FA83700
Date: Mon, 22 Oct 2012 13:46:57 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/3] sched: introduce distinct per-cpu load average
Message-ID: <20121022114657.GA32659@thinkpad>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
 <1350759962-7092-2-git-send-email-andrea@betterlinux.com>
 <1350904240.2768.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350904240.2768.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 01:10:40PM +0200, Peter Zijlstra wrote:
> On Sat, 2012-10-20 at 21:06 +0200, Andrea Righi wrote:
> > @@ -383,13 +383,7 @@ struct rq {
> >         struct list_head leaf_rt_rq_list;
> >  #endif
> >  
> 
> > +       unsigned long __percpu *nr_uninterruptible; 
> 
> This is O(nr_cpus^2) memory..
> 

Correct, this doesn't add too much overhead to the wakeup/sleep path,
but it's bad both in terms of memory and performance overhead in the
other parts of the code for large SMP systems.

> 
> > +unsigned long nr_uninterruptible_cpu(int cpu)
> > +{
> > +       struct rq *this = cpu_rq(cpu);
> > +       unsigned long val = 0;
> > +       int i;
> > +
> > +       for_each_online_cpu(i)
> > +               val += per_cpu(*this->nr_uninterruptible, i);
> > +
> > +       return val;
> > +}
> > 
> > 
> I suspect you've got an accounting leak here on hot-plug.

And I think you're right about the accounting leak with cpu hotplug.
I'll do more tests with this part, until I come up with a better idea
in general for the nr_uninterruptible accounting.

Thanks!
-Andrea

> > 
> >  unsigned long nr_uninterruptible(void)
> >  {
> >         unsigned long i, sum = 0;
> >  
> >         for_each_possible_cpu(i)
> > -               sum += cpu_rq(i)->nr_uninterruptible;
> > +               sum += nr_uninterruptible_cpu(i);
> >  
> >         /*
> >          * Since we read the counters lockless, it might be slightly
> 
> And this makes O(n^2) runtime!
> 
