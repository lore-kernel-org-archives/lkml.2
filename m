Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1BPAWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:20 -0500
Received: from kroah.org ([198.145.64.141]:49112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab1BPAWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.647443541@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [146/272] jz4740-battery: Protect against concurrent battery readings
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8ec98fe0b4ffdedce4c1caa9fb3d550f52ad1c6b upstream.

We can not handle more then one ADC request at a time to the battery.
The patch adds a mutex around the ADC read code to ensure this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/power/jz4740-battery.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -47,6 +47,8 @@ struct jz_battery {
 
 	struct power_supply battery;
 	struct delayed_work work;
+
+	struct mutex lock;
 };
 
 static inline struct jz_battery *psy_to_jz_battery(struct power_supply *psy)
@@ -68,6 +70,8 @@ static long jz_battery_read_voltage(stru
 	unsigned long val;
 	long voltage;
 
+	mutex_lock(&battery->lock);
+
 	INIT_COMPLETION(battery->read_completion);
 
 	enable_irq(battery->irq);
@@ -91,6 +95,8 @@ static long jz_battery_read_voltage(stru
 	battery->cell->disable(battery->pdev);
 	disable_irq(battery->irq);
 
+	mutex_unlock(&battery->lock);
+
 	return voltage;
 }
 
@@ -291,6 +297,7 @@ static int __devinit jz_battery_probe(st
 	jz_battery->pdev = pdev;
 
 	init_completion(&jz_battery->read_completion);
+	mutex_init(&jz_battery->lock);
 
 	INIT_DELAYED_WORK(&jz_battery->work, jz_battery_work);
 


