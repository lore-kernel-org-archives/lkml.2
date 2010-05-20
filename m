Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0ETDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:23:30 -0400
Received: from mga10.intel.com ([192.55.52.92]:10672 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633Ab0ETDX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,268,1272870000"; 
   d="scan'208";a="800118002"
Message-ID: <4BF4AB24.7070107@linux.intel.com>
Date: Thu, 20 May 2010 11:23:16 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, andi.kleen@intel.com,
       cl@linux-foundation.org, fengguang.wu@intel.com, mel@csn.ul.ie,
       tj@kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       minskey guo <chaohong.guo@intel.com>
Subject: [PATCH] cpu_up: hold zonelists_mutex when build_all_zonelists
References: <201005192322.o4JNMu5v012158@imap1.linux-foundation.org>
In-Reply-To: <201005192322.o4JNMu5v012158@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
 > The patch titled
 >      mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix
 > has been added to the -mm tree.  Its filename is
 >      mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix.patch
 > ------------------------------------------------------
> Subject: mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: Andi Kleen <andi.kleen@intel.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Haicheng Li <haicheng.li@linux.intel.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/cpu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN kernel/cpu.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix kernel/cpu.c
> --- a/kernel/cpu.c~mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix
> +++ a/kernel/cpu.c
> @@ -358,7 +358,7 @@ int __cpuinit cpu_up(unsigned int cpu)
>  	}
>  
>  	if (pgdat->node_zonelists->_zonerefs->zone == NULL)
> -		build_all_zonelists();
> +		build_all_zonelists(NULL);
>  #endif
>  
>  	cpu_maps_update_begin();

Andrew,

Here is another issue, we should always hold zonelists_mutex when calling build_all_zonelists
unless system_state == SYSTEM_BOOTING.

We need another patch to fix it, which should be applied after 
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch

---
 From 5f547a85e3b331f7ef2c004c93b674f9698c5531 Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Thu, 20 May 2010 11:17:01 +0800
Subject: [PATCH] cpu_up: hold zonelists_mutex when build_all_zonelists

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  kernel/cpu.c |    5 ++++-
  1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3e8b3ba..124ad9d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -357,8 +357,11 @@ int __cpuinit cpu_up(unsigned int cpu)
                 return -ENOMEM;
         }

-       if (pgdat->node_zonelists->_zonerefs->zone == NULL)
+       if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
+               mutex_lock(&zonelists_mutex);
                 build_all_zonelists(NULL);
+               mutex_unlock(&zonelists_mutex);
+       }
  #endif

         cpu_maps_update_begin();
-- 
1.5.6.1


-haicheng
