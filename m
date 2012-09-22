Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2IVLGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:06:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53640 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2IVLGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:06:35 -0400
Message-ID: <505D9BB6.2000505@kernel.org>
Date: Sat, 22 Sep 2012 12:06:30 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Swapnil TIWARI <swapnil.tiwari@st.com>
CC: "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: iio: gyro: Add STMicroelectronics L3GD20 gyroscope
 device driver
References: <494E38452A01E745B763C5F242AAA2CCC5111C8FD9@SAFEX1MAIL1.st.com>
In-Reply-To: <494E38452A01E745B763C5F242AAA2CCC5111C8FD9@SAFEX1MAIL1.st.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 08:19 PM, Swapnil TIWARI wrote:
> Add STMicroelectronics L3GD20 gyroscope device driver
>
>
>
> Signed-off-by: Swapnil Tiwari <swapnil.tiwari@st.com <mailto:swapnil.tiwari@st.com>>

Hi, couple of standard bits first.

1) Make sure your code passes checkpatch.pl with no warnings
(only exception to this is over 80 character lines if you have a good
reason for doing that).  Of course this might be all down to point 2 :)

2) Check your email client settings (ideally send patches via git send-email
as that won't mess things up). I can hammer this into basic shape via dos2unix and
some find and replaces, but I'm not going to bother doing that a second time.
This email seemed to contain bother html and plain text which wasn't a great start.

If you are having real problems with email clients, then attaching the patch is
better than nothing.

Anyhow the below should be a cleanish copy of the patch you sent.

Also, don't put comments below the patch, I'll miss them.
On the note you put about this being in staging because all the other
gyro drivers were, be brave and put it straight into drivers/iio/gyro.
The others haven't moved because of any particular problems but more because
no one has gotten round to it!



Anyhow, as for the driver.

Mostly good, but a few points to address.

i2c fallback if smbus isn't available.  I don't think there are any parts
that need this anymore given the i2c core supports emulated smbus over i2c
and will fall back to it if the hardware support isn't there.  Get rid
of that and you can squish your read / write functions directly into the call
sites creately reducing the amount of code.

Drop the embrionic buffer interfaces out of here. Bring them in only when needed.

Should have far fewer explicit attributes given most are supported via the info_mask
bit of the chan_spec and relevant chunks in read_raw.

My immediate observation on this driver was that it was rather long for a simple
device with not buffer support.  The above comments should address this somewhat
and I'll take a closer look at the details in the next revision!

Thanks,

Jonathan
---
 drivers/staging/iio/gyro/Kconfig           |    9 +
 drivers/staging/iio/gyro/Makefile          |    3 +
 drivers/staging/iio/gyro/l3gd20.h          |  155 +++++
 drivers/staging/iio/gyro/l3gd20_gyr_core.c | 1030 ++++++++++++++++++++++++++++

If everything is in one file, drop the _core suffix.

4 files changed, 1197 insertions(+)
 create mode 100644 drivers/staging/iio/gyro/l3gd20.h
 create mode 100644 drivers/staging/iio/gyro/l3gd20_gyr_core.c

diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
index ea295b2..47698cb 100644
--- a/drivers/staging/iio/gyro/Kconfig
+++ b/drivers/staging/iio/gyro/Kconfig
@@ -46,4 +46,13 @@ config ADXRS450
 	  This driver can also be built as a module.  If so, the module
 	  will be called adxrs450.

+config L3GD20_GYR_IIO
+       tristate "STM L3GD20 3 Axis Digital Gyroscope Sensor I2C driver (iio)"
IIO
+       depends on I2C
+       help
+          Say yes here to build support for the STMicrolectronics L3GD20 3 Axis
+          Digital .
+          To compile this driver as a module, choose M here: the module
+          will be called l3gd20_gyr_iio.
+
 endmenu
diff --git a/drivers/staging/iio/gyro/Makefile b/drivers/staging/iio/gyro/Makefile
index 9ba5ec1..c5d2879 100644
--- a/drivers/staging/iio/gyro/Makefile
+++ b/drivers/staging/iio/gyro/Makefile
@@ -20,3 +20,6 @@ obj-$(CONFIG_ADIS16251) += adis16251.o

 adxrs450-y             := adxrs450_core.o
 obj-$(CONFIG_ADXRS450) += adxrs450.o
+
+l3gd20_gyr-y    := l3gd20_gyr_core.o
+obj-$(CONFIG_L3GD20_GYR_IIO) += l3gd20_gyr.o
diff --git a/drivers/staging/iio/gyro/l3gd20.h b/drivers/staging/iio/gyro/l3gd20.h
new file mode 100644
index 0000000..0092e88
--- /dev/null
+++ b/drivers/staging/iio/gyro/l3gd20.h
@@ -0,0 +1,155 @@
+/******************** (C) COPYRIGHT 2011 STMicroelectronics ********************
+*
+* File Name    : l3gd20_iio.h
+* Authors : MH - C&I BU - Application Team
+*         : Matteo Dameno (matteo.dameno@st.com<mailto:matteo.dameno@st.com>
+*         : author is willing to be considered the contact
+*         : and update points for the driver.
If you can edit this at all without the lawyers moaning then...
1) drop the version number, it won't mean anything to anyone looking at this in the
future.

If very brave, just just the standard copyright form you see if pretty much every
other driver.

+* Version : V.2.0.0
+* Date         : 2011/Aug/16
+* Description  : L3GD20 3 Axis Digital Gyroscope Sensor device driver iio
+*         :
+********************************************************************************
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
+* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
+* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
+* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
+* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
+* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
Hmm.. got to love lawyers...

+*
+*******************************************************************************/
+/*******************************************************************************
+Version History.
+ Revision 2.0.0: 2012/Nov/16
+  first ioo implementation;
typo, and don't bother. Version history is handled by git from here on.
This sort of comment section just gets left behind...

+*******************************************************************************/
+
+#ifndef __L3GD20_H__
+#define __L3GD20_H__
+
+
+#define L3GD20_GYR_DEV_NAME         "l3gd20_gyr_iio"
+
+#define L3GD20_GYR_FS_250DPS   0x00
+#define L3GD20_GYR_FS_500DPS   0x10
+#define L3GD20_GYR_FS_2000DPS  0x30
+

As defines go, can we not assume on is 1?
Or just drop this as you don't actually use it.
+#define L3GD20_GYR_ENABLED     1
+#define L3GD20_GYR_DISABLED    0
+
+
+#ifdef __KERNEL__
The fact this implies the above is useful to userspace is a
little ominous...

+
+/* to set gpios numb connected to gyro interrupt pins,
+ * the unused ones have to be set to -EINVAL
+ */
+#define DEFAULT_INT1_GPIO      (-EINVAL)
+#define DEFAULT_INT2_GPIO      (-EINVAL)
+
+#define SAD0L                  0x00
+#define SAD0H                  0x01
+#define L3GD20_GYR_I2C_SADROOT      0x35
+#define L3GD20_GYR_I2C_SAD_L        ((L3GD20_GYR_I2C_SADROOT<<1)|SAD0L)
+#define L3GD20_GYR_I2C_SAD_H        ((L3GD20_GYR_I2C_SADROOT<<1)|SAD0H)
+
+#define L3GD20_MIN_POLL_PERIOD_MS   2
+
+struct l3gd20_gyr_platform_data {
As ever with such init, exit callbacks, we need a comment of why these
would make sense and why for the power_on, power_off it can't be done
cleaning using say the regulators framework?
It's pretty unusual to have such callbacks these days in a driver.
+    int (*init)(void);
+    void (*exit)(void);
+    int (*power_on)(void);
+    int (*power_off)(void);
+    unsigned int poll_interval;
+    unsigned int min_interval;
+
+    u8 fs_range;
+    u8 sampling_frequency;
+
+    /* set gpio_int[1,2] either to the choosen gpio pin number or to -EINVAL
+    * if leaved unconnected
+    */
+    int gpio_int1;
+    int gpio_int2;       /* int for fifo */
Can't name it as such then?  int gpio_fifo for example?
+
+    /* axis mapping */
+    u8 axis_map_x;
+    u8 axis_map_y;
+    u8 axis_map_z;
+
+    u8 negate_x;
+    u8 negate_y;
+    u8 negate_z;
bitfield?
+};
+
+#ifdef CONFIG_IIO_RING_BUFFER
That's not existed for some time.... Roughly since the default
buffer stopped being a ring buffer.

So we have a load of stub code here for some future support?
If so drop it from this driver and add it only when it is used...

+/* At the moment triggers are only used for ring buffer
+ * filling. This may change!
+ */
Yikes, some one has been cutting and pasting...
+
+enum l3gd20_gyr_scan {
+    L3GD20_GYR_SCAN_GYR_X,
+    L3GD20_GYR_SCAN_GYR_Y,
+    L3GD20_GYR_SCAN_GYR_Z,
+};
+
+void l3gd20_gyr_remove_trigger(struct iio_dev *indio_dev);
+int l3gd20_gyr_probe_trigger(struct iio_dev *indio_dev);
+
+ssize_t l3gd20_gyr_read_data_from_ring(struct device *dev,
+                          struct device_attribute *attr,
+                          char *buf);
+
+
+int l3gd20_gyr_configure_ring(struct iio_dev *indio_dev);
+void l3gd20_gyr_unconfigure_ring(struct iio_dev *indio_dev);
+
+int l3gd20_gyr_initialize_ring(struct iio_ring_buffer *ring);
+void l3gd20_gyr_uninitialize_ring(struct iio_ring_buffer *ring);
+#else /* CONFIG_IIO_RING_BUFFER */
+
+static inline void l3gd20_gyr_remove_trigger(struct iio_dev *indio_dev)
+{
+}
+
+static inline int l3gd20_gyr_probe_trigger(struct iio_dev *indio_dev)
+{
+    return 0;
+}
+
+static inline ssize_t
+l3gd20_gyr_read_data_from_ring(struct device *dev,
+                     struct device_attribute *attr,
+                     char *buf)
+{
+    return 0;
+}
+
+static int l3gd20_gyr_configure_ring(struct iio_dev *indio_dev)
+{
+    return 0;
+}
+
+static inline void l3gd20_gyr_unconfigure_ring(struct iio_dev *indio_dev)
+{
+}
+/*
+static inline int l3gd20_gyr_initialize_ring(struct iio_ring_buffer *ring)
+{
+    return 0;
+}
+
+static inline void l3gd20_gyr_uninitialize_ring(struct iio_ring_buffer *ring)
+{
+}
+*/
+#endif /* CONFIG_IIO_RING_BUFFER */
+
+#endif /* __KERNEL__ */
+
+#endif  /* __L3GD20_H__ */
diff --git a/drivers/staging/iio/gyro/l3gd20_gyr_core.c b/drivers/staging/iio/gyro/l3gd20_gyr_core.c
new file mode 100644
index 0000000..65b6ffc
--- /dev/null
+++ b/drivers/staging/iio/gyro/l3gd20_gyr_core.c
@@ -0,0 +1,1030 @@
+/******************** (C) COPYRIGHT 2011 STMicroelectronics ********************
+*
+* File Name    : l3gd20_gyr_core_iio.c
+* Authors : MSH - Motion Mems BU - Application Team
+*         : Matteo Dameno (matteo.dameno@st.com<mailto:matteo.dameno@st.com>)
+*         : Swapnil Tiwari (swapnil.tiwari@st.com<mailto:swapnil.tiwari@st.com>)
+*         : Author is willing to be considered the contact
+*         : and update points for the driver.*
+* Version : V.2.0.0
+* Date         : 2011/Nov/16
+* Description  : L3GD20 3 Axis Digital Gyroscope Sensor device driver iio
+*         :
+********************************************************************************
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
+* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
+* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
+* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
+* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
+* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
+*
+********************************************************************************
+ Revision 2.0.0: 2012/Nov/16
+  first ioo implementation;
+
+*******************************************************************************/
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/input.h>
+#include <linux/uaccess.h>
+#include <linux/workqueue.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+#include <linux/moduleparam.h>
+#include "linux/iio/iio.h"
+#include "linux/iio/sysfs.h"
+#include "l3gd20.h"
+
+#define SENSITIVITY_250DPS     "8.75"          /**  mdps/counts */
+#define SENSITIVITY_500DPS     "17.50"         /**  mdps/counts */
+#define SENSITIVITY_2000DPS    "70.00"         /**  mdps/counts */
+
+#define SCALE_250DPS      "0.000153" /**  (rad/sec)/count */
+#define SCALE_500DPS      "0.000297" /**  (rad/sec)/count */
+#define SCALE_2000DPS          "0.001222" /**  (rad/sec)/count */
+
+#define GAIN_250DPS       "6548.089087"   /**  count/(rad/sec) */
+#define GAIN_500DPS       "3370.339971"   /**  count/(rad/sec) */
+#define GAIN_2000DPS      "818.511136"    /**  count/(rad/sec) */
+
+/* l3gd20 gyroscope registers */
+#define WHO_AM_I    (0x0F)
+
+#define CTRL_REG1   (0x20)          /* CTRL REG1 */
+#define CTRL_REG2   (0x21)          /* CTRL REG2 */
+#define CTRL_REG3   (0x22)          /* CTRL_REG3 */
+#define CTRL_REG4   (0x23)          /* CTRL_REG4 */
+#define CTRL_REG5   (0x24)          /* CTRL_REG5 */
+#define   REFERENCE  (0x25)          /* REFERENCE REG */
+
+#define OUT_X_LSB   (0x28)          /* 1st AXIS OUT REG of 6 */
+#define OUT_X_MSB   (0x29)
+#define OUT_Y_LSB   (0x2A)
+#define OUT_Y_MSB   (0x2B)
+#define OUT_Z_LSB   (0x2C)
+#define OUT_Z_MSB   (0x2D)
+#define   AXISDATA_REG    OUT_X_LSB
+
+#define   FIFO_CTRL_REG   (0x2E)          /* FIFO CONTROL REGISTER */
+#define FIFO_SRC_REG (0x2F)          /* FIFO SOURCE REGISTER */
+/* */
+
+/* CTRL_REG1 */
+#define ALL_ZEROES        (0x00)
+#define PM_OFF            (0x00)
+#define PM_NORMAL         (0x08)
+#define ENABLE_ALL_AXES        (0x07)
+#define ENABLE_NO_AXES         (0x00)
+#define BW00              (0x00)
+#define BW01              (0x10)
+#define BW10              (0x20)
+#define BW11              (0x30)
+#define CTRL_REG1_BW_MASK (0x30)
+#define ODR095            (0x00)  /* ODR = 95Hz */
+#define ODR190            (0x40)  /* ODR = 190Hz */
+#define ODR380            (0x80)  /* ODR = 380Hz */
+#define ODR760            (0xC0)  /* ODR = 760Hz */
+#define CTRL_REG1_ODR_MASK     (0xC0)
+
+
+/* CTRL_REG3 bits */
+#define   I2_DRDY              (0x08)
+#define   I2_WTM               (0x04)
+#define   I2_OVRUN        (0x02)
+#define   I2_EMPTY        (0x01)
+#define   I2_NONE              (0x00)
+#define   I2_MASK              (0x0F)
+
+/* CTRL_REG4 bits */
+#define   FS_MASK              (0x30)
+#define   BDU_ENABLE      (0x80)
+
+/* CTRL_REG5 bits */
+#define   FIFO_ENABLE          (0x40)
+#define HPF_ENALBE        (0x11)
+
+/* FIFO_CTRL_REG bits */
+#define   FIFO_MODE_MASK       (0xE0)
+#define   FIFO_MODE_BYPASS     (0x00)
+#define   FIFO_MODE_FIFO       (0x20)
+#define   FIFO_MODE_STREAM     (0x40)
+#define   FIFO_MODE_STR2FIFO   (0x60)
+#define   FIFO_MODE_BYPASS2STR (0x80)
+#define   FIFO_WATERMARK_MASK  (0x1F)
+
+#define FIFO_STORED_DATA_MASK  (0x1F)
+
+/* I2C multi read/write option*/
+#define I2C_AUTO_INCREMENT     (0x80)
+
+/* RESUME STATE INDICES */
+#define   RES_CTRL_REG1        0
+#define   RES_CTRL_REG2        1
+#define   RES_CTRL_REG3        2
+#define   RES_CTRL_REG4        3
+#define   RES_CTRL_REG5        4
+#define   RES_FIFO_CTRL_REG    5
+#define   RESUME_ENTRIES       6
+
Add a prefix to all the above defines. Otherwise you'll
get stung at somepoint by one of them turning up defined
elsewhere in the kernel.

L3GD20_RES_CTRL_REG1 etc.
+
+/** Registers Contents */
+#define WHOAMI_L3GD20     (0x00D4)   /* Expected content for WAI register*/
+
+
+struct output_rate {
+    unsigned int poll_rate_ms;
+    u8 sampling_rate_setting;
+    const char *hz_label;
+};
+
+static const struct output_rate l3gd20_gyr_odr_table[] = {
+
+    {    2,   ODR760|BW10,    "760"},
+    {    3,   ODR380|BW01,    "380"},
+    {    6,   ODR190|BW00,    "190"},
+    {    11,  ODR095|BW00,    "95"},
+};
+
+static struct l3gd20_gyr_platform_data default_l3gd20_gyr_pdata = {
+    .fs_range = L3GD20_GYR_FS_250DPS,
+    .axis_map_x = 0,
+    .axis_map_y = 1,
+    .axis_map_z = 2,
+    .negate_x = 0,
+    .negate_y = 0,
+    .negate_z = 0,
+
+    .gpio_int1 = DEFAULT_INT1_GPIO,
+    .gpio_int2 = DEFAULT_INT2_GPIO,      /* int for fifo */
+
Drop the blank line here
+};
+
+struct l3gd20_gyr_status {
+
blank line here adds nothing.
I'd like to see kernel-doc for this structure please.
+    struct work_struct              work_trigger_to_ring;
+    s64                        last_timestamp;
+    struct iio_dev                  *indio_dev;
+    struct iio_trigger              *trig;
+
+    struct i2c_client               *client;
+    struct l3gd20_gyr_platform_data      *pdata;
+    int                        use_smbus;
Would driver prefer this or not?  Unless I am going mad,
smbus is emulated on all i2c drivers anyway so not sure
if you'll ever need this check..
+
+    struct mutex                    lock;
+    int                        hw_initialized;
+
+    atomic_t                   enabled;
+
+    char const                 *scale;
+    char const                 *gain;
+
+    u8                         reg_addr;
+    u8                         resume_state[RESUME_ENTRIES];
+
+
+    int                        irq1;
+    int                        irq2;
+
+};
+
+static int l3gd20_gyr_i2c_read(struct l3gd20_gyr_status *data,
+                                    u8 *buf, int len)
+{
+    int ret;
+    u8 reg = buf[0];
+    u8 cmd = reg;
+
+    if (len > 1)
+          cmd = (I2C_AUTO_INCREMENT | reg);
+    if (data->use_smbus) {
+          if (len == 1) {
+               ret = i2c_smbus_read_byte_data(data->client, cmd);
+               buf[0] = ret & 0xff;
+#ifdef DEBUG
Loose these ifdefs as dev_dbg can be turned on and off as appropriate anyway.
Actually I'd drop this entirely as it doesn't really tell us much of use.
+               dev_dbg(&data->client->dev,
+                    "i2c_smbus_read_byte_data: ret=0x%02x, len:%d ,"
+                    "command=0x%02x, buf[0]=0x%02x\n",
+                    ret, len, cmd , buf[0]);
+#endif
+          } else if (len > 1) {
+               ret = i2c_smbus_read_i2c_block_data(data->client,
+                                          cmd, len, buf);
+#ifdef DEBUG
+               dev_dbg(&data->client->dev,
+                    "i2c_smbus_read_i2c_block_data: ret:%d len:%d, "
+                    "command=0x%02x, ",
+                    ret, len, cmd);
+               char ii;
+               for (ii = 0; ii < len; ii++)
+                    pr_debug("buf[%d]=0x%02x,\n", ii, buf[ii]);
+#endif
+          } else
+               ret = -1;
+
+          if (ret < 0) {
+               dev_err(&data->client->dev,
+                    "read transfer error: len:%d, command=0x%02x\n",
+                    len, cmd);
+               return 0; /* failure */
+          }
+          return len; /* success */
+    }
+
+
Clunky code, stick this in an else if actually needed so the flow
is more obvious.

+    ret = i2c_master_send(data->client, &cmd, sizeof(cmd));
+    if (ret != sizeof(cmd))
+          return ret;
+
+    return i2c_master_recv(data->client, buf, len);
+}
Both these functions rather look like they could be dropped entirely
and i23c_smbus_write_byte_data / i2c_smbus_write_block_data called
directly where approriate?
+
+static int l3gd20_gyr_i2c_write(struct l3gd20_gyr_status *data, u8 *buf,
+                                          int len)
+{
+    int ret;
+    u8 reg, value;
+
+    if (len > 1)
+          buf[0] = (I2C_AUTO_INCREMENT | buf[0]);
+
+    reg = buf[0];
+    value = buf[1];
+
+    if (data->use_smbus) {
+          if (len == 1) {
+               ret = i2c_smbus_write_byte_data(data->client, reg,
+                                               value);
+#ifdef DEBUG
+               dev_dbg(&data->client->dev,
+                    "i2c_smbus_write_byte_data: ret=%d, len:%d, "
+                    "command=0x%02x, value=0x%02x\n",
+                    ret, len, reg , value);
+#endif
+               return ret;
+          } else if (len > 1) {
+               ret = i2c_smbus_write_i2c_block_data(data->client,
+                                    reg, len, buf + 1);
+#ifdef DEBUG
+               dev_dbg(&data->client->dev,
+                    "i2c_smbus_write_i2c_block_data: ret=%d, "
+                    "len:%d, command=0x%02x, ",
+                    ret, len, reg);
+               char ii;
+               for (ii = 0; ii < len + 1; ii++)
+                    pr_debug("value[%d]=0x%02x,\n", ii, buf[ii]);
+#endif
+               return ret;
+          }
+    }
+
+    ret = i2c_master_send(data->client, buf, len+1);
+    return (ret == len+1) ? 0 : ret;
+}
+
+
+static int l3gd20_gyr_register_write(struct l3gd20_gyr_status *data,
+          u8 *buf, u8 reg_address, u8 new_value)
+{
+    int err;
+
+          /* Sets configuration register at reg_address
+          *  NOTE: this is a straight overwrite  */
+          buf[0] = reg_address;
+          buf[1] = new_value;
Ugly and will go away if you just support smbus and call
the right function directly here.

+          err = l3gd20_gyr_i2c_write(data, buf, 1);
+          if (err < 0)
+               return err;
+
+    return err;
+}
+
+static int l3gd20_gyr_register_read(struct l3gd20_gyr_status *data,
+                               u8 *buf, u8 reg_address)
+{
+
+    int err = -1;
+    buf[0] = (reg_address);
+    err = l3gd20_gyr_i2c_read(data, buf, 1);
+    return err;
+}
+
+#define L3GD20_INFO_MASK IIO_CHAN_INFO_RAW_SEPARATE_BIT
+
+#define L3GD20_CHAN(addr, mod)                      \
+    {                                    \
+          .type = IIO_ANGL_VEL,                \
+          .modified = 1,                       \
+          .channel2 = mod,                     \
+          .info_mask = L3GD20_INFO_MASK,             \
+          .address = addr,                     \

drop scan_type until you add buffered support.
+          .scan_type = {                       \
+               .sign = 's',                    \
+               .realbits = 16,                 \
+               .storagebits = 16,              \
+               .shift = 0,                     \
+          },                              \
+    }
+
+static struct iio_chan_spec l3gd20_channels[] = {
+    L3GD20_CHAN(OUT_X_LSB, IIO_MOD_X),
+    L3GD20_CHAN(OUT_Y_LSB, IIO_MOD_Y),
+    L3GD20_CHAN(OUT_Z_LSB, IIO_MOD_Z),
+};
+
+
+static int l3gd20_gyr_read_raw(struct iio_dev *indio_dev,
+                    struct iio_chan_spec const *chan,
+                    int *val,
+                    int *val2,
+                    long mask)
+{
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    int err;
+    u8 out_data[2];
+    s16 val16;
+    out_data[0] = chan->address;
+    switch  (mask) {
+    case IIO_CHAN_INFO_RAW:
+          mutex_lock(&data->lock);
+          err = l3gd20_gyr_i2c_read(data, out_data, 2);
+          mutex_unlock(&data->lock);
+          if (err < 0)
+               return err;
standard endian conversion so use be16_to_cpu (or appropriate alternative
I'm too sleepy to think about it.)
+          val16 = ((s16) ((out_data[1]) << 8) | out_data[0]);
+          *val = val16;
+          return IIO_VAL_INT;
+    default:
+          return -EINVAL;
+    }
+}
+
+static int l3gd20_gyr_register_update(struct l3gd20_gyr_status *data,
+          u8 *buf, u8 reg_address, u8 mask, u8 new_bit_values)
+{
+    int err = -1;
+    u8 init_val;
+    u8 updated_val;
+    err = l3gd20_gyr_register_read(data, buf, reg_address);
+    if (!(err < 0)) {
+          init_val = buf[0];
+          updated_val = ((mask & new_bit_values) | ((~mask) & init_val));
+          err = l3gd20_gyr_register_write(data, buf, reg_address,
+                    updated_val);
+    }
+    return err;
+}
+
+static int l3gd20_gyr_hw_init(struct l3gd20_gyr_status *dev_data)
+{
+    int err;
+    u8 buf[6];
+
+    pr_info("%s hw init\n", L3GD20_GYR_DEV_NAME);
+
+    buf[0] = (CTRL_REG1);
+    buf[1] = dev_data->resume_state[RES_CTRL_REG1];
+    buf[2] = dev_data->resume_state[RES_CTRL_REG2];
+    buf[3] = dev_data->resume_state[RES_CTRL_REG3];
+    buf[4] = dev_data->resume_state[RES_CTRL_REG4];
+    buf[5] = dev_data->resume_state[RES_CTRL_REG5];
+
+    err = l3gd20_gyr_i2c_write(dev_data, buf, 5);
+    if (err < 0)
+          return err;
+
+    buf[0] = FIFO_CTRL_REG;
+    buf[1] = dev_data->resume_state[RES_FIFO_CTRL_REG];
+    err = l3gd20_gyr_i2c_write(dev_data, buf, 1);
+    if (err < 0)
+               return err;
+
+    dev_data->hw_initialized = 1;
+
+    return err;
+}
+
+static void l3gd20_gyr_device_power_off(struct l3gd20_gyr_status *dev_data)
+{
+    int err;
+    u8 buf[2];
+
+    pr_info("%s power off\n", L3GD20_GYR_DEV_NAME);
+
+    buf[0] = CTRL_REG1;
+    buf[1] = PM_OFF;
+    err = l3gd20_gyr_i2c_write(dev_data, buf, 1);
+    if (err < 0)
+          dev_err(&dev_data->client->dev, "soft power off failed\n");
+
+    if (dev_data->pdata->power_off) {
+          dev_data->pdata->power_off();
+          dev_data->hw_initialized = 0;
+    }
+
+    if (dev_data->hw_initialized)
+          dev_data->hw_initialized = 0;
+}
+
+static int l3gd20_gyr_device_power_on(struct l3gd20_gyr_status *dev_data)
+{
+    int err;
+
+    if (dev_data->pdata->power_on) {
+          err = dev_data->pdata->power_on();
+          if (err < 0)
+               return err;
+    }
+
+
+    if (!dev_data->hw_initialized) {
+          err = l3gd20_gyr_hw_init(dev_data);
+          if (err < 0) {
+               l3gd20_gyr_device_power_off(dev_data);
+               return err;
+          }
+    }
+
+    return 0;
+}
+
+
+static int l3gd20_gyr_enable(struct l3gd20_gyr_status *dev_data)
+{
+    int err;
+
+    if (!atomic_cmpxchg(&dev_data->enabled, 0, 1)) {
+
+          err = l3gd20_gyr_device_power_on(dev_data);
+          if (err < 0) {
+               atomic_set(&dev_data->enabled, 0);
+               return err;
+          }
+
+    }
+
+    return 0;
+}
+
+static int l3gd20_gyr_disable(struct l3gd20_gyr_status *dev_data)
+{
+
+    pr_debug("%s: dev_data->enabled = %d\n", __func__,
+          atomic_read(&dev_data->enabled));
+
Nasty, I'd just go with a mutex..
+    if (atomic_cmpxchg(&dev_data->enabled, 1, 0))
+          l3gd20_gyr_device_power_off(dev_data);
+
+    return 0;
+}
+
+static int l3gd20_gyr_update_fs_range(struct l3gd20_gyr_status *dev_data,
+                                    u8 new_fs_range)
+{
+    int res ;
+    u8 buf[2];
+    char const *scale;
+    char const *gain;
+    buf[0] = CTRL_REG4;
+
+    switch (new_fs_range) {
+    case L3GD20_GYR_FS_250DPS:
+          gain = GAIN_250DPS;
+          scale = SCALE_250DPS;
+          break;
+
+    case L3GD20_GYR_FS_500DPS:
+          gain = GAIN_500DPS;
+          scale = SCALE_500DPS;
+          break;
+
+    case L3GD20_GYR_FS_2000DPS:
+          gain = GAIN_2000DPS;
+          scale = SCALE_2000DPS;
+          break;
+
+    default:
+          dev_err(&dev_data->client->dev,
+                          "invalid fs range requested: %u\n",
+                          new_fs_range);
+          return -EINVAL;
+    }
+
+    res = l3gd20_gyr_register_update(dev_data, buf, CTRL_REG4,
+                                    FS_MASK, new_fs_range);
+
+    if (res < 0) {
+          pr_err("%s : failed to update fs:0x%02x\n",
+                                    __func__, new_fs_range);
+          return res;
+    }
+    dev_data->resume_state[RES_CTRL_REG4] =
+          ((FS_MASK & new_fs_range) |
+          (~FS_MASK & dev_data->resume_state[RES_CTRL_REG4]));
+    dev_data->gain = gain;
+    dev_data->scale = scale;
+    return res;
+}
+
+static int l3gd20_gyr_update_sampling_freq(struct l3gd20_gyr_status *data,
+                                    u8 freq)
+{
+    int res = 0;
+    u8 buf[2];
+    u8 new_value;
+    u8 mask = (CTRL_REG1_ODR_MASK|CTRL_REG1_BW_MASK);
+
+
+    new_value = freq;
+    res = l3gd20_gyr_register_update(data, buf, CTRL_REG1,
+                                    mask, new_value);
+
+    if (res < 0) {
+          dev_err(&data->client->dev,
+               "%s : failed to update sampling frequency setting\n",
+                                          __func__);
+          return res;
+    }
+    dev_dbg(&data->client->dev, "%s : new_value:0x%02x, freq:0x%02x\n",
+               __func__, new_value, freq);
+
+    data->resume_state[RES_CTRL_REG1] =
+          ((mask & new_value) |
+          (~mask & data->resume_state[RES_CTRL_REG1]));
+
+    data->pdata->sampling_frequency = new_value;
+
+    return res;
+}
+
+static ssize_t l3gd20_gyr_show_sampling_frequency(struct device *dev,
+                               struct device_attribute *attr,
+                               char *buf)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    u8 i;
+    u8 val;
+
+
+    mutex_lock(&data->lock);
+    val = data->pdata->sampling_frequency;
+    mutex_unlock(&data->lock);
+    dev_dbg(dev, "getting sampling frequency: 0x%02x\n", val);
+
+    for (i = 0; i < ARRAY_SIZE(l3gd20_gyr_odr_table); i++)
+          if (l3gd20_gyr_odr_table[i].sampling_rate_setting == val)
+               break;
+
+    return sprintf(buf, "%s\n", l3gd20_gyr_odr_table[i].hz_label);
+}
+
+static ssize_t l3gd20_gyr_store_sampling_frequency(struct device *dev,
+                               struct device_attribute *attr,
+                               const char *buf, size_t size)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    u8 found = 0;
+    u8 i;
+    u8 ret;
+
+    for (i = 0; i < ARRAY_SIZE(l3gd20_gyr_odr_table); i++) {
+          if (strcmp(buf, l3gd20_gyr_odr_table[i].hz_label) == 0) {
+               found = 1;
+               break;
+          }
+    }
+
+    if (!found) {
+          dev_err(dev, "trying to set invalid sampling frequency: %s\n"
+                    "new sampling frequency not set!\n", buf);
+          return  -EINVAL;
+    } else {
+          mutex_lock(&data->lock);
+          ret = l3gd20_gyr_update_sampling_freq(data,
+               l3gd20_gyr_odr_table[i].sampling_rate_setting);
+          if (ret < 0)
+               goto error;
+          data->pdata->sampling_frequency =
+               l3gd20_gyr_odr_table[i].sampling_rate_setting;
+          dev_info(dev, "set new sampling frequency: %s Hz\n",
+                          l3gd20_gyr_odr_table[i].hz_label);
+          mutex_unlock(&data->lock);
+    }
+    return size;
+error:
+    mutex_unlock(&data->lock);
+    return ret;
+}
+
+
+static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+          l3gd20_gyr_show_sampling_frequency,
+          l3gd20_gyr_store_sampling_frequency);
+
+static ssize_t l3gd20_gyr_show_enable(struct device *dev,
+                      struct device_attribute *attr, char *buf)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    int val = atomic_read(&data->enabled);
+    return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t l3gd20_gyr_store_enable(struct device *dev,
+                      struct device_attribute *attr,
+                      const char *buf, size_t size)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    unsigned long val;
+
+    if (kstrtoul(buf, 10, &val))
+          return -EINVAL;
+
+    if (val)
+          l3gd20_gyr_enable(data);
+    else
+          l3gd20_gyr_disable(data);
+
+    return size;
+}
+
+static IIO_DEVICE_ATTR(enable_device,
+               S_IWUSR | S_IRUGO,
+               l3gd20_gyr_show_enable,
+               l3gd20_gyr_store_enable,
+               0);
+
+static ssize_t l3gd20_gyr_show_range(struct device *dev,
+                          struct device_attribute *attr,
+                          char *buf)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    int label = 0;
+    u8 val;
+    mutex_lock(&data->lock);
+    val = data->pdata->fs_range;
+    mutex_unlock(&data->lock);
+
+    switch (val) {
+    case L3GD20_GYR_FS_250DPS:
+          label = 250;
+          break;
+    case L3GD20_GYR_FS_500DPS:
+          label = 500;
+          break;
+    case L3GD20_GYR_FS_2000DPS:
+          label = 2000;
+          break;
+    }
+
+    return sprintf(buf, "%d dps\n", label);
+}
+
+static ssize_t l3gd20_gyr_store_range(struct device *dev,
+                            struct device_attribute *attr,
+                            const char *buf,
+                            size_t size)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    unsigned long val;
+    u8 range;
+    int err = -1;
+    if (kstrtoul(buf, 10, &val)) {
+          dev_err(dev, "invalid range %lu\n. Range not changed", val);
+          return -EINVAL;
+    }
+    switch (val) {
+    case 250:
+          range = L3GD20_GYR_FS_250DPS;
+          break;
+    case 500:
+         range = L3GD20_GYR_FS_500DPS;
+          break;
+    case 2000:
+          range = L3GD20_GYR_FS_2000DPS;
+          break;
+    default:
+          dev_err(dev, "invalid range %lu. Range not changed\n", val);
+          return -EINVAL;
+    }
+
+    mutex_lock(&data->lock);
+    data->pdata->fs_range = range;
+    err = l3gd20_gyr_update_fs_range(data, range);
+    mutex_unlock(&data->lock);
+    if (err < 0)
+          goto error;
+    dev_info(dev, "set range to %lu dps\n", val);
+    return size;
+error:
+    dev_err(dev, "error changing range\n");
+    return err;
+}
+
+
+
Not in the abi. Preference always for scale over range
(as we need it to do raw -> processed conversion) but
if you really want range, then in_gyro_range and do it
via the info mask (if the support isn't there, then propose
adding it).
+static IIO_DEVICE_ATTR(gyro_range,
+               S_IWUSR | S_IRUGO,
+               l3gd20_gyr_show_range,
+               l3gd20_gyr_store_range,
+               0);
+
+
+static IIO_CONST_ATTR(gyro_range_available, "250 500 2000");
+
+
+static ssize_t l3gd20_gyr_show_gain(struct device *dev,
+                               struct device_attribute *attr,
+                               char *buf)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    return sprintf(buf, "%s\n", data->gain);
+}
+
+static IIO_DEVICE_ATTR(gyro_gain, S_IRUGO,
+               l3gd20_gyr_show_gain,
+               NULL , 0);
+
+
+static ssize_t l3gd20_gyr_show_scale(struct device *dev,
+                          struct device_attribute *attr,
+                          char *buf)
+{
+    struct iio_dev *indio_dev = dev_get_drvdata(dev);
+    struct l3gd20_gyr_status *data = iio_priv(indio_dev);
+    return sprintf(buf, "%s\n", data->scale);
+}
+
+static IIO_DEVICE_ATTR(gyro_scale, S_IRUGO,
+               l3gd20_gyr_show_scale,
+               NULL , 0);
+
+static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("95 190 380 760");
+
+static IIO_CONST_ATTR(name, L3GD20_GYR_DEV_NAME);
+
+
+
+static struct attribute *l3gd20_gyr_attributes[] = {
+    &iio_const_attr_name.dev_attr.attr,
I think that's been handled by the iio core for some time
but then I may be half asleep this morning...

+    &iio_dev_attr_enable_device.dev_attr.attr,
+    &iio_const_attr_gyro_range_available.dev_attr.attr,
+    &iio_dev_attr_gyro_range.dev_attr.attr,
+    &iio_dev_attr_gyro_gain.dev_attr.attr,
+    &iio_dev_attr_gyro_scale.dev_attr.attr,
These aren't abi compliant and equivalents should mostly be
done via the info_mask and raw_read callback.
+    &iio_dev_attr_sampling_frequency.dev_attr.attr,
+    &iio_const_attr_sampling_frequency_available.dev_attr.attr,
+    NULL
+};
+
+static const struct attribute_group l3gd20_gyr_attribute_group = {
+    .attrs = l3gd20_gyr_attributes,
+};
+
+static const struct iio_info l3gd20_gyr_info = {
+    .attrs = &l3gd20_gyr_attribute_group,
+    .read_raw = &l3gd20_gyr_read_raw,
+    .driver_module = THIS_MODULE,
+};
+
+static int l3gd20_gyr_validate_pdata(struct l3gd20_gyr_status *dev_data)
+{
+
I'd be cynical and assume this was valid, but if you really want to
check I don't suppose it does any harm!
+    if (dev_data->pdata->axis_map_x > 2 ||
+        dev_data->pdata->axis_map_y > 2 ||
+        dev_data->pdata->axis_map_z > 2) {
+          dev_err(&dev_data->client->dev,
+               "invalid axis_map value x:%u y:%u z%u\n",
+               dev_data->pdata->axis_map_x,
+               dev_data->pdata->axis_map_y,
+               dev_data->pdata->axis_map_z);
+          return -EINVAL;
+    }
+

Just make negate a bit field and this won't be possible.

+    /* Only allow 0 and 1 for negation boolean flag */
+    if (dev_data->pdata->negate_x > 1 ||
+        dev_data->pdata->negate_y > 1 ||
+        dev_data->pdata->negate_z > 1) {
+          dev_err(&dev_data->client->dev,
+               "invalid negate value x:%u y:%u z:%u\n",
+               dev_data->pdata->negate_x,
+               dev_data->pdata->negate_y,
+               dev_data->pdata->negate_z);
+          return -EINVAL;
+    }
+
+    return 0;
+}
+
+static int l3gd20_gyr_probe(struct i2c_client *client,
+          const struct i2c_device_id *id)
+{
+    struct l3gd20_gyr_status *stat;
+    struct iio_dev *indio_dev;
+    int err = -1;
+    u32 smbus_func;
+    int regdone = 0;
+    indio_dev = iio_device_alloc(sizeof(*stat));
+    if (indio_dev == NULL) {
+          err = -ENOMEM;
+          dev_err(&client->dev,
+                    "failed to allocate memory for module stat: "
+                          "%d\n", err);
+          goto exit_check_functionality_failed;
+    }
+
+    stat = iio_priv(indio_dev);
+    smbus_func = I2C_FUNC_SMBUS_BYTE_DATA |
+               I2C_FUNC_SMBUS_WORD_DATA | I2C_FUNC_SMBUS_I2C_BLOCK;
+    pr_info("%s: probe start.\n", L3GD20_GYR_DEV_NAME);
+
+    /* Support for both I2C and SMBUS adapter interfaces. */
+    if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+          dev_warn(&client->dev, "client not i2c capable\n");
+          if (i2c_check_functionality(client->adapter, smbus_func)) {
+               stat->use_smbus = 1;
+               dev_warn(&client->dev, "client using SMBUS\n");
+          } else {
+               err = -ENODEV;
+               dev_err(&client->dev, "client nor SMBUS capable\n");
+               stat->use_smbus = 0;
+               goto exit_check_functionality_failed;
+          }
+    }
+
+    mutex_init(&stat->lock);
+    mutex_lock(&stat->lock);
+    stat->client = client;
+    i2c_set_clientdata(client, indio_dev);
+    stat->pdata = kmalloc(sizeof(*stat->pdata), GFP_KERNEL);
+    if (stat->pdata == NULL) {
+          err = -ENOMEM;
+          dev_err(&client->dev,
+                    "failed to allocate memory for pdata: %d\n",
+                    err);
+          goto err_mutexunlock;
+    }
+
+    if (client->dev.platform_data == NULL) {
+          memcpy(stat->pdata, &default_l3gd20_gyr_pdata,
+                                    sizeof(*stat->pdata));
+          dev_info(&client->dev, "using default platform data\n");
+    } else {
+          memcpy(stat->pdata, client->dev.platform_data,
+                                    sizeof(*stat->pdata));
+    }
+
+    err = l3gd20_gyr_validate_pdata(stat);
+    if (err < 0) {
+          dev_err(&client->dev, "failed to validate platform data\n");
+          goto exit_kfree_pdata;
+    }
+
+
+    if (stat->pdata->init) {
+          err = stat->pdata->init();
+          if (err < 0) {
+               dev_err(&client->dev, "init failed: %d\n", err);
+               goto err_pdata_init;
+          }
+    }
+
+    memset(stat->resume_state, 0, ARRAY_SIZE(stat->resume_state));
+
+    stat->resume_state[RES_CTRL_REG1] = (ALL_ZEROES | PM_NORMAL
+                                    | ENABLE_ALL_AXES);
+    stat->resume_state[RES_CTRL_REG2] = ALL_ZEROES;
+    stat->resume_state[RES_CTRL_REG3] = ALL_ZEROES;
+    stat->resume_state[RES_CTRL_REG4] = (ALL_ZEROES | BDU_ENABLE);
+    stat->resume_state[RES_CTRL_REG5] = ALL_ZEROES;
+    stat->resume_state[RES_FIFO_CTRL_REG] = ALL_ZEROES;
+
+    err = l3gd20_gyr_device_power_on(stat);
+    if (err < 0) {
+          dev_err(&client->dev, "power on failed: %d\n", err);
+          goto exit_kfree_pdata;
+    }
+
+    atomic_set(&stat->enabled, 1);
+
+    err = l3gd20_gyr_update_fs_range(stat, stat->pdata->fs_range);
+    if (err < 0) {
+          dev_err(&client->dev, "update_fs_range failed\n");
+          goto  err_power_off;
+    }
+
+    err = l3gd20_gyr_update_sampling_freq(stat,
+                          stat->pdata->sampling_frequency);
+    if (err < 0) {
+          dev_err(&client->dev, "update sampling freq failed\n");
+          goto  err_power_off;
+    }
+
+    indio_dev->dev.parent = &client->dev;
+    indio_dev->modes = INDIO_DIRECT_MODE;
+    indio_dev->info = &l3gd20_gyr_info;
+    indio_dev->channels = l3gd20_channels;
+    indio_dev->num_channels = ARRAY_SIZE(l3gd20_channels);
+
+    l3gd20_gyr_device_power_off(stat);
+
+    /* As default, do not report information */
+    atomic_set(&stat->enabled, 0);
+    err = l3gd20_gyr_configure_ring(indio_dev);
+    if (err)
+          goto error_free_dev;
+
+    err = iio_device_register(indio_dev);
+    if (err) {
+          dev_err(&client->dev, "error registering iio dev: %d\n", err);
+          goto error_unreg_ring_funcs;
+    }
+    regdone = 1;
+
+    mutex_unlock(&stat->lock);
+    dev_info(&client->dev, "%s: probed\n", L3GD20_GYR_DEV_NAME);
+    return 0;
+
+
+
Firstly you are unwinding this in a different order to creation
above.  Also, the ring stuff doesn't exist so get rid of it for
now and bring it in once we have a patch to make it do something.

