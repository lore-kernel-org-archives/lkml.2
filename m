Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0CYNpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:45:04 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:56741 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0CYNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:44:59 -0400
X-SENDER-IP: [83.226.249.76]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkY5ALoFq0tT4vlMPGdsb2JhbACHcJM0DAEBAQE3LbEeA41whH0E
X-IronPort-AV: E=Sophos;i="4.51,307,1267398000"; 
   d="scan'208";a="55369541"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       harvey.harrison@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35reg.c Coding style fixes v2.
Date: Thu, 25 Mar 2010 14:44:53 +0100
Message-Id: <1269524693-27586-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the problems reported by checkpatch.pl excetp for
long lines, a couple of printks and some warnings about usb_free_urb(NULL).
I checked for regressions with Dan Carpenters strip_whitespace.pl
and diff and everything looks good.
Generated .o is identical to master.

This is a new patch against master where I fixed up a switch-statement
after comments from Pavel Machek.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35reg.c |  618 ++++++++++++++++++-------------------
 1 files changed, 305 insertions(+), 313 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index f5608ad..6f47813 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -5,60 +5,61 @@
 
 extern void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
 
-// true  : read command process successfully
-// false : register not support
-// RegisterNo : start base
-// pRegisterData : data point
-// NumberOfData : number of register data
-// Flag : AUTO_INCREMENT - RegisterNo will auto increment 4
-//		  NO_INCREMENT - Function will write data into the same register
-unsigned char
-Wb35Reg_BurstWrite(struct hw_data * pHwData, u16 RegisterNo, u32 * pRegisterData, u8 NumberOfData, u8 Flag)
+/*
+ * true  : read command process successfully
+ * false : register not support
+ * RegisterNo : start base
+ * pRegisterData : data point
+ * NumberOfData : number of register data
+ * Flag : AUTO_INCREMENT - RegisterNo will auto increment 4
+ *	  NO_INCREMENT - Function will write data into the same register
+ */
+unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterData, u8 NumberOfData, u8 Flag)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct urb	*urb = NULL;
-	struct wb35_reg_queue *reg_queue = NULL;
-	u16		UrbSize;
-	struct      usb_ctrlrequest *dr;
-	u16		i, DataSize = NumberOfData*4;
-
-	// Module shutdown
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct urb		*urb = NULL;
+	struct wb35_reg_queue	*reg_queue = NULL;
+	u16			UrbSize;
+	struct usb_ctrlrequest	*dr;
+	u16			i, DataSize = NumberOfData * 4;
+
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
-	// Trying to use burst write function if use new hardware
+	/* Trying to use burst write function if use new hardware */
 	UrbSize = sizeof(struct wb35_reg_queue) + DataSize + sizeof(struct usb_ctrlrequest);
 	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if( urb && reg_queue ) {
-		reg_queue->DIRECT = 2;// burst write register
+	if (urb && reg_queue) {
+		reg_queue->DIRECT = 2; /* burst write register */
 		reg_queue->INDEX = RegisterNo;
 		reg_queue->pBuffer = (u32 *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue));
-		memcpy( reg_queue->pBuffer, pRegisterData, DataSize );
-		//the function for reversing register data from little endian to big endian
-		for( i=0; i<NumberOfData ; i++ )
-			reg_queue->pBuffer[i] = cpu_to_le32( reg_queue->pBuffer[i] );
+		memcpy(reg_queue->pBuffer, pRegisterData, DataSize);
+		/* the function for reversing register data from little endian to big endian */
+		for (i = 0; i < NumberOfData ; i++)
+			reg_queue->pBuffer[i] = cpu_to_le32(reg_queue->pBuffer[i]);
 
 		dr = (struct usb_ctrlrequest *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue) + DataSize);
 		dr->bRequestType = USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE;
-		dr->bRequest = 0x04; // USB or vendor-defined request code, burst mode
-		dr->wValue = cpu_to_le16( Flag ); // 0: Register number auto-increment, 1: No auto increment
-		dr->wIndex = cpu_to_le16( RegisterNo );
-		dr->wLength = cpu_to_le16( DataSize );
+		dr->bRequest = 0x04; /* USB or vendor-defined request code, burst mode */
+		dr->wValue = cpu_to_le16(Flag); /* 0: Register number auto-increment, 1: No auto increment */
+		dr->wIndex = cpu_to_le16(RegisterNo);
+		dr->wLength = cpu_to_le16(DataSize);
 		reg_queue->Next = NULL;
 		reg_queue->pUsbReq = dr;
 		reg_queue->urb = urb;
 
-		spin_lock_irq( &reg->EP0VM_spin_lock );
+		spin_lock_irq(&reg->EP0VM_spin_lock);
 		if (reg->reg_first == NULL)
 			reg->reg_first = reg_queue;
 		else
 			reg->reg_last->Next = reg_queue;
 		reg->reg_last = reg_queue;
 
