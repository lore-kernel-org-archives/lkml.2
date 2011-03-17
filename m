Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1CQJkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:40:04 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:33663 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab1CQJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:39:42 -0400
From: <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rostedt@goodmis.org>, <STEricsson_nomadik_linux@list.st.com>,
        <pierre.peiffer@stericsson.com>, <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 1/3] STM: MIPI System Trace Module char driver
Date: Thu, 17 Mar 2011 10:36:52 +0100
Message-ID: <1300354614-24056-2-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
References: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 Documentation/trace/stm-trace.txt |  193 +++++++++
 drivers/misc/Kconfig              |    1 +
 drivers/misc/Kconfig.stm          |  114 ++++++
 drivers/misc/Makefile             |    1 +
 drivers/misc/stm.c                |  797 +++++++++++++++++++++++++++++++++++++
 include/Kbuild                    |    1 +
 include/trace/Kbuild              |    1 +
 include/trace/stm.h               |  223 +++++++++++
 8 files changed, 1331 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/stm-trace.txt
 create mode 100644 drivers/misc/Kconfig.stm
 create mode 100644 drivers/misc/stm.c
 create mode 100644 include/trace/Kbuild
 create mode 100644 include/trace/stm.h

diff --git a/Documentation/trace/stm-trace.txt b/Documentation/trace/stm-trace.txt
new file mode 100644
index 0000000..4d916bc
--- /dev/null
+++ b/Documentation/trace/stm-trace.txt
@@ -0,0 +1,193 @@
+		MIPI System Trace Module driver
+		===============================
+
+Copyright (C) ST-Ericsson SA 2011
+  Authors:   Pierre Peiffer <pierre dot peiffer at stericsson dot com>
+             Philippe Langlais <philippe dot langlais at linaro dot org>
+  License:   The GNU Free Documentation License, Version 1.2
+               (dual licensed under the GPL v2)
+
+Hardware overview
+=================
+  This hardware collects and provides simple tracepoints,
+  so a system processor (in our case the main ARM CPU,
+  or some small CPUs and DSPs) can write some data,
+  up to 8 bytes, into a register and out comes a log entry
+  with a time stamp (20ns resolution) on one of 256 channels. Also
+  hardware tracepoints are supported.
+
+  This module external interface is a pad on the chip
+  which complies to the MIPI System Trace Protocol v1.0
+  (see http://www.mipi.org/specifications/debug)
+  and the actual trace output can be read by an
+  electronic probe, not by software so it cannot be intercepted by
+  the CPU and reach Linux userspace.
+
+  Bandwidth depends on number of lines & bus frequency (for example on ux500
+  SoC 4 lines at max 100MHz eg max 400Mbit/s shared between 7 cores).
+  Transmit FIFO size: 256 samples up to 8 bytes.
+  On ux500 platform there is 2 contiguous STM blocks (eg 512 channels)
+
+Software Overview
+=================
+  Write atomicity and write order on STM trace channels is ensured by the fact
+  we try to allocate one channel by execution thread (no concurrent access).
+  There is 2 modes one lossless but intrusive aka Software mode and
+  another lossy mode less intrusive aka Hardware mode, by default
+  all sources are configured in Hardware mode and enabled.
+  The end of data packet is marked by a time stamp on latest byte(s) only.
+
+Kernel API
+----------
+  Configuration functions:
+    output trace clock frequency, trace mode, output port configuration
+    and enable/disable STM trace sources
+    Expose a debugfs interface too for STM trace control
+
+  Alloc/free STM trace channel functions
+
+  Set of low level atomic trace functions for 1, 2, 4 or 8 bytes
+  with & w/o time stamp
+
+  Higher level lockless trace functions:
+  stm_trace_buffer:
+     allocate a channel in 128 highest channels available
+     output the trace buffer with arbitrary length
+     (latest byte(s) automatically time stamped) then free the channel
+  stm_trace_buffer_onchannel:
+     use given channel to output the trace buffer
+     with arbitrary length (latest byte(s) automatically time stamped)
+
+  File IO output console like interface (open, close, write)
+
+  See <trace/stm.h> & drivers/misc/stm.c for more detail
+
+debugfs API
+-----------
+clockdiv:
+	This is used to set or display the current clock divisor
+	that is configured
+
+connection:
+	This is used to set or display the current output connector
+	that is configured (common values, 0 not connected, 1 for default
+	connection, 3 on Ux500 for APE MIPI34 connection)
+
+free_channels:
+	This is used to display the total number of free channels
+
+masters_enable:
+	This sets or displays whether the STM trace sources
+	are activated. Each bits represent the state of corresponding source:
+	0 for disable or 1 to enable it.
+
+masters_modes:
+	This sets or displays the STM trace sources modes.
+	Each bits represent the mode of corresponding source:
+	0 for Sofware lossless mode or 1 for Hardware lossy mode.
+
+User API
+--------
+  IOCTLs or debugfs for controls
+  2 levels API for tracing:
+     - Standard write function, in this case a channel is automatically
+       allocated at first write, after you can channel number
+       with IOCTL STM_GET_CHANNEL_NO
+     - mmap for direct access of all STM trace channels port plus
+       a set of IOCTLs for alloc/free channels, in this case you can
+       write your own lib to easiest its usage
+
+Examples of using the STM
+=========================
+First mount debugfs with:
+mount -t debugfs none /sys/kernel/debug
+
+In a shell scipt
+----------------
+It's as easy as:
+  echo "My trace point" > /dev/stm0
+
+To avoid trace overflow, increase STM clock by decreasing the clockdiv with:
+  echo 1 >/sys/kernel/debug/stm/clockdiv  # now use DIV2 instead of default DIV8
+If not enough you can disable some sources with:
+  echo YourEnableSources > /sys/kernel/debug/stm/masters_enable
+If always not enough the ultime intrusive way is to change the sources mode
+and set the corresponding sources in Software mode (set corresponding source
+bit to 0) with:
+  echo YourModeSources > /sys/kernel/debug/stm/masters_modes
+  (be aware some source doesn't support Software mode => keep it in HW mode)
+
+NB: on Ux500 platform, first you have to configure STM output port to switch
+APE tracing on MIPI34 connector with:
+  echo 3 > /sys/kernel/debug/stm/connection
+
+In C language
+-------------
+
+The easy way more intrusive (with STM buffer recopy):
+
+#include <trace/stm.h>
+
+int fd, i;
+char buf[1024];  // Try to align this buffer on 64 bits if possible
+
+  fd = open("/dev/stm0", O_WRONLY);
+  snprintf(buf, 1024, "STM0 Hello world\n");
+  write(fd, buf, strlen(buf));
+  ioctl(fd, STM_GET_CHANNEL_NO, &i);
+  snprintf(buf, 1024, "Use channel #%d\n", i);
+  write(fd, buf, strlen(buf));
+  close(fd);
+
+NB: You can call open("/dev/stm0", O_WRONLY) as many times as necessary
+to allocate a different channel to avoid concurrency in your
+multithreaded application.
+
+The more efficient way, use mmap'ed STM channels memory (to put in a lib):
+
+#include <trace/stm.h>
+
+int fd, i, c, l, maxChannels;
+char buf[1024]; // Try to align this buffer on 64 bits if possible
+volatile struct stm_channel *channels;  // mmap'ed channels area
+
+  fd = open("/dev/stm0", O_RDWR);
+  ioctl(fd0, STM_GET_NB_MAX_CHANNELS, &maxChannels);
+  channels = (struct stm_channel *)mmap(0, maxChannels*sizeof(*channels),
+	PROT_WRITE, MAP_SHARED, fd, 0);
+  assert(channels != MAP_FAILED);
+
+  if (!ioctl(fd, STM_GET_FREE_CHANNEL, &c)) {
+	l = snprintf(buf, 1024, "STM0 Hello world on channel #%d\n", c);
+	// lazy implementation you have to send buffer by 8 Bytes when possible
+	// and be sure you don't share this channel with others threads
+	for (i=0; i<l; i++) {
+		channels[c].stamp8 = buf[i];
+	}
+	ioctl(fd, STM_RELEASE_CHANNEL, c);
+  }
+  munmap((void *)channels, maxChannels*sizeof(*channels));
+  close(fd);
+
+Kernel Internal usages
+======================
+Dynamically channels dedicated for the kernel are allocated
+in the 128 highest ones
+
+Via menuconfig you can:
+- Duplicate printk output on a STM dedicated channel (255)
+- Have realtime ftrace output to a STM dedicated channel (254),
+  if corresponding TRACER is enabled
+- Have realtime sched context switch & sched wakeup output on dedicated channels
+  (253, 252),  if corresponding TRACER is enabled
+- Have Stack Trace on dedicated channels (251)
+- Duplicate trace_printk output on dedicated channels (250 & 249)
+
+
+And in the future:
+------------------
+- Use it in standard kernel tracing infrastucture,
+  possibilities:
+    - Insert other STM trace calls before trace ring buffer write
+    - Substitute time stamping & trace ring buffer by STM
+
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index cc8e49d..70a9527 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -452,6 +452,7 @@ config PCH_PHUB
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
+source "drivers/misc/Kconfig.stm"
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Kconfig.stm b/drivers/misc/Kconfig.stm
new file mode 100644
index 0000000..ef2b946
--- /dev/null
+++ b/drivers/misc/Kconfig.stm
@@ -0,0 +1,114 @@
+menuconfig STM_TRACE
+	bool "STM MIPI Trace driver"
+	depends on ARCH_U8500
+	help
+	  Simple System Trace Module driver. It allows to use and configure the
+	  STM, either from kernel space, or from user space.
+
+if STM_TRACE
+
+config STM_NUMBER_OF_CHANNEL
+	int
+	default 512 if ARCH_U8500
+	default 256
+	help
+	  Number Max of channels always a multiple of 256
+
+config STM_PRINTK
+	bool "printk support"
+	depends on STM_TRACE
+	help
+	  Duplicate printk output on STM printk channel & activate stm_printk
+
+config STM_PRINTK_CHANNEL
+	int "printk channel"
+	range 0 255
+	depends on STM_PRINTK
+	default 255
+	help
+	  STM printk channel number
+
+config STM_FTRACE
+	bool "functions tracing"
+	depends on FTRACE
+	default y
+	help
+	  Output function tracing on STM dedicated channel
+
+config STM_FTRACE_CHANNEL
+	int "ftrace channel"
+	range 0 255
+	depends on STM_FTRACE
+	default 254
+	help
+	  STM ftrace channel number
+
+config STM_CTX_SWITCH
+	bool "Context switch tracing"
+	depends on CONTEXT_SWITCH_TRACER
+	default y
+	help
+	  Output scheduler context switch on STM dedicated channel
+
+config STM_CTX_SWITCH_CHANNEL
+	int "Context switch channel"
+	range 0 255
+	depends on STM_CTX_SWITCH
+	default 253
+	help
+	  STM Context switch channel number
+
+config STM_WAKEUP
+	bool "Scheduler wakeup tracing"
+	depends on CONTEXT_SWITCH_TRACER
+	default y
+	help
+	  Output scheduler wakeup on STM dedicated channel
+
+config STM_WAKEUP_CHANNEL
+	int "Wakeup channel"
+	range 0 255
+	depends on STM_WAKEUP
+	default 252
+	help
+	  STM scheduler wakeup channel number
+
+config STM_STACK_TRACE
+	bool "Stack tracing"
+	depends on STACKTRACE
+	default y
+	help
+	  Output stack tracing on STM dedicated channel
+
+config STM_STACK_TRACE_CHANNEL
+	int "Stack trace channel"
+	range 0 255
+	depends on STM_STACK_TRACE
+	default 251
+	help
+	  STM stack trace channel number
+
+config STM_TRACE_PRINTK
+	bool "trace printk & binary printk support"
+	depends on TRACING
+	default y
+	help
+	  Duplicate trace printk output on STM printk channel
+
+config STM_TRACE_PRINTK_CHANNEL
+	int "trace_printk channel"
+	range 0 255
+	depends on TRACING
+	default 250
+	help
+	  STM trace_printk channel number
+
+config STM_TRACE_BPRINTK_CHANNEL
+	int "trace_bprintk channel"
+	range 0 255
+	depends on TRACING
+	default 249
+	help
+	  STM trace binary printk channel number
+
+endif
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..0b5c3e9 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
+obj-$(CONFIG_STM_TRACE) 	+= stm.o
diff --git a/drivers/misc/stm.c b/drivers/misc/stm.c
new file mode 100644
index 0000000..a05b2d1
--- /dev/null
+++ b/drivers/misc/stm.c
@@ -0,0 +1,797 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Pierre Peiffer <pierre.peiffer@stericsson.com> for ST-Ericsson.
+ *         Philippe Langlais <philippe.Langlais@stericsson.com> for ST-Ericsson.
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/cdev.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <trace/stm.h>
+
+/* STM Registers */
+#define STM_CR          (stm.virtbase)
+#define STM_MMC         (stm.virtbase + 0x008)
+#define STM_TER         (stm.virtbase + 0x010)
+#define STMPERIPHID0    (stm.virtbase + 0xFC0)
+#define STMPERIPHID1    (stm.virtbase + 0xFC8)
+#define STMPERIPHID2    (stm.virtbase + 0xFD0)
+#define STMPERIPHID3    (stm.virtbase + 0xFD8)
+#define STMPCELLID0     (stm.virtbase + 0xFE0)
+#define STMPCELLID1     (stm.virtbase + 0xFE8)
+#define STMPCELLID2     (stm.virtbase + 0xFF0)
+#define STMPCELLID3     (stm.virtbase + 0xFF8)
+
+#define STM_CLOCK_SHIFT 6
+#define STM_CLOCK_MASK  0x1C0
+
+/* Hardware mode for all sources */
+#define STM_MMC_DEFAULT            0xFFFFFFFF
+
+/* Max number of channels (multiple of 256) */
+#define STM_NUMBER_OF_CHANNEL      CONFIG_STM_NUMBER_OF_CHANNEL
+
+/* # dynamically allocated channel with stm_trace_buffer */
+#define NB_KERNEL_DYNAMIC_CHANNEL  128
+
+static struct stm_device {
+	const struct stm_platform_data *pdata;
+	void __iomem *virtbase;
+	/* Used to register the allocated channels */
+	DECLARE_BITMAP(ch_bitmap, STM_NUMBER_OF_CHANNEL);
+} stm;
+
+volatile struct stm_channel __iomem *stm_channels;
+
+static struct cdev cdev;
+static struct class *stm_class;
+static int stm_major;
+
+static DEFINE_SPINLOCK(lock);
+
+/* Middle value for clock divisor */
+static enum clock_div stm_clockdiv = STM_CLOCK_DIV8;
+
+/* Default value for STM output connection */
+static enum stm_connection_type stm_connection = STM_DEFAULT_CONNECTION;
+
+#define STM_BUFSIZE	256
+struct channel_data {
+	DECLARE_BITMAP(bitmap, STM_NUMBER_OF_CHANNEL);
+	int numero;
+	spinlock_t lock;
+	u8 data_buffer[STM_BUFSIZE];
+};
+
+static u64 stm_printk_buf[1024/sizeof(u64)];
+static arch_spinlock_t stm_buf_lock =
+		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
+int stm_alloc_channel(int offset)
+{
+	int channel;
+
+	/* Look for a free channel from offset */
+	do {
+		channel = find_next_zero_bit(stm.ch_bitmap,
+				STM_NUMBER_OF_CHANNEL, offset);
+	} while ((channel < STM_NUMBER_OF_CHANNEL)
+	       && test_and_set_bit(channel, stm.ch_bitmap));
+	return channel;
+}
+EXPORT_SYMBOL(stm_alloc_channel);
+
+void stm_free_channel(int channel)
+{
+	clear_bit(channel, stm.ch_bitmap);
+}
+EXPORT_SYMBOL(stm_free_channel);
+
+static int stm_get_channel(struct channel_data *ch_data, int __user *arg)
+{
+	int channel, err;
+
+	channel = stm_alloc_channel(0);
+	if (channel < STM_NUMBER_OF_CHANNEL) {
+		/* One free found ! */
+		err = put_user(channel, arg);
+		if (err)
+			stm_free_channel(channel);
+		else
+			/* Register it in the context of the file */
+			set_bit(channel, ch_data->bitmap);
+	} else
+		err = -ENOMEM;
+	return err;
+}
+
+static int stm_release_channel(struct channel_data *ch_data, int channel)
+{
+	if ((channel < 0) || (channel >= STM_NUMBER_OF_CHANNEL))
+		return -EINVAL;
+	stm_free_channel(channel);
+	clear_bit(channel, ch_data->bitmap);
+	return 0;
+}
+
+/*
+ * Trace a buffer on a given channel
+ * with auto time stamping on last byte(s) only
+ */
+int stm_trace_buffer_onchannel(int channel,
+			       const void *data, size_t length)
+{
+	int i, mod64;
+	volatile struct stm_channel __iomem *pch;
+
+	if (channel >= STM_NUMBER_OF_CHANNEL || !stm_channels)
+		return 0;
+
+	pch = &stm_channels[channel];
+
+	/*  Align data pointer to u64 & time stamp last byte(s) */
+	mod64 = (int)data & 7;
+	i = length - 8 + mod64;
+	switch (mod64) {
+	case 0:
+		if (i)
+			pch->no_stamp64 = *(u64 *)data;
+		else {
+			pch->stamp64 = *(u64 *)data;
+			return length;
+		}
+		data += 8;
+		break;
+	case 1:
+		pch->no_stamp8 = *(u8 *)data;
+		pch->no_stamp16 = *(u16 *)(data+1);
+		if (i)
+			pch->no_stamp32 = *(u32 *)(data+3);
+		else {
+			pch->stamp32 = *(u32 *)(data+3);
+			return length;
+		}
+		data += 7;
+		break;
+	case 2:
+		pch->no_stamp16 = *(u16 *)data;
+		if (i)
+			pch->no_stamp32 = *(u32 *)(data+2);
+		else {
+			pch->stamp32 = *(u32 *)(data+2);
+			return length;
+		}
+		data += 6;
+		break;
+	case 3:
+		pch->no_stamp8 = *(u8 *)data;
+		if (i)
+			pch->no_stamp32 = *(u32 *)(data+1);
+		else {
+			pch->stamp32 = *(u32 *)(data+1);
+			return length;
+		}
+		data += 5;
+		break;
+	case 4:
+		if (i)
+			pch->no_stamp32 = *(u32 *)data;
+		else {
+			pch->stamp32 = *(u32 *)data;
+			return length;
+		}
+		data += 4;
+		break;
+	case 5:
+		pch->no_stamp8 = *(u8 *)data;
+		if (i)
+			pch->no_stamp16 = *(u16 *)(data+1);
+		else {
+			pch->stamp16 = *(u16 *)(data+1);
+			return length;
+		}
+		data += 3;
+		break;
+	case 6:
+		if (i)
+			pch->no_stamp16 = *(u16 *)data;
+		else {
+			pch->stamp16 = *(u16 *)data;
+			return length;
+		}
+		data += 2;
+		break;
+	case 7:
+		if (i)
+			pch->no_stamp8 = *(u8 *)data;
+		else {
+			pch->stamp8 = *(u8 *)data;
+			return length;
+		}
+		data++;
+		break;
+	}
+	for (;;) {
+		if (i > 8) {
+			pch->no_stamp64 = *(u64 *)data;
+			data += 8;
+			i -= 8;
+		} else if (i == 8) {
+			pch->stamp64 = *(u64 *)data;
+			break;
+		} else if (i > 4) {
+			pch->no_stamp32 = *(u32 *)data;
+			data += 4;
+			i -= 4;
+		} else if (i == 4) {
+			pch->stamp32 = *(u32 *)data;
+			break;
+		} else if (i > 2) {
+			pch->no_stamp16 = *(u16 *)data;
+			data += 2;
+			i -= 2;
+		} else if (i == 2) {
+			pch->stamp16 = *(u16 *)data;
+			break;
+		} else {
+			pch->stamp8 = *(u8 *)data;
+			break;
+		}
+	}
+	return length;
+}
+EXPORT_SYMBOL(stm_trace_buffer_onchannel);
+
+static int stm_open(struct inode *inode, struct file *file)
+{
+	struct channel_data *channel_data;
+
+	channel_data = kzalloc(sizeof(struct channel_data), GFP_KERNEL);
+	if (channel_data == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&channel_data->lock);
+	channel_data->numero = -1;   /*  Channel not yet allocated */
+	file->private_data = channel_data;
+
+	return 0;
+}
+
+static int stm_release(struct inode *inode, struct file *file)
+{
+	struct channel_data *channel;
+
+	channel = (struct channel_data *)file->private_data;
+
+	/* Free allocated channel if necessary */
+	if (channel->numero != -1)
+		stm_free_channel(channel->numero);
+
+	bitmap_andnot(stm.ch_bitmap, stm.ch_bitmap,
+			channel->bitmap, STM_NUMBER_OF_CHANNEL);
+
+	kfree(channel);
+	return 0;
+}
+
+static ssize_t stm_write(struct file *file, const char __user *buf,
+		  size_t size, loff_t *off)
+{
+	struct channel_data *channel = file->private_data;
+
+	/*  Alloc channel at first write */
+	if (channel->numero == -1) {
+		channel->numero = stm_alloc_channel(0);
+		if (channel->numero > STM_NUMBER_OF_CHANNEL)
+			return -ENOMEM;
+	}
+
+	if (size > STM_BUFSIZE)
+		size = STM_BUFSIZE;
+
+	spin_lock(&channel->lock);
+
+	if (copy_from_user
+	    (channel->data_buffer, (void __user *) buf, size)) {
+		spin_unlock(&channel->lock);
+		return -EFAULT;
+	}
+	size = stm_trace_buffer_onchannel(channel->numero,
+			channel->data_buffer, size);
+
+	spin_unlock(&channel->lock);
+
+	return size;
+}
+
+static int stm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/*
+	 * Don't allow a mapping that covers more than the STM channels
+	 */
+	if ((vma->vm_end - vma->vm_start) >
+	    STM_NUMBER_OF_CHANNEL*sizeof(struct stm_channel))
+		return -EINVAL;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start,
+			stm.pdata->channels_phys_base>>PAGE_SHIFT,
+			STM_NUMBER_OF_CHANNEL*sizeof(struct stm_channel),
+			vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
+
+/* Enable the trace for given sources (bitfield) */
+static void stm_enable_src(unsigned int v)
+{
+	unsigned int cr_val;
+	spin_lock(&lock);
+	cr_val = readl(STM_CR);
+	cr_val &= ~STM_CLOCK_MASK;
+	writel(cr_val|(stm_clockdiv<<STM_CLOCK_SHIFT), STM_CR);
+	writel(v, STM_TER);
+	spin_unlock(&lock);
+}
+
+/* Disable all sources */
+static void stm_disable_src(void)
+{
+	writel(0x0, STM_CR);   /* stop clock */
+	writel(0x0, STM_TER);  /* Disable cores */
+}
+
+/* Set clock speed */
+static int stm_set_ckdiv(enum clock_div v)
+{
+	unsigned int val;
+
+	spin_lock(&lock);
+	val = readl(STM_CR);
+	val &= ~STM_CLOCK_MASK;
+	writel(val | ((v << STM_CLOCK_SHIFT) & STM_CLOCK_MASK), STM_CR);
+	spin_unlock(&lock);
+	stm_clockdiv = v;
+
+	return 0;
+}
+
+/* Return the control register */
+static inline unsigned int stm_get_cr(void)
+{
+	return readl(STM_CR);
+}
+
+/*
+ * Set Trace MODE lossless/lossy (Software/Hardware)
+ * each bit represent the corresponding mode of this source
+ */
+static inline void stm_set_modes(unsigned int modes)
+{
+	writel(modes, STM_MMC);
+}
+
+/* Get Trace MODE lossless/lossy (Software/Hardware)
+ * each bit represent the corresponding mode of this source */
+static inline unsigned int stm_get_modes(void)
+{
+	return readl(STM_MMC);
+}
+
+/* Count # of free channels */
+static int stm_nb_free_channels(void)
+{
+	int nb_channels, offset;
+
+	nb_channels = 0;
+	offset = 0;
+	for (;;) {
+		offset = find_next_zero_bit(stm.ch_bitmap,
+				STM_NUMBER_OF_CHANNEL, offset);
+		if (offset == STM_NUMBER_OF_CHANNEL)
+			break;
+		offset++;
+		nb_channels++;
+	}
+	return nb_channels;
+}
+
+static long stm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int err = 0;
+	struct channel_data *channel = file->private_data;
+
+	switch (cmd) {
+
+	case STM_CONNECTION:
+		if (stm.pdata->stm_connection)
+			stm.pdata->stm_connection(arg);
+		stm_connection = arg;
+		break;
+
+	case STM_DISABLE:
+		stm_disable_src();
+		break;
+
+	case STM_GET_NB_MAX_CHANNELS:
+		err = put_user(STM_NUMBER_OF_CHANNEL, (unsigned int *)arg);
+		break;
+
+	case STM_GET_NB_FREE_CHANNELS:
+		err = put_user(stm_nb_free_channels(), (unsigned int *)arg);
+		break;
+
+	case STM_GET_CHANNEL_NO:
+		err = put_user(channel->numero, (unsigned int *)arg);
+		break;
+
+	case STM_SET_CLOCK_DIV:
+		err = stm_set_ckdiv((enum clock_div) arg);
+		break;
+
+	case STM_SET_MODE:
+		stm_set_modes(arg);
+		break;
+
+	case STM_GET_MODE:
+		err = put_user(stm_get_modes(), (unsigned int *)arg);
+		break;
+
+	case STM_GET_CTRL_REG:
+		err = put_user(stm_get_cr(), (unsigned int *)arg);
+		break;
+
+	case STM_ENABLE_SRC:
+		stm_enable_src(arg);
+		break;
+
+	case STM_GET_FREE_CHANNEL:
+		err = stm_get_channel(channel, (int *)arg);
+		break;
+
+	case STM_RELEASE_CHANNEL:
+		err = stm_release_channel(channel, arg);
+		break;
+
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+/*
+ * Trace a buffer on a dynamically allocated channel
+ * with auto time stamping on the first byte(s) only
+ * Dynamic channel number >=
+ *     STM_NUMBER_OF_CHANNEL - NB_KERNEL_DYNAMIC_CHANNEL
+ */
+int stm_trace_buffer(const void *data, size_t length)
+{
+	int channel;
+
+	channel = stm_alloc_channel(STM_NUMBER_OF_CHANNEL
+			- NB_KERNEL_DYNAMIC_CHANNEL);
+	if (channel < STM_NUMBER_OF_CHANNEL) {
+		length = stm_trace_buffer_onchannel(channel, data, length);
+		stm_free_channel(channel);
+		return length;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(stm_trace_buffer);
+
+static const struct file_operations stm_fops = {
+	.owner =		THIS_MODULE,
+	.unlocked_ioctl =	stm_ioctl,
+	.open =			stm_open,
+	.llseek =		no_llseek,
+	.write =		stm_write,
+	.release =		stm_release,
+	.mmap =			stm_mmap,
+};
+
+/*
+ * Init and deinit driver
+ */
+
+static int __devinit stm_probe(struct platform_device *pdev)
+{
+	int retval = 0;
+
+	if (!pdev || !pdev->dev.platform_data)  {
+		pr_alert("No device/platform_data found on STM driver\n");
+		return -ENODEV;
+	}
+
+	stm.pdata = pdev->dev.platform_data;
+
+	cdev_init(&cdev, &stm_fops);
+	cdev.owner = THIS_MODULE;
+
+	stm_channels =
+		ioremap_nocache(stm.pdata->channels_phys_base,
+			STM_NUMBER_OF_CHANNEL*sizeof(*stm_channels));
+	if (stm_channels == NULL) {
+		dev_err(&pdev->dev, "could not remap STM Msg register\n");
+		return -ENODEV;
+	}
+
+	stm.virtbase = ioremap_nocache(stm.pdata->regs_phys_base, SZ_4K);
+	if (stm.virtbase == NULL) {
+		retval = -EIO;
+		dev_err(&pdev->dev, "could not remap STM Register\n");
+		goto err_channels;
+	}
+
+	retval = cdev_add(&cdev, MKDEV(stm_major, 0), 1);
+	if (retval) {
+		dev_err(&pdev->dev, "chardev registration failed\n");
+		goto err_channels;
+	}
+
+	if (IS_ERR(device_create(stm_class, &pdev->dev,
+				 MKDEV(stm_major, 0), NULL, STM_DEV_NAME)))
+		dev_err(&pdev->dev, "can't create device\n");
+
+	/* Check chip IDs if necessary */
+	if (stm.pdata->id_mask) {
+		u32 periph_id, cell_id;
+
+		periph_id = (readb(STMPERIPHID3)<<24) +
+				 (readb(STMPERIPHID2)<<16) +
+				 (readb(STMPERIPHID1)<<8) +
+				 readb(STMPERIPHID0);
+		cell_id = (readb(STMPCELLID3)<<24) +
+				 (readb(STMPCELLID2)<<16) +
+				 (readb(STMPCELLID1)<<8) +
+				 readb(STMPCELLID0);
+		/* Only warns if it isn't a ST-Ericsson supported one */
+		if ((periph_id & stm.pdata->id_mask) != 0x00080dec ||
+		    cell_id != 0xb105f00d) {
+			dev_warn(&pdev->dev, "STM-Trace IC not compatible\n");
+			dev_warn(&pdev->dev, "periph_id=%x\n", periph_id);
+			dev_warn(&pdev->dev, "pcell_id=%x\n", cell_id);
+		}
+	}
+
+	/* Reserve channels if necessary */
+	if (stm.pdata->channels_reserved_sz) {
+		int i;
+
+		for (i = 0; i < stm.pdata->channels_reserved_sz; i++) {
+			set_bit(stm.pdata->channels_reserved[i],
+					stm.ch_bitmap);
+		}
+	}
+	/* Reserve kernel trace channels on demand */
+#ifdef CONFIG_STM_PRINTK
+	set_bit(CONFIG_STM_PRINTK_CHANNEL, stm.ch_bitmap);
+#endif
+#ifdef CONFIG_STM_FTRACE
+	set_bit(CONFIG_STM_FTRACE_CHANNEL, stm.ch_bitmap);
+#endif
+#ifdef CONFIG_STM_CTX_SWITCH
+	set_bit(CONFIG_STM_CTX_SWITCH_CHANNEL, stm.ch_bitmap);
+#endif
+#ifdef CONFIG_STM_WAKEUP
+	set_bit(CONFIG_STM_WAKEUP_CHANNEL, stm.ch_bitmap);
+#endif
+#ifdef CONFIG_STM_STACK_TRACE
+	set_bit(CONFIG_STM_STACK_TRACE_CHANNEL, stm.ch_bitmap);
+#endif
+#ifdef CONFIG_STM_TRACE_PRINTK
+	set_bit(CONFIG_STM_TRACE_PRINTK_CHANNEL, stm.ch_bitmap);
+	set_bit(CONFIG_STM_TRACE_BPRINTK_CHANNEL, stm.ch_bitmap);
+#endif
+
+	if (stm.pdata->stm_connection) {
+		retval = stm.pdata->stm_connection(stm_connection);
+		if (retval) {
+			dev_err(&pdev->dev, "failed to connect STM output\n");
+			goto err_channels;
+		}
+	}
+
+	/* Enable STM Masters given in pdata */
+	if (stm.pdata->masters_enabled)
+		stm_enable_src(stm.pdata->masters_enabled);
+
+	stm_set_modes(STM_MMC_DEFAULT); /* Set all sources in HW mode */
+
+	dev_info(&pdev->dev, "STM-Trace driver probed successfully\n");
+	stm_printk("STM-Trace driver initialized\n");
+	return 0;
+
+err_channels:
+	iounmap(stm_channels);
+	return retval;
+}
+
+static int __devexit stm_remove(struct platform_device *pdev)
+{
+	device_destroy(stm_class, MKDEV(stm_major, 0));
+	cdev_del(&cdev);
+
+	if (stm.pdata->stm_connection)
+		(void) stm.pdata->stm_connection(STM_DISCONNECT);
+
+	stm_disable_src();
+	iounmap(stm.virtbase);
+	iounmap(stm_channels);
+
+	return 0;
+}
+
+int stm_printk(const char *fmt, ...)
+{
+	int ret;
+	size_t size;
+	va_list args;
+
+	va_start(args, fmt);
+	arch_spin_lock(&stm_buf_lock);
+	size = vscnprintf((char *)stm_printk_buf,
+			sizeof(stm_printk_buf), fmt, args);
+	ret = stm_trace_buffer(stm_printk_buf, size);
+	arch_spin_unlock(&stm_buf_lock);
+	va_end(args);
+	return ret;
+}
+EXPORT_SYMBOL(stm_printk);
+
+/*
+ * Debugfs interface
+ */
+
+static int stm_connection_show(void *data, u64 *val)
+{
+	*val = stm_connection;
+	return 0;
+}
+
+static int stm_connection_set(void *data, u64 val)
+{
+	if (stm.pdata->stm_connection) {
+		stm_connection = val;
+		stm.pdata->stm_connection(val);
+	}
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stm_connection_fops, stm_connection_show,
+		stm_connection_set, "%llu\n");
+
+static int stm_clockdiv_show(void *data, u64 *val)
+{
+	*val = stm_clockdiv;
+	return 0;
+}
+
+static int stm_clockdiv_set(void *data, u64 val)
+{
+	stm_set_ckdiv(val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stm_clockdiv_fops, stm_clockdiv_show,
+		stm_clockdiv_set, "%llu\n");
+
+static int stm_masters_enable_show(void *data, u64 *val)
+{
+	*val = readl(STM_TER);
+	return 0;
+}
+
+static int stm_masters_enable_set(void *data, u64 val)
+{
+	stm_enable_src(val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stm_masters_enable_fops, stm_masters_enable_show,
+		stm_masters_enable_set, "%08llx\n");
+
+static int stm_masters_modes_show(void *data, u64 *val)
+{
+	*val = stm_get_modes();
+	return 0;
+}
+
+static int stm_masters_modes_set(void *data, u64 val)
+{
+	stm_set_modes(val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stm_masters_modes_fops, stm_masters_modes_show,
+		stm_masters_modes_set, "%08llx\n");
+
+/* Count # of free channels */
+static int stm_free_channels_show(void *data, u64 *val)
+{
+	*val = stm_nb_free_channels();
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(stm_free_channels_fops, stm_free_channels_show,
+		NULL, "%lld\n");
+
+static __init int stm_init_debugfs(void)
+{
+	struct dentry *d_stm;
+
+	d_stm =  debugfs_create_dir(STM_DEV_NAME, NULL);
+	if (!d_stm)
+		return -ENOMEM;
+
+	(void) debugfs_create_file("connection",  S_IRUGO | S_IWUGO, d_stm,
+				NULL, &stm_connection_fops);
+	(void) debugfs_create_file("clockdiv", S_IRUGO | S_IWUGO, d_stm,
+				NULL, &stm_clockdiv_fops);
+	(void) debugfs_create_file("masters_enable", S_IRUGO | S_IWUGO, d_stm,
+				NULL, &stm_masters_enable_fops);
+	(void) debugfs_create_file("masters_modes", S_IRUGO | S_IWUGO, d_stm,
+				NULL, &stm_masters_modes_fops);
+	(void) debugfs_create_file("free_channels", S_IRUGO, d_stm,
+				NULL, &stm_free_channels_fops);
+	return 0;
+}
+fs_initcall(stm_init_debugfs);
+
+static struct platform_driver stm_driver = {
+	.probe = stm_probe,
+	.remove = __devexit_p(stm_remove),
+	.driver = {
+		.name = STM_DEV_NAME,
+		.owner = THIS_MODULE,
+	}
+};
+
+static int __init stm_init(void)
+{
+	int retval;
+	dev_t dev;
+
+	stm_class = class_create(THIS_MODULE, STM_DEV_NAME);
+	if (IS_ERR(stm_class)) {
+		pr_err("stm: can't register stm class\n");
+		return PTR_ERR(stm_class);
+	}
+
+	retval = alloc_chrdev_region(&dev, 0, 1, STM_DEV_NAME);
+	if (retval) {
+		pr_err("stm: can't register character device\n");
+		class_destroy(stm_class);
+		return retval;
+	}
+	stm_major = MAJOR(dev);
+	return platform_driver_register(&stm_driver);
+}
+
+static void __exit stm_exit(void)
+{
+	platform_driver_unregister(&stm_driver);
+	unregister_chrdev_region(MKDEV(stm_major, 0), 1);
+	class_destroy(stm_class);
+}
+
+arch_initcall(stm_init);   /* STM init ASAP need to wait GPIO init */
+module_exit(stm_exit);
+
+MODULE_AUTHOR("Paul Ghaleb - ST Microelectronics");
+MODULE_AUTHOR("Pierre Peiffer - ST-Ericsson");
+MODULE_AUTHOR("Philippe Langlais - ST-Ericsson");
+MODULE_DESCRIPTION("System Trace Module driver");
+MODULE_ALIAS("stm");
+MODULE_ALIAS("stm-trace");
+MODULE_LICENSE("GPL v2");
diff --git a/include/Kbuild b/include/Kbuild
index 8d226bf..506f6d7 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -10,3 +10,4 @@ header-y += video/
 header-y += drm/
 header-y += xen/
 header-y += scsi/
+header-y += trace/
diff --git a/include/trace/Kbuild b/include/trace/Kbuild
new file mode 100644
index 0000000..7e8b704
--- /dev/null
+++ b/include/trace/Kbuild
@@ -0,0 +1 @@
+header-y += stm.h
diff --git a/include/trace/stm.h b/include/trace/stm.h
new file mode 100644
index 0000000..3362de0
--- /dev/null
+++ b/include/trace/stm.h
@@ -0,0 +1,223 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson STM Trace driver
+ *
+ * Author: Pierre Peiffer <pierre.peiffer@stericsson.com> for ST-Ericsson.
+ *         Philippe Langlais <philippe.langlais@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2.
+ */
+
+#ifndef STM_H
+#define STM_H
+
+#define STM_DEV_NAME "stm"
+
+/* One single channel mapping */
+struct stm_channel {
+	union {
+		__u8  no_stamp8;
+		__u16 no_stamp16;
+		__u32 no_stamp32;
+		__u64 no_stamp64;
+	};
+	union {
+		__u8   stamp8;
+		__u16 stamp16;
+		__u32 stamp32;
+		__u64 stamp64;
+	};
+};
+
+/* Possible trace modes */
+#define STM_SW_LOSSLESS	0 /* Software mode: lossless data but intrusive */
+#define STM_HW_LOSSY	1 /* Hardware mode: lossy data but less intrusive */
+
+/* Possible clock setting */
+enum clock_div {
+	STM_CLOCK_DIV2 = 0,
+	STM_CLOCK_DIV4,
+	STM_CLOCK_DIV6,
+	STM_CLOCK_DIV8,
+	STM_CLOCK_DIV10,
+	STM_CLOCK_DIV12,
+	STM_CLOCK_DIV14,
+	STM_CLOCK_DIV16,
+};
+
+/* ioctl commands */
+#define STM_CONNECTION            _IOW('t', 0, enum stm_connection_type)
+#define STM_DISABLE               _IO('t', 1)
+#define STM_GET_NB_MAX_CHANNELS   _IOR('t', 2, int)
+#define STM_GET_NB_FREE_CHANNELS  _IOR('t', 3, int)
+#define STM_GET_CHANNEL_NO        _IOR('t', 4, int)
+#define STM_SET_CLOCK_DIV         _IOW('t', 5, enum clock_div)
+#define STM_GET_CTRL_REG          _IOR('t', 6, int)
+#define STM_ENABLE_SRC            _IOWR('t', 7, int)
+#define STM_GET_FREE_CHANNEL      _IOW('t', 8, int)
+#define STM_RELEASE_CHANNEL       _IOW('t', 9, int)
+#define STM_SET_MODE              _IOWR('t', 10, int)
+#define STM_GET_MODE              _IOR('t', 11, int)
+
+enum stm_connection_type {
+	STM_DISCONNECT = 0,
+	STM_DEFAULT_CONNECTION = 1,
+	STM_STE_MODEM_ON_MIPI34_NONE_ON_MIPI60 = 2,
+	STM_STE_APE_ON_MIPI34_NONE_ON_MIPI60 = 3,
+	STM_STE_MODEM_ON_MIPI34_APE_ON_MIPI60 = 4
+};
+
+#ifdef __KERNEL__
+
+struct stm_platform_data {
+	u32        regs_phys_base;
+	u32        channels_phys_base;
+	u32        id_mask;
+	u32        masters_enabled;
+	const s16 *channels_reserved;
+	int        channels_reserved_sz;
+	int        (*stm_connection)(enum stm_connection_type);
+};
+
+/* Channels base address */
+extern volatile struct stm_channel __iomem *stm_channels;
+
+/* Provides stm_trace_XX() and stm_tracet_XX() trace API */
+#define DEFLLTFUN(size) \
+static inline void stm_trace_##size(int channel, __u##size data) \
+{ \
+	stm_channels[channel].no_stamp##size = data; \
+} \
+static inline void stm_tracet_##size(int channel, __u##size data) \
+{ \
+	stm_channels[channel].stamp##size = data; \
+} \
+
+DEFLLTFUN(8);
+DEFLLTFUN(16);
+DEFLLTFUN(32);
+DEFLLTFUN(64);
+
+/*
+ * Trace a buffer on a given channel
+ * with auto time stamping on the first byte(s) only
+ */
+int stm_trace_buffer_onchannel(int channel, const void *data, size_t length);
+/*
+ * Trace a buffer on a dynamically allocated channel
+ * with auto time stamping on the first byte(s) only
+ * Dynamic channel are allocated in the 128 highest channels
+ */
+int stm_trace_buffer(const void *data, size_t length);
+
+/* printk equivalent for STM */
+int stm_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+
+#if defined(CONFIG_STM_PRINTK)
+#define stm_dup_printk(buf, length) \
+	stm_trace_buffer_onchannel(CONFIG_STM_PRINTK_CHANNEL, buf, length)
+
+#else
+static inline int stm_dup_printk(char *buf, size_t size)
+{
+	return 0;
+}
+#endif
+
+#if defined(CONFIG_STM_TRACE_PRINTK)
+static inline int stm_trace_printk_buf(
+		unsigned long ip, const char *buf, size_t size)
+{
+	stm_trace_32(CONFIG_STM_TRACE_PRINTK_CHANNEL, ip);
+	return stm_trace_buffer_onchannel(CONFIG_STM_TRACE_PRINTK_CHANNEL,
+			buf, size);
+}
+
+static inline int stm_trace_bprintk_buf(
+		unsigned long ip, const char *fmt, const void *buf, size_t size)
+{
+	stm_trace_64(CONFIG_STM_TRACE_BPRINTK_CHANNEL, ((u64)ip<<32)+(u32)fmt);
+	return stm_trace_buffer_onchannel(CONFIG_STM_TRACE_PRINTK_CHANNEL,
+			buf, size);
+}
+#else
+static inline int stm_trace_printk_buf(
+		unsigned long ip, const char *buf, size_t size)
+{
+	return 0;
+}
+
+static inline int stm_trace_bprintk_buf(
+		unsigned long ip, const char *fmt, const char *buf, size_t size)
+{
+	return 0;
+}
+#endif
+
+#if defined(CONFIG_STM_FTRACE)
+static inline void stm_ftrace(unsigned long ip, unsigned long parent_ip)
+{
+	stm_tracet_64(CONFIG_STM_FTRACE_CHANNEL, (((__u64)ip)<<32) + parent_ip);
+}
+#else
+static inline void stm_ftrace(unsigned long ip, unsigned long parent_ip)
+{
+}
+#endif
+
+#if defined(CONFIG_STM_CTX_SWITCH)
+static inline void stm_sched_switch(u32 prev_pid, u8 prev_prio, u8 prev_state,
+			u32 next_pid, u8 next_prio, u8 next_state, u32 next_cpu)
+{
+	stm_trace_64(CONFIG_STM_CTX_SWITCH_CHANNEL,
+			(((__u64)prev_pid)<<32) + next_pid);
+	stm_tracet_64(CONFIG_STM_CTX_SWITCH_CHANNEL, (((__u64)next_cpu)<<32)
+			+ (prev_prio<<24) + (prev_state<<16)
+			+ (next_prio<<8) + next_state);
+}
+#else
+static inline void stm_sched_switch(u32 prev_pid, u8 prev_prio, u8 prev_state,
+			u32 next_pid, u8 next_prio, u8 next_state, u32 next_cpu)
+{
+}
+#endif
+
+#if defined(CONFIG_STM_WAKEUP)
+static inline void stm_sched_wakeup(u32 prev_pid, u8 prev_prio, u8 prev_state,
+			u32 next_pid, u8 next_prio, u8 next_state, u32 next_cpu)
+{
+	stm_trace_64(CONFIG_STM_WAKEUP_CHANNEL,
+			(((__u64)prev_pid)<<32) + next_pid);
+	stm_tracet_64(CONFIG_STM_WAKEUP_CHANNEL, (((__u64)next_cpu)<<32)
+			+ (prev_prio<<24) + (prev_state<<16)
+			+ (next_prio<<8) + next_state);
+}
+#else
+static inline void stm_sched_wakeup(u32 prev_pid, u8 prev_prio, u8 prev_state,
+			u32 next_pid, u8 next_prio, u8 next_state, u32 next_cpu)
+{
+}
+#endif
+
+#if defined(CONFIG_STM_STACK_TRACE)
+static inline void stm_stack_trace(unsigned long *callers)
+{
+	while (*(callers + 1) != ULONG_MAX) {
+		stm_trace_32(CONFIG_STM_STACK_TRACE_CHANNEL, *callers++);
+	}
+	/* Time stamp the latest */
+	stm_tracet_32(CONFIG_STM_STACK_TRACE_CHANNEL, *callers);
+}
+#else
+static inline void stm_stack_trace(unsigned long *callers)
+{
+}
+#endif
+
+/* Alloc/Free STM channel */
+int stm_alloc_channel(int offset);
+void stm_free_channel(int channel);
+
+#endif /* __KERNEL__ */
+
+#endif /* STM_H */
-- 
1.7.3.1

