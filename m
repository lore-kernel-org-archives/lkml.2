Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2CIP7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42197 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2CIP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:08 -0500
Date: Thu, 8 Mar 2012 13:26:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Andre@jasper.es
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120308212647.GV2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <20120124232911.GA11327@linux.vnet.ibm.com>
 <20120307114410.GA4214@swordfish.minsk.epam.com>
 <CA+5PVA4CdtQYbJBvpoAa7iyWegBpJaDBcFfXpXYX=pARw_SBSA@mail.gmail.com>
 <20120307152703.GD2348@linux.vnet.ibm.com>
 <CA+5PVA7q03ZTLtFZH98KvtLbreSx65uGEBJmT02-vCHgogHaMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA7q03ZTLtFZH98KvtLbreSx65uGEBJmT02-vCHgogHaMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-1780-0000-0000-000003D7BF62
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000256; HX=3.00000185; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00120544; UDB=6.00029127; UTC=2012-03-09
 15:59:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:49:26AM -0500, Josh Boyer wrote:
> On Wed, Mar 7, 2012 at 10:27 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Mar 07, 2012 at 09:09:39AM -0500, Josh Boyer wrote:
> >> On Wed, Mar 7, 2012 at 6:44 AM, Sergey Senozhatsky
> >> <sergey.senozhatsky@gmail.com> wrote:
> >> > Hello,
> >> > I just hit the same problem.
> >> >
> >> > Is this patch scheduled for 3.3 until release or will land during 3.4
> >> > merge window?
> >>
> >> There are 3 patches in Paul's 3.4 queue, and another 9 of Steven Rostedt's
> >> that fix this.  They'll wind up in 3.4.
> >>
> >> I looked at reverting the patch that adds this new warning and it doesn't
> >> trivially revert.
> >
> > What are you based on?  I should be able to disable the warning for
> > you easily enough.
> 
> 3.3.  I think I tried reverting 00f49e5729af602deb559b0cf293a00b625e8636 and
> it failed.  Then I locally commented out the WARN_ONCE in the functions which
> got rid of that, but we still get a 'suspicious RCU usage' warning when
> running powertop.  I gave up after that, since it all goes away if we disable
> the debugging options and you have fixes queued for 3.4.

How about the following?

							Thanx, Paul

------------------------------------------------------------------------

rcu: hack to disable RCU idle checking

Not for inclusion -- for mainline the correct approach is to fix things
so that RCU is not invoked from CPUs that RCU believes to be idle.
Use the upcoming RCU_NONIDLE() macro for this, or the new tracing
functions designed for use from idle.

Not-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 977296d..0829314 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -169,7 +169,7 @@ void rcu_irq_enter(void)
  */
 int rcu_is_cpu_idle(void)
 {
-	return !rcu_dynticks_nesting;
+	return false;
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6c4a672..397cca8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -572,12 +572,7 @@ void rcu_nmi_exit(void)
  */
 int rcu_is_cpu_idle(void)
 {
-	int ret;
-
-	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
-	preempt_enable();
-	return ret;
+	return false;
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 

