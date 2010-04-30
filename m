Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab0D3QxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:53:20 -0400
Received: from maila.microsoft.com ([131.107.115.212]:23189 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0D3Qwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:52:50 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] hv: Added new hv_utils driver to hyper-v - RE-CREATED
Thread-Topic: [PATCH 1/1] hv: Added new hv_utils driver to hyper-v -
 RE-CREATED
Thread-Index: AQHK6IWJOKH51OSTiEaNGLs/SJNOUA==
Date: Fri, 30 Apr 2010 16:52:34 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5621AFF0EC8@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C5621AFEC8AD@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100429191434.GH21799@kroah.com>
In-Reply-To: <20100429191434.GH21799@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

As requested, here is the patch, it was created against a fresh
clone of kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
of this morning using the origin/staging-next branch. It was created with
the help of the git format-patch command.

But when I do a diff from this patch and the one I send earlier this
Week, I do not see anything different in my patch.

Let me know if there is still an issue with this.

Thanks,

Hank.

---------------------
From: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] hv: Added new hv_utils driver with shutdown as first functionality

Addition of new driver for Hyper-V called hv_utils.
This driver is intended to support things like KVP, Timesync, Heartbeat etc.

This first release has support for graceful shutdown.
e.g. Select shutdown from the Hyper-V main admin screen and the Linux VM will do a graceful shutdown.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/Channel.c           |   34 ++++++-
 drivers/staging/hv/ChannelMgmt.c       |  148 +++++++++++++++++++++++++++++++-
 drivers/staging/hv/Kconfig             |    6 ++
 drivers/staging/hv/Makefile            |    2 +
 drivers/staging/hv/VmbusPacketFormat.h |    1 +
 drivers/staging/hv/ext_utils.c         |   27 ++++++
 drivers/staging/hv/hyperv_utils.c      |  134 +++++++++++++++++++++++++++++
 drivers/staging/hv/utils.h             |   94 ++++++++++++++++++++
 8 files changed, 438 insertions(+), 8 deletions(-)
 create mode 100644 drivers/staging/hv/ext_utils.c
 create mode 100644 drivers/staging/hv/hyperv_utils.c
 create mode 100644 drivers/staging/hv/utils.h

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index 328d3a0..de2ccb1 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "osd.h"
 #include "logging.h"
 #include "VmbusPrivate.h"
@@ -666,8 +667,19 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
        DPRINT_EXIT(VMBUS);
 }

-/*
- * VmbusChannelSendPacket - Send the specified buffer on the given channel
+/**
+ * VmbusChannelSendPacket() - Send the specified buffer on the given channel
+ * @Channel: Pointer to vmbus_channel structure.
+ * @Buffer: Pointer to the buffer you want to receive the data into.
+ * @BufferLen: Maximum size of what the the buffer will hold
+ * @RequestId: Identifier of the request
+ * @vmbus_packet_type: Type of packet that is being send e.g. negotiate, time
+ * packet etc.
+ *
+ * Sends data in @Buffer directly to hyper-v via the vmbus
+ * This will send the data unparsed to hyper-v.
+ *
+ * Mainly used by Hyper-V drivers.
  */
 int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
                           u32 BufferLen, u64 RequestId,
@@ -711,6 +723,7 @@ int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,

        return ret;
 }
+EXPORT_SYMBOL(VmbusChannelSendPacket);

 /*
  * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
@@ -848,10 +861,20 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
        return ret;
 }

-/*
- * VmbusChannelRecvPacket - Retrieve the user packet on the specified channel
+
+/**
+ * VmbusChannelRecvPacket() - Retrieve the user packet on the specified channel
+ * @Channel: Pointer to vmbus_channel structure.
+ * @Buffer: Pointer to the buffer you want to receive the data into.
+ * @BufferLen: Maximum size of what the the buffer will hold
+ * @BufferActualLen: The actual size of the data after it was received
+ * @RequestId: Identifier of the request
+ *
+ * Receives directly from the hyper-v vmbus and puts the data it received
+ * into Buffer. This will receive the data unparsed from hyper-v.
+ *
+ * Mainly used by Hyper-V drivers.
  */
