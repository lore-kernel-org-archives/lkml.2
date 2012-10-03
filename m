Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2JCTMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2JCTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:12:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ARM: footbridge: nw_gpio_lock is raw_spin_lock
Date: Wed, 3 Oct 2012 19:12:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210031912.07343.arnd@arndb.de>
X-Provags-ID: V02:K0:L6TQJmJnZqFVjFHcCKvtoacQm9d9hyWyKk0SuUrc7da
 e9oBpaPk0P7FEjEahZoMKxKFLcFDzX4GdhqvG6EYE42C5qhWzm
 VKN0p6ramkc8DRnraWXsclW0yuyp3eyrhuF2C+W85t8LYPUfSm
 xticYuDakcEDZ5SMo0I6ukv/u6neFgeBjlTeXHxivIXhIwETDR
 Az8XyICsn+t70pnKBcngwVJU2eYEAl86RO2//Zjg7xBK1ErY7h
 LluDl9nZe8Jj6XvWbNUKq2/ofgpRR0gUwdmCFNTCy+yM303Dzr
 iQawEjVNTBVjbsiIhGQw+6u7B0ppcPQG9rtKAhqmJkKquq3KMg
 1XZvWkaTHUC8+QC4Uqzo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bd31b85960a "locking, ARM: Annotate low level hw locks as raw"
made nw_gpio_lock a raw spinlock, but did not change all the
users in device drivers. This fixes the remaining ones.

sound/oss/waveartist.c: In function 'vnc_mute_spkr':
sound/oss/waveartist.c:1485:2: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]
include/linux/spinlock.h:272:102: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'
drivers/char/ds1620.c: In function 'netwinder_lock':
drivers/char/ds1620.c:77:2: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]
include/linux/spinlock.h:272:102: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'
drivers/char/nwflash.c: In function 'kick_open':
drivers/char/nwflash.c:620:2: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type [enabled by default]
include/linux/spinlock.h:272:102: note: expected 'struct spinlock_t *' but argument is of type 'struct raw_spinlock_t *'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---

queued in the late/fixes branch, will submit later in the merge window
unless I hear objections.

diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index aab9605..24ffd8c 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -74,21 +74,21 @@ static inline void netwinder_ds1620_reset(void)
 
 static inline void netwinder_lock(unsigned long *flags)
 {
-	spin_lock_irqsave(&nw_gpio_lock, *flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, *flags);
 }
 
 static inline void netwinder_unlock(unsigned long *flags)
 {
-	spin_unlock_irqrestore(&nw_gpio_lock, *flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, *flags);
 }
 
 static inline void netwinder_set_fan(int i)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_gpio_modify_op(GPIO_FAN, i ? GPIO_FAN : 0);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 }
 
 static inline int netwinder_get_fan(void)
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index d45c334..04e2a94 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -617,9 +617,9 @@ static void kick_open(void)
 	 * we want to write a bit pattern XXX1 to Xilinx to enable
 	 * the write gate, which will be open for about the next 2ms.
 	 */
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_cpld_modify(CPLD_FLASH_WR_ENABLE, CPLD_FLASH_WR_ENABLE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 
 	/*
 	 * let the ISA bus to catch on...
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 24c430f..672af8b 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -1482,9 +1482,9 @@ vnc_mute_spkr(wavnc_info *devc)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_cpld_modify(CPLD_UNMUTE, devc->spkr_mute_state ? 0 : CPLD_UNMUTE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 }
 
 static void
