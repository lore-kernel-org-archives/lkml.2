Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab1LEWgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:36:06 -0500
Received: from smtp.nokia.com ([147.243.1.48]:27403 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab1LEWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:36:04 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-main <linux-kernel@vger.kernel.org>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] mfd: add bq2415x charger driver
Date: Tue,  6 Dec 2011 00:35:41 +0200
Message-Id: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.8.rc3.17.gf56ef1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aliaksei Katovich <aliaksei.katovich@nokia.com>

Hi,

The Nokia N900 has a bunch of stuff regarding the battery: bq27x00 to find out
the status, and isp1704 to detect what kind of charger is connected to the USB
port. However, that doesn't charge the battery.

That's the job of bq24150. Up until now, this has been done by the closed and
proprietary BME application from user-space, which sends i2c commands directly.

Several people have tried to decipher what it's actually doing, and there are
some simple user-space scripts that manage to achieve charging:

  http://enivax.net/jk/n900/charge21.sh.txt

Aliaksei Katovich already sent a patch series, but they seem to be doing
something completely different (wrong?).

This simple driver does the work for me. It's doing basically the same as the
user-space scripts, but a bit more aligned to the spec sheet[1], and a bit more
understadable. It's a proof of concept, as it doesn't really change the voltage
or amperage depending on the type of charger as it should, but it at least it
achieves charging.

I have never writen a driver, so don't hold on the comments :)

Some inspiration from the code of Aliaksei Katovich.

Cheers.

[1] http://www.ti.com/lit/ds/symlink/bq24150.pdf

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    3 +
 drivers/mfd/Kconfig                          |    7 +
 drivers/mfd/Makefile                         |    1 +
 drivers/mfd/bq2415x.c                        |  173 ++++++++++++++++++++++++++
 4 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/bq2415x.c

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 973b631..bf827f4 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -925,6 +925,9 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
 		I2C_BOARD_INFO("bq27200", 0x55),
 	},
 #endif
+	{
+		I2C_BOARD_INFO("bq24150", 0x6b),
+	},
 };
 
 static int __init rx51_i2c_init(void)
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..300aadb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -772,6 +772,13 @@ config MFD_INTEL_MSIC
 	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
 	  devices used in Intel Medfield platforms.
 
