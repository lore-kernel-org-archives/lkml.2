Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab2HGWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:39:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab2HGWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 053/109] qeth: repair crash in qeth_l3_vlan_rx_kill_vid()
Date: Tue,  7 Aug 2012 15:35:12 -0700
Message-Id: <20120807222047.744694424@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Blaschka <frank.blaschka@de.ibm.com>

commit eabfbe6230ee7363681e7a561948d362b87169f0 upstream.

Commit efc73f4b "net: Fix memory leak - vlan_info struct" adds deletion of
VLAN 0 for devices with feature NETIF_F_HW_VLAN_FILTER. For driver
qeth these are the layer 3 devices. Usually there exists no
separate vlan net_device for VLAN 0. Thus the qeth functions
qeth_l3_free_vlan_addresses4() and qeth_l3_free_vlan_addresses6()
require an extra checking if function __vlan_find_dev_deep()
returns with a net_device.

Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/net/qeth_l3_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1818,6 +1818,8 @@ static void qeth_l3_free_vlan_addresses4
 	QETH_CARD_TEXT(card, 4, "frvaddr4");
 
 	netdev = __vlan_find_dev_deep(card->dev, vid);
+	if (!netdev)
+		return;
 	in_dev = in_dev_get(netdev);
 	if (!in_dev)
 		return;
@@ -1846,6 +1848,8 @@ static void qeth_l3_free_vlan_addresses6
 	QETH_CARD_TEXT(card, 4, "frvaddr6");
 
 	netdev = __vlan_find_dev_deep(card->dev, vid);
+	if (!netdev)
+		return;
 	in6_dev = in6_dev_get(netdev);
 	if (!in6_dev)
 		return;