-		spin_unlock_irq( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
-		// Start EP0VM
+		/* Start EP0VM */
 		Wb35Reg_EP0VM_start(pHwData);
 
 		return true;
@@ -72,8 +73,7 @@ Wb35Reg_BurstWrite(struct hw_data * pHwData, u16 RegisterNo, u32 * pRegisterData
    return false;
 }
 
-void
-Wb35Reg_Update(struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue)
+void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	switch (RegisterNo) {
@@ -115,97 +115,96 @@ Wb35Reg_Update(struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue)
 	}
 }
 
-// true  : read command process successfully
-// false : register not support
-unsigned char
-Wb35Reg_WriteSync(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue )
+/*
+ * true  : read command process successfully
+ * false : register not support
+ */
+unsigned char Wb35Reg_WriteSync(struct hw_data *pHwData, u16 RegisterNo, u32 RegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	int ret = -1;
 
-	// Module shutdown
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
 	RegisterValue = cpu_to_le32(RegisterValue);
 
-	// update the register by send usb message------------------------------------
+	/* update the register by send usb message */
 	reg->SyncIoPause = 1;
 
-	// 20060717.5 Wait until EP0VM stop
+	/* Wait until EP0VM stop */
 	while (reg->EP0vm_state != VM_STOP)
 		msleep(10);
 
-	// Sync IoCallDriver
+	/* Sync IoCallDriver */
 	reg->EP0vm_state = VM_RUNNING;
-	ret = usb_control_msg( pHwData->WbUsb.udev,
-			       usb_sndctrlpipe( pHwData->WbUsb.udev, 0 ),
+	ret = usb_control_msg(pHwData->WbUsb.udev,
+			       usb_sndctrlpipe(pHwData->WbUsb.udev, 0),
 			       0x03, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			       0x0,RegisterNo, &RegisterValue, 4, HZ*100 );
+			       0x0, RegisterNo, &RegisterValue, 4, HZ * 100);
 	reg->EP0vm_state = VM_STOP;
 	reg->SyncIoPause = 0;
 
 	Wb35Reg_EP0VM_start(pHwData);
 
 	if (ret < 0) {
-		#ifdef _PE_REG_DUMP_
+#ifdef _PE_REG_DUMP_
 		printk("EP0 Write register usb message sending error\n");
-		#endif
-
-		pHwData->SurpriseRemove = 1; // 20060704.2
+#endif
+		pHwData->SurpriseRemove = 1;
 		return false;
 	}
-
 	return true;
 }
 
-// true  : read command process successfully
-// false : register not support
-unsigned char
-Wb35Reg_Write(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue )
+/*
+ * true  : read command process successfully
+ * false : register not support
+ */
+unsigned char Wb35Reg_Write(struct hw_data *pHwData, u16 RegisterNo, u32 RegisterValue)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct usb_ctrlrequest *dr;
-	struct urb	*urb = NULL;
-	struct wb35_reg_queue *reg_queue = NULL;
-	u16		UrbSize;
-
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct usb_ctrlrequest	*dr;
+	struct urb		*urb = NULL;
+	struct wb35_reg_queue	*reg_queue = NULL;
+	u16			UrbSize;
 
-	// Module shutdown
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
-	// update the register by send urb request------------------------------------
+	/* update the register by send urb request */
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
-		reg_queue->DIRECT = 1;// burst write register
+		reg_queue->DIRECT = 1; /* burst write register */
 		reg_queue->INDEX = RegisterNo;
 		reg_queue->VALUE = cpu_to_le32(RegisterValue);
 		reg_queue->RESERVED_VALID = false;
 		dr = (struct usb_ctrlrequest *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue));
-		dr->bRequestType = USB_TYPE_VENDOR|USB_DIR_OUT |USB_RECIP_DEVICE;
-		dr->bRequest = 0x03; // USB or vendor-defined request code, burst mode
+		dr->bRequestType = USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE;
+		dr->bRequest = 0x03; /* USB or vendor-defined request code, burst mode */
 		dr->wValue = cpu_to_le16(0x0);
 		dr->wIndex = cpu_to_le16(RegisterNo);
 		dr->wLength = cpu_to_le16(4);
 
-		// Enter the sending queue
+		/* Enter the sending queue */
 		reg_queue->Next = NULL;
 		reg_queue->pUsbReq = dr;
 		reg_queue->urb = urb;
 
-		spin_lock_irq(&reg->EP0VM_spin_lock );
+		spin_lock_irq(&reg->EP0VM_spin_lock);
 		if (reg->reg_first == NULL)
 			reg->reg_first = reg_queue;
 		else
 			reg->reg_last->Next = reg_queue;
 		reg->reg_last = reg_queue;
 
-		spin_unlock_irq( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
-		// Start EP0VM
+		/* Start EP0VM */
 		Wb35Reg_EP0VM_start(pHwData);
 
 		return true;
@@ -217,56 +216,60 @@ Wb35Reg_Write(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue )
 	}
 }
 
