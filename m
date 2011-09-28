Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab1I1WtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab1I1WtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.135754343@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [216/244] cnic: Improve NETDEV_UP event handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit db1d350fcb156b58f66a67680617077bcacfe6fc upstream.

During NETDEV_UP, we use symbol_get() to get the net driver's cnic
probe function.  This sometimes doesn't work if NETDEV_UP happens
right after NETDEV_REGISTER and the net driver is still running module
init code.  As a result, the cnic device may not be discovered.  We
fix this by probing on all NETDEV events if the device's netif_running
state is up.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cnic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -5342,7 +5342,7 @@ static int cnic_netdev_event(struct noti
 
 	dev = cnic_from_netdev(netdev);
 
-	if (!dev && (event == NETDEV_REGISTER || event == NETDEV_UP)) {
+	if (!dev && (event == NETDEV_REGISTER || netif_running(netdev))) {
 		/* Check for the hot-plug device */
 		dev = is_cnic_dev(netdev);
 		if (dev) {
@@ -5358,7 +5358,7 @@ static int cnic_netdev_event(struct noti
 		else if (event == NETDEV_UNREGISTER)
 			cnic_ulp_exit(dev);
 
-		if (event == NETDEV_UP) {
+		if (event == NETDEV_UP || (new_dev && netif_running(netdev))) {
 			if (cnic_register_netdev(dev) != 0) {
 				cnic_put(dev);
 				goto done;


