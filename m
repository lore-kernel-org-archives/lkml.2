Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0CaAES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:04:18 -0400
Received: from kroah.org ([198.145.64.141]:45299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab0C3XSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:33 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:47 2010
Message-Id: <20100330225647.000006053@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guo-Fu Tseng <cooldavid@cooldavid.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [075/116] jme: Protect vlgrp structure by pause RX actions.
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit bf5e5360fd1df1ae429ebbd81838d7d0879797d1 upstream.

Temporary stop the RX IRQ, and disable (sync) tasklet or napi.
And restore it after finished the vlgrp pointer assignment.

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/jme.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -2087,12 +2087,45 @@ jme_tx_timeout(struct net_device *netdev
 	jme_reset_link(jme);
 }
 
+static inline void jme_pause_rx(struct jme_adapter *jme)
+{
+	atomic_dec(&jme->link_changing);
+
+	jme_set_rx_pcc(jme, PCC_OFF);
+	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
+		JME_NAPI_DISABLE(jme);
+	} else {
+		tasklet_disable(&jme->rxclean_task);
+		tasklet_disable(&jme->rxempty_task);
+	}
+}
+
+static inline void jme_resume_rx(struct jme_adapter *jme)
+{
+	struct dynpcc_info *dpi = &(jme->dpi);
+
+	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
+		JME_NAPI_ENABLE(jme);
+	} else {
+		tasklet_hi_enable(&jme->rxclean_task);
+		tasklet_hi_enable(&jme->rxempty_task);
+	}
+	dpi->cur		= PCC_P1;
+	dpi->attempt		= PCC_P1;
+	dpi->cnt		= 0;
+	jme_set_rx_pcc(jme, PCC_P1);
+
+	atomic_inc(&jme->link_changing);
+}
+
 static void
 jme_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 
+	jme_pause_rx(jme);
 	jme->vlgrp = grp;
+	jme_resume_rx(jme);
 }
 
 static void