-//This command will be executed with a user defined value. When it completes,
-//this value is useful. For example, hal_set_current_channel will use it.
-// true  : read command process successfully
-// false : register not support
-unsigned char
-Wb35Reg_WriteWithCallbackValue( struct hw_data * pHwData, u16 RegisterNo, u32 RegisterValue,
-				s8 *pValue, s8 Len)
+/*
+ * This command will be executed with a user defined value. When it completes,
+ * this value is useful. For example, hal_set_current_channel will use it.
+ * true  : read command process successfully
+ * false : register not support
+ */
+unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *pHwData,
+						u16 RegisterNo,
+						u32 RegisterValue,
+						s8 *pValue,
+						s8 Len)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct usb_ctrlrequest *dr;
-	struct urb	*urb = NULL;
-	struct wb35_reg_queue *reg_queue = NULL;
-	u16		UrbSize;
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct usb_ctrlrequest	*dr;
+	struct urb		*urb = NULL;
+	struct wb35_reg_queue	*reg_queue = NULL;
+	u16			UrbSize;
 
-	// Module shutdown
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
-	// update the register by send urb request------------------------------------
+	/* update the register by send urb request */
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (urb && reg_queue) {
-		reg_queue->DIRECT = 1;// burst write register
+		reg_queue->DIRECT = 1; /* burst write register */
 		reg_queue->INDEX = RegisterNo;
 		reg_queue->VALUE = cpu_to_le32(RegisterValue);
-		//NOTE : Users must guarantee the size of value will not exceed the buffer size.
+		/* NOTE : Users must guarantee the size of value will not exceed the buffer size. */
 		memcpy(reg_queue->RESERVED, pValue, Len);
 		reg_queue->RESERVED_VALID = true;
 		dr = (struct usb_ctrlrequest *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue));
-		dr->bRequestType = USB_TYPE_VENDOR|USB_DIR_OUT |USB_RECIP_DEVICE;
-		dr->bRequest = 0x03; // USB or vendor-defined request code, burst mode
+		dr->bRequestType = USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE;
+		dr->bRequest = 0x03; /* USB or vendor-defined request code, burst mode */
 		dr->wValue = cpu_to_le16(0x0);
 		dr->wIndex = cpu_to_le16(RegisterNo);
 		dr->wLength = cpu_to_le16(4);
 
-		// Enter the sending queue
+		/* Enter the sending queue */
 		reg_queue->Next = NULL;
 		reg_queue->pUsbReq = dr;
 		reg_queue->urb = urb;
-		spin_lock_irq (&reg->EP0VM_spin_lock );
-		if( reg->reg_first == NULL )
+		spin_lock_irq(&reg->EP0VM_spin_lock);
+		if (reg->reg_first == NULL)
 			reg->reg_first = reg_queue;
 		else
 			reg->reg_last->Next = reg_queue;
 		reg->reg_last = reg_queue;
 
-		spin_unlock_irq ( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
-		// Start EP0VM
+		/* Start EP0VM */
 		Wb35Reg_EP0VM_start(pHwData);
 		return true;
 	} else {
@@ -277,115 +280,114 @@ Wb35Reg_WriteWithCallbackValue( struct hw_data * pHwData, u16 RegisterNo, u32 Re
 	}
 }
 
-// true  : read command process successfully
-// false : register not support
-// pRegisterValue : It must be a resident buffer due to asynchronous read register.
-unsigned char
-Wb35Reg_ReadSync(  struct hw_data * pHwData,  u16 RegisterNo,   u32 * pRegisterValue )
+/*
+ * true  : read command process successfully
+ * false : register not support
+ * pRegisterValue : It must be a resident buffer due to
+ *		    asynchronous read register.
+ */
+unsigned char Wb35Reg_ReadSync(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterValue)
 {
 	struct wb35_reg *reg = &pHwData->reg;
-	u32 *	pltmp = pRegisterValue;
-	int ret = -1;
+	u32		*pltmp = pRegisterValue;
+	int		ret = -1;
 
-	// Module shutdown
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
-	// Read the register by send usb message------------------------------------
-
+	/* Read the register by send usb message */
 	reg->SyncIoPause = 1;
 
-	// 20060717.5 Wait until EP0VM stop
+	/* Wait until EP0VM stop */
 	while (reg->EP0vm_state != VM_STOP)
 		msleep(10);
 
 	reg->EP0vm_state = VM_RUNNING;
-	ret = usb_control_msg( pHwData->WbUsb.udev,
+	ret = usb_control_msg(pHwData->WbUsb.udev,
 			       usb_rcvctrlpipe(pHwData->WbUsb.udev, 0),
-			       0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
-			       0x0, RegisterNo, pltmp, 4, HZ*100 );
+			       0x01, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			       0x0, RegisterNo, pltmp, 4, HZ * 100);
 
 	*pRegisterValue = cpu_to_le32(*pltmp);
 
 	reg->EP0vm_state = VM_STOP;
 
-	Wb35Reg_Update( pHwData, RegisterNo, *pRegisterValue );
+	Wb35Reg_Update(pHwData, RegisterNo, *pRegisterValue);
 	reg->SyncIoPause = 0;
 
-	Wb35Reg_EP0VM_start( pHwData );
+	Wb35Reg_EP0VM_start(pHwData);
 
 	if (ret < 0) {
-		#ifdef _PE_REG_DUMP_
+#ifdef _PE_REG_DUMP_
 		printk("EP0 Read register usb message sending error\n");
-		#endif
-
-		pHwData->SurpriseRemove = 1; // 20060704.2
+#endif
+		pHwData->SurpriseRemove = 1;
 		return false;
 	}
-
 	return true;
 }
 
