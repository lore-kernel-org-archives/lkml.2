Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0EDK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:28:47 -0400
Received: from mga06.intel.com ([134.134.136.21]:58889 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193Ab0EDK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,325,1270450800"; 
   d="scan'208";a="618704248"
Date: Tue, 4 May 2010 10:50:32 +0100
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: PATCH: RAR support - bring ready to move from staging
Message-ID: <20100504105032.3de58e68@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rar: perform a clean up pass

- Move to a registration model where each RAR is claimed/unclaimed
- Use that to fix the client stuff (one client per RAR so no need to queue stuff)
- Support unregister so drivers can rmmod themselves safely
- Fix locking hang on calling rar lock from rar callback
- Clean up
- Kerneldoc

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/rar_register/rar_register.c |  611 +++++++++++++++------------
 drivers/staging/rar_register/rar_register.h |   62 ---
 2 files changed, 347 insertions(+), 326 deletions(-)


diff --git a/drivers/staging/rar_register/rar_register.c b/drivers/staging/rar_register/rar_register.c
index bfc0e31..7c2011c 100644
--- a/drivers/staging/rar_register/rar_register.c
+++ b/drivers/staging/rar_register/rar_register.c
@@ -51,98 +51,160 @@
 #include <linux/kernel.h>
 
 /* === Lincroft Message Bus Interface === */
-/* Message Control Register */
-#define LNC_MCR_OFFSET 0xD0
-
-/* Maximum number of clients (other drivers using this driver) */
-#define MAX_RAR_CLIENTS 10
-
-/* Message Data Register */
-#define LNC_MDR_OFFSET 0xD4
+#define LNC_MCR_OFFSET		0xD0	/* Message Control Register */
+#define LNC_MDR_OFFSET		0xD4	/* Message Data Register */
 
 /* Message Opcodes */
-#define LNC_MESSAGE_READ_OPCODE 0xD0
+#define LNC_MESSAGE_READ_OPCODE	0xD0
 #define LNC_MESSAGE_WRITE_OPCODE 0xE0
 
 /* Message Write Byte Enables */
-#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
+#define LNC_MESSAGE_BYTE_WRITE_ENABLES	0xF
 
 /* B-unit Port */
-#define LNC_BUNIT_PORT 0x3
+#define LNC_BUNIT_PORT	0x3
 
 /* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
-#define LNC_BRAR0L 0x10
-#define LNC_BRAR0H 0x11
-#define LNC_BRAR1L 0x12
-#define LNC_BRAR1H 0x13
-
+#define LNC_BRAR0L	0x10
+#define LNC_BRAR0H	0x11
+#define LNC_BRAR1L	0x12
+#define LNC_BRAR1H	0x13
 /* Reserved for SeP */
-#define LNC_BRAR2L 0x14
-#define LNC_BRAR2H 0x15
+#define LNC_BRAR2L	0x14
+#define LNC_BRAR2H	0x15
 
 /* Moorestown supports three restricted access regions. */
 #define MRST_NUM_RAR 3
 
-
 /* RAR Bus Address Range */
-struct RAR_address_range {
+struct rar_addr {
 	dma_addr_t low;
 	dma_addr_t high;
 };
 
-/* Structure containing low and high RAR register offsets. */
-struct RAR_offsets {
-	u32 low;  /* Register offset for low  RAR bus address. */
-	u32 high; /* Register offset for high RAR bus address. */
-};
-
+/*
+ *	We create one of these for each RAR
+ */
 struct client {
-	int (*client_callback)(void *client_data);
-	void *customer_data;
-	int client_called;
-	};
+	int (*callback)(unsigned long data);
+	unsigned long driver_priv;
+	bool busy;
+};
 
 static DEFINE_MUTEX(rar_mutex);
 static DEFINE_MUTEX(lnc_reg_mutex);
 
-struct RAR_device {
-	struct RAR_offsets const rar_offsets[MRST_NUM_RAR];
-	struct RAR_address_range rar_addr[MRST_NUM_RAR];
+/*
+ *	One per RAR device (currently only one device)
+ */
+struct rar_device {
+	struct rar_addr rar_addr[MRST_NUM_RAR];
 	struct pci_dev *rar_dev;
 	bool registered;
-	};
-
-/* this platform has only one rar_device for 3 rar regions */
-static struct RAR_device my_rar_device = {
-	.rar_offsets = {
-		[0].low = LNC_BRAR0L,
-		[0].high = LNC_BRAR0H,
-		[1].low = LNC_BRAR1L,
-		[1].high = LNC_BRAR1H,
-		[2].low = LNC_BRAR2L,
-		[2].high = LNC_BRAR2H
-	}
+	bool allocated;
+	struct client client[MRST_NUM_RAR];
 };
 
-/* this data is for handling requests from other drivers which arrive
- * prior to this driver initializing
+/* Current platforms have only one rar_device for 3 rar regions */
+static struct rar_device my_rar_device;
+
+/*
+ *	Abstract out multiple device support. Current platforms only
+ *	have a single RAR device.
  */
 
-static struct client clients[MAX_RAR_CLIENTS];
-static int num_clients;
+/**
+ *	alloc_rar_device	-	return a new RAR structure
+ *
+ *	Return a new (but not yet ready) RAR device object
+ */
+static struct rar_device *alloc_rar_device(void)
+{
+	if (my_rar_device.allocated)
+		return NULL;
+	my_rar_device.allocated = 1;
+	return &my_rar_device;
+}
 
-/*
- * This function is used to retrieved RAR info using the Lincroft
- * message bus interface.
+/**
+ *	free_rar_device		-	free a RAR object
+ *	@rar: the RAR device being freed
+ *
+ *	Release a RAR object and any attached resources
  */
-static int retrieve_rar_addr(struct pci_dev *pdev,
-	int offset,
-	dma_addr_t *addr)
+static void free_rar_device(struct rar_device *rar)
+{
+	pci_dev_put(rar->rar_dev);
+	rar->allocated = 0;
+}
+
+/**
+ *	_rar_to_device		-	return the device handling this RAR
+ *	@rar: RAR number
+ *	@off: returned offset
+ *
+ *	Internal helper for looking up RAR devices. This and alloc are the
+ *	two functions that need touching to go to multiple RAR devices.
+ */
+static struct rar_device *_rar_to_device(int rar, int *off)
+{
+	if (rar >= 0 && rar <= 3) {
+		*off = rar;
+		return &my_rar_device;
+	}
+	return NULL;
+}
+
+
+/**
+ *	rar_to_device		-	return the device handling this RAR
+ *	@rar: RAR number
+ *	@off: returned offset
+ *
+ *	Return the device this RAR maps to if one is present, otherwise
+ *	returns NULL. Reports the offset relative to the base of this
+ *	RAR device in off.
+ */
+static struct rar_device *rar_to_device(int rar, int *off)
+{
+	struct rar_device *rar_dev = _rar_to_device(rar, off);
+	if (rar_dev == NULL || !rar_dev->registered)
+		return NULL;
+	return rar_dev;
+}
+
+/**
+ *	rar_to_client		-	return the client handling this RAR
+ *	@rar: RAR number
+ *
+ *	Return the client this RAR maps to if one is present, otherwise
+ *	returns NULL. Reports the mapping even if there device is not
+ *	yet probed.
+ */
+static struct client *rar_to_client(int rar)
+{
+	int idx;
+	struct rar_device *r = _rar_to_device(rar, &idx);
+	if (r != NULL)
+		return &r->client[idx];
+	return NULL;
+}
+
+/**
+ *	rar_read_addr		-	retrieve a RAR mapping
+ *	@pdev: PCI device for the RAR
+ *	@offset: offset for message
+ *	@addr: returned address
+ *
+ *	Reads the address of a given RAR register. Returns 0 on success
+ *	or an error code on failure.
+ */
+static int rar_read_addr(struct pci_dev *pdev, int offset, dma_addr_t *addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
+	 * Lincroft registers may be obtained via PCI from
+	 * the host bridge using the Lincroft Message Bus
 	 * Interface.  That message bus interface is generally
 	 * comprised of two registers: a control register (MCR, 0xDO)
 	 * and a data register (MDR, 0xD4).
@@ -182,6 +244,7 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 	*/
 
 	int result;
+	u32 addr32;
 
 	/* Construct control message */
 	u32 const message =
@@ -192,11 +255,6 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 
 	dev_dbg(&pdev->dev, "Offset for 'get' LNC MSG is %x\n", offset);
 
-	if (addr == 0) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
 	/*
 	* We synchronize access to the Lincroft MCR and MDR registers
 	* until BOTH the command is issued through the MCR register
@@ -209,26 +267,25 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
-
-	dev_dbg(&pdev->dev, "Result from send ctl register is %x\n", result);
-
 	if (!result) {
-		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET,
-			(u32 *)addr);
-		dev_dbg(&pdev->dev,
-			"Result from read data register is %x\n", result);
-
-		dev_dbg(&pdev->dev,
-			"Value read from data register is %lx\n",
-			 (unsigned long)*addr);
+		/* Read back the address as a 32bit value */
+		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET, &addr32);
+		*addr = (dma_addr_t)addr32;
 	}
-
 	mutex_unlock(&lnc_reg_mutex);
-
 	return result;
 }
 
