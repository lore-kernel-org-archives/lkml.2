Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2EaKPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:15:41 -0400
Received: from mailgate.zerties.org ([176.9.120.153]:38061 "EHLO
	gandalf.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab2EaKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:15:37 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 06:15:36 EDT
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: dedekind1@gmail.com
Cc: Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        vamos-dev@lists.cs.fau.de,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        Artem Bityutskiy <dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        vamos-dev@lists.cs.fau.de
Subject: [PATCH] netwinder: encapsulate CPLD hardware locking and access
References: <1338040464.2525.38.camel@koala>
	<20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
	<20120529100619.GA23186@faui49q.informatik.uni-erlangen.de>
	<1338040464.2525.38.camel@koala>
	<20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
	<20120529100619.GA23186@faui49q.informatik.uni-erlangen.de>
	<1338286268.11518.157.camel@shinybook.infradead.org>
	<1338040464.2525.38.camel@koala>
	<20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
	<20120529100619.GA23186@faui49q.informatik.uni-erlangen.de>
	<1338286268.11518.157.camel@shinybook.infradead.org>
Date: Thu, 31 May 2012 12:15:22 +0200
In-Reply-To: <1338286268.11518.157.camel@shinybook.infradead.org> (David
	Woodhouse's message of "Tue, 29 May 2012 11:11:08 +0100, Tue, 29 May 2012
	13:24:47 +0300, Tue, 29 May 2012 11:52:32 +0100")
Message-ID: <86d35k7j2d.fsf_-_@gandalf.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to not use the raw_spinlock_t nw_gpio_lock all over the
kernel, the locking of the GPIO ports is done by using the
nw_gpio_{un,}lock functions.

The write-gate is only open for about 2ms after it was
enabled. Therefore it is necessary to disable the preemption during a
series of writes to prevent the kernel from preempting the writing
task. The nw_cpld_enable_write function opens the write gate and
disables preemption, and the nw_cpld_disable_write function enables
the preemption again, the write gate closes automatically.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 arch/arm/mach-footbridge/include/mach/hardware.h |   19 ++++-
 arch/arm/mach-footbridge/netwinder-hw.c          |   53 +++++++++++--
 arch/arm/mach-footbridge/netwinder-leds.c        |    4 +-
 drivers/char/ds1620.c                            |   21 ++----
 drivers/char/nwflash.c                           |   95 ++++++++++++++-------
 drivers/mtd/maps/dc21285.c                       |   46 ++++-------
 sound/oss/waveartist.c                           |    4 +-
 7 files changed, 153 insertions(+), 89 deletions(-)

David Woodhouse <dwmw2@infradead.org> writes:

> Hm, why are we exposing a raw spinlock to drivers? 
>
> Should we export a helper function (or macro, I suppose) which does the
> appropriate locking *and* the GPIO operation?

The locking shouldn't be put into every modification operation, because
sometimes operations are supposed to be done in the same critical
region. The DS1620 driver is such an example.

> If you were to make these functions public by shifting them into
> arch/arm/mach-footbridge/include/mach/hardware.h that would be a lot
> nicer, and other places wouldn't have to touch the raw spinlock
> directly.

I put locking primitives into the mentioned header file. I didn't make
the nw_gpio_lock module static, since i don't know it there is any third
party code touching this gpio lock, and i didn't want to break the API.

> Also... while we're thinking about preemption and netwinder, note that
> the write enable is valid for only 2ms or so. So all the functions in
> dc21285.c that you just touched should probably *also* be disabling
> preemption when they're run on a netwinder, to ensure that that time
> doesn't expire before they actually get to run.

I hope my draft of the preemption disabling is not to much crap. I would
appreciate some comments. And please be aware, that i don't own this
hardware, and haven't tested it on real hardware therefore.

diff --git a/arch/arm/mach-footbridge/include/mach/hardware.h b/arch/arm/mach-footbridge/include/mach/hardware.h
index e3d6cca..642d5c4 100644
--- a/arch/arm/mach-footbridge/include/mach/hardware.h
+++ b/arch/arm/mach-footbridge/include/mach/hardware.h
@@ -93,11 +93,28 @@
 #define CPLD_FLASH_WR_ENABLE	1
 
 #ifndef __ASSEMBLY__
+#ifdef CONFIG_ARCH_NETWINDER
 extern raw_spinlock_t nw_gpio_lock;
 extern void nw_gpio_modify_op(unsigned int mask, unsigned int set);
 extern void nw_gpio_modify_io(unsigned int mask, unsigned int in);
 extern unsigned int nw_gpio_read(void);
 extern void nw_cpld_modify(unsigned int mask, unsigned int set);
-#endif
+extern void nw_cpld_enable_write(void);
+extern void nw_cpld_disable_write(void);
+
+static inline void nw_cpld_lock(unsigned long *flags)
+{
+	raw_spin_lock_irqsave(&nw_gpio_lock, *flags);
+}
+
+static inline void nw_cpld_unlock(unsigned long *flags)
+{
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, *flags);
+}
 
+#else
+#define nw_cpld_enable_write() do {} while(0)
+#define nw_cpld_disable_write() do {} while(0)
+#endif
+#endif
 #endif
diff --git a/arch/arm/mach-footbridge/netwinder-hw.c b/arch/arm/mach-footbridge/netwinder-hw.c
index cac9f67..380f763 100644
--- a/arch/arm/mach-footbridge/netwinder-hw.c
+++ b/arch/arm/mach-footbridge/netwinder-hw.c
@@ -328,9 +328,9 @@ static inline void wb977_init_gpio(void)
 	/*
 	 * Set Group1/Group2 outputs
 	 */
-	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
+	nw_cpld_lock(&flags);
 	nw_gpio_modify_op(-1, GPIO_RED_LED | GPIO_FAN);
-	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	nw_cpld_unlock(&flags);
 }
 
 /*
@@ -387,13 +387,54 @@ void nw_cpld_modify(unsigned int mask, unsigned int set)
 }
 EXPORT_SYMBOL(nw_cpld_modify);
 
+/*
+ * This is really ugly, but it seams to be the only
+ * realiable way to do it, as the cpld state machine
+ * is unpredictible. So we have a 25us penalty per
+ * write access.
+ */
+void nw_cpld_enable_write(void)
+{
+	unsigned long flags;
+
+	/*
+	 * we want to write a bit pattern XXX1 to Xilinx to enable
+	 * the write gate, which will be open for about the next 2ms.
+	 * Because the write gate is just opened for 2ms, it is
+	 * necessary to prevent the kernel from preempting this
+	 * task.
+	 */
+	nw_cpld_lock(&flags);
+
+	/* Increment the preempt counter after we got the lock */
+	preempt_disable();
+
+	nw_cpld_modify(CPLD_FLASH_WR_ENABLE, CPLD_FLASH_WR_ENABLE);
+	nw_cpld_unlock(&flags);
+
+	/*
+	 * let the ISA bus to catch on...
+	 */
+	udelay(25);
+}
+
+void nw_cpld_disable_write(void)
+{
+	/* Since we disabled preemption in nw_cpld_enable_write, we
+	 * have to enable it again after the critical write section. The
+	 * hardware will close the write gate automatically after 2ms.
+	 */
+	preempt_enable();
+}
+
+
 static void __init cpld_init(void)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
