Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2JCIN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:13:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56427 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755793Ab2JCINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:13:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jOrViSivjPrbnn0TcCzqSuTDuvP1KGAmK5xI6/E
	nNC4Ube2tCrHb7
Message-ID: <1349251997.4465.42.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 03 Oct 2012 10:13:17 +0200
In-Reply-To: <1349247011.4465.24.camel@marge.simpson.net>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
	 <1349170282.7086.56.camel@marge.simpson.net>
	 <20121002131421.GN29125@suse.de>
	 <1349247011.4465.24.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 08:50 +0200, Mike Galbraith wrote: 
> On Tue, 2012-10-02 at 14:14 +0100, Mel Gorman wrote: 
> > On Tue, Oct 02, 2012 at 11:31:22AM +0200, Mike Galbraith wrote:
> > > On Tue, 2012-10-02 at 09:45 +0100, Mel Gorman wrote: 
> > > > On Tue, Oct 02, 2012 at 09:49:36AM +0200, Mike Galbraith wrote:
> > > 
> > > > > Hm, 518cd623 fixed up the troubles I saw.  How exactly are you running
> > > > > this?
> > > > > 
> > > > 
> > > > You saw problems with TCP_RR where as this is UDP_STREAM.
> > > 
> > > Yeah, but I wanted to stare at UDP_STREAM as you run it to see if it
> > > would tell me anything about why those numbers happen.
> > > 
> > > > I'm running this through MMTests with a version of the
> > > > configs/config-global-dhp__network-performance file that only runs
> > > > netperf-udp. Ultimately it runs netperf for a size something like
> > > > this
> > > > 
> > > > SIZE=64
> > > > taskset -c 0 netserver
> > > > taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE
> > > 
> > 
> > lock_stat points at the runqueue lock which makes sense as without the
> > IPI the rq->lock has to be taken
> 
> Perf top says we're spinning in ttwu() with NO_TTWU_QUEUE.
> 
> nohz=off idle=halt, netperf -l bignum vs -i 50,6 -I 99,1 -l 20, watching
> with taskset -c 3 perf top -C 1 -U.
> 
> Switch rate rises by nearly 200k/s with NO_TTWU_QUEUE, ttwu() climbs to
> #1 spot.  Annotate shows while (p->on_cpu) cpu_relax() eating ~50% of
> all ttwu() cycles.  Turn TTWU_QUEUE back on, spin evaporates, switch
> rate drops, throughput climbs.  Nifty.

But drop idle=halt, switch rate climbs by ~320k/s, and resched_task()
takes #1 spot.  Hm, maybe perf gets a tad confused monitoring 1 CPU?

