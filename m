Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2HVK6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:58:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56697 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2HVK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:58:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: move the async flags from the serial code into the tty
 includes
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Aug 2012 12:15:37 +0100
Message-ID: <20120822111527.10022.69866.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

These are used with the tty_port flags which are tty generic so move the
flags into a more sensible place. This then makes it possible to add
helpers such as those suggested by Huang Shijie.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 include/linux/serial.h    |    2 +
 include/linux/tty.h       |    1 +
 include/linux/tty_flags.h |   78 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)
 create mode 100644 include/linux/tty_flags.h

diff --git a/include/linux/serial.h b/include/linux/serial.h
index 90e9f98..d63866d 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -15,6 +15,8 @@
 #ifdef __KERNEL__
 #include <asm/page.h>
 
+#include <linux/tty_flags.h>
+
 /*
  * Counters of the input lines (CTS, DSR, RI, CD) interrupts
  */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 69a787f..dbebd1e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -43,6 +43,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/tty_flags.h>
 
 
 
diff --git a/include/linux/tty_flags.h b/include/linux/tty_flags.h
new file mode 100644
index 0000000..eefcb48
--- /dev/null
+++ b/include/linux/tty_flags.h
@@ -0,0 +1,78 @@
+#ifndef _LINUX_TTY_FLAGS_H
+#define _LINUX_TTY_FLAGS_H
+
+/*
+ * Definitions for async_struct (and serial_struct) flags field also
+ * shared by the tty_port flags structures.
+ *
+ * Define ASYNCB_* for convenient use with {test,set,clear}_bit.
+ */
+#define ASYNCB_HUP_NOTIFY	 0 /* Notify getty on hangups and closes
+				    * on the callout port */
+#define ASYNCB_FOURPORT		 1 /* Set OU1, OUT2 per AST Fourport settings */
+#define ASYNCB_SAK		 2 /* Secure Attention Key (Orange book) */
+#define ASYNCB_SPLIT_TERMIOS	 3 /* Separate termios for dialin/callout */
+#define ASYNCB_SPD_HI		 4 /* Use 56000 instead of 38400 bps */
+#define ASYNCB_SPD_VHI		 5 /* Use 115200 instead of 38400 bps */
+#define ASYNCB_SKIP_TEST	 6 /* Skip UART test during autoconfiguration */
+#define ASYNCB_AUTO_IRQ		 7 /* Do automatic IRQ during
+				    * autoconfiguration */
+#define ASYNCB_SESSION_LOCKOUT	 8 /* Lock out cua opens based on session */
+#define ASYNCB_PGRP_LOCKOUT	 9 /* Lock out cua opens based on pgrp */
+#define ASYNCB_CALLOUT_NOHUP	10 /* Don't do hangups for cua device */
+#define ASYNCB_HARDPPS_CD	11 /* Call hardpps when CD goes high  */
+#define ASYNCB_SPD_SHI		12 /* Use 230400 instead of 38400 bps */
+#define ASYNCB_LOW_LATENCY	13 /* Request low latency behaviour */
+#define ASYNCB_BUGGY_UART	14 /* This is a buggy UART, skip some safety
+				    * checks.  Note: can be dangerous! */
+#define ASYNCB_AUTOPROBE	15 /* Port was autoprobed by PCI or PNP code */
+#define ASYNCB_LAST_USER	15
+
+/* Internal flags used only by kernel */
+#define ASYNCB_INITIALIZED	31 /* Serial port was initialized */
+#define ASYNCB_SUSPENDED	30 /* Serial port is suspended */
+#define ASYNCB_NORMAL_ACTIVE	29 /* Normal device is active */
+#define ASYNCB_BOOT_AUTOCONF	28 /* Autoconfigure port on bootup */
+#define ASYNCB_CLOSING		27 /* Serial port is closing */
+#define ASYNCB_CTS_FLOW		26 /* Do CTS flow control */
+#define ASYNCB_CHECK_CD		25 /* i.e., CLOCAL */
+#define ASYNCB_SHARE_IRQ	24 /* for multifunction cards, no longer used */
+#define ASYNCB_CONS_FLOW	23 /* flow control for console  */
+#define ASYNCB_FIRST_KERNEL	22
+
+#define ASYNC_HUP_NOTIFY	(1U << ASYNCB_HUP_NOTIFY)
+#define ASYNC_SUSPENDED		(1U << ASYNCB_SUSPENDED)
+#define ASYNC_FOURPORT		(1U << ASYNCB_FOURPORT)
+#define ASYNC_SAK		(1U << ASYNCB_SAK)
+#define ASYNC_SPLIT_TERMIOS	(1U << ASYNCB_SPLIT_TERMIOS)
+#define ASYNC_SPD_HI		(1U << ASYNCB_SPD_HI)
+#define ASYNC_SPD_VHI		(1U << ASYNCB_SPD_VHI)
+#define ASYNC_SKIP_TEST		(1U << ASYNCB_SKIP_TEST)
+#define ASYNC_AUTO_IRQ		(1U << ASYNCB_AUTO_IRQ)
+#define ASYNC_SESSION_LOCKOUT	(1U << ASYNCB_SESSION_LOCKOUT)
+#define ASYNC_PGRP_LOCKOUT	(1U << ASYNCB_PGRP_LOCKOUT)
+#define ASYNC_CALLOUT_NOHUP	(1U << ASYNCB_CALLOUT_NOHUP)
+#define ASYNC_HARDPPS_CD	(1U << ASYNCB_HARDPPS_CD)
+#define ASYNC_SPD_SHI		(1U << ASYNCB_SPD_SHI)
+#define ASYNC_LOW_LATENCY	(1U << ASYNCB_LOW_LATENCY)
+#define ASYNC_BUGGY_UART	(1U << ASYNCB_BUGGY_UART)
+#define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
+
+#define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
+#define ASYNC_USR_MASK		(ASYNC_SPD_MASK|ASYNC_CALLOUT_NOHUP| \
+		ASYNC_LOW_LATENCY)
+#define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
+#define ASYNC_SPD_WARP		(ASYNC_SPD_HI|ASYNC_SPD_SHI)
+#define ASYNC_SPD_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI|ASYNC_SPD_SHI)
+
+#define ASYNC_INITIALIZED	(1U << ASYNCB_INITIALIZED)
+#define ASYNC_NORMAL_ACTIVE	(1U << ASYNCB_NORMAL_ACTIVE)
+#define ASYNC_BOOT_AUTOCONF	(1U << ASYNCB_BOOT_AUTOCONF)
+#define ASYNC_CLOSING		(1U << ASYNCB_CLOSING)
+#define ASYNC_CTS_FLOW		(1U << ASYNCB_CTS_FLOW)
+#define ASYNC_CHECK_CD		(1U << ASYNCB_CHECK_CD)
+#define ASYNC_SHARE_IRQ		(1U << ASYNCB_SHARE_IRQ)
+#define ASYNC_CONS_FLOW		(1U << ASYNCB_CONS_FLOW)
+#define ASYNC_INTERNAL_FLAGS	(~((1U << ASYNCB_FIRST_KERNEL) - 1))
+
+#endif

