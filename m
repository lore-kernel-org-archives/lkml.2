Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1EFAUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:20:00 -0400
Received: from kroah.org ([198.145.64.141]:32795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1EFANQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.061778445@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>
Subject: [patch 08/38] i2c-parport: Fix adapter list handling
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 56acc7a39ac4ac7638cdc32cd3d0832ebbc834e4 upstream.

Use a standard list with proper locking to handle the list of
adapters. Thankfully it only matters on systems with more than one
parallel port, which are very rare.

Thanks to Lukasz Kapiec for reporting the problem to me.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-parport.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/i2c/busses/i2c-parport.c
+++ b/drivers/i2c/busses/i2c-parport.c
@@ -1,7 +1,7 @@
 /* ------------------------------------------------------------------------ *
  * i2c-parport.c I2C bus over parallel port                                 *
  * ------------------------------------------------------------------------ *
-   Copyright (C) 2003-2010 Jean Delvare <khali@linux-fr.org>
+   Copyright (C) 2003-2011 Jean Delvare <khali@linux-fr.org>
    
    Based on older i2c-philips-par.c driver
    Copyright (C) 1995-2000 Simon G. Vogl
@@ -33,6 +33,8 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-smbus.h>
 #include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include "i2c-parport.h"
 
 /* ----- Device list ------------------------------------------------------ */
@@ -43,10 +45,11 @@ struct i2c_par {
 	struct i2c_algo_bit_data algo_data;
 	struct i2c_smbus_alert_setup alert_data;
 	struct i2c_client *ara;
-	struct i2c_par *next;
+	struct list_head node;
 };
 
-static struct i2c_par *adapter_list;
+static LIST_HEAD(adapter_list);
+static DEFINE_MUTEX(adapter_list_lock);
 
 /* ----- Low-level parallel port access ----------------------------------- */
 
@@ -228,8 +231,9 @@ static void i2c_parport_attach (struct p
 	}
 
 	/* Add the new adapter to the list */
-	adapter->next = adapter_list;
-	adapter_list = adapter;
+	mutex_lock(&adapter_list_lock);
+	list_add_tail(&adapter->node, &adapter_list);
+	mutex_unlock(&adapter_list_lock);
         return;
 
 ERROR1:
@@ -241,11 +245,11 @@ ERROR0:
 
 static void i2c_parport_detach (struct parport *port)
 {
-	struct i2c_par *adapter, *prev;
+	struct i2c_par *adapter, *_n;
 
 	/* Walk the list */
-	for (prev = NULL, adapter = adapter_list; adapter;
-	     prev = adapter, adapter = adapter->next) {
+	mutex_lock(&adapter_list_lock);
+	list_for_each_entry_safe(adapter, _n, &adapter_list, node) {
 		if (adapter->pdev->port == port) {
 			if (adapter->ara) {
 				parport_disable_irq(port);
@@ -259,14 +263,11 @@ static void i2c_parport_detach (struct p
 				
 			parport_release(adapter->pdev);
 			parport_unregister_device(adapter->pdev);
-			if (prev)
-				prev->next = adapter->next;
-			else
-				adapter_list = adapter->next;
+			list_del(&adapter->node);
 			kfree(adapter);
-			return;
 		}
 	}
+	mutex_unlock(&adapter_list_lock);
 }
 
 static struct parport_driver i2c_parport_driver = {


