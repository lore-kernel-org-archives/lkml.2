Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0JEVJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:09:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37579 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0JEVJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:09:07 -0400
Date: Tue, 5 Oct 2010 14:09:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20101005210904.GQ2369@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101005191223.GA31795@elte.hu>
 <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 01:15:02PM -0700, Linus Torvalds wrote:
> On Tue, Oct 5, 2010 at 12:12 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >  #define rcu_dereference_bh(p) \
> > -               rcu_dereference_check(p, rcu_read_lock_bh_held())
> > +               rcu_dereference_check(p, rcu_read_lock_bh_held() || irqs_disabled())
> 
> Wouldn't that irqs_disabled() check have made more sense inside
> rcu_read_lock_bh_held()?
> 
> That's the function that is _supposed_ to check whether bottom halves
> are disabled, no? So why add a workaround for that function being
> buggy/incomplete in one place that uses it?

Good point!!!  If the following diff looks good to you, I will get it
tested and pushed.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 4d16983..0af1dc7 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -86,7 +86,7 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	return in_softirq();
+	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
