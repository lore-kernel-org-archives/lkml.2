Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1HCXpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:45:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab1HCX0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:44 2011
Message-Id: <20110803221244.694847938@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tobias Klauser <tklauser@distanz.ch>
Subject: [006/102] Staging: usbip: vhci-hcd: Do not kill already dead RX/TX kthread
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tobias Klauser <tklauser@distanz.ch>

commit 8547d4cc2b616e4f1dafebe2c673fc986422b506 upstream.

When unbinding a device on the host which was still attached on the
client, I got a NULL pointer dereference on the client. This turned out
to be due to kthread_stop() being called on an already dead kthread.

Here is how I was able to reproduce the problem:

 server:# usbip bind -b 1-2
                                client:# usbip attach -h server -b 1-2
 server:# usbip unbind -b 1-2

This patch fixes the problem by checking the kthread before attempting
to kill it, as it is done on the opposite side in
stub_shutdown_connection().

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/vhci_hcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -846,9 +846,9 @@ static void vhci_shutdown_connection(str
 	}
 
 	/* kill threads related to this sdev, if v.c. exists */
-	if (vdev->ud.tcp_rx)
+	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
 		kthread_stop(vdev->ud.tcp_rx);
-	if (vdev->ud.tcp_tx)
+	if (vdev->ud.tcp_tx && !task_is_dead(vdev->ud.tcp_tx))
 		kthread_stop(vdev->ud.tcp_tx);
 
 	pr_info("stop threads\n");


