Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab0GQPTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 11:19:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57072 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab0GQPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 11:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=noqXddp33QwYqmuyMjlNjWbTUHYDBNn1IpftvUsCwmZ5svoxNMl/f8DuTxQvyUqYaD
         S4ZHSfbuuusCMTeCgFWM5oheyNBufYcKCRpe0x+Il3ekkLuGRFIDdpM2hFrcgsFQpPF0
         hhaYsYPcY8HHtP7mcG/jt9g6J7/61sNyReHFQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] arm: mach-pnx4008: fix sign bug
Date: Sat, 17 Jul 2010 19:19:33 +0400
Message-Id: <1279379974-15192-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ret' is unsigned, so this code is wrong:

    ret = gpio_read_bit(...);
    ...
    if (ret > 0)

If gpio_read_bit() returns -EFAULT then (ret > 0) would be true.
Make 'ret' signed.


The semantic patch that finds this problem (many false-positive results):
(http://coccinelle.lip6.fr/)

// <smpl>
@ r1 @
identifier f;
@@
int f(...) { ... }

@@
identifier r1.f;
type T;
unsigned T x;
@@

*x = f(...)
 ...
*x > 0

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/arm/mach-pnx4008/gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pnx4008/gpio.c b/arch/arm/mach-pnx4008/gpio.c
index f219914..4a0c0eb 100644
--- a/arch/arm/mach-pnx4008/gpio.c
+++ b/arch/arm/mach-pnx4008/gpio.c
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(pnx4008_gpio_unregister_pin);
 
 unsigned long pnx4008_gpio_read_pin(unsigned short pin)
 {
-	unsigned long ret = -EFAULT;
+	int ret = -EFAULT;
 	int gpio = GPIO_BIT_MASK(pin);
 	gpio_lock();
 	if (GPIO_ISOUT(pin)) {
-- 
1.7.0.4

