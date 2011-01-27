Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1A0KsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:48:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:58027 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1A0KsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:48:07 -0500
Date: Thu, 27 Jan 2011 11:47:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] memsw: Deprecate noswapaccount kernel parameter and
 schedule it for removal
Message-ID: <20110127104759.GA4301@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
 <20110126140618.8e09cd23.akpm@linux-foundation.org>
 <20110127082320.GA15500@tiehlicka.suse.cz>
 <20110127180330.78585085.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127092951.GA8036@tiehlicka.suse.cz>
 <20110127184827.a8927595.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127184827.a8927595.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-01-11 18:48:27, KAMEZAWA Hiroyuki wrote:
> Could you try to write a patch for feature-removal-schedule.txt
> and tries to remove noswapaccount and do clean up all ?
> (And add warning to noswapaccount will be removed.....in 2.6.40)

Sure, no problem. What do you think about the following patch?
---
>From a597421909a3291886345565c73102117a52301e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 27 Jan 2011 11:41:01 +0100
Subject: [PATCH] memsw: Deprecate noswapaccount kernel parameter and schedule it for removal

noswapaccount couldn't be used to control memsw for both on/off cases so
we have added swapaccount[=0|1] parameter. This way we can turn the
feature in two ways noswapaccount resp. swapaccount=0. We have kept the
original noswapaccount but I think we should remove it after some time
as it just makes more command line parameters without any advantages and
also the code to handle parameters is uglier if we want both parameters.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Requested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/feature-removal-schedule.txt |   16 ++++++++++++++++
 mm/memcontrol.c                            |    1 +
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b959659..b3f35e5 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -603,3 +603,19 @@ Why:	The adm9240, w83792d and w83793 hardware monitoring drivers have
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ----------------------------
+
+What:	noswapaccount kernel command line parameter
+When:	2.6.40
+Why:	The original implementation of memsw feature enabled by
+	CONFIG_CGROUP_MEM_RES_CTLR_SWAP could be disabled by the noswapaccount
+	kernel parameter (introduced in 2.6.29-rc1). Later on, this decision
+	turned out to be not ideal because we cannot have the feature compiled
+	in and disabled by default and let only interested to enable it
+	(e.g. general distribution kernels might need it). Therefore we have
+	added swapaccount[=0|1] parameter (introduced in 2.6.37) which provides
+	the both possibilities. If we remove noswapaccount we will have
+	less command line parameters with the same functionality and we
+	can also cleanup the parameter handling a bit ().
+Who:	Michal Hocko <mhocko@suse.cz>
+
+----------------------------
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cea2be48..0387287 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5023,6 +5023,7 @@ __setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
+	printk_once("noswapaccount is deprecated and will be removed in 2.6.40. Use swapaccount=0 instead\n");
 	enable_swap_account("=0");
 	return 1;
 }
-- 
1.7.2.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