-/* TODO: Do we ever receive a gpa direct packet other than the ones we send ? */
 int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
                           u32 BufferLen, u32 *BufferActualLen, u64 *RequestId)
 {
@@ -913,6 +936,7 @@ int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,

        return 0;
 }
+EXPORT_SYMBOL(VmbusChannelRecvPacket);

 /*
  * VmbusChannelRecvPacketRaw - Retrieve the raw packet on the specified channel
diff --git a/drivers/staging/hv/ChannelMgmt.c b/drivers/staging/hv/ChannelMgmt.c
index 43f28f2..9c3069f 100644
--- a/drivers/staging/hv/ChannelMgmt.c
+++ b/drivers/staging/hv/ChannelMgmt.c
@@ -22,18 +22,22 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include "osd.h"
 #include "logging.h"
 #include "VmbusPrivate.h"
+#include "utils.h"

 struct vmbus_channel_message_table_entry {
        enum vmbus_channel_message_type messageType;
        void (*messageHandler)(struct vmbus_channel_message_header *msg);
 };

-#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 4
+#define MAX_MSG_TYPES                    1
+#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 5
+
 static const struct hv_guid
-               gSupportedDeviceClasses[MAX_NUM_DEVICE_CLASSES_SUPPORTED] = {
+       gSupportedDeviceClasses[MAX_NUM_DEVICE_CLASSES_SUPPORTED] = {
        /* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
        /* Storage - SCSI */
        {
@@ -69,8 +73,127 @@ static const struct hv_guid
                        0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
                }
        },
+       /* 0E0B6031-5213-4934-818B-38D90CED39DB */
+       /* Shutdown */
+       {
+               .data = {
+                       0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
+                       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB
+               }
+       },
 };

+
+/**
+ * prep_negotiate_resp() - Create default response for Hyper-V Negotiate message
+ * @icmsghdrp: Pointer to msg header structure
+ * @icmsg_negotiate: Pointer to negotiate message structure
+ * @buf: Raw buffer channel data
+ *
+ * @icmsghdrp is of type &struct icmsg_hdr.
+ * @negop is of type &struct icmsg_negotiate.
+ * Set up and fill in default negotiate response message. This response can
+ * come from both the vmbus driver and the hv_utils driver. The current api
+ * will respond properly to both Windows 2008 and Windows 2008-R2 operating
+ * systems.
+ *
+ * Mainly used by Hyper-V drivers.
+ */
+void prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
+                            struct icmsg_negotiate *negop,
+                            u8 *buf)
+{
+       if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+               icmsghdrp->icmsgsize = 0x10;
+
+               negop = (struct icmsg_negotiate *)&buf[
+                       sizeof(struct vmbuspipe_hdr) +
+                       sizeof(struct icmsg_hdr)];
+
+               if (negop->icframe_vercnt == 2 &&
+                  negop->icversion_data[1].major == 3) {
+                       negop->icversion_data[0].major = 3;
+                       negop->icversion_data[0].minor = 0;
+                       negop->icversion_data[1].major = 3;
+                       negop->icversion_data[1].minor = 0;
+               } else {
+                       negop->icversion_data[0].major = 1;
+                       negop->icversion_data[0].minor = 0;
+                       negop->icversion_data[1].major = 1;
+                       negop->icversion_data[1].minor = 0;
+               }
+
+               negop->icframe_vercnt = 1;
+               negop->icmsg_vercnt = 1;
+       }
+}
+EXPORT_SYMBOL(prep_negotiate_resp);
+
+/**
+ * chn_cb_negotiate() - Default handler for non IDE/SCSI/NETWORK
+ * Hyper-V requests
+ * @context: Pointer to argument structure.
+ *
+ * Set up the default handler for non device driver specific requests
+ * from Hyper-V. This stub responds to the default negotiate messages
+ * that come in for every non IDE/SCSI/Network request.
+ * This behavior is normally overwritten in the hv_utils driver. That
+ * driver handles requests like gracefull shutdown, heartbeats etc.
+ *
+ * Mainly used by Hyper-V drivers.
+ */
+void chn_cb_negotiate(void *context)
+{
+       struct vmbus_channel *channel = context;
+       u8 *buf;
+       u32 buflen, recvlen;
+       u64 requestid;
+
+       struct icmsg_hdr *icmsghdrp;
+       struct icmsg_negotiate *negop = NULL;
+
+       buflen = PAGE_SIZE;
+       buf = kmalloc(buflen, GFP_ATOMIC);
+
+       VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+
+       if (recvlen > 0) {
+               icmsghdrp = (struct icmsg_hdr *)&buf[
+                       sizeof(struct vmbuspipe_hdr)];
+
+               prep_negotiate_resp(icmsghdrp, negop, buf);
+
+               icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
+                       | ICMSGHDRFLAG_RESPONSE;
+
+               VmbusChannelSendPacket(channel, buf,
+                                      recvlen, requestid,
+                                      VmbusPacketTypeDataInBand, 0);
+       }
+
+       kfree(buf);
+}
+EXPORT_SYMBOL(chn_cb_negotiate);
+
+/*
+ * Function table used for message responses for non IDE/SCSI/Network type
+ * messages. (Such as KVP/Shutdown etc)
+ */
+struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYPES] = {
+       /* 0E0B6031-5213-4934-818B-38D90CED39DB */
+       /* Shutdown */
+       {
+               .msg_type = HV_SHUTDOWN_MSG,
+               .data = {
+                       0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
+                       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB
+               },
+               .callback = chn_cb_negotiate,
+               .log_msg = "Shutdown channel functionality initialized"
+       },
+};
+EXPORT_SYMBOL(hv_cb_utils);
+
 /*
  * AllocVmbusChannel - Allocate and initialize a vmbus channel object
  */
