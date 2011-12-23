Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1LWSQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1LWSQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:16:29 -0500
Date: Fri, 23 Dec 2011 13:16:26 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-pm@vger.kernel.org
Subject: Print PCI device in power management warning.
Message-ID: <20111223181626.GA18647@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-pm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the WARN_ON in pci_has_legacy_pm_support() triggers, we get
users filing backtraces, but it's not obvious which driver is
triggering the trace. This adds a printk before the BUG.
This still isn't perfect (automated tools like abrt will still miss it)
but we can at least ask the user to look through their dmesg when
we get these traces reported.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 12d1e81..b638244 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -604,7 +604,12 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 	 * supported as well.  Drivers are supposed to support either the
 	 * former, or the latter, but not both at the same time.
 	 */
-	WARN_ON(ret && drv->driver.pm);
+	if (ret && drv->driver.pm) {
+		printk(KERN_WARNING "pci: %s has both legacy and new PM support.\n",
+			drv->name);
+		BUG();
+	}
+
 
 	return ret;
 }