NO_TTWU_QUEUE nohz=off idle=halt               TTWU_QUEUE nohz=off idle=halt                  NO_TTWU_QUEUE nohz=off
5.73%  [kernel]   [k] try_to_wake_up           4.40%  [kernel]   [k] sock_alloc_send_pskb     5.02%  [kernel]   [k] resched_task
3.60%  [kernel]   [k] sock_alloc_send_pskb     4.20%  [kernel]   [k] __udp4_lib_lookup        4.00%  [kernel]   [k] sock_alloc_send_pskb
3.25%  [kernel]   [k] udp_sendmsg              3.69%  [kernel]   [k] udp_sendmsg              3.30%  [kernel]   [k] udp_sendmsg
3.05%  [kernel]   [k] __udp4_lib_rcv           3.52%  [kernel]   [k] _raw_spin_lock           3.11%  [kernel]   [k] _raw_spin_lock_irqsave
3.02%  [kernel]   [k] __udp4_lib_lookup        2.96%  [kernel]   [k] dma_issue_pending_all    2.95%  [kernel]   [k] __udp4_lib_lookup
2.73%  [kernel]   [k] _raw_spin_lock_irqsave   2.91%  [kernel]   [k] try_to_wake_up           2.65%  [kernel]   [k] try_to_wake_up
2.68%  [kernel]   [k] sock_def_readable        2.62%  [kernel]   [k] copy_user_generic_string 2.45%  [kernel]   [k] dma_issue_pending_all
2.61%  [kernel]   [k] _raw_spin_lock           2.57%  [kernel]   [k] __ip_append_data.isra.35 2.44%  [kernel]   [k] ksize
2.25%  [kernel]   [k] dma_issue_pending_all    2.36%  [kernel]   [k] fib_table_lookup         2.43%  [kernel]   [k] sock_def_readable
2.21%  [kernel]   [k] __ip_append_data.isra.35 2.27%  [kernel]   [k] sock_def_readable        2.18%  [kernel]   [k] copy_user_generic_string
2.09%  [kernel]   [k] resched_task             2.23%  [kernel]   [k] system_call              2.15%  [kernel]   [k] __ip_append_data.isra.35
1.99%  [kernel]   [k] copy_user_generic_string 2.15%  [kernel]   [k] _raw_spin_lock_irqsave   1.91%  [kernel]   [k] check_preempt_curr
1.96%  [kernel]   [k] fib_table_lookup         1.97%  [kernel]   [k] __udp4_lib_rcv           1.85%  [kernel]   [k] udp_send_skb
1.96%  [kernel]   [k] udp_send_skb             1.81%  [kernel]   [k] __alloc_skb              1.84%  [kernel]   [k] system_call
1.82%  [kernel]   [k] ksize                    1.79%  [kernel]   [k] udp_send_skb             1.80%  [kernel]   [k] _raw_spin_lock
1.75%  [kernel]   [k] system_call              1.77%  [kernel]   [k] __do_softirq             1.78%  [kernel]   [k] __netif_receive_skb
1.73%  [kernel]   [k] __wake_up_common         1.76%  [kernel]   [k] sock_sendmsg             1.74%  [kernel]   [k] task_waking_fair
1.60%  [kernel]   [k] task_waking_fair         1.69%  [kernel]   [k] enqueue_to_backlog       1.70%  [kernel]   [k] __do_softirq

Watching all cores instead. 

switch rate ~890KHz                            switch rate ~570KHz
NO_TTWU_QUEUE nohz=off                         TTWU_QUEUE nohz=off
5.38%  [kernel]  [k] __schedule                4.81%  [kernel]   [k] _raw_spin_lock_irqsave
4.29%  [kernel]  [k] _raw_spin_lock_irqsave    3.36%  [kernel]   [k] __skb_recv_datagram
2.88%  [kernel]  [k] resched_task              2.71%  [kernel]   [k] copy_user_generic_string
2.60%  [kernel]  [k] copy_user_generic_string  2.67%  [kernel]   [k] reschedule_interrupt
2.38%  [kernel]  [k] __switch_to               2.62%  [kernel]   [k] sock_alloc_send_pskb
2.15%  [kernel]  [k] sock_alloc_send_pskb      2.52%  [kernel]   [k] __schedule
2.08%  [kernel]  [k] __skb_recv_datagram       2.31%  [kernel]   [k] try_to_wake_up
1.81%  [kernel]  [k] udp_sendmsg               2.14%  [kernel]   [k] system_call
1.76%  [kernel]  [k] system_call               1.98%  [kernel]   [k] udp_sendmsg
1.73%  [kernel]  [k] __udp4_lib_lookup         1.96%  [kernel]   [k] __udp4_lib_lookup
1.65%  [kernel]  [k] __slab_free.isra.42       1.78%  [kernel]   [k] sock_def_readable
1.62%  [kernel]  [k] try_to_wake_up            1.63%  [kernel]   [k] __slab_free.isra.42
1.43%  [kernel]  [k] update_rq_clock           1.60%  [kernel]   [k] __switch_to
1.43%  [kernel]  [k] sock_def_readable         1.52%  [kernel]   [k] dma_issue_pending_all
1.41%  [kernel]  [k] dma_issue_pending_all     1.48%  [kernel]   [k] __ip_append_data.isra.35
1.40%  [kernel]  [k] menu_select               1.44%  [kernel]   [k] _raw_spin_lock
1.36%  [kernel]  [k] finish_task_switch        1.38%  [kernel]   [k] _raw_spin_unlock_irqrestore
1.30%  [kernel]  [k] ksize                     1.33%  [kernel]   [k] __udp4_lib_rcv

Strange.

	-Mike

