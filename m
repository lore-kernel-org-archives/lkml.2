Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0KERvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:51:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34273 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0KERvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:51:44 -0400
Date: Fri, 5 Nov 2010 18:51:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com, Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/adt7470 crash on module load (2.6.37-rc1)
Message-ID: <20101105185134.29d0b387@endymion.delvare>
In-Reply-To: <1288976281.22931.209.camel@groeck-laptop>
References: <20101104170929.f5198be3.randy.dunlap@oracle.com>
	<20101105094222.2bfbfb92@endymion.delvare>
	<4CD4187F.1030305@oracle.com>
	<20101105161741.459be240@endymion.delvare>
	<20101105092143.2bd3d315.randy.dunlap@oracle.com>
	<1288976281.22931.209.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010 09:58:01 -0700, Guenter Roeck wrote:
> On Fri, 2010-11-05 at 12:21 -0400, Randy Dunlap wrote:
> > /sys/bus/i2c/devices/i2c-0/name:gmbus disabled
> > /sys/bus/i2c/devices/i2c-10/name:GPIOE
> > /sys/bus/i2c/devices/i2c-11/name:gmbus reserveddpd
> > /sys/bus/i2c/devices/i2c-12/name:GPIOF
> > /sys/bus/i2c/devices/i2c-13/name:gmbus (null)
> > /sys/bus/i2c/devices/i2c-14/name:GPIO?
> 
> The above two lines look a bit fishy to me.

I had the exact same thought. And "reserveddpd" looks odd as well.

> Wonder if 7b5337ddbaf7e4b71ef6fd6307c6f9ef84f636e9 or one of the other
> recent changes in drivers/gpu/drm/i915/intel_i2c.c caused some havoc.

Thanks for the pointer. But if Randy is running 2.6.37-rc1, he doesn't
have this commit yet. Upgrading to 2.6.37-rc1-git3 might be a good
idea. Especially as rc1 also lacks
cb8ea7527b813dd6e19fb07328f7867a5f0a8d0a, if I understand what git
name-rev is telling me. Apparently the "GMBUS" code was reverted
(whatever it is) because it caused trouble. Maybe this is the trouble
Randy just met.

Looking at the code, I indeed see a couple things which need fixing.
Randy, please test this patch (on top of rc1-git3) Hopefully it will
fix your adapter names, and possibly solve your crash (but if you
couldn't reproduce it, you won't be able to confirm this.)

From: Jean Delvare <khali@linux-fr.org>
Subject: drm/i915: Fix I2C adapter registration

Fix many small bugs in I2C adapter registration:
* Properly reject unsupported GPIO pin.
* Fix improper use of I2C_NAME_SIZE (which is the size of
  i2c_client.name, not i2c_adapter.name.)
* Prefix adapter names with "i915" so that the user knows what the
  I2C channel is connected to.
* Fix swapped characters in the string used to name the GPIO-based
  adapter.
* Add missing comma in gmbus name table.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.37-rc1.orig/drivers/gpu/drm/i915/intel_i2c.c	2010-11-02 09:19:35.000000000 +0100
+++ linux-2.6.37-rc1/drivers/gpu/drm/i915/intel_i2c.c	2010-11-05 18:38:15.000000000 +0100
@@ -160,7 +160,7 @@ intel_gpio_create(struct drm_i915_privat
 	};
 	struct intel_gpio *gpio;
 
-	if (pin < 1 || pin > 7)
+	if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])
 		return NULL;
 
 	gpio = kzalloc(sizeof(struct intel_gpio), GFP_KERNEL);
@@ -172,7 +172,8 @@ intel_gpio_create(struct drm_i915_privat
 		gpio->reg += PCH_GPIOA - GPIOA;
 	gpio->dev_priv = dev_priv;
 
-	snprintf(gpio->adapter.name, I2C_NAME_SIZE, "GPIO%c", "?BACDEF?"[pin]);
+	snprintf(gpio->adapter.name, sizeof(gpio->adapter.name), "i915 GPIO%c",
+		 "?BACDE?F"[pin]);
 	gpio->adapter.owner = THIS_MODULE;
 	gpio->adapter.algo_data	= &gpio->algo;
 	gpio->adapter.dev.parent = &dev_priv->dev->pdev->dev;
@@ -349,7 +350,7 @@ int intel_setup_gmbus(struct drm_device
 		"panel",
 		"dpc",
 		"dpb",
-		"reserved"
+		"reserved",
 		"dpd",
 	};
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -366,8 +367,8 @@ int intel_setup_gmbus(struct drm_device
 		bus->adapter.owner = THIS_MODULE;
 		bus->adapter.class = I2C_CLASS_DDC;
 		snprintf(bus->adapter.name,
-			 I2C_NAME_SIZE,
-			 "gmbus %s",
+			 sizeof(bus->adapter.name),
+			 "i915 gmbus %s",
 			 names[i]);
 
 		bus->adapter.dev.parent = &dev->pdev->dev;

-- 
Jean Delvare
