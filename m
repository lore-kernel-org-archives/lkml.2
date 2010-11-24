Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0KXUpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:45:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64648 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0KXUpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QdzNRb6h1APK2EQk1jN3X8wq0pKockSdhtj4Qo75FR2cb3eNaZR5J8Lo+xXB5cpb10
         Rdj/wXlyImYKHr1AQf9s50PzlNjim68y+5BrnNdDk4YA4MSDHEoRyOcWovGpFlBRWXrx
         ESmYyLwuYjWq0EFxntRYJYk4wihxcs59ZEgb4=
MIME-Version: 1.0
In-Reply-To: <20101124202236.GA7989@linux.vnet.ibm.com>
References: <20101124005820.GH8056@linux.vnet.ibm.com>
	<AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
	<AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
	<20101124062212.GA2165@linux.vnet.ibm.com>
	<AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
	<20101124144240.GC2165@linux.vnet.ibm.com>
	<AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
	<20101124161513.GA2207@linux.vnet.ibm.com>
	<AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
	<20101124182051.GF2207@linux.vnet.ibm.com>
	<20101124202236.GA7989@linux.vnet.ibm.com>
Date: Wed, 24 Nov 2010 21:45:08 +0100
Message-ID: <AANLkTi=DmGiYK5r0cuzQkLFF3V4XaG=CGvcDh2S4M2t+@mail.gmail.com>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after
 extended grace periods
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> I take it back.  I queued the following -- your code, but updated
> comment and commit message.  Please let me know if I missed anything.
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> commit 1d9d947bb882371a0877ba05207a0b996dcb38ee
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Wed Nov 24 01:31:12 2010 +0100
>
>    rcu: Don't chase unnecessary quiescent states after extended grace periods
>
>    When a CPU is in an extended quiescent state, including offline and
>    dyntick-idle mode, other CPUs will detect the extended quiescent state
>    and respond to the the current grace period on that CPU's behalf.
>    However, the locking design prevents those other CPUs from updating
>    the first CPU's rcu_data state.
>
>    Therefore, when this CPU exits its extended quiescent state, it must
>    update its rcu_data state.  Because such a CPU will usually check for
>    the completion of a prior grace period before checking for the start of a
>    new grace period, the rcu_data ->completed field will be updated before
>    the rcu_data ->gpnum field.  This means that if RCU is currently idle,
>    the CPU will usually enter __note_new_gpnum() with ->completed set to
>    the current grace-period number, but with ->gpnum set to some long-ago
>    grace period number.  Unfortunately, __note_new_gpnum() will then insist
>    that the current CPU needlessly check for a new quiescent state.  This
>    checking can result in this CPU needlessly taking several scheduling-clock
>    interrupts.


So I'm all ok for the commit and the comments updated. But just a doubt about
the about sentence.

The effect seems more that there will be one extra softirq. But not an
extra tick
because before sleeping, the CPU will check rcu_needs_cpu() which
doesn't check for
the need of noting a quiescent state, IIRC...

And I think the softirq will be only raised on the next tick.

Hm?

>
>    This bug is harmless in most cases, but is a problem for users concerned
>    with OS jitter for HPC applications or concerned with battery lifetime
>    for portable SMP embedded devices.  This commit therefore makes the
>    test in __note_new_gpnum() check for this situation and avoid the needless
>    quiescent-state checks.
>
>    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>    Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Cc: Thomas Gleixner <tglx@linutronix.de>
>    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>    Cc: Steven Rostedt <rostedt@goodmis.org>
>    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5df948f..76cd5d2 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -616,8 +616,20 @@ static void __init check_cpu_stall_init(void)
>  static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
>  {
>        if (rdp->gpnum != rnp->gpnum) {
> -               rdp->qs_pending = 1;
> -               rdp->passed_quiesc = 0;
> +               /*
> +                * Because RCU checks for the prior grace period ending
> +                * before checking for a new grace period starting, it
> +                * is possible for rdp->gpnum to be set to the old grace
> +                * period and rdp->completed to be set to the new grace
> +                * period.  So don't bother checking for a quiescent state
> +                * for the rnp->gpnum grace period unless it really is
> +                * waiting for this CPU.
> +                */
> +               if (rdp->completed != rnp->gpnum) {
> +                       rdp->qs_pending = 1;
> +                       rdp->passed_quiesc = 0;
> +               }
> +
>                rdp->gpnum = rnp->gpnum;
>        }
>  }
>
