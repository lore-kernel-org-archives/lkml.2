Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0IHOam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:30:42 -0400
Received: from www.tglx.de ([62.245.132.106]:35083 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0IHOal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:30:41 -0400
Date: Wed, 8 Sep 2010 16:30:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: slow nanosleep?
In-Reply-To: <OF58F81314.CCA2DE14-ONC1257798.004E57E1-C1257798.004EA9E9@transmode.se>
Message-ID: <alpine.LFD.2.00.1009081626460.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>  <1283934289.2880.12.camel@edumazet-laptop> 
 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>  <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>  <OF82705D74.3C13AE80-ONC1257798.00427DAB-C1257798.0042F243@transmode.se>  <alpine.LFD.2.00.1009081442390.2477@localhost6.localdomain6>
 <1283950818.23762.20.camel@laptop> <OFA5A9E9D0.0B55FA15-ONC1257798.004A7BB3-C1257798.004B86F2@transmode.se> <alpine.LFD.2.00.1009081551510.2477@localhost6.localdomain6> <OF58F81314.CCA2DE14-ONC1257798.004E57E1-C1257798.004EA9E9@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Joakim Tjernlund wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote on 2010/09/08 15:52:23:
> > On Wed, 8 Sep 2010, Joakim Tjernlund wrote:
> > > 
> > > Actually, it takes 120 us. The 20 us was when I had Thomas
> > > timeout == 0 fast path patch applied(forgot to remove it).
> > > Without that patch it takes about 115 us. So it seems it takes
> > > 115-20=95 us to turn the timer wheel on my ppc.
> >
> > You might fire up the tracer to look where it spends that time.
> 
> This helps for short(1 ns) nanosleeps, sleeps for 25 us. No idea
> if this is any good, just tossing it out for you to tear apart :)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 5c69e99..e612016 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1545,6 +1545,9 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
>  				HRTIMER_MODE_ABS);
>  	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
> 
> +	if (!hrtimer_active(&t.timer))
> +		goto out;

That actually will return for any expiry time. The timer is armed in
do_nanosleep() not in hrtimer_set_expires_tv64() /
hrtimer_set_expires_range_ns()

Thanks,

	tglx
