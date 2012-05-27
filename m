Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2E0Bkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:40:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338Ab2E0BLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:33 -0400
Message-Id: <20120527010433.618389573@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:33 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Wucher <thwucher@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Felix Radensky <felix@embedded-sol.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 70/94] gpio: mpc8xxx: Prevent NULL pointer deref in demux handler
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit d6de85e85edcc38c9edcde45a0a568818fcddc13 upstream.

commit cfadd838(powerpc/8xxx: Fix interrupt handling in MPC8xxx GPIO
driver) added an unconditional call of chip->irq_eoi() to the demux
handler.

This leads to a NULL pointer derefernce on MPC512x platforms which use
this driver as well.

Make it conditional.

Reported-by: Thomas Wucher <thwucher@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Felix Radensky <felix@embedded-sol.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-mpc8xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -163,7 +163,8 @@ static void mpc8xxx_gpio_irq_cascade(uns
 	if (mask)
 		generic_handle_irq(irq_linear_revmap(mpc8xxx_gc->irq,
 						     32 - ffs(mask)));
-	chip->irq_eoi(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
 }
 
 static void mpc8xxx_irq_unmask(struct irq_data *d)