-// true  : read command process successfully
-// false : register not support
-// pRegisterValue : It must be a resident buffer due to asynchronous read register.
-unsigned char
-Wb35Reg_Read(struct hw_data * pHwData, u16 RegisterNo,  u32 * pRegisterValue )
+/*
+ * true  : read command process successfully
+ * false : register not support
+ * pRegisterValue : It must be a resident buffer due to
+ *		    asynchronous read register.
+ */
+unsigned char Wb35Reg_Read(struct hw_data *pHwData, u16 RegisterNo, u32 *pRegisterValue)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct usb_ctrlrequest * dr;
-	struct urb	*urb;
-	struct wb35_reg_queue *reg_queue;
-	u16		UrbSize;
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct usb_ctrlrequest	*dr;
+	struct urb		*urb;
+	struct wb35_reg_queue	*reg_queue;
+	u16			UrbSize;
 
-	// Module shutdown
+	/* Module shutdown */
 	if (pHwData->SurpriseRemove)
 		return false;
 
-	// update the variable by send Urb to read register ------------------------------------
+	/* update the variable by send Urb to read register */
 	UrbSize = sizeof(struct wb35_reg_queue) + sizeof(struct usb_ctrlrequest);
 	reg_queue = kzalloc(UrbSize, GFP_ATOMIC);
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if( urb && reg_queue )
-	{
-		reg_queue->DIRECT = 0;// read register
+	if (urb && reg_queue) {
+		reg_queue->DIRECT = 0; /* read register */
 		reg_queue->INDEX = RegisterNo;
 		reg_queue->pBuffer = pRegisterValue;
 		dr = (struct usb_ctrlrequest *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue));
-		dr->bRequestType = USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN;
-		dr->bRequest = 0x01; // USB or vendor-defined request code, burst mode
+		dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN;
+		dr->bRequest = 0x01; /* USB or vendor-defined request code, burst mode */
 		dr->wValue = cpu_to_le16(0x0);
-		dr->wIndex = cpu_to_le16 (RegisterNo);
-		dr->wLength = cpu_to_le16 (4);
+		dr->wIndex = cpu_to_le16(RegisterNo);
+		dr->wLength = cpu_to_le16(4);
 
-		// Enter the sending queue
+		/* Enter the sending queue */
 		reg_queue->Next = NULL;
 		reg_queue->pUsbReq = dr;
 		reg_queue->urb = urb;
-		spin_lock_irq ( &reg->EP0VM_spin_lock );
-		if( reg->reg_first == NULL )
+		spin_lock_irq(&reg->EP0VM_spin_lock);
+		if (reg->reg_first == NULL)
 			reg->reg_first = reg_queue;
 		else
 			reg->reg_last->Next = reg_queue;
 		reg->reg_last = reg_queue;
 
-		spin_unlock_irq( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
-		// Start EP0VM
-		Wb35Reg_EP0VM_start( pHwData );
+		/* Start EP0VM */
+		Wb35Reg_EP0VM_start(pHwData);
 
 		return true;
 	} else {
 		if (urb)
-			usb_free_urb( urb );
+			usb_free_urb(urb);
 		kfree(reg_queue);
 		return false;
 	}
 }
 
 
-void
-Wb35Reg_EP0VM_start(  struct hw_data * pHwData )
+void Wb35Reg_EP0VM_start(struct hw_data *pHwData)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
@@ -396,15 +398,14 @@ Wb35Reg_EP0VM_start(  struct hw_data * pHwData )
 		atomic_dec(&reg->RegFireCount);
 }
 
-void
-Wb35Reg_EP0VM(struct hw_data * pHwData )
+void Wb35Reg_EP0VM(struct hw_data *pHwData)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct urb	*urb;
-	struct usb_ctrlrequest *dr;
-	u32 *		pBuffer;
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct urb		*urb;
+	struct usb_ctrlrequest	*dr;
+	u32			*pBuffer;
 	int			ret = -1;
-	struct wb35_reg_queue *reg_queue;
+	struct wb35_reg_queue	*reg_queue;
 
 
 	if (reg->SyncIoPause)
@@ -413,27 +414,27 @@ Wb35Reg_EP0VM(struct hw_data * pHwData )
 	if (pHwData->SurpriseRemove)
 		goto cleanup;
 
