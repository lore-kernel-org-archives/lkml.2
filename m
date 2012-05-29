Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2E2KGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:06:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47220 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab2E2KGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:06:23 -0400
Date: Tue, 29 May 2012 12:06:19 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        vamos-dev@lists.cs.fau.de
Subject: [PATCH] netwinder: nw_gpio_lock is a raw_spinlock_t
Message-ID: <20120529100619.GA23186@faui49q.informatik.uni-erlangen.de>
References: <1338040464.2525.38.camel@koala>
 <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338040464.2525.38.camel@koala>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nw_gpio_lock is a raw_spinlock_t it should be used with the
raw_spinlock_* functions and not the spinlock_* variants. Functionally
this is equivalent at the moment, because the raw_spinlock_t is the
first field of spinlock_t, and therefore &nw_gpio_lock ==
&(nw_gpio_lock->rlock). But when other spinlock_t functions use other
field they read and write random memory.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/char/ds1620.c      |    8 ++++----
 drivers/char/nwflash.c     |    4 ++--
 drivers/mtd/maps/dc21285.c |    4 ++--
 sound/oss/waveartist.c     |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index aab9605..7d86139 100644
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
+	netwinder_lock(&flags);
 	nw_gpio_modify_op(GPIO_FAN, i ? GPIO_FAN : 0);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	netwinder_unlock(&flags);
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
diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index 080f060..86598a1 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -38,9 +38,9 @@ static void nw_en_write(void)
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
-- 
1.7.5.4

