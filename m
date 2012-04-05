Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2DEVBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:01:35 -0400
Received: from masquerade.micron.com ([137.201.242.130]:62305 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2DEVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:01:34 -0400
Message-ID: <4F7E07DC.50909@micron.com>
Date: Thu, 5 Apr 2012 14:00:12 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 2/5] mtip32xx: Add new sysfs entry 'status' and fix restart
 port
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--12.413500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Add support for detecting the following device status
	- write protect
	- over temp (thermal shutdown)
* New sysfs entry 'status' created for this device,  possible values - online, write_protect, thermal_shutdown
* Reinitialize (init and start) the port after comreset in mtip_restart_port()
* Clear pending HOST interrupts(HOST_IRQ_STAT) in mtip_init_port()
* Handle the interrupt completion of polled internal commands
* Free the rssd_index_ida in both mtip_block_remove() and mtip_block_shutdown()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Reviewed-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |  400 ++++++++++++++++++++++++++++++++-----
 drivers/block/mtip32xx/mtip32xx.h |   19 ++
 2 files changed, 368 insertions(+), 51 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 295138b..43d9cb7 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -438,6 +438,10 @@ static void mtip_init_port(struct mtip_port *port)
 	/* Clear any pending interrupts for this port */
 	writel(readl(port->mmio + PORT_IRQ_STAT), port->mmio + PORT_IRQ_STAT);
 
+	/* Clear any pending interrupts on the HBA. */
+	writel(readl(port->dd->mmio + HOST_IRQ_STAT),
+					port->dd->mmio + HOST_IRQ_STAT);
+
 	/* Enable port interrupts */
 	writel(DEF_PORT_IRQ, port->mmio + PORT_IRQ_MASK);
 }
@@ -515,11 +519,8 @@ static void mtip_restart_port(struct mtip_port *port)
 		dev_warn(&port->dd->pdev->dev,
 			"COM reset failed\n");
 
-	/* Clear SError, the PxSERR.DIAG.x should be set so clear it */
-	writel(readl(port->mmio + PORT_SCR_ERR), port->mmio + PORT_SCR_ERR);
-
-	/* Enable the DMA engine */
-	mtip_enable_engine(port, 1);
+	mtip_init_port(port);
+	mtip_start_port(port);
 }
 
 /*
@@ -706,6 +707,15 @@ static void mtip_completion(struct mtip_port *port,
 	complete(waiting);
 }
 
+
+static void mtip_null_completion(struct mtip_port *port,
+			    int tag,
+			    void *data,
+			    int status)
+{
+	return;
+}
+
 /*
  * Helper function for tag logging
  */
@@ -723,6 +733,10 @@ static void print_tags(struct driver_data *dd,
 		dev_info(&dd->pdev->dev, "%s [%i tags]\n", msg, count);
 }
 
