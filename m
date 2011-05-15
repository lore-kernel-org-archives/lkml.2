Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1EOWqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:46:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56463 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1EOWqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:46:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=BHBLd83goxKdu1Jcm85kXUI3kScMsK6ZefiwNXU+5KD2BBnyGJJa4YLhoKn33pQfXI
         XrTYg2h3KwP4U8J9forXp1kSeR/XhiXUNw3xNATU/GcL8BZ2Ou1L2jGc0YePwG7vNuWU
         UI9tVQWbQq/EHzHVMQFNlmWJ0PoUZ5fsL/DZI=
From: Christian Lamparter <chunkeey@googlemail.com>
To: eric.piel@tremplin-utc.net
Subject: [PATCH] lis3lv02d: avoid divide by zero due to unchecked register read
Date: Mon, 16 May 2011 00:46:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105160046.31019.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After an "unexpected" reboot, I found this Oops in my logs:

divide error: 0000 [#1] PREEMPT SMP 
CPU 0 
Modules linked in: lis3lv02d hp_wmi input_polldev [...]
Pid: 390, comm: modprobe Tainted: G         C  2.6.39-rc7-wl+ 
RIP: 0010:[<ffffffffa014b427>]  [<ffffffffa014b427>]
		 lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
RSP: 0018:ffff8801d6407cf8  EFLAGS: 00010246
RAX: 0000000000000bb8 RBX: ffffffffa014e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffea00066e4708 RDI: ffff8801df002700
RBP: ffff8801d6407d18 R08: ffffea00066c5a30 R09: ffffffff812498c9
R10: ffff8801d7bfcea0 R11: ffff8801d7bfce10 R12: 0000000000000bb8
R13: 00000000ffffffda R14: ffffffffa0154120 R15: ffffffffa0154030
FS:  00007fc0705db700(0000) GS:ffff8801dfa00000(0000) knlGS:0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f33549174f0 CR3: 00000001d65c9000 CR4: 00000000000406f0
Process modprobe (pid: 390, threadinfo ffff8801d6406000, task ffff8801d6b40000)
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
31 e4 80 7b 
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
---
Oh, please keep the CC.

Note: This patch is a bit experimental, I can't get the
device to fail reliable so even with the patch, it might
fail in a different place.

Regards,
	Chr
---
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index b928bc1..96102f0 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -198,12 +198,18 @@ static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
 static int lis3lv02d_get_odr(void)
 {
 	u8 ctrl;
-	int shift;
+	int shift, res;
 
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
 	ctrl &= lis3_dev.odr_mask;
 	shift = ffs(lis3_dev.odr_mask) - 1;
-	return lis3_dev.odrs[(ctrl >> shift)];
+	res = lis3_dev.odrs[(ctrl >> shift)];
+
+	/*
+	 * because the result is used as a divisor, it must
+	 * not be a zero.
+	 */
+	return (res != 0) ? res : 100;
 }
 
 static int lis3lv02d_set_odr(int rate)
