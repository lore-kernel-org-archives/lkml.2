Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab2KWJpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:45:51 -0500
Received: from intranet.asianux.com ([58.214.24.6]:1665 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2KWJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:45:49 -0500
X-Spam-Score: -100.7
Message-ID: <50AF4603.2050107@asianux.com>
Date: Fri, 23 Nov 2012 17:46:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char: for hpet, add count checking, and ~0UL instead
 of -1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  use ~0UL for unsigned long variable initialization, instead of -1.

  add check for hdp->hd_nirqs within 32 (HPET_MAX_TIMERS).
    the type of irqp->interrupt_count is u8.
    the git diff not display the relative lines below.
      hdp->hd_irq[hdp->hd_nirqs] = irq;
      hdp->hd_nirqs++;
    please check source code to get more information.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/char/hpet.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index dfd7876..fe6d4be 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -816,7 +816,7 @@ static unsigned long __hpet_calibrate(struct hpets *hpetp)
 
 static unsigned long hpet_calibrate(struct hpets *hpetp)
 {
-	unsigned long ret = -1;
+	unsigned long ret = ~0UL;
 	unsigned long tmp;
 
 	/*
@@ -1001,6 +1001,9 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		irqp = &res->data.extended_irq;
 
 		for (i = 0; i < irqp->interrupt_count; i++) {
+			if (hdp->hd_nirqs >= HPET_MAX_TIMERS)
+				break;
+
 			irq = acpi_register_gsi(NULL, irqp->interrupts[i],
 				      irqp->triggering, irqp->polarity);
 			if (irq < 0)
-- 
1.7.10.4
