Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0IVL50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:57:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50634 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0IVL5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:57:25 -0400
From: <samu.p.onkalo@nokia.com>
To: <tiwai@suse.de>, <akpm@linux-foundation.org>
CC: <Eric.Piel@tremplin-utc.net>, <linux-kernel@vger.kernel.org>
Date: Wed, 22 Sep 2010 13:56:15 +0200
Subject: RE: [PATCH resent] lis3: Fix Oops with NULL platform data
Thread-Topic: [PATCH resent] lis3: Fix Oops with NULL platform data
Thread-Index: ActaSh5DD/ipiDLnQhWyMUCGFCcONgAAZLQA
Message-ID: <62697B07E9803846BC582181BD6FB6B831300D2218@NOK-EUMSG-02.mgdnok.nokia.com>
References: <s5htyli811o.wl%tiwai@suse.de>
In-Reply-To: <s5htyli811o.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Sep 2010 11:56:18.0559 (UTC) FILETIME=[2AB3A8F0:01CB5A4D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

>-----Original Message-----
>From: ext Takashi Iwai [mailto:tiwai@suse.de]
>Sent: 22 September, 2010 14:34
>To: Andrew Morton
>Cc: Onkalo Samu.P (Nokia-MS/Tampere); Éric Piel; linux-
>kernel@vger.kernel.org
>Subject: [PATCH resent] lis3: Fix Oops with NULL platform data
>
>The recent addition of threaded irq handler causes a NULL dereference
>when used with hp_accel driver, which has NULL pdata.
>
>Cc: <stable@kernel.org>
>Signed-off-by: Takashi Iwai <tiwai@suse.de>
>---
>
>This should go to 2.6.36 and 2.6.35-stable tree.
>
> drivers/hwmon/lis3lv02d.c |    6 ++++--
> 1 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
>index 5e15967..1c266ec 100644
>--- a/drivers/hwmon/lis3lv02d.c
>+++ b/drivers/hwmon/lis3lv02d.c
>@@ -354,7 +354,8 @@ static irqreturn_t lis302dl_interrupt_thread1_8b(int
>irq, void *data)
>
> 	struct lis3lv02d *lis3 = data;
>
>-	if ((lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
>+	if (lis3->pdata &&
>+	    (lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
> 		lis302dl_interrupt_handle_click(lis3);
> 	else
> 		lis302dl_interrupt_handle_ff_wu(lis3);
>@@ -367,7 +368,8 @@ static irqreturn_t lis302dl_interrupt_thread2_8b(int
>irq, void *data)
>
> 	struct lis3lv02d *lis3 = data;
>
>-	if ((lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
>+	if (lis3->pdata &&
>+	    (lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
> 		lis302dl_interrupt_handle_click(lis3);
> 	else
> 		lis302dl_interrupt_handle_ff_wu(lis3);

Yes, that will remove the kernel oops definitely, but I'm wondering if
this thread should be executed at all if there is no pdata available.
Eric, is it so that in laptops interrupts are used for free fall detection
and polled input device is for joystick?

Interrupts can (and are used) also for other purposes but in that case
some additional configurations are done based on platform data.

With this patch, there are just some additional input event refreshes in
top of polled device updates. It should really not matter. So,

Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>

-Samu



