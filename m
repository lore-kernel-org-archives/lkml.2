Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1EMOPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:15:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53876 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1EMOPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:15:44 -0400
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/isdn/hisax: Drop unused list
Date: Fri, 13 May 2011 16:15:39 +0200
Message-Id: <1305296139-16773-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file st5481_init.c locally defines and initializes the adapter_list
variable, but does not use it for anything.  Removing the list makes it
possible to remove the list field from the st5481_adapter data structure.
In the function probe_st5481, it also makes it possible to free the locally
allocated adapter value on an error exit.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hisax/st5481.h      |    1 -
 drivers/isdn/hisax/st5481_init.c |    6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/st5481.h b/drivers/isdn/hisax/st5481.h
index 64f78a8..b9054cb 100644
--- a/drivers/isdn/hisax/st5481.h
+++ b/drivers/isdn/hisax/st5481.h
@@ -377,7 +377,6 @@ struct st5481_bcs {
 };
 
 struct st5481_adapter {
-	struct list_head list;
 	int number_of_leds;
 	struct usb_device *usb_dev;
 	struct hisax_d_if hisax_d_if;
diff --git a/drivers/isdn/hisax/st5481_init.c b/drivers/isdn/hisax/st5481_init.c
index 1375123..9f7fd18 100644
--- a/drivers/isdn/hisax/st5481_init.c
+++ b/drivers/isdn/hisax/st5481_init.c
@@ -46,8 +46,6 @@ module_param(debug, int, 0);
 #endif
 int st5481_debug;
 
-static LIST_HEAD(adapter_list);
-
 /* ======================================================================
  * registration/deregistration with the USB layer
  */
@@ -86,7 +84,6 @@ static int probe_st5481(struct usb_interface *intf,
 		adapter->bcs[i].b_if.ifc.priv = &adapter->bcs[i];
 		adapter->bcs[i].b_if.ifc.l2l1 = st5481_b_l2l1;
 	}
-	list_add(&adapter->list, &adapter_list);
 
 	retval = st5481_setup_usb(adapter);
 	if (retval < 0)
@@ -125,6 +122,7 @@ static int probe_st5481(struct usb_interface *intf,
  err_usb:
 	st5481_release_usb(adapter);
  err:
+	kfree(adapter);
 	return -EIO;
 }
 
@@ -142,8 +140,6 @@ static void disconnect_st5481(struct usb_interface *intf)
 	if (!adapter)
 		return;
 	
-	list_del(&adapter->list);
-
 	st5481_stop(adapter);
 	st5481_release_b(&adapter->bcs[1]);
 	st5481_release_b(&adapter->bcs[0]);

