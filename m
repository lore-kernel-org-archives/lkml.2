Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1GYPYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:24:45 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:45483 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1GYPYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.39
Message-ID: <4E2D88C7.30409@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:16:23 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 01/10] lis3lv02d: avoid divide by zero due to unchecked
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After an "unexpected" reboot, I found this Oops in my logs:

divide error: 0000 [#1] PREEMPT SMP=20
CPU 0=20
Modules linked in: lis3lv02d hp_wmi input_polldev [...]
Pid: 390, comm: modprobe Tainted: G         C  2.6.39-rc7-wl+=20
RIP: 0010:[<ffffffffa014b427>]  [<ffffffffa014b427>]
		 lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
RSP: 0018:ffff8801d6407cf8  EFLAGS: 00010246
RAX: 0000000000000bb8 RBX: ffffffffa014e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffea00066e4708 RDI: ffff8801df002700
RBP: ffff8801d6407d18 R08: ffffea00066c5a30 R09: ffffffff812498c9
R10: ffff8801d7bfcea0 R11: ffff8801d7bfce10 R12: 0000000000000bb8
R13: 00000000ffffffda R14: ffffffffa0154120 R15: ffffffffa0154030
=46S:  00007fc0705db700(0000) GS:ffff8801dfa00000(0000) knlGS:0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f33549174f0 CR3: 00000001d65c9000 CR4: 00000000000406f0
Process modprobe (pid: 390, threadinfo ffff8801d6406000, task ffff8801d6b40=
000)
Stack:
 ffffffffa0154120 62ffffffa0154030 ffffffffa014e000 00000000ffffffea
 ffff8801d6407d58 ffffffffa014bcc1 0000000000000000 0000000000000048
 ffff8801d8bae800 00000000ffffffea 00000000ffffffda ffffffffa0154120
Call Trace:
 [<ffffffffa014bcc1>] lis3lv02d_init_device+0x1ce/0x496 [lis3lv02d]
 [<ffffffffa01522ff>] lis3lv02d_add+0x10f/0x17c [hp_accel]
 [<ffffffff81233e11>] acpi_device_probe+0x49/0x117
[...]
Code: 3a 75 06 80 4d ef 50 eb 04 80 4d ef 40 0f b6 55 ef be 21
00 00 00 48 89 df ff 53 18 44 8b 63 6c e8 3e fc ff ff 89 c1 44
89 e0 99 <f7> f9 89 c7 e8 93 82 ef e0 48 83 7b 30 00 74 2d 45
31 e4 80 7b=20
RIP  [<ffffffffa014b427>] lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
 RSP <ffff8801d6407cf8>

>From my POV, it looks like the hardware is not working as expected
and returns a bogus data rate. The driver doesn't check the result
and directly uses it as some sort of divisor in some places:

msleep(lis3->pwron_delay / lis3lv02d_get_odr());

Under this circumstances, this could very well cause the
"divide by zero" exception from above.

For now, I fixed it the easiest and most obvious way:
Check if the result is sane and if it isn't use a sane default
instead. I went for "100" in the latter case, simply because
/sys/devices/platform/lis3lv02d/rate returns it on a successful
boot.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/misc/lis3lv02d/lis3lv02d.c |   36 ++++++++++++++++++++++++++++++------
 drivers/misc/lis3lv02d/lis3lv02d.h |    2 +-
 drivers/platform/x86/hp_accel.c    |    3 +--
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index b928bc1..a9ee5f7 100644
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
+	msleep(lis3->pwron_delay / div);
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
-- 
1.7.6