-static int set_rar_address(struct pci_dev *pdev,
+/**
+ *	rar_set_addr		-	Set a RAR mapping
+ *	@pdev: PCI device for the RAR
+ *	@offset: offset for message
+ *	@addr: address to set
+ *
+ *	Sets the address of a given RAR register. Returns 0 on success
+ *	or an error code on failure.
+ */
+static int rar_set_addr(struct pci_dev *pdev,
 	int offset,
 	dma_addr_t addr)
 {
@@ -236,11 +293,11 @@ static int set_rar_address(struct pci_dev *pdev,
 	* Data being written to this register must be written before
 	* writing the appropriate control message to the MCR
 	* register.
-	* @note See rar_get_address() for a description of the
+	* See rar_get_addrs() for a description of the
 	* message bus interface being used here.
 	*/
 
-	int result = 0;
+	int result;
 
 	/* Construct control message */
 	u32 const message = (LNC_MESSAGE_WRITE_OPCODE << 24)
@@ -248,13 +305,6 @@ static int set_rar_address(struct pci_dev *pdev,
 		| (offset << 8)
 		| (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	if (addr == 0) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	dev_dbg(&pdev->dev, "Offset for 'set' LNC MSG is %x\n", offset);
-
 	/*
 	* We synchronize access to the Lincroft MCR and MDR registers
 	* until BOTH the command is issued through the MCR register
@@ -267,32 +317,27 @@ static int set_rar_address(struct pci_dev *pdev,
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev, LNC_MDR_OFFSET, addr);
-
-	dev_dbg(&pdev->dev, "Result from write data register is %x\n", result);
-
-	if (!result) {
-		dev_dbg(&pdev->dev,
-			"Value written to data register is %lx\n",
-			 (unsigned long)addr);
-
+	if (!result)
+		/* And address */
 		result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
 
-		dev_dbg(&pdev->dev, "Result from send ctl register is %x\n",
-			result);
-	}
-
 	mutex_unlock(&lnc_reg_mutex);
-
 	return result;
 }
 
 /*
-* Initialize RAR parameters, such as bus addresses, etc.
-*/
-static int init_rar_params(struct pci_dev *pdev)
+ *	rar_init_params		-	Initialize RAR parameters
+ *	@rar: RAR device to initialise
+ *
+ *	Initialize RAR parameters, such as bus addresses, etc. Returns 0
+ *	on success, or an error code on failure.
+ */
+static int init_rar_params(struct rar_device *rar)
 {
+	struct pci_dev *pdev = rar->rar_dev;
 	unsigned int i;
 	int result = 0;
+	int offset = 0x10;	/* RAR 0 to 2 in order low/high/low/high/... */
 
 	/* Retrieve RAR start and end bus addresses.
 	* Access the RAR registers through the Lincroft Message Bus
@@ -300,15 +345,16 @@ static int init_rar_params(struct pci_dev *pdev)
 	*/
 
 	for (i = 0; i < MRST_NUM_RAR; ++i) {
-		struct RAR_offsets const *offset =
-			&my_rar_device.rar_offsets[i];
-		struct RAR_address_range *addr = &my_rar_device.rar_addr[i];
-
-	if ((retrieve_rar_addr(pdev, offset->low, &addr->low) != 0)
-		|| (retrieve_rar_addr(pdev, offset->high, &addr->high) != 0)) {
-		result = -1;
-		break;
-		}
+		struct rar_addr *addr = &rar->rar_addr[i];
+
+		result = rar_read_addr(pdev, offset++, &addr->low);
+		if (result != 0)
+			return result;
+
+		result = rar_read_addr(pdev, offset++, &addr->high);
+		if (result != 0)
+			return result;
+
 
 		/*
 		* Only the upper 22 bits of the RAR addresses are
@@ -336,201 +382,237 @@ static int init_rar_params(struct pci_dev *pdev)
 	/* Done accessing the device. */
 
 	if (result == 0) {
-		int z;
-		for (z = 0; z != MRST_NUM_RAR; ++z) {
+		for (i = 0; i != MRST_NUM_RAR; ++i) {
 			/*
 			* "BRAR" refers to the RAR registers in the
 			* Lincroft B-unit.
 			*/
 			dev_info(&pdev->dev, "BRAR[%u] bus address range = "
-			  "[%lx, %lx]\n", z,
-			  (unsigned long)my_rar_device.rar_addr[z].low,
-			  (unsigned long)my_rar_device.rar_addr[z].high);
+			  "[%lx, %lx]\n", i,
+			  (unsigned long)rar->rar_addr[i].low,
+			  (unsigned long)rar->rar_addr[i].high);
 		}
 	}
-
 	return result;
 }
 
-/*
- * The rar_get_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes three
- * parameters:
+/**
+ *	rar_get_address		-	get the bus address in a RAR
+ *	@start: return value of start address of block
+ *	@end: return value of end address of block
  *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
+ *	The rar_get_address function is used by other device drivers
+ *	to obtain RAR address information on a RAR. It takes three
+ *	parameters:
  *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
+ *	The function returns a 0 upon success or an error if there is no RAR
+ *	facility on this system.
  */
-int rar_get_address(int rar_index,
-	dma_addr_t *start_address,
-	dma_addr_t *end_address)
+int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end)
 {
-	int result = -ENODEV;
-
-	if (my_rar_device.registered) {
-		if (start_address == 0 || end_address == 0
-			|| rar_index >= MRST_NUM_RAR || rar_index < 0) {
-			result = -EINVAL;
-		} else {
-			*start_address =
-				my_rar_device.rar_addr[rar_index].low;
-			*end_address =
-				my_rar_device.rar_addr[rar_index].high;
-
-			result = 0;
-		}
+	int idx;
+	struct rar_device *rar = rar_to_device(rar_index, &idx);
+
+	if (rar == NULL) {
+		WARN_ON(1);
+		return -ENODEV;
 	}
 
-	return result;
+	*start = rar->rar_addr[idx].low;
+	*end = rar->rar_addr[idx].high;
+	return 0;
 }
 EXPORT_SYMBOL(rar_get_address);
 
-/*
- * The rar_lock function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
+/**
+ *	rar_lock	-	lock a RAR register
+ *	@rar_index: RAR to lock (0-2)
  *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
+ *	The rar_lock function is ued by other device drivers to lock an RAR.
+ *	once a RAR is locked, it stays locked until the next system reboot.
  *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
+ *	The function returns a 0 upon success or an error if there is no RAR
+ *	facility on this system, or the locking fails
  */
 int rar_lock(int rar_index)
 {
-	int result = -ENODEV;
-
-	if (rar_index >= MRST_NUM_RAR || rar_index < 0) {
-		result = -EINVAL;
-		return result;
-	}
-
-	dev_dbg(&my_rar_device.rar_dev->dev, "rar_lock mutex locking\n");
-	mutex_lock(&rar_mutex);
+	struct rar_device *rar;
+	int result;
+	int idx;
+	dma_addr_t low, high;
 
-	if (my_rar_device.registered) {
+	rar = rar_to_device(rar_index, &idx);
 
-		dma_addr_t low = my_rar_device.rar_addr[rar_index].low &
-			0xfffffc00u;
+	if (rar == NULL) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
-		dma_addr_t high = my_rar_device.rar_addr[rar_index].high &
-			0xfffffc00u;
+	low = rar->rar_addr[idx].low & 0xfffffc00u;
+	high = rar->rar_addr[idx].high & 0xfffffc00u;
 
-		/*
-		* Only allow I/O from the graphics and Langwell;
-		* Not from the x96 processor
-		*/
-		if (rar_index == (int)RAR_TYPE_VIDEO) {
-			low |= 0x00000009;
-			high |= 0x00000015;
-		}
+	/*
+	* Only allow I/O from the graphics and Langwell;
+	* not from the x86 processor
+	*/
 
-		else if (rar_index == (int)RAR_TYPE_AUDIO) {
-			/* Only allow I/O from Langwell; nothing from x86 */
-			low |= 0x00000008;
-			high |= 0x00000018;
-		}
+	if (rar_index == RAR_TYPE_VIDEO) {
+		low |= 0x00000009;
+		high |= 0x00000015;
+	} else if (rar_index == RAR_TYPE_AUDIO) {
+		/* Only allow I/O from Langwell; nothing from x86 */
+		low |= 0x00000008;
+		high |= 0x00000018;
+	} else
+		/* Read-only from all agents */
+		high |= 0x00000018;
 
-		else
-			/* Read-only from all agents */
-			high |= 0x00000018;
+	/*
+	* Now program the register using the Lincroft message
+	* bus interface.
+	*/
+	result = rar_set_addr(rar->rar_dev,
+				2 * idx, low);
 
-		/*
-		* Now program the register using the Lincroft message
-		* bus interface.
-		*/
-		result = set_rar_address(my_rar_device.rar_dev,
-			my_rar_device.rar_offsets[rar_index].low,
-			low);
-
-		if (result == 0)
-			result = set_rar_address(
-			my_rar_device.rar_dev,
-			my_rar_device.rar_offsets[rar_index].high,
-			high);
-	}
+	if (result == 0)
+		result = rar_set_addr(rar->rar_dev,
+				2 * idx + 1, high);
 
-	dev_dbg(&my_rar_device.rar_dev->dev, "rar_lock mutex unlocking\n");
-	mutex_unlock(&rar_mutex);
 	return result;
 }
 EXPORT_SYMBOL(rar_lock);
 
-/* The register_rar function is to used by other device drivers
- * to ensure that this driver is ready. As we cannot be sure of
- * the compile/execute order of dirvers in ther kernel, it is
- * best to give this driver a callback function to call when
- * it is ready to give out addresses. The callback function
- * would have those steps that continue the initialization of
- * a driver that do require a valid RAR address. One of those
- * steps would be to call rar_get_address()
- * This function return 0 on success an -1 on failure.
-*/
-int register_rar(int (*callback)(void *yourparameter), void *yourparameter)
+/**
+ *	register_rar		-	register a RAR handler
+ *	@num: RAR we wish to register for
+ *	@callback: function to call when RAR support is available
+ *	@data: data to pass to this function
+ *
+ *	The register_rar function is to used by other device drivers
+ *	to ensure that this driver is ready. As we cannot be sure of
+ *	the compile/execute order of drivers in ther kernel, it is
+ *	best to give this driver a callback function to call when
+ *	it is ready to give out addresses. The callback function
+ *	would have those steps that continue the initialization of
+ *	a driver that do require a valid RAR address. One of those
+ *	steps would be to call rar_get_address()
+ *
+ *	This function return 0 on success an error code on failure.
+ */
+int register_rar(int num, int (*callback)(unsigned long data),
+							unsigned long data)
 {
-
-	int result = -ENODEV;
-
-	if (callback == NULL)
-		return -EINVAL;
+	/* For now we hardcode a single RAR device */
+	struct rar_device *rar;
+	struct client *c;
+	int idx;
+	int retval = 0;
 
 	mutex_lock(&rar_mutex);
 
-	if (my_rar_device.registered) {
+	/* Do we have a client mapping for this RAR number ? */
+	c = rar_to_client(num);
+	if (c == NULL) {
+		retval = -ERANGE;
+		goto done;
+	}
+	/* Is it claimed ? */
+	if (c->busy) {
+		retval = -EBUSY;
+		goto done;
+	}
+	c->busy = 1;
+
+	/* See if we have a handler for this RAR yet, if we do then fire it */
+	rar = rar_to_device(num, &idx);
 
-		mutex_unlock(&rar_mutex);
+	if (rar) {
 		/*
 		* if the driver already registered, then we can simply
 		* call the callback right now
 		*/
-
-		return (*callback)(yourparameter);
-	}
-
-	if (num_clients < MRST_NUM_RAR) {
-
-		clients[num_clients].client_callback = callback;
-		clients[num_clients].customer_data = yourparameter;
-		num_clients += 1;
-		result = 0;
+		(*callback)(data);
+		goto done;
 	}
 
+	/* Arrange to be called back when the hardware is found */
+	c->callback = callback;
+	c->driver_priv = data;
+done:
 	mutex_unlock(&rar_mutex);
-	return result;
-
+	return retval;
 }
 EXPORT_SYMBOL(register_rar);
 
-/* Suspend - returns -ENOSYS */
-static int rar_suspend(struct pci_dev *dev, pm_message_t state)
+/**
+ *	unregister_rar	-	release a RAR allocation
+ *	@num: RAR number
+ *
+ *	Releases a RAR allocation, or pending allocation. If a callback is
+ *	pending then this function will either complete before the unregister
+ *	returns or not at all.
+ */
+
+void unregister_rar(int num)
 {
-	return -ENOSYS;
+	struct client *c;
+
+	mutex_lock(&rar_mutex);
+	c = rar_to_client(num);
+	if (c == NULL || !c->busy)
+		WARN_ON(1);
+	else
+		c->busy = 0;
+	mutex_unlock(&rar_mutex);
 }
+EXPORT_SYMBOL(unregister_rar);
 
-static int rar_resume(struct pci_dev *dev)
+/**
+ *	rar_callback		-	Process callbacks
+ *	@rar: new RAR device
+ *
+ *	Process the callbacks for a newly found RAR device.
+ */
+
+static void rar_callback(struct rar_device *rar)
 {
-	return -ENOSYS;
+	struct client *c = &rar->client[0];
+	int i;
+
+	mutex_lock(&rar_mutex);
+
+	rar->registered = 1;	/* Ensure no more callbacks queue */
+
+	for (i = 0; i < MRST_NUM_RAR; i++) {
+		if (c->callback && c->busy) {
+			c->callback(c->driver_priv);
+			c->callback = NULL;
+		}
+		c++;
+	}
+	mutex_unlock(&rar_mutex);
 }
 
-/*
- * This function registers the driver with the device subsystem (
- * either PCI, USB, etc).
- * Function that is activaed on the succesful probe of the RAR device
- * (Moorestown host controller).
+/**
+ *	rar_probe		-	PCI probe callback
+ *	@dev: PCI device
+ *	@id: matching entry in the match table
+ *
+ *	A RAR device has been discovered. Initialise it and if successful
+ *	process any pending callbacks that can now be completed.
  */
 static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int error;
-	int counter;
+	struct rar_device *rar;
 
 	dev_dbg(&dev->dev, "PCI probe starting\n");
 
-	/* enable the device */
+	rar = alloc_rar_device();
+	if (rar == NULL)
+		return -EBUSY;
+
+	/* Enable the device */
 	error = pci_enable_device(dev);
 	if (error) {
 		dev_err(&dev->dev,
@@ -538,50 +620,30 @@ static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto end_function;
 	}
 
-	/* we have only one device; fill in the rar_device structure */
-	my_rar_device.rar_dev = dev;
+	/* Fill in the rar_device structure */
+	rar->rar_dev = pci_dev_get(dev);
+	pci_set_drvdata(dev, rar);
 
 	/*
-	* Initialize the RAR parameters, which have to be retrieved
-	* via the message bus interface.
-	*/
-	error = init_rar_params(dev);
+	 * Initialize the RAR parameters, which have to be retrieved
+	 * via the message bus interface.
+	 */
+	error = init_rar_params(rar);
 	if (error) {
 		pci_disable_device(dev);
-
-		dev_err(&dev->dev,
-			"Error retrieving RAR addresses\n");
-
+		dev_err(&dev->dev, "Error retrieving RAR addresses\n");
 		goto end_function;
 	}
-
-	dev_dbg(&dev->dev, "PCI probe locking\n");
-	mutex_lock(&rar_mutex);
-	my_rar_device.registered = 1;
-
 	/* now call anyone who has registered (using callbacks) */
-	for (counter = 0; counter < num_clients; counter += 1) {
-		if (clients[counter].client_callback) {
-			error = (*clients[counter].client_callback)(
-				clients[counter].customer_data);
-			/* set callback to NULL to indicate it has been done */
-			clients[counter].client_callback = NULL;
-				dev_dbg(&my_rar_device.rar_dev->dev,
-				"Callback called for %d\n",
-			counter);
-		}
-	}
-
-	dev_dbg(&dev->dev, "PCI probe unlocking\n");
-	mutex_unlock(&rar_mutex);
-
+	rar_callback(rar);
+	return 0;
 end_function:
-
+	free_rar_device(rar);
 	return error;
 }
 
 const struct pci_device_id rar_pci_id_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_RAR_DEVICE_ID) },
+	{ PCI_VDEVICE(INTEL, 0x4110) },
 	{ 0 }
 };
 
@@ -594,8 +656,7 @@ static struct pci_driver rar_pci_driver = {
 	.name = "rar_register_driver",
 	.id_table = rar_pci_id_tbl,
 	.probe = rar_probe,
-	.suspend = rar_suspend,
-	.resume = rar_resume
+	/* Cannot be unplugged - no remove */
 };
 
 static int __init rar_init_handler(void)
diff --git a/drivers/staging/rar_register/rar_register.h b/drivers/staging/rar_register/rar_register.h
index 29ade0f..ffa8057 100644
--- a/drivers/staging/rar_register/rar_register.h
+++ b/drivers/staging/rar_register/rar_register.h
@@ -21,63 +21,23 @@
 #ifndef _RAR_REGISTER_H
 #define _RAR_REGISTER_H
 
-# include <linux/types.h>
+#include <linux/types.h>
 
 /* following are used both in drivers as well as user space apps */
-enum RAR_type {
-	RAR_TYPE_VIDEO = 0,
-	RAR_TYPE_AUDIO,
-	RAR_TYPE_IMAGE,
-	RAR_TYPE_DATA
-};
 
-#ifdef __KERNEL__
+#define	RAR_TYPE_VIDEO	0
+#define	RAR_TYPE_AUDIO	1
+#define	RAR_TYPE_IMAGE	2
+#define	RAR_TYPE_DATA	3
 
-/* PCI device id for controller */
-#define PCI_RAR_DEVICE_ID 0x4110
+#ifdef __KERNEL__
 
-/* The register_rar function is to used by other device drivers
- * to ensure that this driver is ready. As we cannot be sure of
- * the compile/execute order of dirvers in ther kernel, it is
- * best to give this driver a callback function to call when
- * it is ready to give out addresses. The callback function
- * would have those steps that continue the initialization of
- * a driver that do require a valid RAR address. One of those
- * steps would be to call get_rar_address()
- * This function return 0 on success an -1 on failure.
- */
-int register_rar(int (*callback)(void *yourparameter), void *yourparameter);
+struct rar_device;
 
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int rar_get_address(int rar_index,
-		dma_addr_t *start_address,
-		dma_addr_t *end_address);
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
+int register_rar(int num,
+		int (*callback)(unsigned long data), unsigned long data);
+void unregister_rar(int num);
+int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end);
 int rar_lock(int rar_index);
 
 #endif  /* __KERNEL__ */
