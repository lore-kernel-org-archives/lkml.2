Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2IVXRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 19:17:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33789 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2IVXRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 19:17:40 -0400
Date: Sat, 22 Sep 2012 16:17:33 -0700
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
Message-ID: <20120922231733.GI2934@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com>
 <20120921212054.GE2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com>
 <20120922000537.GH2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221813330.10663@utopia.booyaka.com>
 <20120922195253.GD2934@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209222214120.22590@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209222214120.22590@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092223-2398-0000-0000-00000B497E7D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00176433; UDB=6.00039953; UTC=2012-09-22
 23:17:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 10:20:19PM +0000, Paul Walmsley wrote:
> Hi Paul
> 
> On Sat, 22 Sep 2012, Paul E. McKenney wrote:
> 
> > Strangely enough, I believe that I have inadvertently fixed this in
> > my -rcu tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> > 
> > Nevertheless, if you get a chance to try it, I would be interested to
> > hear if my guess is correct.
> 
> Yes, good news: the stall warnings go away with that branch.

Very good!

> > The trick is that a kthread drives the grace period in -rcu, regardless 
> > of whether or not there are callbacks.
> 
> This is "rcu: Move quiescent-state forcing into kthread" ?

Yep, plus the preceding commits moving grace-period initialization and
cleanup into that same kthread.  This was motivated by a bug report
last February complaining about 200-microsecond latency spikes from
RCU grace-period initialization.  On systems with 4096 CPUs.

Real-time response.  It is far bigger than I thought.  ;-)

> Added some debugging into rcu_gp_kthread() after that commit and can 
> confirm that the quiescent-state forcing loop does start a few times when 
> there are zero callbacks pending (modulo any races in my measurement 
> code).

Cool, thank you!  Assuming it works, that indicates that there is long-term
value to the fix for this problem.  On larger systems, extra grace periods
are not what you want, as their expense increases with the number of CPUs.

> > However, the backport would not be something that -stable would be happy
> > with, so I will be putting together a fix for mainline.  This thing
> > has been in the kernel since about 2004, not sure why you didn't hit
> > it earlier.
> 
> One other data point in that regard - noticed the warnings don't appear 
> when the board is booted with:
> 
> commit 4fa3b6cb1bc8c14b81b4c8ffdfd3f2500a7e9367
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Tue Jun 5 15:53:53 2012 -0700
> 
>     rcu: Fix qlen_lazy breakage

You lost me on this one.  This is already in mainline, so if you were
using (say) 3.6-rc6, you would already have this commit applied.

							Thanx, Paul

