Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0KRJ4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:56:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:40625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0KRJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:56:15 -0500
Date: Thu, 18 Nov 2010 10:56:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        stable@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Make swap accounting default behavior configurable v4
Message-ID: <20101118095607.GD15928@tiehlicka.suse.cz>
References: <20101116101726.GA21296@tiehlicka.suse.cz>
 <20101116124615.978ed940.akpm@linux-foundation.org>
 <20101117092339.1b7c2d6d.nishimura@mxp.nes.nec.co.jp>
 <20101116171225.274019cf.akpm@linux-foundation.org>
 <20101117122801.e9850acf.nishimura@mxp.nes.nec.co.jp>
 <20101118082332.GB15928@tiehlicka.suse.cz>
 <20101118174654.8fa69aca.nishimura@mxp.nes.nec.co.jp>
 <20101118175334.be00c8f2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118175334.be00c8f2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-11-10 17:53:34, KAMEZAWA Hiroyuki wrote:
> On Thu, 18 Nov 2010 17:46:54 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Thu, 18 Nov 2010 09:23:32 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Wed 17-11-10 12:28:01, Daisuke Nishimura wrote:
> > > > On Tue, 16 Nov 2010 17:12:25 -0800
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
[...]
> > > > > Yes, we're stuck with the old one now.
> > > > > 
> > > > > But we should note that "foo=[0|1]" is superior to "foo" and "nofoo". 
> > > > > Even if we didn't initially intend to add "nofoo".
> > > > > 
> > > > I see.
> > > > 
> > > > Michal-san, could you update your patch to use "swapaccount=[1|0]" ?
> > > 
> > > I have noticed that Andrew has already taken the last version of the
> > > patch for -mm tree. Should I still rework it to change swapaccount to
> > > swapaccount=0|1 resp. true|false?
> > > 
> > It's usual to update a patch into more sophisticated one while it is in -mm tree.
> > So, I think you'd better to do it(btw, I prefer 0|1 to true|false.
> > Reading kernel-parameters.txt, 0|1 is more commonly used.).
> > 
> 
> I vote for 0|1

Changes since v3:
* add 0|1 parameter values handling

Changes since v2:
* put the new parameter description to the proper (alphabetically
* sorted)
  place in Documentation/kernel-parameters.txt
  
Changes since v1:
* do not remove noswapaccount parameter and add swapaccount parameter
* instead
* Documentation/kernel-parameters.txt updated)

--- 
>From 72c003f6586c092c1a69f5482cd102e97d7ef40f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 10 Nov 2010 13:30:04 +0100
Subject: [PATCH] Make swap accounting default behavior configurable

Swap accounting can be configured by CONFIG_CGROUP_MEM_RES_CTLR_SWAP
configuration option and then it is turned on by default. There is
a boot option (noswapaccount) which can disable this feature.

This makes it hard for distributors to enable the configuration option
as this feature leads to a bigger memory consumption and this is a no-go
for general purpose distribution kernel. On the other hand swap
accounting may be very usuful for some workloads.

This patch adds a new configuration option which controls the default
behavior (CGROUP_MEM_RES_CTLR_SWAP_ENABLED). If the option is selected
then the feature is turned on by default.

It also adds a new boot parameter swapaccount[=1|0] which enhances the
original noswapaccount parameter semantic by means of enable/disable
logic (defaults to 1 if no value is provided to be still consistent with
noswapaccount).

The default behavior is unchanged (if CONFIG_CGROUP_MEM_RES_CTLR_SWAP is
enabled then CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is enabled as well)

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/kernel-parameters.txt |    5 +++++
 init/Kconfig                        |   13 +++++++++++++
 mm/memcontrol.c                     |   21 +++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ed45e98..98c4902 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2385,6 +2385,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
+	swapaccount[=0|1]
+			[KNL] Enable accounting of swap in memory resource
+			controller if no parameter or 1 is given or disable
+			it if 0 is given (See Documentation/cgroups/memory.txt)
+
 	swiotlb=	[IA-64] Number of I/O TLB slabs
 
 	switches=	[HW,M68k]
diff --git a/init/Kconfig b/init/Kconfig
index 88c1046..c972899 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -613,6 +613,19 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  if boot option "noswapaccount" is set, swap will not be accounted.
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
+config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+	bool "Memory Resource Controller Swap Extension enabled by default"
+	depends on CGROUP_MEM_RES_CTLR_SWAP
+	default y
+	help
+	  Memory Resource Controller Swap Extension comes with its price in
+	  a bigger memory consumption. General purpose distribution kernels
+	  which want to enable the feautre but keep it disabled by default
+	  and let the user enable it by swapaccount boot command line
+	  parameter should have this option unselected.
+	  For those who want to have the feature enabled by default should
+	  select this option (if, for some reason, they need to disable it
+	  then noswapaccount does the trick).
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a99cfa..bed98b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -61,7 +61,14 @@ struct mem_cgroup *root_mem_cgroup __read_mostly;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
 int do_swap_account __read_mostly;
-static int really_do_swap_account __initdata = 1; /* for remember boot option*/
+
+/* for remember boot option*/
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+static int really_do_swap_account __initdata = 1;
+#else
+static int really_do_swap_account __initdata = 0;
+#endif
+
 #else
 #define do_swap_account		(0)
 #endif
@@ -4909,10 +4916,20 @@ struct cgroup_subsys mem_cgroup_subsys = {
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static int __init enable_swap_account(char *s)
+{
+	/* consider enabled if no parameter or 1 is given */
+	if (!s || !strcmp(s, "1"))
+		really_do_swap_account = 1;
+	else if (!strcmp(s, "0"))
+		really_do_swap_account = 0;
+	return 1;
+}
+__setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
-	really_do_swap_account = 0;
+	enable_swap_account("0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);
-- 
1.7.2.3


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
