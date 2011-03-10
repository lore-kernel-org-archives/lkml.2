Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1CJX7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:59:14 -0500
Received: from kroah.org ([198.145.64.141]:46921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab1CJX5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.437789526@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ivan Vecera <ivecera@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/29] drivers/net: Call netif_carrier_off at the end of the probe
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit 0d672e9f8ac320c6d1ea9103db6df7f99ea20361 upstream.

Without calling of netif_carrier_off at the end of the probe the operstate
is unknown when the device is initially opened. By default the carrier is
on so when the device is opened and netif_carrier_on is called the link
watch event is not fired and operstate remains zero (unknown).

This patch fixes this behavior in forcedeth and r8169.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |    2 ++
 drivers/net/r8169.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5816,6 +5816,8 @@ static int __devinit nv_probe(struct pci
 		goto out_error;
 	}
 
+	netif_carrier_off(dev);
+
 	dev_printk(KERN_INFO, &pci_dev->dev, "ifname %s, PHY OUI 0x%x @ %d, "
 		   "addr %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x\n",
 		   dev->name,
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3236,6 +3236,8 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_noidle(&pdev->dev);
 
+	netif_carrier_off(dev);
+
 out:
 	return rc;
 


