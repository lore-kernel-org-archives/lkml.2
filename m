Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1CRRqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:46:18 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60434 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab1CRRp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:45:59 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: [PATCH 11/11] KBUS configuration and Makefile
Date: Fri, 18 Mar 2011 17:21:20 +0000
Message-Id: <9d9c3a293cc9e16d703459509b3134a038052656.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <667f715f19ff4543cedc10361db357ce844e73b1.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
 <273ee9658cbcbe19adfa0d7b30082d8966e70afc.1300450604.git.tibs@tonyibbs.co.uk>
 <979f23cd5f8a9ac727f17ad359ee487cbccbf7f6.1300450604.git.tibs@tonyibbs.co.uk>
 <c28914a66ae5526f18c331475298e7ef05bf57c7.1300450604.git.tibs@tonyibbs.co.uk>
 <ffc9b735a3b61c51881c108235155384a6e6f56c.1300450604.git.tibs@tonyibbs.co.uk>
 <e1e0c80ed995eccd4881081f5a769acb148b267b.1300450604.git.tibs@tonyibbs.co.uk>
 <023b39071aff3abc8e63336be501742333ceeced.1300450604.git.tibs@tonyibbs.co.uk>
 <6038dbd7e203bc102bd5d33ad9f1aa4f204a3a2e.1300450604.git.tibs@tonyibbs.co.uk>
 <100daf735e4bcf057ca5e84c391f04fa7dea1aaf.1300450604.git.tibs@tonyibbs.co.uk>
 <c6d9cea99c649d41ae838838a0e8da3807b98e64.1300450604.git.tibs@tonyibbs.co.uk>
 <667f715f19ff4543cedc10361db357ce844e73b1.1300450604.git.tibs@tonyibbs.co.uk>
In-Reply-To: <cover.1300450604.git.tibs@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tony Ibbs <tibs@tonyibbs.co.uk>
---
 init/Kconfig |    2 +
 ipc/Kconfig  |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ipc/Makefile |    9 ++++
 3 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 ipc/Kconfig

diff --git a/init/Kconfig b/init/Kconfig
index c972899..945c380 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -339,6 +339,8 @@ config AUDIT_TREE
 	depends on AUDITSYSCALL
 	select FSNOTIFY
 
+source "ipc/Kconfig"
+
 source "kernel/irq/Kconfig"
 
 menu "RCU Subsystem"