+	nw_cpld_lock(&flags);
 	nw_cpld_modify(-1, CPLD_UNMUTE | CPLD_7111_DISABLE);
-	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	nw_cpld_unlock(&flags);
 }
 
 static unsigned char rwa_unlock[] __initdata =
@@ -617,9 +658,9 @@ static int __init nw_hw_init(void)
 		cpld_init();
 		rwa010_init();
 
-		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
+		nw_cpld_lock(&flags);
 		nw_gpio_modify_op(GPIO_RED_LED|GPIO_GREEN_LED, DEFAULT_LEDS);
-		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
+		nw_cpld_unlock(&flags);
 	}
 	return 0;
 }
diff --git a/arch/arm/mach-footbridge/netwinder-leds.c b/arch/arm/mach-footbridge/netwinder-leds.c
index 5a2bd89..61e6282 100644
--- a/arch/arm/mach-footbridge/netwinder-leds.c
+++ b/arch/arm/mach-footbridge/netwinder-leds.c
@@ -119,9 +119,9 @@ static void netwinder_leds_event(led_event_t evt)
 	raw_spin_unlock_irqrestore(&leds_lock, flags);
 
 	if  (led_state & LED_STATE_ENABLED) {
-		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
+		nw_cpld_lock(&flags);
 		nw_gpio_modify_op(GPIO_RED_LED | GPIO_GREEN_LED, hw_led_state);
-		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
+		nw_cpld_unlock(&flags);
 	}
 }
 
diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index aab9605..d302ea5 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -72,23 +72,14 @@ static inline void netwinder_ds1620_reset(void)
 	nw_cpld_modify(CPLD_DS_ENABLE, CPLD_DS_ENABLE);
 }
 
-static inline void netwinder_lock(unsigned long *flags)
-{
-	spin_lock_irqsave(&nw_gpio_lock, *flags);
-}
-
-static inline void netwinder_unlock(unsigned long *flags)
-{
-	spin_unlock_irqrestore(&nw_gpio_lock, *flags);
-}
 
 static inline void netwinder_set_fan(int i)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	nw_cpld_lock(&flags);
 	nw_gpio_modify_op(GPIO_FAN, i ? GPIO_FAN : 0);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	nw_cpld_unlock(&flags);
 }
 
 static inline int netwinder_get_fan(void)
@@ -145,7 +136,7 @@ static void ds1620_out(int cmd, int bits, int value)
 {
 	unsigned long flags;
 
-	netwinder_lock(&flags);
+	nw_cpld_lock(&flags);
 	netwinder_ds1620_set_clk(1);
 	netwinder_ds1620_set_data_dir(0);
 	netwinder_ds1620_reset();
@@ -159,7 +150,7 @@ static void ds1620_out(int cmd, int bits, int value)
 	udelay(1);
 
 	netwinder_ds1620_reset();
-	netwinder_unlock(&flags);
+	nw_cpld_unlock(&flags);
 
 	msleep(20);
 }
@@ -169,7 +160,7 @@ static unsigned int ds1620_in(int cmd, int bits)
 	unsigned long flags;
 	unsigned int value;
 
-	netwinder_lock(&flags);
+	nw_cpld_lock(&flags);
 	netwinder_ds1620_set_clk(1);
 	netwinder_ds1620_set_data_dir(0);
 	netwinder_ds1620_reset();
@@ -182,7 +173,7 @@ static unsigned int ds1620_in(int cmd, int bits)
 	value = ds1620_recv_bits(bits);
 
 	netwinder_ds1620_reset();
-	netwinder_unlock(&flags);
+	nw_cpld_unlock(&flags);
 
 	return value;
 }
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index d45c334..f007eec 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -40,7 +40,6 @@
 #define	NWFLASH_VERSION "6.4"
 
 static DEFINE_MUTEX(flash_mutex);
-static void kick_open(void);
 static int get_flash_id(void);
 static int erase_block(int nBlock);
 static int write_block(unsigned long p, const char __user *buf, int count);
@@ -65,7 +64,7 @@ static int get_flash_id(void)
 	/*
 	 * try to get flash chip ID
 	 */
-	kick_open();
+	nw_cpld_enable_write();
 	c2 = inb(0x80);
 	*(volatile unsigned char *) (FLASH_BASE + 0x8000) = 0x90;
 	udelay(15);
@@ -90,6 +89,8 @@ static int get_flash_id(void)
 	if (c2 == KFLASH_ID4)
 		gbFlashSize = KFLASH_SIZE4;
 
+	nw_cpld_disable_write();
+
 	return c2;
 }
 
