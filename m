Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab2JKC0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:26:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38739 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933994Ab2JKC00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:26 -0400
X-Sasl-enc: PiXkMaKKN8A+/I7UkSWcukJ0eefRCzfzq7mPiZZi36eZ 1349922385
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sameer Nanda <snanda@chromium.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Hayes Wang <hayeswang@realtek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: =?UTF-8?q?=5B=2069/84=5D=20r8169=3A=20runtime=20resume=20before=20shutdown=2E?=
Date: Thu, 11 Oct 2012 11:03:53 +0900
Message-Id: <20121011015429.496759307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: françois romieu <romieu@fr.zoreil.com>

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
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -5570,6 +5570,9 @@ static void rtl_shutdown(struct pci_dev
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct rtl8169_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
+	struct device *d = &pdev->dev;
+
+	pm_runtime_get_sync(d);
 
 	rtl8169_net_suspend(dev);
 
@@ -5598,6 +5601,8 @@ static void rtl_shutdown(struct pci_dev
 		pci_wake_from_d3(pdev, true);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
+
+	pm_runtime_put_noidle(d);
 }
 
 static struct pci_driver rtl8169_pci_driver = {


