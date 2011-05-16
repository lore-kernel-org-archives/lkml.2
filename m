Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1EPVgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:36:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34482 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab1EPVgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=PBUybFND+eHkzn3ZLIE05OQWPNnxjNwSr1yEVHHWmaHE437AsVZWmrljS7LWkz/UsD
         y13xdd+5TgXUNjZiwGj7Yt7JQcQb0mYhZ+LsgWV2UqeDn41zfb5YfKsZcxULhOiRV+bz
         rB6YUyF35bKVBr38MmwpJ/zbPNzaG9OQzLnHo=
From: Christian Lamparter <chunkeey@googlemail.com>
To: =?iso-8859-1?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Subject: Re: [RFC v2] lis3lv02d: avoid divide by zero due to unchecked register read
Date: Mon, 16 May 2011 23:36:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105160046.31019.chunkeey@googlemail.com> <4DD1079E.6000209@tremplin-utc.net>
In-Reply-To: <4DD1079E.6000209@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105162336.05306.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 May 2011 13:16:46 Éric Piel wrote:
> Op 16-05-11 00:46, Christian Lamparter schreef:
> > From my POV, it looks like the hardware is not working as expected
> > and returns a bogus data rate. The driver doesn't check the result
> > and directly uses it as some sort of divisor in some places:
> >
> > msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> >
> > Under this circumstances, this could very well cause the
> > "divide by zero" exception from above.
> >
> However, I'd fix it a bit differently: let lis3lv02d_get_odr() return 
> the raw data, and create a special function 
> lis3lv02d_get_pwron_delay_ms() which does the "lis3->pwron_delay / 
> lis3lv02d_get_odr()" with special handling for 0 (returning a large 
> value and also sending a printk_once() ).
Do you know how "volatile" this data rate is? If it never changes 
[at least it doesn't here?] then why not read it once in init_device
and store it in the device context?

Anyway, I updated the code... But instead of returning a "large value"
I went for the -ENXIO to bail-out early, so now we won't continue if
something went bad [after resume for instance?].

> As you have noted, we might want to check other parts of the driver to 
> validate the data from the device. So far, all the code considers that 
> the device is flawless :-S
well:
  CHECK   drivers/misc/lis3lv02d/lis3lv02d.c
drivers/misc/lis3lv02d/lis3lv02d.c:170:52: warning: cast to restricted __le16

but this is a tiny tiny niggle (on x86 at least).
---
v1 -> v2
   - Eric's comments
---
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index b928bc1..60539c8 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -206,6 +206,18 @@ static int lis3lv02d_get_odr(void)
 	return lis3_dev.odrs[(ctrl >> shift)];
 }
 
+static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
+{
+	int div = lis3lv02d_get_odr();
+
+	if (WARN_ONCE(div == 0, "device returned spurious data"))
+		return -ENXIO;
+
+	/* LIS3 power on delay is quite long */
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	return 0;
+}
+
 static int lis3lv02d_set_odr(int rate)
 {
 	u8 ctrl;
@@ -266,7 +278,9 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 
 	lis3->read(lis3, ctlreg, &reg);
 	lis3->write(lis3, ctlreg, (reg | selftest));
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	ret = lis3lv02d_get_pwron_wait(lis3);
+	if (ret)
+		goto fail;
 
 	/* Read directly to avoid axis remap */
 	x = lis3->read_data(lis3, OUTX);
@@ -275,7 +289,9 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 
 	/* back to normal settings */
 	lis3->write(lis3, ctlreg, reg);
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	ret = lis3lv02d_get_pwron_wait(lis3);
+	if (ret)
+		goto fail;
 
 	results[0] = x - lis3->read_data(lis3, OUTX);
 	results[1] = y - lis3->read_data(lis3, OUTY);
@@ -363,8 +379,9 @@ void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
-void lis3lv02d_poweron(struct lis3lv02d *lis3)
+int lis3lv02d_poweron(struct lis3lv02d *lis3)
 {
+	int err;
 	u8 reg;
 
 	lis3->init(lis3);
@@ -382,11 +399,14 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 		reg |= CTRL2_BOOT_8B;
 	lis3->write(lis3, CTRL_REG2, reg);
 
-	/* LIS3 power on delay is quite long */
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	err = lis3lv02d_get_pwron_wait(lis3);
+	if (err)
+		return err;
 
 	if (lis3->reg_ctrl)
 		lis3_context_restore(lis3);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
@@ -926,7 +946,11 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	atomic_set(&dev->wake_thread, 0);
 
 	lis3lv02d_add_fs(dev);
-	lis3lv02d_poweron(dev);
+	err = lis3lv02d_poweron(dev);
+	if (err) {
+		lis3lv02d_remove_fs(dev);
+		return err;
+	}
 
 	if (dev->pm_dev) {
 		pm_runtime_set_active(dev->pm_dev);
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index a193958..57c64bb 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -285,7 +285,7 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3);
 int lis3lv02d_joystick_enable(void);
 void lis3lv02d_joystick_disable(void);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
-void lis3lv02d_poweron(struct lis3lv02d *lis3);
+int lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
 
 extern struct lis3lv02d lis3_dev;
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 1b52d00..891e71f 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -354,8 +354,7 @@ static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	lis3lv02d_poweron(&lis3_dev);
-	return 0;
+	return lis3lv02d_poweron(&lis3_dev);
 }
 #else
 #define lis3lv02d_suspend NULL