@@ -167,7 +168,7 @@ static ssize_t flash_write(struct file *file, const char __user *buf,
 
 	if (count > gbFlashSize - p)
 		count = gbFlashSize - p;
-			
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 
@@ -348,7 +349,12 @@ static int erase_block(int nBlock)
 	 */
 	c1 = *(volatile unsigned char *) (FLASH_BASE + 0x8000);
 
-	kick_open();
+	/*
+	 * Enable the write gate and disable preemption. The write
+	 * gate is open for 2ms.
+	 */
+	nw_cpld_enable_write();
+
 	/*
 	 * reset status if old errors
 	 */
@@ -364,7 +370,6 @@ static int erase_block(int nBlock)
 	 */
 	c1 = *pWritePtr;
 
-	kick_open();
 	/*
 	 * erase
 	 */
@@ -376,6 +381,11 @@ static int erase_block(int nBlock)
 	*(volatile unsigned char *) pWritePtr = 0xD0;
 
 	/*
+	 * Reenable preemption again, before we go to sleep
+	 */
+	nw_cpld_disable_write();
+
+	/*
 	 * wait 10 ms
 	 */
 	msleep(10);
@@ -395,9 +405,14 @@ static int erase_block(int nBlock)
 	}
 
 	/*
+	 * Enable the write gate and disable preemption. The write
+	 * gate is open for 2ms.
+	 */
+	nw_cpld_enable_write();
+
+	/*
 	 * set flash for normal read access
 	 */
-	kick_open();
 //      *(volatile unsigned char*)(FLASH_BASE+0x8000) = 0xFF;
 	*(volatile unsigned char *) pWritePtr = 0xFF;	//back to normal operation
 
@@ -415,6 +430,11 @@ static int erase_block(int nBlock)
 	}
 
 	/*
+	 * Reenable preemption again, before we go to sleep
+	 */
+	nw_cpld_disable_write();
+
+	/*
 	 * just to make sure - verify if erased OK...
 	 */
 	msleep(10);
@@ -480,9 +500,10 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 		c1 = *(volatile unsigned char *) (FLASH_BASE + 0x8000);
 
 		/*
-		 * kick open the write gate
+		 * Enable the write gate and disable preemption. The write
+		 * gate is open for 2ms.
 		 */
-		kick_open();
+		nw_cpld_enable_write();
 
 		/*
 		 * program footbridge to the correct offset...0..3
@@ -504,8 +525,12 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 		 */
 		*(volatile unsigned char *) (FLASH_BASE + 0x10000) = 0x70;
 
-		c1 = 0;
+		/*
+		 * Reenable preemption again, before we go to sleep
+		 */
+		nw_cpld_disable_write();
 
+		c1 = 0;
 		/*
 		 * wait up to 1 sec for this byte
 		 */
@@ -521,35 +546,55 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 		 * if timeout getting status
 		 */
 		if (time_after_eq(jiffies, timeout1)) {
-			kick_open();
+			/*
+			 * Enable the write gate and disable preemption. The write
+			 * gate is open for 2ms.
+			 */
+			nw_cpld_enable_write();
+
 			/*
 			 * reset err
 			 */
 			*(volatile unsigned char *) (FLASH_BASE + 0x8000) = 0x50;
 
+			/*
+			 * Reenable preemption again, before we go to sleep
+			 */
+			nw_cpld_disable_write();
+
+
 			goto WriteRetry;
 		}
 		/*
 		 * switch on read access, as a default flash operation mode
 		 */
-		kick_open();
+		/*
+		 * Enable the write gate and disable preemption. The write
+		 * gate is open for 2ms.
+		 */
+		nw_cpld_enable_write();
+
 		/*
 		 * read access
 		 */
 		*(volatile unsigned char *) (FLASH_BASE + 0x8000) = 0xFF;
 
 		/*
-		 * if hardware reports an error writing, and not timeout - 
+		 * if hardware reports an error writing, and not timeout -
 		 * reset the chip and retry
 		 */
 		if (c1 & 0x10) {
-			kick_open();
 			/*
 			 * reset err
 			 */
 			*(volatile unsigned char *) (FLASH_BASE + 0x8000) = 0x50;
 
 			/*
+			 * Reenable preemption again, before we go to sleep
+			 */
+			nw_cpld_disable_write();
+
+			/*
 			 * before timeout?
 			 */
 			if (time_before(jiffies, timeout)) {
@@ -580,6 +625,11 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 				return -2;
 
 			}
+		} else {
+			/*
+			 * Reenable preemption again, before we go to sleep
+			 */
+			nw_cpld_disable_write();
 		}
 	}
 
