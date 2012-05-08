Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2EHQv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:51:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58250 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2EHQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:51:21 -0400
Message-ID: <1336495850.1179.41.camel@mop>
Subject: Re: [PATCH RESEND 2/3] kmsg: export printk records to the /dev/kmsg
 interface
From: Kay Sievers <kay@vrfy.org>
To: Greg Kroah-Hartmann <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Karel Zak <kzak@redhat.com>
Date: Tue, 08 May 2012 18:50:50 +0200
In-Reply-To: <20120508002830.GA2204@kroah.com>
References: <1336004981.4240.10.camel@mop> <20120508002830.GA2204@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 2:28 AM, Greg Kroah-Hartmann <greg@kroah.com> wrote:

> Can you add a file somwhere in Documentation (Documentatin/ABI?) that
> documents the file format for this file?

Something like that? Please let me know, what else might be useful here.

Thanks,
Kay


From: Kay Sievers <kay@vrfy.org>
Subject: kmsg - add Documentation/ABI/testing/dev-kmsg

Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 Documentation/ABI/testing/dev-kmsg |   90 +++++++++++++++++++++++++++++++++++++
 Documentation/devices.txt          |    3 -
 2 files changed, 92 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/Documentation/ABI/testing/dev-kmsg
@@ -0,0 +1,90 @@
+What:		/dev/kmsg
+Date:		Mai 2012
+KernelVersion:	3.4
+Contact:	Kay Sievers <kay@vrfy.org>
+Description:	The /dev/kmsg character device node provides userspace access
+		to the kernel's printk buffer.
+
+		Injecting messages:
+		Every write() to the opened device node places a log entry in
+		the kernel's printk buffer.
+
+		The logged line can be prefixed with a <N> syslog prefix, which
+		carries the syslog priority and facility. The single decimal
+		prefix number is composed of the 3 lowest bits being the syslog
+		priority and the higher bits the syslog facility number.
+
+		If no prefix is given, the priority number is the default kernel
+		log priority and the facility number is set to LOG_USER (1). It
+		is not possible to inject messages from userspace with the
+		facility number LOG_KERN (0), to make sure that the origin of
+		the messages can always be reliably determined.
+
+		Accessing the buffer:
+		Every read() from the opened device node receives one record
+		of the kernel's printk buffer.
+
+		The first read() directly following an open() always returns
+		first message in the buffer; there is no kernel-internal
+		persistent state; many readers can concurrently open the device
+		and read from it, without affecting other readers.
+
+		Every read() will receive the next available record. If no more
+		records are available read() will block, or if O_NONBLOCK is
+		used -EAGAIN returned.
+
+		Messages in the record ring buffer get overwritten as whole,
+		there are never partial messages received by read().
+
+		In case messages get overwritten in the circular buffer while
+		the device is kept open, the next read() will return -EPIPE,
+		and the seek position be updated to the next available record.
+		Subsequent reads() will return available records again.
+
+		Unlike the classic syslog() interface, the 64 bit record
+		sequence numbers allow to calculate the amount of lost
+		messages, in case the buffer gets overwritten. And they allow
+		to reconnect to the buffer and reconstruct the read position
+		if needed, without limiting the interface to a single reader.
+
+		The device supports seek with the following parameters:
+		SEEK_SET, 0
+		  seek to the first entry in the buffer
+		SEEK_END, 0
+		  seek after the last entry in the buffer
+		SEEK_DATA, 0
+		  seek after the last record available at the time
+		  the last SYSLOG_ACTION_CLEAR was issued.
+
+		The output format consists of a prefix carrying the syslog
+		prefix including priority and facility, the 64 bit message
+		sequence number and the monotonic timestamp in microseconds.
+		The values are separated by a ','. Future extensions might
+		add more comma separated values before the terminating ';'.
+		Unknown values should be gracefully ignored.
+
+		The human readable text string starts directly after the ';'
+		and is terminated by a '\n'. Untrusted values derived from
+		hardware or other facilities are printed, therefore
+		all non-printable characters in the log message are escaped
+		by "\x00" C-style hex encoding.
+
+		A line starting with ' ', is a continuation line, adding
+		key/value pairs to the log message, which provide the machine
+		readable context of the message, for reliable processing in
+		userspace.
+
+		Example:
+		7,160,424069;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
+		 SUBSYSTEM=acpi
+		 DEVICE=+acpi:PNP0A03:00
+		6,339,5140900;NET: Registered protocol family 10
+		30,340,5690716;udevd[80]: starting version 181
+
+		The DEVICE= key uniquely identifies devices the following way:
+		  b12:8        - block dev_t
+		  c127:3       - char dev_t
+		  n8           - netdev ifindex
+		  + sound:card0 - subsystem:devname
+
+Users:		dmesg(1), userspace kernel log consumers
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -98,7 +98,8 @@ Your cooperation is appreciated.
 		  8 = /dev/random	Nondeterministic random number gen.
 		  9 = /dev/urandom	Faster, less secure random number gen.
 		 10 = /dev/aio		Asynchronous I/O notification interface
-		 11 = /dev/kmsg		Writes to this come out as printk's
+		 11 = /dev/kmsg		Writes to this come out as printk's, reads
+					export the buffered printk records.
 		 12 = /dev/oldmem	Used by crashdump kernels to access
 					the memory of the kernel that crashed.
 

