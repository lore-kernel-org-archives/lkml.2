Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0IOA3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:29:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:51221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0IOA3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:29:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,367,1280732400"; 
   d="scan'208";a="657362420"
Date: Tue, 14 Sep 2010 17:19:49 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/hwmon: register alternate sibling upon CPU removal
Message-ID: <20100915001949.GB1237@fenghua-desk.sc.intel.com>
References: <4C8E17A90200007800015AE6@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E17A90200007800015AE6@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 03:23:05AM -0700, Jan Beulich wrote:
> Just like pkgtemp registers another core of the same package when one
> gets removed, coretemp should register another hyperthread (if
> available) in that situation.
> 
> As pointed out in the patch fixing the respective code in pkgtemp, the
> list protectng mutex must be dropped before calling
> coretemp_device_add(), and due to the restructured loop (including an
> explicit return) the "safe" variant of the list iterator isn't needed
> anymore.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> 
> ---
>  drivers/hwmon/coretemp.c |   22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> --- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
> +++ 2.6.36-rc4-x86-coretemp-remove-deadlock/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
> @@ -482,14 +482,22 @@ exit:
>  
>  static void coretemp_device_remove(unsigned int cpu)
>  {
> -	struct pdev_entry *p, *n;
> +	struct pdev_entry *p;
> +	unsigned int i;
> +
>  	mutex_lock(&pdev_list_mutex);
> -	list_for_each_entry_safe(p, n, &pdev_list, list) {
> -		if (p->cpu == cpu) {
> -			platform_device_unregister(p->pdev);
> -			list_del(&p->list);
> -			kfree(p);
> -		}
> +	list_for_each_entry(p, &pdev_list, list) {
> +		if (p->cpu != cpu)
> +			continue;
> +
> +		platform_device_unregister(p->pdev);
> +		list_del(&p->list);
> +		mutex_unlock(&pdev_list_mutex);
> +		kfree(p);
> +		for_each_cpu(i, cpu_sibling_mask(cpu))
> +			if (i != cpu && !coretemp_device_add(i))
> +				break;
> +		return;
>  	}
>  	mutex_unlock(&pdev_list_mutex);
>  }
> 
> 
> 

I sent a patch to fix this issue before. I'll push it to Linus.

BTW, you patch won't be compiled in UP mode.

Thanks.

-Fenghua

From: Fenghua Yu <fenghua.yu@intel.com>

In current coretemp driver, when a CPU in dev_list is hot-removed, although its
HT sibling is still running, its core sensor is gone and not available to user
level application any more.

When a CPU is hot-removed, its core sensor should be still available to upper
level application as long as the hot-removed CPU's HT sibling is still running.
A core sensor is invisible to user level only when all of siblings in a core are
hot-removed.

This patch fixes this issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/hwmon/coretemp.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index c070c97..2257cc4 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -418,7 +418,7 @@ struct pdev_entry {
 static LIST_HEAD(pdev_list);
 static DEFINE_MUTEX(pdev_list_mutex);
 
-static int __cpuinit coretemp_device_add(unsigned int cpu)
+static int coretemp_device_add(unsigned int cpu)
 {
 	int err;
 	struct platform_device *pdev;
@@ -483,15 +483,34 @@ exit:
 static void coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
-	mutex_lock(&pdev_list_mutex);
+#ifdef CONFIG_SMP
+	int s;
+#endif
+
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		if (p->cpu == cpu) {
+			mutex_lock(&pdev_list_mutex);
 			platform_device_unregister(p->pdev);
 			list_del(&p->list);
 			kfree(p);
+			mutex_unlock(&pdev_list_mutex);
+
+#ifdef CONFIG_SMP
+			/*
+			 * Add removed CPU's HT sibling to dev_list.
+			 * If there is no sibling available, the core sensor
+			 * is invisiable to user space any more.
+			 */
+			for_each_cpu(s, cpu_sibling_mask(cpu)) {
+				if (s != cpu) {
+					coretemp_device_add(s);
+					break;
+				}
+			}
+#endif
+			return;
 		}
 	}
-	mutex_unlock(&pdev_list_mutex);
 }
 
 static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
-- 
1.6.0.3

