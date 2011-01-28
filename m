Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1A1ID7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:03:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab1A1ID6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:03:58 -0500
Date: Fri, 28 Jan 2011 09:03:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memsw: Deprecate noswapaccount kernel parameter and
 schedule it for removal
Message-ID: <20110128080352.GA5914@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
 <20110126140618.8e09cd23.akpm@linux-foundation.org>
 <20110127082320.GA15500@tiehlicka.suse.cz>
 <20110127180330.78585085.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127092951.GA8036@tiehlicka.suse.cz>
 <20110127184827.a8927595.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127104759.GA4301@tiehlicka.suse.cz>
 <20110128083703.a154050b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128083703.a154050b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-01-11 08:37:03, KAMEZAWA Hiroyuki wrote:
> On Thu, 27 Jan 2011 11:47:59 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Thu 27-01-11 18:48:27, KAMEZAWA Hiroyuki wrote:
> > > Could you try to write a patch for feature-removal-schedule.txt
> > > and tries to remove noswapaccount and do clean up all ?
> > > (And add warning to noswapaccount will be removed.....in 2.6.40)
> > 
> > Sure, no problem. What do you think about the following patch?
> > ---
> > From a597421909a3291886345565c73102117a52301e Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Thu, 27 Jan 2011 11:41:01 +0100
> > Subject: [PATCH] memsw: Deprecate noswapaccount kernel parameter and schedule it for removal
> > 
> > noswapaccount couldn't be used to control memsw for both on/off cases so
> > we have added swapaccount[=0|1] parameter. This way we can turn the
> > feature in two ways noswapaccount resp. swapaccount=0. We have kept the
> > original noswapaccount but I think we should remove it after some time
> > as it just makes more command line parameters without any advantages and
> > also the code to handle parameters is uglier if we want both parameters.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Requested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Nice!. Thank you.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks

> 
> Maybe other discussion as 2.6.40 is too early or some may happen.
> But Ack from me, at least.

Sure.

Just for record here is the patch to remove and cleanup. I can split it
into 2 patches (one for removal and the other for the cleanup) but this
can be done later as well.
---

>From 212b3bae0d32a55a7422c8089a4cebfb9ca4a42f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 28 Jan 2011 08:57:32 +0100
Subject: [PATCH] memsw: remove noswapaccount kernel parameter

noswapaccount parameter has been deprecated for some time without any
complains from users so we can remove it. swapaccount=0|1 can be used
instead.

As we are removing the parameter we can also cleanup swapaccount
because it doesn't have to accept an empty string anymore (to match
noswapaccount) and so we can push = into __setup macro rather than
checking "=1" resp. "=0" strings

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/kernel-parameters.txt |    3 ---
 mm/memcontrol.c                     |   13 +++----------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b72e071..a8fe114 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1746,9 +1746,6 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
-	noswapaccount	[KNL] Disable accounting of swap in memory resource
-			controller. (See Documentation/cgroups/memory.txt)
-
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0387287..96c3471 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5013,19 +5013,12 @@ struct cgroup_subsys mem_cgroup_subsys = {
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!(*s) || !strcmp(s, "=1"))
+	if (!strcmp(s, "1"))
 		really_do_swap_account = 1;
-	else if (!strcmp(s, "=0"))
+	else if (!strcmp(s, "0"))
 		really_do_swap_account = 0;
 	return 1;
 }
-__setup("swapaccount", enable_swap_account);
+__setup("swapaccount=", enable_swap_account);
 
-static int __init disable_swap_account(char *s)
-{
-	printk_once("noswapaccount is deprecated and will be removed in 2.6.40. Use swapaccount=0 instead\n");
-	enable_swap_account("=0");
-	return 1;
-}
-__setup("noswapaccount", disable_swap_account);
 #endif
-- 
1.7.2.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
