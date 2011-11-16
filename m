Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1KPTC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:02:57 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:33442 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1KPTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:02:56 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1321470059!45261771!124
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: basic_mmio_gpio: Add hook for simple debounce register
Date: Wed, 16 Nov 2011 12:02:15 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>, <jamie@jamieiles.com>,
        <cbouatmailru@gmail.com>, <akpm@linux-foundation.org>,
        <rmk+kernel@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201111161202.15485.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms using the basic memory-mapped GPIO library have
simple input debounce support that is enabled/disabled, per-input,
by setting/clearing bits in a control register. Add a hook in the
bgpio_chip structure to hold the void __iomem * for this register.

This register, and the gc.set_debounce callback should set by the
platform after calling bgpio_init() and before calling gpiochip_add().

	...
	err = bgpio_chip(bgc, ...);
	if (err)
		return err;

	bgc->reg_db = platform_debounce_reg;
	bgc->gc.set_debounce = platform_set_debounce_func;

	return gpiochip_add(&bgc->gc);
}

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <rmk+kernel@arm.linux.org.uk>

---

diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index feb91219..9bec937 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -35,6 +35,7 @@ struct bgpio_chip {
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
 	void __iomem *reg_dir;
+	void __iomem *reg_db;
 
 	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
