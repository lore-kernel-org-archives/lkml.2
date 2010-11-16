Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200Ab0KPKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:17:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:46560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab0KPKRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:17:30 -0500
Date: Tue, 16 Nov 2010 11:17:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] Make swap accounting default behavior configurable
Message-ID: <20101116101726.GA21296@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
could you consider the following patch for the Linus tree, please?
The discussion took place in this email thread 
http://lkml.org/lkml/2010/11/10/114.
The patch is based on top of 151f52f09c572 commit in the Linus tree.

Please let me know if there I should route this patch through somebody
else.

Thanks!

---
>From 30238aaec758988493af793939f14b0ba83dc4b3 Mon Sep 17 00:00:00 2001
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

It also adds a new boot parameter swapaccount which (contrary to
noswapaccount) enables the feature. (I would consider swapaccount=yes|no
semantic with removed noswapaccount parameter much better but this
parameter is kind of API which might be in use and unexpected breakage
is no-go.)

The default behavior is unchanged (if CONFIG_CGROUP_MEM_RES_CTLR_SWAP is
enabled then CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is enabled as well)

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 Documentation/kernel-parameters.txt |    3 +++
 init/Kconfig                        |   13 +++++++++++++
 mm/memcontrol.c                     |   15 ++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ed45e98..14eafa5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2385,6 +2385,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
+	swapaccount	[KNL] Enable accounting of swap in memory resource
+			controller. (See Documentation/cgroups/memory.txt)
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
index 9a99cfa..4f479fe 100644
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
@@ -4909,6 +4916,12 @@ struct cgroup_subsys mem_cgroup_subsys = {
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static int __init enable_swap_account(char *s)
+{
+	really_do_swap_account = 1;
+	return 1;
+}
+__setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
-- 
1.7.2.3

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
