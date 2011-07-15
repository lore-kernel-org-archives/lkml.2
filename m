Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1GOSAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:00:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36978 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab1GOSAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:00:06 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
        "MINOURA Makoto / ?$BL'1: ?$B??" <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <1310724097.2586.296.camel@twins>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	 <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
	 <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm>  <20110712041938.GO27254@1wt.eu>
	 <1310690138.3367.61.camel@work-vm>  <1310724097.2586.296.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 10:59:55 -0700
Message-ID: <1310752795.2945.4.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 12:01 +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-14 at 17:35 -0700, john stultz wrote:
> > 
> > Peter/Ingo: Can you take a look at the above and let me know if you find
> > it too disagreeable?
> 
> +static unsigned long long __cycles_2_ns(unsigned long long cyc)
> +{
> +       unsigned long long ns = 0;
> +       struct x86_sched_clock_data *data;
> +       int cpu = smp_processor_id();
> +
> +       rcu_read_lock();
> +       data = rcu_dereference(per_cpu(cpu_sched_clock_data, cpu));
> +
> +       if (unlikely(!data))
> +               goto out;
> +
> +       ns = ((cyc - data->base_cycles) * data->mult) >> CYC2NS_SCALE_FACTOR;
> +       ns += data->accumulated_ns;
> +out:
> +       rcu_read_unlock();
> +       return ns;
> +}
> 
> The way I read that we're still not wrapping properly if freq scaling
> 'never' happens.

Right, this doesn't address the mult overflow behavior. As I mentioned
in the patch that the rework allows for solving that in the future using
a (possibly very rare) timer that would accumulate cycles to ns.

This rework just really addresses the multiplication overflow->negative
roll under that currently occurs with the cyc2ns_offset value.

> Because then we're wrapping on accumulated_ns + 2^54.
> 
> Something like resetting base, and adding ns to accumulated_ns and
> returning the latter would make more sense.

Although we have to update the base_cycles and accumulated_ns
atomically, so its probably not something to do in the sched_clock path.

thanks
-john




