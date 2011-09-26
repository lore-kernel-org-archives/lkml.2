Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1IZKpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:45:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:36738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1IZKpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:45:44 -0400
Subject: Re: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Mon, 26 Sep 2011 12:44:44 +0200
In-Reply-To: <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
	 <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317033884.9084.79.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 12:19 +0200, Frederic Weisbecker wrote:
> It is assumed that rcu won't be used once we switch to tickless
> mode and until we restart the tick. However this is not always
> true, as in x86-64 where we dereference the idle notifiers after
> the tick is stopped.
> 
> To prepare for fixing this, add a parameter to tick_nohz_enter_idle()
> named "rcu_ext_qs" that tells whether we want to enter RCU extended
> quiescent state at the same time we stop the tick.
> 
> If no use of RCU is made in the idle loop between
> tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the parameter
> must be set to true and the arch doesn't need to call rcu_enter_nohz()
> and rcu_exit_nohz() explicitly.
> 
> Otherwise the parameter must be set to false and the arch is
> responsible of calling:
> 
> - rcu_enter_nohz() after its last use of RCU before the CPU is put
> to sleep.
> - rcu_exit_nohz() before the first use of RCU after the CPU is woken
> up. 

I can't say this really makes sense:

  tick_nohz_idle_enter(false);

reads like, don't enter nohz state, not: enter nohz state but don't
enter rcu-nohz state.

I realize you want to keep the per-arch frobbing low, but since you're
already touching all of them, I think its more important to keep the
functions readable.

Why not simply fully split nohz and rcu and modify all idle routines
with both calls?
