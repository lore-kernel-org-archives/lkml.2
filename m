Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1GACUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:20:30 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33134 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754306Ab1GACT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:27 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 07/11] misc: I2C communication with the MPU3050 and slave devices
Date: Thu, 30 Jun 2011 19:18:23 -0700
Message-Id: <1309486707-1658-7-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/inv_mpu/mlsl.c |  389 +++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/mlsl.h |  186 +++++++++++++++++++++
 2 files changed, 575 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/mlsl.c
 create mode 100644 drivers/misc/inv_mpu/mlsl.h

diff --git a/drivers/misc/inv_mpu/mlsl.c b/drivers/misc/inv_mpu/mlsl.c
new file mode 100644
index 0000000..0d15559
--- /dev/null
+++ b/drivers/misc/inv_mpu/mlsl.c
@@ -0,0 +1,389 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#include "mlsl.h"
+#include <linux/i2c.h>
+#  include "mpu3050.h"
+
+static int inv_i2c_write(struct i2c_adapter *i2c_adap,
+			    unsigned char address,
+			    unsigned int len, unsigned char const *data)
+{
+	struct i2c_msg msgs[1];
+	int res;
+
+	if (!data || !i2c_adap)
+		return -EINVAL;
+
+	msgs[0].addr = address;
+	msgs[0].flags = 0;	/* write */
+	msgs[0].buf = (unsigned char *)data;
+	msgs[0].len = len;
+
+	res = i2c_transfer(i2c_adap, msgs, 1);
+	if (res < 1) {
+		if (res == 0)
+			res = -EIO;
+		return res;
+	} else
+		return 0;
+}
+
+static int inv_i2c_write_register(struct i2c_adapter *i2c_adap,
+				     unsigned char address,
+				     unsigned char reg, unsigned char value)
+{
+	unsigned char data[2];
+
+	data[0] = reg;
+	data[1] = value;
+	return inv_i2c_write(i2c_adap, address, 2, data);
+}
+
+static int inv_i2c_read(struct i2c_adapter *i2c_adap,
+			   unsigned char address, unsigned char reg,
+			   unsigned int len, unsigned char *data)
+{
+	struct i2c_msg msgs[2];
+	int res;
+
+	if (!data || !i2c_adap)
+		return -EINVAL;
+
+	msgs[0].addr = address;
+	msgs[0].flags = 0;	/* write */
+	msgs[0].buf = &reg;
+	msgs[0].len = 1;
+
+	msgs[1].addr = address;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].buf = data;
+	msgs[1].len = len;
+
+	res = i2c_transfer(i2c_adap, msgs, 2);
+	if (res < 2) {
+		if (res >= 0)
+			res = -EIO;
+		return res;
+	} else
+		return 0;
+}
+
+static int mpu_memory_read(struct i2c_adapter *i2c_adap,
+			   unsigned char mpu_addr,
+			   unsigned short mem_addr,
+			   unsigned int len, unsigned char *data)
+{
+	unsigned char bank[2];
+	unsigned char addr[2];
+	unsigned char buf;
+
+	struct i2c_msg msgs[4];
+	int res;
+
+	if (!data || !i2c_adap)
+		return -EINVAL;
+
+	bank[0] = MPUREG_BANK_SEL;
+	bank[1] = mem_addr >> 8;
+
+	addr[0] = MPUREG_MEM_START_ADDR;
+	addr[1] = mem_addr & 0xFF;
+
+	buf = MPUREG_MEM_R_W;
+
+	/* write message */
+	msgs[0].addr = mpu_addr;
+	msgs[0].flags = 0;
+	msgs[0].buf = bank;
+	msgs[0].len = sizeof(bank);
+
+	msgs[1].addr = mpu_addr;
+	msgs[1].flags = 0;
+	msgs[1].buf = addr;
+	msgs[1].len = sizeof(addr);
+
+	msgs[2].addr = mpu_addr;
+	msgs[2].flags = 0;
+	msgs[2].buf = &buf;
+	msgs[2].len = 1;
+
+	msgs[3].addr = mpu_addr;
+	msgs[3].flags = I2C_M_RD;
+	msgs[3].buf = data;
+	msgs[3].len = len;
+
+	res = i2c_transfer(i2c_adap, msgs, 4);
+	if (res != 4) {
+		if (res >= 0)
+			res = -EIO;
+		return res;
+	} else
+		return 0;
+}
+
+static int mpu_memory_write(struct i2c_adapter *i2c_adap,
+			    unsigned char mpu_addr,
+			    unsigned short mem_addr,
+			    unsigned int len, unsigned char const *data)
+{
+	unsigned char bank[2];
+	unsigned char addr[2];
+	unsigned char buf[513];
+
+	struct i2c_msg msgs[3];
+	int res;
+
+	if (!data || !i2c_adap)
+		return -EINVAL;
+	if (len >= (sizeof(buf) - 1))
+		return -ENOMEM;
+
+	bank[0] = MPUREG_BANK_SEL;
+	bank[1] = mem_addr >> 8;
+
+	addr[0] = MPUREG_MEM_START_ADDR;
+	addr[1] = mem_addr & 0xFF;
+
+	buf[0] = MPUREG_MEM_R_W;
+	memcpy(buf + 1, data, len);
+
+	/* write message */
+	msgs[0].addr = mpu_addr;
+	msgs[0].flags = 0;
+	msgs[0].buf = bank;
+	msgs[0].len = sizeof(bank);
+
+	msgs[1].addr = mpu_addr;
+	msgs[1].flags = 0;
+	msgs[1].buf = addr;
+	msgs[1].len = sizeof(addr);
+
+	msgs[2].addr = mpu_addr;
+	msgs[2].flags = 0;
+	msgs[2].buf = (unsigned char *)buf;
+	msgs[2].len = len + 1;
+
+	res = i2c_transfer(i2c_adap, msgs, 3);
+	if (res != 3) {
+		if (res >= 0)
+			res = -EIO;
+		return res;
+	} else
+		return 0;
+}
+
+int inv_serial_single_write(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned char register_addr,
+	unsigned char data)
+{
+	return inv_i2c_write_register((struct i2c_adapter *)sl_handle,
+				      slave_addr, register_addr, data);
+}
+EXPORT_SYMBOL(inv_serial_single_write);
+
+int inv_serial_write(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char const *data)
+{
+	int result;
+	const unsigned short data_length = length - 1;
+	const unsigned char start_reg_addr = data[0];
+	unsigned char i2c_write[SERIAL_MAX_TRANSFER_SIZE + 1];
+	unsigned short bytes_written = 0;
+
+	while (bytes_written < data_length) {
+		unsigned short this_len = min(SERIAL_MAX_TRANSFER_SIZE,
+					     data_length - bytes_written);
+		if (bytes_written == 0) {
+			result = inv_i2c_write((struct i2c_adapter *)
+					       sl_handle, slave_addr,
+					       1 + this_len, data);
+		} else {
+			/* manually increment register addr between chunks */
+			i2c_write[0] = start_reg_addr + bytes_written;
+			memcpy(&i2c_write[1], &data[1 + bytes_written],
+				this_len);
+			result = inv_i2c_write((struct i2c_adapter *)
+					       sl_handle, slave_addr,
+					       1 + this_len, i2c_write);
+		}
+		if (result)
+			return result;
+		bytes_written += this_len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_write);
+
+int inv_serial_read(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned char register_addr,
+	unsigned short length,
+	unsigned char *data)
+{
+	int result;
+	unsigned short bytes_read = 0;
+
+	if (register_addr == MPUREG_FIFO_R_W || register_addr == MPUREG_MEM_R_W)
+		return INV_ERROR_INVALID_PARAMETER;
+
+	while (bytes_read < length) {
+		unsigned short this_len =
+		    min(SERIAL_MAX_TRANSFER_SIZE, length - bytes_read);
+		result = inv_i2c_read((struct i2c_adapter *)sl_handle,
+				      slave_addr, register_addr + bytes_read,
+				      this_len, &data[bytes_read]);
+		if (result)
+			return result;
+		bytes_read += this_len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_read);
+
+int inv_serial_write_mem(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short mem_addr,
+	unsigned short length,
+	unsigned char const *data)
+{
+	int result;
+	unsigned short bytes_written = 0;
+
+	if ((mem_addr & 0xFF) + length > MPU_MEM_BANK_SIZE) {
+		pr_err("memory read length (%d B) extends beyond its"
+		       " limits (%d) if started at location %d\n", length,
+		       MPU_MEM_BANK_SIZE, mem_addr & 0xFF);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+	while (bytes_written < length) {
+		unsigned short this_len =
+		    min(SERIAL_MAX_TRANSFER_SIZE, length - bytes_written);
+		result = mpu_memory_write((struct i2c_adapter *)sl_handle,
+					  slave_addr, mem_addr + bytes_written,
+					  this_len, &data[bytes_written]);
+		if (result)
+			return result;
+		bytes_written += this_len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_write_mem);
+
+int inv_serial_read_mem(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short mem_addr,
+	unsigned short length,
+	unsigned char *data)
+{
+	int result;
+	unsigned short bytes_read = 0;
+
+	if ((mem_addr & 0xFF) + length > MPU_MEM_BANK_SIZE) {
+		printk
+		    ("memory read length (%d B) extends beyond its limits (%d) "
+		     "if started at location %d\n", length,
+		     MPU_MEM_BANK_SIZE, mem_addr & 0xFF);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+	while (bytes_read < length) {
+		unsigned short this_len =
+		    min(SERIAL_MAX_TRANSFER_SIZE, length - bytes_read);
+		result =
+		    mpu_memory_read((struct i2c_adapter *)sl_handle,
+				    slave_addr, mem_addr + bytes_read,
+				    this_len, &data[bytes_read]);
+		if (result)
+			return result;
+		bytes_read += this_len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_read_mem);
+
+int inv_serial_write_fifo(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char const *data)
+{
+	int result;
+	unsigned char i2c_write[SERIAL_MAX_TRANSFER_SIZE + 1];
+	unsigned short bytes_written = 0;
+
+	if (length > FIFO_HW_SIZE) {
+		printk(KERN_ERR
+		       "maximum fifo write length is %d\n", FIFO_HW_SIZE);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+	while (bytes_written < length) {
+		unsigned short this_len =
+		    min(SERIAL_MAX_TRANSFER_SIZE, length - bytes_written);
+		i2c_write[0] = MPUREG_FIFO_R_W;
+		memcpy(&i2c_write[1], &data[bytes_written], this_len);
+		result = inv_i2c_write((struct i2c_adapter *)sl_handle,
+				       slave_addr, this_len + 1, i2c_write);
+		if (result)
+			return result;
+		bytes_written += this_len;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_write_fifo);
+
+int inv_serial_read_fifo(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char *data)
+{
+	int result;
+	unsigned short bytes_read = 0;
+
+	if (length > FIFO_HW_SIZE) {
+		printk(KERN_ERR
+		       "maximum fifo read length is %d\n", FIFO_HW_SIZE);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+	while (bytes_read < length) {
+		unsigned short this_len =
+		    min(SERIAL_MAX_TRANSFER_SIZE, length - bytes_read);
+		result = inv_i2c_read((struct i2c_adapter *)sl_handle,
+				      slave_addr, MPUREG_FIFO_R_W, this_len,
+				      &data[bytes_read]);
+		if (result)
+			return result;
+		bytes_read += this_len;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(inv_serial_read_fifo);
+
+/**
+ *  @}
+ */
diff --git a/drivers/misc/inv_mpu/mlsl.h b/drivers/misc/inv_mpu/mlsl.h
new file mode 100644
index 0000000..204baed
--- /dev/null
+++ b/drivers/misc/inv_mpu/mlsl.h
@@ -0,0 +1,186 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#ifndef __MLSL_H__
+#define __MLSL_H__
+
+/**
+ *  @defgroup   MLSL
+ *  @brief      Motion Library - Serial Layer.
+ *              The Motion Library System Layer provides the Motion Library
+ *              with the communication interface to the hardware.
+ *
+ *              The communication interface is assumed to support serial
+ *              transfers in burst of variable length up to
+ *              SERIAL_MAX_TRANSFER_SIZE.
+ *              The default value for SERIAL_MAX_TRANSFER_SIZE is 128 bytes.
+ *              Transfers of length greater than SERIAL_MAX_TRANSFER_SIZE, will
+ *              be subdivided in smaller transfers of length <=
+ *              SERIAL_MAX_TRANSFER_SIZE.
+ *              The SERIAL_MAX_TRANSFER_SIZE definition can be modified to
+ *              overcome any host processor transfer size limitation down to
+ *              1 B, the minimum.
+ *              An higher value for SERIAL_MAX_TRANSFER_SIZE will favor
+ *              performance and efficiency while requiring higher resource usage
+ *              (mostly buffering). A smaller value will increase overhead and
+ *              decrease efficiency but allows to operate with more resource
+ *              constrained processor and master serial controllers.
+ *              The SERIAL_MAX_TRANSFER_SIZE definition can be found in the
+ *              mlsl.h header file and master serial controllers.
+ *              The SERIAL_MAX_TRANSFER_SIZE definition can be found in the
+ *              mlsl.h header file.
+ *
+ *  @{
+ *      @file   mlsl.h
+ *      @brief  The Motion Library System Layer.
+ *
+ */
+
+#include "mltypes.h"
+#include <linux/mpu.h>
+
+
+/*
+ * NOTE : to properly support Yamaha compass reads,
+ *	  the max transfer size should be at least 9 B.
+ *	  Length in bytes, typically a power of 2 >= 2
+ */
+#define SERIAL_MAX_TRANSFER_SIZE 128
+
+
+/**
+ *  inv_serial_single_write() - used to write a single byte of data.
+ *  @sl_handle		pointer to the serial device used for the communication.
+ *  @slave_addr		I2C slave address of device.
+ *  @register_addr	Register address to write.
+ *  @data		Single byte of data to write.
+ *
+ *	It is called by the MPL to write a single byte of data to the MPU.
+ *
+ *  returns INV_SUCCESS if successful, a non-zero error code otherwise.
+ */
+int inv_serial_single_write(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned char register_addr,
+	unsigned char data);
+
+/**
+ *  inv_serial_write() - used to write multiple bytes of data to registers.
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @register_addr	Register address to write.
+ *  @length	Length of burst of data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS if successful, a non-zero error code otherwise.
+ */
+int inv_serial_write(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char const *data);
+
+/**
+ *  inv_serial_read() - used to read multiple bytes of data from registers.
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @register_addr	Register address to read.
+ *  @length	Length of burst of data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS == 0 if successful; a non-zero error code otherwise.
+ */
+int inv_serial_read(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned char register_addr,
+	unsigned short length,
+	unsigned char *data);
+
+/**
+ *  inv_serial_read_mem() - used to read multiple bytes of data from the memory.
+ *	    This should be sent by I2C or SPI.
+ *
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @mem_addr	The location in the memory to read from.
+ *  @length	Length of burst data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS == 0 if successful; a non-zero error code otherwise.
+ */
+int inv_serial_read_mem(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short mem_addr,
+	unsigned short length,
+	unsigned char *data);
+
+/**
+ *  inv_serial_write_mem() - used to write multiple bytes of data to the memory.
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @mem_addr	The location in the memory to write to.
+ *  @length	Length of burst data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS == 0 if successful; a non-zero error code otherwise.
+ */
+int inv_serial_write_mem(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short mem_addr,
+	unsigned short length,
+	unsigned char const *data);
+
+/**
+ *  inv_serial_read_fifo() - used to read multiple bytes of data from the fifo.
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @length	Length of burst of data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS == 0 if successful; a non-zero error code otherwise.
+ */
+int inv_serial_read_fifo(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char *data);
+
+/**
+ *  inv_serial_write_fifo() - used to write multiple bytes of data to the fifo.
+ *  @sl_handle	a file handle to the serial device used for the communication.
+ *  @slave_addr	I2C slave address of device.
+ *  @length	Length of burst of data.
+ *  @data	Pointer to block of data.
+ *
+ *  returns INV_SUCCESS == 0 if successful; a non-zero error code otherwise.
+ */
+int inv_serial_write_fifo(
+	void *sl_handle,
+	unsigned char slave_addr,
+	unsigned short length,
+	unsigned char const *data);
+
+/**
+ * @}
+ */
+#endif				/* __MLSL_H__ */
-- 
1.7.4.1

