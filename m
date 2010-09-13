Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0IMIIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:08:19 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:43744 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0IMIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:08:18 -0400
Date: Mon, 13 Sep 2010 10:08:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-ID: <20100913080813.GB2310@osiris.boeblingen.de.ibm.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
 <1284116817.402.33.camel@laptop>
 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
 <1284196838.2251.12.camel@laptop>
 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 09:42:16AM -0700, Venkatesh Pallipadi wrote:
> On Sat, Sep 11, 2010 at 2:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-09-10 at 17:28 -0700, Andrew Morton wrote:
> >> Where is this scheduler bug?  Did it occur because someone didn't
> >> understand __smp_call_function_single()?  Or did it occur because the
> >> scheduler code is doing something which its implementors did not expect
> >> or intend?
> >
> >
> > It comes from 83cd4fe2 (sched: Change nohz idle load balancing logic to
> > push model), where nohz_balance_kick() simply needs to kick the
> > designated driver into action.
> >
> > I take it Venki assumed __smp_call_function_single() works like
> > smp_call_function_single() where you can use it for the local cpu as
> > well.
> 
> Yes. This was an oversight while moving from using send_remote_softirq
> to using __smp_call_function_single.
> Also, as we don't have rq lock around this point, it seems possible
> that the CPU that was busy and wants to kick idle load balance on
> remote CPU, could have become idle and nominated itself as idle load
> balancer.
> 
> Below patch looks good to me.
> 
> Acked-by: Venkatesh Pallipadi <venki@google.com>
> 
> I guess, we also need a WARN_ON_ONCE for (cpu == smp_processor_id())
> in __smp_call_function_single(), as the eventual result of this bug
> that Heiko saw was a deadlock

Either that or my generic IPI patch should be applied. At least to me
it was rather surprising to see that smp_call_function_single() and
__smp_call_function_single() behave differently when the 'remote' cpu
is the current cpu.
