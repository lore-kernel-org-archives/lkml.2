Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1ERXNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:13:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64722 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1ERXNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xH0jebwtiRmzMXN5gfaVIZcqZSBRWxY4V61Bf1e/LSJfqb810G0Yp0rbTJC6EnYzXu
         4pXPAP1xacE5HBIZTLEnzIvP8LCIwjTSiCUxwy8CAIs/iixw9xkniJJwuGuePZVcasiO
         f4NwxBpiqEjFdbxwmQEHMBogTH1lWqdC2FB6w=
Date: Thu, 19 May 2011 01:13:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110518231314.GA1723@nowhere>
References: <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
 <20110517024000.GA5026@nowhere>
 <4DD435C2.6040305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD435C2.6040305@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 02:10:26PM -0700, Yinghai Lu wrote:
> On 05/16/2011 07:40 PM, Frederic Weisbecker wrote:
> > On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
> >> On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
> >>>
> >>> * Ingo Molnar <mingo@elte.hu> wrote:
> >>>
> >>>>> In the meantime, would you be willing to try out the patch at 
> >>>>> https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> >>>>> several configurations.
> >>>>
> >>>> Wasn't this the one i tested - or is it a new iteration?
> >>>>
> >>>> I'll try it in any case.
> >>>
> >>> oh, this was a new iteration, mea culpa!
> >>>
> >>> And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
> >>
> >> ;-)
> >>
> >> Unfortunately, the only reason I can see that it works is (1) there
> >> is some obscure bug in my code or (2) someone somewhere is failing to
> >> call irq_exit() on some interrupt-exit path.  Much as I might be tempted
> >> to paper this one over, I believe that we do need to find whatever the
> >> underlying bug is.
> >>
> >> Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
> >> a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
> >> But I couldn't see any evidence of this in my admittedly cursory scan
> >> of the x86 interrupt-handling code.
> >>
> >> So until I learn differently, I am assuming that each and every
> >> irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
> >> is called after the final irq_exit() of a given burst of interrupts.
> >>
> >> If my assumptions are mistaken, please do let me know!
> > 
> > So it would be nice to have a trace of the calls to rcu_irq_*() / rcu_*_nohz()
> > before the unpairing happened.
> > 
> > I have tried to reproduce it but couldn't trigger anything.
> > 
> > So it would be nice if Yinghai can test the patch below, since he was able
> > to trigger the warning.
> > 
> > This is essentially Paul's patch but with stacktrace of the calls recorded.
> > Then the whole trace is dumped on the console when one of the WARN_ON_ONCE
> > sanity check is positive. Beware as the trace will be dumped everytime
> > WARN_ON_ONCE() is positive. So the first dump is enough, you can ignore the
> > rest.
> > 
> > This requires CONFIG_TRACING. May be a good thing to boot with
> > "ftrace=nop" parameter, so that ftrace will set up a long enough buffer
> > to have an interesting trace.
> 
> with this patches if the kernel is compiled from opensuse 11.3 no delay anymore, but have one warning:
> 
> [   82.895182] ------------[ cut here ]------------
> [   82.895189] WARNING: at kernel/rcutree.c:352 rcu_enter_nohz+0x49/0x8b()
> [   82.895193] Switched to NOHz mode on CPU #90
> [   82.895199] Switched to NOHz mode on CPU #8
> [   82.895202] Modules linked in:
> [   82.895206] Switched to NOHz mode on CPU #28
> [   82.895211] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-05234-g3a108a0-dirty #1016
> [   82.895213] Call Trace:
> [   82.895233]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
> [   82.895238]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
> [   82.895242]  [<ffffffff810d32cc>] rcu_enter_nohz+0x49/0x8b
> [   82.895250]  [<ffffffff810ab121>] tick_nohz_stop_sched_tick+0x27d/0x366
> [   82.895255]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
> [   82.895261]  [<ffffffff81bda6e3>] rest_init+0xb7/0xbe
> [   82.895266]  [<ffffffff81bda62c>] ? csum_partial_copy_generic+0x16c/0x16c
> [   82.895272]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
> [   82.895276]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
> [   82.895281]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
> [   82.895290] ---[ end trace 2cfc591bf7de931f ]---
> [   82.895310] Switched to NOHz mode on CPU #72
> [   82.895315] Dumping ftrace buffer:
> [   82.895328] ---------------------------------
> [   82.895340] CPU:0 [LOST 35328 EVENTS]
> [   82.895341]   <idle>-0       0d... 82735399us : Unknown type 4

Doh, ftrace couldn't recognize that trace is of stacktrace type. We
need to initialize the events output earlier.

Sorry, can you retry after applying the following patch?

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index cf535cc..ad92d9c 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1278,4 +1278,4 @@ __init static int init_events(void)
 
 	return 0;
 }
-device_initcall(init_events);
+early_initcall(init_events);
