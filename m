Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab0JVSny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:43:54 -0400
Received: from kroah.org ([198.145.64.141]:45967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab0JVSlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:33 2010
Message-Id: <20101022184033.209913125@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Tettamanti <kronos.it@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [08/17] atl1: fix resume
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luca Tettamanti <kronos.it@gmail.com>

commit ec5a32f67c603b11d68eb283d94eb89a4f6cfce1 upstream.

adapter->cmb.cmb is initialized when the device is opened and freed when
it's closed. Accessing it unconditionally during resume results either
in a crash (NULL pointer dereference, when the interface has not been
opened yet) or data corruption (when the interface has been used and
brought down adapter->cmb.cmb points to a deallocated memory area).

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Acked-by: Chris Snook <chris.snook@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atlx/atl1.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2881,10 +2881,11 @@ static int atl1_resume(struct pci_dev *p
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
 	atl1_reset_hw(&adapter->hw);
-	adapter->cmb.cmb->int_stats = 0;
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		adapter->cmb.cmb->int_stats = 0;
 		atl1_up(adapter);
+	}
 	netif_device_attach(netdev);
 
 	return 0;