+static int mtip_read_log_page(struct mtip_port *port, u8 page, u16 *buffer,
+				dma_addr_t buffer_dma, unsigned int sectors);
+static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
+						struct smart_attr *attrib);
 /*
  * Handle an error.
  *
@@ -733,12 +747,15 @@ static void print_tags(struct driver_data *dd,
  */
 static void mtip_handle_tfe(struct driver_data *dd)
 {
-	int group, tag, bit, reissue;
+	int group, tag, bit, reissue, rv;
 	struct mtip_port *port;
-	struct mtip_cmd  *command;
+	struct mtip_cmd  *cmd;
 	u32 completed;
 	struct host_to_dev_fis *fis;
 	unsigned long tagaccum[SLOTBITS_IN_LONGS];
+	unsigned char *buf;
+	char *fail_reason = NULL;
+	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
 
 	dev_warn(&dd->pdev->dev, "Taskfile error\n");
 
@@ -770,13 +787,13 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			if (tag == MTIP_TAG_INTERNAL)
 				continue;
 
-			command = &port->commands[tag];
-			if (likely(command->comp_func)) {
+			cmd = &port->commands[tag];
+			if (likely(cmd->comp_func)) {
 				set_bit(tag, tagaccum);
-				atomic_set(&port->commands[tag].active, 0);
-				command->comp_func(port,
+				atomic_set(&cmd->active, 0);
+				cmd->comp_func(port,
 					 tag,
-					 command->comp_data,
+					 cmd->comp_data,
 					 0);
 			} else {
 				dev_err(&port->dd->pdev->dev,
@@ -796,6 +813,38 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	mdelay(20);
 	mtip_restart_port(port);
 
+	/* Trying to determine the cause of the error */
+	rv = mtip_read_log_page(dd->port, ATA_LOG_SATA_NCQ,
+				dd->port->log_buf,
+				dd->port->log_buf_dma, 1);
+	if (rv) {
+		dev_warn(&dd->pdev->dev,
+			"Error in READ LOG EXT (10h) command\n");
+		/* non-critical error, don't fail the load */
+	} else {
+		buf = (unsigned char *)dd->port->log_buf;
+		if (buf[259] & 0x1) {
+			dev_info(&dd->pdev->dev,
+				"Write protect bit is set.\n");
+			set_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag);
+			fail_all_ncq_write = 1;
+			fail_reason = "write protect";
+		}
+		if (buf[288] == 0xF7) {
+			dev_info(&dd->pdev->dev,
+				"Exceeded Tmax, drive in thermal shutdown.\n");
+			set_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag);
+			fail_all_ncq_cmds = 1;
+			fail_reason = "thermal shutdown";
+		}
+		if (buf[288] == 0xBF) {
+			dev_info(&dd->pdev->dev,
+				"Drive indicates rebuild has failed.\n");
+			fail_all_ncq_cmds = 1;
+			fail_reason = "rebuild failed";
+		}
+	}
+
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
 
@@ -804,25 +853,44 @@ static void mtip_handle_tfe(struct driver_data *dd)
 		for (bit = 0; bit < 32; bit++) {
 			reissue = 1;
 			tag = (group << 5) + bit;
+			cmd = &port->commands[tag];
 
 			/* If the active bit is set re-issue the command */
-			if (atomic_read(&port->commands[tag].active) == 0)
+			if (atomic_read(&cmd->active) == 0)
 				continue;
 
-			fis = (struct host_to_dev_fis *)
-				port->commands[tag].command;
+			fis = (struct host_to_dev_fis *)cmd->command;
 
 			/* Should re-issue? */
 			if (tag == MTIP_TAG_INTERNAL ||
 			    fis->command == ATA_CMD_SET_FEATURES)
 				reissue = 0;
+			else {
+				if (fail_all_ncq_cmds ||
+					(fail_all_ncq_write &&
+					fis->command == ATA_CMD_FPDMA_WRITE)) {
+					dev_warn(&dd->pdev->dev,
+					"  Fail: %s w/tag %d [%s].\n",
+					fis->command == ATA_CMD_FPDMA_WRITE ?
+						"write" : "read",
+					tag,
+					fail_reason != NULL ?
+						fail_reason : "unknown");
+					atomic_set(&cmd->active, 0);
+					if (cmd->comp_func) {
+						cmd->comp_func(port, tag,
+							cmd->comp_data,
+							-ENODATA);
+					}
+					continue;
+				}
+			}
 
 			/*
 			 * First check if this command has
 			 *  exceeded its retries.
 			 */
-			if (reissue &&
-			    (port->commands[tag].retries-- > 0)) {
+			if (reissue && (cmd->retries-- > 0)) {
 
 				set_bit(tag, tagaccum);
 
@@ -835,13 +903,13 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			/* Retire a command that will not be reissued */
 			dev_warn(&port->dd->pdev->dev,
 				"retiring tag %d\n", tag);
-			atomic_set(&port->commands[tag].active, 0);
+			atomic_set(&cmd->active, 0);
 
-			if (port->commands[tag].comp_func)
-				port->commands[tag].comp_func(
+			if (cmd->comp_func)
+				cmd->comp_func(
 					port,
 					tag,
-					port->commands[tag].comp_data,
+					cmd->comp_data,
 					PORT_IRQ_TF_ERR);
 			else
 				dev_warn(&port->dd->pdev->dev,
@@ -932,8 +1000,6 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 		}
 	}
 
-	dev_warn(&dd->pdev->dev, "IRQ status 0x%x ignored.\n", port_stat);
-
 	return;
 }
 
@@ -1101,7 +1167,7 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
  *	-EAGAIN  Time out waiting for command to complete.
  */
 static int mtip_exec_internal_command(struct mtip_port *port,
-					void *fis,
+					struct host_to_dev_fis *fis,
 					int fis_len,
 					dma_addr_t buffer,
 					int buf_len,
@@ -1130,14 +1196,17 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	set_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
 
 	if (atomic == GFP_KERNEL) {
-		/* wait for io to complete if non atomic */
-		if (mtip_quiesce_io(port, 5000) < 0) {
-			dev_warn(&port->dd->pdev->dev,
-				"Failed to quiesce IO\n");
-			release_slot(port, MTIP_TAG_INTERNAL);
-			clear_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
-			wake_up_interruptible(&port->svc_wait);
-			return -EBUSY;
+		if (fis->command != ATA_CMD_STANDBYNOW1) {
+			/* wait for io to complete if non atomic */
+			if (mtip_quiesce_io(port, 5000) < 0) {
+				dev_warn(&port->dd->pdev->dev,
+					"Failed to quiesce IO\n");
+				release_slot(port, MTIP_TAG_INTERNAL);
+				clear_bit(MTIP_FLAG_IC_ACTIVE_BIT,
+							&port->flags);
+				wake_up_interruptible(&port->svc_wait);
+				return -EBUSY;
+			}
 		}
 
 		/* Set the completion function and data for the command. */
@@ -1147,7 +1216,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	} else {
 		/* Clear completion - we're going to poll */
 		int_cmd->comp_data = NULL;
-		int_cmd->comp_func = NULL;
+		int_cmd->comp_func = mtip_null_completion;
 	}
 
 	/* Copy the command to the command table */
@@ -1213,12 +1282,14 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	} else {
 		/* Spin for <timeout> checking if command still outstanding */
 		timeout = jiffies + msecs_to_jiffies(timeout);
-
-		while ((readl(
-			port->cmd_issue[MTIP_TAG_INTERNAL])
-			& (1 << MTIP_TAG_INTERNAL))
-			&& time_before(jiffies, timeout)) {
-			if (mtip_check_surprise_removal(port->dd->pdev) ||
+		while ((readl(port->cmd_issue[MTIP_TAG_INTERNAL])
+				& (1 << MTIP_TAG_INTERNAL))
+				&& time_before(jiffies, timeout)) {
+			if (mtip_check_surprise_removal(port->dd->pdev)) {
+				rv = -ENXIO;
+				goto exec_ic_exit;
+			}
+			if ((fis->command != ATA_CMD_STANDBYNOW1) &&
 				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				rv = -ENXIO;
@@ -1229,8 +1300,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 		if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL)) {
 			dev_err(&port->dd->pdev->dev,
-				"Internal command did not complete [%d]\n",
-				atomic);
+				"Internal command did not complete [atomic]\n");
 			rv = -EAGAIN;
 			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
@@ -1372,6 +1442,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 {
 	int rv;
 	struct host_to_dev_fis	fis;
+	unsigned long start;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1379,6 +1450,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	fis.opts	= 1 << 7;
 	fis.command	= ATA_CMD_STANDBYNOW1;
 
+	start = jiffies;
 	/* Execute the command.  Use a 15-second timeout for large drives. */
 	rv = mtip_exec_internal_command(port,
 					&fis,
@@ -1386,8 +1458,151 @@ static int mtip_standby_immediate(struct mtip_port *port)
 					0,
 					0,
 					0,
-					GFP_KERNEL,
+					GFP_ATOMIC,
 					15000);
+	dev_info(&port->dd->pdev->dev,
+		"Time to complete standby cmd: %d ms\n",
+			jiffies_to_msecs(jiffies - start));
+	if (rv)
+		dev_warn(&port->dd->pdev->dev,
+			"STANDBY IMMEDIATE command failed.\n");
+
+	return rv;
+}
+
+/*
+ * Issue a READ LOG EXT command to the device.
+ *
+ * @port	pointer to the port structure.
+ * @page	page number to fetch
+ * @buffer	pointer to buffer
+ * @buffer_dma	dma address corresponding to @buffer
+ * @sectors	page length to fetch, in sectors
+ *
+ * return value
+ *	@rv	return value from mtip_exec_internal_command()
+ */
+static int mtip_read_log_page(struct mtip_port *port, u8 page, u16 *buffer,
+				dma_addr_t buffer_dma, unsigned int sectors)
+{
+	int rv;
+	struct host_to_dev_fis fis;
+
+	memset(&fis, 0, sizeof(struct host_to_dev_fis));
+	fis.type	= 0x27;
+	fis.opts	= 1 << 7;
+	fis.command	= ATA_CMD_READ_LOG_EXT;
+	fis.sect_count	= sectors & 0xFF;
+	fis.sect_cnt_ex	= (sectors >> 8) & 0xFF;
+	fis.lba_low	= page;
+	fis.lba_mid	= 0;
+	fis.device	= ATA_DEVICE_OBS;
+
+	memset(buffer, 0, sectors * ATA_SECT_SIZE);
+
+	/* Execute the command.  Use a 15-second timeout for large drives. */
+	rv = mtip_exec_internal_command(port,
+					&fis,
+					5,
+					buffer_dma,
+					sectors * ATA_SECT_SIZE,
+					0,
+					GFP_ATOMIC,
+					MTIP_INTERNAL_COMMAND_TIMEOUT_MS);
+
+	return rv;
+}
+
+/*
+ * Issue a SMART READ DATA command to the device.
+ *
+ * @port	pointer to the port structure.
+ * @buffer	pointer to buffer
+ * @buffer_dma	dma address corresponding to @buffer
+ *
+ * return value
+ *	@rv	return value from mtip_exec_internal_command()
+ */
+static int mtip_get_smart_data(struct mtip_port *port, u8 *buffer,
+					dma_addr_t buffer_dma)
+{
+	int rv;
+	struct host_to_dev_fis fis;
+
+	memset(&fis, 0, sizeof(struct host_to_dev_fis));
+	fis.type	= 0x27;
+	fis.opts	= 1 << 7;
+	fis.command	= ATA_CMD_SMART;
+	fis.features	= 0xD0;
+	fis.sect_count	= 1;
+	fis.lba_mid	= 0x4F;
+	fis.lba_hi	= 0xC2;
+	fis.device	= ATA_DEVICE_OBS;
+
+	/* Execute the command.  Use a 15-second timeout for large drives. */
+	rv = mtip_exec_internal_command(port,
+					&fis,
+					5,
+					buffer_dma,
+					ATA_SECT_SIZE,
+					0,
+					GFP_ATOMIC,
+					MTIP_INTERNAL_COMMAND_TIMEOUT_MS);
+	return rv;
+}
+
+/*
+ * Get the value of a smart attribute
+ *
+ * @port	pointer to the port structure
+ * @id		attribute number
+ * @attrib	pointer to return attrib information corresponding to @id
+ *
+ * return value
+ *	-EINVAL	NULL buffer passed or unsupported attribute @id.
+ *	-EPERM	Identify data not valid, SMART not supported or not enabled
+ */
+static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
+						struct smart_attr *attrib)
+{
+	int rv, i;
+	struct smart_attr *pattr;
+
+	if (!attrib)
+		return -EINVAL;
+
+	if (!port->identify_valid) {
+		dev_warn(&port->dd->pdev->dev, "IDENTIFY DATA not valid\n");
+		return -EPERM;
+	}
+	if (!(port->identify[82] & 0x1)) {
+		dev_warn(&port->dd->pdev->dev, "SMART not supported\n");
+		return -EPERM;
+	}
+	if (!(port->identify[85] & 0x1)) {
+		dev_warn(&port->dd->pdev->dev, "SMART not enabled\n");
+		return -EPERM;
+	}
+
+	memset(port->smart_buf, 0, ATA_SECT_SIZE);
+	rv = mtip_get_smart_data(port, port->smart_buf, port->smart_buf_dma);
+	if (rv) {
+		dev_warn(&port->dd->pdev->dev, "Failed to ge SMART data\n");
+		return rv;
+	}
+
+	pattr = (struct smart_attr *)(port->smart_buf + 2);
+	for (i = 0; i < 29; i++, pattr++)
+		if (pattr->attr_id == id) {
+			memcpy(attrib, pattr, sizeof(struct smart_attr));
+			break;
+		}
+
+	if (i == 29) {
+		dev_warn(&port->dd->pdev->dev,
+			"Query for invalid SMART attribute ID\n");
+		rv = -EINVAL;
+	}
 
 	return rv;
 }
@@ -2307,7 +2522,26 @@ static ssize_t mtip_hw_show_registers(struct device *dev,
 
 	return size;
 }
+
+static ssize_t mtip_hw_show_status(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct driver_data *dd = dev_to_disk(dev)->private_data;
+	int size = 0;
+
+	if (test_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag))
+		size += sprintf(buf, "%s", "thermal_shutdown\n");
+	else if (test_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag))
+		size += sprintf(buf, "%s", "write_protect\n");
+	else
+		size += sprintf(buf, "%s", "online\n");
+
+	return size;
+}
+
 static DEVICE_ATTR(registers, S_IRUGO, mtip_hw_show_registers, NULL);
+static DEVICE_ATTR(status, S_IRUGO, mtip_hw_show_status, NULL);
 
 /*
  * Create the sysfs related attributes.
@@ -2326,7 +2560,10 @@ static int mtip_hw_sysfs_init(struct driver_data *dd, struct kobject *kobj)
 
 	if (sysfs_create_file(kobj, &dev_attr_registers.attr))
 		dev_warn(&dd->pdev->dev,
-			"Error creating registers sysfs entry\n");
+			"Error creating 'registers' sysfs entry\n");
+	if (sysfs_create_file(kobj, &dev_attr_status.attr))
+		dev_warn(&dd->pdev->dev,
+			"Error creating 'registers' sysfs entry\n");
 	return 0;
 }
 
@@ -2346,6 +2583,7 @@ static int mtip_hw_sysfs_exit(struct driver_data *dd, struct kobject *kobj)
 		return -EINVAL;
 
 	sysfs_remove_file(kobj, &dev_attr_registers.attr);
+	sysfs_remove_file(kobj, &dev_attr_status.attr);
 
 	return 0;
 }
@@ -2539,7 +2777,9 @@ static int mtip_service_thread(void *data)
 
 			clear_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags);
 		} else if (test_bit(MTIP_FLAG_REBUILD_BIT, &port->flags)) {
-			mtip_ftl_rebuild_poll(dd);
+			if (!mtip_ftl_rebuild_poll(dd))
+				set_bit(MTIP_DD_FLAG_REBUILD_FAILED_BIT,
+							&dd->dd_flag);
 			clear_bit(MTIP_FLAG_REBUILD_BIT, &port->flags);
 		}
 		clear_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags);
@@ -2564,6 +2804,8 @@ static int mtip_hw_init(struct driver_data *dd)
 	int rv;
 	unsigned int num_command_slots;
 	unsigned long timeout, timetaken;
+	unsigned char *buf;
+	struct smart_attr attr242;
 
 	dd->mmio = pcim_iomap_table(dd->pdev)[MTIP_ABAR];
 
@@ -2598,7 +2840,7 @@ static int mtip_hw_init(struct driver_data *dd)
 	/* Allocate memory for the command list. */
 	dd->port->command_list =
 		dmam_alloc_coherent(&dd->pdev->dev,
-			HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 2),
+			HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 4),
 			&dd->port->command_list_dma,
 			GFP_KERNEL);
 	if (!dd->port->command_list) {
@@ -2611,7 +2853,7 @@ static int mtip_hw_init(struct driver_data *dd)
 	/* Clear the memory we have allocated. */
 	memset(dd->port->command_list,
 		0,
-		HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 2));
+		HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 4));
 
 	/* Setup the addresse of the RX FIS. */
 	dd->port->rxfis	    = dd->port->command_list + HW_CMD_SLOT_SZ;
@@ -2627,10 +2869,19 @@ static int mtip_hw_init(struct driver_data *dd)
 	dd->port->identify_dma = dd->port->command_tbl_dma +
 					HW_CMD_TBL_AR_SZ;
 
-	/* Setup the address of the sector buffer. */
+	/* Setup the address of the sector buffer - for some non-ncq cmds */
 	dd->port->sector_buffer	= (void *) dd->port->identify + ATA_SECT_SIZE;
 	dd->port->sector_buffer_dma = dd->port->identify_dma + ATA_SECT_SIZE;
 
+	/* Setup the address of the log buf - for read log command */
+	dd->port->log_buf = (void *)dd->port->sector_buffer  + ATA_SECT_SIZE;
+	dd->port->log_buf_dma = dd->port->sector_buffer_dma + ATA_SECT_SIZE;
+
+	/* Setup the address of the smart buf - for smart read data command */
+	dd->port->smart_buf = (void *)dd->port->log_buf  + ATA_SECT_SIZE;
+	dd->port->smart_buf_dma = dd->port->log_buf_dma + ATA_SECT_SIZE;
+
+
 	/* Point the command headers at the command tables. */
 	for (i = 0; i < num_command_slots; i++) {
 		dd->port->commands[i].command_header =
@@ -2757,6 +3008,43 @@ static int mtip_hw_init(struct driver_data *dd)
 		return MTIP_FTL_REBUILD_MAGIC;
 	}
 	mtip_dump_identify(dd->port);
+
+	/* check write protect, over temp and rebuild statuses */
+	rv = mtip_read_log_page(dd->port, ATA_LOG_SATA_NCQ,
+				dd->port->log_buf,
+				dd->port->log_buf_dma, 1);
+	if (rv) {
+		dev_warn(&dd->pdev->dev,
+			"Error in READ LOG EXT (10h) command\n");
+		/* non-critical error, don't fail the load */
+	} else {
+		buf = (unsigned char *)dd->port->log_buf;
+		if (buf[259] & 0x1) {
+			dev_info(&dd->pdev->dev,
+				"Write protect bit is set.\n");
+			set_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag);
+		}
+		if (buf[288] == 0xF7) {
+			dev_info(&dd->pdev->dev,
+				"Exceeded Tmax, drive in thermal shutdown.\n");
+			set_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag);
+		}
+		if (buf[288] == 0xBF) {
+			dev_info(&dd->pdev->dev,
+				"Drive indicates rebuild has failed.\n");
+			/* TODO */
+		}
+	}
+
+	/* get write protect progess */
+	memset(&attr242, 0, sizeof(struct smart_attr));
+	if (mtip_get_smart_attr(dd->port, 242, &attr242))
+		dev_warn(&dd->pdev->dev,
+				"Unable to check write protect progress\n");
+	else
+		dev_info(&dd->pdev->dev,
+				"Write protect progress: %d%% (%d blocks)\n",
+				attr242.cur, attr242.data);
 	return rv;
 
 out3:
