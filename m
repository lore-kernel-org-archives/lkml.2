Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0LLQtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:49:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:45400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0LLQtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:49:14 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Duncan Sands <duncan.sands@free.fr>, linux-usb@vger.kernel.org
Subject: [PATCH 6/6] usb: don't use flush_scheduled_work()
Date: Sun, 12 Dec 2010 17:48:19 +0100
Message-Id: <1292172499-21633-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:49:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is being deprecated.  Directly flush or cancel
work items instead.

* u_ether, isp1301_omap, speedtch conversions are straight-forward.

* ochi-hcd should only flush when quirk_nec() is true as otherwise the
  work wouldn't have been initialized.

* In oti6858, cancel_delayed_work() + flush_scheduled_work() ->
  cancel_delayed_work_sync().

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: linux-usb@vger.kernel.org
---
This is part of a series to remove flush_scheduled_work() usage to
prepare for deprecation of flush_scheduled_work().  Patches in this
series are self contained and mostly straight-forward.

Please feel free to take it into the appropriate tree, or just ack it.
In the latter case, I'll merge the patch through the workqueue tree
during the next merge window.

Thank you.

 drivers/usb/atm/speedtch.c     |    2 +-
 drivers/usb/gadget/u_ether.c   |    4 +---
 drivers/usb/host/ohci-hcd.c    |    3 ++-
 drivers/usb/otg/isp1301_omap.c |    2 +-
 drivers/usb/serial/oti6858.c   |    5 ++---
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index b591906..ff0f219 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -718,7 +718,7 @@ static void speedtch_atm_stop(struct usbatm_data *usbatm, struct atm_dev *atm_de
 	del_timer_sync(&instance->resubmit_timer);
 	usb_free_urb(int_urb);
 
-	flush_scheduled_work();
+	flush_work_sync(&instance->status_check_work);
 }
 
 static int speedtch_pre_reset(struct usb_interface *intf)
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index fbe86ca..00a7824 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -829,11 +829,9 @@ void gether_cleanup(void)
 		return;
 
 	unregister_netdev(the_dev->net);
+	flush_work_sync(&the_dev->work);
 	free_netdev(the_dev->net);
 
-	/* assuming we used keventd, it must quiesce too */
-	flush_scheduled_work();
-
 	the_dev = NULL;
 }
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 5179acb..bd5eff7 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -901,7 +901,8 @@ static void ohci_stop (struct usb_hcd *hcd)
 
 	ohci_dump (ohci, 1);
 
-	flush_scheduled_work();
+	if (quirk_nec(ohci))
+		flush_work_sync(&ohci->nec_work);
 
 	ohci_usb_reset (ohci);
 	ohci_writel (ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index 4569694..e00fa1b 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -1247,7 +1247,7 @@ static int __exit isp1301_remove(struct i2c_client *i2c)
 	isp->timer.data = 0;
 	set_bit(WORK_STOP, &isp->todo);
 	del_timer_sync(&isp->timer);
-	flush_scheduled_work();
+	flush_work_sync(&isp->work);
 
 	put_device(&i2c->dev);
 	the_transceiver = NULL;
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index e199b0f..5be866b 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -613,9 +613,8 @@ static void oti6858_close(struct usb_serial_port *port)
 	dbg("%s(): after buf_clear()", __func__);
 
 	/* cancel scheduled setup */
-	cancel_delayed_work(&priv->delayed_setup_work);
-	cancel_delayed_work(&priv->delayed_write_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&priv->delayed_setup_work);
+	cancel_delayed_work_sync(&priv->delayed_write_work);
 
 	/* shutdown our urbs */
 	dbg("%s(): shutting down urbs", __func__);
-- 
1.7.1

