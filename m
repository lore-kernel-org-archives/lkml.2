Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0EDQZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:25:48 -0400
Received: from web94916.mail.in2.yahoo.com ([203.104.17.196]:42852 "HELO
	web94916.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753330Ab0EDQZr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:25:47 -0400
Message-ID: <114054.49943.qm@web94916.mail.in2.yahoo.com>
X-YMail-OSG: 34AFEnAVM1mUN1Y72fZDqZuHqEfy4ogu3SvvukizACDWKYZ
 Z6i89kiDEE2mf5LXPQSnil5zoU3feEMYK8l7kvcJe4B1mBlU2iP682Q1olnT
 uHS6ifQ_uWE_YQlRWpT4pdTB20fY3wZmzh7dp7ThPL6xk5HrORSaWrFJomin
 hW56sl6MTT..sSI_ArJsD5H5uhVvxN9zSMqXHEArCMdwH3J7bWmg_TInD.Io
 uvbMgHbPiJhnfKmVGfMd2KGqoJHv5CXyxUHYE3slWLOKh44UmcXq5vaSDbbr
 j9AWxLQt2cJKYtk8-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Tue, 4 May 2010 21:55:43 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: [PATCH] drivers: staging: GPS protocol driver for wl128x
To: greg <gregkh@suse.de>, alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Alan,

Just to complete the circle on N_TI_WL, find below the GPS driver which makes use of the shared transport line discipline.

This driver provides a TTY line character device to application/middle-ware running on host, as if the device is directly connected over UART to a GPS chip.

Almost all actions that can be done on a /dev/ttySx can be done on this /dev/tigps device.

So with Bluetooth and GPS drivers as the consumers of this N_TI_WL line discipline, how can I tweak the line discipline driver for proper submission [out of staging] ?
(will send out the patch for Kconfig/Makefile once you guys have a look at this..)

>From dc6c64e732bb662471a1f9b95f8f68ab657e30e6 Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Mon, 3 May 2010 17:41:23 -0600
Subject: [PATCH] drivers: staging: GPS protocol driver for wl128x

Texas Instrument's wl128x connectivity combo chip
has BT, FM and GPS interfaced to host/apps processor
over a single UART.
This is the driver for the GPS protocol which makes use of
the N_TI_WL TTY line discipline.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Nagarjuna Kristam <x0043706@ti.com>
Signed-off-by: Sunil Pillai <sunil_pillai@ti.com>
---
 drivers/staging/ti-st/gps_drv.c |  732 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/gps_drv.h |   91 +++++
 2 files changed, 823 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/gps_drv.c
 create mode 100644 drivers/staging/ti-st/gps_drv.h

diff --git a/drivers/staging/ti-st/gps_drv.c b/drivers/staging/ti-st/gps_drv.c
new file mode 100644
index 0000000..cbc0dac
--- /dev/null
+++ b/drivers/staging/ti-st/gps_drv.c
@@ -0,0 +1,732 @@
+/*
+ *   GPS Char Driver for Texas Instrument's Connectivity Chip.
+ *   Copyright (C) 2009 Texas Instruments
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#define pr_fmt(fmt)	"(gps): " fmt
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+
+#include <linux/uaccess.h>
+#include <linux/tty.h>
+#include <linux/sched.h>
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/skbuff.h>
+#include <linux/interrupt.h>
+
+#include "gps_drv.h"
+#include "st.h"
+
+#define DEVICE_NAME     "tigps"
+
+/* Initialization TaskLet for performing GPS Write */
+DECLARE_TASKLET_DISABLED(gpsdrv_tx_tsklet, gpsdrv_tsklet_write, 0);
+
+/* Structure declerations for GPS char Driver Data */
+static struct gpsdrv_data *hgps;
+
+/***********Functions called from ST driver**********************************/
+
+/*  gpsdrv_st_recv Function
+ *  This is Called in from -- ST Core when a data is received
+ *  This is a registered callback with ST core when the gps driver registers
+ *  with ST.
+ *
+ *  Parameters:
+ *  @skb    : SKB buffer pointer which contains the incoming Ch-9 GPS data.
+ *  Returns:
+ *          GPS_SUCCESS - On Success
+ *          else suitable error code
+ */
+long gpsdrv_st_recv(struct sk_buff *skb)
+{
+	struct gpsdrv_event_hdr gpsdrv_hdr = { 0x00, 0x0000 };
+
+#ifdef VERBOSE
+	unsigned int i;
+#endif
+
+	/* SKB is NULL */
+	if (NULL == skb) {
+		pr_err("Input SKB is NULL");
+		return GPS_ERR_FAILURE;
+	}
+
+	/* Sanity Check - To Check if the Rx Pkt is Channel -9 or not */
+	if (0x09 != skb->cb[0]) {
+		pr_err("Input SKB is not a Channel-9 packet");
+		return GPS_ERR_FAILURE;
+	}
+	/* Copy Ch-9 info to local structure */
+	memcpy(&gpsdrv_hdr, skb->data, GPS_CH9_PKT_HDR_SIZE - 1);
+	skb_pull(skb, GPS_CH9_PKT_HDR_SIZE - 1);
+
+	/* check if skb->len and gpsdrv_hdr.plen are equal */
+	if (skb->len != gpsdrv_hdr.plen) {
+		pr_err("Received corrupted packet - Length Mismatch");
+		return -EINVAL;
+	}
+#ifdef VERBOSE
+	printk(KERN_INFO"data start >>\n");
+	for (i = 0; i < skb->len; i++)
+		printk(KERN_INFO" %x ", skb->data[i]);
+	printk(KERN_INFO"\n<< end\n");
+#endif
+	/* Check the Opcode */
+	if ((gpsdrv_hdr.opcode != GPS_CH9_OP_READ) && (gpsdrv_hdr.opcode != \
+						GPS_CH9_OP_COMPLETED_EVT)) {
+		pr_err("Rec corrupt pkt opcode %x", gpsdrv_hdr.opcode);
+		return -EINVAL;
+	}
+
+	/* Strip Channel 9 packet information from SKB only
+	 * if the opcode is GPS_CH9_OP_READ and get AI2 packet
+	 */
+	if (GPS_CH9_OP_READ == gpsdrv_hdr.opcode) {
+		spin_lock(&hgps->lock);
+		skb_queue_tail(&hgps->rx_list, skb);
+		spin_unlock(&hgps->lock);
+		wake_up_interruptible(&hgps->gpsdrv_data_q);
+	} else {
+		/* Copy Ch-9 info to local structure */
+		memcpy(&hgps->tx_count, skb->data, 1);
+		pr_info(" Tx count = %x", hgps->tx_count);
+		/* Check if Tx queue and Tx count not empty */
+		if ((0 != hgps->tx_count) && \
+			(!skb_queue_empty(&hgps->tx_list))) {
+			/* Schedule the Tx-task let */
+			pr_info(" Scheduling tasklet to write");
+			tasklet_schedule(&gpsdrv_tx_tsklet);
+		}
+		/* Free the received command complete SKB */
+		kfree(skb);
+	}
+
+	return GPS_SUCCESS;
+
+}
+
+/*  gpsdrv_st_cb Function
+ *  This is Called in from -- ST Core when the state is pending during
+ *  st_register. This is a registered callback with ST core when the gps
+ *  driver registers with ST.
+ *
+ *  Parameters:
+ *  @data   Status update of GPS registration
+ *  Returns: NULL
+ */
+void gpsdrv_st_cb(char data)
+{
+	pr_info(" Inside %s", __func__);
+	hgps->streg_cbdata = data;	/* ST registration callback  status */
+	complete_all(&hgps->gpsdrv_reg_completed);
+	return;
+}
+
+static struct st_proto_s gpsdrv_proto = {
+	.type = ST_GPS,
+	.recv = gpsdrv_st_recv,
+	.reg_complete_cb = gpsdrv_st_cb,
+};
+
+/** gpsdrv_tsklet_write Function
+ *  This tasklet function will be scheduled when there is a data in Tx queue
+ *  and GPS chip sent an command completion packet with non zero value.
+ *
+ *  Parameters :
+ *  @data  : data passed to tasklet function
+ *  Returns : NULL
+ */
+void gpsdrv_tsklet_write(unsigned long data)
+{
+	struct sk_buff *skb = NULL;
+
+	pr_info(" Inside %s", __func__);
+
+	/* Perform sanity check of verifying the status
+				to perform an st_write */
+	if (((!hgps->st_write) || (0 == hgps->tx_count))
+			|| ((skb_queue_empty(&hgps->tx_list)))) {
+		pr_err("Sanity check Failed exiting %s", __func__);
+		return;
+	}
+	/* hgps->tx_list not empty skb already present
+	 * dequeue the tx-data and perform a st_write
+	 */
+	spin_lock(&hgps->lock);
+	skb = skb_dequeue(&hgps->tx_list);
+	spin_unlock(&hgps->lock);
+	hgps->st_write(skb);
+	hgps->tx_count--;
+
+	/* Check if Tx queue and Tx count not empty */
+	if ((0 != hgps->tx_count) && (!skb_queue_empty(&hgps->tx_list))) {
+		/* Schedule the Tx-task let */
+		tasklet_schedule(&gpsdrv_tx_tsklet);
+	}
+
+	return;
+}
+
+/*********Functions Called from GPS host***************************************/
+
+/** gpsdrv_open Function
+ *  This function will perform an register on ST driver.
+ *
+ *  Parameters :
+ *  @file  : File pointer for GPS char driver
+ *  @inod  :
+ *  Returns  GPS_SUCCESS -  on success
+ *           else suitable error code
+ */
+int gpsdrv_open(struct inode *inod, struct file *file)
+{
+	int ret = 0;
+	unsigned long timeout = GPSDRV_REG_TIMEOUT;
+
+	pr_info(" Inside %s", __func__);
+	/* Check if GPS is already registered with ST */
+	if (test_and_set_bit(GPS_ST_REGISTERED, &hgps->state)) {
+		pr_err("GPS Registered/Registration in progress with ST \
+							,open called again?");
+
+		return GPS_ERR_ALREADY;
+	}
+
+	/* Initialize  gpsdrv_reg_completed so as to wait for completion
+	* on the same
+	* if st_register returns with a PENDING status
+	*/
+	INIT_COMPLETION(hgps->gpsdrv_reg_completed);
+
+	/* Resgister GPS with ST */
+	ret = st_register(&gpsdrv_proto);
+
+	pr_info(" st_register returned %d", ret);
+
+	/* If GPS Registration returned with error, then clear GPS_ST_REGISTERED
+	 * for future open calls and return the appropriate error code
+	 */
+	if (ret < 0 && ret != ST_ERR_PENDING) {
+		pr_err(" st_register failed");
+		clear_bit(GPS_ST_REGISTERED, &hgps->state);
+		if (ret == ST_ERR_ALREADY)
+			return GPS_ERR_ALREADY;
+		return GPS_ERR_FAILURE;
+	}
+
+	/* if returned status is pending, wait for the completion */
+	if (ret == ST_ERR_PENDING) {
+		pr_info(" GPS Register waiting for completion ");
+		timeout = wait_for_completion_timeout \
+		    (&hgps->gpsdrv_reg_completed, msecs_to_jiffies(timeout));
+		/* Check for timed out condition */
+		if (0 == timeout) {
+			pr_err("st_register failed-GPS Device \
+						Registration timed out");
+			clear_bit(GPS_ST_REGISTERED, &hgps->state);
+			return GPS_ERR_TIMEOUT;
+		} else if (0 > hgps->streg_cbdata) {
+			pr_err("GPS Device Registration Failed-ST \
+								Reg CB called"
+				   "with ivalid value %d", hgps->streg_cbdata);
+			clear_bit(GPS_ST_REGISTERED, &hgps->state);
+			return -EAGAIN;
+		}
+	}
+	pr_info(" gps registration complete ");
+
+	/* Assign the write callback pointer */
+	hgps->st_write = gpsdrv_proto.write;
+	hgps->tx_count = 1;
+	tasklet_enable(&gpsdrv_tx_tsklet);
+	set_bit(GPS_ST_RUNNING, &hgps->state);
+
+	return GPS_SUCCESS;
+}
+
+/** gpsdrv_release Function
+ *  This function will un-registers from the ST driver.
+ *
+ *  Parameters :
+ *  @file  : File pointer for GPS char driver
+ *  @inod  :
+ *  Returns  GPS_SUCCESS -  on success
+ *           else suitable error code
+ */
+int gpsdrv_release(struct inode *inod, struct file *file)
+{
+	pr_info(" Inside %s", __func__);
+
+	/* Disabling task-let 1st & then un-reg to avoid
+	 * tasklet getting scheduled
+	 */
+	tasklet_disable(&gpsdrv_tx_tsklet);
+	/* Cleat registered bit if already registered */
+	if (test_and_clear_bit(GPS_ST_REGISTERED, &hgps->state)) {
+		if (st_unregister(gpsdrv_proto.type) < 0) {
+			pr_err(" st_unregister failed");
+			/* Re-Enable the task-let if un-register fails */
+			tasklet_enable(&gpsdrv_tx_tsklet);
+			return GPS_ERR_FAILURE;
+		}
+	}
+
+	/* Reset Tx count value and st_write function pointer */
+	hgps->tx_count = 0;
+	hgps->st_write = NULL;
+	clear_bit(GPS_ST_RUNNING, &hgps->state);
+	pr_info(" st_unregister success");
+
+	return GPS_SUCCESS;
+}
+
+/** gpsdrv_read Function
+ *  This function will wait till the data received from the ST driver
+ *  and then strips the GPS-Channel-9 header from the
+ *  incoming AI2 packet and then send it to GPS host application.
+ *
+ *  Parameters :
+ *  @file  : File pointer for GPS char driver
+ *  @data  : Data which needs to be passed to APP
+ *  @size  : Length of the data passesd
+ *  offset :
+ *  Returns  Size of AI2 packet received -  on success
+ *           else suitable error code
+ */
+ssize_t gpsdrv_read(struct file *file, char __user *data, size_t size,
+			loff_t *offset)
+{
+	int len = 0;
+	struct sk_buff *skb = NULL;
+	unsigned long timeout = GPSDRV_READ_TIMEOUT;
+
+	pr_info(" Inside %s", __func__);
+
+	/* Validate input parameters */
+	if ((NULL == file) || (((NULL == data) || (0 == size)))) {
+		pr_err("Invalid input params passed to %s", __func__);
+		return -EINVAL;
+	}
+
+	/* Check if GPS is registered to perform read operation */
+	if (!test_bit(GPS_ST_RUNNING, &hgps->state)) {
+		pr_err("GPS Device is not running");
+		return -EINVAL;
+	}
+
+	/* cannot come here if poll-ed before reading
+	 * if not poll-ed wait on the same wait_q
+	 */
+	timeout = wait_event_interruptible_timeout(hgps->gpsdrv_data_q,
+		!skb_queue_empty(&hgps->rx_list), msecs_to_jiffies(timeout));
+	/* Check for timed out condition */
+	if (0 == timeout) {
+		pr_err("GPS Device Read timed out");
+		return GPS_ERR_TIMEOUT;
+	}
+
+
+	/* hgps->rx_list not empty skb already present */
+	spin_lock(&hgps->lock);
+	skb = skb_dequeue(&hgps->rx_list);
+	spin_unlock(&hgps->lock);
+
+	if (!skb) {
+		pr_err("Dequed SKB is NULL?");
+		return GPS_ERR_UNKNOWN;
+	} else if (skb->len > size) {
+		pr_info("SKB length is Greater than requested size \
+				Returning the available length of SKB");
+
+		if (copy_to_user(data, skb->data, size)) {
+			pr_err(" Unable to copy to user space");
+			/* Queue the skb back to head */
+			spin_lock(&hgps->lock);
+			skb_queue_head(&hgps->rx_list, skb);
+
+			spin_unlock(&hgps->lock);
+			return GPS_ERR_CPY_TO_USR;
+		}
+		skb_pull(skb, size);
+
+		if (skb->len != 0) {
+			spin_lock(&hgps->lock);
+			skb_queue_head(&hgps->rx_list, skb);
+			spin_unlock(&hgps->lock);
+		}
+
+		printk(KERN_DEBUG  "gpsdrv: total size read= %d", size);
+		return size;
+	}
+
+#ifdef VERBOSE
+	for (len = 0; (skb) && (len < skb->len); len++)
+		pr_info(" %x ", skb->data[len]);
+#endif
+
+	/* Forward the data to the user */
+	if (skb->len <= size) {
+		if (copy_to_user(data, skb->data, skb->len)) {
+			pr_err(" Unable to copy to user space");
+			/* Queue the skb back to head */
+			spin_lock(&hgps->lock);
+			skb_queue_head(&hgps->rx_list, skb);
+
+			spin_unlock(&hgps->lock);
+			return GPS_ERR_CPY_TO_USR;
+		}
+	}
+
+	len = skb->len;
+	kfree(skb);
+	printk(KERN_DEBUG  "gpsdrv: total size read= %d", len);
+	return len;
+}
+/* gpsdrv_write Function
+ *  This function will pre-pend the GPS-Channel-9 header to the
+ *  incoming AI2 packet sent from the GPS host application.
+ *
+ *  Parameters :
+ *  @file   : File pointer for GPS char driver
+ *  @data   : AI2 packet data from GPS application
+ *  @size   : Size of the AI2 packet data
+ *  @offset :
+ *  Returns  Size of AI2 packet on success
+ *           else suitable error code
+ */
+ssize_t gpsdrv_write(struct file *file, const char __user *data,
+			 size_t size, loff_t *offset)
+{
+#ifdef VERBOSE
+	long count = 0;
+#endif
+	unsigned char channel = GPS_CH9_PKT_NUMBER; /* GPS Channel number */
+	/* Initialize gpsdrv_event_hdr with write opcode */
+	struct gpsdrv_event_hdr gpsdrv_hdr = { GPS_CH9_OP_WRITE, 0x0000 };
+	struct sk_buff *skb = NULL;
+
+	spin_lock(&hgps->lock);
+	pr_info(" Inside %s", __func__);
+	spin_unlock(&hgps->lock);
+
+	/* Validate input parameters */
+	if ((NULL == file) || (((NULL == data) || (0 == size)))) {
+		pr_err("Invalid input params passed to %s", __func__);
+		return -EINVAL;
+	}
+
+	/* Check if GPS is registered to perform write operation */
+	if (!test_bit(GPS_ST_RUNNING, &hgps->state)) {
+		pr_err("GPS Device is not running");
+		return -EINVAL;
+	}
+
+	if (!hgps->st_write) {
+		pr_err(" Can't write to ST, hgps->st_write null ?");
+		return -EINVAL;
+	}
+
+
+	skb = alloc_skb(size + GPS_CH9_PKT_HDR_SIZE, GFP_ATOMIC);
+	/* Validate Created SKB */
+	if (NULL == skb) {
+		pr_err("Error aaloacting SKB");
+		return -ENOMEM;
+	}
+
+	/* Update chnl-9 information with plen=AI2 pckt size which is "size"*/
+	gpsdrv_hdr.plen = size;
+
+	/* PrePend Channel-9 header to AI2 packet and write to SKB */
+	memcpy(skb_put(skb, 1), &channel, 1);
+	memcpy(skb_put(skb, GPS_CH9_PKT_HDR_SIZE - 1), &gpsdrv_hdr,
+					       GPS_CH9_PKT_HDR_SIZE - 1);
+
+	/* Forward the data from the user space to ST core */
+	if (copy_from_user(skb_put(skb, size), data, size)) {
+		pr_err(" Unable to copy from user space");
+		kfree_skb(skb);
+		return GPS_ERR_CPY_FRM_USR;
+	}
+#ifdef VERBOSE
+	pr_info("start data..");
+	for (count = 0; count < size; count++)
+		printk(" 0x%02x ", skb->data[count]);
+	pr_info("\n..end data");
+#endif
+
+	/* Check if data can be sent to GPS chip
+	 * If not, add it to queue and that can be sent later
+	 */
+	if (0 != hgps->tx_count) {
+		/* If TX Q is empty send current SKB;
+		 *  else, queue current SKB at end of tx_list queue and
+		 *  send first SKB in tx_list queue.
+		 */
+		if (skb_queue_empty(&hgps->tx_list)) {
+			hgps->st_write(skb);
+		} else {
+			spin_lock(&hgps->lock);
+			skb_queue_tail(&hgps->tx_list, skb);
+			hgps->st_write(skb_dequeue(&hgps->tx_list));
+			spin_unlock(&hgps->lock);
+		}
+
+		hgps->tx_count--;
+		/* Check if Tx queue and Tx count not empty and
+		 * schedule wriet tsklet accordingly
+		 */
+		if ((0 != hgps->tx_count) && \
+					(!skb_queue_empty(&hgps->tx_list))) {
+			/* Schedule the Tx-task let */
+			tasklet_schedule(&gpsdrv_tx_tsklet);
+		}
+	} else {
+		/* Add it to TX queue */
+		pr_info(" SKB added to Tx queue");
+		spin_lock(&hgps->lock);
+		skb_queue_tail(&hgps->tx_list, skb);
+		spin_unlock(&hgps->lock);
+	}
+
+	return size;
+}
+
+/** gpsdrv_ioctl Function
+ *  This will peform the functions as directed by the command and command
+ *  argument.
+ *
+ *  Parameters :
+ *  @file  : File pointer for GPS char driver
+ *  @cmd   : IOCTL Command
+ *  @arg   : Command argument for IOCTL command
+ *  Returns  GPS_SUCCESS on success
+ *           else suitable error code
+ */
+static int gpsdrv_ioctl(struct inode *inode, struct file *file,
+			    unsigned int cmd, unsigned long arg)
+{
+	struct sk_buff *skb = NULL;
+	int		retCode = GPS_SUCCESS;
+	pr_info(" Inside %s", __func__);
+
+	/* Validate input parameters */
+	if ((NULL == file) || (0 == cmd)) {
+		pr_err("Invalid input parameters passed to %s", __func__);
+		return -EINVAL;
+	}
+	/* Check if GPS is registered to perform IOCTL operation */
+	if (!test_bit(GPS_ST_RUNNING, &hgps->state)) {
+		pr_err("GPS Device is not running");
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case TCFLSH:
+		pr_info(" IOCTL TCFLSH invoked with %ld argument", arg);
+	spin_lock(&hgps->lock);
+		switch (arg) {
+		/* purge Rx/Tx SKB list queues depending on arg value */
+		case TCIFLUSH:
+			skb_queue_purge(&hgps->rx_list);
+			break;
+		case TCOFLUSH:
+			skb_queue_purge(&hgps->tx_list);
+			break;
+		case TCIOFLUSH:
+			skb_queue_purge(&hgps->rx_list);
+			skb_queue_purge(&hgps->tx_list);
+			break;
+		default:
+			pr_err("Invalid Command passed for tcflush");
+			retCode = 0;
+			break;
+		}
+		spin_unlock(&hgps->lock);
+		break;
+	case FIONREAD:
+	/* Deque the SKB from the head if rx_list is not empty
+	* And update the argument with skb->len to provide amount of data
+	* available in the available SKB
+	*/
+		spin_lock(&hgps->lock);
+		if (!skb_queue_empty(&hgps->rx_list)) {
+			skb = skb_dequeue(&hgps->rx_list);
+			*(unsigned int *)arg = skb->len;
+			/* Re-Store the SKB for furtur Read operations */
+			skb_queue_head(&hgps->rx_list, skb);
+		} else {
+			*(unsigned int *)arg = 0;
+		}
+		pr_info("returning %d\n", *(unsigned int *)arg);
+		spin_unlock(&hgps->lock);
+		break;
+	default:
+		pr_info("Un-Identified IOCTL %d", cmd);
+		retCode = 0;
+		break;
+	}
+
+	return retCode;
+}
+
+/** gpsdrv_poll Function
+ *  This function will wait till some data is received to the gps driver from ST
+ *
+ *  Parameters :
+ *  @file  : File pointer for GPS char driver
+ *  @wait  : POLL wait information
+ *  Returns  status of POLL on success
+ *           else suitable error code
+ */
+static unsigned int gpsdrv_poll(struct file *file, poll_table *wait)
+{
+	unsigned long mask = 0;
+
+	/* Check if GPS is registered to perform read operation */
+	if (!test_bit(GPS_ST_RUNNING, &hgps->state)) {
+		pr_err("GPS Device is not running");
+		return -EINVAL;
+	}
+
+	/* Wait till data is signalled from gpsdrv_st_recv function
+	 *  with AI2 packet
+	 */
+	poll_wait(file, &hgps->gpsdrv_data_q, wait);
+
+	if (!skb_queue_empty(&hgps->rx_list))
+		mask |= POLLIN;	/* TODO: check app for mask */
+
+	return mask;
+}
+
+/* GPS Char driver function pointers
+ * These functions are called from USER space by pefroming File Operations
+ * on /dev/gps node exposed by this driver during init
+ */
+const struct file_operations gpsdrv_chrdev_ops = {
+	.owner = THIS_MODULE,
+	.open = gpsdrv_open,
+	.read = gpsdrv_read,
+	.write = gpsdrv_write,
+	.ioctl = gpsdrv_ioctl,
+	.poll = gpsdrv_poll,
+	.release = gpsdrv_release,
+};
+
+/*********Functions called during insmod and delmod****************************/
+
+/** gpsdrv_init Function
+ *  This function Initializes the gps driver parametes and exposes
+ *  /dev/gps node to user space
+ *
+ *  Parameters : NULL
+ *  Returns  GPS_SUCCESS on success
+ *           else suitable error code
+ */
+static int __init gpsdrv_init(void)
+{
+
+#ifdef VERBOSE
+	int err = 0;
+#endif
+	pr_info(" Inside %s", __func__);
+
+	/* Allocate local resource memory */
+	hgps = kzalloc(sizeof(struct gpsdrv_data), GFP_KERNEL);
+	if (!(hgps)) {
+		pr_err("Can't allocate GPS data structure");
+		return -ENOMEM;
+	}
+
+	/* Expose the device DEVICE_NAME to user space
+	 * And obtain the major number for the device
+	 */
+	hgps->gpsdrv_major = register_chrdev(0, DEVICE_NAME, \
+						&gpsdrv_chrdev_ops);
+	if (0 > hgps->gpsdrv_major) {
+		pr_err("Error when registering to char dev");
+		kfree(hgps);
+		return GPS_ERR_FAILURE;
+	}
+#ifdef VERBOSE
+	pr_info(" %d: allocated %d, %d", err, hgps->gpsdrv_major, 0);
+#endif
+	/*  ask udev to create device */
+	hgps->gpsdrv_class = class_create(THIS_MODULE, DEVICE_NAME);
+	if (IS_ERR(hgps->gpsdrv_class)) {
+		pr_err(" Something went wrong in class_create");
+		kfree(hgps);
+		unregister_chrdev(hgps->gpsdrv_major, DEVICE_NAME);
+		return GPS_ERR_CLASS;
+	}
+
+	hgps->gpsdrv_dev =
+	  device_create(hgps->gpsdrv_class, NULL, MKDEV(hgps->gpsdrv_major, 0),
+			  NULL, DEVICE_NAME);
+	if (IS_ERR(hgps->gpsdrv_dev)) {
+		pr_err(" Error in class_create");
+		kfree(hgps);
+		unregister_chrdev(hgps->gpsdrv_major, DEVICE_NAME);
+		class_unregister(hgps->gpsdrv_class);
+		class_destroy(hgps->gpsdrv_class);
+		return GPS_ERR_CLASS;
+	}
+
+	/* Initialize wait queue, skb queue head and
+	 * registration complete strucuture
+	 */
+	skb_queue_head_init(&hgps->rx_list);
+	skb_queue_head_init(&hgps->tx_list);
+	init_completion(&hgps->gpsdrv_reg_completed);
+	init_waitqueue_head(&hgps->gpsdrv_data_q);
+	spin_lock_init(&hgps->lock);
+
+	return GPS_SUCCESS;
+}
+
+/** gpsdrv_exit Function
+ *  This function Destroys the gps driver parametes and /dev/gps node
+ *
+ *  Parameters : NULL
+ *  Returns   NULL
+ */
+static void __exit gpsdrv_exit(void)
+{
+	pr_info(" Inside %s", __func__);
+	pr_info(" Bye.. freeing up %d", hgps->gpsdrv_major);
+
+	skb_queue_purge(&hgps->rx_list);
+	skb_queue_purge(&hgps->tx_list);
+	device_destroy(hgps->gpsdrv_class, MKDEV(hgps->gpsdrv_major, 0));
+
+	class_unregister(hgps->gpsdrv_class);
+	class_destroy(hgps->gpsdrv_class);
+
+	unregister_chrdev(hgps->gpsdrv_major, DEVICE_NAME);
+	tasklet_kill(&gpsdrv_tx_tsklet);
+	kfree(hgps);
+}
+
+module_init(gpsdrv_init);
+module_exit(gpsdrv_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/ti-st/gps_drv.h b/drivers/staging/ti-st/gps_drv.h
new file mode 100644
index 0000000..620559e
--- /dev/null
+++ b/drivers/staging/ti-st/gps_drv.h
@@ -0,0 +1,91 @@
+/*
+ *   GPS Char Driver for Texas Instrument's Connectivity Chip.
+ *   Copyright (C) 2009 Texas Instruments
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef GPSDRV_H
+#define GPSDRV_H
+
+
+void gpsdrv_tsklet_write(unsigned long data);
+
+/* List of error codes returned by the gps driver*/
+enum {
+	GPS_ERR_FAILURE = -1,	/* check struct */
+	GPS_SUCCESS,
+	GPS_ERR_PENDING = -5,	/* to call reg_complete_cb */
+	GPS_ERR_ALREADY,	/* already registered */
+	GPS_ERR_INPROGRESS,
+	GPS_ERR_NOPROTO,	/* protocol not supported */
+	GPS_ERR_CLASS = -15,
+	GPS_ERR_CPY_TO_USR,
+	GPS_ERR_CPY_FRM_USR,
+	GPS_ERR_TIMEOUT,
+	GPS_ERR_UNKNOWN,
+};
+
+/* Channel-9 details for GPS */
+#define GPS_CH9_PKT_HDR_SIZE		4
+#define GPS_CH9_PKT_NUMBER		0x9
+#define GPS_CH9_OP_WRITE		0x1
+#define GPS_CH9_OP_READ			0x2
+#define GPS_CH9_OP_COMPLETED_EVT	0x3
+
+/* Macros for Syncronising GPS registration and other R/W/ICTL operations */
+#define GPS_ST_REGISTERED		0
+#define GPS_ST_RUNNING			1
+
+/* Read time out defined to 10 seconds */
+#define GPSDRV_READ_TIMEOUT		10000
+/* Reg time out defined to 6 seconds */
+#define GPSDRV_REG_TIMEOUT		6000
+
+
+struct gpsdrv_event_hdr {
+	uint8_t opcode;
+	uint16_t plen;
+} __attribute__ ((packed));
+
+/* BT driver operation structure */
+struct gpsdrv_data {
+
+	int gpsdrv_major;		/* GPS major number */
+	struct class *gpsdrv_class;	/* GPS class during class_create */
+	struct device *gpsdrv_dev;	/* GPS dev during device_create */
+
+	struct completion gpsdrv_reg_completed;
+		/*comepletion handler to synchronize gpsdrv_chrdev_open */
+	char streg_cbdata;	/* ST registration callback  status */
+
+	unsigned long state;
+		/* used locally,to maintain various GPS driver status */
+	unsigned char tx_count;	/* Count value which gives number of Tx GPS
+				 * commands that can be sent to GPS chip */
+
+	long (*st_write) (struct sk_buff *skb);
+				/* write function pointer of ST driver */
+	struct sk_buff_head rx_list;	/* Rx data SKB queue */
+	struct sk_buff_head tx_list;	/* Tx data SKB queue */
+
+	wait_queue_head_t gpsdrv_data_q;
+			/* Used to syncronize read call and poll */
+
+	spinlock_t lock;
+		/* spin lock data for safe-gaurding operations on SKB */
+
+};
+
+#endif /*GPS_H */
-- 
1.5.4.3




