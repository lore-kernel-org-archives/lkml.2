Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2I0TqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:46:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49801 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2I0TqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:46:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 27 Sep 2012 21:46:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: addendum to address handler RCU conversion
Message-ID: <20120927214609.4ab01f35@stein>
In-Reply-To: <20120927214436.1da8b8ef@stein>
References: <1345359002.6089.3.camel@thor>
	<20120819122759.30f9981f@stein>
	<1345403610.7706.72.camel@thor>
	<20120820030450.7f5bfa37@stein>
	<20120927214436.1da8b8ef@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow up on commit "firewire: remove global lock around address handlers,
convert to RCU":

  - address_handler_lock no longer serializes the address handler, only
    its function to serialize updates to the list of handlers remains.
    Rename the lock to address_handler_list_lock.

  - Callers of fw_core_remove_address_handler() must be able to sleep.
    Comment on this in the API documentation.

  - The counterpart fw_core_add_address_handler() is by nature something
    which is used in process context.  Replace spin_lock_bh() by
    spin_lock() in fw_core_add_address_handler() and in
    fw_core_remove_address_handler(), and document that process context
    is now required for fw_core_add_address_handler().

  - Extend the documentation of fw_address_callback_t.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |   13 ++++++++-----
 include/linux/firewire.h            |   12 ++++++++++--
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -518,7 +518,7 @@ static struct fw_address_handler *lookup
 	return NULL;
 }
 
-static DEFINE_SPINLOCK(address_handler_lock);
+static DEFINE_SPINLOCK(address_handler_list_lock);
 static LIST_HEAD(address_handler_list);
 
 const struct fw_address_region fw_high_memory_region =
@@ -555,6 +555,7 @@ static bool is_in_fcp_region(u64 offset,
  * the specified callback is invoked.  The parameters passed to the callback
  * give the details of the particular request.
  *
+ * To be called in process context.
  * Return value:  0 on success, non-zero otherwise.
  *
  * The start offset of the handler's address region is determined by
@@ -575,7 +576,7 @@ int fw_core_add_address_handler(struct f
 	    handler->length == 0)
 		return -EINVAL;
 
-	spin_lock_bh(&address_handler_lock);
+	spin_lock(&address_handler_list_lock);
 
 	handler->offset = region->start;
 	while (handler->offset + handler->length <= region->end) {
@@ -594,7 +595,7 @@ int fw_core_add_address_handler(struct f
 		}
 	}
 
-	spin_unlock_bh(&address_handler_lock);
+	spin_unlock(&address_handler_list_lock);
 
 	return ret;
 }
@@ -603,14 +604,16 @@ EXPORT_SYMBOL(fw_core_add_address_handle
 /**
  * fw_core_remove_address_handler() - unregister an address handler
  *
+ * To be called in process context.
+ *
  * When fw_core_remove_address_handler() returns, @handler->callback() is
  * guaranteed to not run on any CPU anymore.
  */
 void fw_core_remove_address_handler(struct fw_address_handler *handler)
 {
-	spin_lock_bh(&address_handler_lock);
+	spin_lock(&address_handler_list_lock);
 	list_del_rcu(&handler->link);
-	spin_unlock_bh(&address_handler_lock);
+	spin_unlock(&address_handler_list_lock);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(fw_core_remove_address_handler);
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -265,8 +265,16 @@ typedef void (*fw_transaction_callback_t
 					  void *data, size_t length,
 					  void *callback_data);
 /*
- * Important note:  Except for the FCP registers, the callback must guarantee
- * that either fw_send_response() or kfree() is called on the @request.
+ * This callback handles an inbound request subaction.  It is called in
+ * RCU read-side context, therefore must not sleep.
+ *
+ * The callback should not initiate outbound request subactions directly.
+ * Otherwise there is a danger of recursion of inbound and outbound
+ * transactions from and to the local node.
+ *
+ * The callback is responsible that either fw_send_response() or kfree()
+ * is called on the @request, except for FCP registers for which the core
+ * takes care of that.
  */
 typedef void (*fw_address_callback_t)(struct fw_card *card,
 				      struct fw_request *request,


-- 
Stefan Richter
-=====-===-- =--= ==-==
http://arcgraph.de/sr/
