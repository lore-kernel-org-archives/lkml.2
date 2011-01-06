Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1AFWbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:31:37 -0500
Received: from kroah.org ([198.145.64.141]:55617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1AFWXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Claudio Scordino <claudio@evidence.eu.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/36] serial: add Documentation about RS485 serial communications
Date: Thu,  6 Jan 2011 14:22:54 -0800
Message-Id: <1294352605-31906-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>

Documentation about RS485 serial communications

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Russell King <linux@arm.linux.org.uk>
Acked-by: Grant Edwards <grant.b.edwards@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/serial/00-INDEX         |    2 +
 Documentation/serial/serial-rs485.txt |  119 +++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/serial/serial-rs485.txt

diff --git a/Documentation/serial/00-INDEX b/Documentation/serial/00-INDEX
index 07dcdb0..e09468a 100644
--- a/Documentation/serial/00-INDEX
+++ b/Documentation/serial/00-INDEX
@@ -14,6 +14,8 @@ riscom8.txt
 	- notes on using the RISCom/8 multi-port serial driver.
 rocket.txt
 	- info on the Comtrol RocketPort multiport serial driver.
+serial-rs485.txt
+	- info about RS485 structures and support in the kernel.
 specialix.txt
 	- info on hardware/driver for specialix IO8+ multiport serial card.
 stallion.txt
diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
new file mode 100644
index 0000000..a3b1af7
--- /dev/null
+++ b/Documentation/serial/serial-rs485.txt
@@ -0,0 +1,119 @@
+                        RS485 SERIAL COMMUNICATIONS
+
+1. INTRODUCTION
+
+   EIA-485, also known as TIA/EIA-485 or RS-485, is a standard defining the
+   electrical characteristics of drivers and receivers for use in balanced
+   digital multipoint systems.
+   This standard is widely used for communications in industrial automation
+   because it can be used effectively over long distances and in electrically
+   noisy environments.
+
+2. HARDWARE-RELATED CONSIDERATIONS
+
+   Some CPUs (e.g., Atmel AT91) contain a built-in half-duplex mode capable of
+   automatically controlling line direction by toggling RTS. That can used to
+   control external half-duplex hardware like an RS485 transceiver or any
+   RS232-connected half-duplex device like some modems.
+
+   For these microcontrollers, the Linux driver should be made capable of
+   working in both modes, and proper ioctls (see later) should be made
+   available at user-level to allow switching from one mode to the other, and
+   vice versa.
+
+3. DATA STRUCTURES ALREADY AVAILABLE IN THE KERNEL
+
+   The Linux kernel provides the serial_rs485 structure (see [1]) to handle
+   RS485 communications. This data structure is used to set and configure RS485
+   parameters in the platform data and in ioctls.
+
+   Any driver for devices capable of working both as RS232 and RS485 should
+   provide at least the following ioctls:
+
+    - TIOCSRS485 (typically associated with number 0x542F). This ioctl is used
+      to enable/disable RS485 mode from user-space
+
+    - TIOCGRS485 (typically associated with number 0x542E). This ioctl is used
+      to get RS485 mode from kernel-space (i.e., driver) to user-space.
+
+   In other words, the serial driver should contain a code similar to the next
+   one:
+
+	static struct uart_ops atmel_pops = {
+		/* ... */
+		.ioctl		= handle_ioctl,
+	};
+
+	static int handle_ioctl(struct uart_port *port,
+		unsigned int cmd,
+		unsigned long arg)
+	{
+		struct serial_rs485 rs485conf;
+
+		switch (cmd) {
+		case TIOCSRS485:
+			if (copy_from_user(&rs485conf,
+				(struct serial_rs485 *) arg,
+				sizeof(rs485conf)))
+					return -EFAULT;
+
+			/* ... */
+			break;
+
+		case TIOCGRS485:
+			if (copy_to_user((struct serial_rs485 *) arg,
+				...,
+				sizeof(rs485conf)))
+					return -EFAULT;
+			/* ... */
+			break;
+
+		/* ... */
+		}
+	}
+
+
+4. USAGE FROM USER-LEVEL
+
+   From user-level, RS485 configuration can be get/set using the previous
+   ioctls. For instance, to set RS485 you can use the following code:
+
+	#include <linux/serial.h>
+
+	/* Driver-specific ioctls: */
+	#define TIOCGRS485      0x542E
+	#define TIOCSRS485      0x542F
+
+	/* Open your specific device (e.g., /dev/mydevice): */
+	int fd = open ("/dev/mydevice", O_RDWR);
+	if (fd < 0) {
+		/* Error handling. See errno. */
+	}
+
+	struct serial_rs485 rs485conf;
+
+	/* Set RS485 mode: */
+	rs485conf.flags |= SER_RS485_ENABLED;
+
+	/* Set rts delay before send, if needed: */
+	rs485conf.flags |= SER_RS485_RTS_BEFORE_SEND;
+	rs485conf.delay_rts_before_send = ...;
+
+	/* Set rts delay after send, if needed: */
+	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
+	rs485conf.delay_rts_after_send = ...;
+
+	if (ioctl (fd, TIOCSRS485, &rs485conf) < 0) {
+		/* Error handling. See errno. */
+	}
+
+	/* Use read() and write() syscalls here... */
+
+	/* Close the device when finished: */
+	if (close (fd) < 0) {
+		/* Error handling. See errno. */
+	}
+
+5. REFERENCES
+
+ [1]	include/linux/serial.h
-- 
1.7.3.2

