Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1GIOrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:47:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39427 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1GIOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:47:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 16:47:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] firewire: cdev: ABI documentation enhancements
Message-ID: <20110709164737.53cf7801@stein>
In-Reply-To: <20110709164322.2deb2f36@stein>
References: <20110709164226.519a81fe@stein>
	<20110709164322.2deb2f36@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add overview documentation in Documentation/ABI/stable/firewire-cdev.

Improve the inline reference documentation in firewire-cdev.h:

  - Add /* available since kernel... */ comments to event numbers
    consistent with the comments on ioctl numbers.

  - Shorten some documentation on an event and an ioctl that are
    less interesting to current programming because there are newer
    preferable variants.

  - Spell Configuration ROM (name of an IEEE 1212 register) in
    upper case.

  - Move the dummy FW_CDEV_VERSION out of the reader's field of
    vision.  We should remove it from the header next year or so.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
applicable after patch
"firewire: cdev: prevent race between first get_info ioctl and bus reset event queuing"

 Documentation/ABI/stable/firewire-cdev |  103 +++++++++++++++++++++++++
 include/linux/firewire-cdev.h          |   77 +++++++++----------
 2 files changed, 138 insertions(+), 42 deletions(-)

Index: b/Documentation/ABI/stable/firewire-cdev
===================================================================
--- /dev/null
+++ b/Documentation/ABI/stable/firewire-cdev
@@ -0,0 +1,103 @@
+What:		/dev/fw[0-9]+
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		The character device files /dev/fw* are the interface between
+		firewire-core and IEEE 1394 device drivers implemented in
+		userspace.  The ioctl(2)- and read(2)-based ABI is defined and
+		documented in <linux/firewire-cdev.h>.
+
+		This ABI offers most of the features which firewire-core also
+		exposes to kernelspace IEEE 1394 drivers.
+
+		Each /dev/fw* is associated with one IEEE 1394 node, which can
+		be remote or local nodes.  Operations on a /dev/fw* file have
+		different scope:
+		  - The 1394 node which is associated with the file:
+			  - Asynchronous request transmission
+			  - Get the Configuration ROM
+			  - Query node ID
+			  - Query maximum speed of the path between this node
+			    and local node
+		  - The 1394 bus (i.e. "card") to which the node is attached to:
+			  - Isochronous stream transmission and reception
+			  - Asynchronous stream transmission and reception
+			  - Asynchronous broadcast request transmission
+			  - PHY packet transmission and reception
+			  - Allocate, reallocate, deallocate isochronous
+			    resources (channels, bandwidth) at the bus's IRM
+			  - Query node IDs of local node, root node, IRM, bus
+			    manager
+			  - Query cycle time
+			  - Bus reset initiation, bus reset event reception
+		  - All 1394 buses:
+			  - Allocation of IEEE 1212 address ranges on the local
+			    link layers, reception of inbound requests to such
+			    an address range, asynchronous response transmission
+			    to inbound requests
+			  - Addition of descriptors or directories to the local
+			    nodes' Configuration ROM
+
+		Due to the different scope of operations and in order to let
+		userland implement different access permission models, some
+		operations are restricted to /dev/fw* files that are associated
+		with a local node:
+			  - Addition of descriptors or directories to the local
+			    nodes' Configuration ROM
+			  - PHY packet transmission and reception
+
+		A /dev/fw* file remains associated with one particular node
+		during its entire life time.  Bus topology changes, and hence
+		node ID changes, are tracked by firewire-core.  ABI users do not
+		need to be aware of topology.
+
+		The following file operations are supported:
+
+		open(2)
+		Currently the only useful flags are O_RDWR.
+
+		ioctl(2)
+		Initiate various actions.  Some take immediate effect, others
+		are performed asynchronously while or after the ioctl returns.
+		See the inline documentation in <linux/firewire-cdev.h> for
+		descriptions of all ioctls.
+
+		poll(2), epoll(2)
+		Watch for events to become available to be read.
+
+		read(2)
+		Receive various events.  There are solicited events like
+		outbound asynchronous transaction completion, and unsolicited
+		events such as bus reset events, isochronous DMA buffer
+		completion, or PHY packet reception.  Always use a read buffer
+		which is large enough to receive the largest event that could
+		ever arrive.  See the documentation in <linux/firewire-cdev.h>
+		for descriptions of all event types and for which ioctls affect
+		reception of events.
+
+		mmap(2)
+		Allocate a DMA buffer for isochronous reception or transmission
+		and map it into the process address space.  The arguments should
+		be used as follows:  addr = NULL, length = the desired buffer
+		size, i.e. number of packets times size of largest packet,
+		prot = at least PROT_READ for reception and at least PROT_WRITE
+		for transmission, flags = MAP_SHARED, fd = the handle to the
+		/dev/fw*, offset = 0.
+
+		Isochronous reception works in packet-per-buffer fashion except
+		for multichannel reception which works in buffer-fill mode.
+
+		munmap(2)
+		Unmap the isochronous I/O buffer from the process address space.
+
+		close(2)
+		Besides stopping and freeing I/O contexts that were associated
+		with the file descriptor, back out any changes to the local
+		nodes' Configuration ROM.  Deallocate isochronous channels and
+		bandwidth at the IRM that were marked for kernel-assisted
+		re- and deallocation.
+
+Users:		libraw1394
+		libdc1394
+		tools like jujuutils, fwhack, ...
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -30,10 +30,13 @@
 #include <linux/types.h>
 #include <linux/firewire-constants.h>
 
