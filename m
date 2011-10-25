Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1JYJuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:50:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40772 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1JYJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:06 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 6/7] amp/rpmsg: add virtio-based remote processor messaging bus
Date: Tue, 25 Oct 2011 11:48:25 +0200
Message-Id: <1319536106-25802-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a virtio-based inter-processor communication bus, which enables
kernel drivers to communicate with entities, running on remote
processors, over shared memory using a simple messaging protocol.

Every pair of AMP processors share two vrings, which are used to send
and receive the messages over shared memory.

The header of every message sent on the rpmsg bus contains src and dst
addresses, which make it possible to multiplex several rpmsg channels on
the same vring.

Every rpmsg channel is a device on this bus. When a channel is added,
and an appropriate rpmsg driver is found and probed, it is also assigned
a local rpmsg address, which is then bound to the driver's callback.

When inbound messages carry the local address of a bound driver,
its callback is invoked by the bus.

This patch provides a kernel interface only; user space interfaces
will be later exposed by kernel users of this rpmsg bus.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/ABI/testing/sysfs-bus-rpmsg |   75 +++
 Documentation/amp/rpmsg.txt               |  293 ++++++++
 Documentation/virtual/virtio-spec.txt     |   94 +++
 drivers/amp/Kconfig                       |    2 +
 drivers/amp/Makefile                      |    1 +
 drivers/amp/rpmsg/Kconfig                 |    6 +
 drivers/amp/rpmsg/Makefile                |    2 +
 drivers/amp/rpmsg/virtio_rpmsg_bus.c      | 1026 +++++++++++++++++++++++++++++
 include/linux/amp/rpmsg.h                 |  326 +++++++++
 include/linux/mod_devicetable.h           |    9 +
 include/linux/virtio_ids.h                |    1 +
 11 files changed, 1835 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/amp/rpmsg.txt
 create mode 100644 drivers/amp/rpmsg/Kconfig
 create mode 100644 drivers/amp/rpmsg/Makefile
 create mode 100644 drivers/amp/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/amp/rpmsg.h