@@ -132,7 +255,8 @@ void FreeVmbusChannel(struct vmbus_channel *Channel)
 }

 /*
- * VmbusChannelProcessOffer - Process the offer by creating a channel/device associated with this offer
+ * VmbusChannelProcessOffer - Process the offer by creating a channel/device
+ * associated with this offer
  */
 static void VmbusChannelProcessOffer(void *context)
 {
@@ -140,6 +264,7 @@ static void VmbusChannelProcessOffer(void *context)
        struct vmbus_channel *channel;
        bool fNew = true;
        int ret;
+       int cnt;
        unsigned long flags;

        DPRINT_ENTER(VMBUS);
@@ -209,6 +334,23 @@ static void VmbusChannelProcessOffer(void *context)
                 * can cleanup properly
                 */
                newChannel->State = CHANNEL_OPEN_STATE;
+               cnt = 0;
+
+               while (cnt != MAX_MSG_TYPES) {
+                       if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
+                                  &hv_cb_utils[cnt].data,
+                                  sizeof(struct hv_guid)) == 0) {
+                               DPRINT_INFO(VMBUS, "%s",
+                                           hv_cb_utils[cnt].log_msg);
+
+                               if (VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
+                                                   2 * PAGE_SIZE, NULL, 0,
+                                                   hv_cb_utils[cnt].callback,
+                                                   newChannel) == 0)
+                                       hv_cb_utils[cnt].channel = newChannel;
+                       }
+                       cnt++;
+               }
        }
        DPRINT_EXIT(VMBUS);
 }
diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 4044702..79afb1e 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -29,4 +29,10 @@ config HYPERV_NET
        help
          Select this option to enable the Hyper-V virtual network driver.

+config HYPERV_UTILS
+       tristate "Microsoft Hyper-V Utilities driver"
+       default HYPERV
+       help
+         Select this option to enable the Hyper-V Utilities.
+
 endif
diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index 27ebae8..d2977ab 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_HYPERV)            += hv_vmbus.o
 obj-$(CONFIG_HYPERV_STORAGE)   += hv_storvsc.o
 obj-$(CONFIG_HYPERV_BLOCK)     += hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)       += hv_netvsc.o
