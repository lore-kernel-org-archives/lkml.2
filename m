Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab2INRtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:49:15 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:10485 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2INRtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:49:05 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Kevin McNeely <kev@cypress.com>, Phil Warkentin <pwar@cypress.com>,
        Ferruh Yigit <fery@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] Input: cyttsp4 - core driver for Cypress TMA4XX touchscreen devices
Date: Fri, 14 Sep 2012 20:48:35 +0300
Message-ID: <1347644917-13269-2-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347644917-13269-1-git-send-email-fery@cypress.com>
References: <Ferruh Yigit <fery@cypress.com>
 <1347644917-13269-1-git-send-email-fery@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers, Generation4
devices, Core driver.

Core module has two main functionality:
1- Interface between Host and TTSP controller
2- Process data sent by controller and send MT events to OS

This Core module support Multi Touch protocol Type B

Responsible from IRQ handling, reading system information registers
and sending multi touch events to Linux

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Kconfig        |   33 +
 drivers/input/touchscreen/Makefile       |    8 +
 drivers/input/touchscreen/cyttsp4_core.c | 2308 ++++++++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp4_core.h |  525 +++++++
 include/linux/input/cyttsp4.h            |  126 ++
 5 files changed, 3000 insertions(+)
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.h
 create mode 100644 include/linux/input/cyttsp4.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1ba232c..d6ebd4c 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -179,6 +179,39 @@ config TOUCHSCREEN_CYTTSP_SPI
          To compile this driver as a module, choose M here: the
          module will be called cyttsp_spi.

+config TOUCHSCREEN_CYPRESS_CYTTSP4
+       tristate "Cypress TrueTouch Gen4 Touchscreen Driver"
+       default n
+       help
+         Core driver for Cypress TrueTouch(tm) Standard Product
+         Generation4 touchscreen controllers.
+
+         Say Y here if you have a Cypress Gen4 touchscreen.
+
+         If unsure, say N.
+
+         To compile this driver as a module, choose M here.
+
+config TOUCHSCREEN_CYPRESS_CYTTSP4_DEBUG
+       bool "Enable debug output"
+       depends on TOUCHSCREEN_CYPRESS_CYTTSP4
+       default n
+       help
+         Enable Debug output for Cypress TrueTouch(tm)
+         Standard Product Generation4 driver set.
+
+         Say Y here to enable debug output.
+
+config TOUCHSCREEN_CYPRESS_CYTTSP4_VDEBUG
+       bool "Enable verbose debug output"
+       depends on TOUCHSCREEN_CYPRESS_CYTTSP4_DEBUG
+       default n
+       help
+         Enable Verbose Debug output for Cypress TrueTouch(tm)
+         Standard Product Generation4 driver set.
+
+         Say Y here to enable verbose debug output.
+
 config TOUCHSCREEN_DA9034
        tristate "Touchscreen support for Dialog Semiconductor DA9034"
        depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 178eb12..1cdab28 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -73,3 +73,11 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)   += mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)      += zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)      += w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)     += tps6507x-ts.o
+obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4)      += cyttsp4_core.o
+ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_DEBUG),y)
+CFLAGS_cyttsp4_core.o += -DDEBUG
+endif
+
+ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_VDEBUG),y)
+CFLAGS_cyttsp4_core.o += -DVERBOSE_DEBUG
+endif
diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
new file mode 100644
index 0000000..2ec7223
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -0,0 +1,2308 @@
+/*
+ * cyttsp4_core.c
+ * Cypress TrueTouch(TM) Standard Product V4 Core driver module.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2012 Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#include <linux/input/cyttsp4.h>
+#include "cyttsp4_core.h"
+
+#define CY_CORE_MODE_CHANGE_TIMEOUT            1000
+#define CY_CORE_RESET_AND_WAIT_TIMEOUT         500
+#define CY_CORE_WAKEUP_TIMEOUT                 500
+
+MODULE_FIRMWARE(CY_FW_FILE_NAME);
+
+const char *cy_driver_core_name = CYTTSP4_CORE_NAME;
+const char *cy_driver_core_version = CY_DRIVER_VERSION;
+const char *cy_driver_core_date = CY_DRIVER_DATE;
+
+static inline size_t merge_bytes(u8 high, u8 low)
+{
+       return (high << 8) + low;
+}
+
+static inline int cyttsp4_bits_2_bytes(int nbits, int *max)
+{
+       *max = 1 << nbits;
+       return (nbits + 7) / 8;
+}
+
+static inline int cyttsp4_read(struct cyttsp4_core_data *cd,
+                u8 addr, void *buf, int size)
+{
+       return cd->ops->read(cd->dev, addr, buf, size);
+}
+
+static inline int cyttsp4_write(struct cyttsp4_core_data *cd,
+               u8 addr, const void *buf, int size)
+{
+       return cd->ops->write(cd->dev, addr, buf, size);
+}
+
+#ifdef VERBOSE_DEBUG
+void cyttsp4_pr_buf(struct device *dev, u8 *pr_buf, u8 *dptr, int size,
+               const char *data_name)
+{
+       int i, k;
+       const char fmt[] = "%02X ";
+       int max = (CY_MAX_PRBUF_SIZE - 1) - sizeof(CY_PR_TRUNCATED);
+
+       pr_buf[0] = 0;
+       for (i = k = 0; i < size && k < max; i++, k += 3)
+               scnprintf(pr_buf + k, CY_MAX_PRBUF_SIZE, fmt, dptr[i]);
+
+       dev_vdbg(dev, "%s:  %s[0..%d]=%s%s\n", __func__, data_name, size - 1,
+                       pr_buf, size <= max ? "" : CY_PR_TRUNCATED);
+}
+EXPORT_SYMBOL(cyttsp4_pr_buf);
+#endif
+
+static int cyttsp4_xres(struct cyttsp4_core_platform_data *pdata,
+               struct device *dev)
+{
+       int rst_gpio = pdata->rst_gpio;
+       int rc = 0;
+
+       gpio_set_value(rst_gpio, 1);
+       msleep(20);
+       gpio_set_value(rst_gpio, 0);
+       msleep(40);
+       gpio_set_value(rst_gpio, 1);
+       msleep(20);
+       dev_info(dev,
+               "%s: RESET CYTTSP gpio=%d r=%d\n", __func__,
+               pdata->rst_gpio, rc);
+       return rc;
+}
+
+static int cyttsp4_init(struct cyttsp4_core_platform_data *pdata,
+               struct device *dev)
+{
+       int rst_gpio = pdata->rst_gpio;
+       int irq_gpio = pdata->irq_gpio;
+       int rc;
+
+       rc = gpio_request(rst_gpio, NULL);
+       if (rc < 0) {
+               gpio_free(rst_gpio);
+               /* Try once more */
+               rc = gpio_request(rst_gpio, NULL);
+       }
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail request gpio=%d\n", __func__, rst_gpio);
+               goto error;
+       }
+
+       rc = gpio_direction_output(rst_gpio, 1);
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail set output gpio=%d\n", __func__,
+                       rst_gpio);
+               goto error_free_rst_gpio;
+       }
+
+       rc = gpio_request(irq_gpio, NULL);
+       if (rc < 0) {
+               gpio_free(irq_gpio);
+               /* Try once more */
+               rc = gpio_request(irq_gpio, NULL);
+       }
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail request gpio=%d\n", __func__, irq_gpio);
+               goto error_free_rst_gpio;
+       }
+
+       rc = gpio_direction_input(irq_gpio);
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail set input gpio=%d\n", __func__,
+                       irq_gpio);
+               goto error_free_irq_gpio;
+       }
+
+       dev_info(dev, "%s: INIT CYTTSP RST gpio=%d and IRQ gpio=%d\n",
+               __func__, rst_gpio, irq_gpio);
+       return 0;
+
+error_free_irq_gpio:
+       gpio_free(irq_gpio);
+error_free_rst_gpio:
+       gpio_free(rst_gpio);
+error:
+       return rc;
+}
+
+static void cyttsp4_exit(struct cyttsp4_core_platform_data *pdata,
+               struct device *dev)
+{
+       int rst_gpio = pdata->rst_gpio;
+       int irq_gpio = pdata->irq_gpio;
+
+       gpio_free(rst_gpio);
+       gpio_free(irq_gpio);
+
+       dev_info(dev, "%s: EXIT CYTTSP RST gpio=%d and IRQ gpio=%d\n",
+               __func__, rst_gpio, irq_gpio);
+}
+
+static int cyttsp4_irq_stat(struct cyttsp4_core_platform_data *pdata,
+               struct device *dev)
+{
+       return gpio_get_value(pdata->irq_gpio);
+}
+
+static int cyttsp4_wakeup(struct cyttsp4_core_data *cd)
+{
+       atomic_t *ignore_irq = &cd->ignore_irq;
+       int irq_gpio = cd->pdata->irq_gpio;
+       struct device *dev = cd->dev;
+       int rc = 0;
+
+       atomic_set(ignore_irq, 1);
+       rc = gpio_direction_output(irq_gpio, 0);
+       if (rc < 0) {
+               atomic_set(ignore_irq, 0);
+               dev_err(dev,
+                       "%s: Fail set output gpio=%d\n",
+                       __func__, irq_gpio);
+       } else {
+               udelay(2000);
+               rc = gpio_direction_input(irq_gpio);
+               atomic_set(ignore_irq, 0);
+               if (rc < 0) {
+                       dev_err(dev,
+                               "%s: Fail set input gpio=%d\n",
+                               __func__, irq_gpio);
+               }
+       }
+
+       dev_info(dev,
+               "%s: WAKEUP CYTTSP gpio=%d r=%d\n", __func__,
+               irq_gpio, rc);
+       return rc;
+}
+
+static int cyttsp4_load_status_regs(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       struct device *dev = cd->dev;
+       int rc;
+
+       if (!si->xy_mode) {
+               dev_err(cd->dev, "%s: NULL xy_mode pointer\n", __func__);
+               return -EINVAL;
+       }
+
+       rc = cyttsp4_read(cd, CY_REG_BASE, si->xy_mode, si->si_ofs.mode_size);
+       if (rc < 0)
+               dev_err(dev, "%s: fail read mode regs r=%d\n",
+                       __func__, rc);
+       else
+               cyttsp4_pr_buf(dev, cd->pr_buf, si->xy_mode,
+                       si->si_ofs.mode_size, "xy_mode");
+
+       return rc;
+}
+
+static int cyttsp4_handshake(struct cyttsp4_core_data *cd, u8 mode)
+{
+       u8 cmd = mode ^ CY_HST_TOGGLE;
+       int rc = cyttsp4_write(cd, CY_REG_BASE, &cmd, sizeof(cmd));
+
+       if (rc < 0)
+               dev_err(cd->dev, "%s: bus write fail on handshake (ret=%d)\n",
+                               __func__, rc);
+
+       return rc;
+}
+
+static int cyttsp4_hw_soft_reset(struct cyttsp4_core_data *cd)
+{
+       u8 cmd = CY_HST_RESET | CY_HST_MODE_CHANGE;
+       int rc = cyttsp4_write(cd, CY_REG_BASE, &cmd, sizeof(cmd));
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: FAILED to execute SOFT reset\n",
+                               __func__);
+               return rc;
+       }
+       dev_dbg(cd->dev, "%s: execute SOFT reset\n", __func__);
+       return 0;
+}
+
+static int cyttsp4_hw_hard_reset(struct cyttsp4_core_data *cd)
+{
+       dev_dbg(cd->dev, "%s: execute HARD reset\n", __func__);
+       return cyttsp4_xres(cd->pdata, cd->dev);
+}
+
+static int cyttsp4_hw_reset(struct cyttsp4_core_data *cd)
+{
+       int rc = cyttsp4_hw_hard_reset(cd);
+       if (rc == -ENOSYS)
+               rc = cyttsp4_hw_soft_reset(cd);
+       return rc;
+}
+
+static int cyttsp4_si_data_offsets(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc = cyttsp4_read(cd, CY_REG_BASE, &si->si_data,
+                       sizeof(si->si_data));
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: fail read sysinfo data offsets r=%d\n",
+                       __func__, rc);
+               return rc;
+       }
+
+       /* Print sysinfo data offsets */
+       cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)&si->si_data,
+               sizeof(si->si_data), "sysinfo_data_offsets");
+
+       /* convert sysinfo data offset bytes into integers */
+
+       si->si_ofs.map_sz = merge_bytes(si->si_data.map_szh,
+                       si->si_data.map_szl);
+       si->si_ofs.cydata_ofs = merge_bytes(si->si_data.cydata_ofsh,
+                       si->si_data.cydata_ofsl);
+       si->si_ofs.test_ofs = merge_bytes(si->si_data.test_ofsh,
+                       si->si_data.test_ofsl);
+       si->si_ofs.pcfg_ofs = merge_bytes(si->si_data.pcfg_ofsh,
+                       si->si_data.pcfg_ofsl);
+       si->si_ofs.opcfg_ofs = merge_bytes(si->si_data.opcfg_ofsh,
+                       si->si_data.opcfg_ofsl);
+       si->si_ofs.ddata_ofs = merge_bytes(si->si_data.ddata_ofsh,
+                       si->si_data.ddata_ofsl);
+       si->si_ofs.mdata_ofs = merge_bytes(si->si_data.mdata_ofsh,
+                       si->si_data.mdata_ofsl);
+       return rc;
+}
+
+static int cyttsp4_si_get_cydata(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       si->si_ofs.cydata_size = si->si_ofs.test_ofs - si->si_ofs.cydata_ofs;
+       if (si->si_ptrs.cydata == NULL)
+               si->si_ptrs.cydata = kzalloc(si->si_ofs.cydata_size,
+                       GFP_KERNEL);
+       if (si->si_ptrs.cydata == NULL) {
+               dev_err(cd->dev, "%s: fail alloc cydata memory\n", __func__);
+               return -ENOMEM;
+       }
+
+       rc = cyttsp4_read(cd, si->si_ofs.cydata_ofs, si->si_ptrs.cydata,
+                       si->si_ofs.cydata_size);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: fail read cydata r=%d\n",
+                       __func__, rc);
+       else
+               cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.cydata,
+                       si->si_ofs.cydata_size, "sysinfo_cydata");
+       return rc;
+}
+
+static int cyttsp4_si_get_test_data(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       si->si_ofs.test_size = si->si_ofs.pcfg_ofs - si->si_ofs.test_ofs;
+       if (si->si_ptrs.test == NULL)
+               si->si_ptrs.test = kzalloc(si->si_ofs.test_size, GFP_KERNEL);
+       if (si->si_ptrs.test == NULL) {
+               dev_err(cd->dev, "%s: fail alloc test memory\n", __func__);
+               return -ENOMEM;
+       }
+
+       rc = cyttsp4_read(cd, si->si_ofs.test_ofs, si->si_ptrs.test,
+                       si->si_ofs.test_size);
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: fail read test data r=%d\n",
+                       __func__, rc);
+               return rc;
+       }
+
+       cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.test,
+               si->si_ofs.test_size, "sysinfo_test_data");
+
+       if (si->si_ptrs.test->post_codel &
+           CY_POST_CODEL_WDG_RST)
+               dev_info(cd->dev, "%s: %s codel=%02X\n",
+                        __func__, "Reset was a WATCHDOG RESET",
+                        si->si_ptrs.test->post_codel);
+
+       if (!(si->si_ptrs.test->post_codel &
+             CY_POST_CODEL_CFG_DATA_CRC_FAIL))
+               dev_info(cd->dev, "%s: %s codel=%02X\n", __func__,
+                        "Config Data CRC FAIL",
+                        si->si_ptrs.test->post_codel);
+
+       if (!(si->si_ptrs.test->post_codel &
+             CY_POST_CODEL_PANEL_TEST_FAIL))
+               dev_info(cd->dev, "%s: %s codel=%02X\n",
+                        __func__, "PANEL TEST FAIL",
+                        si->si_ptrs.test->post_codel);
+
+       dev_info(cd->dev, "%s: SCANNING is %s codel=%02X\n",
+                __func__, si->si_ptrs.test->post_codel & 0x08 ?
+                "ENABLED" : "DISABLED",
+                si->si_ptrs.test->post_codel);
+       return rc;
+}
+
+static int cyttsp4_si_get_pcfg_data(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       dev_vdbg(cd->dev, "%s: get pcfg data\n", __func__);
+       si->si_ofs.pcfg_size = si->si_ofs.opcfg_ofs - si->si_ofs.pcfg_ofs;
+       if (si->si_ptrs.pcfg == NULL)
+               si->si_ptrs.pcfg = kzalloc(si->si_ofs.pcfg_size, GFP_KERNEL);
+       if (si->si_ptrs.pcfg == NULL) {
+               rc = -ENOMEM;
+               dev_err(cd->dev, "%s: fail alloc pcfg memory r=%d\n",
+                       __func__, rc);
+               return rc;
+       }
+       rc = cyttsp4_read(cd, si->si_ofs.pcfg_ofs, si->si_ptrs.pcfg,
+                       si->si_ofs.pcfg_size);
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: fail read pcfg data r=%d\n",
+                       __func__, rc);
+               return rc;
+       }
+
+       si->si_ofs.max_x = merge_bytes((si->si_ptrs.pcfg->res_xh
+                       & CY_PCFG_RESOLUTION_X_MASK), si->si_ptrs.pcfg->res_xl);
+       si->si_ofs.x_origin = !!(si->si_ptrs.pcfg->res_xh
+                       & CY_PCFG_ORIGIN_X_MASK);
+       si->si_ofs.max_y = merge_bytes((si->si_ptrs.pcfg->res_yh
+                       & CY_PCFG_RESOLUTION_Y_MASK), si->si_ptrs.pcfg->res_yl);
+       si->si_ofs.y_origin = !!(si->si_ptrs.pcfg->res_yh
+                       & CY_PCFG_ORIGIN_Y_MASK);
+       si->si_ofs.max_p = merge_bytes(si->si_ptrs.pcfg->max_zh,
+                       si->si_ptrs.pcfg->max_zl);
+
+       cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.pcfg,
+               si->si_ofs.pcfg_size, "sysinfo_pcfg_data");
+
+       return rc;
+}
+
+static int cyttsp4_si_get_opcfg_data(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int i;
+       enum cyttsp4_tch_abs abs;
+       int rc;
+
+       dev_vdbg(cd->dev, "%s: get opcfg data\n", __func__);
+       si->si_ofs.opcfg_size = si->si_ofs.ddata_ofs - si->si_ofs.opcfg_ofs;
+       if (si->si_ptrs.opcfg == NULL)
+               si->si_ptrs.opcfg = kzalloc(si->si_ofs.opcfg_size, GFP_KERNEL);
+       if (si->si_ptrs.opcfg == NULL) {
+               dev_err(cd->dev, "%s: fail alloc opcfg memory\n", __func__);
+               rc = -ENOMEM;
+               goto cyttsp4_si_get_opcfg_data_exit;
+       }
+
+       rc = cyttsp4_read(cd, si->si_ofs.opcfg_ofs, si->si_ptrs.opcfg,
+                       si->si_ofs.opcfg_size);
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: fail read opcfg data r=%d\n",
+                       __func__, rc);
+               goto cyttsp4_si_get_opcfg_data_exit;
+       }
+       si->si_ofs.cmd_ofs = si->si_ptrs.opcfg->cmd_ofs;
+       si->si_ofs.rep_ofs = si->si_ptrs.opcfg->rep_ofs;
+       si->si_ofs.rep_sz = (si->si_ptrs.opcfg->rep_szh * 256) +
+               si->si_ptrs.opcfg->rep_szl;
+       si->si_ofs.num_btns = si->si_ptrs.opcfg->num_btns;
+       si->si_ofs.num_btn_regs = (si->si_ofs.num_btns +
+               CY_NUM_BTN_PER_REG - 1) / CY_NUM_BTN_PER_REG;
+       si->si_ofs.tt_stat_ofs = si->si_ptrs.opcfg->tt_stat_ofs;
+       si->si_ofs.obj_cfg0 = si->si_ptrs.opcfg->obj_cfg0;
+       si->si_ofs.max_tchs = si->si_ptrs.opcfg->max_tchs &
+               CY_BYTE_OFS_MASK;
+       si->si_ofs.tch_rec_size = si->si_ptrs.opcfg->tch_rec_size &
+               CY_BYTE_OFS_MASK;
+
+       /* Get the old touch fields */
+       for (abs = CY_TCH_X; abs < CY_NUM_TCH_FIELDS; abs++) {
+               si->si_ofs.tch_abs[abs].ofs =
+                       si->si_ptrs.opcfg->tch_rec_old[abs].loc &
+                       CY_BYTE_OFS_MASK;
+               si->si_ofs.tch_abs[abs].size =
+                       cyttsp4_bits_2_bytes
+                       (si->si_ptrs.opcfg->tch_rec_old[abs].size,
+                       &si->si_ofs.tch_abs[abs].max);
+               si->si_ofs.tch_abs[abs].bofs =
+                       (si->si_ptrs.opcfg->tch_rec_old[abs].loc &
+                       CY_BOFS_MASK) >> CY_BOFS_SHIFT;
+       }
+
+       /* button fields */
+       si->si_ofs.btn_rec_size = si->si_ptrs.opcfg->btn_rec_size;
+       si->si_ofs.btn_diff_ofs = si->si_ptrs.opcfg->btn_diff_ofs;
+       si->si_ofs.btn_diff_size = si->si_ptrs.opcfg->btn_diff_size;
+
+       if (si->si_ofs.tch_rec_size > CY_TMA1036_TCH_REC_SIZE) {
+               /* Get the extended touch fields */
+               for (i = 0; i < CY_NUM_EXT_TCH_FIELDS; abs++, i++) {
+                       si->si_ofs.tch_abs[abs].ofs =
+                               si->si_ptrs.opcfg->tch_rec_new[i].loc &
+                               CY_BYTE_OFS_MASK;
+                       si->si_ofs.tch_abs[abs].size =
+                               cyttsp4_bits_2_bytes
+                               (si->si_ptrs.opcfg->tch_rec_new[i].size,
+                               &si->si_ofs.tch_abs[abs].max);
+                       si->si_ofs.tch_abs[abs].bofs =
+                               (si->si_ptrs.opcfg->tch_rec_new[i].loc
+                               & CY_BOFS_MASK) >> CY_BOFS_SHIFT;
+               }
+       }
+
+       for (abs = 0; abs < CY_TCH_NUM_ABS; abs++) {
+               dev_dbg(cd->dev, "%s: tch_rec_%s\n", __func__,
+                       cyttsp4_tch_abs_string[abs]);
+               dev_dbg(cd->dev, "%s:     ofs =%2d\n", __func__,
+                       si->si_ofs.tch_abs[abs].ofs);
+               dev_dbg(cd->dev, "%s:     siz =%2d\n", __func__,
+                       si->si_ofs.tch_abs[abs].size);
+               dev_dbg(cd->dev, "%s:     max =%2d\n", __func__,
+                       si->si_ofs.tch_abs[abs].max);
+               dev_dbg(cd->dev, "%s:     bofs=%2d\n", __func__,
+                       si->si_ofs.tch_abs[abs].bofs);
+       }
+
+       si->si_ofs.mode_size = si->si_ofs.tt_stat_ofs + 1;
+       si->si_ofs.data_size = si->si_ofs.max_tchs *
+               si->si_ptrs.opcfg->tch_rec_size;
+
+       cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.opcfg,
+               si->si_ofs.opcfg_size, "sysinfo_opcfg_data");
+
+cyttsp4_si_get_opcfg_data_exit:
+       return rc;
+}
+
+static int cyttsp4_si_get_ddata(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       dev_vdbg(cd->dev, "%s: get ddata data\n", __func__);
+       si->si_ofs.ddata_size = si->si_ofs.mdata_ofs - si->si_ofs.ddata_ofs;
+       if (si->si_ptrs.ddata == NULL)
+               si->si_ptrs.ddata = kzalloc(si->si_ofs.ddata_size, GFP_KERNEL);
+       if (si->si_ptrs.ddata == NULL) {
+               dev_err(cd->dev, "%s: fail alloc ddata memory\n", __func__);
+               return -ENOMEM;
+       }
+
+       rc = cyttsp4_read(cd, si->si_ofs.ddata_ofs, si->si_ptrs.ddata,
+                       si->si_ofs.ddata_size);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: fail read ddata data r=%d\n",
+                       __func__, rc);
+       else
+               cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.ddata,
+                       si->si_ofs.ddata_size, "sysinfo_ddata");
+
+       return rc;
+}
+
+static int cyttsp4_si_get_mdata(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       dev_vdbg(cd->dev, "%s: get mdata data\n", __func__);
+       si->si_ofs.mdata_size = si->si_ofs.map_sz - si->si_ofs.mdata_ofs;
+       if (si->si_ptrs.mdata == NULL)
+               si->si_ptrs.mdata = kzalloc(si->si_ofs.mdata_size, GFP_KERNEL);
+       if (si->si_ptrs.mdata == NULL) {
+               dev_err(cd->dev, "%s: fail alloc mdata memory\n", __func__);
+               return -ENOMEM;
+       }
+
+       rc = cyttsp4_read(cd, si->si_ofs.mdata_ofs, si->si_ptrs.mdata,
+                       si->si_ofs.mdata_size);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: fail read mdata data r=%d\n",
+                       __func__, rc);
+       else
+               cyttsp4_pr_buf(cd->dev, cd->pr_buf, (u8 *)si->si_ptrs.mdata,
+                       si->si_ofs.mdata_size, "sysinfo_mdata");
+
+       return rc;
+}
+
+static int cyttsp4_si_get_btn_data(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int btn;
+       int num_defined_keys;
+       u16 *key_table;
+       int rc = 0;
+
+       dev_vdbg(cd->dev, "%s: get btn data\n", __func__);
+       if (si->si_ofs.num_btns) {
+               si->si_ofs.btn_keys_size = si->si_ofs.num_btns *
+                       sizeof(struct cyttsp4_btn);
+               if (si->btn == NULL)
+                       si->btn = kzalloc(si->si_ofs.btn_keys_size, GFP_KERNEL);
+               if (si->btn == NULL) {
+                       dev_err(cd->dev, "%s: %s\n", __func__,
+                               "fail alloc btn_keys memory");
+                       return -ENOMEM;
+               }
+               if (cd->pdata->sett[CY_IC_GRPNUM_BTN_KEYS] == NULL)
+                       num_defined_keys = 0;
+               else if (cd->pdata->sett[CY_IC_GRPNUM_BTN_KEYS]->data == NULL)
+                       num_defined_keys = 0;
+               else
+                       num_defined_keys = cd->pdata->sett
+                               [CY_IC_GRPNUM_BTN_KEYS]->size;
+
+               for (btn = 0; btn < si->si_ofs.num_btns &&
+                       btn < num_defined_keys; btn++) {
+                       key_table = (u16 *)cd->pdata->sett
+                               [CY_IC_GRPNUM_BTN_KEYS]->data;
+                       si->btn[btn].key_code = key_table[btn];
+                       si->btn[btn].enabled = true;
+               }
+               for (; btn < si->si_ofs.num_btns; btn++) {
+                       si->btn[btn].key_code = KEY_RESERVED;
+                       si->btn[btn].enabled = true;
+               }
+
+               return rc;
+       }
+
+       si->si_ofs.btn_keys_size = 0;
+       kfree(si->btn);
+       si->btn = NULL;
+       return rc;
+}
+
+static int cyttsp4_si_get_op_data_ptrs(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       if (si->xy_mode == NULL) {
+               si->xy_mode = kzalloc(si->si_ofs.mode_size, GFP_KERNEL);
+               if (si->xy_mode == NULL)
+                       return -ENOMEM;
+       }
+
+       if (si->xy_data == NULL) {
+               si->xy_data = kzalloc(si->si_ofs.data_size, GFP_KERNEL);
+               if (si->xy_data == NULL)
+                       return -ENOMEM;
+       }
+
+       if (si->btn_rec_data == NULL) {
+               si->btn_rec_data = kzalloc(si->si_ofs.btn_rec_size *
+                                          si->si_ofs.num_btns, GFP_KERNEL);
+               if (si->btn_rec_data == NULL)
+                       return -ENOMEM;
+       }
+       return 0;
+}
+
+static void cyttsp4_si_put_log_data(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       dev_dbg(cd->dev, "%s: cydata_ofs =%4d siz=%4d\n", __func__,
+               si->si_ofs.cydata_ofs, si->si_ofs.cydata_size);
+       dev_dbg(cd->dev, "%s: test_ofs   =%4d siz=%4d\n", __func__,
+               si->si_ofs.test_ofs, si->si_ofs.test_size);
+       dev_dbg(cd->dev, "%s: pcfg_ofs   =%4d siz=%4d\n", __func__,
+               si->si_ofs.pcfg_ofs, si->si_ofs.pcfg_size);
+       dev_dbg(cd->dev, "%s: opcfg_ofs  =%4d siz=%4d\n", __func__,
+               si->si_ofs.opcfg_ofs, si->si_ofs.opcfg_size);
+       dev_dbg(cd->dev, "%s: ddata_ofs  =%4d siz=%4d\n", __func__,
+               si->si_ofs.ddata_ofs, si->si_ofs.ddata_size);
+       dev_dbg(cd->dev, "%s: mdata_ofs  =%4d siz=%4d\n", __func__,
+               si->si_ofs.mdata_ofs, si->si_ofs.mdata_size);
+
+       dev_dbg(cd->dev, "%s: cmd_ofs       =%4d\n", __func__,
+               si->si_ofs.cmd_ofs);
+       dev_dbg(cd->dev, "%s: rep_ofs       =%4d\n", __func__,
+               si->si_ofs.rep_ofs);
+       dev_dbg(cd->dev, "%s: rep_sz        =%4d\n", __func__,
+               si->si_ofs.rep_sz);
+       dev_dbg(cd->dev, "%s: num_btns      =%4d\n", __func__,
+               si->si_ofs.num_btns);
+       dev_dbg(cd->dev, "%s: num_btn_regs  =%4d\n", __func__,
+               si->si_ofs.num_btn_regs);
+       dev_dbg(cd->dev, "%s: tt_stat_ofs   =%4d\n", __func__,
+               si->si_ofs.tt_stat_ofs);
+       dev_dbg(cd->dev, "%s: tch_rec_size   =%4d\n", __func__,
+               si->si_ofs.tch_rec_size);
+       dev_dbg(cd->dev, "%s: max_tchs      =%4d\n", __func__,
+               si->si_ofs.max_tchs);
+       dev_dbg(cd->dev, "%s: mode_size     =%4d\n", __func__,
+               si->si_ofs.mode_size);
+       dev_dbg(cd->dev, "%s: data_size     =%4d\n", __func__,
+               si->si_ofs.data_size);
+       dev_dbg(cd->dev, "%s: map_sz        =%4d\n", __func__,
+               si->si_ofs.map_sz);
+
+       dev_dbg(cd->dev, "%s: btn_rec_size   =%2d\n", __func__,
+               si->si_ofs.btn_rec_size);
+       dev_dbg(cd->dev, "%s: btn_diff_ofs  =%2d\n", __func__,
+               si->si_ofs.btn_diff_ofs);
+       dev_dbg(cd->dev, "%s: btn_diff_size  =%2d\n", __func__,
+               si->si_ofs.btn_diff_size);
+
+       dev_dbg(cd->dev, "%s: max_x    = 0x%04X (%d)\n", __func__,
+               si->si_ofs.max_x, si->si_ofs.max_x);
+       dev_dbg(cd->dev, "%s: x_origin = %d (%s)\n", __func__,
+               si->si_ofs.x_origin,
+               si->si_ofs.x_origin == CY_NORMAL_ORIGIN ?
+               "left corner" : "right corner");
+       dev_dbg(cd->dev, "%s: max_y    = 0x%04X (%d)\n", __func__,
+               si->si_ofs.max_y, si->si_ofs.max_y);
+       dev_dbg(cd->dev, "%s: y_origin = %d (%s)\n", __func__,
+               si->si_ofs.y_origin,
+               si->si_ofs.y_origin == CY_NORMAL_ORIGIN ?
+               "upper corner" : "lower corner");
+       dev_dbg(cd->dev, "%s: max_p    = 0x%04X (%d)\n", __func__,
+               si->si_ofs.max_p, si->si_ofs.max_p);
+
+       dev_dbg(cd->dev, "%s: xy_mode=%p xy_data=%p\n", __func__,
+               si->xy_mode, si->xy_data);
+}
+
+static int cyttsp4_get_sysinfo_regs(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+       int rc;
+
+       rc = cyttsp4_si_data_offsets(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_cydata(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_test_data(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_pcfg_data(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_opcfg_data(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_ddata(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_mdata(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_btn_data(cd);
+       if (rc < 0)
+               return rc;
+
+       rc = cyttsp4_si_get_op_data_ptrs(cd);
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: failed to get_op_data\n",
+                       __func__);
+               return rc;
+       }
+       cyttsp4_si_put_log_data(cd);
+
+       /* provide flow control handshake */
+       rc = cyttsp4_handshake(cd, si->si_data.hst_mode);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: handshake fail on sysinfo reg\n",
+                       __func__);
+
+       si->ready = true;
+       return rc;
+}
+
+static void cyttsp4_queue_startup(struct cyttsp4_core_data *cd)
+{
+       queue_work(cd->startup_work_q, &cd->startup_work);
+       dev_info(cd->dev, "%s: cyttsp4_startup queued\n", __func__);
+}
+
+static void cyttsp4_lift_all(struct cyttsp4_mt_data *md)
+{
+       struct cyttsp4_sysinfo *si = md->si;
+       int t;
+
+       if (md->num_prv_tch == 0)
+               return;
+
+       for (t = 0; t < si->si_ofs.max_tchs + 1; t++) {
+               input_mt_slot(md->input, t);
+               input_mt_report_slot_state(md->input,
+                       MT_TOOL_FINGER, false);
+       }
+
+       /* Lift off button release signal and empty mt */
+       if (md->prv_tch_type != CY_OBJ_HOVER)
+               input_report_key(md->input, BTN_TOUCH, CY_BTN_RELEASED);
+       input_sync(md->input);
+       md->num_prv_tch = 0;
+}
+
+static void cyttsp4_get_touch_axis(struct cyttsp4_mt_data *md,
+       int *axis, int size, int max, u8 *xy_data, int bofs)
+{
+       int nbyte;
+       int next;
+
+       for (nbyte = 0, *axis = 0, next = 0; nbyte < size; nbyte++) {
+               dev_vdbg(&md->input->dev,
+                       "%s: *axis=%02X(%d) size=%d max=%08X xy_data=%p"
+                       " xy_data[%d]=%02X(%d) bofs=%d\n",
+                       __func__, *axis, *axis, size, max, xy_data, next,
+                       xy_data[next], xy_data[next], bofs);
+               *axis = (*axis * 256) + (xy_data[next] >> bofs);
+               next++;
+       }
+
+       *axis &= max - 1;
+
+       dev_vdbg(&md->input->dev,
+               "%s: *axis=%02X(%d) size=%d max=%08X xy_data=%p"
+               " xy_data[%d]=%02X(%d)\n",
+               __func__, *axis, *axis, size, max, xy_data, next,
+               xy_data[next], xy_data[next]);
+}
+
+static void cyttsp4_get_touch(struct cyttsp4_mt_data *md,
+       struct cyttsp4_touch *touch, u8 *xy_data)
+{
+       struct device *dev = &md->input->dev;
+       struct cyttsp4_sysinfo *si = md->si;
+       enum cyttsp4_tch_abs abs;
+       int tmp;
+       bool flipped;
+
+       for (abs = CY_TCH_X; abs < CY_TCH_NUM_ABS; abs++) {
+               cyttsp4_get_touch_axis(md, &touch->abs[abs],
+                       si->si_ofs.tch_abs[abs].size,
+                       si->si_ofs.tch_abs[abs].max,
+                       xy_data + si->si_ofs.tch_abs[abs].ofs,
+                       si->si_ofs.tch_abs[abs].bofs);
+               dev_vdbg(dev, "%s: get %s=%04X(%d)\n", __func__,
+                       cyttsp4_tch_abs_string[abs],
+                       touch->abs[abs], touch->abs[abs]);
+       }
+
+       if (md->pdata->flags & CY_FLAG_FLIP) {
+               tmp = touch->abs[CY_TCH_X];
+               touch->abs[CY_TCH_X] = touch->abs[CY_TCH_Y];
+               touch->abs[CY_TCH_Y] = tmp;
+               flipped = true;
+       } else
+               flipped = false;
+
+       if (md->pdata->flags & CY_FLAG_INV_X) {
+               if (flipped)
+                       touch->abs[CY_TCH_X] = md->si->si_ofs.max_y -
+                               touch->abs[CY_TCH_X];
+               else
+                       touch->abs[CY_TCH_X] = md->si->si_ofs.max_x -
+                               touch->abs[CY_TCH_X];
+       }
+       if (md->pdata->flags & CY_FLAG_INV_Y) {
+               if (flipped)
+                       touch->abs[CY_TCH_Y] = md->si->si_ofs.max_x -
+                               touch->abs[CY_TCH_Y];
+               else
+                       touch->abs[CY_TCH_Y] = md->si->si_ofs.max_y -
+                               touch->abs[CY_TCH_Y];
+       }
+
+       dev_vdbg(dev, "%s: flip=%s inv-x=%s inv-y=%s x=%04X(%d) y=%04X(%d)\n",
+               __func__, flipped ? "true" : "false",
+               md->pdata->flags & CY_FLAG_INV_X ? "true" : "false",
+               md->pdata->flags & CY_FLAG_INV_Y ? "true" : "false",
+               touch->abs[CY_TCH_X], touch->abs[CY_TCH_X],
+               touch->abs[CY_TCH_Y], touch->abs[CY_TCH_Y]);
+}
+
+static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
+{
+       struct device *dev = &md->input->dev;
+       struct cyttsp4_sysinfo *si = md->si;
+       struct cyttsp4_touch tch;
+       int sig;
+       int i, j, t = 0;
+       int ids[max(CY_TMA1036_MAX_TCH + 1,
+               CY_TMA4XX_MAX_TCH + 1)]; /* add one for hover */
+       int mt_sync_count = 0;
+
+       memset(ids, 0, (si->si_ofs.max_tchs + 1) * sizeof(int));
+       memset(&tch, 0, sizeof(struct cyttsp4_touch));
+       for (i = 0; i < num_cur_tch; i++) {
+               cyttsp4_get_touch(md, &tch, si->xy_data +
+                       (i * si->si_ofs.tch_rec_size));
+               if ((tch.abs[CY_TCH_T] < md->pdata->frmwrk->abs
+                       [(CY_ABS_ID_OST * CY_NUM_ABS_SET) + CY_MIN_OST]) ||
+                       (tch.abs[CY_TCH_T] > md->pdata->frmwrk->abs
+                       [(CY_ABS_ID_OST * CY_NUM_ABS_SET) + CY_MAX_OST])) {
+                       dev_err(dev, "%s: tch=%d -> bad trk_id=%d max_id=%d\n",
+                               __func__, i, tch.abs[CY_TCH_T],
+                               md->pdata->frmwrk->abs[(CY_ABS_ID_OST *
+                               CY_NUM_ABS_SET) + CY_MAX_OST]);
+                       mt_sync_count++;
+                       continue;
+               }
+
+               /*
+                * if any touch is hover, then there is only one touch
+                * so it is OK to check the first touch for hover condition
+                */
+               if ((md->num_prv_tch == 0 && tch.abs[CY_TCH_O] != CY_OBJ_HOVER)
+                       || (md->prv_tch_type == CY_OBJ_HOVER
+                       && tch.abs[CY_TCH_O] != CY_OBJ_HOVER))
+                       input_report_key(md->input, BTN_TOUCH, CY_BTN_PRESSED);
+
+               /* use 0 based track id's */
+               sig = md->pdata->frmwrk->abs
+                       [(CY_ABS_ID_OST * CY_NUM_ABS_SET) + 0];
+               if (sig != CY_IGNORE_VALUE) {
+                       t = tch.abs[CY_TCH_T] - md->pdata->frmwrk->abs
+                               [(CY_ABS_ID_OST * CY_NUM_ABS_SET) + CY_MIN_OST];
+                       if (tch.abs[CY_TCH_E] == CY_EV_LIFTOFF) {
+                               dev_dbg(dev, "%s: t=%d e=%d lift-off\n",
+                                       __func__, t, tch.abs[CY_TCH_E]);
+                               goto cyttsp4_get_mt_touches_pr_tch;
+                       }
+                       input_mt_slot(md->input, t);
+                       input_mt_report_slot_state(md->input, MT_TOOL_FINGER,
+                                       true);
+                       ids[t] = true;
+               }
+
+               /* Check if hover on this touch */
+               dev_vdbg(dev, "%s: t=%d z=%d\n", __func__, t,
+                       tch.abs[CY_TCH_P]);
+               if (t == CY_ACTIVE_STYLUS_ID) {
+                       tch.abs[CY_TCH_P] = 0;
+                       dev_dbg(dev, "%s: t=%d z=%d force zero\n", __func__, t,
+                               tch.abs[CY_TCH_P]);
+               }
+
+               /* all devices: position and pressure fields */
+               for (j = 0; j <= CY_ABS_W_OST ; j++) {
+                       sig = md->pdata->frmwrk->abs[((CY_ABS_X_OST + j) *
+                               CY_NUM_ABS_SET) + 0];
+                       if (sig != CY_IGNORE_VALUE)
+                               input_report_abs(md->input, sig,
+                                       tch.abs[CY_TCH_X + j]);
+               }
+               if (si->si_ofs.tch_rec_size > CY_TMA1036_TCH_REC_SIZE) {
+                       /*
+                        * TMA400 size and orientation fields:
+                        * if pressure is non-zero and major touch
+                        * signal is zero, then set major and minor touch
+                        * signals to minimum non-zero value
+                        */
+                       if (tch.abs[CY_TCH_P] > 0 && tch.abs[CY_TCH_MAJ] == 0)
+                               tch.abs[CY_TCH_MAJ] = tch.abs[CY_TCH_MIN] = 1;
+
+                       /* Get the extended touch fields */
+                       for (j = 0; j < CY_NUM_EXT_TCH_FIELDS; j++) {
+                               sig = md->pdata->frmwrk->abs
+                                       [((CY_ABS_MAJ_OST + j) *
+                                       CY_NUM_ABS_SET) + 0];
+                               if (sig != CY_IGNORE_VALUE)
+                                       input_report_abs(md->input, sig,
+                                               tch.abs[CY_TCH_MAJ + j]);
+                       }
+               }
+               mt_sync_count++;
+
+cyttsp4_get_mt_touches_pr_tch:
+               if (si->si_ofs.tch_rec_size > CY_TMA1036_TCH_REC_SIZE)
+                       dev_dbg(dev,
+                               "%s: t=%d x=%d y=%d z=%d M=%d m=%d o=%d e=%d\n",
+                               __func__, t,
+                               tch.abs[CY_TCH_X],
+                               tch.abs[CY_TCH_Y],
+                               tch.abs[CY_TCH_P],
+                               tch.abs[CY_TCH_MAJ],
+                               tch.abs[CY_TCH_MIN],
+                               tch.abs[CY_TCH_OR],
+                               tch.abs[CY_TCH_E]);
+               else
+                       dev_dbg(dev,
+                               "%s: t=%d x=%d y=%d z=%d e=%d\n", __func__,
+                               t,
+                               tch.abs[CY_TCH_X],
+                               tch.abs[CY_TCH_Y],
+                               tch.abs[CY_TCH_P],
+                               tch.abs[CY_TCH_E]);
+       }
+
+       for (t = 0; t < si->si_ofs.max_tchs + 1; t++) {
+               if (ids[t])
+                       continue;
+               input_mt_slot(md->input, t);
+               input_mt_report_slot_state(md->input, MT_TOOL_FINGER, false);
+       }
+
+       input_sync(md->input);
+
+       md->num_prv_tch = num_cur_tch;
+       md->prv_tch_type = tch.abs[CY_TCH_O];
+
+       return;
+}
+
+/* read xy_data for all current touches */
+int cyttsp4_xy_worker(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_mt_data *md = &cd->md;
+       struct device *dev = &md->input->dev;
+       struct cyttsp4_sysinfo *si = md->si;
+       u8 num_cur_tch;
+       u8 hst_mode;
+       u8 rep_len;
+       u8 rep_stat;
+       u8 tt_stat;
+       int rc = 0;
+
+       /*
+        * Get event data from cyttsp4 device.
+        * The event data includes all data
+        * for all active touches.
+        * Event data also includes button data
+        */
+       /*
+        * Use 2 reads:
+        * 1st read to get mode + button bytes + touch count (core)
+        * 2nd read (optional) to get touch 1 - touch n data
+        */
+       hst_mode = si->xy_mode[CY_REG_BASE];
+       rep_len = si->xy_mode[si->si_ofs.rep_ofs];
+       rep_stat = si->xy_mode[si->si_ofs.rep_ofs + 1];
+       tt_stat = si->xy_mode[si->si_ofs.tt_stat_ofs];
+       dev_vdbg(dev, "%s: %s%02X %s%d %s%02X %s%02X\n", __func__,
+               "hst_mode=", hst_mode, "rep_len=", rep_len,
+               "rep_stat=", rep_stat, "tt_stat=", tt_stat);
+
+       num_cur_tch = GET_NUM_TOUCHES(tt_stat);
+       dev_vdbg(dev, "%s: num_cur_tch=%d\n", __func__, num_cur_tch);
+
+       if (rep_len == 0 && num_cur_tch > 0) {
+               dev_err(dev, "%s: report length error rep_len=%d num_tch=%d\n",
+                       __func__, rep_len, num_cur_tch);
+               goto cyttsp4_xy_worker_exit;
+       }
+
+       /* read touches */
+       if (num_cur_tch > 0) {
+               rc = cyttsp4_read(cd, si->si_ofs.tt_stat_ofs + 1, si->xy_data,
+                               num_cur_tch * si->si_ofs.tch_rec_size);
+               if (rc < 0) {
+                       dev_err(dev, "%s: read fail on touch regs r=%d\n",
+                               __func__, rc);
+                       goto cyttsp4_xy_worker_exit;
+               }
+       }
+
+       /* print xy data */
+       cyttsp4_pr_buf(dev, md->pr_buf, si->xy_data,
+               num_cur_tch * si->si_ofs.tch_rec_size, "xy_data");
+
+       /* check any error conditions */
+       if (IS_BAD_PKT(rep_stat)) {
+               dev_dbg(dev, "%s: Invalid buffer detected\n", __func__);
+               rc = 0;
+               goto cyttsp4_xy_worker_exit;
+       } else if (IS_LARGE_AREA(tt_stat)) {
+               /* terminate all active tracks */
+               num_cur_tch = 0;
+               dev_dbg(dev, "%s: Large area detected\n", __func__);
+       } else if (num_cur_tch > si->si_ofs.max_tchs) {
+               if (num_cur_tch > max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)) {
+                       /* terminate all active tracks */
+                       dev_err(dev, "%s: Num touch err detected (n=%d)\n",
+                               __func__, num_cur_tch);
+                       num_cur_tch = 0;
+               } else {
+                       dev_err(dev, "%s: %s (n=%d c=%d)\n", __func__,
+                               "too many tch; set to max tch",
+                               num_cur_tch, si->si_ofs.max_tchs);
+                       num_cur_tch = si->si_ofs.max_tchs;
+               }
+       }
+
+       /* extract xy_data for all currently reported touches */
+       dev_vdbg(dev, "%s: extract data num_cur_tch=%d\n", __func__,
+               num_cur_tch);
+       if (num_cur_tch)
+               cyttsp4_get_mt_touches(md, num_cur_tch);
+       else
+               cyttsp4_lift_all(md);
+
+       dev_vdbg(dev, "%s: done\n", __func__);
+       rc = 0;
+
+cyttsp4_xy_worker_exit:
+       return rc;
+}
+
+static irqreturn_t cyttsp4_irq(int irq, void *handle)
+{
+       struct cyttsp4_core_data *cd = handle;
+       struct device *dev = cd->dev;
+       enum cyttsp4_mode cur_mode;
+       u8 cmd_ofs = cd->sysinfo.si_ofs.cmd_ofs;
+       u8 mode[3];
+       int rc;
+
+       /*
+        * Check whether this IRQ should be ignored (external)
+        * This should be the very first thing to check since
+        * ignore_irq may be set for a very short period of time
+        */
+       if (atomic_read(&cd->ignore_irq)) {
+               dev_vdbg(dev, "%s: Ignoring IRQ\n", __func__);
+               return IRQ_HANDLED;
+       }
+
+       dev_dbg(dev, "%s int:0x%x\n", __func__, cd->int_status);
+
+       mutex_lock(&cd->system_lock);
+
+       /* Just to debug */
+       if (cd->sleep_state == SS_SLEEP_ON) {
+               dev_vdbg(dev, "%s: Received IRQ while in sleep\n",
+                       __func__);
+       } else if (cd->sleep_state == SS_SLEEPING) {
+               dev_vdbg(dev, "%s: Received IRQ while sleeping\n",
+                       __func__);
+       }
+
+       rc = cyttsp4_read(cd, CY_REG_BASE, mode, sizeof(mode));
+       if (rc) {
+               dev_err(cd->dev, "%s: Fail read adapter r=%d\n", __func__, rc);
+               goto cyttsp4_irq_exit;
+       }
+       dev_vdbg(dev, "%s mode[0-2]:0x%X 0x%X 0x%X\n", __func__,
+                       mode[0], mode[1], mode[2]);
+
+       if (IS_BOOTLOADER(mode[0])) {
+               cur_mode = CY_MODE_BOOTLOADER;
+               dev_vdbg(dev, "%s: bl running\n", __func__);
+               if (cd->mode == CY_MODE_BOOTLOADER) {
+                       /* Signal bootloader heartbeat heard */
+                       wake_up(&cd->wait_q);
+                       goto cyttsp4_irq_exit;
+               }
+
+               /* switch to bootloader */
+               dev_dbg(dev, "%s: restart switch to bl m=%d -> m=%d\n",
+                       __func__, cd->mode, cur_mode);
+
+               /* catch operation->bl glitch */
+               if (cd->mode != CY_MODE_UNKNOWN) {
+                       cyttsp4_queue_startup(cd);
+                       goto cyttsp4_irq_exit;
+               }
+
+               /*
+                * do not wake thread on this switch since
+                * it is possible to get an early heartbeat
+                * prior to performing the reset
+                */
+               cd->mode = cur_mode;
+
+               goto cyttsp4_irq_exit;
+       }
+
+       switch (mode[0] & CY_HST_MODE) {
+       case CY_HST_OPERATE:
+               cur_mode = CY_MODE_OPERATIONAL;
+               dev_vdbg(dev, "%s: operational\n", __func__);
+               break;
+       case CY_HST_CAT:
+               cur_mode = CY_MODE_CAT;
+               dev_vdbg(dev, "%s: CaT\n", __func__);
+               break;
+       case CY_HST_SYSINFO:
+               cur_mode = CY_MODE_SYSINFO;
+               dev_vdbg(dev, "%s: sysinfo\n", __func__);
+               break;
+       default:
+               cur_mode = CY_MODE_UNKNOWN;
+               dev_err(dev, "%s: unknown HST mode 0x%02X\n", __func__,
+                       mode[0]);
+               break;
+       }
+
+       /* Check whether this IRQ should be ignored (internal) */
+       if (cd->int_status & CY_INT_IGNORE) {
+               dev_vdbg(dev, "%s: Ignoring IRQ\n", __func__);
+               goto cyttsp4_irq_exit;
+       }
+
+       /* Check for wake up interrupt */
+       if (cd->int_status & CY_INT_AWAKE) {
+               cd->int_status &= ~CY_INT_AWAKE;
+               wake_up(&cd->sleep_q);
+               dev_vdbg(dev, "%s: Received wake up interrupt\n", __func__);
+               goto cyttsp4_irq_handshake;
+       }
+
+       /* Expecting mode change interrupt */
+       if ((cd->int_status & CY_INT_MODE_CHANGE)
+                       && (mode[0] & CY_HST_MODE_CHANGE) == 0) {
+               cd->int_status &= ~CY_INT_MODE_CHANGE;
+               dev_dbg(dev, "%s: finish mode switch m=%d -> m=%d\n",
+                               __func__, cd->mode, cur_mode);
+               cd->mode = cur_mode;
+               wake_up(&cd->wait_q);
+               goto cyttsp4_irq_handshake;
+       }
+
+       /* compare current core mode to current device mode */
+       dev_vdbg(dev, "%s: cd->mode=%d cur_mode=%d\n",
+                       __func__, cd->mode, cur_mode);
+       if ((mode[0] & CY_HST_MODE_CHANGE) == 0 && cd->mode != cur_mode) {
+               /* Unexpected mode change occurred */
+               dev_err(dev, "%s %d->%d 0x%x\n", __func__, cd->mode,
+                               cur_mode, cd->int_status);
+               dev_vdbg(dev, "%s: Unexpected mode change, startup\n",
+                               __func__);
+               cyttsp4_queue_startup(cd);
+               goto cyttsp4_irq_exit;
+       }
+
+       /* Expecting command complete interrupt */
+       dev_vdbg(dev, "%s: command byte:0x%x, toggle:0x%x\n",
+                       __func__, mode[cmd_ofs], cd->cmd_toggle);
+       if ((cd->int_status & CY_INT_EXEC_CMD)
+                       && mode[cmd_ofs] & CY_CMD_COMPLETE) {
+               cd->int_status &= ~CY_INT_EXEC_CMD;
+               dev_vdbg(dev, "%s: Received command complete interrupt\n",
+                               __func__);
+               wake_up(&cd->wait_q);
+               goto cyttsp4_irq_handshake;
+       }
+
+       /* This should be status report, read status regs */
+       if (cd->mode == CY_MODE_OPERATIONAL) {
+               dev_vdbg(dev, "%s: Read status registers\n", __func__);
+               rc = cyttsp4_load_status_regs(cd);
+               if (rc < 0) {
+                       dev_err(dev, "%s: fail read mode regs r=%d\n",
+                               __func__, rc);
+               } else {
+                       rc = cyttsp4_xy_worker(cd);
+                       if (rc < 0)
+                               dev_err(dev, "%s: fail xy_worker r=%d\n",
+                                       __func__, rc);
+               }
+       }
+
+cyttsp4_irq_handshake:
+       /* handshake the event */
+       dev_vdbg(dev, "%s: Handshake mode=0x%02X r=%d\n",
+                       __func__, mode[0], rc);
+       rc = cyttsp4_handshake(cd, mode[0]);
+       if (rc < 0)
+               dev_err(dev, "%s: Fail handshake mode=0x%02X r=%d\n",
+                               __func__, mode[0], rc);
+
+       /*
+        * a non-zero udelay period is required for using
+        * IRQF_TRIGGER_LOW in order to delay until the
+        * device completes isr deassert
+        */
+       udelay(cd->pdata->level_irq_udelay);
+
+cyttsp4_irq_exit:
+       mutex_unlock(&cd->system_lock);
+       dev_vdbg(dev, "%s: irq done\n", __func__);
+       return IRQ_HANDLED;
+}
+
+static void cyttsp4_start_wd_timer(struct cyttsp4_core_data *cd)
+{
+       if (!CY_WATCHDOG_TIMEOUT)
+               return;
+
+       mod_timer(&cd->timer, jiffies + CY_WATCHDOG_TIMEOUT);
+       return;
+}
+
+static void cyttsp4_stop_wd_timer(struct cyttsp4_core_data *cd)
+{
+       if (!CY_WATCHDOG_TIMEOUT)
+               return;
+
+       del_timer(&cd->timer);
+       cancel_work_sync(&cd->work);
+       return;
+}
+
+static void cyttsp4_timer_watchdog(struct work_struct *work)
+{
+       struct cyttsp4_core_data *cd =
+                       container_of(work, struct cyttsp4_core_data, work);
+       int rep_stat;
+       int mode;
+       int retval;
+
+       if (cd == NULL) {
+               dev_err(cd->dev, "%s: NULL context pointer\n", __func__);
+               return;
+       }
+
+       mutex_lock(&cd->system_lock);
+       retval = cyttsp4_load_status_regs(cd);
+       if (retval < 0) {
+               dev_err(cd->dev,
+                       "%s: failed to access device in watchdog timer r=%d\n",
+                       __func__, retval);
+               cyttsp4_queue_startup(cd);
+               goto cyttsp4_timer_watchdog_exit_error;
+       }
+       mode = cd->sysinfo.xy_mode[CY_REG_BASE];
+       rep_stat = cd->sysinfo.xy_mode[cd->sysinfo.si_ofs.rep_ofs];
+       if (IS_BOOTLOADER(mode) && IS_BOOTLOADER(rep_stat)) {
+               dev_err(cd->dev,
+                       "%s: device found in bootloader mode when operational mode rep_stat=0x%02X\n",
+                       __func__, rep_stat);
+               cyttsp4_queue_startup(cd);
+               goto cyttsp4_timer_watchdog_exit_error;
+       }
+
+       cyttsp4_start_wd_timer(cd);
+cyttsp4_timer_watchdog_exit_error:
+       mutex_unlock(&cd->system_lock);
+       return;
+}
+
+static void cyttsp4_timer(unsigned long handle)
+{
+       struct cyttsp4_core_data *cd = (struct cyttsp4_core_data *)handle;
+
+       dev_vdbg(cd->dev, "%s: Timer triggered\n", __func__);
+
+       if (!cd)
+               return;
+
+       if (!work_pending(&cd->work))
+               schedule_work(&cd->work);
+
+       return;
+}
+
+static int cyttsp4_reset_and_wait(struct cyttsp4_core_data *cd)
+{
+       long t;
+       int rc;
+
+       /* reset hardware */
+       mutex_lock(&cd->system_lock);
+       dev_dbg(cd->dev, "%s: reset hw...\n", __func__);
+       rc = cyttsp4_hw_reset(cd);
+       cd->mode = CY_MODE_UNKNOWN;
+       mutex_unlock(&cd->system_lock);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: Fail hw reset r=%d\n", __func__, rc);
+
+       /* wait heartbeat */
+       dev_vdbg(cd->dev, "%s: wait heartbeat...\n", __func__);
+       t = wait_event_timeout(cd->wait_q, cd->mode == CY_MODE_BOOTLOADER,
+               msecs_to_jiffies(CY_CORE_RESET_AND_WAIT_TIMEOUT));
+       if  (IS_TMO(t)) {
+               dev_err(cd->dev, "%s: tmo waiting bl heartbeat cd->mode=%d\n",
+                               __func__, cd->mode);
+               rc = -ETIME;
+       } else
+               rc = 0;
+
+       return rc;
+}
+
+/*
+ * returns err if refused or timeout; block until mode change complete
+ * bit is set (mode change interrupt)
+ */
+static int cyttsp4_set_mode(struct cyttsp4_core_data *cd, u8 new_dev_mode,
+               int new_op_mode)
+{
+       long t;
+       int rc;
+
+       /* change mode */
+       dev_dbg(cd->dev, "%s: new_dev_mode=%02X new_mode=%d\n",
+                       __func__, new_dev_mode, new_op_mode);
+       new_dev_mode |= CY_HST_MODE_CHANGE;
+
+       mutex_lock(&cd->system_lock);
+       cd->int_status |= CY_INT_MODE_CHANGE;
+       rc = cyttsp4_write(cd, CY_REG_BASE, &new_dev_mode,
+                       sizeof(new_dev_mode));
+       if (rc < 0)
+               dev_err(cd->dev, "%s: Fail write mode change r=%d\n",
+                               __func__, rc);
+       mutex_unlock(&cd->system_lock);
+
+       /* wait for mode change done interrupt */
+       t = wait_event_timeout(cd->wait_q,
+                       (cd->int_status & CY_INT_MODE_CHANGE) == 0,
+                       msecs_to_jiffies(CY_CORE_MODE_CHANGE_TIMEOUT));
+       dev_dbg(cd->dev, "%s: back from wait t=%ld cd->mode=%d\n",
+                       __func__, t, cd->mode);
+
+       if (IS_TMO(t)) {
+               dev_err(cd->dev, "%s: %s\n", __func__,
+                               "tmo waiting mode change");
+               mutex_lock(&cd->system_lock);
+               cd->int_status &= ~CY_INT_MODE_CHANGE;
+               mutex_unlock(&cd->system_lock);
+               rc = -EINVAL;
+       }
+
+       return rc;
+}
+
+static const u8 ldr_exit[] = {
+       0xFF, 0x01, 0x3B, 0x00, 0x00, 0x4F, 0x6D, 0x17
+};
+
+static int cyttsp4_core_sleep(struct cyttsp4_core_data *cd)
+{
+       enum cyttsp4_sleep_state ss = SS_SLEEP_ON;
+       int rc = 0;
+       u8 mode;
+
+       dev_vdbg(cd->dev, "%s: enter...\n", __func__);
+
+       /* Already in sleep mode? */
+       mutex_lock(&cd->system_lock);
+       if (cd->sleep_state == SS_SLEEP_ON) {
+               mutex_unlock(&cd->system_lock);
+               return 0;
+       }
+       cd->sleep_state = SS_SLEEPING;
+       mutex_unlock(&cd->system_lock);
+
+       /* Wait until currently running IRQ handler exits and disable IRQ */
+       disable_irq(cd->irq);
+
+       dev_vdbg(cd->dev, "%s: write DEEP SLEEP...\n", __func__);
+
+       rc = cyttsp4_read(cd, CY_REG_BASE, &mode, sizeof(mode));
+       if (rc) {
+               dev_err(cd->dev, "%s: Fail read adapter r=%d\n", __func__, rc);
+               ss = SS_SLEEP_OFF;
+               goto exit;
+       }
+
+       if (IS_BOOTLOADER(mode)) {
+               dev_err(cd->dev, "%s: Device in BOOTLADER mode.\n", __func__);
+               rc = -EINVAL;
+               ss = SS_SLEEP_OFF;
+               goto exit;
+       }
+       mode |= CY_HST_SLEEP;
+
+       rc = cyttsp4_write(cd, CY_REG_BASE, &mode, sizeof(mode));
+       if (rc) {
+               dev_err(cd->dev, "%s: Fail write adapter r=%d\n", __func__, rc);
+               ss = SS_SLEEP_OFF;
+               goto exit;
+       }
+
+       dev_vdbg(cd->dev, "%s: write DEEP SLEEP succeeded\n", __func__);
+
+       if (cd->pdata->power) {
+               dev_dbg(cd->dev, "%s: Power down HW\n", __func__);
+               cd->pdata->power(cd->pdata, 0, cd->dev);
+       } else {
+               dev_vdbg(cd->dev, "%s: No power function\n", __func__);
+       }
+
+       cyttsp4_stop_wd_timer(cd);
+
+       /* Give time to FW to sleep */
+       mdelay(10);
+
+exit:
+       mutex_lock(&cd->system_lock);
+       if (ss == SS_SLEEP_ON)
+               cd->int_status |= CY_INT_IGNORE;
+       cd->sleep_state = ss;
+       mutex_unlock(&cd->system_lock);
+
+       enable_irq(cd->irq);
+
+       return rc;
+}
+
+
+static int cyttsp4_core_wake(struct cyttsp4_core_data *cd)
+{
+       struct device *dev = cd->dev;
+       int rc;
+       u8 mode;
+       int t;
+
+       dev_vdbg(cd->dev, "%s: enter...\n", __func__);
+
+       /* Already woken? */
+       mutex_lock(&cd->system_lock);
+       if (cd->sleep_state == SS_SLEEP_OFF) {
+               mutex_unlock(&cd->system_lock);
+               return 0;
+       }
+       cd->int_status &= ~CY_INT_IGNORE;
+       cd->int_status |= CY_INT_AWAKE;
+       cd->sleep_state = SS_WAKING;
+
+       /* Do not start watchdog in already woken state */
+       cyttsp4_start_wd_timer(cd);
+
+       if (cd->pdata->power) {
+               dev_dbg(dev, "%s: Power up HW\n", __func__);
+               cd->pdata->power(cd->pdata, 1, dev);
+       } else {
+               dev_vdbg(dev, "%s: No power function\n", __func__);
+       }
+
+       rc = cyttsp4_wakeup(cd);
+       if (rc < 0) {
+               dev_err(dev, "%s: HW Power up fails r=%d\n",
+                               __func__, rc);
+
+               /* Initiate a read transaction to wake up */
+               cyttsp4_read(cd, CY_REG_BASE, &mode, sizeof(mode));
+       } else
+               dev_vdbg(cd->dev, "%s: HW power up succeeds\n",
+                       __func__);
+       mutex_unlock(&cd->system_lock);
+
+       t = wait_event_timeout(cd->sleep_q,
+                       (cd->int_status & CY_INT_AWAKE) == 0,
+                       msecs_to_jiffies(CY_CORE_WAKEUP_TIMEOUT));
+       if (IS_TMO(t)) {
+               dev_err(dev, "%s: TMO waiting for wakeup\n", __func__);
+               mutex_lock(&cd->system_lock);
+               cd->int_status &= ~CY_INT_AWAKE;
+               mutex_unlock(&cd->system_lock);
+               /* Try starting up */
+               cyttsp4_queue_startup(cd);
+       }
+
+       mutex_lock(&cd->system_lock);
+       cd->sleep_state = SS_SLEEP_OFF;
+       mutex_unlock(&cd->system_lock);
+
+       return 0;
+}
+
+static int cyttsp4_startup_to_sysinfo_mode(struct cyttsp4_core_data *cd)
+{
+       long t;
+       int rc;
+
+       dev_dbg(cd->dev, "%s: enter...\n", __func__);
+
+       cyttsp4_stop_wd_timer(cd);
+
+       /* reset hardware and wait for heartbeat */
+       rc = cyttsp4_reset_and_wait(cd);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: Error on h/w reset r=%d\n", __func__, rc);
+
+       /* exit bl into sysinfo mode */
+       dev_vdbg(cd->dev, "%s: write exit ldr...\n", __func__);
+       mutex_lock(&cd->system_lock);
+       cd->int_status &= ~CY_INT_IGNORE;
+       cd->int_status |= CY_INT_MODE_CHANGE;
+       rc = cyttsp4_write(cd, CY_REG_BASE, (u8 *)ldr_exit, sizeof(ldr_exit));
+       if (rc < 0)
+               dev_err(cd->dev, "%s: Fail write adap= r=%d\n", __func__, rc);
+       mutex_unlock(&cd->system_lock);
+
+       dev_vdbg(cd->dev, "%s: wait sysinfo...\n", __func__);
+       t = wait_event_timeout(cd->wait_q, cd->mode == CY_MODE_SYSINFO,
+               msecs_to_jiffies(CY_CORE_MODE_CHANGE_TIMEOUT));
+       if (IS_TMO(t)) {
+               dev_err(cd->dev, "%s: tmo waiting exit bl cd->mode=%d\n",
+                               __func__, cd->mode);
+               mutex_lock(&cd->system_lock);
+               cd->int_status &= ~CY_INT_MODE_CHANGE;
+               mutex_unlock(&cd->system_lock);
+
+               cyttsp4_start_wd_timer(cd);
+
+               /*
+                * Unable to switch to SYSINFO mode,
+                * Corrupted FW may cause crash, exit here.
+                */
+               return 0;
+       }
+
+       /* read sysinfo data */
+       dev_vdbg(cd->dev, "%s: get sysinfo regs..\n", __func__);
+       rc = cyttsp4_get_sysinfo_regs(cd);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: failed to get sysinfo regs rc=%d\n",
+                       __func__, rc);
+       return rc;
+}
+
+static void cyttsp4_switch_to_operating_mode(struct cyttsp4_core_data *cd)
+{
+       bool sleep = false;
+
+       cyttsp4_start_wd_timer(cd);
+
+       /* switch to operational mode */
+       dev_vdbg(cd->dev, "%s: set mode hst_mode=%02X mode=%d...\n",
+               __func__, CY_HST_OPERATE, CY_MODE_OPERATIONAL);
+       cyttsp4_set_mode(cd, CY_HST_OPERATE, CY_MODE_OPERATIONAL);
+
+       /* restore to sleep if was suspended */
+       mutex_lock(&cd->system_lock);
+       if (cd->sleep_state == SS_SLEEP_ON) {
+               cd->sleep_state = SS_SLEEP_OFF;
+               sleep = true;
+       }
+       mutex_unlock(&cd->system_lock);
+
+       if (sleep)
+               cyttsp4_core_sleep(cd);
+}
+
+static int cyttsp4_startup(struct cyttsp4_core_data *cd)
+{
+       int rc;
+
+       rc = cyttsp4_startup_to_sysinfo_mode(cd);
+       if (!rc)
+               cyttsp4_switch_to_operating_mode(cd);
+
+       return rc;
+}
+
+static void cyttsp4_startup_work_function(struct work_struct *work)
+{
+       struct cyttsp4_core_data *cd =  container_of(work,
+               struct cyttsp4_core_data, startup_work);
+       int rc;
+
+       rc = cyttsp4_startup(cd);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: Fail queued startup r=%d\n",
+                       __func__, rc);
+}
+
+static void cyttsp4_free_si_ptrs(struct cyttsp4_core_data *cd)
+{
+       struct cyttsp4_sysinfo *si = &cd->sysinfo;
+
+       kfree(si->si_ptrs.cydata);
+       kfree(si->si_ptrs.test);
+       kfree(si->si_ptrs.pcfg);
+       kfree(si->si_ptrs.opcfg);
+       kfree(si->si_ptrs.ddata);
+       kfree(si->si_ptrs.mdata);
+       kfree(si->btn);
+       kfree(si->xy_mode);
+       kfree(si->xy_data);
+       kfree(si->btn_rec_data);
+}
+
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
+static int cyttsp4_core_suspend(struct device *dev)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       int rc;
+
+       dev_dbg(dev, "%s\n", __func__);
+
+       rc = cyttsp4_core_sleep(cd);
+       if (rc < 0) {
+               dev_err(dev, "%s: Error on sleep\n", __func__);
+               return -EAGAIN;
+       }
+       return 0;
+}
+
+static int cyttsp4_core_resume(struct device *dev)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       int rc;
+
+       dev_dbg(dev, "%s\n", __func__);
+
+       rc = cyttsp4_core_wake(cd);
+       if (rc < 0) {
+               dev_err(dev, "%s: Error on wake\n", __func__);
+               return -EAGAIN;
+       }
+
+       return 0;
+}
+#endif
+
+const struct dev_pm_ops cyttsp4_pm_ops = {
+       SET_SYSTEM_SLEEP_PM_OPS(cyttsp4_core_suspend, cyttsp4_core_resume)
+       SET_RUNTIME_PM_OPS(cyttsp4_core_suspend, cyttsp4_core_resume, NULL)
+};
+EXPORT_SYMBOL_GPL(cyttsp4_pm_ops);
+
+/*
+ * Show Firmware version via sysfs
+ */
+static ssize_t cyttsp4_ic_ver_show(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       struct cyttsp4_cydata *cydata = cd->sysinfo.si_ptrs.cydata;
+
+       return sprintf(buf,
+               "%s: 0x%02X 0x%02X\n"
+               "%s: 0x%02X\n"
+               "%s: 0x%02X\n"
+               "%s: 0x%02X 0x%02X 0x%02X 0x%02X 0x%02X 0x%02X 0x%02X 0x%02X\n"
+               "%s: 0x%02X\n"
+               "%s: 0x%02X\n",
+               "TrueTouch Product ID", cydata->ttpidh, cydata->ttpidl,
+               "Firmware Major Version", cydata->fw_ver_major,
+               "Firmware Minor Version", cydata->fw_ver_minor,
+               "Revision Control Number", cydata->revctrl[0],
+               cydata->revctrl[1], cydata->revctrl[2], cydata->revctrl[3],
+               cydata->revctrl[4], cydata->revctrl[5], cydata->revctrl[6],
+               cydata->revctrl[7],
+               "Bootloader Major Version", cydata->blver_major,
+               "Bootloader Minor Version", cydata->blver_minor);
+}
+
+/*
+ * Show Driver version via sysfs
+ */
+static ssize_t cyttsp4_drv_ver_show(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       return snprintf(buf, CY_MAX_PRBUF_SIZE,
+               "Driver: %s\nVersion: %s\nDate: %s\n",
+               cy_driver_core_name, cy_driver_core_version,
+               cy_driver_core_date);
+}
+
+/*
+ * HW reset via sysfs
+ */
+static ssize_t cyttsp4_hw_reset_store(struct device *dev,
+               struct device_attribute *attr, const char *buf, size_t size)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       int rc = 0;
+
+       rc = cyttsp4_startup(cd);
+       if (rc < 0)
+               dev_err(dev, "%s: HW reset failed r=%d\n",
+                       __func__, rc);
+
+       return size;
+}
+
+/*
+ * Show IRQ status via sysfs
+ */
+static ssize_t cyttsp4_hw_irq_stat_show(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       int retval;
+
+       retval = cyttsp4_irq_stat(cd->pdata, dev);
+       switch (retval) {
+       case 0:
+               return snprintf(buf, CY_MAX_PRBUF_SIZE,
+                       "Interrupt line is LOW.\n");
+       case 1:
+               return snprintf(buf, CY_MAX_PRBUF_SIZE,
+                       "Interrupt line is HIGH.\n");
+       }
+
+       return snprintf(buf, CY_MAX_PRBUF_SIZE,
+               "Function irq_stat() returned %d.\n", retval);
+}
+
+/*
+ * Show IRQ enable/disable status via sysfs
+ */
+static ssize_t cyttsp4_drv_irq_show(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       ssize_t ret;
+
+       mutex_lock(&cd->system_lock);
+       if (cd->irq_enabled)
+               ret = snprintf(buf, CY_MAX_PRBUF_SIZE,
+                       "Driver interrupt is ENABLED\n");
+       else
+               ret = snprintf(buf, CY_MAX_PRBUF_SIZE,
+                       "Driver interrupt is DISABLED\n");
+       mutex_unlock(&cd->system_lock);
+
+       return ret;
+}
+
+/*
+ * Enable/disable IRQ via sysfs
+ */
+static ssize_t cyttsp4_drv_irq_store(struct device *dev,
+               struct device_attribute *attr, const char *buf, size_t size)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       unsigned long value;
+       int retval = 0;
+
+       retval = kstrtoul(buf, 10, &value);
+       if (retval < 0) {
+               dev_err(dev, "%s: Invalid value\n", __func__);
+               goto cyttsp4_drv_irq_store_error_exit;
+       }
+
+       mutex_lock(&cd->system_lock);
+       switch (value) {
+       case 0:
+               if (cd->irq_enabled) {
+                       cd->irq_enabled = false;
+                       /* Disable IRQ */
+                       disable_irq_nosync(cd->irq);
+                       dev_info(dev, "%s: Driver IRQ now disabled\n",
+                               __func__);
+               } else
+                       dev_info(dev, "%s: Driver IRQ already disabled\n",
+                               __func__);
+               break;
+
+       case 1:
+               if (cd->irq_enabled == false) {
+                       cd->irq_enabled = true;
+                       /* Enable IRQ */
+                       enable_irq(cd->irq);
+                       dev_info(dev, "%s: Driver IRQ now enabled\n",
+                               __func__);
+               } else
+                       dev_info(dev, "%s: Driver IRQ already enabled\n",
+                               __func__);
+               break;
+
+       default:
+               dev_err(dev, "%s: Invalid value\n", __func__);
+       }
+       mutex_unlock(&(cd->system_lock));
+
+cyttsp4_drv_irq_store_error_exit:
+
+       return size;
+}
+
+/*
+ * Debugging options via sysfs
+ */
+static ssize_t cyttsp4_drv_debug_store(struct device *dev,
+               struct device_attribute *attr, const char *buf, size_t size)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       unsigned long value = 0;
+       int rc = 0;
+
+       rc = kstrtoul(buf, 10, &value);
+       if (rc < 0) {
+               dev_err(dev, "%s: Invalid value\n", __func__);
+               goto cyttsp4_drv_debug_store_exit;
+       }
+
+       switch (value) {
+       case CY_DBG_SUSPEND:
+               dev_info(dev, "%s: SUSPEND (cd=%p)\n", __func__, cd);
+               rc = cyttsp4_core_sleep(cd);
+               if (rc)
+                       dev_err(dev, "%s: Suspend failed rc=%d\n",
+                               __func__, rc);
+               else
+                       dev_info(dev, "%s: Suspend succeeded\n", __func__);
+               break;
+
+       case CY_DBG_RESUME:
+               dev_info(dev, "%s: RESUME (cd=%p)\n", __func__, cd);
+               rc = cyttsp4_core_wake(cd);
+               if (rc)
+                       dev_err(dev, "%s: Resume failed rc=%d\n",
+                               __func__, rc);
+               else
+                       dev_info(dev, "%s: Resume succeeded\n", __func__);
+               break;
+       case CY_DBG_SOFT_RESET:
+               dev_info(dev, "%s: SOFT RESET (cd=%p)\n", __func__, cd);
+               rc = cyttsp4_hw_soft_reset(cd);
+               break;
+       case CY_DBG_RESET:
+               dev_info(dev, "%s: HARD RESET (cd=%p)\n", __func__, cd);
+               rc = cyttsp4_hw_hard_reset(cd);
+               break;
+       default:
+               dev_err(dev, "%s: Invalid value\n", __func__);
+       }
+
+cyttsp4_drv_debug_store_exit:
+       return size;
+}
+
+/*
+ * Show system status on deep sleep status via sysfs
+ */
+static ssize_t cyttsp4_sleep_status_show(struct device *dev,
+               struct device_attribute *attr, char *buf)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       ssize_t ret;
+
+       mutex_lock(&cd->system_lock);
+       if (cd->sleep_state == SS_SLEEP_ON)
+               ret = snprintf(buf, CY_MAX_PRBUF_SIZE,
+                               "Deep Sleep is ENABLED\n");
+       else
+               ret = snprintf(buf, CY_MAX_PRBUF_SIZE,
+                               "Deep Sleep is DISABLED\n");
+       mutex_unlock(&cd->system_lock);
+
+       return ret;
+}
+
+static struct device_attribute attributes[] = {
+       __ATTR(ic_ver, S_IRUGO, cyttsp4_ic_ver_show, NULL),
+       __ATTR(drv_ver, S_IRUGO, cyttsp4_drv_ver_show, NULL),
+       __ATTR(hw_reset, S_IWUSR, NULL, cyttsp4_hw_reset_store),
+       __ATTR(hw_irq_stat, S_IRUSR, cyttsp4_hw_irq_stat_show, NULL),
+       __ATTR(drv_irq, S_IRUSR | S_IWUSR, cyttsp4_drv_irq_show,
+               cyttsp4_drv_irq_store),
+       __ATTR(drv_debug, S_IWUSR, NULL, cyttsp4_drv_debug_store),
+       __ATTR(sleep_status, S_IRUSR, cyttsp4_sleep_status_show, NULL),
+};
+
+static int add_sysfs_interfaces(struct device *dev)
+{
+       int i;
+
+       for (i = 0; i < ARRAY_SIZE(attributes); i++)
+               if (device_create_file(dev, attributes + i))
+                       goto undo;
+       return 0;
+undo:
+       for (; i >= 0 ; i--)
+               device_remove_file(dev, attributes + i);
+       dev_err(dev, "%s: failed to create sysfs interface\n", __func__);
+       return -ENODEV;
+}
+
+static void remove_sysfs_interfaces(struct device *dev)
+{
+       int i;
+       for (i = 0; i < ARRAY_SIZE(attributes); i++)
+               device_remove_file(dev, attributes + i);
+}
+
+void cyttsp4_mt_release(struct cyttsp4_mt_data *md)
+{
+       struct device *dev = md->input->dev.parent;
+
+       dev_dbg(dev, "%s\n", __func__);
+
+
+       input_unregister_device(md->input);
+
+       input_set_drvdata(md->input, NULL);
+}
+
+static int cyttsp4_mt_open(struct input_dev *input)
+{
+       struct device *dev = input->dev.parent;
+
+       dev_dbg(dev, "%s\n", __func__);
+
+       pm_runtime_get_sync(dev);
+
+       return 0;
+}
+
+static void cyttsp4_mt_close(struct input_dev *input)
+{
+       struct cyttsp4_mt_data *md = input_get_drvdata(input);
+       struct device *dev = input->dev.parent;
+
+       dev_dbg(dev, "%s\n", __func__);
+
+       cyttsp4_lift_all(md);
+
+       pm_runtime_put(dev);
+}
+
+
+int cyttsp4_mt_probe(struct cyttsp4_core_data *cd)
+{
+       struct device *dev = cd->dev;
+       struct cyttsp4_mt_data *md = &cd->md;
+       struct cyttsp4_platform_data *pdata = dev_get_platdata(dev);
+       struct cyttsp4_mt_platform_data *mt_pdata = pdata->mt_pdata;
+       int signal = CY_IGNORE_VALUE;
+       int max_x, max_y, max_p, min, max;
+       int max_x_tmp, max_y_tmp;
+       int i;
+       int rc;
+
+       dev_info(dev, "%s\n", __func__);
+       dev_dbg(dev, "%s: debug on\n", __func__);
+       dev_vdbg(dev, "%s: verbose debug on\n", __func__);
+
+       if (mt_pdata == NULL) {
+               dev_err(dev, "%s: No MT platform data\n", __func__);
+               rc = -EINVAL;
+               goto error_no_mt_pdata;
+       }
+
+       md->prv_tch_type = CY_OBJ_STANDARD_FINGER;
+       md->pdata = mt_pdata;
+
+       /* Create the input device and register it. */
+       dev_vdbg(dev, "%s: Create the input device and register it\n",
+               __func__);
+       md->input = input_allocate_device();
+       if (md->input == NULL) {
+               dev_err(dev, "%s: Error, failed to allocate input device\n",
+                       __func__);
+               rc = -ENOSYS;
+               goto error_alloc_failed;
+       }
+
+       md->input->name = mt_pdata->inp_dev_name;
+       scnprintf(md->phys, sizeof(md->phys)-1, "%s", dev_name(dev));
+       md->input->phys = md->phys;
+       md->input->id.bustype = cd->ops->bustype;
+       md->input->dev.parent = dev;
+       md->input->open = cyttsp4_mt_open;
+       md->input->close = cyttsp4_mt_close;
+       input_set_drvdata(md->input, md);
+
+       /* get sysinfo */
+       md->si = &cd->sysinfo;
+       if (md->si == NULL) {
+               dev_err(dev, "%s: Fail get sysinfo pointer from core p=%p\n",
+                       __func__, md->si);
+               rc = -ENODEV;
+               goto error_get_sysinfo;
+       }
+
+       dev_vdbg(dev, "%s: Initialize event signals\n", __func__);
+       __set_bit(EV_ABS, md->input->evbit);
+       __set_bit(EV_REL, md->input->evbit);
+       __set_bit(EV_KEY, md->input->evbit);
+       bitmap_fill(md->input->absbit, ABS_MAX);
+       __set_bit(BTN_TOUCH, md->input->keybit);
+
+       /* If virtualkeys enabled, don't use all screen */
+       if (md->pdata->flags & CY_FLAG_VKEYS) {
+               max_x_tmp = CY_VKEYS_X;
+               max_y_tmp = CY_VKEYS_Y;
+       } else {
+               max_x_tmp = md->si->si_ofs.max_x;
+               max_y_tmp = md->si->si_ofs.max_y;
+       }
+
+       /* get maximum values from the sysinfo data */
+       if (md->pdata->flags & CY_FLAG_FLIP) {
+               max_x = max_y_tmp - 1;
+               max_y = max_x_tmp - 1;
+       } else {
+               max_x = max_x_tmp - 1;
+               max_y = max_y_tmp - 1;
+       }
+       max_p = md->si->si_ofs.max_p;
+
+       /* set event signal capabilities */
+       for (i = 0; i < (md->pdata->frmwrk->size / CY_NUM_ABS_SET); i++) {
+               signal = md->pdata->frmwrk->abs
+                       [(i * CY_NUM_ABS_SET) + CY_SIGNAL_OST];
+               if (signal != CY_IGNORE_VALUE) {
+                       min = md->pdata->frmwrk->abs
+                               [(i * CY_NUM_ABS_SET) + CY_MIN_OST];
+                       max = md->pdata->frmwrk->abs
+                               [(i * CY_NUM_ABS_SET) + CY_MAX_OST];
+                       if (i == CY_ABS_ID_OST) {
+                               /* shift track ids down to start at 0 */
+                               max = max - min;
+                               min = min - min;
+                       } else if (i == CY_ABS_X_OST)
+                               max = max_x;
+                       else if (i == CY_ABS_Y_OST)
+                               max = max_y;
+                       else if (i == CY_ABS_P_OST)
+                               max = max_p;
+                       input_set_abs_params(md->input, signal, min, max,
+                               md->pdata->frmwrk->abs
+                               [(i * CY_NUM_ABS_SET) + CY_FUZZ_OST],
+                               md->pdata->frmwrk->abs
+                               [(i * CY_NUM_ABS_SET) + CY_FLAT_OST]);
+                       dev_dbg(dev, "%s: register signal=%02X min=%d max=%d\n",
+                               __func__, signal, min, max);
+                       if ((i == CY_ABS_ID_OST) &&
+                               (md->si->si_ofs.tch_rec_size <
+                               CY_TMA4XX_TCH_REC_SIZE))
+                               break;
+               }
+       }
+
+       /* max num slots equals max touches + 1 for hover */
+       input_mt_init_slots(md->input, md->si->si_ofs.max_tchs + 1);
+       rc = input_register_device(md->input);
+       if (rc < 0) {
+               dev_err(dev, "%s: Error, failed register input device r=%d\n",
+                       __func__, rc);
+               goto error_init_input;
+       }
+
+       dev_dbg(dev, "%s: OK\n", __func__);
+       return 0;
+
+error_init_input:
+       input_free_device(md->input);
+error_get_sysinfo:
+       input_set_drvdata(md->input, NULL);
+error_alloc_failed:
+error_no_mt_pdata:
+       dev_err(dev, "%s failed.\n", __func__);
+       return rc;
+}
+
+int cyttsp4_probe(struct device *dev, struct cyttsp4_bus_ops *ops,
+               u8 *xfer_buf)
+{
+       struct cyttsp4_core_data *cd;
+       struct cyttsp4_platform_data *pdata = dev_get_platdata(dev);
+       struct cyttsp4_core_platform_data *core_pdata;
+       unsigned long irq_flags;
+       int rc = 0;
+
+       dev_info(dev, "%s: startup\n", __func__);
+       dev_dbg(dev, "%s: debug on\n", __func__);
+       dev_vdbg(dev, "%s: verbose debug on\n", __func__);
+
+       if (pdata == NULL) {
+               dev_err(dev, "%s: No platform data\n", __func__);
+               rc = -EINVAL;
+               goto error_no_pdata;
+       }
+
+       core_pdata = pdata->core_pdata;
+       if (core_pdata == NULL) {
+               dev_err(dev, "%s: No core platform data\n", __func__);
+               rc = -EINVAL;
+               goto error_no_core_pdata;
+       }
+
+       /* get context and debug print buffers */
+       cd = kzalloc(sizeof(*cd), GFP_KERNEL);
+       if (cd == NULL) {
+               dev_err(dev, "%s: Error, kzalloc\n", __func__);
+               rc = -ENOMEM;
+               goto error_alloc_data_failed;
+       }
+
+       /* init lists */
+       mutex_init(&cd->system_lock);
+       init_waitqueue_head(&cd->wait_q);
+       init_waitqueue_head(&cd->sleep_q);
+       cd->startup_work_q = create_singlethread_workqueue("startup_work_q");
+       if (cd->startup_work_q == NULL) {
+               dev_err(dev, "%s: No memory for %s\n", __func__,
+                       "startup_work_q");
+               goto error_init;
+       }
+
+       dev_dbg(dev, "%s: initialize core data\n", __func__);
+       spin_lock_init(&cd->spinlock);
+       cd->dev = dev;
+       cd->pdata = core_pdata;
+       cd->ops = ops;
+       cd->irq = gpio_to_irq(core_pdata->irq_gpio);
+       cd->irq_enabled = true;
+       cd->xfer_buf = xfer_buf;
+       dev_set_drvdata(dev, cd);
+       if (cd->irq < 0) {
+               rc = -EINVAL;
+               goto error_gpio_irq;
+       }
+
+       dev_info(cd->dev, "%s: Init HW\n", __func__);
+       rc = cyttsp4_init(cd->pdata, cd->dev);
+       if (rc < 0)
+               dev_err(cd->dev, "%s: HW Init fail r=%d\n", __func__, rc);
+
+       INIT_WORK(&cd->startup_work, cyttsp4_startup_work_function);
+
+       dev_dbg(dev, "%s: initialize threaded irq=%d\n", __func__, cd->irq);
+       if (core_pdata->level_irq_udelay > 0)
+               /* use level triggered interrupts */
+               irq_flags = IRQF_TRIGGER_LOW | IRQF_ONESHOT;
+       else
+               /* use edge triggered interrupts */
+               irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+
+       rc = request_threaded_irq(cd->irq, NULL, cyttsp4_irq, irq_flags,
+               dev_name(dev), cd);
+       if (rc < 0) {
+               dev_err(dev, "%s: Error, could not request irq\n", __func__);
+               goto error_request_irq;
+       }
+
+       INIT_WORK(&cd->work, cyttsp4_timer_watchdog);
+       setup_timer(&cd->timer, cyttsp4_timer, (unsigned long)cd);
+
+       dev_dbg(dev, "%s: add sysfs interfaces\n", __func__);
+       rc = add_sysfs_interfaces(dev);
+       if (rc < 0) {
+               dev_err(dev, "%s: Error, fail sysfs init\n", __func__);
+               goto error_attr_create;
+       }
+
+       pm_runtime_enable(dev);
+
+       /*
+        * call startup directly to ensure that the device
+        * is tested before leaving the probe
+        */
+       dev_dbg(dev, "%s: call startup\n", __func__);
+
+       rc = cyttsp4_startup_to_sysinfo_mode(cd);
+
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: Fail initial startup r=%d\n",
+                       __func__, rc);
+               goto error_startup;
+       }
+
+       rc = cyttsp4_mt_probe(cd);
+
+       if (rc < 0) {
+               dev_err(cd->dev, "%s: Fail MT probe r=%d\n",
+                       __func__, rc);
+               goto error_startup;
+       }
+
+       cyttsp4_switch_to_operating_mode(cd);
+
+       dev_info(dev, "%s: ok\n", __func__);
+       rc = 0;
+       goto no_error;
+
+error_startup:
+       cyttsp4_free_si_ptrs(cd);
+       pm_runtime_disable(dev);
+error_attr_create:
+       free_irq(cd->irq, cd);
+error_request_irq:
+error_gpio_irq:
+       cyttsp4_exit(core_pdata, dev);
+error_init:
+       dev_set_drvdata(dev, NULL);
+       kfree(cd);
+error_alloc_data_failed:
+error_no_core_pdata:
+error_no_pdata:
+       dev_err(dev, "%s failed.\n", __func__);
+no_error:
+       return rc;
+}
+EXPORT_SYMBOL_GPL(cyttsp4_probe);
+
+void cyttsp4_remove(struct device *dev)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+
+       cyttsp4_mt_release(&cd->md);
+
+       cyttsp4_stop_wd_timer(cd);
+
+       remove_sysfs_interfaces(dev);
+       free_irq(cd->irq, cd);
+       cyttsp4_exit(cd->pdata, dev);
+       cyttsp4_free_si_ptrs(cd);
+       pm_runtime_disable(dev);
+       dev_set_drvdata(dev, NULL);
+       kfree(cd);
+}
+EXPORT_SYMBOL_GPL(cyttsp4_remove);
+
+static int __init cyttsp4_core_init(void)
+{
+       pr_info("%s: Cypress TTSP v4 core driver (Built %s)\n",
+                __func__, CY_DRIVER_DATE);
+       return 0;
+}
+module_init(cyttsp4_core_init);
+
+static void __exit cyttsp4_core_exit(void)
+{
+       pr_info("%s: module exit\n", __func__);
+}
+module_exit(cyttsp4_core_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard (TTSP) touchscreen core driver");
+MODULE_AUTHOR("Cypress");
diff --git a/drivers/input/touchscreen/cyttsp4_core.h b/drivers/input/touchscreen/cyttsp4_core.h
new file mode 100644
index 0000000..5626c70
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_core.h
@@ -0,0 +1,525 @@
+/*
+ * cyttsp4_core.h
+ * Cypress TrueTouch(TM) Standard Product V4 Core driver module.
+ * For use with Cypress Txx4xx parts.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2012 Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#ifndef _CYTTSP4_CORE_H
+#define _CYTTSP4_CORE_H
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define CY_FW_FILE_NAME "cyttsp4_fw.bin"
+
+#define CY_MAX_PRBUF_SIZE           PIPE_BUF
+#define CY_PR_TRUNCATED             " truncated..."
+
+#define CY_TMA1036_TCH_REC_SIZE     6
+#define CY_TMA4XX_TCH_REC_SIZE      9
+#define CY_TMA1036_MAX_TCH          0x0E
+#define CY_TMA4XX_MAX_TCH           0x1E
+
+#define GET_HSTMODE(reg)            ((reg & 0x70) >> 4)
+#define GET_TOGGLE(reg)             ((reg & 0x80) >> 7)
+#define IS_BOOTLOADER(reg)          ((reg) == 0x01)
+#define IS_EXCLUSIVE(dev)           ((dev) != NULL)
+#define IS_TMO(t)                   ((t) == 0)
+
+#define CY_REG_BASE                 0x00
+#define CY_NUM_REVCTRL              8
+#define CY_NUM_MFGID                8
+#define CY_NUM_TCHREC               10
+#define CY_NUM_DDATA                32
+#define CY_NUM_MDATA                64
+
+#define CY_REG_CAT_CMD              2
+#define CY_CMD_COMPLETE_MASK        (1 << 6)
+#define CY_CMD_MASK                 0x3F
+#define CY_EBID                     0
+
+/* touch record system information offset masks and shifts */
+#define CY_BYTE_OFS_MASK            0x1F
+#define CY_BOFS_MASK                0xE0
+#define CY_BOFS_SHIFT               5
+
+#define CY_REQUEST_EXCLUSIVE_TIMEOUT   500
+
+/* maximum number of concurrent tracks */
+#define CY_NUM_TCH_ID               10
+
+#define CY_ACTIVE_STYLUS_ID         10
+
+/* helpers */
+#define GET_NUM_TOUCHES(x)          ((x) & 0x1F)
+#define IS_LARGE_AREA(x)            ((x) & 0x20)
+#define IS_BAD_PKT(x)               ((x) & 0x20)
+
+#define CY_WATCHDOG_TIMEOUT msecs_to_jiffies(1000)
+
+/* drv_debug commands */
+#define CY_DBG_SUSPEND                  4
+#define CY_DBG_RESUME                   5
+#define CY_DBG_SOFT_RESET               97
+#define CY_DBG_RESET                    98
+
+enum cyttsp4_hst_mode_bits {
+       CY_HST_TOGGLE      = (1 << 7),
+       CY_HST_MODE_CHANGE = (1 << 3),
+       CY_HST_MODE        = (7 << 4),
+       CY_HST_OPERATE     = (0 << 4),
+       CY_HST_SYSINFO     = (1 << 4),
+       CY_HST_CAT         = (2 << 4),
+       CY_HST_LOWPOW      = (1 << 2),
+       CY_HST_SLEEP       = (1 << 1),
+       CY_HST_RESET       = (1 << 0),
+};
+
+enum cyttsp_cmd_bits {
+       CY_CMD_COMPLETE    = (1 << 6),
+};
+
+enum cyttsp4_cmd_cat {
+       CY_CMD_CAT_NULL,
+       CY_CMD_CAT_RESERVED_1,
+       CY_CMD_CAT_GET_CFG_BLK_SZ,
+       CY_CMD_CAT_READ_CFG_BLK,
+       CY_CMD_CAT_WRITE_CFG_BLK,
+       CY_CMD_CAT_RESERVED_2,
+       CY_CMD_CAT_LOAD_SELF_TEST_DATA,
+       CY_CMD_CAT_RUN_SELF_TEST,
+       CY_CMD_CAT_GET_SELF_TEST_RESULT,
+       CY_CMD_CAT_CALIBRATE_IDACS,
+       CY_CMD_CAT_INIT_BASELINES,
+       CY_CMD_CAT_EXEC_PANEL_SCAN,
+       CY_CMD_CAT_RETRIEVE_PANEL_SCAN,
+       CY_CMD_CAT_START_SENSOR_DATA_MODE,
+       CY_CMD_CAT_STOP_SENSOR_DATA_MODE,
+       CY_CMD_CAT_INT_PIN_MODE,
+       CY_CMD_CAT_RETRIEVE_DATA_STRUCTURE,
+       CY_CMD_CAT_VERIFY_CFG_BLK_CRC,
+       CY_CMD_CAT_RESERVED_N,
+};
+
+enum cyttsp4_tt_mode_bits {
+       CY_TT_BL     = (1 << 4),
+       CY_TT_INVAL  = (1 << 5),
+       CY_TT_CNTR   = (3 << 6),
+};
+
+enum cyttsp4_bl_status_bits {
+       CY_BL_CS_OK    = (1 << 0),
+       CY_BL_WDOG     = (1 << 1),
+       CY_BL_RUNNING  = (1 << 4),
+       CY_BL_BUSY     = (1 << 7),
+};
+
+/* times */
+#define CY_SCAN_PERIOD              40
+#define CY_BL_ENTER_TIME            100
+
+enum cyttsp4_mode {
+       CY_MODE_UNKNOWN      = 0,
+       CY_MODE_BOOTLOADER   = (1 << 1),
+       CY_MODE_OPERATIONAL  = (1 << 2),
+       CY_MODE_SYSINFO      = (1 << 3),
+       CY_MODE_CAT          = (1 << 4),
+       CY_MODE_STARTUP      = (1 << 5),
+       CY_MODE_LOADER       = (1 << 6),
+       CY_MODE_CHANGE_MODE  = (1 << 7),
+       CY_MODE_CHANGED      = (1 << 8),
+       CY_MODE_CMD_COMPLETE = (1 << 9),
+};
+
+enum cyttsp4_int_state {
+       CY_INT_IGNORE      = (1 << 0),
+       CY_INT_MODE_CHANGE = (1 << 1),
+       CY_INT_EXEC_CMD    = (1 << 2),
+       CY_INT_AWAKE       = (1 << 3),
+};
+
+enum cyttsp4_ic_grpnum {
+       CY_IC_GRPNUM_RESERVED,
+       CY_IC_GRPNUM_CMD_REGS,
+       CY_IC_GRPNUM_TCH_REP,
+       CY_IC_GRPNUM_DATA_REC,
+       CY_IC_GRPNUM_TEST_REC,
+       CY_IC_GRPNUM_PCFG_REC,
+       CY_IC_GRPNUM_TCH_PARM_VAL,
+       CY_IC_GRPNUM_TCH_PARM_SIZE,
+       CY_IC_GRPNUM_RESERVED1,
+       CY_IC_GRPNUM_RESERVED2,
+       CY_IC_GRPNUM_OPCFG_REC,
+       CY_IC_GRPNUM_DDATA_REC,
+       CY_IC_GRPNUM_MDATA_REC,
+       CY_IC_GRPNUM_TEST_REGS,
+       CY_IC_GRPNUM_BTN_KEYS,
+       CY_IC_GRPNUM_TTHE_REGS,
+       CY_IC_GRPNUM_NUM
+};
+
+#define CY_VKEYS_X 720
+#define CY_VKEYS_Y 1280
+
+enum cyttsp4_flags {
+       CY_FLAG_NONE = 0x00,
+       CY_FLAG_HOVER = 0x04,
+       CY_FLAG_FLIP = 0x08,
+       CY_FLAG_INV_X = 0x10,
+       CY_FLAG_INV_Y = 0x20,
+       CY_FLAG_VKEYS = 0x40,
+};
+
+enum cyttsp4_event_id {
+       CY_EV_NO_EVENT,
+       CY_EV_TOUCHDOWN,
+       CY_EV_MOVE,             /* significant displacement (> act dist) */
+       CY_EV_LIFTOFF,          /* record reports last position */
+};
+
+enum cyttsp4_object_id {
+       CY_OBJ_STANDARD_FINGER,
+       CY_OBJ_LARGE_OBJECT,
+       CY_OBJ_STYLUS,
+       CY_OBJ_HOVER,
+};
+
+#define CY_POST_CODEL_WDG_RST           0x01
+#define CY_POST_CODEL_CFG_DATA_CRC_FAIL 0x02
+#define CY_POST_CODEL_PANEL_TEST_FAIL   0x04
+
+#define CY_TEST_CMD_NULL                0
+
+/* test mode NULL command driver codes; D */
+enum cyttsp4_null_test_cmd_code {
+       CY_NULL_CMD_NULL,
+       CY_NULL_CMD_MODE,
+       CY_NULL_CMD_STATUS_SIZE,
+       CY_NULL_CMD_HANDSHAKE,
+       CY_NULL_CMD_LOW_POWER,
+};
+
+enum cyttsp4_test_mode {
+       CY_TEST_MODE_NORMAL_OP,         /* Send touch data to OS; normal op */
+       CY_TEST_MODE_CAT,               /* Configuration and Test */
+       CY_TEST_MODE_SYSINFO,           /* System information mode */
+       CY_TEST_MODE_CLOSED_UNIT,       /* Send scan data to sysfs */
+};
+
+struct cyttsp4_test_mode_params {
+       int cur_mode;
+       int cur_cmd;
+       size_t cur_status_size;
+};
+
+/* GEN4/SOLO Operational interface definitions */
+/* TTSP System Information interface definitions */
+struct cyttsp4_cydata {
+       u8 ttpidh;
+       u8 ttpidl;
+       u8 fw_ver_major;
+       u8 fw_ver_minor;
+       u8 revctrl[CY_NUM_REVCTRL];
+       u8 blver_major;
+       u8 blver_minor;
+       u8 jtag_si_id3;
+       u8 jtag_si_id2;
+       u8 jtag_si_id1;
+       u8 jtag_si_id0;
+       u8 mfgid_sz;
+       u8 mfg_id[CY_NUM_MFGID];
+       u8 cyito_idh;
+       u8 cyito_idl;
+       u8 cyito_verh;
+       u8 cyito_verl;
+       u8 ttsp_ver_major;
+       u8 ttsp_ver_minor;
+       u8 device_info;
+} __packed;
+
+struct cyttsp4_test {
+       u8 post_codeh;
+       u8 post_codel;
+} __packed;
+
+struct cyttsp4_pcfg {
+       u8 electrodes_x;
+       u8 electrodes_y;
+       u8 len_xh;
+       u8 len_xl;
+       u8 len_yh;
+       u8 len_yl;
+       u8 res_xh;
+       u8 res_xl;
+       u8 res_yh;
+       u8 res_yl;
+       u8 max_zh;
+       u8 max_zl;
+} __packed;
+
+enum cyttsp4_tch_abs { /* for ordering within the extracted touch data array */
+       CY_TCH_X,       /* X */
+       CY_TCH_Y,       /* Y */
+       CY_TCH_P,       /* P (Z) */
+       CY_TCH_T,       /* TOUCH ID */
+       CY_TCH_E,       /* EVENT ID */
+       CY_TCH_O,       /* OBJECT ID */
+       CY_TCH_W,       /* SIZE */
+       CY_TCH_MAJ,     /* TOUCH_MAJOR */
+       CY_TCH_MIN,     /* TOUCH_MINOR */
+       CY_TCH_OR,      /* ORIENTATION */
+       CY_TCH_NUM_ABS
+};
+
+static const char * const cyttsp4_tch_abs_string[] = {
+       [CY_TCH_X]      = "X",
+       [CY_TCH_Y]      = "Y",
+       [CY_TCH_P]      = "P",
+       [CY_TCH_T]      = "T",
+       [CY_TCH_E]      = "E",
+       [CY_TCH_O]      = "O",
+       [CY_TCH_W]      = "W",
+       [CY_TCH_MAJ]    = "MAJ",
+       [CY_TCH_MIN]    = "MIN",
+       [CY_TCH_OR]     = "OR",
+       [CY_TCH_NUM_ABS] = "INVALID"
+};
+
+#define CY_NUM_TCH_FIELDS       7
+#define CY_NUM_EXT_TCH_FIELDS   3
+
+struct cyttsp4_tch_rec_params {
+       u8 loc;
+       u8 size;
+} __packed;
+
+struct cyttsp4_opcfg {
+       u8 cmd_ofs;
+       u8 rep_ofs;
+       u8 rep_szh;
+       u8 rep_szl;
+       u8 num_btns;
+       u8 tt_stat_ofs;
+       u8 obj_cfg0;
+       u8 max_tchs;
+       u8 tch_rec_size;
+       struct cyttsp4_tch_rec_params tch_rec_old[CY_NUM_TCH_FIELDS];
+       u8 btn_rec_size;/* btn record size (in bytes) */
+       u8 btn_diff_ofs;/* btn data loc ,diff counts, (Op-Mode byte ofs) */
+       u8 btn_diff_size;/* btn size of diff counts (in bits) */
+       struct cyttsp4_tch_rec_params tch_rec_new[CY_NUM_EXT_TCH_FIELDS];
+} __packed;
+
+struct cyttsp4_sysinfo_data {
+       u8 hst_mode;
+       u8 reserved;
+       u8 map_szh;
+       u8 map_szl;
+       u8 cydata_ofsh;
+       u8 cydata_ofsl;
+       u8 test_ofsh;
+       u8 test_ofsl;
+       u8 pcfg_ofsh;
+       u8 pcfg_ofsl;
+       u8 opcfg_ofsh;
+       u8 opcfg_ofsl;
+       u8 ddata_ofsh;
+       u8 ddata_ofsl;
+       u8 mdata_ofsh;
+       u8 mdata_ofsl;
+} __packed;
+
+struct cyttsp4_sysinfo_ptr {
+       struct cyttsp4_cydata *cydata;
+       struct cyttsp4_test *test;
+       struct cyttsp4_pcfg *pcfg;
+       struct cyttsp4_opcfg *opcfg;
+       struct cyttsp4_ddata *ddata;
+       struct cyttsp4_mdata *mdata;
+} __packed;
+
+struct cyttsp4_touch {
+       int abs[CY_TCH_NUM_ABS];
+};
+
+struct cyttsp4_tch_abs_params {
+       size_t ofs;     /* abs byte offset */
+       size_t size;    /* size in bits */
+       size_t max;     /* max value */
+       size_t bofs;    /* bit offset */
+};
+
+#define CY_NORMAL_ORIGIN 0     /* upper, left corner */
+#define CY_INVERT_ORIGIN 1     /* lower, right corner */
+
+struct cyttsp4_sysinfo_ofs {
+       size_t chip_type;
+       size_t cmd_ofs;
+       size_t rep_ofs;
+       size_t rep_sz;
+       size_t num_btns;
+       size_t num_btn_regs;    /* ceil(num_btns/4) */
+       size_t tt_stat_ofs;
+       size_t tch_rec_size;
+       size_t obj_cfg0;
+       size_t max_tchs;
+       size_t mode_size;
+       size_t data_size;
+       size_t map_sz;
+       size_t max_x;
+       size_t x_origin;        /* left or right corner */
+       size_t max_y;
+       size_t y_origin;        /* upper or lower corner */
+       size_t max_p;
+       size_t cydata_ofs;
+       size_t test_ofs;
+       size_t pcfg_ofs;
+       size_t opcfg_ofs;
+       size_t ddata_ofs;
+       size_t mdata_ofs;
+       size_t cydata_size;
+       size_t test_size;
+       size_t pcfg_size;
+       size_t opcfg_size;
+       size_t ddata_size;
+       size_t mdata_size;
+       size_t btn_keys_size;
+       struct cyttsp4_tch_abs_params tch_abs[CY_TCH_NUM_ABS];
+       size_t btn_rec_size; /* btn record size (in bytes) */
+       size_t btn_diff_ofs;/* btn data loc ,diff counts, (Op-Mode byte ofs) */
+       size_t btn_diff_size;/* btn size of diff counts (in bits) */
+};
+
+/* button to keycode support */
+#define CY_NUM_BTN_PER_REG     4
+#define CY_NUM_BTN_EVENT_ID    4
+#define CY_BITS_PER_BTN                2
+
+enum cyttsp4_btn_state {
+       CY_BTN_RELEASED = 0,
+       CY_BTN_PRESSED = 1,
+       CY_BTN_NUM_STATE
+};
+
+struct cyttsp4_btn {
+       bool enabled;
+       int state;      /* CY_BTN_PRESSED, CY_BTN_RELEASED */
+       int key_code;
+};
+
+
+struct cyttsp4_sysinfo {
+       bool ready;
+       struct cyttsp4_sysinfo_data si_data;
+       struct cyttsp4_sysinfo_ptr si_ptrs;
+       struct cyttsp4_sysinfo_ofs si_ofs;
+       struct cyttsp4_btn *btn;        /* button states */
+       u8 *btn_rec_data;               /* button diff count data */
+       u8 *xy_mode;                    /* operational mode and status regs */
+       u8 *xy_data;                    /* operational touch regs */
+};
+
+struct cyttsp4_mt_data {
+       struct cyttsp4_mt_platform_data *pdata;
+       struct cyttsp4_sysinfo *si;
+       struct input_dev *input;
+       char phys[NAME_MAX];
+       int num_prv_tch;
+       int prv_tch_type;
+#ifdef VERBOSE_DEBUG
+       u8 pr_buf[CY_MAX_PRBUF_SIZE];
+#endif
+};
+
+enum cyttsp4_sleep_state {
+       SS_SLEEP_OFF,
+       SS_SLEEP_ON,
+       SS_SLEEPING,
+       SS_WAKING,
+};
+
+struct cyttsp4_core_data {
+       struct device *dev;
+       struct mutex system_lock;
+       enum cyttsp4_mode mode;
+       enum cyttsp4_sleep_state sleep_state;
+       int int_status;
+       int cmd_toggle;
+       spinlock_t spinlock;
+       struct cyttsp4_core_platform_data *pdata;
+       wait_queue_head_t wait_q;
+       wait_queue_head_t sleep_q;
+       int irq;
+       struct workqueue_struct *startup_work_q;
+       struct work_struct startup_work;
+       struct workqueue_struct *mode_change_work_q;
+       struct work_struct mode_change_work;
+       struct cyttsp4_sysinfo sysinfo;
+       struct cyttsp4_bus_ops *ops;
+       atomic_t ignore_irq;
+       bool irq_enabled;
+       struct work_struct work;
+       struct timer_list timer;
+       struct cyttsp4_mt_data md;
+       u8 *xfer_buf;
+#ifdef VERBOSE_DEBUG
+       u8 pr_buf[CY_MAX_PRBUF_SIZE];
+#endif
+};
+
+struct cyttsp4_bus_ops {
+       u16 bustype;
+       int (*write)(struct device *dev, u8 addr,
+               const void *buf, int size);
+       int (*read)(struct device *dev, u8 addr, void *buf, int size);
+};
+
+#ifdef VERBOSE_DEBUG
+extern void cyttsp4_pr_buf(struct device *dev, u8 *pr_buf, u8 *dptr, int size,
+                          const char *data_name);
+#else
+#define cyttsp4_pr_buf(a, b, c, d, e) do { } while (0)
+#endif
+
+extern int cyttsp4_probe(struct device *dev, struct cyttsp4_bus_ops *ops,
+               u8 *xfer_buf);
+extern void cyttsp4_remove(struct device *dev);
+extern const struct dev_pm_ops cyttsp4_pm_ops;
+
+static inline u8 *cyttsp4_get_xfer_buf(struct device *dev)
+{
+       struct cyttsp4_core_data *cd = dev_get_drvdata(dev);
+       return cd->xfer_buf;
+}
+
+#endif /* _CYTTSP4_CORE_H */
diff --git a/include/linux/input/cyttsp4.h b/include/linux/input/cyttsp4.h
new file mode 100644
index 0000000..12d200b
--- /dev/null
+++ b/include/linux/input/cyttsp4.h
@@ -0,0 +1,126 @@
+/*
+ * cyttsp4.h
+ * Cypress TrueTouch(TM) Standard Product V4 module.
+ * For use with Cypress Txx4xx parts.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2012 Cypress Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#ifndef _LINUX_CYTTSP4_H
+#define _LINUX_CYTTSP4_H
+
+#define CYTTSP4_CORE_NAME "cyttsp4_core"
+#define CYTTSP4_MT_NAME "cyttsp4_mt"
+
+#define CYTTSP4_STR(x) #x
+#define CYTTSP4_STRINGIFY(x) CYTTSP4_STR(x)
+
+#define CY_DRIVER_NAME TTDA
+#define CY_DRIVER_MAJOR 02
+#define CY_DRIVER_MINOR 01
+
+#define CY_DRIVER_REVCTRL 000004
+
+#define CY_DRIVER_VERSION                          \
+CYTTSP4_STRINGIFY(CY_DRIVER_NAME)                  \
+"." CYTTSP4_STRINGIFY(CY_DRIVER_MAJOR)             \
+"." CYTTSP4_STRINGIFY(CY_DRIVER_MINOR)             \
+"." CYTTSP4_STRINGIFY(CY_DRIVER_REVCTRL)
+
+#define CY_DRIVER_DATE "20120803"      /* YYYYMMDD */
+
+/* x-axis resolution of panel in pixels */
+#define CY_PCFG_RESOLUTION_X_MASK 0x7F
+
+/* y-axis resolution of panel in pixels */
+#define CY_PCFG_RESOLUTION_Y_MASK 0x7F
+
+/* x-axis, 0:origin is on left side of panel, 1: right */
+#define CY_PCFG_ORIGIN_X_MASK 0x80
+
+/* y-axis, 0:origin is on top side of panel, 1: bottom */
+#define CY_PCFG_ORIGIN_Y_MASK 0x80
+
+#define CY_TOUCH_SETTINGS_MAX 32
+
+struct touch_settings {
+       const uint8_t   *data;
+       uint32_t         size;
+       uint8_t         tag;
+} __packed;
+
+struct cyttsp4_core_platform_data {
+       int irq_gpio;
+       int rst_gpio;
+       int level_irq_udelay;
+       /* power is called before waking up and after sleeping
+        * to perform any external power related tasks
+        */
+       void (*power)(struct cyttsp4_core_platform_data *pdata,
+               int on, struct device *dev);
+       struct touch_settings *sett[CY_TOUCH_SETTINGS_MAX];
+};
+
+/* abs settings */
+#define CY_IGNORE_VALUE             0xFFFF
+
+/* abs signal capabilities offsets in the frameworks array */
+enum cyttsp4_sig_caps {
+       CY_SIGNAL_OST,
+       CY_MIN_OST,
+       CY_MAX_OST,
+       CY_FUZZ_OST,
+       CY_FLAT_OST,
+       CY_NUM_ABS_SET  /* number of signal capability fields */
+};
+
+/* abs axis signal offsets in the framworks array  */
+enum cyttsp4_sig_ost {
+       CY_ABS_X_OST,
+       CY_ABS_Y_OST,
+       CY_ABS_P_OST,
+       CY_ABS_W_OST,
+       CY_ABS_ID_OST,
+       CY_ABS_MAJ_OST,
+       CY_ABS_MIN_OST,
+       CY_ABS_OR_OST,
+       CY_NUM_ABS_OST  /* number of abs signals */
+};
+
+struct touch_framework {
+       const uint16_t  *abs;
+       uint8_t         size;
+       uint8_t         enable_vkeys;
+} __packed;
+
+struct cyttsp4_mt_platform_data {
+       struct touch_framework *frmwrk;
+       unsigned short flags;
+       char const *inp_dev_name;
+};
+
+struct cyttsp4_platform_data {
+       struct cyttsp4_core_platform_data *core_pdata;
+       struct cyttsp4_mt_platform_data *mt_pdata;
+};
+#endif /* _LINUX_CYTTSP4_H */
--
1.7.9.5


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
