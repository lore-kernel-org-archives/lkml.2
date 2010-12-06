Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0LFSMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:12:06 -0500
Received: from mail.perches.com ([173.55.12.10]:2307 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab0LFSME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:12:04 -0500
Subject: Re: [PATCH 0/7] printk: add pr_<level>_once, guard print_hex_dump
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291649869.3065.2095.camel@calx>
References: <cover.1291611190.git.joe@perches.com>
	 <1291649869.3065.2095.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 10:12:00 -0800
Message-ID: <1291659120.17494.179.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 09:37 -0600, Matt Mackall wrote:
> On Sun, 2010-12-05 at 21:44 -0800, Joe Perches wrote:
> > There are many uses of printk_once(KERN_<level>.
> > Add pr_<level>_once macros to avoid printk_once(KERN_<level> pr_fmt(fmt).
> > Add an #ifdef CONFIG_PRINTK for print_hex_dump and static inline void
> > functions for the #else cases to reduce embedded code size.
> > Neaten and organize the rest of the code.
> Looks fine to me. I'd missed the introduction of the pr_<level> macros
> and I'm not sure if I like the idea, but this is a tidy and
> well-presented cleanup and extension.
> Acked-by: Matt Mackall <mpm@selenic.com>

The #ifdef CONFIG_PRINTK guard for print_hex_dump saves ~200
bytes in an x86 !CONFIG_PRINTK

There could be ~500 bytes more saved if hex_dump_to_buffer
was compiled out.

It's a more invasive change, so I didn't want to submit it
just now, but it could be something like below.

It requires the modules that use hex_dump_to_buffer, there
aren't many, to Kconfig select HEX_DUMP_TO_BUFFER so it's
not very pretty nor simple.

Thoughts?

---

 drivers/isdn/hardware/mISDN/Kconfig  |    2 +-
 drivers/media/video/hdpvr/Kconfig    |    1 +
 drivers/mfd/Kconfig                  |    1 +
 drivers/net/wireless/iwlwifi/Kconfig |    1 +
 drivers/scsi/osd/Kconfig             |    1 +
 include/linux/printk.h               |   14 ++++++++++++++
 init/Kconfig                         |    7 +++++++
 lib/Kconfig                          |    4 ++++
 lib/Kconfig.debug                    |    1 +
 lib/hexdump.c                        |    2 ++
 10 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index eadc1cd..243eadf 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -90,4 +90,4 @@ config MISDN_IPAC
 config MISDN_ISAR
 	tristate
 	depends on MISDN
-
+	select HEX_DUMP_TO_BUFFER
diff --git a/drivers/media/video/hdpvr/Kconfig b/drivers/media/video/hdpvr/Kconfig
index de247f3..851a45f 100644
--- a/drivers/media/video/hdpvr/Kconfig
+++ b/drivers/media/video/hdpvr/Kconfig
@@ -2,6 +2,7 @@
 config VIDEO_HDPVR
 	tristate "Hauppauge HD PVR support"
 	depends on VIDEO_DEV
+	select HEX_DUMP_TO_BUFFER
 	---help---
 	  This is a video4linux driver for Hauppauge's HD PVR USB device.
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a7b891..982b27a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -418,6 +418,7 @@ config MFD_WM8994
 config MFD_PCF50633
 	tristate "Support for NXP PCF50633"
 	depends on I2C
+	select HEX_DUMP_TO_BUFFER
 	help
 	  Say yes here if you have NXP PCF50633 chip on your board.
 	  This core driver provides register access and IRQ handling
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ed42457..4074fa0 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -2,6 +2,7 @@ config IWLWIFI
 	tristate "Intel Wireless Wifi"
 	depends on PCI && MAC80211
 	select FW_LOADER
+	select HEX_DUMP_TO_BUFFER
 
 menu "Debugging Options"
 	depends on IWLWIFI
diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
index 861b5ce..c43df39 100644
--- a/drivers/scsi/osd/Kconfig
+++ b/drivers/scsi/osd/Kconfig
@@ -18,6 +18,7 @@
 config SCSI_OSD_INITIATOR
 	tristate "OSD-Initiator library"
 	depends on SCSI
+	select HEX_DUMP_TO_BUFFER
 	help
 		Enable the OSD-Initiator library (libosd.ko).
 		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 41388e3..38d918d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -276,9 +276,23 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
+
+#ifdef CONFIG_HEX_DUMP_TO_BUFFER
 extern void hex_dump_to_buffer(const void *buf, size_t len,
 			       int rowsize, int groupsize,
 			       char *linebuf, size_t linebuflen, bool ascii);
+#else
+static inline
+void hex_dump_to_buffer(const void *buf, size_t len,
+			int rowsize, int groupsize,
+			char *linebuf, size_t linebuflen, bool ascii)
+{
+#ifndef CONFIG_EMBEDDED
+#error "Kconfig must select CONFIG_HEX_DUMP_TO_BUFFER"
+#endif
+}
+#endif
+
 #ifdef CONFIG_PRINTK
 extern void print_hex_dump(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
diff --git a/init/Kconfig b/init/Kconfig
index 3eb22ad..5ab5ad8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,6 +950,13 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config HEX_DUMP_TO_BUFFER
+       default y
+       bool "Enable support for hexdump" if EMBEDDED
+       help
+	  This option enables normal hex_dump support.
+	  Saying N here is strongly discouraged.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/lib/Kconfig b/lib/Kconfig
index 3d498b2..2c95d1c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -5,6 +5,10 @@
 config BINARY_PRINTF
 	def_bool n
 
+config HEX_DUMP_TO_BUFFER
+       bool
+       default n
+
 menu "Library routines"
 
 config RAID6_PQ
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 968d183..e3b0238 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -380,6 +380,7 @@ config DEBUG_KMEMLEAK
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
 	select CRC32
+	select HEX_DUMP_TO_BUFFER
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
diff --git a/lib/hexdump.c b/lib/hexdump.c
index f5fe6ba..88d70f4 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -49,6 +49,7 @@ void hex2bin(u8 *dst, const char *src, size_t count)
 }
 EXPORT_SYMBOL(hex2bin);
 
+#ifdef CONFIG_HEX_DUMP_TO_BUFFER
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
@@ -153,6 +154,7 @@ nil:
 	linebuf[lx++] = '\0';
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
+#endif
 
 #ifdef CONFIG_PRINTK
 /**


