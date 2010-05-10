Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab0EJX3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:29:05 -0400
Received: from kroah.org ([198.145.64.141]:33373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab0EJWww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223325.963212772@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [095/117] WAN: flush tx_queue in hdlc_ppp to prevent panic on rmmod hw_driver.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Krzysztof Halasa <khc@pm.waw.pl>

[ Upstream commit 31f634a63de7068c6a5dcb0d7b09b24b61a5cf88 ]

tx_queue is used as a temporary queue when not allowed to queue skb
directly to the hw device driver (which may sleep). Most paths flush
it before returning, but ppp_start() currently cannot. Make sure we
don't leave skbs pointing to a non-existent device.

Thanks to Michael Barkowski for reporting this problem.

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wan/hdlc_ppp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -628,9 +628,15 @@ static void ppp_stop(struct net_device *
 	ppp_cp_event(dev, PID_LCP, STOP, 0, 0, 0, NULL);
 }
 
+static void ppp_close(struct net_device *dev)
+{
+	ppp_tx_flush();
+}
+
 static struct hdlc_proto proto = {
 	.start		= ppp_start,
 	.stop		= ppp_stop,
+	.close		= ppp_close,
 	.type_trans	= ppp_type_trans,
 	.ioctl		= ppp_ioctl,
 	.netif_rx	= ppp_rx,


