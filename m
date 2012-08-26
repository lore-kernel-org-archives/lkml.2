Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2HZESP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 00:18:15 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:36030 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab2HZESM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 00:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120825214459.7333a376@notabene.brown>
References: <20120825214459.7333a376@notabene.brown>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sun, 26 Aug 2012 09:47:50 +0530
Message-ID: <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
To: NeilBrown <neilb@suse.de>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Cousson@suse.de,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>
Content-Type: multipart/mixed; boundary=e89a8f2356c93cff9d04c8237f6e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f2356c93cff9d04c8237f6e
Content-Type: text/plain; charset=ISO-8859-1

+ Jon,

On Sat, Aug 25, 2012 at 5:14 PM, NeilBrown <neilb@suse.de> wrote:
>
>
>
> Current kernel will wake from suspend on an event on any active
> GPIO even if enable_irq_wake() wasn't called.
>
> There are two reasons that the hardware wake-enable bit should be set:
>
> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>   in which the wake-enable bit is needed for an interrupt to be
>   recognised.
> 2/ while suspended the GPIO interrupt should wake from suspend if and
>    only if irq_wake as been enabled.
>
> The code currently doesn't keep these two reasons separate so they get
> confused and sometimes the wakeup flags is set incorrectly.
>
> This patch reverts:
>  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>     gpio/omap: remove suspend/resume callbacks
> and
>  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>
> and makes some minor changes so that we have separate flags for "GPIO
> should wake from deep idle" and "GPIO should wake from suspend".
>
> With this patch, the GPIO from my touch screen doesn't wake my device
> any more, which is what I want.
>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson, Benoit <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
The patch doesn't seems to be correct. At least the 2/ gets
fixed with a proper IRQCHIP flag. Can you try the patch at
end of the email and see if it helps ? Am attaching it in case
mailer damages it.

Regards
Santosh

>From b8a38fc75e046f6462610e26c47c620cad850c24 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Sun, 26 Aug 2012 09:39:51 +0530
Subject: [PATCH] gpio: omap: Set IRQCHIP_MASK_ON_SUSPEND to mask all
 non-wakeup gpio wakeups.

Set the irq chip flag IRQCHIP_MASK_ON_SUSPEND to cause the irq pm code
to mask all non-wake gpios in suspend, which will ensure the wakeup enable
bit is not set on non-wake gpios.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index e6efd77..50b4c18 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -779,6 +779,7 @@ static struct irq_chip gpio_irq_chip = {
 	.irq_unmask	= gpio_unmask_irq,
 	.irq_set_type	= gpio_irq_type,
 	.irq_set_wake	= gpio_wake_enable,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND;
 };

 /*---------------------------------------------------------------------*/
-- 
1.7.9.5

--e89a8f2356c93cff9d04c8237f6e
Content-Type: application/octet-stream; 
	name="0001-gpio-omap-Set-IRQCHIP_MASK_ON_SUSPEND-to-mask-all-no.patch"
Content-Disposition: attachment; 
	filename="0001-gpio-omap-Set-IRQCHIP_MASK_ON_SUSPEND-to-mask-all-no.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h6bmm9m70

RnJvbSBiOGEzOGZjNzVlMDQ2ZjY0NjI2MTBlMjZjNDdjNjIwY2FkODUwYzI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJA
dGkuY29tPgpEYXRlOiBTdW4sIDI2IEF1ZyAyMDEyIDA5OjM5OjUxICswNTMwClN1YmplY3Q6IFtQ
QVRDSF0gZ3Bpbzogb21hcDogU2V0IElSUUNISVBfTUFTS19PTl9TVVNQRU5EIHRvIG1hc2sgYWxs
CiBub24td2FrZXVwIGdwaW8gd2FrZXVwcy4KClNldCB0aGUgaXJxIGNoaXAgZmxhZyBJUlFDSElQ
X01BU0tfT05fU1VTUEVORCB0byBjYXVzZSB0aGUgaXJxIHBtIGNvZGUKdG8gbWFzayBhbGwgbm9u
LXdha2UgZ3Bpb3MgaW4gc3VzcGVuZCwgd2hpY2ggd2lsbCBlbnN1cmUgdGhlIHdha2V1cCBlbmFi
bGUKYml0IGlzIG5vdCBzZXQgb24gbm9uLXdha2UgZ3Bpb3MuCgpTaWduZWQtb2ZmLWJ5OiBTYW50
b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJAdGkuY29tPgotLS0KIGRyaXZlcnMvZ3Bp
by9ncGlvLW9tYXAuYyB8ICAgIDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncGlvL2dwaW8tb21hcC5jIGIvZHJpdmVycy9ncGlvL2dwaW8t
b21hcC5jCmluZGV4IGU2ZWZkNzcuLjUwYjRjMTggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3Bpby9n
cGlvLW9tYXAuYworKysgYi9kcml2ZXJzL2dwaW8vZ3Bpby1vbWFwLmMKQEAgLTc3OSw2ICs3Nzks
NyBAQCBzdGF0aWMgc3RydWN0IGlycV9jaGlwIGdwaW9faXJxX2NoaXAgPSB7CiAJLmlycV91bm1h
c2sJPSBncGlvX3VubWFza19pcnEsCiAJLmlycV9zZXRfdHlwZQk9IGdwaW9faXJxX3R5cGUsCiAJ
LmlycV9zZXRfd2FrZQk9IGdwaW9fd2FrZV9lbmFibGUsCisJLmZsYWdzCQk9IElSUUNISVBfTUFT
S19PTl9TVVNQRU5EOwogfTsKIAogLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLwotLSAKMS43LjkuNQoK
--e89a8f2356c93cff9d04c8237f6e--
