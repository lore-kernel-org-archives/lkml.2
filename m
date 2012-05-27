Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab2E0B1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:27:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933992Ab2E0BSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:18:11 -0400
Message-Id: <20120527002517.763110383@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Subject: [ 50/91] USB: gpio_vbus: provide an appropriate debounce interval
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

commit 934ccec4da14dc0586dfe08b36166364bdd2181b upstream.

In commit c2344f13b59e007d782a3e591ebc551bc583a8b7 (USB: gpio_vbus:
add delayed vbus_session calls, 2009-01-24), usb_gadget_vbus_connect()
and ...disconnect() were extracted from the interrupt handler, so to
allow vbus_session handlers to deal with msleep() calls.

This patch takes the approach one step further.

USB2.0 specification (7.1.7.3 Connect and Disconnect Signaling) says
that the USB system software (shall) provide a debounce interval with
a minimum duration of 100 ms, which ensures that the electrical and
mechanical connection is stable before software attempts to reset
the attached device.

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/otg/gpio_vbus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/otg/gpio_vbus.c
+++ b/drivers/usb/otg/gpio_vbus.c
@@ -37,7 +37,7 @@ struct gpio_vbus_data {
 	struct regulator       *vbus_draw;
 	int			vbus_draw_enabled;
 	unsigned		mA;
-	struct work_struct	work;
+	struct delayed_work	work;
 };
 
 
@@ -94,7 +94,7 @@ static int is_vbus_powered(struct gpio_v
 static void gpio_vbus_work(struct work_struct *work)
 {
 	struct gpio_vbus_data *gpio_vbus =
-		container_of(work, struct gpio_vbus_data, work);
+		container_of(work, struct gpio_vbus_data, work.work);
 	struct gpio_vbus_mach_info *pdata = gpio_vbus->dev->platform_data;
 	int gpio, status;
 
@@ -152,7 +152,7 @@ static irqreturn_t gpio_vbus_irq(int irq
 		otg->gadget ? otg->gadget->name : "none");
 
 	if (otg->gadget)
-		schedule_work(&gpio_vbus->work);
+		schedule_delayed_work(&gpio_vbus->work, msecs_to_jiffies(100));
 
 	return IRQ_HANDLED;
 }
@@ -300,7 +300,7 @@ static int __init gpio_vbus_probe(struct
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&gpio_vbus->phy.notifier);
 
-	INIT_WORK(&gpio_vbus->work, gpio_vbus_work);
+	INIT_DELAYED_WORK(&gpio_vbus->work, gpio_vbus_work);
 
 	gpio_vbus->vbus_draw = regulator_get(&pdev->dev, "vbus_draw");
 	if (IS_ERR(gpio_vbus->vbus_draw)) {


