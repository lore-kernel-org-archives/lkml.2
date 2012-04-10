Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2DJQSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:18:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37397 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2DJQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:18:09 -0400
Date: Tue, 10 Apr 2012 09:07:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120410160706.GF2428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
 <20120405123759.GE1963@zod.bos.redhat.com>
 <20120405140006.GB27672@linux.vnet.ibm.com>
 <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
 <20120405143918.GE27672@linux.vnet.ibm.com>
 <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041016-7408-0000-0000-000004187BA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 11:18:03AM +0200, Pascal Chapperon wrote:
> > Message du 05/04/12 16:40
> > De : "Paul E. McKenney" 
> > A : "Pascal CHAPPERON" 
> > Copie à : "Josh Boyer" , linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
> > Objet : Re: RCU related performance regression in 3.3
> > 
> > On Thu, Apr 05, 2012 at 04:15:33PM +0200, Pascal CHAPPERON wrote:
> > > Hello,
> > > 
> > > I didn't notice any significant slowdown while the system is up and running. 
> A full kernel compilation (make -j 16) takes 14mn with both 3.2.10 and 3.3.0.

OK, good.

> > OK, so the natural approach is to disable CONFIG_RCU_FAST_NO_HZ at
> > boot time. Unfortunately, you appear to need it to remain disabled
> > through at least filesystem mounting, which if I understand correctly
> > happens long after system_state gets set to SYSTEM_RUNNING.
> > 
> In fact, I need it to remain disable until all the systemd units are completed. 
> Some units, such as NetworkManager can take longer time to complete with
> RCU_FAST_NO_HZ enabled.
> And i need it to be disabled at shutdown, as umounting cgroups, sysfs, etc.
> plus old-root mounting can take one plain second for each umounting.

OK...

> > If RCU has some way to find out when init is complete, I can easily
> > make it so that CONFIG_RCU_FAST_NO_HZ optimizes for speed during boot
> > and energy efficiency during runtime.
> > 
> I said that I didn't noticed significant slowdown during runtime, but my
> laptop usage is basic. Some specific tasks similar to systemd may 
> perhaps be impacted by this feature.
> I can test a task/program that could stress RCU_FAST_NO_HZ if any ?

One thing to try first -- could you please check boot/shutdown slowdown
with the patch below?

But yes, there are things like modifying netfilter rules and updating
security configuration that might be affected.

> > One thing I could easily do would be to provide a sysfs parameter or
> > some such that allows the boot process to enable energy-efficiency
> > mode at runtime. I would much prefer to make this automatic, though.
> > 
> So the feature is disabled until you trigger a sysfs parameter, and can be
> disabled before shutdown ? It would be fair, at least for hardware like my
> own.

That is the thought, though again I would really really prefer that this
be automated.

> > Other thoughts?
> > 
> Do you think that the culprit is a buggy hardware in my laptop, or the 
> number of cpu/threads ?

Maybe just more filesystems to mount?

> > Thanx, Paul
> > 
> 
> Resent in plain text because rejected. Sorry, i forgot the rules.

No problem!  Please see below for the patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Decrease RCU_FAST_NO_HZ timer interval

Use of RCU_FAST_NO_HZ reportedly significantly slowed boot time in
configurations involving lots of filesystem mounts.  This commit attempts
to work around this by decreasing the RCU_FAST_NO_HZ timer interval
from 6 jiffies down to 3 jiffies.

Reported-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..980a4bb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1975,7 +1975,7 @@ static void rcu_prepare_for_idle(int cpu)
  */
 #define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
 #define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
-#define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
+#define RCU_IDLE_GP_DELAY 3		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);