@@ -2774,7 +3062,7 @@ out2:
 
 	/* Free the command/command header memory. */
 	dmam_free_coherent(&dd->pdev->dev,
-				HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 2),
+				HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 4),
 				dd->port->command_list,
 				dd->port->command_list_dma);
 out1:
@@ -2800,7 +3088,7 @@ static int mtip_hw_exit(struct driver_data *dd)
 	 */
 	if (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
 
-		if (test_bit(MTIP_FLAG_REBUILD_BIT, &dd->dd_flag))
+		if (!test_bit(MTIP_FLAG_REBUILD_BIT, &dd->port->flags))
 			if (mtip_standby_immediate(dd->port))
 				dev_warn(&dd->pdev->dev,
 					"STANDBY IMMEDIATE failed\n");
@@ -2823,7 +3111,7 @@ static int mtip_hw_exit(struct driver_data *dd)
 
 	/* Free the command/command header memory. */
 	dmam_free_coherent(&dd->pdev->dev,
-			HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 2),
+			HW_PORT_PRIV_DMA_SZ + (ATA_SECT_SIZE * 4),
 			dd->port->command_list,
 			dd->port->command_list_dma);
 	/* Free the memory allocated for the for structure. */
@@ -3376,7 +3664,7 @@ static int mtip_block_remove(struct driver_data *dd)
 		kthread_stop(dd->mtip_svc_handler);
 	}
 
