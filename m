Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1GHFLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:11:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1GHFEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.350174346@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [078/107] PCI / PM: Block races between runtime PM and system sleep
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit a5f76d5eba157bf637beb2dd18026db2917c512e upstream.

After commit e8665002477f0278f84f898145b1f141ba26ee26
(PM: Allow pm_runtime_suspend() to succeed during system suspend) it
is possible that a device resumed by the pm_runtime_resume(dev) in
pci_pm_prepare() will be suspended immediately from a work item,
timer function or otherwise, defeating the very purpose of calling
pm_runtime_resume(dev) from there.  To prevent that from happening
it is necessary to increment the runtime PM usage counter of the
device by replacing pm_runtime_resume() with pm_runtime_get_sync().
Moreover, the incremented runtime PM usage counter has to be
decremented by the corresponding pci_pm_complete(), via
pm_runtime_put_sync().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -624,7 +624,7 @@ static int pci_pm_prepare(struct device
 	 * system from the sleep state, we'll have to prevent it from signaling
 	 * wake-up.
 	 */
-	pm_runtime_resume(dev);
+	pm_runtime_get_sync(dev);
 
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
@@ -638,6 +638,8 @@ static void pci_pm_complete(struct devic
 
 	if (drv && drv->pm && drv->pm->complete)
 		drv->pm->complete(dev);
+
+	pm_runtime_put_sync(dev);
 }
 
 #else /* !CONFIG_PM_SLEEP */