-	// Get the register data and send to USB through Irp
-	spin_lock_irq( &reg->EP0VM_spin_lock );
+	/* Get the register data and send to USB through Irp */
+	spin_lock_irq(&reg->EP0VM_spin_lock);
 	reg_queue = reg->reg_first;
-	spin_unlock_irq( &reg->EP0VM_spin_lock );
+	spin_unlock_irq(&reg->EP0VM_spin_lock);
 
 	if (!reg_queue)
 		goto cleanup;
 
-	// Get an Urb, send it
+	/* Get an Urb, send it */
 	urb = (struct urb *)reg_queue->urb;
 
 	dr = reg_queue->pUsbReq;
 	urb = reg_queue->urb;
 	pBuffer = reg_queue->pBuffer;
-	if (reg_queue->DIRECT == 1) // output
+	if (reg_queue->DIRECT == 1) /* output */
 		pBuffer = &reg_queue->VALUE;
 
-	usb_fill_control_urb( urb, pHwData->WbUsb.udev,
-			      REG_DIRECTION(pHwData->WbUsb.udev,reg_queue),
-			      (u8 *)dr,pBuffer,cpu_to_le16(dr->wLength),
-			      Wb35Reg_EP0VM_complete, (void*)pHwData);
+	usb_fill_control_urb(urb, pHwData->WbUsb.udev,
+			      REG_DIRECTION(pHwData->WbUsb.udev, reg_queue),
+			      (u8 *)dr, pBuffer, cpu_to_le16(dr->wLength),
+			      Wb35Reg_EP0VM_complete, (void *)pHwData);
 
 	reg->EP0vm_state = VM_RUNNING;
 
@@ -445,7 +446,6 @@ Wb35Reg_EP0VM(struct hw_data * pHwData )
 #endif
 		goto cleanup;
 	}
-
 	return;
 
  cleanup:
@@ -454,29 +454,28 @@ Wb35Reg_EP0VM(struct hw_data * pHwData )
 }
 
 