@@ -608,25 +658,6 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 	return count;
 }
 
-
-static void kick_open(void)
-{
-	unsigned long flags;
-
-	/*
-	 * we want to write a bit pattern XXX1 to Xilinx to enable
-	 * the write gate, which will be open for about the next 2ms.
-	 */
-	spin_lock_irqsave(&nw_gpio_lock, flags);
-	nw_cpld_modify(CPLD_FLASH_WR_ENABLE, CPLD_FLASH_WR_ENABLE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
-
-	/*
-	 * let the ISA bus to catch on...
-	 */
-	udelay(25);
-}
-
 static const struct file_operations flash_fops =
 {
 	.owner		= THIS_MODULE,
diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index 080f060..9414ceb 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -23,34 +23,6 @@
 
 static struct mtd_info *dc21285_mtd;
 
-#ifdef CONFIG_ARCH_NETWINDER
-/*
- * This is really ugly, but it seams to be the only
- * realiable way to do it, as the cpld state machine
- * is unpredictible. So we have a 25us penalty per
- * write access.
- */
-static void nw_en_write(void)
-{
-	unsigned long flags;
-
-	/*
-	 * we want to write a bit pattern XXX1 to Xilinx to enable
-	 * the write gate, which will be open for about the next 2ms.
-	 */
-	spin_lock_irqsave(&nw_gpio_lock, flags);
-	nw_cpld_modify(CPLD_FLASH_WR_ENABLE, CPLD_FLASH_WR_ENABLE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
-
-	/*
-	 * let the ISA bus to catch on...
-	 */
-	udelay(25);
-}
-#else
-#define nw_en_write() do { } while (0)
-#endif
-
 static map_word dc21285_read8(struct map_info *map, unsigned long ofs)
 {
 	map_word val;
@@ -80,26 +52,38 @@ static void dc21285_copy_from(struct map_info *map, void *to, unsigned long from
 static void dc21285_write8(struct map_info *map, const map_word d, unsigned long adr)
 {
 	if (machine_is_netwinder())
-		nw_en_write();
+		nw_cpld_enable_write();
+
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint8_t*)(map->virt + adr) = d.x[0];
+
+	if (machine_is_netwinder())
+		nw_cpld_disable_write();
 }
 
 static void dc21285_write16(struct map_info *map, const map_word d, unsigned long adr)
 {
 	if (machine_is_netwinder())
-		nw_en_write();
+		nw_cpld_enable_write();
+
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint16_t*)(map->virt + adr) = d.x[0];
+
+	if (machine_is_netwinder())
+		nw_cpld_disable_write();
 }
 
 static void dc21285_write32(struct map_info *map, const map_word d, unsigned long adr)
 {
 	if (machine_is_netwinder())
-		nw_en_write();
+		nw_cpld_enable_write();
+
 	*(uint32_t*)(map->virt + adr) = d.x[0];
+
+	if (machine_is_netwinder())
+		nw_cpld_disable_write();
 }
 
 static void dc21285_copy_to_32(struct map_info *map, unsigned long to, const void *from, ssize_t len)
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 24c430f..efb6438 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -1482,9 +1482,9 @@ vnc_mute_spkr(wavnc_info *devc)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	nw_cpld_lock(&flags);
 	nw_cpld_modify(CPLD_UNMUTE, devc->spkr_mute_state ? 0 : CPLD_UNMUTE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	nw_cpld_unlock(&flags);
 }
 
 static void
-- 
1.7.5.4
