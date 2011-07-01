Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1GACTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:19:30 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49186 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754626Ab1GACTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:25 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 06/11] misc: inv_mpu logging and debugging support
Date: Thu, 30 Jun 2011 19:18:22 -0700
Message-Id: <1309486707-1658-6-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/inv_mpu/log.h            |  287 +++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/mldl_print_cfg.c |  131 +++++++++++++++
 drivers/misc/inv_mpu/mldl_print_cfg.h |   38 +++++
 drivers/misc/inv_mpu/mltypes.h        |  226 ++++++++++++++++++++++++++
 4 files changed, 682 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/log.h
 create mode 100644 drivers/misc/inv_mpu/mldl_print_cfg.c
 create mode 100644 drivers/misc/inv_mpu/mldl_print_cfg.h
 create mode 100644 drivers/misc/inv_mpu/mltypes.h

diff --git a/drivers/misc/inv_mpu/log.h b/drivers/misc/inv_mpu/log.h
new file mode 100644
index 0000000..a8db425
--- /dev/null
+++ b/drivers/misc/inv_mpu/log.h
@@ -0,0 +1,287 @@
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
+/*
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *
+ * Copyright (C) 2005 The Android Open Source Project
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+
+/*
+ * C/C++ logging functions.  See the logging documentation for API details.
+ *
+ * We'd like these to be available from C code (in case we import some from
+ * somewhere), so this has a C interface.
+ *
+ * The output will be correct when the log file is shared between multiple
+ * threads and/or multiple processes so long as the operating system
+ * supports O_APPEND.  These calls have mutex-protected data structures
+ * and so are NOT reentrant.  Do not use MPL_LOG in a signal handler.
+ */
+#ifndef _LIBS_CUTILS_MPL_LOG_H
+#define _LIBS_CUTILS_MPL_LOG_H
+
+#include "mltypes.h"
+#include <stdarg.h>
+
+
+#include <linux/kernel.h>
+
+
+/* --------------------------------------------------------------------- */
+
+/*
+ * Normally we strip MPL_LOGV (VERBOSE messages) from release builds.
+ * You can modify this (for example with "#define MPL_LOG_NDEBUG 0"
+ * at the top of your source file) to change that behavior.
+ */
+#ifndef MPL_LOG_NDEBUG
+#ifdef NDEBUG
+#define MPL_LOG_NDEBUG 1
+#else
+#define MPL_LOG_NDEBUG 0
+#endif
+#endif
+
+#define MPL_LOG_UNKNOWN MPL_LOG_VERBOSE
+#define MPL_LOG_DEFAULT KERN_DEFAULT
+#define MPL_LOG_VERBOSE KERN_CONT
+#define MPL_LOG_DEBUG   KERN_NOTICE
+#define MPL_LOG_INFO    KERN_INFO
+#define MPL_LOG_WARN    KERN_WARNING
+#define MPL_LOG_ERROR   KERN_ERR
+#define MPL_LOG_SILENT  MPL_LOG_VERBOSE
+
+
+
+/*
+ * This is the local tag used for the following simplified
+ * logging macros.  You can change this preprocessor definition
+ * before using the other macros to change the tag.
+ */
+#ifndef MPL_LOG_TAG
+#define MPL_LOG_TAG
+#endif
+
+/* --------------------------------------------------------------------- */
+
+/*
+ * Simplified macro to send a verbose log message using the current MPL_LOG_TAG.
+ */
+#ifndef MPL_LOGV
+#if MPL_LOG_NDEBUG
+#define MPL_LOGV(fmt, ...)						\
+	do {								\
+		if (0)							\
+			MPL_LOG(LOG_VERBOSE, MPL_LOG_TAG, fmt, ##__VA_ARGS__);\
+	} while (0)
+#else
+#define MPL_LOGV(fmt, ...) MPL_LOG(LOG_VERBOSE, MPL_LOG_TAG, fmt, ##__VA_ARGS__)
+#endif
+#endif
+
+#ifndef CONDITION
+#define CONDITION(cond)     ((cond) != 0)
+#endif
+
+#ifndef MPL_LOGV_IF
+#if MPL_LOG_NDEBUG
+#define MPL_LOGV_IF(cond, fmt, ...)  \
+	do { if (0) MPL_LOG(fmt, ##__VA_ARGS__); } while (0)
+#else
+#define MPL_LOGV_IF(cond, fmt, ...) \
+	((CONDITION(cond))						\
+		? MPL_LOG(LOG_VERBOSE, MPL_LOG_TAG, fmt, ##__VA_ARGS__) \
+		: (void)0)
+#endif
+#endif
+
+/*
+ * Simplified macro to send a debug log message using the current MPL_LOG_TAG.
+ */
+#ifndef MPL_LOGD
+#define MPL_LOGD(fmt, ...) MPL_LOG(LOG_DEBUG, MPL_LOG_TAG, fmt, ##__VA_ARGS__)
+#endif
+
+#ifndef MPL_LOGD_IF
+#define MPL_LOGD_IF(cond, fmt, ...) \
+	((CONDITION(cond))					       \
+		? MPL_LOG(LOG_DEBUG, MPL_LOG_TAG, fmt, ##__VA_ARGS__)  \
+		: (void)0)
+#endif
+
+/*
+ * Simplified macro to send an info log message using the current MPL_LOG_TAG.
+ */
+#ifndef MPL_LOGI
+#define MPL_LOGI(fmt, ...) MPL_LOG(LOG_INFO, MPL_LOG_TAG, fmt, ##__VA_ARGS__)
+#endif
+
+#ifndef MPL_LOGI_IF
+#define MPL_LOGI_IF(cond, fmt, ...) \
+	((CONDITION(cond))                                              \
+		? MPL_LOG(LOG_INFO, MPL_LOG_TAG, fmt, ##__VA_ARGS__)   \
+		: (void)0)
+#endif
+
+/*
+ * Simplified macro to send a warning log message using the current MPL_LOG_TAG.
+ */
+#ifndef MPL_LOGW
+#define MPL_LOGW(fmt, ...) printk(KERN_WARNING MPL_LOG_TAG fmt, ##__VA_ARGS__)
+#endif
+
+#ifndef MPL_LOGW_IF
+#define MPL_LOGW_IF(cond, fmt, ...) \
+	((CONDITION(cond))					       \
+		? MPL_LOG(LOG_WARN, MPL_LOG_TAG, fmt, ##__VA_ARGS__)   \
+		: (void)0)
+#endif
+
+/*
+ * Simplified macro to send an error log message using the current MPL_LOG_TAG.
+ */
+#ifndef MPL_LOGE
+#define MPL_LOGE(fmt, ...) printk(KERN_ERR MPL_LOG_TAG fmt, ##__VA_ARGS__)
+#endif
+
+#ifndef MPL_LOGE_IF
+#define MPL_LOGE_IF(cond, fmt, ...) \
+	((CONDITION(cond))					       \
+		? MPL_LOG(LOG_ERROR, MPL_LOG_TAG, fmt, ##__VA_ARGS__)  \
+		: (void)0)
+#endif
+
+/* --------------------------------------------------------------------- */
+
+/*
+ * Log a fatal error.  If the given condition fails, this stops program
+ * execution like a normal assertion, but also generating the given message.
+ * It is NOT stripped from release builds.  Note that the condition test
+ * is -inverted- from the normal assert() semantics.
+ */
+#define MPL_LOG_ALWAYS_FATAL_IF(cond, fmt, ...) \
+	((CONDITION(cond))					   \
+		? ((void)android_printAssert(#cond, MPL_LOG_TAG,   \
+						fmt, ##__VA_ARGS__))	\
+		: (void)0)
+
+#define MPL_LOG_ALWAYS_FATAL(fmt, ...) \
+	(((void)android_printAssert(NULL, MPL_LOG_TAG, fmt, ##__VA_ARGS__)))
+
+/*
+ * Versions of MPL_LOG_ALWAYS_FATAL_IF and MPL_LOG_ALWAYS_FATAL that
+ * are stripped out of release builds.
+ */
+#if MPL_LOG_NDEBUG
+#define MPL_LOG_FATAL_IF(cond, fmt, ...)				\
+	do {								\
+		if (0)							\
+			MPL_LOG_ALWAYS_FATAL_IF(cond, fmt, ##__VA_ARGS__); \
+	} while (0)
+#define MPL_LOG_FATAL(fmt, ...)						\
+	do {								\
+		if (0)							\
+			MPL_LOG_ALWAYS_FATAL(fmt, ##__VA_ARGS__)	\
+	} while (0)
+#else
+#define MPL_LOG_FATAL_IF(cond, fmt, ...) \
+	MPL_LOG_ALWAYS_FATAL_IF(cond, fmt, ##__VA_ARGS__)
+#define MPL_LOG_FATAL(fmt, ...) \
+	MPL_LOG_ALWAYS_FATAL(fmt, ##__VA_ARGS__)
+#endif
+
+/*
+ * Assertion that generates a log message when the assertion fails.
+ * Stripped out of release builds.  Uses the current MPL_LOG_TAG.
+ */
+#define MPL_LOG_ASSERT(cond, fmt, ...)			\
+	MPL_LOG_FATAL_IF(!(cond), fmt, ##__VA_ARGS__)
+
+/* --------------------------------------------------------------------- */
+
+/*
+ * Basic log message macro.
+ *
+ * Example:
+ *  MPL_LOG(MPL_LOG_WARN, NULL, "Failed with error %d", errno);
+ *
+ * The second argument may be NULL or "" to indicate the "global" tag.
+ */
+#ifndef MPL_LOG
+#define MPL_LOG(priority, tag, fmt, ...)		\
+	MPL_LOG_PRI(priority, tag, fmt, ##__VA_ARGS__)
+#endif
+
+/*
+ * Log macro that allows you to specify a number for the priority.
+ */
+#ifndef MPL_LOG_PRI
+#define MPL_LOG_PRI(priority, tag, fmt, ...) \
+	pr_debug(MPL_##priority tag fmt, ##__VA_ARGS__)
+#endif
+
+/*
+ * Log macro that allows you to pass in a varargs ("args" is a va_list).
+ */
+#ifndef MPL_LOG_PRI_VA
+/* not allowed in the Kernel because there is no dev_dbg that takes a va_list */
+#endif
+
+/* --------------------------------------------------------------------- */
+
+/*
+ * ===========================================================================
+ *
+ * The stuff in the rest of this file should not be used directly.
+ */
+
+int _MLPrintLog(int priority, const char *tag, const char *fmt,	...);
+int _MLPrintVaLog(int priority, const char *tag, const char *fmt, va_list args);
+/* Final implementation of actual writing to a character device */
+int _MLWriteLog(const char *buf, int buflen);
+
+static inline void __print_result_location(int result,
+					   const char *file,
+					   const char *func, int line)
+{
+	MPL_LOGE("%s|%s|%d returning %d\n", file, func, line, result);
+}
+
+#define LOG_RESULT_LOCATION(condition) \
+	do {								\
+		__print_result_location((int)(condition), __FILE__,	\
+					__func__, __LINE__);		\
+	} while (0)
+
+
+#endif				/* _LIBS_CUTILS_MPL_LOG_H */
diff --git a/drivers/misc/inv_mpu/mldl_print_cfg.c b/drivers/misc/inv_mpu/mldl_print_cfg.c
new file mode 100644
index 0000000..8218824
--- /dev/null
+++ b/drivers/misc/inv_mpu/mldl_print_cfg.c
@@ -0,0 +1,131 @@
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
+/**
+ *  @addtogroup MLDL
+ *
+ *  @{
+ *      @file   mldl_print_cfg.c
+ *      @brief  The Motion Library Driver Layer.
+ */
+
+#include <stddef.h>
+#include "mldl_cfg.h"
+#include "mlsl.h"
+#include "linux/mpu.h"
+
+
+void mldl_print_cfg(struct mldl_cfg *mldl_cfg)
+{
+	struct mpu_gyro_cfg	*mpu_gyro_cfg	= mldl_cfg->mpu_gyro_cfg;
+	struct mpu_offsets	*mpu_offsets	= mldl_cfg->mpu_offsets;
+	struct mpu_chip_info	*mpu_chip_info	= mldl_cfg->mpu_chip_info;
+	struct inv_mpu_cfg	*inv_mpu_cfg	= mldl_cfg->inv_mpu_cfg;
+	struct inv_mpu_state	*inv_mpu_state	= mldl_cfg->inv_mpu_state;
+	struct ext_slave_descr	**slave		= mldl_cfg->slave;
+	struct mpu_platform_data *pdata		= mldl_cfg->pdata;
+	struct ext_slave_platform_data **pdata_slave = mldl_cfg->pdata_slave;
+	int ii;
+
+	/* mpu_gyro_cfg */
+	MPL_LOGD("int_config     = %02x\n", mpu_gyro_cfg->int_config);
+	MPL_LOGD("ext_sync       = %02x\n", mpu_gyro_cfg->ext_sync);
+	MPL_LOGD("full_scale     = %02x\n", mpu_gyro_cfg->full_scale);
+	MPL_LOGD("lpf            = %02x\n", mpu_gyro_cfg->lpf);
+	MPL_LOGD("clk_src        = %02x\n", mpu_gyro_cfg->clk_src);
+	MPL_LOGD("divider        = %02x\n", mpu_gyro_cfg->divider);
+	MPL_LOGD("dmp_enable     = %02x\n", mpu_gyro_cfg->dmp_enable);
+	MPL_LOGD("fifo_enable    = %02x\n", mpu_gyro_cfg->fifo_enable);
+	MPL_LOGD("dmp_cfg1       = %02x\n", mpu_gyro_cfg->dmp_cfg1);
+	MPL_LOGD("dmp_cfg2       = %02x\n", mpu_gyro_cfg->dmp_cfg2);
+	/* mpu_offsets */
+	MPL_LOGD("tc[0]      = %02x\n", mpu_offsets->tc[0]);
+	MPL_LOGD("tc[1]      = %02x\n", mpu_offsets->tc[1]);
+	MPL_LOGD("tc[2]      = %02x\n", mpu_offsets->tc[2]);
+	MPL_LOGD("gyro[0]    = %04x\n", mpu_offsets->gyro[0]);
+	MPL_LOGD("gyro[1]    = %04x\n", mpu_offsets->gyro[1]);
+	MPL_LOGD("gyro[2]    = %04x\n", mpu_offsets->gyro[2]);
+
+	/* mpu_chip_info */
+	MPL_LOGD("addr            = %02x\n", mldl_cfg->mpu_chip_info->addr);
+
+	MPL_LOGD("silicon_revision = %02x\n", mpu_chip_info->silicon_revision);
+	MPL_LOGD("product_revision = %02x\n", mpu_chip_info->product_revision);
+	MPL_LOGD("product_id       = %02x\n", mpu_chip_info->product_id);
+	MPL_LOGD("gyro_sens_trim   = %02x\n", mpu_chip_info->gyro_sens_trim);
+
+	MPL_LOGD("requested_sensors = %04x\n", inv_mpu_cfg->requested_sensors);
+	MPL_LOGD("ignore_system_suspend= %04x\n",
+		inv_mpu_cfg->ignore_system_suspend);
+	MPL_LOGD("status = %04x\n", inv_mpu_state->status);
+	MPL_LOGD("i2c_slaves_enabled= %04x\n",
+		inv_mpu_state->i2c_slaves_enabled);
+
+	for (ii = 0; ii < EXT_SLAVE_NUM_TYPES; ii++) {
+		if (!slave[ii])
+			continue;
+		MPL_LOGD("SLAVE %d:\n", ii);
+		MPL_LOGD("    suspend  = %02x\n", (int)slave[ii]->suspend);
+		MPL_LOGD("    resume   = %02x\n", (int)slave[ii]->resume);
+		MPL_LOGD("    read     = %02x\n", (int)slave[ii]->read);
+		MPL_LOGD("    type     = %02x\n", slave[ii]->type);
+		MPL_LOGD("    reg      = %02x\n", slave[ii]->read_reg);
+		MPL_LOGD("    len      = %02x\n", slave[ii]->read_len);
+		MPL_LOGD("    endian   = %02x\n", slave[ii]->endian);
+		MPL_LOGD("    range.mantissa= %02x\n",
+			slave[ii]->range.mantissa);
+		MPL_LOGD("    range.fraction= %02x\n",
+			slave[ii]->range.fraction);
+	}
+
+	for (ii = 0; ii < EXT_SLAVE_NUM_TYPES; ii++) {
+		if (!pdata_slave[ii])
+			continue;
+		MPL_LOGD("PDATA_SLAVE[%d]\n", ii);
+		MPL_LOGD("    irq        = %02x\n", pdata_slave[ii]->irq);
+		MPL_LOGD("    adapt_num  = %02x\n", pdata_slave[ii]->adapt_num);
+		MPL_LOGD("    bus        = %02x\n", pdata_slave[ii]->bus);
+		MPL_LOGD("    address    = %02x\n", pdata_slave[ii]->address);
+		MPL_LOGD("    orientation=\n"
+			"                            %2d %2d %2d\n"
+			"                            %2d %2d %2d\n"
+			"                            %2d %2d %2d\n",
+			pdata_slave[ii]->orientation[0],
+			pdata_slave[ii]->orientation[1],
+			pdata_slave[ii]->orientation[2],
+			pdata_slave[ii]->orientation[3],
+			pdata_slave[ii]->orientation[4],
+			pdata_slave[ii]->orientation[5],
+			pdata_slave[ii]->orientation[6],
+			pdata_slave[ii]->orientation[7],
+			pdata_slave[ii]->orientation[8]);
+	}
+
+	MPL_LOGD("pdata->int_config         = %02x\n", pdata->int_config);
+	MPL_LOGD("pdata->level_shifter      = %02x\n", pdata->level_shifter);
+	MPL_LOGD("pdata->orientation        =\n"
+		 "                            %2d %2d %2d\n"
+		 "                            %2d %2d %2d\n"
+		 "                            %2d %2d %2d\n",
+		 pdata->orientation[0], pdata->orientation[1],
+		 pdata->orientation[2], pdata->orientation[3],
+		 pdata->orientation[4], pdata->orientation[5],
+		 pdata->orientation[6], pdata->orientation[7],
+		 pdata->orientation[8]);
+}
diff --git a/drivers/misc/inv_mpu/mldl_print_cfg.h b/drivers/misc/inv_mpu/mldl_print_cfg.h
new file mode 100644
index 0000000..2e19114
--- /dev/null
+++ b/drivers/misc/inv_mpu/mldl_print_cfg.h
@@ -0,0 +1,38 @@
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
+/**
+ * @defgroup
+ * @brief
+ *
+ * @{
+ * @file     mldl_print_cfg.h
+ * @brief
+ *
+ *
+ */
+#ifndef __MLDL_PRINT_CFG__
+#define __MLDL_PRINT_CFG__
+
+#include "mldl_cfg.h"
+
+
+void mldl_print_cfg(struct mldl_cfg *mldl_cfg);
+
+#endif /* __MLDL_PRINT_CFG__ */
diff --git a/drivers/misc/inv_mpu/mltypes.h b/drivers/misc/inv_mpu/mltypes.h
new file mode 100644
index 0000000..2abb215
--- /dev/null
+++ b/drivers/misc/inv_mpu/mltypes.h
@@ -0,0 +1,226 @@
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
+/**
+ *  @defgroup MLERROR
+ *  @brief  Motion Library - Error definitions.
+ *          Definition of the error codes used within the MPL and
+ *          returned to the user.
+ *          Every function tries to return a meaningful error code basing
+ *          on the occuring error condition. The error code is numeric.
+ *
+ *          The available error codes and their associated values are:
+ *          - (0)       INV_SUCCESS
+ *          - (1)       INV_ERROR
+ *          - (2)       INV_ERROR_INVALID_PARAMETER
+ *          - (3)       INV_ERROR_FEATURE_NOT_ENABLED
+ *          - (4)       INV_ERROR_FEATURE_NOT_IMPLEMENTED
+ *          - (6)       INV_ERROR_DMP_NOT_STARTED
+ *          - (7)       INV_ERROR_DMP_STARTED
+ *          - (8)       INV_ERROR_NOT_OPENED
+ *          - (9)       INV_ERROR_OPENED
+ *          - (10)      INV_ERROR_INVALID_MODULE
+ *          - (11)      INV_ERROR_MEMORY_EXAUSTED
+ *          - (12)      INV_ERROR_DIVIDE_BY_ZERO
+ *          - (13)      INV_ERROR_ASSERTION_FAILURE
+ *          - (14)      INV_ERROR_FILE_OPEN
+ *          - (15)      INV_ERROR_FILE_READ
+ *          - (16)      INV_ERROR_FILE_WRITE
+ *          - (17)      INV_ERROR_INVALID_CONFIGURATION
+ *          - (20)      INV_ERROR_SERIAL_CLOSED
+ *          - (21)      INV_ERROR_SERIAL_OPEN_ERROR
+ *          - (22)      INV_ERROR_SERIAL_READ
+ *          - (23)      INV_ERROR_SERIAL_WRITE
+ *          - (24)      INV_ERROR_SERIAL_DEVICE_NOT_RECOGNIZED
+ *          - (25)      INV_ERROR_SM_TRANSITION
+ *          - (26)      INV_ERROR_SM_IMPROPER_STATE
+ *          - (30)      INV_ERROR_FIFO_OVERFLOW
+ *          - (31)      INV_ERROR_FIFO_FOOTER
+ *          - (32)      INV_ERROR_FIFO_READ_COUNT
+ *          - (33)      INV_ERROR_FIFO_READ_DATA
+ *          - (40)      INV_ERROR_MEMORY_SET
+ *          - (50)      INV_ERROR_LOG_MEMORY_ERROR
+ *          - (51)      INV_ERROR_LOG_OUTPUT_ERROR
+ *          - (60)      INV_ERROR_OS_BAD_PTR
+ *          - (61)      INV_ERROR_OS_BAD_HANDLE
+ *          - (62)      INV_ERROR_OS_CREATE_FAILED
+ *          - (63)      INV_ERROR_OS_LOCK_FAILED
+ *          - (70)      INV_ERROR_COMPASS_DATA_OVERFLOW
+ *          - (71)      INV_ERROR_COMPASS_DATA_UNDERFLOW
+ *          - (72)      INV_ERROR_COMPASS_DATA_NOT_READY
+ *          - (73)      INV_ERROR_COMPASS_DATA_ERROR
+ *          - (75)      INV_ERROR_CALIBRATION_LOAD
+ *          - (76)      INV_ERROR_CALIBRATION_STORE
+ *          - (77)      INV_ERROR_CALIBRATION_LEN
+ *          - (78)      INV_ERROR_CALIBRATION_CHECKSUM
+ *          - (79)      INV_ERROR_ACCEL_DATA_OVERFLOW
+ *          - (80)      INV_ERROR_ACCEL_DATA_UNDERFLOW
+ *          - (81)      INV_ERROR_ACCEL_DATA_NOT_READY
+ *          - (82)      INV_ERROR_ACCEL_DATA_ERROR
+ *
+ *  @{
+ *      @file mltypes.h
+ *  @}
+ */
+
+#ifndef MLTYPES_H
+#define MLTYPES_H
+
+#include <linux/types.h>
+#include <asm-generic/errno-base.h>
+
+
+
+
+/*---------------------------
+ *    ML Defines
+ *--------------------------*/
+
+#ifndef NULL
+#define NULL 0
+#endif
+
+/* - ML Errors. - */
+#define ERROR_NAME(x)   (#x)
+#define ERROR_CHECK_FIRST(first, x)                                     \
+	{ if (INV_SUCCESS == first) first = x; }
+
+#define INV_SUCCESS                       (0)
+/* Generic Error code.  Proprietary Error Codes only */
+#define INV_ERROR_BASE                    (0x20)
+#define INV_ERROR                         (INV_ERROR_BASE)
+
+/* Compatibility and other generic error codes */
+#define INV_ERROR_INVALID_PARAMETER       (EINVAL)
+#define INV_ERROR_FEATURE_NOT_ENABLED     (EPERM)
+#define INV_ERROR_FEATURE_NOT_IMPLEMENTED (INV_ERROR_BASE + 4)
+#define INV_ERROR_DMP_NOT_STARTED         (INV_ERROR_BASE + 6)
+#define INV_ERROR_DMP_STARTED             (INV_ERROR_BASE + 7)
+#define INV_ERROR_NOT_OPENED              (INV_ERROR_BASE + 8)
+#define INV_ERROR_OPENED                  (INV_ERROR_BASE + 9)
+#define INV_ERROR_INVALID_MODULE         (ENODEV)
+#define INV_ERROR_MEMORY_EXAUSTED        (ENOMEM)
+#define INV_ERROR_DIVIDE_BY_ZERO         (INV_ERROR_BASE + 12)
+#define INV_ERROR_ASSERTION_FAILURE      (INV_ERROR_BASE + 13)
+#define INV_ERROR_FILE_OPEN              (INV_ERROR_BASE + 14)
+#define INV_ERROR_FILE_READ              (INV_ERROR_BASE + 15)
+#define INV_ERROR_FILE_WRITE             (INV_ERROR_BASE + 16)
+#define INV_ERROR_INVALID_CONFIGURATION  (INV_ERROR_BASE + 17)
+
+/* Serial Communication */
+#define INV_ERROR_SERIAL_CLOSED          (INV_ERROR_BASE + 20)
+#define INV_ERROR_SERIAL_OPEN_ERROR      (INV_ERROR_BASE + 21)
+#define INV_ERROR_SERIAL_READ            (INV_ERROR_BASE + 22)
+#define INV_ERROR_SERIAL_WRITE           (INV_ERROR_BASE + 23)
+#define INV_ERROR_SERIAL_DEVICE_NOT_RECOGNIZED  (INV_ERROR_BASE + 24)
+
+/* SM = State Machine */
+#define INV_ERROR_SM_TRANSITION          (INV_ERROR_BASE + 25)
+#define INV_ERROR_SM_IMPROPER_STATE      (INV_ERROR_BASE + 26)
+
+/* Fifo */
+#define INV_ERROR_FIFO_OVERFLOW          (INV_ERROR_BASE + 30)
+#define INV_ERROR_FIFO_FOOTER            (INV_ERROR_BASE + 31)
+#define INV_ERROR_FIFO_READ_COUNT        (INV_ERROR_BASE + 32)
+#define INV_ERROR_FIFO_READ_DATA         (INV_ERROR_BASE + 33)
+
+/* Memory & Registers, Set & Get */
+#define INV_ERROR_MEMORY_SET             (INV_ERROR_BASE + 40)
+
+#define INV_ERROR_LOG_MEMORY_ERROR       (INV_ERROR_BASE + 50)
+#define INV_ERROR_LOG_OUTPUT_ERROR       (INV_ERROR_BASE + 51)
+
+/* OS interface errors */
+#define INV_ERROR_OS_BAD_PTR             (INV_ERROR_BASE + 60)
+#define INV_ERROR_OS_BAD_HANDLE          (INV_ERROR_BASE + 61)
+#define INV_ERROR_OS_CREATE_FAILED       (INV_ERROR_BASE + 62)
+#define INV_ERROR_OS_LOCK_FAILED         (INV_ERROR_BASE + 63)
+
+/* Compass errors */
+#define INV_ERROR_COMPASS_DATA_OVERFLOW  (INV_ERROR_BASE + 70)
+#define INV_ERROR_COMPASS_DATA_UNDERFLOW (INV_ERROR_BASE + 71)
+#define INV_ERROR_COMPASS_DATA_NOT_READY (INV_ERROR_BASE + 72)
+#define INV_ERROR_COMPASS_DATA_ERROR     (INV_ERROR_BASE + 73)
+
+/* Load/Store calibration */
+#define INV_ERROR_CALIBRATION_LOAD       (INV_ERROR_BASE + 75)
+#define INV_ERROR_CALIBRATION_STORE      (INV_ERROR_BASE + 76)
+#define INV_ERROR_CALIBRATION_LEN        (INV_ERROR_BASE + 77)
+#define INV_ERROR_CALIBRATION_CHECKSUM   (INV_ERROR_BASE + 78)
+
+/* Accel errors */
+#define INV_ERROR_ACCEL_DATA_OVERFLOW    (INV_ERROR_BASE + 79)
+#define INV_ERROR_ACCEL_DATA_UNDERFLOW   (INV_ERROR_BASE + 80)
+#define INV_ERROR_ACCEL_DATA_NOT_READY   (INV_ERROR_BASE + 81)
+#define INV_ERROR_ACCEL_DATA_ERROR       (INV_ERROR_BASE + 82)
+
+#ifdef INV_USE_LEGACY_NAMES
+#define ML_SUCCESS                       INV_SUCCESS
+#define ML_ERROR                         INV_ERROR
+#define ML_ERROR_INVALID_PARAMETER       INV_ERROR_INVALID_PARAMETER
+#define ML_ERROR_FEATURE_NOT_ENABLED     INV_ERROR_FEATURE_NOT_ENABLED
+#define ML_ERROR_FEATURE_NOT_IMPLEMENTED INV_ERROR_FEATURE_NOT_IMPLEMENTED
+#define ML_ERROR_DMP_NOT_STARTED         INV_ERROR_DMP_NOT_STARTED
+#define ML_ERROR_DMP_STARTED             INV_ERROR_DMP_STARTED
+#define ML_ERROR_NOT_OPENED              INV_ERROR_NOT_OPENED
+#define ML_ERROR_OPENED                  INV_ERROR_OPENED
+#define ML_ERROR_INVALID_MODULE          INV_ERROR_INVALID_MODULE
+#define ML_ERROR_MEMORY_EXAUSTED         INV_ERROR_MEMORY_EXAUSTED
+#define ML_ERROR_DIVIDE_BY_ZERO          INV_ERROR_DIVIDE_BY_ZERO
+#define ML_ERROR_ASSERTION_FAILURE       INV_ERROR_ASSERTION_FAILURE
+#define ML_ERROR_FILE_OPEN               INV_ERROR_FILE_OPEN
+#define ML_ERROR_FILE_READ               INV_ERROR_FILE_READ
+#define ML_ERROR_FILE_WRITE              INV_ERROR_FILE_WRITE
+#define ML_ERROR_INVALID_CONFIGURATION   INV_ERROR_INVALID_CONFIGURATION
+#define ML_ERROR_SERIAL_CLOSED           INV_ERROR_SERIAL_CLOSED
+#define ML_ERROR_SERIAL_OPEN_ERROR       INV_ERROR_SERIAL_OPEN_ERROR
+#define ML_ERROR_SERIAL_READ             INV_ERROR_SERIAL_READ
+#define ML_ERROR_SERIAL_WRITE            INV_ERROR_SERIAL_WRITE
+#define ML_ERROR_SERIAL_DEVICE_NOT_RECOGNIZED  \
+	INV_ERROR_SERIAL_DEVICE_NOT_RECOGNIZED
+#define ML_ERROR_SM_TRANSITION          INV_ERROR_SM_TRANSITION
+#define ML_ERROR_SM_IMPROPER_STATE      INV_ERROR_SM_IMPROPER_STATE
+#define ML_ERROR_FIFO_OVERFLOW          INV_ERROR_FIFO_OVERFLOW
+#define ML_ERROR_FIFO_FOOTER            INV_ERROR_FIFO_FOOTER
+#define ML_ERROR_FIFO_READ_COUNT        INV_ERROR_FIFO_READ_COUNT
+#define ML_ERROR_FIFO_READ_DATA         INV_ERROR_FIFO_READ_DATA
+#define ML_ERROR_MEMORY_SET             INV_ERROR_MEMORY_SET
+#define ML_ERROR_LOG_MEMORY_ERROR       INV_ERROR_LOG_MEMORY_ERROR
+#define ML_ERROR_LOG_OUTPUT_ERROR       INV_ERROR_LOG_OUTPUT_ERROR
+#define ML_ERROR_OS_BAD_PTR             INV_ERROR_OS_BAD_PTR
+#define ML_ERROR_OS_BAD_HANDLE          INV_ERROR_OS_BAD_HANDLE
+#define ML_ERROR_OS_CREATE_FAILED       INV_ERROR_OS_CREATE_FAILED
+#define ML_ERROR_OS_LOCK_FAILED         INV_ERROR_OS_LOCK_FAILED
+#define ML_ERROR_COMPASS_DATA_OVERFLOW  INV_ERROR_COMPASS_DATA_OVERFLOW
+#define ML_ERROR_COMPASS_DATA_UNDERFLOW INV_ERROR_COMPASS_DATA_UNDERFLOW
+#define ML_ERROR_COMPASS_DATA_NOT_READY INV_ERROR_COMPASS_DATA_NOT_READY
+#define ML_ERROR_COMPASS_DATA_ERROR     INV_ERROR_COMPASS_DATA_ERROR
+#define ML_ERROR_CALIBRATION_LOAD       INV_ERROR_CALIBRATION_LOAD
+#define ML_ERROR_CALIBRATION_STORE      INV_ERROR_CALIBRATION_STORE
+#define ML_ERROR_CALIBRATION_LEN        INV_ERROR_CALIBRATION_LEN
+#define ML_ERROR_CALIBRATION_CHECKSUM   INV_ERROR_CALIBRATION_CHECKSUM
+#define ML_ERROR_ACCEL_DATA_OVERFLOW    INV_ERROR_ACCEL_DATA_OVERFLOW
+#define ML_ERROR_ACCEL_DATA_UNDERFLOW   INV_ERROR_ACCEL_DATA_UNDERFLOW
+#define ML_ERROR_ACCEL_DATA_NOT_READY   INV_ERROR_ACCEL_DATA_NOT_READY
+#define ML_ERROR_ACCEL_DATA_ERROR       INV_ERROR_ACCEL_DATA_ERROR
+#endif
+
+/* For Linux coding compliance */
+
+#endif				/* MLTYPES_H */
-- 
1.7.4.1

