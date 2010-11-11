Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0KKKWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:22:43 -0500
Received: from borg.asidev.net ([95.141.38.199]:48888 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab0KKKWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:22:41 -0500
Message-ID: <4CDBC3EC.6020707@evidence.eu.com>
Date: Thu, 11 Nov 2010 11:22:36 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-serial@vger.kernel.org,
        Grant Edwards <grant.b.edwards@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation about RS485 serial communications
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4CBD8EE4.5040808@evidence.eu.com> <i9ka0s$4ua$1@dough.gmane.org> <201010191727.53314.alexander.stein@systec-electronic.com> <i9kk4o$svc$1@dough.gmane.org> <4CC418A9.6090602@evidence.eu.com> <4CDA630F.4060903@atmel.com> <20101110172842.GC12371@suse.de>
In-Reply-To: <20101110172842.GC12371@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH ha scritto:
> On Wed, Nov 10, 2010 at 10:17:03AM +0100, Nicolas Ferre wrote:
>> Le 24/10/2010 13:29, Claudio Scordino :
>>
>> [..]
>>
>>> Hi all,
>>>
>>> 	sorry for the misuse of the term "transceiver", and thank you
>>> for your corrections.
>>>
>>> Hopefully, this new version of the document is slightly better.
>> Hi all,
>>
>> This documentation is floating around for some time now. Claudio has
>> enhanced it and it is maybe time to merge it in mainline...
>>
>> So, can serial people include it in their tree (Greg?) or should it go
>> through another path?
> 
> I can take it, if someone resends it with the accumulated acks that I
> think it gathered over the review cycle.

Here it is.

Thanks,

	Claudio


Documentation about RS485 serial communications

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Russell King <linux@arm.linux.org.uk>
Acked-by: Grant Edwards <grant.b.edwards@gmail.com>
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
index 0000000..40f09c6
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
1.6.0.4