-	/* Clean up the sysfs attributes managed by the protocol layer. */
+	/* Clean up the sysfs attributes, if created */
 	if (test_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag)) {
 		kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
 		if (kobj) {
@@ -3390,6 +3678,11 @@ static int mtip_block_remove(struct driver_data *dd)
 	 * from /dev
 	 */
 	del_gendisk(dd->disk);
+
+	spin_lock(&rssd_index_lock);
+	ida_remove(&rssd_index_ida, dd->index);
+	spin_unlock(&rssd_index_lock);
+
 	blk_cleanup_queue(dd->queue);
 	dd->disk  = NULL;
 	dd->queue = NULL;
@@ -3419,6 +3712,11 @@ static int mtip_block_shutdown(struct driver_data *dd)
 
 	/* Delete our gendisk structure, and cleanup the blk queue. */
 	del_gendisk(dd->disk);
+
+	spin_lock(&rssd_index_lock);
+	ida_remove(&rssd_index_ida, dd->index);
+	spin_unlock(&rssd_index_lock);
+
 	blk_cleanup_queue(dd->queue);
 	dd->disk  = NULL;
 	dd->queue = NULL;
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index f4e46cc..ea5c7e7 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -127,6 +127,19 @@
 #define MTIP_DD_FLAG_CLEANUP_BIT		3
 #define MTIP_DD_FLAG_INIT_DONE_BIT		4
 
+#define MTIP_DD_FLAG_WRITE_PROTECT_BIT		5
+#define MTIP_DD_FLAG_OVER_TEMP_BIT		6
+#define MTIP_DD_FLAG_REBUILD_FAILED_BIT		7
+
+__packed struct smart_attr{
+	u8 attr_id;
+	u16 flags;
+	u8 cur;
+	u8 worst;
+	u32 data;
+	u8 res[3];
+};
+
 /* Register Frame Information Structure (FIS), host to device. */
 struct host_to_dev_fis {
 	/*
@@ -351,6 +364,12 @@ struct mtip_port {
 	 * when the command slot and all associated data structures
 	 * are no longer needed.
 	 */
+	u16 *log_buf;
+	dma_addr_t log_buf_dma;
+
+	u8 *smart_buf;
+	dma_addr_t smart_buf_dma;
+
 	unsigned long allocated[SLOTBITS_IN_LONGS];
 	/*
 	 * used to queue commands when an internal command is in progress
-- 
1.7.1