diff --git a/ipc/Kconfig b/ipc/Kconfig
new file mode 100644
index 0000000..808d742
--- /dev/null
+++ b/ipc/Kconfig
@@ -0,0 +1,117 @@
+config KBUS
+	tristate "KBUS messaging system"
+	default n
+	---help---
+	  KBUS is a lightweight messaging system, particularly aimed
+	  at embedded platforms. This option provides the kernel support
+	  for mediating messages between client processes.
+
+	  KBUS documentation may be found in Documentation/Kbus.txt
+
+	  If you want KBUS support, you should say Y or M here. If you
+	  choose M, the module will be called kbus.
+
+	  If unsure, say N.
+
+if KBUS
+
+config KBUS_DEBUG
+	bool "Make KBUS debugging messages available"
+	default y
+	---help---
+	  This is the master switch for KBUS debug kernel messages.
+
+	  If N is selected, all debug messages will be compiled out,
+	  and the KBUS_IOC_VERBOSE ioctl will have no effect.
+
+	  If Y is selected, then KBUS_DEBUG_DEFAULT_VERBOSE sets
+	  the default for whether debug messages are emitted or not,
+	  and the KBUS_IOC_VERBOSE ioctl can be used at runtime to
+	  set/unset the output of debugging messages per KBUS device.
+
+	  If unsure, say Y.
+
+config KBUS_DEBUG_DEFAULT_VERBOSE
+	bool "Output KBUS debug messages by default"
+	depends on KBUS_DEBUG
+	default n
+	---help---
+	  This sets the default state for the output of debugging messages,
+	  It only has effect if KBUS_DEBUG is already set.
+
+	  If Y is selected, then KBUS devices default to outputting debug
+	  messages. If N is selected, they do not.
+
+	  In either case, debug messages for a particular KBUS device can
+	  be turned on or off at runtime with the KBUS_IOC_VERBOSE ioctl.
+
+	  If unsure, say N.
+
+config KBUS_DEF_NUM_DEVICES
+	int "Number of KBUS devices to auto-create"
+	default 1
+	range 1 KBUS_MAX_NUM_DEVICES
+	---help---
+	  This specifies the number of KBUS devices automatically created
+	  when the KBUS subsystem initialises (when the module is loaded
+			  or the kernel booted, as appropriate).
+
+	  If KBUS is built as a module, this number may also be given as a
+	  parameter; for example: kbus_num_devices=5.
+
+	  Additional devices can be added at runtime using the
+	  KBUS_IOC_NEWDEVICE ioctl.
+
+config KBUS_MAX_NUM_DEVICES
+	int "Maximum number of KBUS devices"
+	default 256
+	range 1 2147483647
+	# We don't impose a limit on the max, so if you've got enough
+	# RAM the only practical limit will be the (int) minor count
+	# passed to __register_chrdev_region.
+	---help---
+	  The maximum number of KBUS devices to support. If unsure, use
+	  the default of 256.
+
+	  Note that this setting controls the size of an array of pointers
+	  to in-kernel KBUS structures; reducing it only saves a tiny amount
+	  of RAM. On the other hand, once a KBUS device is used, the various
+	  message lists and so on do take space.
+
+config KBUS_DEF_MAX_MESSAGES
+	int "Default KBUS message queue size limit"
+	default 100
+	range 1 2147483647
+	---help---
+	  Specify the default incoming message queue size limit. This default
+	  is applied to all clients whenever they open or reopen a KBUS device
+	  node.
+
+	  Clients sending messages may specify the desired behaviour if any
+	  of the recipients' message queues are full. If a senders own queue
+	  is full, it may not send a message flagged as a Request. Refer to
+	  the KBBUS documentation ("Queues filling up") for details.
+
+	  Clients may change their own queue size limits at any time with the
+	  KBUS_IOC_MAXMSGS ioctl.
+
+	  The default is believed to be a reasonable conservative choice.
+
+config KBUS_MAX_UNSENT_UNBIND_MESSAGES
+	int "Maximum number of unsent KBUS unbind event messages"
+	default 1000
+	range 1 2147483647
+	---help---
+	  KBUS devices may request (by ioctl) that they want to receive
+	  messages when clients bind or unbind as repliers. If such a
+	  message is sent when their incoming queue is full, it is instead
+	  saved onto a set-aside queue, and delivered later. This setting
+	  determines the size of the set-aside queue; if the limit is reached,
+	  a special "bind/unbind event messages were lost" message is queued
+	  instead, and any further bind/unbind messages will be lost, until
+	  such time as the special message can be delivered.
+
+	  If unsure, choose the default.
+
+endif # KBUS
+
diff --git a/ipc/Makefile b/ipc/Makefile
index 9075e17..db692ad 100644
--- a/ipc/Makefile
+++ b/ipc/Makefile
@@ -2,6 +2,11 @@
 # Makefile for the linux ipc.
 #
 
+ifeq ($(CONFIG_KBUS_DEBUG),y)
+	CFLAGS_kbus_main.o	= -DDEBUG
+	CFLAGS_kbus_report.o	= -DDEBUG
+endif
+
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
 obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o syscall.o
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
@@ -9,4 +14,8 @@ obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
 obj-$(CONFIG_POSIX_MQUEUE_SYSCTL) += mq_sysctl.o
+obj-$(CONFIG_KBUS) += kbus.o
+
+kbus-y := kbus_main.o
+kbus-$(CONFIG_PROC_FS) += kbus_report.o
 
-- 
1.7.4.1