-void
-Wb35Reg_EP0VM_complete(struct urb *urb)
+void Wb35Reg_EP0VM_complete(struct urb *urb)
 {
-	struct hw_data *  pHwData = (struct hw_data *)urb->context;
-	struct wb35_reg *reg = &pHwData->reg;
-	struct wb35_reg_queue *reg_queue;
+	struct hw_data		*pHwData = (struct hw_data *)urb->context;
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct wb35_reg_queue	*reg_queue;
 
 
-	// Variable setting
+	/* Variable setting */
 	reg->EP0vm_state = VM_COMPLETED;
 	reg->EP0VM_status = urb->status;
 
-	if (pHwData->SurpriseRemove) { // Let WbWlanHalt to handle surprise remove
+	if (pHwData->SurpriseRemove) { /* Let WbWlanHalt to handle surprise remove */
 		reg->EP0vm_state = VM_STOP;
 		atomic_dec(&reg->RegFireCount);
 	} else {
-		// Complete to send, remove the URB from the first
-		spin_lock_irq( &reg->EP0VM_spin_lock );
+		/* Complete to send, remove the URB from the first */
+		spin_lock_irq(&reg->EP0VM_spin_lock);
 		reg_queue = reg->reg_first;
 		if (reg_queue == reg->reg_last)
 			reg->reg_last = NULL;
 		reg->reg_first = reg->reg_first->Next;
-		spin_unlock_irq( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 
 		if (reg->EP0VM_status) {
 #ifdef _PE_REG_DUMP_
@@ -485,37 +484,35 @@ Wb35Reg_EP0VM_complete(struct urb *urb)
 			reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
 		} else {
-			// Success. Update the result
+			/* Success. Update the result */
 
-			// Start the next send
+			/* Start the next send */
 			Wb35Reg_EP0VM(pHwData);
 		}
 
-   		kfree(reg_queue);
+		kfree(reg_queue);
 	}
 
 	usb_free_urb(urb);
 }
 
 
-void
-Wb35Reg_destroy(struct hw_data * pHwData)
+void Wb35Reg_destroy(struct hw_data *pHwData)
 {
-	struct wb35_reg *reg = &pHwData->reg;
-	struct urb	*urb;
-	struct wb35_reg_queue *reg_queue;
-
+	struct wb35_reg		*reg = &pHwData->reg;
+	struct urb		*urb;
+	struct wb35_reg_queue	*reg_queue;
 
 	Uxx_power_off_procedure(pHwData);
 
-	// Wait for Reg operation completed
+	/* Wait for Reg operation completed */
 	do {
-		msleep(10); // Delay for waiting function enter 940623.1.a
+		msleep(10); /* Delay for waiting function enter */
 	} while (reg->EP0vm_state != VM_STOP);
-	msleep(10);  // Delay for waiting function enter 940623.1.b
+	msleep(10);  /* Delay for waiting function enter */
 
-	// Release all the data in RegQueue
-	spin_lock_irq( &reg->EP0VM_spin_lock );
+	/* Release all the data in RegQueue */
+	spin_lock_irq(&reg->EP0VM_spin_lock);
 	reg_queue = reg->reg_first;
 	while (reg_queue) {
 		if (reg_queue == reg->reg_last)
@@ -523,84 +520,88 @@ Wb35Reg_destroy(struct hw_data * pHwData)
 		reg->reg_first = reg->reg_first->Next;
 
 		urb = reg_queue->urb;
-		spin_unlock_irq( &reg->EP0VM_spin_lock );
+		spin_unlock_irq(&reg->EP0VM_spin_lock);
 		if (urb) {
 			usb_free_urb(urb);
 			kfree(reg_queue);
 		} else {
-			#ifdef _PE_REG_DUMP_
+#ifdef _PE_REG_DUMP_
 			printk("EP0 queue release error\n");
-			#endif
+#endif
 		}
-		spin_lock_irq( &reg->EP0VM_spin_lock );
+		spin_lock_irq(&reg->EP0VM_spin_lock);
 
 		reg_queue = reg->reg_first;
 	}
-	spin_unlock_irq( &reg->EP0VM_spin_lock );
+	spin_unlock_irq(&reg->EP0VM_spin_lock);
 }
 
-//====================================================================================
-// The function can be run in passive-level only.
-//====================================================================================
-unsigned char Wb35Reg_initial(struct hw_data * pHwData)
+/*
+ * =======================================================================
+ * The function can be run in passive-level only.
+ * =========================================================================
+ */
+unsigned char Wb35Reg_initial(struct hw_data *pHwData)
 {
-	struct wb35_reg *reg=&pHwData->reg;
+	struct wb35_reg *reg = &pHwData->reg;
 	u32 ltmp;
 	u32 SoftwareSet, VCO_trim, TxVga, Region_ScanInterval;
 
-	// Spin lock is acquired for read and write IRP command
-	spin_lock_init( &reg->EP0VM_spin_lock );
-
-	// Getting RF module type from EEPROM ------------------------------------
-	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x080d0000 ); // Start EEPROM access + Read + address(0x0d)
-	Wb35Reg_ReadSync( pHwData, 0x03b4, &ltmp );
-
-	//Update RF module type and determine the PHY type by inf or EEPROM
-	reg->EEPROMPhyType = (u8)( ltmp & 0xff );
-	// 0 V MAX2825, 1 V MAX2827, 2 V MAX2828, 3 V MAX2829
-	// 16V AL2230, 17 - AL7230, 18 - AL2230S
-	// 32 Reserved
-	// 33 - W89RF242(TxVGA 0~19), 34 - W89RF242(TxVGA 0~34)
+	/* Spin lock is acquired for read and write IRP command */
+	spin_lock_init(&reg->EP0VM_spin_lock);
+
+	/* Getting RF module type from EEPROM */
+	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x080d0000); /* Start EEPROM access + Read + address(0x0d) */
+	Wb35Reg_ReadSync(pHwData, 0x03b4, &ltmp);
+
+	/* Update RF module type and determine the PHY type by inf or EEPROM */
+	reg->EEPROMPhyType = (u8)(ltmp & 0xff);
+	/*
+	 * 0 V MAX2825, 1 V MAX2827, 2 V MAX2828, 3 V MAX2829
+	 * 16V AL2230, 17 - AL7230, 18 - AL2230S
+	 * 32 Reserved
+	 * 33 - W89RF242(TxVGA 0~19), 34 - W89RF242(TxVGA 0~34)
+	 */
 	if (reg->EEPROMPhyType != RF_DECIDE_BY_INF) {
-		if( (reg->EEPROMPhyType == RF_MAXIM_2825)	||
+		if ((reg->EEPROMPhyType == RF_MAXIM_2825)	||
 			(reg->EEPROMPhyType == RF_MAXIM_2827)	||
 			(reg->EEPROMPhyType == RF_MAXIM_2828)	||
 			(reg->EEPROMPhyType == RF_MAXIM_2829)	||
 			(reg->EEPROMPhyType == RF_MAXIM_V1)	||
 			(reg->EEPROMPhyType == RF_AIROHA_2230)	||
-			(reg->EEPROMPhyType == RF_AIROHA_2230S)    ||
+			(reg->EEPROMPhyType == RF_AIROHA_2230S)	||
 			(reg->EEPROMPhyType == RF_AIROHA_7230)	||
-			(reg->EEPROMPhyType == RF_WB_242)		||
+			(reg->EEPROMPhyType == RF_WB_242)	||
 			(reg->EEPROMPhyType == RF_WB_242_1))
 			pHwData->phy_type = reg->EEPROMPhyType;
 	}
 
-	// Power On procedure running. The relative parameter will be set according to phy_type
-	Uxx_power_on_procedure( pHwData );
+	/* Power On procedure running. The relative parameter will be set according to phy_type */
+	Uxx_power_on_procedure(pHwData);
 
-	// Reading MAC address
-	Uxx_ReadEthernetAddress( pHwData );
+	/* Reading MAC address */
+	Uxx_ReadEthernetAddress(pHwData);
 
-	// Read VCO trim for RF parameter
-	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x08200000 );
-	Wb35Reg_ReadSync( pHwData, 0x03b4, &VCO_trim );
+	/* Read VCO trim for RF parameter */
+	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x08200000);
+	Wb35Reg_ReadSync(pHwData, 0x03b4, &VCO_trim);
 
