Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0IOAWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:22:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:36989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0IOAWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:22:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,367,1280732400"; 
   d="scan'208";a="554530989"
Date: Tue, 14 Sep 2010 17:13:00 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/hwmon: avoid deadlock on CPU removal in pkgtemp
Message-ID: <20100915001259.GA1237@fenghua-desk.sc.intel.com>
References: <4C8E14D90200007800015AAE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E14D90200007800015AAE@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 03:11:05AM -0700, Jan Beulich wrote:
> pkgtemp_device_remove(), holding the list protecting mutex, calls
> pkgtemp_device_add(), which itself wants to acquire the same mutex.
> Holding the mutex over the entire loop body in pkgtemp_device_remove()
> isn't really necessary, as long as the loop gets exited after
> processing the matched CPU.
> 
> Once exiting the loop after removing an eventual match, there's no
> need for using the "safe" list iterator anymore.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
>  drivers/hwmon/pkgtemp.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
> +++ 2.6.36-rc4-x86-pkgtemp-remove-deadlock/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
> @@ -339,17 +339,18 @@ exit:
>  #ifdef CONFIG_HOTPLUG_CPU
>  static void pkgtemp_device_remove(unsigned int cpu)

I already sent a  fix patch before. I'll push it to Linus.

Thanks.

-Fenghua

From: Fenghua Yu <fenghua.yu@intel.com>

When a sibling is added to dev_list after a cpu is hot-removed, pdev_list_mutex
has been locked already. But pkgtemp_device_add() tries to lock pdev_list_mutex
again. This is incorrect. The patch fixes this issue.

The patch also removes __cpuinit for pkgtemp_device_add() to avoid section
mismatch warning.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/hwmon/pkgtemp.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index 74157fc..928a016 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -276,7 +276,7 @@ struct pdev_entry {
 static LIST_HEAD(pdev_list);
 static DEFINE_MUTEX(pdev_list_mutex);
 
-static int __cpuinit pkgtemp_device_add(unsigned int cpu)
+static int pkgtemp_device_add(unsigned int cpu)
 {
 	int err;
 	struct platform_device *pdev;
@@ -341,26 +341,34 @@ static void pkgtemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	unsigned int i;
-	int err;
 
-	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		if (p->cpu != cpu)
 			continue;
 
+		mutex_lock(&pdev_list_mutex);
 		platform_device_unregister(p->pdev);
 		list_del(&p->list);
 		kfree(p);
+		mutex_unlock(&pdev_list_mutex);
+		/*
+		 * Select one of removed cpu's siblings to represent sensor
+		 * for this package.
+		 * If there is no more running sibling in a package, the
+		 * package sensor for this package is not available to user
+		 * space any more.
+		 */
 		for_each_cpu(i, cpu_core_mask(cpu)) {
+			int err;
+
 			if (i != cpu) {
 				err = pkgtemp_device_add(i);
 				if (!err)
 					break;
 			}
 		}
-		break;
+		return;
 	}
-	mutex_unlock(&pdev_list_mutex);
 }
 
 static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
-- 
1.6.0.3

