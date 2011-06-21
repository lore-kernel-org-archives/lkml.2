Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1FUHWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:22:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1FUHWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:25 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
Date: Tue, 21 Jun 2011 10:18:33 +0300
Message-Id: <1308640714-17961-8-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a virtio-based IPC bus, which enables kernel users to communicate
with remote processors over shared memory using a simple messaging
protocol.

Assign a local address for every local endpoint that is created,
and bind it to the user's callback. Invoke that callback when the
destination of an inbound message is the user's address.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 Documentation/ABI/testing/sysfs-bus-rpmsg |   75 +++
 Documentation/rpmsg.txt                   |  308 +++++++++
 drivers/Kconfig                           |    1 +
 drivers/Makefile                          |    1 +
 drivers/rpmsg/Kconfig                     |   14 +
 drivers/rpmsg/Makefile                    |    1 +
 drivers/rpmsg/virtio_rpmsg_bus.c          | 1036 +++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h           |   10 +
 include/linux/rpmsg.h                     |  421 ++++++++++++
 include/linux/virtio_ids.h                |    1 +
 10 files changed, 1868 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/rpmsg.txt
 create mode 100644 drivers/rpmsg/Kconfig
 create mode 100644 drivers/rpmsg/Makefile
 create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/rpmsg.h

diff --git a/Documentation/ABI/testing/sysfs-bus-rpmsg b/Documentation/ABI/testing/sysfs-bus-rpmsg
new file mode 100644
index 0000000..7bddf70
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-rpmsg
@@ -0,0 +1,75 @@
+What:		/sys/bus/rpmsg/devices/.../name
+Date:		June 2011
+KernelVersion:	3.2
+Contact:	Ohad Ben-Cohen <ohad@wizery.com>
+Description:
+		Every rpmsg device is a communication channel with a remote
+		processor. Channels are identified with a (textual) name,
+		which is maximum 32 bytes long (defined as RPMSG_NAME_SIZE in
+		rpmsg.h).
+
+		This sysfs entry contains the name of this channel.
+
+What:		/sys/bus/rpmsg/devices/.../src
+Date:		June 2011
+KernelVersion:	3.2
+Contact:	Ohad Ben-Cohen <ohad@wizery.com>
+Description:
+		Every rpmsg device is a communication channel with a remote
+		processor. Channels have a local ("source") rpmsg address,
+		and remote ("destination") rpmsg address. When an entity
+		starts listening on one end of a channel, it assigns it with
+		a unique rpmsg address (a 32 bits integer). This way when
+		inbound messages arrive to this address, the rpmsg core
+		dispatches them to the listening entity (a kernel driver).
+
+		This sysfs entry contains the src (local) rpmsg address
+		of this channel. If it contains 0xffffffff, then an address
+		wasn't assigned (can happen if no driver exists for this
+		channel).
+
+What:		/sys/bus/rpmsg/devices/.../dst
+Date:		June 2011
+KernelVersion:	3.2
+Contact:	Ohad Ben-Cohen <ohad@wizery.com>
+Description:
+		Every rpmsg device is a communication channel with a remote
+		processor. Channels have a local ("source") rpmsg address,
+		and remote ("destination") rpmsg address. When an entity
+		starts listening on one end of a channel, it assigns it with
+		a unique rpmsg address (a 32 bits integer). This way when
+		inbound messages arrive to this address, the rpmsg core
+		dispatches them to the listening entity.
+
+		This sysfs entry contains the dst (remote) rpmsg address
+		of this channel. If it contains 0xffffffff, then an address
+		wasn't assigned (can happen if the kernel driver that
+		is attached to this channel is exposing a service to the
+		remote processor. This make it a local rpmsg server,
+		and it is listening for inbound messages that may be sent
+		from any remote rpmsg client; it is not bound to a single
+		remote entity).
+
+What:		/sys/bus/rpmsg/devices/.../announce
+Date:		June 2011
+KernelVersion:	3.2
+Contact:	Ohad Ben-Cohen <ohad@wizery.com>
+Description:
+		Every rpmsg device is a communication channel with a remote
+		processor. Channels are identified by a textual name (see
+		/sys/bus/rpmsg/devices/.../name above) and have a local
+		("source") rpmsg address, and remote ("destination") rpmsg
+		address.
+
+		A channel is first created when an entity, whether local
+		or remote, starts listening on it for messages (and is thus
+		called an rpmsg server).
+
+		When that happens, a "name service" announcement is sent
+		to the other processor, in order to let it know about the
+		creation of the channel (this way remote clients know they
+		can start sending messages).
+
+		This sysfs entry tells us whether the channel is a local
+		server channel that is announced (values are either
+		true or false).
diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
new file mode 100644
index 0000000..0a7c820
--- /dev/null
+++ b/Documentation/rpmsg.txt
@@ -0,0 +1,308 @@
+Remote Processor Messaging (rpmsg) Framework
+
+1. Introduction
+
+Modern SoCs typically employ heterogeneous remote processor devices in
+asymmetric multiprocessing (AMP) configurations, which may be running
+different instances of operating system, whether it's Linux or any other
+flavor of real-time OS.
+
+OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
+Typically, the dual cortex-A9 is running Linux in a SMP configuration,
+and each of the other three cores (two M3 cores and a DSP) is running
+its own instance of RTOS in an AMP configuration.
+
+Typically AMP remote processors employ dedicated DSP codecs and multimedia
+hardware accelerators, and therefore are often used to offload cpu-intensive
+multimedia tasks from the main application processor.
+
+These remote processors could also be used to control latency-sensitive
+sensors, drive random hardware blocks, or just perform background tasks
+while the main CPU is idling.
+
+Users of those remote processors can either be userland apps (e.g. multimedia
+frameworks talking with remote OMX components) or kernel drivers (controlling
+hardware accessible only by the remote processor, reserving kernel-controlled
+resources on behalf of the remote processor, etc..).
+
+Rpmsg is a virtio-based messaging bus that allows kernel drivers to communicate
+with remote processors available on the system. In turn, drivers could then
+expose appropriate user space interfaces, if needed.
+
+When writing a driver that exposes rpmsg communication to userland, please
+keep in mind that remote processors might have direct access to the
+system's physical memory and/or other sensitive hardware resources (e.g. on
+OMAP4, remote cores (/hardware accelerators) may have direct access to the
+physical memory, gpio banks, dma controllers, i2c bus, gptimers, mailbox
+devices, hwspinlocks, etc..). Moreover, those remote processors might be
+running RTOS where every task can access the entire memory/devices exposed
+to the processor. To minimize the risks of rogue (/buggy) userland code
+exploiting (/triggering) remote bugs, and by that taking over (/down) the
+system, it is often desired to limit userland to specific rpmsg channels (see
+definition below) it is allowed to send messages on, and if possible/relevant,
+minimize the amount of control it has over the content of the messages.
+
+Every rpmsg device is a communication channel with a remote processor (thus
+rpmsg devices are called channels). Channels are identified by a textual name
+and have a local ("source") rpmsg address, and remote ("destination") rpmsg
+address.
+
+When a driver starts listening on a channel, it binds it with a unique
+rpmsg src address (a 32 bits integer). This way when inbound messages arrive
+to this src address, the rpmsg core dispatches them to that driver (by invoking
+the driver's rx handler with the payload of the incoming message).
+
+
+2. User API
+
+  int rpmsg_send(struct rpmsg_channel *rpdev, void *data, int len);
+   - sends a message across to the remote processor on a given channel.
+     The caller should specify the channel, the data it wants to send,
+     and its length (in bytes). The message will be sent on the specified
+     channel, i.e. its source and destination address fields will be
+     set to the channel's src and dst addresses.
+
+     In case there are no TX buffers available, the function will block until
+     one becomes available (i.e. until the remote processor will consume
+     a tx buffer and put it back on virtio's used descriptor ring),
+     or a timeout of 15 seconds elapses. When the latter happens,
+     -ERESTARTSYS is returned.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  int rpmsg_sendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst);
+   - sends a message across to the remote processor on a given channel,
+     to a destination address provided by the caller.
+     The caller should specify the channel, the data it wants to send,
+     its length (in bytes), and an explicit destination address.
+     The message will then be sent to the remote processor to which the
+     channel belongs to, using the channel's src address, and the user-provided
+     dst address (thus the channel's dst address will be ignored).
+
+     In case there are no TX buffers available, the function will block until
+     one becomes available (i.e. until the remote processor will consume
+     a tx buffer and put it back on virtio's used descriptor ring),
+     or a timeout of 15 seconds elapses. When the latter happens,
+     -ERESTARTSYS is returned.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  int rpmsg_send_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
+							void *data, int len);
+   - sends a message across to the remote processor, using the src and dst
+     addresses provided by the user.
+     The caller should specify the channel, the data it wants to send,
+     its length (in bytes), and explicit source and destination addresses.
+     The message will then be sent to the remote processor to which the
+     channel belongs to, but the channel's src and dst addresses will be
+     ignored (and the user-provided addresses will be used instead).
+
+     In case there are no TX buffers available, the function will block until
+     one becomes available (i.e. until the remote processor will consume
+     a tx buffer and put it back on virtio's used descriptor ring),
+     or a timeout of 15 seconds elapses. When the latter happens,
+     -ERESTARTSYS is returned.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  int rpmsg_trysend(struct rpmsg_channel *rpdev, void *data, int len);
+   - sends a message across to the remote processor on a given channel.
+     The caller should specify the channel, the data it wants to send,
+     and its length (in bytes). The message will be sent on the specified
+     channel, i.e. its source and destination address fields will be
+     set to the channel's src and dst addresses.
+
+     In case there are no TX buffers available, the function will immediately
+     return -ENOMEM without waiting until one becomes available.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  int rpmsg_trysendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst)
+   - sends a message across to the remote processor on a given channel,
+     to a destination address provided by the user.
+     The user should specify the channel, the data it wants to send,
+     its length (in bytes), and an explicit destination address.
+     The message will then be sent to the remote processor to which the
+     channel belongs to, using the channel's src address, and the user-provided
+     dst address (thus the channel's dst address will be ignored).
+
+     In case there are no TX buffers available, the function will immediately
+     return -ENOMEM without waiting until one becomes available.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  int rpmsg_trysend_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
+							void *data, int len);
+   - sends a message across to the remote processor, using source and
+     destination addresses provided by the user.
+     The user should specify the channel, the data it wants to send,
+     its length (in bytes), and explicit source and destination addresses.
+     The message will then be sent to the remote processor to which the
+     channel belongs to, but the channel's src and dst addresses will be
+     ignored (and the user-provided addresses will be used instead).
+
+     In case there are no TX buffers available, the function will immediately
+     return -ENOMEM without waiting until one becomes available.
+     The function can only be called from a process context (for now).
+     Returns 0 on success and an appropriate error value on failure.
+
+  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
+		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
+		void *priv, u32 addr);
+   - every rpmsg address in the system is bound to an rx callback (so when
+     inbound messages arrive, they are dispatched by the rpmsg bus using the
+     appropriate callback handler) by means of an rpmsg_endpoint struct.
+
+     This function allows drivers to create such an endpoint, and by that,
+     bind a callback, and possibly some private data too, to an rpmsg address
+     (either one that is known in advance, or one that will be dynamically
+     assigned for them).
+
+     Simple rpmsg drivers need not call rpmsg_create_ept, because an endpoint
+     is already created for them when they are probed by the rpmsg bus
+     (using the rx callback they provide when they registered to the rpmsg bus).
+
+     So things should just work for simple drivers: they already have an
+     endpoint, their rx callback is bound to their rpmsg address, and when
+     relevant inbound messages arrive (i.e. messages which their dst address
+     equals to the src address of their rpmsg channel), the driver's handler
+     is invoked to process it.
+
+     That said, more complicated drivers might do need to allocate
+     additional rpmsg addresses, and bind them to different rx callbacks.
+     To accomplish that, those drivers need to call this function.
+     Driver should provide their channel (so the new endpoint would bind
+     to the same remote processor their channel belongs to), an rx callback
+     function, an optional private data (which is provided back when the
+     rx callback is invoked), and an address they want to bind with the
+     callback. If addr is RPMSG_ADDR_ANY, then rpmsg_create_ept will
+     dynamically assign them an available rpmsg address (drivers should have
+     a very good reason why not to always use RPMSG_ADDR_ANY here).
+
+     Returns a pointer to the endpoint on success, or NULL on error.
+
+  void rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
+   - destroys an existing rpmsg endpoint. user should provide a pointer
+     to an rpmsg endpoint that was previously created with rpmsg_create_ept().
+
+  int register_rpmsg_driver(struct rpmsg_driver *rpdrv);
+   - registers an rpmsg driver with the rpmsg bus. user should provide
+     a pointer to an rpmsg_driver struct, which contains the driver's
+     ->probe() and ->remove() functions, an rx callback, and an id_table
+     specifying the names of the channels this driver is interested to
+     be probed with.
+
+  void unregister_rpmsg_driver(struct rpmsg_driver *rpdrv);
+   - unregisters an rpmsg driver from the rpmsg bus. user should provide
+     a pointer to a previously-registerd rpmsg_driver struct.
+     Returns 0 on success, and an appropriate error value on failure.
+
+
+3. Typical usage
+
+The following is a simple rpmsg driver, that sends an "hello!" message
+on probe(), and whenever it receives an incoming message, it dumps its
+content to the console.
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rpmsg.h>
+
+static void rpmsg_sample_cb(struct rpmsg_channel *rpdev, void *data, int len,
+						void *priv, u32 src)
+{
+	print_hex_dump(KERN_INFO, "incoming message:", DUMP_PREFIX_NONE,
+						16, 1, data, len, true);
+}
+
+static int rpmsg_sample_probe(struct rpmsg_channel *rpdev)
+{
+	int err;
+
+	dev_info(&rpdev->dev, "chnl: 0x%x -> 0x%x\n", rpdev->src, rpdev->dst);
+
+	/* send a message on our channel */
+	err = rpmsg_send(rpdev, "hello!", 6);
+	if (err) {
+		pr_err("rpmsg_send failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __devexit rpmsg_sample_remove(struct rpmsg_channel *rpdev)
+{
+	dev_info(&rpdev->dev, "rpmsg sample client driver is removed\n");
+}
+
+static struct rpmsg_device_id rpmsg_driver_sample_id_table[] = {
+	{ .name	= "rpmsg-client-sample" },
+	{ },
+};
+MODULE_DEVICE_TABLE(rpmsg, rpmsg_driver_sample_id_table);
+
+static struct rpmsg_driver rpmsg_sample_client = {
+	.drv.name	= KBUILD_MODNAME,
+	.drv.owner	= THIS_MODULE,
+	.id_table	= rpmsg_driver_sample_id_table,
+	.probe		= rpmsg_sample_probe,
+	.callback	= rpmsg_sample_cb,
+	.remove		= __devexit_p(rpmsg_sample_remove),
+};
+
+static int __init init(void)
+{
+	return register_rpmsg_driver(&rpmsg_sample_client);
+}
+
+static void __exit fini(void)
+{
+	unregister_rpmsg_driver(&rpmsg_sample_client);
+}
+module_init(init);
+module_exit(fini);
+
+
+4. API for implementors
+
+Adding rpmsg support for a new platform is relatively easy; one just needs
+to register a VIRTIO_ID_RPMSG virtio device with the usual virtio_config_ops
+handlers.
+
+For simplicity, it is recommended to register a single virtio device for
+every physical remote processor we have in the system, but there are no
+hard rules here, and this decision largely depends on the use cases,
+platform capabilities, performance requirements, etc.
+
+OMAP4, e.g., registers two virtio devices to communicate with the remote dual
+Cortex-M3 processor, because each of the M3 cores executes its own OS instance
+(see omap_rpmsg.c for reference).
+This way each of the remote cores may have different rpmsg channels, and the
+rpmsg core will treat them as completely independent processors (despite
+the fact that both of are part of the same physical device, and they are
+powered on/off together).
+
+Notable virtio implementation bits:
+
+* virtio features: VIRTIO_RPMSG_F_NS should be enabled if the remote
+  processor supports dynamic name service announcement messages.
+
+  Enabling this means that rpmsg device (i.e. channel) creation is
+  completely dynamic: the remote processor announces the existence of a
+  remote rpmsg service by sending a name service message (which contains
+  the name and rpmsg addr of the remote service, see struct rpmsg_ns_msg).
+
+  This message is then handled by the rpmsg bus, which in turn dynamically
+  creates and registers an rpmsg channel (which represents the remote service).
+  If/when a relevant rpmsg driver is registered, it will be immediately probed
+  by the bus, and can then start sending messages to the remote service.
+
+* virtqueue's notify handler: should inform the remote processor whenever
+  it is kicked by virtio. OMAP4 is using its mailbox device to interrupt
+  the remote processor, and inform it which virtqueue number is kicked
+  (the index of the kicked virtqueue is written to the mailbox register).
+
+* virtio_config_ops's ->get() handler: the rpmsg bus uses this handler
+  to request for platform-specific configuration values.
+  see enum rpmsg_platform_requests for more info.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1f6d6d3..840f835 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -128,4 +128,5 @@ source "drivers/clocksource/Kconfig"
 
 source "drivers/remoteproc/Kconfig"
 
+source "drivers/rpmsg/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 4d53a18..2980a15 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_ARM_AMBA)		+= amba/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 
 obj-$(CONFIG_VIRTIO)		+= virtio/
+obj-$(CONFIG_RPMSG)		+= rpmsg/
 obj-$(CONFIG_XEN)		+= xen/
 
 # regulators early, since some subsystems rely on them to initialize
diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
new file mode 100644
index 0000000..41303f5
--- /dev/null
+++ b/drivers/rpmsg/Kconfig
@@ -0,0 +1,14 @@
+# RPMSG always gets selected by whoever wants it
+config RPMSG
+	tristate
+	select VIRTIO
+	select VIRTIO_RING
+
+if RPMSG
+
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the rpmsg menu (and it's the approach preferred by the virtio folks).
+
+source "drivers/virtio/Kconfig"
+
+endif # RPMSG
diff --git a/drivers/rpmsg/Makefile b/drivers/rpmsg/Makefile
new file mode 100644
index 0000000..7617fcb
--- /dev/null
+++ b/drivers/rpmsg/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_RPMSG)	+= virtio_rpmsg_bus.o
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
new file mode 100644
index 0000000..3e98b02
--- /dev/null
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -0,0 +1,1036 @@
+/*
+ * Virtio-based remote processor messaging bus
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/rpmsg.h>
+
+/**
+ * struct virtproc_info - virtual remote processor state
+ * @vdev:	the virtio device
+ * @rvq:	rx virtqueue (from pov of local processor)
+ * @svq:	tx virtqueue (from pov of local processor)
+ * @rbufs:	address of rx buffers
+ * @sbufs:	address of tx buffers
+ * @last_sbuf:	index of last tx buffer used
+ * @phys_base:	physical base addr of the buffers
+ * @tx_lock:	protects svq, sbufs and sleepers, to allow concurrent senders
+ * @num_bufs:	total number of buffers allocated for communicating with this
+ *		virtual remote processor. half is used for rx and half for tx.
+ * @buf_size:	size of buffers allocated for communications
+ * @endpoints:	idr of local endpoints, allows fast retrieval
+ * @endpoints_lock: lock of the endpoints set
+ * @sendq:	wait queue of sending contexts waiting for a tx buffers
+ * @sleepers:	number of senders that are waiting for a tx buffer
+ * @ns_ept:	the bus's name service endpoint
+ *
+ * This structure stores the rpmsg state of a given virtio remote processor
+ * device (there might be several virtio proc devices for each physical
+ * remote processor).
+ */
+struct virtproc_info {
+	struct virtio_device *vdev;
+	struct virtqueue *rvq, *svq;
+	void *rbufs, *sbufs;
+	int last_sbuf;
+	phys_addr_t phys_base;
+	spinlock_t tx_lock;
+	int num_bufs;
+	int buf_size;
+	struct idr endpoints;
+	spinlock_t endpoints_lock;
+	wait_queue_head_t sendq;
+	int sleepers;
+	struct rpmsg_endpoint *ns_ept;
+};
+
+#define to_rpmsg_channel(d) container_of(d, struct rpmsg_channel, dev)
+#define to_rpmsg_driver(d) container_of(d, struct rpmsg_driver, drv)
+
+/*
+ * Local addresses are dynamically allocated on-demand.
+ * We do not dynamically assign addresses from the low 1024 range,
+ * in order to reserve that address range for predefined services.
+ */
+#define RPMSG_RESERVED_ADDRESSES	(1024)
+
+/* Address 53 is reserved for advertising remote services */
+#define RPMSG_NS_ADDR			(53)
+
+/* show configuration fields */
+#define rpmsg_show_attr(field, path, format_string)			\
+static ssize_t								\
+field##_show(struct device *dev,					\
+			struct device_attribute *attr, char *buf)	\
+{									\
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);		\
+									\
+	return sprintf(buf, format_string, rpdev->path);		\
+}
+
+/* for more info, see Documentation/ABI/testing/sysfs-bus-rpmsg */
+rpmsg_show_attr(name, id.name, "%s\n");
+rpmsg_show_attr(src, src, "0x%x\n");
+rpmsg_show_attr(dst, dst, "0x%x\n");
+rpmsg_show_attr(announce, announce ? "true" : "false", "%s\n");
+
+/* unique (free running) index for rpmsg devices */
+static unsigned int rpmsg_dev_index;
+
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+
+	return sprintf(buf, RPMSG_DEVICE_MODALIAS_FMT "\n", rpdev->id.name);
+}
+
+static struct device_attribute rpmsg_dev_attrs[] = {
+	__ATTR_RO(name),
+	__ATTR_RO(modalias),
+	__ATTR_RO(dst),
+	__ATTR_RO(src),
+	__ATTR_RO(announce),
+	__ATTR_NULL
+};
+
+/* rpmsg devices and drivers are matched using the service name */
+static inline int rpmsg_id_match(const struct rpmsg_channel *rpdev,
+				  const struct rpmsg_device_id *id)
+{
+	if (strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE))
+		return 0;
+
+	return 1;
+}
+
+/* match rpmsg channel and rpmsg driver */
+static int rpmsg_dev_match(struct device *dev, struct device_driver *drv)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+	struct rpmsg_driver *rpdrv = to_rpmsg_driver(drv);
+	const struct rpmsg_device_id *ids = rpdrv->id_table;
+	unsigned int i;
+
+	for (i = 0; ids[i].name[0]; i++) {
+		if (rpmsg_id_match(rpdev, &ids[i]))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int rpmsg_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+
+	return add_uevent_var(env, "MODALIAS=" RPMSG_DEVICE_MODALIAS_FMT,
+					rpdev->id.name);
+}
+
+/* for more info, see below documentation of rpmsg_create_ept() */
+static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
+		struct rpmsg_channel *rpdev,
+		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
+		void *priv, u32 addr)
+{
+	int err, tmpaddr, request;
+	struct rpmsg_endpoint *ept;
+	struct device *dev = rpdev ? &rpdev->dev : &vrp->vdev->dev;
+
+	if (!idr_pre_get(&vrp->endpoints, GFP_KERNEL))
+		return NULL;
+
+	ept = kzalloc(sizeof(*ept), GFP_KERNEL);
+	if (!ept) {
+		dev_err(dev, "failed to kzalloc a new ept\n");
+		return NULL;
+	}
+
+	ept->rpdev = rpdev;
+	ept->cb = cb;
+	ept->priv = priv;
+
+	/* do we need to allocate a local address ? */
+	request = addr == RPMSG_ADDR_ANY ? RPMSG_RESERVED_ADDRESSES : addr;
+
+	spin_lock(&vrp->endpoints_lock);
+
+	/* bind the endpoint to an rpmsg address (and allocate one if needed) */
+	err = idr_get_new_above(&vrp->endpoints, ept, request, &tmpaddr);
+	if (err) {
+		dev_err(dev, "idr_get_new_above failed: %d\n", err);
+		goto free_ept;
+	}
+
+	/* make sure the user's address request is fulfilled, if relevant */
+	if (addr != RPMSG_ADDR_ANY && tmpaddr != addr) {
+		dev_err(dev, "address 0x%x already in use\n", addr);
+		goto rem_idr;
+	}
+
+	ept->addr = tmpaddr;
+
+	spin_unlock(&vrp->endpoints_lock);
+
+	return ept;
+
+rem_idr:
+	idr_remove(&vrp->endpoints, request);
+free_ept:
+	spin_unlock(&vrp->endpoints_lock);
+	kfree(ept);
+	return NULL;
+}
+
+/**
+ * rpmsg_create_ept() - create a new rpmsg_endpoint
+ * @rpdev: rpmsg channel device
+ * @cb: rx callback handler
+ * @priv: private data for the driver's use
+ * @addr: local rpmsg address to bind with @cb
+ *
+ * Every rpmsg address in the system is bound to an rx callback (so when
+ * inbound messages arrive, they are dispatched by the rpmsg bus using the
+ * appropriate callback handler) by means of an rpmsg_endpoint struct.
+ *
+ * This function allows drivers to create such an endpoint, and by that,
+ * bind a callback, and possibly some private data too, to an rpmsg address
+ * (either one that is known in advance, or one that will be dynamically
+ * assigned for them).
+ *
+ * Simple rpmsg drivers need not call rpmsg_create_ept, because an endpoint
+ * is already created for them when they are probed by the rpmsg bus
+ * (using the rx callback provided when they registered to the rpmsg bus).
+ *
+ * So things should just work for simple drivers: they already have an
+ * endpoint, their rx callback is bound to their rpmsg address, and when
+ * relevant inbound messages arrive (i.e. messages which their dst address
+ * equals to the src address of their rpmsg channel), the driver's handler
+ * is invoked to process it.
+ *
+ * That said, more complicated drivers might do need to allocate
+ * additional rpmsg addresses, and bind them to different rx callbacks.
+ * To accomplish that, those drivers need to call this function.
+ *
+ * Drivers should provide their @rpdev channel (so the new endpoint would belong
+ * to the same remote processor their channel belongs to), an rx callback
+ * function, an optional private data (which is provided back when the
+ * rx callback is invoked), and an address they want to bind with the
+ * callback. If @addr is RPMSG_ADDR_ANY, then rpmsg_create_ept will
+ * dynamically assign them an available rpmsg address (drivers should have
+ * a very good reason why not to always use RPMSG_ADDR_ANY here).
+ *
+ * Returns a pointer to the endpoint on success, or NULL on error.
+ */
+struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
+		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
+		void *priv, u32 addr)
+{
+	return __rpmsg_create_ept(rpdev->vrp, rpdev, cb, priv, addr);
+}
+EXPORT_SYMBOL(rpmsg_create_ept);
+
+/**
+ * rpmsg_destroy_ept() - destroy an existing rpmsg endpoint
+ * @ept: endpoing to destroy
+ *
+ * Should be used by drivers to destroy an rpmsg endpoint previously
+ * created with rpmsg_create_ept().
+ */
+void rpmsg_destroy_ept(struct rpmsg_endpoint *ept)
+{
+	struct virtproc_info *vrp = ept->rpdev->vrp;
+
+	spin_lock(&vrp->endpoints_lock);
+	idr_remove(&vrp->endpoints, ept->addr);
+	spin_unlock(&vrp->endpoints_lock);
+
+	kfree(ept);
+}
+EXPORT_SYMBOL(rpmsg_destroy_ept);
+
+/*
+ * when an rpmsg driver is probed with a channel, we seamlessly create
+ * it an endpoint, binding its rx callback to a unique local rpmsg
+ * address.
+ *
+ * if we need to, we also announce about this channel to the remote
+ * processor (needed in case the driver is exposing an rpmsg service).
+ */
+static int rpmsg_dev_probe(struct device *dev)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
+	struct virtproc_info *vrp = rpdev->vrp;
+	struct rpmsg_endpoint *ept;
+	int err;
+
+	ept = rpmsg_create_ept(rpdev, rpdrv->callback, NULL, rpdev->src);
+	if (!ept) {
+		dev_err(dev, "failed to create endpoint\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rpdev->ept = ept;
+	rpdev->src = ept->addr;
+
+	err = rpdrv->probe(rpdev);
+	if (err) {
+		dev_err(dev, "%s: failed: %d\n", __func__, err);
+		rpmsg_destroy_ept(ept);
+		goto out;
+	}
+
+	/* need to tell remote processor's name service about this channel ? */
+	if (rpdev->announce &&
+			virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
+		struct rpmsg_ns_msg nsm;
+
+		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		nsm.addr = rpdev->src;
+		nsm.flags = RPMSG_NS_CREATE;
+
+		err = rpmsg_sendto(rpdev, &nsm, sizeof(nsm), RPMSG_NS_ADDR);
+		if (err)
+			dev_err(dev, "failed to announce service %d\n", err);
+	}
+
+out:
+	return err;
+}
+
+static int rpmsg_dev_remove(struct device *dev)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpdev->dev.driver);
+	struct virtproc_info *vrp = rpdev->vrp;
+	int err = 0;
+
+	/* tell remote processor's name service we're removing this channel */
+	if (rpdev->announce &&
+			virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
+		struct rpmsg_ns_msg nsm;
+
+		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		nsm.addr = rpdev->src;
+		nsm.flags = RPMSG_NS_DESTROY;
+
+		err = rpmsg_sendto(rpdev, &nsm, sizeof(nsm), RPMSG_NS_ADDR);
+		if (err)
+			dev_err(dev, "failed to announce service %d\n", err);
+	}
+
+	rpdrv->remove(rpdev);
+
+	rpmsg_destroy_ept(rpdev->ept);
+
+	return err;
+}
+
+static struct bus_type rpmsg_bus = {
+	.name		= "rpmsg",
+	.match		= rpmsg_dev_match,
+	.dev_attrs	= rpmsg_dev_attrs,
+	.uevent		= rpmsg_uevent,
+	.probe		= rpmsg_dev_probe,
+	.remove		= rpmsg_dev_remove,
+};
+
+/**
+ * register_rpmsg_driver() - register an rpmsg driver with the rpmsg bus
+ * @rpdrv: pointer to a struct rpmsg_driver
+ *
+ * Returns 0 on success, and an appropriate error value on failure.
+ */
+int register_rpmsg_driver(struct rpmsg_driver *rpdrv)
+{
+	rpdrv->drv.bus = &rpmsg_bus;
+	return driver_register(&rpdrv->drv);
+}
+EXPORT_SYMBOL(register_rpmsg_driver);
+
+/**
+ * unregister_rpmsg_driver() - unregister an rpmsg driver from the rpmsg bus
+ * @rpdrv: pointer to a struct rpmsg_driver
+ *
+ * Returns 0 on success, and an appropriate error value on failure.
+ */
+void unregister_rpmsg_driver(struct rpmsg_driver *rpdrv)
+{
+	driver_unregister(&rpdrv->drv);
+}
+EXPORT_SYMBOL(unregister_rpmsg_driver);
+
+static void rpmsg_release_device(struct device *dev)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+
+	kfree(rpdev);
+}
+
+/*
+ * match an rpmsg channel with a channel info struct.
+ * this is used to make sure we're not creating rpmsg devices for channels
+ * that already exist.
+ */
+static int rpmsg_channel_match(struct device *dev, void *data)
+{
+	struct rpmsg_channel_info *chinfo = data;
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+
+	if (chinfo->src != RPMSG_ADDR_ANY && chinfo->src != rpdev->src)
+		return 0;
+
+	if (chinfo->dst != RPMSG_ADDR_ANY && chinfo->dst != rpdev->dst)
+		return 0;
+
+	if (strncmp(chinfo->name, rpdev->id.name, RPMSG_NAME_SIZE))
+		return 0;
+
+	/* found a match ! */
+	return 1;
+}
+
+/*
+ * create an rpmsg channel using its name and address info.
+ * this function will be used to create both static and dynamic
+ * channels.
+ */
+static struct rpmsg_channel *rpmsg_create_channel(struct virtproc_info *vrp,
+				struct rpmsg_channel_info *chinfo)
+{
+	struct rpmsg_channel *rpdev;
+	struct device *tmp, *dev = &vrp->vdev->dev;
+	int ret;
+
+	/* make sure a similar channel doesn't already exist */
+	tmp = device_find_child(dev, chinfo, rpmsg_channel_match);
+	if (tmp) {
+		/* decrement the matched device's refcount back */
+		put_device(tmp);
+		dev_err(dev, "channel %s:%x:%x already exist\n",
+				chinfo->name, chinfo->src, chinfo->dst);
+		return NULL;
+	}
+
+	rpdev = kzalloc(sizeof(struct rpmsg_channel), GFP_KERNEL);
+	if (!rpdev) {
+		pr_err("kzalloc failed\n");
+		return NULL;
+	}
+
+	rpdev->vrp = vrp;
+	rpdev->src = chinfo->src;
+	rpdev->dst = chinfo->dst;
+
+	/*
+	 * rpmsg server channels has predefined local address (for now),
+	 * and their existence needs to be announced remotely
+	 */
+	rpdev->announce = rpdev->src != RPMSG_ADDR_ANY ? true : false;
+
+	strncpy(rpdev->id.name, chinfo->name, RPMSG_NAME_SIZE);
+
+	/* very simple device indexing plumbing which is enough for now */
+	dev_set_name(&rpdev->dev, "rpmsg%d", rpmsg_dev_index++);
+
+	rpdev->dev.parent = &vrp->vdev->dev;
+	rpdev->dev.bus = &rpmsg_bus;
+	rpdev->dev.release = rpmsg_release_device;
+
+	ret = device_register(&rpdev->dev);
+	if (ret) {
+		dev_err(dev, "device_register failed: %d\n", ret);
+		kfree(rpdev);
+		return NULL;
+	}
+
+	return rpdev;
+}
+
+/*
+ * find an existing channel using its name + address properties,
+ * and destroy it
+ */
+static int rpmsg_destroy_channel(struct virtproc_info *vrp,
+					struct rpmsg_channel_info *chinfo)
+{
+	struct virtio_device *vdev = vrp->vdev;
+	struct device *dev;
+
+	dev = device_find_child(&vdev->dev, chinfo, rpmsg_channel_match);
+	if (!dev)
+		return -EINVAL;
+
+	device_unregister(dev);
+
+	put_device(dev);
+
+	kfree(to_rpmsg_channel(dev));
+
+	return 0;
+}
+
+/* super simple buffer "allocator" that is just enough for now */
+static void *get_a_tx_buf(struct virtproc_info *vrp)
+{
+	unsigned int len;
+	void *ret;
+
+	/* support multiple concurrent senders */
+	spin_lock(&vrp->tx_lock);
+
+	/*
+	 * either pick the next unused tx buffer
+	 * (half of our buffers are used for sending messages)
+	 */
+	if (vrp->last_sbuf < vrp->num_bufs / 2)
+		ret = vrp->sbufs + vrp->buf_size * vrp->last_sbuf++;
+	/* or recycle a used one */
+	else
+		ret = virtqueue_get_buf(vrp->svq, &len);
+
+	spin_unlock(&vrp->tx_lock);
+
+	return ret;
+}
+
+/**
+ * rpmsg_upref_sleepers() - enable "tx-complete" interrupts, if needed
+ * @vrp: virtual remote processor state
+ *
+ * This function is called before a sender is blocked, waiting for
+ * a tx buffer to become available.
+ *
+ * If we already have blocking senders, this function merely increases
+ * the "sleepers" reference count, and exits.
+ *
+ * Otherwise, if this is the first sender to block, we also enable
+ * virtio's tx callbacks, so we'd be immediately notified when a tx
+ * buffer is consumed (we rely on virtio's tx callback in order
+ * to wake up sleeping senders as soon as a tx buffer is used by the
+ * remote processor).
+ */
+static void rpmsg_upref_sleepers(struct virtproc_info *vrp)
+{
+	/* support multiple concurrent senders */
+	spin_lock(&vrp->tx_lock);
+
+	/* are we the first sleeping context waiting for tx buffers ? */
+	if (!vrp->sleepers++)
+		/* enable "tx-complete" interrupts before dozing off */
+		virtqueue_enable_cb(vrp->svq);
+
+	spin_unlock(&vrp->tx_lock);
+}
+
+/**
+ * rpmsg_downref_sleepers() - disable "tx-complete" interrupts, if needed
+ * @vrp: virtual remote processor state
+ *
+ * This function is called after a sender, that waited for a tx buffer
+ * to become available, is unblocked.
+ *
+ * If we still have blocking senders, this function merely decreases
+ * the "sleepers" reference count, and exits.
+ *
+ * Otherwise, if there are no more blocking senders, we also disable
+ * virtio's tx callbacks, to avoid the overhead incurred with handling
+ * those (now redundant) interrupts.
+ */
+static void rpmsg_downref_sleepers(struct virtproc_info *vrp)
+{
+	/* support multiple concurrent senders */
+	spin_lock(&vrp->tx_lock);
+
+	/* are we the last sleeping context waiting for tx buffers ? */
+	if (!--vrp->sleepers)
+		/* disable "tx-complete" interrupts */
+		virtqueue_disable_cb(vrp->svq);
+
+	spin_unlock(&vrp->tx_lock);
+}
+
+/**
+ * rpmsg_send_offchannel_raw() - send a message across to the remote processor
+ * @rpdev: the rpmsg channel
+ * @src: source address
+ * @dst: destination address
+ * @data: payload of message
+ * @len: length of payload
+ * @wait: indicates whether caller should block in case no TX buffers available
+ *
+ * This function is the base implementation for all of the rpmsg sending API.
+ *
+ * It will send @data of length @len to @dst, and say it's from @src. The
+ * message will be sent to the remote processor which the @rpdev channel
+ * belongs to.
+ *
+ * The message is sent using one of the TX buffers that are available for
+ * communication with this remote processor.
+ *
+ * If @wait is true, the caller will be blocked until either a TX buffer is
+ * available, or 15 seconds elapses (we don't want callers to
+ * sleep indefinitely due to misbehaving remote processors), and in that
+ * case -ERESTARTSYS is returned. The number '15' itself was picked
+ * arbitrarily; there's little point in asking drivers to provide a timeout
+ * value themselves.
+ *
+ * Otherwise, if @wait is false, and there are no TX buffers available,
+ * the function will immediately fail, and -ENOMEM will be returned.
+ *
+ * Normally drivers shouldn't use this function directly; instead, drivers
+ * should use the appropriate rpmsg_{try}send{to, _offchannel} API
+ * (see include/linux/rpmsg.h).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
+					void *data, int len, bool wait)
+{
+	struct virtproc_info *vrp = rpdev->vrp;
+	struct device *dev = &rpdev->dev;
+	struct scatterlist sg;
+	struct rpmsg_hdr *msg;
+	int err;
+	unsigned long offset;
+	phys_addr_t phys_addr;
+
+	if (src == RPMSG_ADDR_ANY || dst == RPMSG_ADDR_ANY) {
+		dev_err(dev, "invalid addr (src 0x%x, dst 0x%x)\n", src, dst);
+		return -EINVAL;
+	}
+
+	/*
+	 * The size of the payload is currently limited according to the
+	 * buffers size picked by the platform.
+	 *
+	 * One of the possible improvements here is either to support
+	 * user-provided buffers (and then we can also support zero-copy
+	 * messaging), or to improve the buffer allocator, to support
+	 * variable-length buffer sizes.
+	 */
+	if (len > vrp->buf_size - sizeof(struct rpmsg_hdr)) {
+		dev_err(dev, "message is too big (%d)\n", len);
+		return -EMSGSIZE;
+	}
+
+	/* grab a buffer */
+	msg = get_a_tx_buf(vrp);
+	if (!msg && !wait)
+		return -ENOMEM;
+
+	/* no free buffer ? wait for one (but bail after 15 seconds) */
+	while (!msg) {
+		/* enable "tx-complete" interrupts, if not already enabled */
+		rpmsg_upref_sleepers(vrp);
+
+		/*
+		 * sleep until a free buffer is available or 15 secs elapse.
+		 * the timeout period is not configurable because there's
+		 * little point in asking drivers to specify that.
+		 * if later this happens to be required, it'd be easy to add.
+		 */
+		err = wait_event_interruptible_timeout(vrp->sendq,
+					(msg = get_a_tx_buf(vrp)),
+					msecs_to_jiffies(15000));
+
+		/* disable "tx-complete" interrupts if we're the last sleeper */
+		rpmsg_downref_sleepers(vrp);
+
+		/* timeout ? */
+		if (!err) {
+			dev_err(dev, "timeout waiting for a tx buffer\n");
+			return -ERESTARTSYS;
+		}
+	}
+
+	msg->len = len;
+	msg->flags = 0;
+	msg->src = src;
+	msg->dst = dst;
+	msg->reserved = 0;
+	memcpy(msg->data, data, len);
+
+	dev_dbg(dev, "TX From 0x%x, To 0x%x, Len %d, Flags %d, Reserved %d\n",
+					msg->src, msg->dst, msg->len,
+					msg->flags, msg->reserved);
+	print_hex_dump(KERN_DEBUG, "rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
+					msg, sizeof(*msg) + msg->len, true);
+
+	offset = ((unsigned long) msg) - ((unsigned long) vrp->rbufs);
+
+	phys_addr = vrp->phys_base + offset;
+
+	sg_init_table(&sg, 1);
+
+	/*
+	 * can't use sg_set_buf because buffers might not be residing
+	 * in virt_to_page()-able memory.
+	 * revisit this to achieve a cleaner solution (e.g. DMA API).
+	 */
+	sg_set_page(&sg, phys_to_page(phys_addr), sizeof(*msg) + len,
+						offset_in_page(phys_addr));
+
+	spin_lock(&vrp->tx_lock);
+
+	/* add message to the remote processor's virtqueue */
+	err = virtqueue_add_buf_gfp(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
+	if (err < 0) {
+		/*
+		 * need to reclaim the buffer here, otherwise it's lost
+		 * (memory won't leak, but rpmsg won't use it again for TX).
+		 * this will wait for a buffer management overhaul.
+		 */
+		dev_err(dev, "virtqueue_add_buf_gfp failed: %d\n", err);
+		goto out;
+	}
+
+	/* tell the remote processor it has a pending message to read */
+	virtqueue_kick(vrp->svq);
+
+	err = 0;
+out:
+	spin_unlock(&vrp->tx_lock);
+	return err;
+}
+EXPORT_SYMBOL(rpmsg_send_offchannel_raw);
+
+/* called when an rx buffer is used, and it's time to digest a message */
+static void rpmsg_recv_done(struct virtqueue *rvq)
+{
+	struct rpmsg_hdr *msg;
+	unsigned int len;
+	struct rpmsg_endpoint *ept;
+	struct scatterlist sg;
+	unsigned long offset;
+	phys_addr_t phys_addr;
+	struct virtproc_info *vrp = rvq->vdev->priv;
+	struct device *dev = &rvq->vdev->dev;
+	int err;
+
+	msg = virtqueue_get_buf(rvq, &len);
+	if (!msg) {
+		dev_err(dev, "uhm, incoming signal, but no used buffer ?\n");
+		return;
+	}
+
+	dev_dbg(dev, "From: 0x%x, To: 0x%x, Len: %d, Flags: %d, Reserved: %d\n",
+					msg->src, msg->dst, msg->len,
+					msg->flags, msg->reserved);
+	print_hex_dump(KERN_DEBUG, "rpmsg_virtio RX: ", DUMP_PREFIX_NONE, 16, 1,
+					msg, sizeof(*msg) + msg->len, true);
+
+	/* use the dst addr to fetch the callback of the appropriate user */
+	spin_lock(&vrp->endpoints_lock);
+	ept = idr_find(&vrp->endpoints, msg->dst);
+	spin_unlock(&vrp->endpoints_lock);
+
+	if (ept && ept->cb)
+		ept->cb(ept->rpdev, msg->data, msg->len, ept->priv, msg->src);
+	else
+		dev_warn(dev, "msg received with no recepient\n");
+
+	/* add the buffer back to the remote processor's virtqueue */
+	offset = ((unsigned long) msg) - ((unsigned long) vrp->rbufs);
+	phys_addr = vrp->phys_base + offset;
+
+	sg_init_table(&sg, 1);
+
+	/*
+	 * can't use sg_set_buf because buffers might not be residing
+	 * in virt_to_page()-able memory.
+	 * revisit this to achieve a cleaner solution.
+	 */
+	sg_set_page(&sg, phys_to_page(phys_addr), sizeof(*msg) + len,
+						offset_in_page(phys_addr));
+
+	err = virtqueue_add_buf_gfp(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
+	if (err < 0) {
+		dev_err(dev, "failed to add a virtqueue buffer: %d\n", err);
+		return;
+	}
+
+	/* tell the remote processor we added another available rx buffer */
+	virtqueue_kick(vrp->rvq);
+}
+
+/*
+ * This is invoked whenever the remote processor completed processing
+ * a TX msg we just sent it, and the buffer is put back to the used ring.
+ *
+ * Normally, though, we suppress this "tx complete" interrupt in order to
+ * avoid the incurred overhead.
+ */
+static void rpmsg_xmit_done(struct virtqueue *svq)
+{
+	struct virtproc_info *vrp = svq->vdev->priv;
+
+	dev_dbg(&svq->vdev->dev, "%s\n", __func__);
+
+	/* wake up potential senders that are waiting for a tx buffer */
+	wake_up_interruptible(&vrp->sendq);
+}
+
+/* invoked when a name service announcement arrives */
+static void rpmsg_ns_cb(struct rpmsg_channel *rpdev, void *data, int len,
+							void *priv, u32 src)
+{
+	struct rpmsg_ns_msg *msg = data;
+	struct rpmsg_channel *newch;
+	struct rpmsg_channel_info chinfo;
+	struct virtproc_info *vrp = priv;
+	struct device *dev = &vrp->vdev->dev;
+	int ret;
+
+	print_hex_dump(KERN_DEBUG, "NS announcement: ",
+			DUMP_PREFIX_NONE, 16, 1,
+			data, len, true);
+
+	if (len != sizeof(*msg)) {
+		dev_err(dev, "malformed ns msg (%d)\n", len);
+		return;
+	}
+
+	/*
+	 * the name service ept does _not_ belong to a real rpmsg channel,
+	 * and is handled by the rpmsg bus itself.
+	 * for sanity reasons, make sure a valid rpdev has _not_ sneaked
+	 * in somehow.
+	 */
+	if (rpdev) {
+		dev_err(dev, "anomaly: ns ept has an rpdev handle\n");
+		return;
+	}
+
+	/* don't trust the remote processor for null terminating the name */
+	msg->name[RPMSG_NAME_SIZE - 1] = '\0';
+
+	dev_info(dev, "%sing channel %s addr 0x%x\n",
+			msg->flags & RPMSG_NS_DESTROY ? "destroy" : "creat",
+			msg->name, msg->addr);
+
+	strncpy(chinfo.name, msg->name, sizeof(chinfo.name));
+	chinfo.src = RPMSG_ADDR_ANY;
+	chinfo.dst = msg->addr;
+
+	if (msg->flags & RPMSG_NS_DESTROY) {
+		ret = rpmsg_destroy_channel(vrp, &chinfo);
+		if (ret)
+			dev_err(dev, "rpmsg_destroy_channel failed: %d\n", ret);
+	} else {
+		newch = rpmsg_create_channel(vrp, &chinfo);
+		if (!newch)
+			dev_err(dev, "rpmsg_create_channel failed\n");
+	}
+}
+
+static int rpmsg_probe(struct virtio_device *vdev)
+{
+	vq_callback_t *vq_cbs[] = { rpmsg_recv_done, rpmsg_xmit_done };
+	const char *names[] = { "input", "output" };
+	struct virtqueue *vqs[2];
+	struct virtproc_info *vrp;
+	void *addr;
+	int err, i, num_bufs, buf_size, total_buf_size;
+	struct rpmsg_channel_info *ch;
+
+	vrp = kzalloc(sizeof(*vrp), GFP_KERNEL);
+	if (!vrp)
+		return -ENOMEM;
+
+	vrp->vdev = vdev;
+
+	idr_init(&vrp->endpoints);
+	spin_lock_init(&vrp->endpoints_lock);
+	spin_lock_init(&vrp->tx_lock);
+	init_waitqueue_head(&vrp->sendq);
+
+	/* We expect two virtqueues, rx and tx (and in this order) */
+	err = vdev->config->find_vqs(vdev, 2, vqs, vq_cbs, names);
+	if (err)
+		goto free_vi;
+
+	vrp->rvq = vqs[0];
+	vrp->svq = vqs[1];
+
+	/* Platform must supply pre-allocated uncached buffers for now */
+	vdev->config->get(vdev, VPROC_BUF_ADDR, &addr, sizeof(addr));
+	vdev->config->get(vdev, VPROC_BUF_NUM, &num_bufs, sizeof(num_bufs));
+	vdev->config->get(vdev, VPROC_BUF_SZ, &buf_size, sizeof(buf_size));
+	vdev->config->get(vdev, VPROC_BUF_PADDR, &vrp->phys_base,
+						sizeof(vrp->phys_base));
+
+	total_buf_size = num_bufs * buf_size;
+
+	dev_dbg(&vdev->dev, "%d buffers, size %d, addr 0x%x, total 0x%x\n",
+		num_bufs, buf_size, (unsigned int) addr, total_buf_size);
+
+	vrp->num_bufs = num_bufs;
+	vrp->buf_size = buf_size;
+
+	/* the first half of the buffers is dedicated for RX */
+	vrp->rbufs = addr;
+
+	/* the second half of the buffers is dedicated for TX */
+	vrp->sbufs = addr + total_buf_size / 2;
+
+	/* set up the receive buffers */
+	for (i = 0; i < num_bufs / 2; i++) {
+		struct scatterlist sg;
+		void *cpu_addr = vrp->rbufs + i * buf_size;
+		phys_addr_t phys_addr = vrp->phys_base + i * buf_size;
+
+		sg_init_table(&sg, 1);
+
+		/*
+		 * can't use sg_set_buf because buffers might not be residing
+		 * in virt_to_page()-able memory.
+		 * revisit this to achieve a cleaner solution.
+		 */
+		sg_set_page(&sg, phys_to_page(phys_addr), buf_size,
+						offset_in_page(phys_addr));
+
+		err = virtqueue_add_buf_gfp(vrp->rvq, &sg, 0, 1, cpu_addr,
+								GFP_KERNEL);
+		WARN_ON(err < 0); /* sanity check; this can't really happen */
+	}
+
+	/* suppress "tx-complete" interrupts */
+	virtqueue_disable_cb(vrp->svq);
+
+	vdev->priv = vrp;
+
+	/* if supported by the remote processor, enable the name service */
+	if (virtio_has_feature(vdev, VIRTIO_RPMSG_F_NS)) {
+		/* a dedicated endpoint handles the name service msgs */
+		vrp->ns_ept = __rpmsg_create_ept(vrp, NULL, rpmsg_ns_cb,
+						vrp, RPMSG_NS_ADDR);
+		if (!vrp->ns_ept) {
+			dev_err(&vdev->dev, "failed to create the ns ept\n");
+			err = -ENOMEM;
+			goto vqs_del;
+		}
+	}
+
+	/* tell the remote processor it can start sending messages */
+	virtqueue_kick(vrp->rvq);
+
+	/* do we have a platform-specific static channels table ? */
+	vdev->config->get(vdev, VPROC_STATIC_CHANNELS, &ch, sizeof(ch));
+
+	/* if we do, create the appropriate channels */
+	for (i = 0; ch && ch[i].name[0]; i++)
+		rpmsg_create_channel(vrp, &ch[i]);
+
+	dev_info(&vdev->dev, "rpmsg backend virtproc probed successfully\n");
+
+	return 0;
+
+vqs_del:
+	vdev->config->del_vqs(vrp->vdev);
+free_vi:
+	kfree(vrp);
+	return err;
+}
+
+static int rpmsg_remove_device(struct device *dev, void *data)
+{
+	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
+
+	device_unregister(dev);
+
+	kfree(rpdev);
+
+	return 0;
+}
+
+static void __devexit rpmsg_remove(struct virtio_device *vdev)
+{
+	struct virtproc_info *vrp = vdev->priv;
+	int ret;
+
+	ret = device_for_each_child(&vdev->dev, NULL, rpmsg_remove_device);
+	if (ret)
+		dev_warn(&vdev->dev, "can't remove rpmsg device: %d\n", ret);
+
+	idr_remove_all(&vrp->endpoints);
+	idr_destroy(&vrp->endpoints);
+
+	vdev->config->del_vqs(vrp->vdev);
+
+	kfree(vrp);
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static unsigned int features[] = {
+	VIRTIO_RPMSG_F_NS,
+};
+
+static struct virtio_driver virtio_ipc_driver = {
+	.feature_table	= features,
+	.feature_table_size = ARRAY_SIZE(features),
+	.driver.name	= KBUILD_MODNAME,
+	.driver.owner	= THIS_MODULE,
+	.id_table	= id_table,
+	.probe		= rpmsg_probe,
+	.remove		= __devexit_p(rpmsg_remove),
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret = bus_register(&rpmsg_bus);
+	if (ret) {
+		pr_err("failed to register rpmsg bus: %d\n", ret);
+		return ret;
+	}
+
+	return register_virtio_driver(&virtio_ipc_driver);
+}
+module_init(init);
+
+static void __exit fini(void)
+{
+	unregister_virtio_driver(&virtio_ipc_driver);
+	bus_unregister(&rpmsg_bus);
+}
+module_exit(fini);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio-based remote processor messaging bus");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ae28e93..561567e 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -533,4 +533,14 @@ struct isapnp_device_id {
 	kernel_ulong_t driver_data;	/* data private to the driver */
 };
 
+/* rpmsg */
+
+#define RPMSG_NAME_SIZE			32
+#define RPMSG_DEVICE_MODALIAS_FMT	"rpmsg:%s"
+
+struct rpmsg_device_id {
+	char name[RPMSG_NAME_SIZE];
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
new file mode 100644
index 0000000..73f9231
--- /dev/null
+++ b/include/linux/rpmsg.h
@@ -0,0 +1,421 @@
+/*
+ * Remote processor messaging
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * * Redistributions of source code must retain the above copyright
+ *   notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the
+ *   distribution.
+ * * Neither the name Texas Instruments nor the names of its
+ *   contributors may be used to endorse or promote products derived
+ *   from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _LINUX_RPMSG_H
+#define _LINUX_RPMSG_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+
+/* The feature bitmap for virtio rpmsg */
+#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
+
+/**
+ * struct rpmsg_hdr - common header for all rpmsg messages
+ * @src: source address
+ * @dst: destination address
+ * @reserved: reserved for future use
+ * @len: length of payload (in bytes)
+ * @flags: message flags
+ * @data: @len bytes of message payload data
+ *
+ * Every message sent(/received) on the rpmsg bus begins with this header.
+ */
+struct rpmsg_hdr {
+	u32 src;
+	u32 dst;
+	u32 reserved;
+	u16 len;
+	u16 flags;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct rpmsg_ns_msg - dynamic name service announcement message
+ * @name: name of remote service that is published
+ * @addr: address of remote service that is published
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent across to publish a new service (or announce
+ * about its removal). When Linux receives these messages, an appropriate
+ * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
+ * or ->remove() handler of the appropriate rpmsg driver will be invoked
+ * (if/as-soon-as one is registered).
+ */
+struct rpmsg_ns_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 addr;
+	u32 flags;
+} __packed;
+
+/**
+ * struct rpmsg_ns_flags - dynamic name service announcement flags
+ *
+ * @RPMSG_NS_CREATE: a new remote service was just created
+ * @RPMSG_NS_DESTROY: a known remote service was just destroyed
+ */
+enum rpmsg_ns_flags {
+	RPMSG_NS_CREATE		= 0,
+	RPMSG_NS_DESTROY	= 1,
+};
+
+/**
+ * enum rpmsg_platform_requests - platform-specific rpmsg configuration requests
+ *
+ * These configuration requests are required by the rpmsg bus, and must be
+ * implemented by the platform-specific rpmsg backend.
+ *
+ * @VPROC_BUF_ADDR: Kernel virtual address of an uncached memory region,
+ *		    shared with the remote processor, that will be splitted
+ *		    to buffers and then used to send messages across to the
+ *		    remote processor. Those buffers will be added to the
+ *		    appropriate vrings by the rpmsg bus in order to send and
+ *		    receive messages.
+ *
+ * @VPROC_BUF_PADDR: Physical address of the above memory region, needed
+ *		     for the "wire" protocol between the two processors
+ *		     (i.e. for the vring's buffer descriptors).
+ *
+ * @VPROC_BUF_NUM: Number of buffers to split the shared memory region to
+ * @VPROC_BUF_SZ: Size of each buffer that the shared memory region will be
+ *		  split into. It is the responsibility of the underlying
+ *		  implementation to make sure that the size of the memory
+ *		  region provided by @VPROC_BUF_ADDR is exactly
+ *		  @VPROC_BUF_NUM * @VPROC_BUF_SZ bytes.
+ *
+ * @VPROC_STATIC_CHANNELS: Table of static channels that this platform
+ *			   expects to have. See struct rpmsg_channel_info
+ *			   for additional information.
+ *			   This configuration is optional: it is perfectly
+ *			   fine not to have any pre-configured static channels.
+ *
+ * The number and size of buffers to use are considered platform-specific,
+ * because this is strongly tied with the performance/functionality
+ * requirements of the specific use cases that the platform needs rpmsg
+ * for. This should be revisited when we'll have a bigger requirement
+ * picture.
+ *
+ * We might also want to add support for user-provided buffers. This will
+ * allow bigger buffer size flexibility, and might also be used to achieve
+ * zero-copy messaging.
+ */
+enum rpmsg_platform_requests {
+	VPROC_BUF_ADDR,
+	VPROC_BUF_PADDR,
+	VPROC_BUF_NUM,
+	VPROC_BUF_SZ,
+	VPROC_STATIC_CHANNELS,
+};
+
+#define RPMSG_ADDR_ANY		0xFFFFFFFF
+
+struct virtproc_info;
+
+/**
+ * rpmsg_channel - the rpmsg bus devices are called channels
+ * @vrp: the remote processor this channel belongs to
+ * @dev: the device struct
+ * @id: device id (used to match between rpmsg drivers and devices)
+ * @src: local address
+ * @dst: destination address
+ * @ept: the rpmsg endpoint of this channel
+ * @announce: if set, rpmsg will announce the creation/removal of this channel
+ */
+struct rpmsg_channel {
+	struct virtproc_info *vrp;
+	struct device dev;
+	struct rpmsg_device_id id;
+	u32 src;
+	u32 dst;
+	struct rpmsg_endpoint *ept;
+	bool announce;
+};
+
+/**
+ * struct rpmsg_channel_info - static channel info
+ * @name: name of service
+ * @src: local address
+ * @dst: destination address
+ *
+ * This struct is used to define static channel information, namely name
+ * and addresses, which is used by platform-specific code to create static
+ * channels (i.e. channels that always exists).
+ *
+ * Use cases of static channels are:
+ *
+ * 1. In case the remote processor does not support dynamic name service
+ *    announcements (i.e. remote channel creation/removal).
+ *    In this case, we predefine a static channel table which contains the
+ *    remote rpmsg services supported by the remote processor. The rpmsg
+ *    bus then iterates through this table, and creates rpmsg channels
+ *    (i.e. devices) accordingly. @dst will contain the rpmsg address
+ *    of the remote service, and @src will most likely contain RPMSG_ADDR_ANY.
+ *
+ * 2. To define channels which will be probed with local rpmsg "server"
+ *    driver (i.e. drivers that expose a service). In this case, @src will
+ *    contain the local rpmsg address of the service (but this can made
+ *    dynamic too, if remote processor supports listening to our own dynamic
+ *    name service announcements), and @dst will most likely be RPMSG_ADDR_ANY.
+ *
+ * Use the RPMSG_REMOTE_CHNL and RMSG_SERVER_CHNL macros (see below)
+ * to populate the static channels table for the above two use cases.
+ */
+struct rpmsg_channel_info {
+	char name[RPMSG_NAME_SIZE];
+	u32 src;
+	u32 dst;
+};
+
+/*
+ * rpmsg server channels have a local predefined address, and accept
+ * any remote address
+ */
+#define RMSG_SERVER_CHNL(name, addr)	{ name, addr, RPMSG_ADDR_ANY }
+
+/*
+ * rpmsg remote service channels have a remote predefined address, and
+ * don't care about the local address
+ */
+#define RMSG_REMOTE_CHNL(name, addr)	{ name, RPMSG_ADDR_ANY, addr }
+
+/**
+ * struct rpmsg_endpoint - binds a local rpmsg address to its user
+ * @rpdev: rpmsg channel device
+ * @cb: rx callback handler
+ * @addr: local rpmsg address
+ * @priv: private data for the driver's use
+ *
+ * In essence, an rpmsg endpoint represents a listener on the rpmsg bus, as
+ * it binds together an rpmsg address with an rx callback handler.
+ *
+ * Simple rpmsg drivers shouldn't be aware of this detail, because
+ * things just work: every rpmsg driver provides an rx callback upon
+ * registering to the bus, and that callback is then bound to its rpmsg
+ * address when the driver is probed. When relevant inbound messages arrive
+ * (i.e. messages which their dst address equals to the src address of
+ * the rpmsg channel), the driver's handler is invoked to process it.
+ *
+ * More complicated drivers though, that do need to allocate additional rpmsg
+ * addresses, and bind them to different rx callbacks, must explicitly
+ * create themselves additional endpoints (see rpmsg_create_ept()).
+ */
+struct rpmsg_endpoint {
+	struct rpmsg_channel *rpdev;
+	void (*cb)(struct rpmsg_channel *, void *, int, void *, u32);
+	u32 addr;
+	void *priv;
+};
+
+/**
+ * struct rpmsg_driver - rpmsg driver struct
+ * @drv: underlying device driver
+ * @id_table: rpmsg ids serviced by this driver
+ * @probe: invoked when a matching rpmsg channel (i.e. device) is found
+ * @remove: invoked when the rpmsg channel is removed
+ * @callback: invoked when an inbound message is received on the channel
+ */
+struct rpmsg_driver {
+	struct device_driver drv;
+	const struct rpmsg_device_id *id_table;
+	int (*probe)(struct rpmsg_channel *dev);
+	void (*remove)(struct rpmsg_channel *dev);
+	void (*callback)(struct rpmsg_channel *, void *, int, void *, u32);
+};
+
+int register_rpmsg_device(struct rpmsg_channel *dev);
+void unregister_rpmsg_device(struct rpmsg_channel *dev);
+int register_rpmsg_driver(struct rpmsg_driver *drv);
+void unregister_rpmsg_driver(struct rpmsg_driver *drv);
+void rpmsg_destroy_ept(struct rpmsg_endpoint *);
+struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *,
+		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
+		void *priv, u32 addr);
+
+int
+rpmsg_send_offchannel_raw(struct rpmsg_channel *, u32, u32, void *, int, bool);
+
+/**
+ * rpmsg_send() - send a message across to the remote processor
+ * @rpdev: the rpmsg channel
+ * @data: payload of message
+ * @len: length of payload
+ *
+ * This function sends @data of length @len on the @rpdev channel.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to, using @rpdev's source and destination addresses.
+ * In case there are no TX buffers available, the function will block until
+ * one becomes available, or a timeout of 15 seconds elapses. When the latter
+ * happens, -ERESTARTSYS is returned.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline int rpmsg_send(struct rpmsg_channel *rpdev, void *data, int len)
+{
+	u32 src = rpdev->src, dst = rpdev->dst;
+
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, true);
+}
+
+/**
+ * rpmsg_sendto() - send a message across to the remote processor, specify dst
+ * @rpdev: the rpmsg channel
+ * @data: payload of message
+ * @len: length of payload
+ * @dst: destination address
+ *
+ * This function sends @data of length @len to the remote @dst address.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to, using @rpdev's source address.
+ * In case there are no TX buffers available, the function will block until
+ * one becomes available, or a timeout of 15 seconds elapses. When the latter
+ * happens, -ERESTARTSYS is returned.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline
+int rpmsg_sendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst)
+{
+	u32 src = rpdev->src;
+
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, true);
+}
+
+/**
+ * rpmsg_send_offchannel() - send a message using explicit src/dst addresses
+ * @rpdev: the rpmsg channel
+ * @src: source address
+ * @dst: destination address
+ * @data: payload of message
+ * @len: length of payload
+ *
+ * This function sends @data of length @len to the remote @dst address,
+ * and uses @src as the source address.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to.
+ * In case there are no TX buffers available, the function will block until
+ * one becomes available, or a timeout of 15 seconds elapses. When the latter
+ * happens, -ERESTARTSYS is returned.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline
+int rpmsg_send_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
+							void *data, int len)
+{
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, true);
+}
+
+/**
+ * rpmsg_send() - send a message across to the remote processor
+ * @rpdev: the rpmsg channel
+ * @data: payload of message
+ * @len: length of payload
+ *
+ * This function sends @data of length @len on the @rpdev channel.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to, using @rpdev's source and destination addresses.
+ * In case there are no TX buffers available, the function will immediately
+ * return -ENOMEM without waiting until one becomes available.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline
+int rpmsg_trysend(struct rpmsg_channel *rpdev, void *data, int len)
+{
+	u32 src = rpdev->src, dst = rpdev->dst;
+
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
+}
+
+/**
+ * rpmsg_sendto() - send a message across to the remote processor, specify dst
+ * @rpdev: the rpmsg channel
+ * @data: payload of message
+ * @len: length of payload
+ * @dst: destination address
+ *
+ * This function sends @data of length @len to the remote @dst address.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to, using @rpdev's source address.
+ * In case there are no TX buffers available, the function will immediately
+ * return -ENOMEM without waiting until one becomes available.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline
+int rpmsg_trysendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst)
+{
+	u32 src = rpdev->src;
+
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
+}
+
+/**
+ * rpmsg_send_offchannel() - send a message using explicit src/dst addresses
+ * @rpdev: the rpmsg channel
+ * @src: source address
+ * @dst: destination address
+ * @data: payload of message
+ * @len: length of payload
+ *
+ * This function sends @data of length @len to the remote @dst address,
+ * and uses @src as the source address.
+ * The message will be sent to the remote processor which the @rpdev
+ * channel belongs to.
+ * In case there are no TX buffers available, the function will immediately
+ * return -ENOMEM without waiting until one becomes available.
+ *
+ * Can only be called from process context (for now).
+ *
+ * Returns 0 on success and an appropriate error value on failure.
+ */
+static inline
+int rpmsg_trysend_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
+							void *data, int len)
+{
+	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
+}
+
+#endif /* _LINUX_RPMSG_H */
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 85bb0bb..1520c06 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -35,5 +35,6 @@
 #define VIRTIO_ID_RNG		4 /* virtio ring */
 #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
+#define VIRTIO_ID_RPMSG		10 /* virtio remote processor messaging */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.1