-	// Read Antenna On/Off of software flag
-	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x08210000 );
-	Wb35Reg_ReadSync( pHwData, 0x03b4, &SoftwareSet );
+	/* Read Antenna On/Off of software flag */
+	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x08210000);
+	Wb35Reg_ReadSync(pHwData, 0x03b4, &SoftwareSet);
 
-	// Read TXVGA
-	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x08100000 );
-	Wb35Reg_ReadSync( pHwData, 0x03b4, &TxVga );
+	/* Read TXVGA */
+	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x08100000);
+	Wb35Reg_ReadSync(pHwData, 0x03b4, &TxVga);
 
-	// Get Scan interval setting from EEPROM offset 0x1c
-	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x081d0000 );
-	Wb35Reg_ReadSync( pHwData, 0x03b4, &Region_ScanInterval );
+	/* Get Scan interval setting from EEPROM offset 0x1c */
+	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x081d0000);
+	Wb35Reg_ReadSync(pHwData, 0x03b4, &Region_ScanInterval);
 
-	// Update Ethernet address
-	memcpy( pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_ALEN );
+	/* Update Ethernet address */
+	memcpy(pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_ALEN);
 
-	// Update software variable
+	/* Update software variable */
 	pHwData->SoftwareSet = (u16)(SoftwareSet & 0xffff);
 	TxVga &= 0x000000ff;
 	pHwData->PowerIndexFromEEPROM = (u8)TxVga;
@@ -608,22 +609,22 @@ unsigned char Wb35Reg_initial(struct hw_data * pHwData)
 	if (pHwData->VCO_trim == 0xff)
 		pHwData->VCO_trim = 0x28;
 
-	reg->EEPROMRegion = (u8)(Region_ScanInterval>>8); // 20060720
-	if( reg->EEPROMRegion<1 || reg->EEPROMRegion>6 )
+	reg->EEPROMRegion = (u8)(Region_ScanInterval >> 8);
+	if (reg->EEPROMRegion < 1 || reg->EEPROMRegion > 6)
 		reg->EEPROMRegion = REGION_AUTO;
 
-	//For Get Tx VGA from EEPROM 20060315.5 move here
-	GetTxVgaFromEEPROM( pHwData );
+	/* For Get Tx VGA from EEPROM */
+	GetTxVgaFromEEPROM(pHwData);
 
-	// Set Scan Interval
+	/* Set Scan Interval */
 	pHwData->Scan_Interval = (u8)(Region_ScanInterval & 0xff) * 10;
-	if ((pHwData->Scan_Interval == 2550) || (pHwData->Scan_Interval < 10)) // Is default setting 0xff * 10
+	if ((pHwData->Scan_Interval == 2550) || (pHwData->Scan_Interval < 10)) /* Is default setting 0xff * 10 */
 		pHwData->Scan_Interval = SCAN_MAX_CHNL_TIME;
 
-	// Initial register
+	/* Initial register */
 	RFSynthesizer_initial(pHwData);
 
-	BBProcessor_initial(pHwData); // Async write, must wait until complete
+	BBProcessor_initial(pHwData); /* Async write, must wait until complete */
 
 	Wb35Reg_phy_calibration(pHwData);
 
@@ -633,113 +634,104 @@ unsigned char Wb35Reg_initial(struct hw_data * pHwData)
 	if (pHwData->SurpriseRemove)
 		return false;
 	else
-		return true; // Initial fail
+		return true; /* Initial fail */
 }
 