+obj-$(CONFIG_HYPERV_UTILS)     += hv_utils.o

 hv_vmbus-objs := vmbus_drv.o osd.o \
                 Vmbus.o Hv.o Connection.o Channel.o \
@@ -9,3 +10,4 @@ hv_vmbus-objs := vmbus_drv.o osd.o \
 hv_storvsc-objs := storvsc_drv.o StorVsc.o
 hv_blkvsc-objs := blkvsc_drv.o BlkVsc.o
 hv_netvsc-objs := netvsc_drv.o NetVsc.o RndisFilter.o
+hv_utils-objs := hyperv_utils.o ext_utils.o
diff --git a/drivers/staging/hv/VmbusPacketFormat.h b/drivers/staging/hv/VmbusPacketFormat.h
index 79120bc..f9f6b4b 100644
--- a/drivers/staging/hv/VmbusPacketFormat.h
+++ b/drivers/staging/hv/VmbusPacketFormat.h
@@ -22,6 +22,7 @@
  */

 #ifndef _VMBUSPACKETFORMAT_H_
+#define _VMBUSPACKETFORMAT_H_

 struct vmpacket_descriptor {
        u16 Type;
diff --git a/drivers/staging/hv/ext_utils.c b/drivers/staging/hv/ext_utils.c
new file mode 100644
index 0000000..a44cd1b
--- /dev/null
+++ b/drivers/staging/hv/ext_utils.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2010, Microsoft Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ *   Hank Janssen  <hjanssen@microsoft.com>
+ */
+#include <linux/reboot.h>
+#include "utils.h"
+
+void shutdown_linux_system()
+{
+       orderly_poweroff(false);
+}
diff --git a/drivers/staging/hv/hyperv_utils.c b/drivers/staging/hv/hyperv_utils.c
new file mode 100644
index 0000000..2a48647
--- /dev/null
+++ b/drivers/staging/hv/hyperv_utils.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (c) 2010, Microsoft Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ *   Hank Janssen  <hjanssen@microsoft.com>
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sysctl.h>
+#include <linux/version.h>
+
+#include "logging.h"
+#include "osd.h"
+#include "vmbus.h"
+#include "VmbusPacketFormat.h"
+#include "VmbusChannelInterface.h"
+#include "VersionInfo.h"
+#include "Channel.h"
+#include "VmbusPrivate.h"
+#include "VmbusApi.h"
+#include "utils.h"
+
+
+void shutdown_onchannelcallback(void *context)
+{
+       struct vmbus_channel *channel = context;
+       u8 *buf;
+       u32 buflen, recvlen;
+       u64 requestid;
+       u8  execute_shutdown = false;
+
+       struct shutdown_msg_data *shutdown_msg;
+
+       struct icmsg_hdr *icmsghdrp;
+       struct icmsg_negotiate *negop = NULL;
+
+       DPRINT_ENTER(VMBUS);
+
+       buflen = PAGE_SIZE;
+       buf = kmalloc(buflen, GFP_ATOMIC);
+
+       VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+
+       if (recvlen > 0) {
+               DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
+                          recvlen, requestid);
+
+               icmsghdrp = (struct icmsg_hdr *)&buf[
+                       sizeof(struct vmbuspipe_hdr)];
+
+               if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+                       prep_negotiate_resp(icmsghdrp, negop, buf);
+               } else {
+                       shutdown_msg = (struct shutdown_msg_data *)&buf[
+                               sizeof(struct vmbuspipe_hdr) +
+                               sizeof(struct icmsg_hdr)];
+
+                       switch (shutdown_msg->flags) {
+                       case 0:
+                       case 1:
+                               icmsghdrp->status = HV_S_OK;
+                               execute_shutdown = true;
+
+                               DPRINT_INFO(VMBUS, "Shutdown request received -"
+                                           " gracefull shutdown initiated");
+                               break;
+                       default:
+                               icmsghdrp->status = HV_E_FAIL;
+                               execute_shutdown = false;
+
+                               DPRINT_INFO(VMBUS, "Shutdown request received -"
+                                           " Invalid request");
+                               break;
+                       };
+               }
+
+               icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
+                       | ICMSGHDRFLAG_RESPONSE;
+
+               VmbusChannelSendPacket(channel, buf,
+                                      recvlen, requestid,
+                                      VmbusPacketTypeDataInBand, 0);
+       }
+
+       kfree(buf);
+
+       DPRINT_EXIT(VMBUS);
+
+       if (execute_shutdown == true)
+               shutdown_linux_system();
+}
+
+static int __init init_hyperv_utils(void)
+{
+       printk(KERN_INFO "Registering HyperV Utility Driver\n");
+
+       hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
+               &shutdown_onchannelcallback;
+       hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
+
+       return 0;
+}
+
+static void exit_hyperv_utils(void)
+{
+       printk(KERN_INFO "De-Registered HyperV Utility Driver\n");
+
+       hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
+               &chn_cb_negotiate;
+       hv_cb_utils[HV_SHUTDOWN_MSG].callback = &chn_cb_negotiate;
+}
+
+module_init(init_hyperv_utils);
+module_exit(exit_hyperv_utils);
+
+MODULE_DESCRIPTION("Hyper-V Utilities");
+MODULE_VERSION(HV_DRV_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/hv/utils.h b/drivers/staging/hv/utils.h
new file mode 100644
index 0000000..4e09804
--- /dev/null
+++ b/drivers/staging/hv/utils.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2009, Microsoft Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
+ *   Hank Janssen  <hjanssen@microsoft.com>
+ */
+#ifndef _UTILS_H_
+#define _UTILS_H_
+
+/*
+ * Common header for Hyper-V ICs
+ */
+#define ICMSGTYPE_NEGOTIATE   0
+#define ICMSGTYPE_HEARTBEAT   1
+#define ICMSGTYPE_KVPEXCHANGE 2
+#define ICMSGTYPE_SHUTDOWN    3
+#define ICMSGTYPE_TIMESYNC    4
+#define ICMSGTYPE_VSS         5
+
+#define ICMSGHDRFLAG_TRANSACTION 1
+#define ICMSGHDRFLAG_REQUEST     2
+#define ICMSGHDRFLAG_RESPONSE    4
+
+#define HV_S_OK                   0x00000000
+#define HV_E_FAIL                 0x80004005
+#define HV_ERROR_NOT_SUPPORTED    0x80070032
+#define HV_ERROR_MACHINE_LOCKED   0x800704F7
+
+struct vmbuspipe_hdr {
+    u32 flags;
+    u32 msgsize;
+} __attribute__((packed));
+
+struct ic_version {
+    u16 major;
+    u16 minor;
+} __attribute__((packed));
+
+struct icmsg_hdr {
+    struct ic_version icverframe;
+    u16 icmsgtype;
+    struct ic_version icvermsg;
+    u16 icmsgsize;
+    u32 status;
+    u8 ictransaction_id;
+    u8 icflags;
+    u8 reserved[2];
+} __attribute__((packed));
+
+struct icmsg_negotiate {
+    u16 icframe_vercnt;
+    u16 icmsg_vercnt;
+    u32 reserved;
+    struct ic_version icversion_data[1]; /* any size array */
+} __attribute__((packed));
+
+struct shutdown_msg_data {
+       u32 reason_code;
+       u32 timeout_seconds;
+       u32 flags;
+       u8  display_message[2048];
+} __attribute__((packed));
+
+#define HV_SHUTDOWN_MSG             0
+
+struct hyperv_service_callback {
+       u8 msg_type;
+       char *log_msg;
+       unsigned char data[16];
+       struct vmbus_channel *channel;
+       void (*callback) (void *context);
+};
+
+extern void prep_negotiate_resp(struct icmsg_hdr *,
+                                   struct icmsg_negotiate *, u8 *);
+extern void shutdown_linux_system(void);
+extern void chn_cb_negotiate(void *);
+extern struct hyperv_service_callback hv_cb_utils[];
+
+#endif /* _UTILS_H_ */
--
1.6.0.2