+config MFD_BQ2415X
+	tristate "TI bq2415x one-cell Li-Ion charger"
+	depends on I2C
+	help
+	  This driver supports TI bq2415x integrated switch-mode chargers
+	  attached to i2c.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b2292eb..ce715d2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
+obj-$(CONFIG_MFD_BQ2415X)	+= bq2415x.o
diff --git a/drivers/mfd/bq2415x.c b/drivers/mfd/bq2415x.c
new file mode 100644
index 0000000..4382da6
--- /dev/null
+++ b/drivers/mfd/bq2415x.c
@@ -0,0 +1,173 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define BQ2415X_TIMEOUT 9
+
+#define BQ2415X_STS_CTL 0x00
+#define BQ2415X_TMR_RST BIT(7)
+
+#define BQ2415X_GEN_CTL 0x01
+#define BQ2415X_BAT_CTL 0x02
+#define BQ2415X_CHG_CTL 0x04
+
+#define BQ2415X_IIN_LIMIT_500_MASK 0x40
+#define BQ2415X_IIN_LIMIT_800_MASK 0x80
+#define BQ2415X_IIN_LIMIT_UNLIM_MASK 0xc0
+
+#define BQ2415X_IIN_LIMIT_100 100000
+#define BQ2415X_IIN_LIMIT_500 500000
+#define BQ2415X_IIN_LIMIT_800 800000
+#define BQ2415X_IIN_LIMIT_UNLIM 1500000
+
+#define BQ2415X_MIN_VOLTAGE 3500000
+#define BQ2415X_VOLTAGE_SCALE 20000
+#define BQ2415X_BAT_VOL_MASK 0xfc
+
+enum bq2415x_chip { BQ24150, BQ24151, BQ24153, BQ24156, BQ24158 };
+
+struct bq2415x_device_info {
+	struct i2c_client *cli;
+	struct delayed_work work;
+};
+
+static inline int bq2415x_i2c_read(struct i2c_client *cli, u8 reg)
+{
+	return i2c_smbus_read_byte_data(cli, reg);
+}
+
+static inline int bq2415x_i2c_write(struct i2c_client *cli, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(cli, reg, val);
+}
+
+static void bq2415x_timer(struct work_struct *work)
+{
+	struct bq2415x_device_info *di =
+		container_of(work, struct bq2415x_device_info, work.work);
+	struct i2c_client *cli = di->cli;
+	bq2415x_i2c_write(cli, BQ2415X_STS_CTL, BQ2415X_TMR_RST);
+	schedule_delayed_work(&di->work, BQ2415X_TIMEOUT * HZ);
+}
+
+static int bq2415x_set_current_limit(struct i2c_client *cli,
+		int min_uA, int max_uA)
+{
+	int res;
+
+	res = bq2415x_i2c_read(cli, BQ2415X_GEN_CTL);
+	if (res < 0)
+		return res;
+
+	res &= ~BQ2415X_IIN_LIMIT_UNLIM_MASK;
+
+	if (min_uA >= BQ2415X_IIN_LIMIT_100 && max_uA < BQ2415X_IIN_LIMIT_500)
+		;
+	else if (min_uA >= BQ2415X_IIN_LIMIT_500 && max_uA < BQ2415X_IIN_LIMIT_800)
+		res |= BQ2415X_IIN_LIMIT_500_MASK;
+	else if (min_uA >= BQ2415X_IIN_LIMIT_800 && max_uA < BQ2415X_IIN_LIMIT_UNLIM)
+		res |= BQ2415X_IIN_LIMIT_800_MASK;
+	else if (min_uA >= BQ2415X_IIN_LIMIT_UNLIM)
+		res |= BQ2415X_IIN_LIMIT_UNLIM_MASK;
+	else
+		return -EINVAL;
+
+	return bq2415x_i2c_write(cli, BQ2415X_GEN_CTL, res);
+}
+
+/* 3.5 - 4.44 (6 registers, pos 2) */
+static int bq2415x_set_voltage(struct i2c_client *cli,
+		int min_uV, int max_uV)
+{
+	int res;
+
+	if (max_uV >= 4400000)
+		return -EINVAL;
+
+	res = bq2415x_i2c_read(cli, BQ2415X_BAT_CTL);
+	if (res < 0)
+		return res;
+
+	res &= ~BQ2415X_BAT_VOL_MASK;
+	res |= ((max_uV - BQ2415X_MIN_VOLTAGE) / BQ2415X_VOLTAGE_SCALE) << 2;
+	return bq2415x_i2c_write(cli, BQ2415X_BAT_CTL, res);
+}
+
+static int bq2415x_probe(struct i2c_client *cli,
+		const struct i2c_device_id *id)
+{
+	struct bq2415x_device_info *di;
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&cli->dev, "failed to allocate device info data\n");
+		return -ENOMEM;
+	}
+
+	di->cli = cli;
+
+	i2c_set_clientdata(cli, di);
+
+	bq2415x_i2c_write(cli, BQ2415X_CHG_CTL, 0x42);
+
+	bq2415x_set_voltage(cli, 0, 4200000);
+
+	bq2415x_set_current_limit(cli, 1800000, 1800000);
+
+	/* seems we need to write something here to start charging */
+	bq2415x_i2c_write(cli, BQ2415X_STS_CTL, 0);
+
+	INIT_DELAYED_WORK(&di->work, bq2415x_timer);
+	schedule_delayed_work(&di->work, BQ2415X_TIMEOUT * HZ);
+
+	return 0;
+}
+
+static int bq2415x_remove(struct i2c_client *cli)
+{
+	struct bq2415x_device_info *di = i2c_get_clientdata(cli);
+	cancel_delayed_work_sync(&di->work);
+	kfree(di);
+	return 0;
+}
+
+static const struct i2c_device_id bq2415x_id[] = {
+	{ "bq24150", BQ24150 },
+	{ "bq24151", BQ24151 },
+	{ "bq24153", BQ24153 },
+	{ "bq24156", BQ24156 },
+	{ "bq24158", BQ24158 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, bq2415x_id);
+
+static struct i2c_driver bq2415x_driver = {
+	.driver = {
+		.name = "bq2415x",
+		.owner = THIS_MODULE,
+	},
+	.probe = bq2415x_probe,
+	.remove = bq2415x_remove,
+	.id_table = bq2415x_id,
+};
+
+static int __init bq2415x_init(void)
+{
+	return i2c_add_driver(&bq2415x_driver);
+}
+
+static void __exit bq2415x_exit(void)
+{
+	i2c_del_driver(&bq2415x_driver);
+}
+
+module_init(bq2415x_init);
+module_exit(bq2415x_exit);
+
+MODULE_AUTHOR("Felipe Contreras <felipe.contreras@gmail.com>");
+MODULE_DESCRIPTION("TI bq2415x one-cell Li-Ion charger driver");
+MODULE_LICENSE("GPL");
-- 
1.7.8.rc3.17.gf56ef1

