Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694Ab2DJXfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:35:37 -0400
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:26216 "HELO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756506Ab2DJXfg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:35:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 771568.67872.bm@omp1010.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yY/RhmA8o73DoCMEoYLemehKEhJ3Jgu6VDZqYFDOsbHG5tt/zON/HzfhwVkBeNtAbsSm7vUFFNMMT8B7rEXD1GsSBfVOpf/gz0vbuLzf7JkRtPb5mDcRKywlay6sPY0wjrmZ/8tn7+8W4LmIvjqPQenyTbIwc97e8AUE6hwQbUo=;
X-YMail-OSG: mzAnaf8VM1kv7W_XrFlOPFhW76OnQXm.goI15Vwkw3RmU3c
 CQxWumFxfhjTpDARWfyWZ0LUt62Q4l8C7O_0qAbMVNe_LuJKFVmK.aMd6Was
 N7cEFLTXSSzC66Y7fFFjr2fEvITW04AfwQ2SIf1osVJSefvWA4UAcD2vJkcD
 0gOTvxg5T0CAUkvHCi4Qj2.M91cQQDWS4MqPj39B9AEXsQeWNTuDiYz595wf
 myzdwZFxjC31Z3y7R0Y9m2JDl5oyq9RiFvgJLeWOR7SccytJ4r8gYODcntW3
 2oBnBwjAA4DMuJYX8vMDApjhaRV1DbHicbefZU_CvFCviHJWtKpw0e36LrDp
 laTT5xApqpdDvPYsSWeYr6tUAWiIqV6d22Wjpx1xfVKqp9BL.LT3dcFtPBKL
 p2sYpqokMNUqkAVuX_XN0HUfSIohzLoB1ZKvw9mYneg--
X-Mailer: YahooMailClassic/15.0.5 YahooMailWebService/0.8.117.340979
Message-ID: <1334100934.85623.YahooMailClassic@web29003.mail.ird.yahoo.com>
Date: Wed, 11 Apr 2012 00:35:34 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH v2] mfd: asic3: Avoid unbalanced irq wakeup enables/disables
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd/asic3 driver does not currently define a irq_set_wake() handler.
Consequently any attempt to configure the 3 ASIC3 GPIO buttons - RECORD,
CALENDAR, HOME - as wakeup sources results in Unbalanced IRQ warnings
when the system is woken from sleep mode:

WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
Unbalanced IRQ 342 wake disable
...
WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
Unbalanced IRQ 337 wake disable
...
WARNING: at kernel/irq/manage.c:520 irq_set_irq_wake+0xc4/0xf8()
Unbalanced IRQ 339 wake disable
...

This patch adds a irq_set_wake() handler to the mfd/asic3 driver.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---

V2:
This patch now adds asic3_gpio_irq_set_wake() to mfd/asic3 instead of
disabling the 3 ASIC3 GPIO buttons as wakeup sources in pxa/hx4700.
This patch now submitted to linux-kernel instead of linux-arm-kernel.
Rebased from linux-2.6.39-rc6 to linux-3.4-rc2.

 drivers/mfd/asic3.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 4bf02a8..f5a8b3a 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -353,12 +353,28 @@ static int asic3_gpio_irq_type(struct irq_data *data, unsigned int type)
 	return 0;
 }
 
+static int asic3_gpio_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct asic3 *asic = irq_data_get_irq_chip_data(data);
+	u32 bank, index;
+	u16 bit;
+
+	bank = asic3_irq_to_bank(asic, data->irq);
+	index = asic3_irq_to_index(asic, data->irq);
+	bit = 1<<index;
+
+	asic3_set_register(asic, bank + ASIC3_GPIO_SLEEP_MASK, bit, !on);
+
+	return 0;
+}
+
 static struct irq_chip asic3_gpio_irq_chip = {
 	.name		= "ASIC3-GPIO",
 	.irq_ack	= asic3_mask_gpio_irq,
 	.irq_mask	= asic3_mask_gpio_irq,
 	.irq_unmask	= asic3_unmask_gpio_irq,
 	.irq_set_type	= asic3_gpio_irq_type,
+	.irq_set_wake	= asic3_gpio_irq_set_wake,
 };
 
 static struct irq_chip asic3_irq_chip = {
-- 
1.7.3.4

