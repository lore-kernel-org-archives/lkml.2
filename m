Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0DNACd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:02:33 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51975 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0DNACa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dbwdn30WjlSfnXODdFPArOwMy4eVJtNqhR2imLI6dYEr3EhwD5OYmOpgMOir01YAOe
         0IFqGEhytWK56naVe6qdlVJlglksHMo5z539ZLNLccxlVQS02F0t3Xn0coMrWf23cSBF
         a574q6CDC0C+Vedg827TzorcZMGVLCr4ARR5k=
Date: Wed, 14 Apr 2010 02:02:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       SparcLinux <sparclinux@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weird rcu lockdep warning
Message-ID: <20100414000226.GH5602@nowhere>
References: <20100413200432.GB5099@nowhere> <20100413234043.GG2538@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413234043.GG2538@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 04:40:43PM -0700, Paul E. McKenney wrote:
> On Tue, Apr 13, 2010 at 10:04:36PM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > I just ran the following on -rc4 with the latest pending sparc pull
> > request manually merged (no -tip bits):
> > 
> > 	perf record -a -f -g sleep 5
> > 
> > And I got this warning:
> > 
> > 
> > [ 2235.846071] ===================================================
> > [ 2235.857419] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [ 2235.863127] ---------------------------------------------------
> > [ 2235.868734] kernel/perf_event.c:2232 invoked rcu_dereference_check() without protection!
> > [ 2235.879843] 
> > [ 2235.879848] other info that might help us debug this:
> > [ 2235.879855] 
> > [ 2235.895659] 
> > [ 2235.895663] rcu_scheduler_active = 1, debug_locks = 0
> > [ 2235.905505] 1 lock held by swapper/0:
> > [ 2235.910333]  #0:  (&ctx->lock){-.....}, at: [<00000000004d9e00>] __perf_event_enable+0x60/0x1e8
> 
> As far as lockdep is concerned, we are not in an RCU read-side critical
> section.



Yeah :-/



> Very strange indeed.
> 
> One question -- is it possible that your kernel does not match your
> source code?  I freely admit that it is extremely unlikely that such
> a mismatch would happen to land on an rcu_dereference(), but...


No, for example I just found the same problem in x86 in -tip:


===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/perf_event.c:2236 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by perf/3466:
 #0:  (&ctx->mutex){+.+...}, at: [<c10bc567>] sys_perf_event_open+0x2a7/0x420
 #1:  (&ctx->lock){-.....}, at: [<c10b940f>] __perf_install_in_context+0x6f/0x160

stack backtrace:
Pid: 3466, comm: perf Not tainted 2.6.34-rc3-atom #411
Call Trace:
 [<c150f95f>] ? printk+0x1d/0x1f
 [<c1075f8a>] lockdep_rcu_dereference+0xaa/0xb0
 [<c10b8c01>] perf_event_update_userpage+0x151/0x190
 [<c10b8ab0>] ? perf_event_update_userpage+0x0/0x190
 [<c1010931>] x86_perf_event_set_period+0x101/0x1d0
 [<c1010cf2>] intel_pmu_save_and_restart+0x12/0x20
 [<c1013743>] intel_pmu_handle_irq+0x1d3/0x4e0
 [<c1069b08>] ? sched_clock_cpu+0x128/0x170
 [<c1074e8b>] ? trace_hardirqs_off+0xb/0x10
 [<c1069b9f>] ? cpu_clock+0x4f/0x60
 [<c1074e8b>] ? trace_hardirqs_off+0xb/0x10
 [<c1069b9f>] ? cpu_clock+0x4f/0x60
 [<c1078105>] ? __lock_acquire+0x1c5/0x1900
 [<c1069942>] ? sched_clock_local+0xd2/0x170
 [<c100f180>] perf_event_nmi_handler+0x40/0x50
 [<c1068885>] notifier_call_chain+0x35/0x70
 [<c1068eec>] __atomic_notifier_call_chain+0x6c/0xb0
 [<c1068e80>] ? __atomic_notifier_call_chain+0x0/0xb0
 [<c1068f4f>] atomic_notifier_call_chain+0x1f/0x30
 [<c1068f8d>] notify_die+0x2d/0x30
 [<c100428c>] do_nmi+0x16c/0x350
 [<c1074f36>] ? lock_release_holdtime+0xa6/0x1a0
 [<c151458d>] nmi_stack_correct+0x28/0x2d
 [<c10104cc>] ? intel_pmu_enable_all+0x8c/0x110
 [<c1010c5a>] hw_perf_enable+0x1ba/0x240
 [<c10b7df5>] perf_enable+0x25/0x30
 [<c10b94b7>] __perf_install_in_context+0x117/0x160
 [<c10807f6>] smp_call_function_single+0x76/0x170
 [<c10b93a0>] ? __perf_install_in_context+0x0/0x160
 [<c10bb34d>] perf_install_in_context+0x7d/0x80
 [<c10bc575>] sys_perf_event_open+0x2b5/0x420
 [<c1002c4c>] sysenter_do_call+0x12/0x32



> 
> Another unlikely possibility is that an interrupt occurred between
> the rcu_read_lock() and the rcu_dereference(), and that this interrupt
> had an extra unmatched rcu_read_unlock().


I fear it's too easily reproducible (for me at least) and too well localized
(always the same place) to be a random interrupt there.

I just have a guess though....
This seems to always happen from NMI path, and lockdep is disabled on NMI.
I suspect the lock_acquire() performed by rcu_read_lock() is just ignored
and then the rcu_read_lock_held() check has the wrong result...