-//===================================================================================
-//  CardComputeCrc --
-//
-//  Description:
-//    Runs the AUTODIN II CRC algorithm on buffer Buffer of length, Length.
-//
-//  Arguments:
-//    Buffer - the input buffer
-//    Length - the length of Buffer
-//
-//  Return Value:
-//    The 32-bit CRC value.
-//
-//  Note:
-//    This is adapted from the comments in the assembly language
-//    version in _GENREQ.ASM of the DWB NE1000/2000 driver.
-//==================================================================================
-u32
-CardComputeCrc(u8 * Buffer, u32 Length)
+/*
+ * ================================================================
+ *  CardComputeCrc --
+ *
+ *  Description:
+ *    Runs the AUTODIN II CRC algorithm on buffer Buffer of length, Length.
+ *
+ *  Arguments:
+ *    Buffer - the input buffer
+ *    Length - the length of Buffer
+ *
+ *  Return Value:
+ *    The 32-bit CRC value.
+ * ===================================================================
+ */
+u32 CardComputeCrc(u8 *Buffer, u32 Length)
 {
-    u32 Crc, Carry;
-    u32  i, j;
-    u8 CurByte;
-
-    Crc = 0xffffffff;
-
-    for (i = 0; i < Length; i++) {
-
-        CurByte = Buffer[i];
-
-        for (j = 0; j < 8; j++) {
-
-            Carry     = ((Crc & 0x80000000) ? 1 : 0) ^ (CurByte & 0x01);
-            Crc     <<= 1;
-            CurByte >>= 1;
-
-            if (Carry) {
-                Crc =(Crc ^ 0x04c11db6) | Carry;
-            }
-        }
-    }
-
-    return Crc;
+	u32	Crc, Carry;
+	u32	i, j;
+	u8	CurByte;
+
+	Crc = 0xffffffff;
+
+	for (i = 0; i < Length; i++) {
+		CurByte = Buffer[i];
+		for (j = 0; j < 8; j++) {
+			Carry = ((Crc & 0x80000000) ? 1 : 0) ^ (CurByte & 0x01);
+			Crc <<= 1;
+			CurByte >>= 1;
+			if (Carry)
+				Crc = (Crc ^ 0x04c11db6) | Carry;
+		}
+	}
+	return Crc;
 }
 
 
-//==================================================================
-// BitReverse --
-//   Reverse the bits in the input argument, dwData, which is
-//   regarded as a string of bits with the length, DataLength.
-//
-// Arguments:
-//   dwData     :
-//   DataLength :
-//
-// Return:
-//   The converted value.
-//==================================================================
-u32 BitReverse( u32 dwData, u32 DataLength)
+/*
+ * ==================================================================
+ * BitReverse --
+ *   Reverse the bits in the input argument, dwData, which is
+ *   regarded as a string of bits with the length, DataLength.
+ *
+ * Arguments:
+ *   dwData     :
+ *   DataLength :
+ *
+ * Return:
+ *   The converted value.
+ * ==================================================================
+ */
+u32 BitReverse(u32 dwData, u32 DataLength)
 {
-	u32   HalfLength, i, j;
-	u32   BitA, BitB;
+	u32	HalfLength, i, j;
+	u32	BitA, BitB;
 
-	if ( DataLength <= 0)       return 0;   // No conversion is done.
+	if (DataLength <= 0)
+		return 0;	/* No conversion is done. */
 	dwData = dwData & (0xffffffff >> (32 - DataLength));
 
 	HalfLength = DataLength / 2;
-	for ( i = 0, j = DataLength-1 ; i < HalfLength; i++, j--)
-	{
-		BitA = GetBit( dwData, i);
-		BitB = GetBit( dwData, j);
+	for (i = 0, j = DataLength - 1; i < HalfLength; i++, j--) {
+		BitA = GetBit(dwData, i);
+		BitB = GetBit(dwData, j);
 		if (BitA && !BitB) {
-			dwData = ClearBit( dwData, i);
-			dwData = SetBit( dwData, j);
+			dwData = ClearBit(dwData, i);
+			dwData = SetBit(dwData, j);
 		} else if (!BitA && BitB) {
-			dwData = SetBit( dwData, i);
-			dwData = ClearBit( dwData, j);
-		} else
-		{
-			// Do nothing since these two bits are of the save values.
+			dwData = SetBit(dwData, i);
+			dwData = ClearBit(dwData, j);
+		} else {
+			/* Do nothing since these two bits are of the save values. */
 		}
 	}
-
 	return dwData;
 }
 
-void Wb35Reg_phy_calibration(  struct hw_data * pHwData )
+void Wb35Reg_phy_calibration(struct hw_data *pHwData)
 {
-	u32 BB3c, BB54;
+	u32	BB3c, BB54;
 
 	if ((pHwData->phy_type == RF_WB_242) ||
 		(pHwData->phy_type == RF_WB_242_1)) {
-		phy_calibration_winbond ( pHwData, 2412 ); // Sync operation
-		Wb35Reg_ReadSync( pHwData, 0x103c, &BB3c );
-		Wb35Reg_ReadSync( pHwData, 0x1054, &BB54 );
+		phy_calibration_winbond(pHwData, 2412); /* Sync operation */
+		Wb35Reg_ReadSync(pHwData, 0x103c, &BB3c);
+		Wb35Reg_ReadSync(pHwData, 0x1054, &BB54);
 
 		pHwData->BB3c_cal = BB3c;
 		pHwData->BB54_cal = BB54;
 
 		RFSynthesizer_initial(pHwData);
-		BBProcessor_initial(pHwData); // Async operation
+		BBProcessor_initial(pHwData); /* Async operation */
 
-		Wb35Reg_WriteSync( pHwData, 0x103c, BB3c );
-		Wb35Reg_WriteSync( pHwData, 0x1054, BB54 );
+		Wb35Reg_WriteSync(pHwData, 0x103c, BB3c);
+		Wb35Reg_WriteSync(pHwData, 0x1054, BB54);
 	}
 }
 
-- 
1.7.0.3