+/* available since kernel version 2.6.22 */
 #define FW_CDEV_EVENT_BUS_RESET				0x00
 #define FW_CDEV_EVENT_RESPONSE				0x01
 #define FW_CDEV_EVENT_REQUEST				0x02
 #define FW_CDEV_EVENT_ISO_INTERRUPT			0x03
+
+/* available since kernel version 2.6.30 */
 #define FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED		0x04
 #define FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED		0x05
 
@@ -120,24 +123,11 @@ struct fw_cdev_event_response {
 
 /**
  * struct fw_cdev_event_request - Old version of &fw_cdev_event_request2
- * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_ALLOCATE ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_REQUEST
- * @tcode:	See &fw_cdev_event_request2
- * @offset:	See &fw_cdev_event_request2
- * @handle:	See &fw_cdev_event_request2
- * @length:	See &fw_cdev_event_request2
- * @data:	See &fw_cdev_event_request2
  *
  * This event is sent instead of &fw_cdev_event_request2 if the kernel or
- * the client implements ABI version <= 3.
- *
- * Unlike &fw_cdev_event_request2, the sender identity cannot be established,
- * broadcast write requests cannot be distinguished from unicast writes, and
- * @tcode of lock requests is %TCODE_LOCK_REQUEST.
- *
- * Requests to the FCP_REQUEST or FCP_RESPONSE register are responded to as
- * with &fw_cdev_event_request2, except in kernel 2.6.32 and older which send
- * the response packet of the client's %FW_CDEV_IOC_SEND_RESPONSE ioctl.
+ * the client implements ABI version <= 3.  &fw_cdev_event_request lacks
+ * essential information; use &fw_cdev_event_request2 instead.
  */
 struct fw_cdev_event_request {
 	__u64 closure;
@@ -452,30 +442,29 @@ union fw_cdev_event {
  *                 %FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL, and
  *                 %FW_CDEV_IOC_SET_ISO_CHANNELS
  */
-#define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
 /**
  * struct fw_cdev_get_info - General purpose information ioctl
  * @version:	The version field is just a running serial number.  Both an
  *		input parameter (ABI version implemented by the client) and
  *		output parameter (ABI version implemented by the kernel).
- *		A client must not fill in an %FW_CDEV_VERSION defined from an
- *		included kernel header file but the actual version for which
- *		the client was implemented.  This is necessary for forward
- *		compatibility.  We never break backwards compatibility, but
- *		may add more structs, events, and ioctls in later revisions.
- * @rom_length:	If @rom is non-zero, at most rom_length bytes of configuration
+ *		A client shall fill in the ABI @version for which the client
+ *		was implemented.  This is necessary for forward compatibility.
+ * @rom_length:	If @rom is non-zero, up to @rom_length bytes of Configuration
  *		ROM will be copied into that user space address.  In either
  *		case, @rom_length is updated with the actual length of the
- *		configuration ROM.
+ *		Configuration ROM.
  * @rom:	If non-zero, address of a buffer to be filled by a copy of the
- *		device's configuration ROM
+ *		device's Configuration ROM
  * @bus_reset:	If non-zero, address of a buffer to be filled by a
  *		&struct fw_cdev_event_bus_reset with the current state
  *		of the bus.  This does not cause a bus reset to happen.
  * @bus_reset_closure: Value of &closure in this and subsequent bus reset events
  * @card:	The index of the card this device belongs to
  *
+ * The %FW_CDEV_IOC_GET_INFO ioctl is usually the very first one which a client
+ * performs right after it opened a /dev/fw* file.
+ *
  * As a side effect, reception of %FW_CDEV_EVENT_BUS_RESET events to be read(2)
  * is started by this ioctl.
  */
@@ -615,7 +604,7 @@ struct fw_cdev_initiate_bus_reset {
  * @handle:	Handle to the descriptor, written by the kernel
  *
  * Add a descriptor block and optionally a preceding immediate key to the local
- * node's configuration ROM.
+ * node's Configuration ROM.
  *
  * The @key field specifies the upper 8 bits of the descriptor root directory
  * pointer and the @data and @length fields specify the contents. The @key
@@ -630,9 +619,9 @@ struct fw_cdev_initiate_bus_reset {
  * If successful, the kernel adds the descriptor and writes back a @handle to
  * the kernel-side object to be used for later removal of the descriptor block
  * and immediate key.  The kernel will also generate a bus reset to signal the
- * change of the configuration ROM to other nodes.
+ * change of the Configuration ROM to other nodes.
  *
- * This ioctl affects the configuration ROMs of all local nodes.
+ * This ioctl affects the Configuration ROMs of all local nodes.
  * The ioctl only succeeds on device files which represent a local node.
  */
 struct fw_cdev_add_descriptor {
@@ -644,13 +633,13 @@ struct fw_cdev_add_descriptor {
 };
 
 /**
- * struct fw_cdev_remove_descriptor - Remove contents from the configuration ROM
+ * struct fw_cdev_remove_descriptor - Remove contents from the Configuration ROM
  * @handle:	Handle to the descriptor, as returned by the kernel when the
  *		descriptor was added
  *
  * Remove a descriptor block and accompanying immediate key from the local
- * nodes' configuration ROMs.  The kernel will also generate a bus reset to
- * signal the change of the configuration ROM to other nodes.
+ * nodes' Configuration ROMs.  The kernel will also generate a bus reset to
+ * signal the change of the Configuration ROM to other nodes.
  */
 struct fw_cdev_remove_descriptor {
 	__u32 handle;
@@ -672,7 +661,7 @@ struct fw_cdev_remove_descriptor {
  * @handle:	Handle to context, written back by kernel
  *
  * Prior to sending or receiving isochronous I/O, a context must be created.
- * The context records information about the transmit or receive configuration
+ * The context records information about the transmit or receive Configuration
  * and typically maps to an underlying hardware resource.  A context is set up
  * for either sending or receiving.  It is bound to a specific isochronous
  * @channel.
@@ -866,13 +855,8 @@ struct fw_cdev_stop_iso {
  * @local_time:   system time, in microseconds since the Epoch
  * @cycle_timer:  Cycle Time register contents
  *
- * The %FW_CDEV_IOC_GET_CYCLE_TIMER ioctl reads the isochronous cycle timer
- * and also the system clock (%CLOCK_REALTIME).  This allows to express the
- * receive time of an isochronous packet as a system time.
- *
- * @cycle_timer consists of 7 bits cycleSeconds, 13 bits cycleCount, and
- * 12 bits cycleOffset, in host byte order.  Cf. the Cycle Time register
- * per IEEE 1394 or Isochronous Cycle Timer register per OHCI-1394.
+ * Same as %FW_CDEV_IOC_GET_CYCLE_TIMER2, but fixed to use %CLOCK_REALTIME
+ * and only with microseconds resolution.
  *
  * In version 1 and 2 of the ABI, this ioctl returned unreliable (non-
  * monotonic) @cycle_timer values on certain controllers.
@@ -889,10 +873,17 @@ struct fw_cdev_get_cycle_timer {
  * @clk_id:       input parameter, clock from which to get the system time
  * @cycle_timer:  Cycle Time register contents
  *
- * The %FW_CDEV_IOC_GET_CYCLE_TIMER2 works like
- * %FW_CDEV_IOC_GET_CYCLE_TIMER but lets you choose a clock like with POSIX'
- * clock_gettime function.  Supported @clk_id values are POSIX' %CLOCK_REALTIME
- * and %CLOCK_MONOTONIC and Linux' %CLOCK_MONOTONIC_RAW.
+ * The %FW_CDEV_IOC_GET_CYCLE_TIMER2 ioctl reads the isochronous cycle timer
+ * and also the system clock.  This allows to correlate reception time of
+ * isochronous packets with system time.
+ *
+ * @clk_id lets you choose a clock like with POSIX' clock_gettime function.
+ * Supported @clk_id values are POSIX' %CLOCK_REALTIME and %CLOCK_MONOTONIC
+ * and Linux' %CLOCK_MONOTONIC_RAW.
+ *
+ * @cycle_timer consists of 7 bits cycleSeconds, 13 bits cycleCount, and
+ * 12 bits cycleOffset, in host byte order.  Cf. the Cycle Time register
+ * per IEEE 1394 or Isochronous Cycle Timer register per OHCI-1394.
  */
 struct fw_cdev_get_cycle_timer2 {
 	__s64 tv_sec;
@@ -1014,4 +1005,6 @@ struct fw_cdev_receive_phy_packets {
 	__u64 closure;
 };
 
+#define FW_CDEV_VERSION 3 /* Meaningless legacy macro; don't use it. */
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */


-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/