+error_unreg_ring_funcs:
+    l3gd20_gyr_unconfigure_ring(stat->indio_dev);
+error_free_dev:
+    if (regdone)
+          iio_device_unregister(indio_dev);
+    else
+          iio_device_free(indio_dev);
+err_power_off:
+    l3gd20_gyr_device_power_off(stat);
+err_pdata_init:
+    if (stat->pdata->exit)
+          stat->pdata->exit();
+exit_kfree_pdata:
+    kfree(stat->pdata);
+err_mutexunlock:
+    mutex_unlock(&stat->lock);
+exit_check_functionality_failed:
+    pr_err("%s: Driver Init failed\n", L3GD20_GYR_DEV_NAME);
+    return err;
+}
+
+
+static int __devexit l3gd20_gyr_remove(struct i2c_client *client)
+{
+    struct iio_dev *indio_dev = i2c_get_clientdata(client);
+    struct l3gd20_gyr_status *dev_data = iio_priv(indio_dev);
+
+    iio_device_unregister(indio_dev);
+    l3gd20_gyr_device_power_off(dev_data);
+
+    l3gd20_gyr_unconfigure_ring(indio_dev);
+    iio_device_free(indio_dev);
+
+    return 0;
+}
+
+static const struct i2c_device_id l3gd20_gyr_id[] = {
+    { L3GD20_GYR_DEV_NAME , 0 },
+    {},
+};
+
+MODULE_DEVICE_TABLE(i2c, l3gd20_gyr_id);
+
+static struct i2c_driver l3gd20_gyr_driver = {
+    .driver = {
+               .owner = THIS_MODULE,
+               .name = L3GD20_GYR_DEV_NAME,
+            },
+    .probe = l3gd20_gyr_probe,
+    .remove = __devexit_p(l3gd20_gyr_remove),
+    .id_table = l3gd20_gyr_id,
+};
+
+module_i2c_driver(l3gd20_gyr_driver);
+
+MODULE_DESCRIPTION("STMicroelectronics l3gd20 digital gyroscope iio driver");
+MODULE_AUTHOR("Matteo Dameno, Swapnil Tiwari, STMicroelectronics");
+MODULE_LICENSE("GPL v2");
-- 
1.7.12