diff --git a/Documentation/ABI/testing/sysfs-bus-rpmsg b/Documentation/ABI/testing/sysfs-bus-rpmsg
new file mode 100644
index 0000000..189e419
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-rpmsg
@@ -0,0 +1,75 @@
+What:		/sys/bus/rpmsg/devices/.../name
+Date:		June 2011
+KernelVersion:	3.3
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
+KernelVersion:	3.3
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
+KernelVersion:	3.3
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
+KernelVersion:	3.3
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
diff --git a/Documentation/amp/rpmsg.txt b/Documentation/amp/rpmsg.txt
new file mode 100644
index 0000000..a41ffd0
--- /dev/null
+++ b/Documentation/amp/rpmsg.txt
@@ -0,0 +1,293 @@
+Remote Processor Messaging (rpmsg) Framework
+
+Note: this document describes the rpmsg bus and how to write rpmsg drivers.
+To learn how to add rpmsg support for new platforms, check out remoteproc.txt
+(also a resident of Documentation/amp/).
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
+hardware accelerators, and therefore are often used to offload CPU-intensive
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
+system's physical memory and other sensitive hardware resources (e.g. on
+OMAP4, remote cores and hardware accelerators may have direct access to the
+physical memory, gpio banks, dma controllers, i2c bus, gptimers, mailbox
+devices, hwspinlocks, etc..). Moreover, those remote processors might be
+running RTOS where every task can access the entire memory/devices exposed
+to the processor. To minimize the risks of rogue (or buggy) userland code
+exploiting remote bugs, and by that taking over the system, it is often
+desired to limit userland to specific rpmsg channels (see definition below)
+it can send messages on, and if possible, minimize how much control
+it has over the content of the messages.
+
+Every rpmsg device is a communication channel with a remote processor (thus
+rpmsg devices are called channels). Channels are identified by a textual name
+and have a local ("source") rpmsg address, and remote ("destination") rpmsg
+address.
+
+When a driver starts listening on a channel, its rx callback is bound with
+a unique rpmsg local address (a 32-bit integer). This way when inbound messages
+arrive, the rpmsg core dispatches them to the appropriate driver according
+to their destination address (this is done by invoking the driver's rx handler
+with the payload of the inbound message).
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
+     one becomes available (i.e. until the remote processor consumes
+     a tx buffer and puts it back on virtio's used descriptor ring),
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
+     channel belongs, using the channel's src address, and the user-provided
+     dst address (thus the channel's dst address will be ignored).
+
+     In case there are no TX buffers available, the function will block until
+     one becomes available (i.e. until the remote processor consumes
+     a tx buffer and puts it back on virtio's used descriptor ring),
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
+     channel belongs, but the channel's src and dst addresses will be
+     ignored (and the user-provided addresses will be used instead).
+
+     In case there are no TX buffers available, the function will block until
+     one becomes available (i.e. until the remote processor consumes
+     a tx buffer and puts it back on virtio's used descriptor ring),
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
+     channel belongs, using the channel's src address, and the user-provided
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
+     channel belongs, but the channel's src and dst addresses will be
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
+     Drivers should provide their channel (so the new endpoint would bind
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
+     a pointer to a previously-registered rpmsg_driver struct.
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
+module_init(init);
+
+static void __exit fini(void)
+{
+	unregister_rpmsg_driver(&rpmsg_sample_client);
+}
+module_exit(fini);
+
+Note: a similar sample which can be built and loaded can be found
+in samples/amp/.
+
+4. Allocations of rpmsg channels:
+
+At this point we only support dynamic allocations of rpmsg channels.
+
+This is possible only with remote processors that have the VIRTIO_RPMSG_F_NS
+virtio device feature set. This feature bit means that the remote
+processor supports dynamic name service announcement messages.
+
+When this feature is enabled, creation of rpmsg devices (i.e. channels)
+is completely dynamic: the remote processor announces the existence of a
+remote rpmsg service by sending a name service message (which contains
+the name and rpmsg addr of the remote service, see struct rpmsg_ns_msg).
+
+This message is then handled by the rpmsg bus, which in turn dynamically
+creates and registers an rpmsg channel (which represents the remote service).
+If/when a relevant rpmsg driver is registered, it will be immediately probed
+by the bus, and can then start sending messages to the remote service.
+
+The plan is also to add static creation of rpmsg channels via the virtio
+config space, but it's not implemented yet.
diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
index a350ae1..b574065 100644
--- a/Documentation/virtual/virtio-spec.txt
+++ b/Documentation/virtual/virtio-spec.txt
@@ -106,6 +106,8 @@ for informational purposes by the guest).
 +----------------------+--------------------+---------------+
 |          6           |     ioMemory       |       -       |
 +----------------------+--------------------+---------------+
+|          7           |       rpmsg        |  Appendix H   |
++----------------------+--------------------+---------------+
 |          9           |   9P transport     |       -       |
 +----------------------+--------------------+---------------+
 
@@ -2198,3 +2200,95 @@ as follows:
   VIRTIO_BALLOON_S_MEMTOT The total amount of memory available
   (in bytes).
 
+Appendix H: Rpmsg: Remote Processor Messaging
+
+Virtio rpmsg devices represent remote processors on the system
+which run in asymmetric multi-processing (AMP) configuration, and
+which are usually used to offload cpu-intensive tasks from the main
+application processor.
+
+Virtio is being used to communicate with those remote processors;
+empty buffers are placed in one virtqueue for receiving messages, and
+non-empty buffers, containing outbound messages, are enqueued in
+a second virtqueue for transmission.
+
+Numerous communication channels can be multiplexed over those two
+virtqueues, so different entities, running on the application and remote
+processor, can directly communicate in a point-to-point fashion.
+
+  Configuration
+
+  Subsystem Device ID 7
+
+  Virtqueues 0:receiveq. 1:transmitq.
+
+  Feature bits
+
+  VIRTIO_RPMSG_F_NS (0) Device sends (and capable of receiving) name service
+    messages announcing the creation (or destruction) of a channel:
+
+/**
+ * struct rpmsg_ns_msg - dynamic name service announcement message
+ * @name: name of remote service that is published
+ * @addr: address of remote service that is published
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent across to publish a new service (or announce
+ * about its removal). When we receives these messages, an appropriate
+ * rpmsg channel (i.e device) is created/destroyed.
+ */
+struct rpmsg_ns_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 addr;
+	u32 flags;
+} __packed;
+
+/**
+ * enum rpmsg_ns_flags - dynamic name service announcement flags
+ *
+ * @RPMSG_NS_CREATE: a new remote service was just created
+ * @RPMSG_NS_DESTROY: a remote service was just destroyed
+ */
+enum rpmsg_ns_flags {
+	RPMSG_NS_CREATE		= 0,
+	RPMSG_NS_DESTROY	= 1,
+};
+
+  Device configuration layout
+
+  At his point none currently defined, but the plan is to use the
+  the config space for announcing the existence of static channels
+  and configuring their addresses.
+
+  Device Initialization
+
+  The initialization routine should identify the receive and
+  transmission virtqueues.
+
+  The receive virtqueue should be filled with receive buffers.
+
+  Device Operation
+
+  Messages are transmitted by placing them in the transmitq, and
+  buffers for inbound messages are placed in the receiveq. In any
+  case, messages are always preceded by the following header:
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
diff --git a/drivers/amp/Kconfig b/drivers/amp/Kconfig
index 23a8ed1..9580849 100644
--- a/drivers/amp/Kconfig
+++ b/drivers/amp/Kconfig
@@ -6,4 +6,6 @@ menu "Asymmetric Multiprocessing (AMP) Framework"
 
 source "drivers/amp/remoteproc/Kconfig"
 
+source "drivers/amp/rpmsg/Kconfig"
+
 endmenu
diff --git a/drivers/amp/Makefile b/drivers/amp/Makefile
index 708461d..ea71d56 100644
--- a/drivers/amp/Makefile
+++ b/drivers/amp/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
+obj-$(CONFIG_RPMSG)		+= rpmsg/
diff --git a/drivers/amp/rpmsg/Kconfig b/drivers/amp/rpmsg/Kconfig
new file mode 100644
index 0000000..480944c
--- /dev/null
+++ b/drivers/amp/rpmsg/Kconfig
@@ -0,0 +1,6 @@
+# RPMSG always gets selected by whoever wants it
+config RPMSG
+	tristate
+	select VIRTIO
+	select VIRTIO_RING
+
diff --git a/drivers/amp/rpmsg/Makefile b/drivers/amp/rpmsg/Makefile
new file mode 100644
index 0000000..ba8e3c5
--- /dev/null
+++ b/drivers/amp/rpmsg/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_RPMSG)	+= virtio_rpmsg_bus.o
+
diff --git a/drivers/amp/rpmsg/virtio_rpmsg_bus.c b/drivers/amp/rpmsg/virtio_rpmsg_bus.c
new file mode 100644
index 0000000..f3d111f
--- /dev/null
+++ b/drivers/amp/rpmsg/virtio_rpmsg_bus.c
@@ -0,0 +1,1026 @@
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
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/amp/rpmsg.h>
+#include <linux/mutex.h>
+
+/**
+ * struct virtproc_info - virtual remote processor state
+ * @vdev:	the virtio device
+ * @rvq:	rx virtqueue
+ * @svq:	tx virtqueue
+ * @rbufs:	kernel address of rx buffers
+ * @sbufs:	kernel address of tx buffers
+ * @last_sbuf:	index of last tx buffer used
+ * @bufs_dma:	dma base addr of the buffers
+ * @tx_lock:	protects svq, sbufs and sleepers, to allow concurrent senders.
+ *		sending a message might require waking up a dozing remote
+ *		processor, which involves sleeping, hence the mutex.
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
+	dma_addr_t bufs_dma;
+	struct mutex tx_lock;
+	struct idr endpoints;
+	struct mutex endpoints_lock;
+	wait_queue_head_t sendq;
+	atomic_t sleepers;
+	struct rpmsg_endpoint *ns_ept;
+};
+
+/**
+ * struct rpmsg_channel_info - internal channel info representation
+ * @name: name of service
+ * @src: local address
+ * @dst: destination address
+ */
+struct rpmsg_channel_info {
+	char name[RPMSG_NAME_SIZE];
+	u32 src;
+	u32 dst;
+};
+
+#define to_rpmsg_channel(d) container_of(d, struct rpmsg_channel, dev)
+#define to_rpmsg_driver(d) container_of(d, struct rpmsg_driver, drv)
+
+/*
+ * We're allocating 512 buffers of 512 bytes for communications, and then
+ * using the first 256 buffers for RX, and the last 256 buffers for TX.
+ *
+ * Each buffer will have 16 bytes for the msg header and 496 bytes for
+ * the payload.
+ *
+ * This will require a total space of 256KB for the buffers.
+ *
+ * We might also want to add support for user-provided buffers in time.
+ * This will allow bigger buffer size flexibility, and can also be used
+ * to achieve zero-copy messaging.
+ *
+ * Note that these numbers are purely a decision of this driver - we
+ * can change this without changing anything in the firmware of the remote
+ * processor.
+ */
+#define RPMSG_NUM_BUFS		(512)
+#define RPMSG_BUF_SIZE		(512)
+#define RPMSG_TOTAL_BUF_SPACE	(RPMSG_NUM_BUFS * RPMSG_BUF_SIZE)
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
+/* sysfs show configuration fields */
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
+/*
+ * Unique (and free running) index for rpmsg devices.
+ *
+ * Yeah, we're not recycling those numbers (yet?). will be easy
+ * to change if/when we want to.
+ */
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
+	return strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE) == 0;
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
+	for (i = 0; ids[i].name[0]; i++)
+		if (rpmsg_id_match(rpdev, &ids[i]))
+			return 1;
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
+		struct rpmsg_channel *rpdev, rpmsg_rx_cb_t cb,
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
+	mutex_lock(&vrp->endpoints_lock);
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
+	mutex_unlock(&vrp->endpoints_lock);
+
+	return ept;
+
+rem_idr:
+	idr_remove(&vrp->endpoints, request);
+free_ept:
+	mutex_unlock(&vrp->endpoints_lock);
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
+				rpmsg_rx_cb_t cb, void *priv, u32 addr)
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
+	mutex_lock(&vrp->endpoints_lock);
+	idr_remove(&vrp->endpoints, ept->addr);
+	mutex_unlock(&vrp->endpoints_lock);
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
+		put_device(&rpdev->dev);
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
+	mutex_lock(&vrp->tx_lock);
+
+	/*
+	 * either pick the next unused tx buffer
+	 * (half of our buffers are used for sending messages)
+	 */
+	if (vrp->last_sbuf < RPMSG_NUM_BUFS / 2)
+		ret = vrp->sbufs + RPMSG_BUF_SIZE * vrp->last_sbuf++;
+	/* or recycle a used one */
+	else
+		ret = virtqueue_get_buf(vrp->svq, &len);
+
+	mutex_unlock(&vrp->tx_lock);
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
+	mutex_lock(&vrp->tx_lock);
+
+	/* are we the first sleeping context waiting for tx buffers ? */
+	if (atomic_inc_return(&vrp->sleepers) == 1)
+		/* enable "tx-complete" interrupts before dozing off */
+		virtqueue_enable_cb(vrp->svq);
+
+	mutex_unlock(&vrp->tx_lock);
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
+	mutex_lock(&vrp->tx_lock);
+
+	/* are we the last sleeping context waiting for tx buffers ? */
+	if (atomic_dec_and_test(&vrp->sleepers))
+		/* disable "tx-complete" interrupts */
+		virtqueue_disable_cb(vrp->svq);
+
+	mutex_unlock(&vrp->tx_lock);
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
+
+	/* bcasting isn't allowed */
+	if (src == RPMSG_ADDR_ANY || dst == RPMSG_ADDR_ANY) {
+		dev_err(dev, "invalid addr (src 0x%x, dst 0x%x)\n", src, dst);
+		return -EINVAL;
+	}
+
+	/*
+	 * We currently use fixed-sized buffers, and therefore the payload
+	 * length is limited.
+	 *
+	 * One of the possible improvements here is either to support
+	 * user-provided buffers (and then we can also support zero-copy
+	 * messaging), or to improve the buffer allocator, to support
+	 * variable-length buffer sizes.
+	 */
+	if (len > RPMSG_BUF_SIZE - sizeof(struct rpmsg_hdr)) {
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
+	sg_init_one(&sg, msg, sizeof(*msg) + len);
+
+	mutex_lock(&vrp->tx_lock);
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
+	mutex_unlock(&vrp->tx_lock);
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
+	mutex_lock(&vrp->endpoints_lock);
+	ept = idr_find(&vrp->endpoints, msg->dst);
+	mutex_unlock(&vrp->endpoints_lock);
+
+	if (ept && ept->cb)
+		ept->cb(ept->rpdev, msg->data, msg->len, ept->priv, msg->src);
+	else
+		dev_warn(dev, "msg received with no recepient\n");
+
+	sg_init_one(&sg, msg, sizeof(*msg) + len);
+
+	/* add the buffer back to the remote processor's virtqueue */
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
+	void *bufs_va;
+	int err = 0, i;
+
+	vrp = kzalloc(sizeof(*vrp), GFP_KERNEL);
+	if (!vrp)
+		return -ENOMEM;
+
+	vrp->vdev = vdev;
+
+	idr_init(&vrp->endpoints);
+	mutex_init(&vrp->endpoints_lock);
+	mutex_init(&vrp->tx_lock);
+	init_waitqueue_head(&vrp->sendq);
+
+	/* We expect two virtqueues, rx and tx (and in this order) */
+	err = vdev->config->find_vqs(vdev, 2, vqs, vq_cbs, names);
+	if (err)
+		goto free_vrp;
+
+	vrp->rvq = vqs[0];
+	vrp->svq = vqs[1];
+
+	/* allocate coherent memory for the buffers */
+	bufs_va = dma_alloc_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE,
+				&vrp->bufs_dma, GFP_KERNEL);
+	if (!bufs_va)
+		goto vqs_del;
+
+	dev_dbg(&vdev->dev, "buffers: va %p, dma 0x%x\n", bufs_va,
+						vrp->bufs_dma);
+
+	/* half of the buffers is dedicated for RX */
+	vrp->rbufs = bufs_va;
+
+	/* and half is dedicated for TX */
+	vrp->sbufs = bufs_va + RPMSG_TOTAL_BUF_SPACE / 2;
+
+	/* set up the receive buffers */
+	for (i = 0; i < RPMSG_NUM_BUFS / 2; i++) {
+		struct scatterlist sg;
+		void *cpu_addr = vrp->rbufs + i * RPMSG_BUF_SIZE;
+
+		sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
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
+			goto free_coherent;
+		}
+	}
+
+	/* tell the remote processor it can start sending messages */
+	virtqueue_kick(vrp->rvq);
+
+	dev_info(&vdev->dev, "rpmsg host is online\n");
+
+	return 0;
+
+free_coherent:
+	dma_free_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE, bufs_va,
+					vrp->bufs_dma);
+vqs_del:
+	vdev->config->del_vqs(vrp->vdev);
+free_vrp:
+	kfree(vrp);
+	return err;
+}
+
+static int rpmsg_remove_device(struct device *dev, void *data)
+{
+	device_unregister(dev);
+
+	return 0;
+}
+
+static void __devexit rpmsg_remove(struct virtio_device *vdev)
+{
+	struct virtproc_info *vrp = vdev->priv;
+	int ret;
+
+	vdev->config->reset(vdev);
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
+	dma_free_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE,
+					vrp->rbufs, vrp->bufs_dma);
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
+static int __init rpmsg_init(void)
+{
+	int ret;
+
+	ret = bus_register(&rpmsg_bus);
+	if (ret) {
+		pr_err("failed to register rpmsg bus: %d\n", ret);
+		return ret;
+	}
+
+	ret = register_virtio_driver(&virtio_ipc_driver);
+	if (ret) {
+		pr_err("failed to register virtio driver: %d\n", ret);
+		bus_unregister(&rpmsg_bus);
+	}
+
+	return ret;
+}
+module_init(rpmsg_init);
+
+static void __exit rpmsg_fini(void)
+{
+	unregister_virtio_driver(&virtio_ipc_driver);
+	bus_unregister(&rpmsg_bus);
+}
+module_exit(rpmsg_fini);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio-based remote processor messaging bus");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/amp/rpmsg.h b/include/linux/amp/rpmsg.h
new file mode 100644
index 0000000..a8e50e4
--- /dev/null
+++ b/include/linux/amp/rpmsg.h
@@ -0,0 +1,326 @@
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
+ * This message is sent across to publish a new service, or announce
+ * about its removal. When we receive these messages, an appropriate
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
+ * enum rpmsg_ns_flags - dynamic name service announcement flags
+ *
+ * @RPMSG_NS_CREATE: a new remote service was just created
+ * @RPMSG_NS_DESTROY: a known remote service was just destroyed
+ */
+enum rpmsg_ns_flags {
+	RPMSG_NS_CREATE		= 0,
+	RPMSG_NS_DESTROY	= 1,
+};
+
+#define RPMSG_ADDR_ANY		0xFFFFFFFF
+
+struct virtproc_info;
+
+/**
+ * rpmsg_channel - devices that belong to the rpmsg bus are called channels
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
+typedef void (*rpmsg_rx_cb_t)(struct rpmsg_channel *, void *, int, void *, u32);
+
+/**
+ * struct rpmsg_endpoint - binds a local rpmsg address to its user
+ * @rpdev: rpmsg channel device
+ * @cb: rx callback handler
+ * @addr: local rpmsg address
+ * @priv: private data for the driver's use
+ *
+ * In essence, an rpmsg endpoint represents a listener on the rpmsg bus, as
+ * it binds an rpmsg address with an rx callback handler.
+ *
+ * Simple rpmsg drivers shouldn't use this struct directly, because
+ * things just work: every rpmsg driver provides an rx callback upon
+ * registering to the bus, and that callback is then bound to its rpmsg
+ * address when the driver is probed. When relevant inbound messages arrive
+ * (i.e. messages which their dst address equals to the src address of
+ * the rpmsg channel), the driver's handler is invoked to process it.
+ *
+ * More complicated drivers though, that do need to allocate additional rpmsg
+ * addresses, and bind them to different rx callbacks, must explicitly
+ * create additional endpoints by themselves (see rpmsg_create_ept()).
+ */
+struct rpmsg_endpoint {
+	struct rpmsg_channel *rpdev;
+	rpmsg_rx_cb_t cb;
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
+				rpmsg_rx_cb_t cb, void *priv, u32 addr);
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
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ae28e93..6176f29 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -405,6 +405,15 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
+/* rpmsg */
+
+#define RPMSG_NAME_SIZE			32
+#define RPMSG_DEVICE_MODALIAS_FMT	"rpmsg:%s"
+
+struct rpmsg_device_id {
+	char name[RPMSG_NAME_SIZE];
+};
+
 /* i2c */
 
 #define I2C_NAME_SIZE	20
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 85bb0bb..b37c521 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -34,6 +34,7 @@
 #define VIRTIO_ID_CONSOLE	3 /* virtio console */
 #define VIRTIO_ID_RNG		4 /* virtio ring */
 #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
+#define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.5.4

