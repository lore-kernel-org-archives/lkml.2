Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2JCNaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:30:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51005 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755241Ab2JCNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:30:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/nNBA1trfntFHdS6bIquaSsg0/ql+8adV9WHi3Zf
	9dlrdtpuKCKt5b
Message-ID: <1349271001.4465.66.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 03 Oct 2012 15:30:01 +0200
In-Reply-To: <1349251997.4465.42.camel@marge.simpson.net>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
	 <1349170282.7086.56.camel@marge.simpson.net>
	 <20121002131421.GN29125@suse.de>
	 <1349247011.4465.24.camel@marge.simpson.net>
	 <1349251997.4465.42.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 10:13 +0200, Mike Galbraith wrote:

> Watching all cores instead. 
> 
> switch rate ~890KHz                            switch rate ~570KHz
> NO_TTWU_QUEUE nohz=off                         TTWU_QUEUE nohz=off
> 5.38%  [kernel]  [k] __schedule                4.81%  [kernel]   [k] _raw_spin_lock_irqsave
> 4.29%  [kernel]  [k] _raw_spin_lock_irqsave    3.36%  [kernel]   [k] __skb_recv_datagram
> 2.88%  [kernel]  [k] resched_task              2.71%  [kernel]   [k] copy_user_generic_string
> 2.60%  [kernel]  [k] copy_user_generic_string  2.67%  [kernel]   [k] reschedule_interrupt
> 2.38%  [kernel]  [k] __switch_to               2.62%  [kernel]   [k] sock_alloc_send_pskb
> 2.15%  [kernel]  [k] sock_alloc_send_pskb      2.52%  [kernel]   [k] __schedule
> 2.08%  [kernel]  [k] __skb_recv_datagram       2.31%  [kernel]   [k] try_to_wake_up
> 1.81%  [kernel]  [k] udp_sendmsg               2.14%  [kernel]   [k] system_call
> 1.76%  [kernel]  [k] system_call               1.98%  [kernel]   [k] udp_sendmsg
> 1.73%  [kernel]  [k] __udp4_lib_lookup         1.96%  [kernel]   [k] __udp4_lib_lookup
> 1.65%  [kernel]  [k] __slab_free.isra.42       1.78%  [kernel]   [k] sock_def_readable
> 1.62%  [kernel]  [k] try_to_wake_up            1.63%  [kernel]   [k] __slab_free.isra.42
> 1.43%  [kernel]  [k] update_rq_clock           1.60%  [kernel]   [k] __switch_to
> 1.43%  [kernel]  [k] sock_def_readable         1.52%  [kernel]   [k] dma_issue_pending_all
> 1.41%  [kernel]  [k] dma_issue_pending_all     1.48%  [kernel]   [k] __ip_append_data.isra.35
> 1.40%  [kernel]  [k] menu_select               1.44%  [kernel]   [k] _raw_spin_lock
> 1.36%  [kernel]  [k] finish_task_switch        1.38%  [kernel]   [k] _raw_spin_unlock_irqrestore
> 1.30%  [kernel]  [k] ksize                     1.33%  [kernel]   [k] __udp4_lib_rcv
> 
> Strange.

nohz=off, pipe-test with one half pinned to CPU0, the other to CPU1.

procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
TTW_QUEUE
 1  0      0 3039488  50948 444720    0    0     0     0 539724 1013417  1 15 84  0  0
 1  0      0 3039488  50956 444720    0    0     0     1 540853 1015679  1 15 84  0  0
 1  0      0 3039364  50956 444720    0    0     0     0 541630 1017239  1 16 83  0  0
 2  0      0 3038992  50956 444720    0    0     0     0 335550 1096569  4 20 76  0  0
NO_TTWU_QUEUE
 1  0      0 3038992  50956 444720    0    0     0     0 33100 1318984  1 27 71  0  0
 1  0      0 3038868  50956 444720    0    0     0     0 33100 1319126  2 27 71  0  0
 1  0      0 3038868  50956 444720    0    0     0     0 33097 1317968  1 27 72  0  0
 2  0      0 3038868  50964 444720    0    0     0     1 33104 1318558  2 27 71  0  0

We can switch faster with NO_TTWU_QUEUE, so we switch more, and that
hurts netperf UDP_STREAM throughput.. somehow.  Fatter is better is not
the way context switch happy benchmarks usually work.

-Mike

