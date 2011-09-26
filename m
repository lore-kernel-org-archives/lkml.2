Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1IZRGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:06:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1IZRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:06:16 -0400
Date: Mon, 26 Sep 2011 19:06:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
Message-ID: <20110926170606.GG18553@somewhere>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
 <1317033884.9084.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317033884.9084.79.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 12:44:44PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 12:19 +0200, Frederic Weisbecker wrote:
> > It is assumed that rcu won't be used once we switch to tickless
> > mode and until we restart the tick. However this is not always
> > true, as in x86-64 where we dereference the idle notifiers after
> > the tick is stopped.
> > 
> > To prepare for fixing this, add a parameter to tick_nohz_enter_idle()
> > named "rcu_ext_qs" that tells whether we want to enter RCU extended
> > quiescent state at the same time we stop the tick.
> > 
> > If no use of RCU is made in the idle loop between
> > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the parameter
> > must be set to true and the arch doesn't need to call rcu_enter_nohz()
> > and rcu_exit_nohz() explicitly.
> > 
> > Otherwise the parameter must be set to false and the arch is
> > responsible of calling:
> > 
> > - rcu_enter_nohz() after its last use of RCU before the CPU is put
> > to sleep.
> > - rcu_exit_nohz() before the first use of RCU after the CPU is woken
> > up. 
> 
> I can't say this really makes sense:
> 
>   tick_nohz_idle_enter(false);
> 
> reads like, don't enter nohz state, not: enter nohz state but don't
> enter rcu-nohz state.
> 
> I realize you want to keep the per-arch frobbing low, but since you're
> already touching all of them, I think its more important to keep the
> functions readable.
> 
> Why not simply fully split nohz and rcu and modify all idle routines
> with both calls?

Right, that parameter can be a bit confusing.
I could do the split and call directly rcu_enter_nohz() from the arch
but that's going to be a duplication of code everywhere. For now only
x86 seem to need to call it separately. We have only tested x86 and
powerpc yet though...

The other reason is that it avoids to call rcu_enter_nohz()
unconditionally. If the tick doesn't stop we don't need to call it. May
be that can matter to make the CPU go faster to sleep.

We could have tick_nohz_idle_enter() for cases where we need to call
rcu_enter_nohz() explicitly from the arch and tick_nohz_idle_enter_norcu()
otherwise.

Or an enum as a parameter.
