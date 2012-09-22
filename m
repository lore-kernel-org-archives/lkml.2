Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2IVUgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 16:36:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46383 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2IVUgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:36:52 -0400
Date: Sat, 22 Sep 2012 12:52:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120922195253.GD2934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120920000351.GI2455@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com>
 <20120921212054.GE2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com>
 <20120922000537.GH2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221813330.10663@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209221813330.10663@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092219-6148-0000-0000-000009E7B1C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 06:16:15PM +0000, Paul Walmsley wrote:
> Hi Paul
> 
> On Fri, 21 Sep 2012, Paul E. McKenney wrote:
> 
> > I am wondering if your system somehow figured out how to start a grace
> > period that had no RCU callbacks waiting for it.  If that happened,
> > then a CONFIG_NO_HZ=y system could in theory get into a state where all
> > CPUs are in dyntick-idle mode, so that none of them is doing anything
> > to force the grace period to complete.
> >
> > That should be easy to diagnose, anyway.  Please see below, which
> > includes the earlier diagnostic patch.
> 
> Here you go.
> 
> - Paul
> 
> [  248.902618] INFO: rcu_sched self-detected stall on CPU
> [  248.905456]  0: (1 ticks this GP) idle=933/1/0 
> [  248.907897]   (t=26570 jiffies g=11 c=10 q=0)

Bingo!!!  (q=0, in case you were wondering.  And thank you for testing this!)

Strangely enough, I believe that I have inadvertently fixed this in
my -rcu tree:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

Nevertheless, if you get a chance to try it, I would be interested to
hear if my guess is correct.  The trick is that a kthread drives the
grace period in -rcu, regardless of whether or not there are callbacks.

However, the backport would not be something that -stable would be happy
with, so I will be putting together a fix for mainline.  This thing
has been in the kernel since about 2004, not sure why you didn't hit
it earlier.

							Thanx, Paul

> [  248.910339] [<c001bc90>] (unwind_backtrace+0x0/0xf0) from [<c00ad800>] (rcu_check_callbacks+0x220/0x714)
> [  248.915527] [<c00ad800>] (rcu_check_callbacks+0x220/0x714) from [<c00532a0>] (update_process_times+0x38/0x68)
> [  248.920928] [<c00532a0>] (update_process_times+0x38/0x68) from [<c008c9e8>] (tick_sched_timer+0x80/0xec)
> [  248.926116] [<c008c9e8>] (tick_sched_timer+0x80/0xec) from [<c0068ed4>] (__run_hrtimer+0x7c/0x1e0)
> [  248.930999] [<c0068ed4>] (__run_hrtimer+0x7c/0x1e0) from [<c0069cb8>] (hrtimer_interrupt+0x11c/0x2d0)
> [  248.936035] [<c0069cb8>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a3cc>] (twd_handler+0x30/0x44)
> [  248.940948] [<c001a3cc>] (twd_handler+0x30/0x44) from [<c00a7bd0>] (handle_percpu_devid_irq+0x90/0x13c)
> [  248.946075] [<c00a7bd0>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a4344>] (generic_handle_irq+0x30/0x48)
> [  248.951538] [<c00a4344>] (generic_handle_irq+0x30/0x48) from [<c0014e38>] (handle_IRQ+0x4c/0xac)
> [  248.956329] [<c0014e38>] (handle_IRQ+0x4c/0xac) from [<c00084cc>] (gic_handle_irq+0x28/0x5c)
> [  248.960937] [<c00084cc>] (gic_handle_irq+0x28/0x5c) from [<c04fb1a4>] (__irq_svc+0x44/0x5c)
> [  248.965484] Exception stack(0xc0729f58 to 0xc0729fa0)
> [  248.968231] 9f40:                                                       0003b832 00000001
> [  248.972686] 9f60: 00000000 c074a8e8 c0728000 c07c42c8 c05065a0 c074bdc8 00000000 411fc092
> [  248.977142] 9f80: c074bfe8 00000000 00000001 c0729fa0 0003b833 c0015130 20000113 ffffffff
> [  248.981597] [<c04fb1a4>] (__irq_svc+0x44/0x5c) from [<c0015130>] (default_idle+0x20/0x44)
> [  248.986083] [<c0015130>] (default_idle+0x20/0x44) from [<c001535c>] (cpu_idle+0x9c/0x114)
> [  248.990539] [<c001535c>] (cpu_idle+0x9c/0x114) from [<c06d77b0>] (start_kernel+0x2b4/0x304)
> 

