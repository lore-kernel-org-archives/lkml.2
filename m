Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GUHZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1GUHZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:25:13 -0400
Date: Thu, 21 Jul 2011 09:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>,
        "MINOURA Makoto / ?$BL'1: ?$B??" <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110721072256.GE9216@elte.hu>
References: <20110430093605.GA10529@1wt.eu>
 <20110430173905.GA25641@tty.gr>
 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
 <20110705231515.95bc758f.akpm@linux-foundation.org>
 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
 <1310434819.30337.21.camel@work-vm>
 <20110712041938.GO27254@1wt.eu>
 <1310690138.3367.61.camel@work-vm>
 <1310724097.2586.296.camel@twins>
 <1310752795.2945.4.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752795.2945.4.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> On Fri, 2011-07-15 at 12:01 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-14 at 17:35 -0700, john stultz wrote:
> > > 
> > > Peter/Ingo: Can you take a look at the above and let me know if you find
> > > it too disagreeable?
> > 
> > +static unsigned long long __cycles_2_ns(unsigned long long cyc)
> > +{
> > +       unsigned long long ns = 0;
> > +       struct x86_sched_clock_data *data;
> > +       int cpu = smp_processor_id();
> > +
> > +       rcu_read_lock();
> > +       data = rcu_dereference(per_cpu(cpu_sched_clock_data, cpu));
> > +
> > +       if (unlikely(!data))
> > +               goto out;
> > +
> > +       ns = ((cyc - data->base_cycles) * data->mult) >> CYC2NS_SCALE_FACTOR;
> > +       ns += data->accumulated_ns;
> > +out:
> > +       rcu_read_unlock();
> > +       return ns;
> > +}
> > 
> > The way I read that we're still not wrapping properly if freq scaling
> > 'never' happens.
> 
> Right, this doesn't address the mult overflow behavior. As I mentioned
> in the patch that the rework allows for solving that in the future using
> a (possibly very rare) timer that would accumulate cycles to ns.
> 
> This rework just really addresses the multiplication overflow->negative
> roll under that currently occurs with the cyc2ns_offset value.
> 
> > Because then we're wrapping on accumulated_ns + 2^54.
> > 
> > Something like resetting base, and adding ns to accumulated_ns and
> > returning the latter would make more sense.
> 
> Although we have to update the base_cycles and accumulated_ns
> atomically, so its probably not something to do in the sched_clock path.

Ping, what's going on with this bug? Systems are crashing so we need 
a quick fix ASAP ...

Thanks,

	Ingo
