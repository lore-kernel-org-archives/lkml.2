Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0IDRSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:18:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:4601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0IDRSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,318,1280732400"; 
   d="scan'208";a="834871054"
Date: Sat, 4 Sep 2010 10:08:44 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: pkgtemp: double lock
Message-ID: <20100904170843.GA25659@fenghua-desk.sc.intel.com>
References: <4C8232B9.2020005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8232B9.2020005@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 04:51:21AM -0700, Jiri Slaby wrote:
> Hi,
> 
> stanse found that you double lock pdev_list_mutex:
>   -> pkgtemp_device_remove
>     -> mutex_lock(&pdev_list_mutex);
>     -> pkgtemp_device_add
>       -> mutex_lock(&pdev_list_mutex);
> 
> Could you fix that?
> 
> regards,
> -- 
> js

I have already sent a patch to lkml to fix the issue. It's not in upstream yet.
I'll will push it to Linus.

>From fenghua.yu@intel.com Wed Aug 18 16:03:04 2010

From: Fenghua Yu <fenghua.yu@intel.com>

When a sibling is added to dev_list after a cpu is hot-removed, pdev_list_m=
utex
has been locked already. But pkgtemp_device_add() tries to lock pdev_list_m=
utex
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
=20
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
=20
-	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		if (p->cpu !=3D cpu)
 			continue;
=20
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
 			if (i !=3D cpu) {
 				err =3D pkgtemp_device_add(i);
 				if (!err)
 					break;
 			}
 		}
-		break;
+		return;
 	}
-	mutex_unlock(&pdev_list_mutex);
 }
=20
 static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
--=20
1.6.0.3


