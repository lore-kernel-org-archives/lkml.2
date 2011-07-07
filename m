Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1GGFip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:38:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53802 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1GGFin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:38:43 -0400
Date: Thu, 7 Jul 2011 15:38:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>
Subject: linux-next: manual merge of the staging tree with the net and
 trivial trees
Message-Id: <20110707153840.c70fde0f5881bbe0c82eb6dc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/bcm/headers.h
drivers/staging/brcm80211/brcmfmac/dhd_linux.c
drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h between commits
219eb47e6f35 ("net/staging: add needed interrupt.h and hardirq.h
includes") from the net tree and e44ba033c565 ("treewide: remove
duplicate includes") from the trivial tree and various commits from the
staging tree.

I fixed thme up (see below) and can carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/bcm/headers.h
index 8fe8d2b,ab0a1db..0000000
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@@ -23,8 -23,10 +23,7 @@@
  #include <linux/wait.h>
  #include <linux/proc_fs.h>
  #include <linux/interrupt.h>
- #include <linux/version.h>
 -
  #include <linux/stddef.h>
 -#include <linux/kernel.h>
  #include <linux/stat.h>
  #include <linux/fcntl.h>
  #include <linux/unistd.h>
diff --cc drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 09957bd,380447f..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@@ -31,140 -28,17 +28,19 @@@
  #include <linux/fcntl.h>
  #include <linux/fs.h>
  #include <linux/uaccess.h>
 +#include <linux/interrupt.h>
 +#include <linux/hardirq.h>
- #include <bcmdefs.h>
- #include <bcmutils.h>
- 
- #include <dngl_stats.h>
- #include <dhd.h>
- #include <dhd_bus.h>
- #include <dhd_proto.h>
- #include <dhd_dbg.h>
- 
- #include <wl_cfg80211.h>
- 
- #define EPI_VERSION_STR		"4.218.248.5"
- #define ETH_P_BRCM			0x886c
- 
- #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
- #include <linux/wifi_tiwlan.h>
- 
- struct semaphore wifi_control_sem;
- 
- struct dhd_bus *g_bus;
- 
- static struct wifi_platform_data *wifi_control_data;
- static struct resource *wifi_irqres;
- 
- int wifi_get_irq_number(unsigned long *irq_flags_ptr)
- {
- 	if (wifi_irqres) {
- 		*irq_flags_ptr = wifi_irqres->flags & IRQF_TRIGGER_MASK;
- 		return (int)wifi_irqres->start;
- 	}
- #ifdef CUSTOM_OOB_GPIO_NUM
- 	return CUSTOM_OOB_GPIO_NUM;
- #else
- 	return -1;
- #endif
- }
- 
- int wifi_set_carddetect(int on)
- {
- 	printk(KERN_ERR "%s = %d\n", __func__, on);
- 	if (wifi_control_data && wifi_control_data->set_carddetect)
- 		wifi_control_data->set_carddetect(on);
- 	return 0;
- }
- 
- int wifi_set_power(int on, unsigned long msec)
- {
- 	printk(KERN_ERR "%s = %d\n", __func__, on);
- 	if (wifi_control_data && wifi_control_data->set_power)
- 		wifi_control_data->set_power(on);
- 	if (msec)
- 		mdelay(msec);
- 	return 0;
- }
- 
- int wifi_set_reset(int on, unsigned long msec)
- {
- 	printk(KERN_ERR "%s = %d\n", __func__, on);
- 	if (wifi_control_data && wifi_control_data->set_reset)
- 		wifi_control_data->set_reset(on);
- 	if (msec)
- 		mdelay(msec);
- 	return 0;
- }
- 
- static int wifi_probe(struct platform_device *pdev)
- {
- 	struct wifi_platform_data *wifi_ctrl =
- 	    (struct wifi_platform_data *)(pdev->dev.platform_data);
- 
- 	printk(KERN_ERR "## %s\n", __func__);
- 	wifi_irqres =
- 	    platform_get_resource_byname(pdev, IORESOURCE_IRQ,
- 					 "bcm4329_wlan_irq");
- 	wifi_control_data = wifi_ctrl;
- 
- 	wifi_set_power(1, 0);	/* Power On */
- 	wifi_set_carddetect(1);	/* CardDetect (0->1) */
- 
- 	up(&wifi_control_sem);
- 	return 0;
- }
- 
- static int wifi_remove(struct platform_device *pdev)
- {
- 	struct wifi_platform_data *wifi_ctrl =
- 	    (struct wifi_platform_data *)(pdev->dev.platform_data);
- 
- 	printk(KERN_ERR "## %s\n", __func__);
- 	wifi_control_data = wifi_ctrl;
- 
- 	wifi_set_carddetect(0);	/* CardDetect (1->0) */
- 	wifi_set_power(0, 0);	/* Power Off */
- 
- 	up(&wifi_control_sem);
- 	return 0;
- }
- 
- static int wifi_suspend(struct platform_device *pdev, pm_message_t state)
- {
- 	DHD_TRACE(("##> %s\n", __func__));
- 	return 0;
- }
- 
- static int wifi_resume(struct platform_device *pdev)
- {
- 	DHD_TRACE(("##> %s\n", __func__));
- 	return 0;
- }
- 
- static struct platform_driver wifi_device = {
- 	.probe = wifi_probe,
- 	.remove = wifi_remove,
- 	.suspend = wifi_suspend,
- 	.resume = wifi_resume,
- 	.driver = {
- 		   .name = KBUILD_MODNAME,
- 		   }
- };
- 
- int wifi_add_dev(void)
- {
- 	DHD_TRACE(("## Calling platform_driver_register\n"));
- 	return platform_driver_register(&wifi_device);
- }
- 
- void wifi_del_dev(void)
- {
- 	DHD_TRACE(("## Unregister platform_driver_register\n"));
- 	platform_driver_unregister(&wifi_device);
- }
- #endif	/* defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC) */
+ #include <net/cfg80211.h>
+ #include <defs.h>
+ #include <brcmu_utils.h>
+ #include <brcmu_wifi.h>
+ 
+ #include "dhd.h"
+ #include "dhd_bus.h"
+ #include "dhd_proto.h"
+ #include "dhd_dbg.h"
+ #include "wl_cfg80211.h"
+ #include "bcmchip.h"
  
  #if defined(CONFIG_PM_SLEEP)
  #include <linux/suspend.h>
diff --cc drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8cbfeae,7fa95b6..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
diff --cc drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index d4bcc1e,f26d087..0000000
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
