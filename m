Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0IGCox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:44:53 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:56615 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755810Ab0IGCou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:44:50 -0400
Message-ID: <4C85A71F.3010402@bluewatersys.com>
Date: Tue, 07 Sep 2010 14:44:47 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, avictor.za@gmail.com
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
References: <280328.53116.qm@web180311.mail.gq1.yahoo.com>
In-Reply-To: <280328.53116.qm@web180311.mail.gq1.yahoo.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 02:23 PM, David Brownell wrote:
> Still not liking or accepting this proposed
> change to the GPIO framework.
>
> For the AT91 case (where integers 0..N are
> IRQs, but N..max are GPIOs)
>
> A simpler solution is just to use a bit in
> the integer to indicate IRQ vs GPIO.  Like
> maybe the sign bit.. which is never set on
> valid GPIO numbers, but platforms could let
> be set on IRQs.
>   
How about this approach instead?

----
On some architectures gpio numbering does not start from zero. Allow for
correct behaviour of gpio_is_valid on values below the first gpio by
adding the architecture overrideable ARCH_FIRST_GPIO.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
----

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c7376bf..01aab1f 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -22,10 +22,15 @@
 #define ARCH_NR_GPIOS		256
 #endif
 
+#ifndef ARCH_FIRST_GPIO
+#define ARCH_FIRST_GPIO		0
+#endif
+
 static inline int gpio_is_valid(int number)
 {
 	/* only some non-negative numbers are valid */
-	return ((unsigned)number) < ARCH_NR_GPIOS;
+	return (number >= ARCH_FIRST_GPIO &&
+		(unsigned)number < ARCH_NR_GPIOS;
 }
 
 struct device;


