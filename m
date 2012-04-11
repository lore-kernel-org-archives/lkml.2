Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233Ab2DKXXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:23:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965218Ab2DKXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:57 -0400
Message-Id: <20120411231040.688459493@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sameer Nanda <snanda@chromium.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Hayes Wang <hayeswang@realtek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/59] r8169: runtime resume before shutdown.
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit 2a15cd2ff488a9fdb55e5e34060f499853b27c77 upstream.

With runtime PM, if the ethernet cable is disconnected, the device is
transitioned to D3 state to conserve energy. If the system is shutdown
in this state, any register accesses in rtl_shutdown are dropped on
the floor. As the device was programmed by .runtime_suspend() to wake
on link changes, it is thus brought back up as soon as the link recovers.

Resuming every suspended device through the driver core would slow things
down and it is not clear how many devices really need it now.

Original report and D0 transition patch by Sameer Nanda. Patch has been
changed to comply with advices by Rafael J. Wysocki and the PM folks.

Reported-by: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Hayes Wang <hayeswang@realtek.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6194,6 +6194,9 @@ static void rtl_shutdown(struct pci_dev
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct rtl8169_private *tp = netdev_priv(dev);
+	struct device *d = &pdev->dev;
+
+	pm_runtime_get_sync(d);
 
 	rtl8169_net_suspend(dev);
 
@@ -6215,6 +6218,8 @@ static void rtl_shutdown(struct pci_dev
 		pci_wake_from_d3(pdev, true);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
+
+	pm_runtime_put_noidle(d);
 }
 
 static struct pci_driver rtl8169_pci_driver = {


