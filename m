Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1CDR45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:56:57 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37323 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1CDR4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:56:51 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 08/11] hwmon: (w83627ehf) Add support for Nuvoton NCT6775F and NCT6776F
Date: Fri, 4 Mar 2011 09:58:03 -0800
Message-ID: <1299261486-15190-9-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for NCT6775F and NCT6776F to the w83627ehf driver.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Tested-by: Ian Dobson <i.dobson@planet-ian.com> (for NCT6776F)
---
 Documentation/hwmon/w83627ehf |   59 +++-
 drivers/hwmon/w83627ehf.c     |  791 +++++++++++++++++++++++++++++++++-------
 2 files changed, 694 insertions(+), 156 deletions(-)

diff --git a/Documentation/hwmon/w83627ehf b/Documentation/hwmon/w83627ehf
index b634e98..76ffef9 100644
--- a/Documentation/hwmon/w83627ehf
+++ b/Documentation/hwmon/w83627ehf
@@ -22,6 +22,14 @@ Supported chips:
     Prefix: 'w83667hg'
     Addresses scanned: ISA address retrieved from Super I/O registers
     Datasheet: Available from Nuvoton upon request
+  * Nuvoton NCT6775F/W83667HG-I
+    Prefix: 'nct6775'
+    Addresses scanned: ISA address retrieved from Super I/O registers
+    Datasheet: Available from Nuvoton upon request
+  * Nuvoton NCT6776F
+    Prefix: 'nct6776'
+    Addresses scanned: ISA address retrieved from Super I/O registers
+    Datasheet: Available from Nuvoton upon request
 
 Authors:
         Jean Delvare <khali@linux-fr.org>
@@ -34,24 +42,28 @@ Description
 -----------
 
 This driver implements support for the Winbond W83627EHF, W83627EHG,
-W83627DHG, W83627DHG-P, W83667HG and W83667HG-B super I/O chips.
-We will refer to them collectively as Winbond chips.
-
-The chips implement three temperature sensors (up to four for 667HG-B),
-five fan rotation speed sensors, ten analog voltage sensors (only nine for the
-627DHG), one VID (6 pins for the 627EHF/EHG, 8 pins for the 627DHG and 667HG),
-alarms with beep warnings (control unimplemented), and some automatic fan
-regulation strategies (plus manual fan control mode).
-
-The temperature sensor sources on W82677HG-B are configurable. temp4 is only
-reported if its temperature source differs from the temperature sources of the
-other three temperature sensors. The configured source for each of the
-temperature sensors is reported in tempX_label.
+W83627DHG, W83627DHG-P, W83667HG, W83667HG-B, W83667HG-I (NCT6775F),
+and NCT6776F super I/O chips. We will refer to them collectively as
+Winbond chips.
+
+The chips implement three temperature sensors (up to four for 667HG-B, and nine
+for NCT6775F and NCT6776F), five fan rotation speed sensors, ten analog voltage
+sensors (only nine for the 627DHG), one VID (6 pins for the 627EHF/EHG, 8 pins
+for the 627DHG and 667HG), alarms with beep warnings (control unimplemented),
+and some automatic fan regulation strategies (plus manual fan control mode).
+
+The temperature sensor sources on W82677HG-B, NCT6775F, and NCT6776F are
+configurable. temp4 and higher attributes are only reported if its temperature
+source differs from the temperature sources of the already reported temperature
+sensors. The configured source for each of the temperature sensors is provided
+in tempX_label.
 
 Temperatures are measured in degrees Celsius and measurement resolution is 1
-degC for temp1 and temp4, and 0.5 degC for temp2 and temp3. An alarm is
-triggered when the temperature gets higher than high limit; it stays on until
-the temperature falls below the hysteresis value.
+degC for temp1 and and 0.5 degC for temp2 and temp3. For temp4 and higher,
+resolution is 1 degC for W83667HG-B and 0.0 degC for NCT6775F and NCT6776F.
+An alarm is triggered when the temperature gets higher than high limit;
+it stays on until the temperature falls below the hysteresis value.
+Alarms are only supported for temp1, temp2, and temp3.
 
 Fan rotation speeds are reported in RPM (rotations per minute). An alarm is
 triggered if the rotation speed has dropped below a programmable limit. Fan
@@ -83,7 +95,8 @@ prog  -> pwm4 (not on 667HG and 667HG-B; the programmable setting is not
 
 name - this is a standard hwmon device entry. For the W83627EHF and W83627EHG,
        it is set to "w83627ehf", for the W83627DHG it is set to "w83627dhg",
-       and for the W83667HG it is set to "w83667hg".
+       for the W83667HG and W83667HG-B it is set to "w83667hg", for NCT6775F it
+       is set to "nct6775", and for NCT6776F it is set to "nct6776".
 
 pwm[1-4] - this file stores PWM duty cycle or DC value (fan speed) in range:
 	   0 (stop) to 255 (full)
@@ -93,6 +106,18 @@ pwm[1-4]_enable - this file controls mode of fan/temperature control:
 	* 2 "Thermal Cruise" mode
 	* 3 "Fan Speed Cruise" mode
 	* 4 "Smart Fan III" mode
+	* 5 "Smart Fan IV" mode
+
+	SmartFan III mode is not supported on NCT6776F.
+
+	SmartFan IV mode is configurable only if it was configured at system
+	startup, and is only supported for W83677HG-B, NCT6775F, and NCT6776F.
+	SmartFan IV operational parameters can not be configured at this time,
+	and the various pwm attributes are not used in SmartFan IV mode.
+	The attributes can be written to, which is useful if you plan to
+	configure the system for a different pwm mode. However, the information
+	returned when reading pwm attributes is unrelated to SmartFan IV
+	operation.
 
 pwm[1-4]_mode - controls if output is PWM or DC level
         * 0 DC output (0 - 12v)
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 2f17f99..b3b4f2b 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -6,6 +6,7 @@
 			Rudolf Marek <r.marek@assembler.cz>
 			David Hubbard <david.c.hubbard@gmail.com>
 			Daniel J Blueman <daniel.blueman@gmail.com>
+    Copyright (C) 2010  Sheng-Yuan Huang (Nuvoton) (PS00)
 
     Shamelessly ripped from the w83627hf driver
     Copyright (C) 2003  Mark Studebaker
@@ -40,6 +41,8 @@
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
     w83667hg-b   9      5       3       4      0xb350 0xc1    0x5ca3
+    nct6775f     9      4       3       9      0xb470 0xc1    0x5ca3
+    nct6776f     9      5       3       9      0xC330 0xc1    0x5ca3
 */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -58,7 +61,8 @@
 #include <linux/io.h>
 #include "lm75.h"
 
-enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg, w83667hg_b };
+enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg, w83667hg_b, nct6775,
+	nct6776 };
 
 /* used to set data->name = w83627ehf_device_names[data->sio_kind] */
 static const char * const w83627ehf_device_names[] = {
@@ -67,6 +71,8 @@ static const char * const w83627ehf_device_names[] = {
 	"w83627dhg",
 	"w83667hg",
 	"w83667hg",
+	"nct6775",
+	"nct6776",
 };
 
 static unsigned short force_id;
@@ -96,6 +102,8 @@ MODULE_PARM_DESC(force_id, "Override the detected device ID");
 #define SIO_W83627DHG_P_ID	0xb070
 #define SIO_W83667HG_ID		0xa510
 #define SIO_W83667HG_B_ID	0xb350
+#define SIO_NCT6775_ID		0xb470
+#define SIO_NCT6776_ID		0xc330
 #define SIO_ID_MASK		0xFFF0
 
 static inline void
@@ -176,6 +184,10 @@ static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252, 0 };
 #define W83627EHF_REG_DIODE		0x59
 #define W83627EHF_REG_SMI_OVT		0x4C
 
+/* NCT6775F has its own fan divider registers */
+#define NCT6775_REG_FANDIV1		0x506
+#define NCT6775_REG_FANDIV2		0x507
+
 #define W83627EHF_REG_ALARM1		0x459
 #define W83627EHF_REG_ALARM2		0x45A
 #define W83627EHF_REG_ALARM3		0x45B
@@ -214,6 +226,28 @@ static const u16 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
 static const u16 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[]
 						= { 0x68, 0x6a, 0x6c };
 
+static const u16 NCT6775_REG_TARGET[] = { 0x101, 0x201, 0x301 };
+static const u16 NCT6775_REG_FAN_MODE[] = { 0x102, 0x202, 0x302 };
+static const u16 NCT6775_REG_FAN_STOP_OUTPUT[] = { 0x105, 0x205, 0x305 };
+static const u16 NCT6775_REG_FAN_START_OUTPUT[] = { 0x106, 0x206, 0x306 };
+static const u16 NCT6775_REG_FAN_STOP_TIME[] = { 0x107, 0x207, 0x307 };
+static const u16 NCT6775_REG_PWM[] = { 0x109, 0x209, 0x309 };
+static const u16 NCT6775_REG_FAN_MAX_OUTPUT[] = { 0x10a, 0x20a, 0x30a };
+static const u16 NCT6775_REG_FAN_STEP_OUTPUT[] = { 0x10b, 0x20b, 0x30b };
+static const u16 NCT6776_REG_FAN[] = { 0x630, 0x632, 0x634, 0x636, 0x638 };
+static const u16 NCT6776_REG_FAN_MIN[] = { 0x63a, 0x63c, 0x63e, 0x640, 0x642};
+
+static const u16 NCT6775_REG_TEMP[]
+	= { 0x27, 0x150, 0x250, 0x73, 0x75, 0x77, 0x62b, 0x62c, 0x62d };
+static const u16 NCT6775_REG_TEMP_CONFIG[]
+	= { 0, 0x152, 0x252, 0, 0, 0, 0x628, 0x629, 0x62A };
+static const u16 NCT6775_REG_TEMP_HYST[]
+	= { 0x3a, 0x153, 0x253, 0, 0, 0, 0x673, 0x678, 0x67D };
+static const u16 NCT6775_REG_TEMP_OVER[]
+	= { 0x39, 0x155, 0x255, 0, 0, 0, 0x672, 0x677, 0x67C };
+static const u16 NCT6775_REG_TEMP_SOURCE[]
+	= { 0x621, 0x622, 0x623, 0x100, 0x200, 0x300, 0x624, 0x625, 0x626 };
+
 static const char *const w83667hg_b_temp_label[] = {
 	"SYSTIN",
 	"CPUTIN",
@@ -225,15 +259,71 @@ static const char *const w83667hg_b_temp_label[] = {
 	"PECI Agent 4"
 };
 
-#define NUM_REG_TEMP	4
+static const char *const nct6775_temp_label[] = {
+	"",
+	"SYSTIN",
+	"CPUTIN",
+	"AUXTIN",
+	"AMD SB-TSI",
+	"PECI Agent 0",
+	"PECI Agent 1",
+	"PECI Agent 2",
+	"PECI Agent 3",
+	"PECI Agent 4",
+	"PECI Agent 5",
+	"PECI Agent 6",
+	"PECI Agent 7",
+	"PCH_CHIP_CPU_MAX_TEMP",
+	"PCH_CHIP_TEMP",
+	"PCH_CPU_TEMP",
+	"PCH_MCH_TEMP",
+	"PCH_DIM0_TEMP",
+	"PCH_DIM1_TEMP",
+	"PCH_DIM2_TEMP",
+	"PCH_DIM3_TEMP"
+};
+
+static const char *const nct6776_temp_label[] = {
+	"",
+	"SYSTIN",
+	"CPUTIN",
+	"AUXTIN",
+	"SMBUSMASTER 0",
+	"SMBUSMASTER 1",
+	"SMBUSMASTER 2",
+	"SMBUSMASTER 3",
+	"SMBUSMASTER 4",
+	"SMBUSMASTER 5",
+	"SMBUSMASTER 6",
+	"SMBUSMASTER 7",
+	"PECI Agent 0",
+	"PECI Agent 1",
+	"PCH_CHIP_CPU_MAX_TEMP",
+	"PCH_CHIP_TEMP",
+	"PCH_CPU_TEMP",
+	"PCH_MCH_TEMP",
+	"PCH_DIM0_TEMP",
+	"PCH_DIM1_TEMP",
+	"PCH_DIM2_TEMP",
+	"PCH_DIM3_TEMP",
+	"BYTE_TEMP"
+};
+
+#define NUM_REG_TEMP	ARRAY_SIZE(NCT6775_REG_TEMP)
 
 static inline int is_word_sized(u16 reg)
 {
-	return (((reg & 0xff00) == 0x100
+	return ((((reg & 0xff00) == 0x100
 	      || (reg & 0xff00) == 0x200)
 	     && ((reg & 0x00ff) == 0x50
 	      || (reg & 0x00ff) == 0x53
-	      || (reg & 0x00ff) == 0x55));
+	      || (reg & 0x00ff) == 0x55))
+	     || (reg & 0xfff0) == 0x630
+	     || reg == 0x640 || reg == 0x642
+	     || ((reg & 0xfff0) == 0x650
+		 && (reg & 0x000f) >= 0x06)
+	     || reg == 0x73 || reg == 0x75 || reg == 0x77
+		);
 }
 
 /*
@@ -253,11 +343,20 @@ static inline u8 step_time_to_reg(unsigned int msec, u8 mode)
 }
 
 static inline unsigned int
-fan_from_reg(u8 reg, unsigned int div)
+fan_from_reg(int reg, u16 val, unsigned int div)
 {
-	if (reg == 0 || reg == 255)
+	if (val == 0)
 		return 0;
-	return 1350000U / (reg * div);
+	if (is_word_sized(reg)) {
+		if ((val & 0xff1f) == 0xff1f)
+			return 0;
+		val = (val & 0x1f) | ((val & 0xff00) >> 3);
+	} else {
+		if (val == 255 || div == 0)
+			return 0;
+		val *= div;
+	}
+	return 1350000U / val;
 }
 
 static inline unsigned int
@@ -274,7 +373,7 @@ temp_from_reg(u16 reg, s16 regval)
 	return regval * 1000;
 }
 
-static inline s16
+static inline u16
 temp_to_reg(u16 reg, long temp)
 {
 	if (is_word_sized(reg))
@@ -308,6 +407,10 @@ struct w83627ehf_data {
 	struct device *hwmon_dev;
 	struct mutex lock;
 
+	u16 reg_temp[NUM_REG_TEMP];
+	u16 reg_temp_over[NUM_REG_TEMP];
+	u16 reg_temp_hyst[NUM_REG_TEMP];
+	u16 reg_temp_config[NUM_REG_TEMP];
 	u8 temp_src[NUM_REG_TEMP];
 	const char * const *temp_label;
 
@@ -331,14 +434,15 @@ struct w83627ehf_data {
 	u8 in[10];		/* Register value */
 	u8 in_max[10];		/* Register value */
 	u8 in_min[10];		/* Register value */
-	u8 fan[5];
-	u8 fan_min[5];
+	u16 fan[5];
+	u16 fan_min[5];
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
+	u8 has_fan_min;		/* some fans don't have min register */
 	u8 temp_type[3];
-	s16 temp[4];
-	s16 temp_max[4];
-	s16 temp_max_hyst[4];
+	s16 temp[9];
+	s16 temp_max[9];
+	s16 temp_max_hyst[9];
 	u32 alarms;
 
 	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
@@ -364,7 +468,7 @@ struct w83627ehf_data {
 	u8 vid;
 	u8 vrm;
 
-	u8 have_temp;
+	u16 have_temp;
 	u8 in6_skip;
 };
 
@@ -429,6 +533,34 @@ static int w83627ehf_write_value(struct w83627ehf_data *data, u16 reg,
 }
 
 /* This function assumes that the caller holds data->update_lock */
+static void nct6775_write_fan_div(struct w83627ehf_data *data, int nr)
+{
+	u8 reg;
+
+	switch (nr) {
+	case 0:
+		reg = (w83627ehf_read_value(data, NCT6775_REG_FANDIV1) & 0x70)
+		    | (data->fan_div[0] & 0x7);
+		w83627ehf_write_value(data, NCT6775_REG_FANDIV1, reg);
+		break;
+	case 1:
+		reg = (w83627ehf_read_value(data, NCT6775_REG_FANDIV1) & 0x7)
+		    | ((data->fan_div[1] << 4) & 0x70);
+		w83627ehf_write_value(data, NCT6775_REG_FANDIV1, reg);
+	case 2:
+		reg = (w83627ehf_read_value(data, NCT6775_REG_FANDIV2) & 0x70)
+		    | (data->fan_div[2] & 0x7);
+		w83627ehf_write_value(data, NCT6775_REG_FANDIV2, reg);
+		break;
+	case 3:
+		reg = (w83627ehf_read_value(data, NCT6775_REG_FANDIV2) & 0x7)
+		    | ((data->fan_div[3] << 4) & 0x70);
+		w83627ehf_write_value(data, NCT6775_REG_FANDIV2, reg);
+		break;
+	}
+}
+
+/* This function assumes that the caller holds data->update_lock */
 static void w83627ehf_write_fan_div(struct w83627ehf_data *data, int nr)
 {
 	u8 reg;
@@ -479,6 +611,32 @@ static void w83627ehf_write_fan_div(struct w83627ehf_data *data, int nr)
 	}
 }
 
+static void w83627ehf_write_fan_div_common(struct device *dev,
+					   struct w83627ehf_data *data, int nr)
+{
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
+
+	if (sio_data->kind == nct6776)
+		; /* no dividers, do nothing */
+	else if (sio_data->kind == nct6775)
+		nct6775_write_fan_div(data, nr);
+	else
+		w83627ehf_write_fan_div(data, nr);
+}
+
+static void nct6775_update_fan_div(struct w83627ehf_data *data)
+{
+	u8 i;
+
+	i = w83627ehf_read_value(data, NCT6775_REG_FANDIV1);
+	data->fan_div[0] = i & 0x7;
+	data->fan_div[1] = (i & 0x70) >> 4;
+	i = w83627ehf_read_value(data, NCT6775_REG_FANDIV2);
+	data->fan_div[2] = i & 0x7;
+	if (data->has_fan & (1<<3))
+		data->fan_div[3] = (i & 0x70) >> 4;
+}
+
 static void w83627ehf_update_fan_div(struct w83627ehf_data *data)
 {
 	int i;
@@ -504,10 +662,79 @@ static void w83627ehf_update_fan_div(struct w83627ehf_data *data)
 	}
 }
 
+static void w83627ehf_update_fan_div_common(struct device *dev,
+					    struct w83627ehf_data *data)
+{
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
+
+	if (sio_data->kind == nct6776)
+		; /* no dividers, do nothing */
+	else if (sio_data->kind == nct6775)
+		nct6775_update_fan_div(data);
+	else
+		w83627ehf_update_fan_div(data);
+}
+
+static void nct6775_update_pwm(struct w83627ehf_data *data)
+{
+	int i;
+	int pwmcfg, fanmodecfg;
+
+	for (i = 0; i < data->pwm_num; i++) {
+		pwmcfg = w83627ehf_read_value(data,
+					      W83627EHF_REG_PWM_ENABLE[i]);
+		fanmodecfg = w83627ehf_read_value(data,
+						  NCT6775_REG_FAN_MODE[i]);
+		data->pwm_mode[i] =
+		  ((pwmcfg >> W83627EHF_PWM_MODE_SHIFT[i]) & 1) ? 0 : 1;
+		data->pwm_enable[i] = ((fanmodecfg >> 4) & 7) + 1;
+		data->tolerance[i] = fanmodecfg & 0x0f;
+		data->pwm[i] = w83627ehf_read_value(data, data->REG_PWM[i]);
+	}
+}
+
+static void w83627ehf_update_pwm(struct w83627ehf_data *data)
+{
+	int i;
+	int pwmcfg = 0, tolerance = 0; /* shut up the compiler */
+
+	for (i = 0; i < data->pwm_num; i++) {
+		if (!(data->has_fan & (1 << i)))
+			continue;
+
+		/* pwmcfg, tolerance mapped for i=0, i=1 to same reg */
+		if (i != 1) {
+			pwmcfg = w83627ehf_read_value(data,
+					W83627EHF_REG_PWM_ENABLE[i]);
+			tolerance = w83627ehf_read_value(data,
+					W83627EHF_REG_TOLERANCE[i]);
+		}
+		data->pwm_mode[i] =
+			((pwmcfg >> W83627EHF_PWM_MODE_SHIFT[i]) & 1) ? 0 : 1;
+		data->pwm_enable[i] = ((pwmcfg >> W83627EHF_PWM_ENABLE_SHIFT[i])
+				       & 3) + 1;
+		data->pwm[i] = w83627ehf_read_value(data, data->REG_PWM[i]);
+
+		data->tolerance[i] = (tolerance >> (i == 1 ? 4 : 0)) & 0x0f;
+	}
+}
+
+static void w83627ehf_update_pwm_common(struct device *dev,
+					struct w83627ehf_data *data)
+{
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
+
+	if (sio_data->kind == nct6775 || sio_data->kind == nct6776)
+		nct6775_update_pwm(data);
+	else
+		w83627ehf_update_pwm(data);
+}
+
 static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 {
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
-	int pwmcfg = 0, tolerance = 0; /* shut up the compiler */
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
+
 	int i;
 
 	mutex_lock(&data->update_lock);
@@ -515,7 +742,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 	if (time_after(jiffies, data->last_updated + HZ + HZ/2)
 	 || !data->valid) {
 		/* Fan clock dividers */
-		w83627ehf_update_fan_div(data);
+		w83627ehf_update_fan_div_common(dev, data);
 
 		/* Measured voltages and limits */
 		for (i = 0; i < data->in_num; i++) {
@@ -533,23 +760,29 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 				continue;
 
 			data->fan[i] = w83627ehf_read_value(data,
-				       data->REG_FAN[i]);
-			data->fan_min[i] = w83627ehf_read_value(data,
+							    data->REG_FAN[i]);
+
+			if (data->has_fan_min & (1 << i))
+				data->fan_min[i] = w83627ehf_read_value(data,
 					   data->REG_FAN_MIN[i]);
 
 			/* If we failed to measure the fan speed and clock
 			   divider can be increased, let's try that for next
 			   time */
-			if (data->fan[i] == 0xff
-			 && data->fan_div[i] < 0x07) {
+			if (!is_word_sized(data->REG_FAN[i])
+			    && (data->fan[i] == 0xff
+				|| (sio_data->kind == nct6775
+				    && data->fan[i] == 0x00))
+			    && data->fan_div[i] < 0x07) {
 				dev_dbg(dev, "Increasing fan%d "
 					"clock divider from %u to %u\n",
 					i + 1, div_from_reg(data->fan_div[i]),
 					div_from_reg(data->fan_div[i] + 1));
 				data->fan_div[i]++;
-				w83627ehf_write_fan_div(data, i);
+				w83627ehf_write_fan_div_common(dev, data, i);
 				/* Preserve min limit if possible */
-				if (data->fan_min[i] >= 2
+				if ((data->has_fan_min & (1 << i))
+				 && data->fan_min[i] >= 2
 				 && data->fan_min[i] != 255)
 					w83627ehf_write_value(data,
 						data->REG_FAN_MIN[i],
@@ -557,64 +790,54 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			}
 		}
 
+		w83627ehf_update_pwm_common(dev, data);
+
 		for (i = 0; i < data->pwm_num; i++) {
 			if (!(data->has_fan & (1 << i)))
 				continue;
 
-			/* pwmcfg, tolerance mapped for i=0, i=1 to same reg */
-			if (i != 1) {
-				pwmcfg = w83627ehf_read_value(data,
-						W83627EHF_REG_PWM_ENABLE[i]);
-				tolerance = w83627ehf_read_value(data,
-						W83627EHF_REG_TOLERANCE[i]);
-			}
-			data->pwm_mode[i] =
-				((pwmcfg >> W83627EHF_PWM_MODE_SHIFT[i]) & 1)
-				? 0 : 1;
-			data->pwm_enable[i] =
-				((pwmcfg >> W83627EHF_PWM_ENABLE_SHIFT[i])
-				& 3) + 1;
-			data->pwm[i] = w83627ehf_read_value(data,
-							    data->REG_PWM[i]);
-			data->fan_start_output[i] = w83627ehf_read_value(data,
-					data->REG_FAN_START_OUTPUT[i]);
-			data->fan_stop_output[i] = w83627ehf_read_value(data,
-					data->REG_FAN_STOP_OUTPUT[i]);
-			data->fan_stop_time[i] = w83627ehf_read_value(data,
-					data->REG_FAN_STOP_TIME[i]);
-
-			if (data->REG_FAN_MAX_OUTPUT[i] != 0xff)
+			data->fan_start_output[i] =
+			  w83627ehf_read_value(data,
+					       data->REG_FAN_START_OUTPUT[i]);
+			data->fan_stop_output[i] =
+			  w83627ehf_read_value(data,
+					       data->REG_FAN_STOP_OUTPUT[i]);
+			data->fan_stop_time[i] =
+			  w83627ehf_read_value(data,
+					       data->REG_FAN_STOP_TIME[i]);
+
+			if (data->REG_FAN_MAX_OUTPUT &&
+			    data->REG_FAN_MAX_OUTPUT[i] != 0xff)
 				data->fan_max_output[i] =
 				  w83627ehf_read_value(data,
-					       data->REG_FAN_MAX_OUTPUT[i]);
+						data->REG_FAN_MAX_OUTPUT[i]);
 
-			if (data->REG_FAN_STEP_OUTPUT[i] != 0xff)
+			if (data->REG_FAN_STEP_OUTPUT &&
+			    data->REG_FAN_STEP_OUTPUT[i] != 0xff)
 				data->fan_step_output[i] =
 				  w83627ehf_read_value(data,
-					       data->REG_FAN_STEP_OUTPUT[i]);
+						data->REG_FAN_STEP_OUTPUT[i]);
 
 			data->target_temp[i] =
 				w83627ehf_read_value(data,
 					data->REG_TARGET[i]) &
 					(data->pwm_mode[i] == 1 ? 0x7f : 0xff);
-			data->tolerance[i] = (tolerance >> (i == 1 ? 4 : 0))
-									& 0x0f;
 		}
 
 		/* Measured temperatures and limits */
 		for (i = 0; i < NUM_REG_TEMP; i++) {
 			if (!(data->have_temp & (1 << i)))
 				continue;
-			data->temp[i]
-			  = w83627ehf_read_value(data, W83627EHF_REG_TEMP[i]);
-			if (i > 2)
-				break;
-			data->temp_max[i]
-			  = w83627ehf_read_value(data,
-						 W83627EHF_REG_TEMP_OVER[i]);
-			data->temp_max_hyst[i]
-			  = w83627ehf_read_value(data,
-						 W83627EHF_REG_TEMP_HYST[i]);
+			data->temp[i] = w83627ehf_read_value(data,
+						data->reg_temp[i]);
+			if (data->reg_temp_over[i])
+				data->temp_max[i]
+				  = w83627ehf_read_value(data,
+						data->reg_temp_over[i]);
+			if (data->reg_temp_hyst[i])
+				data->temp_max_hyst[i]
+				  = w83627ehf_read_value(data,
+						data->reg_temp_hyst[i]);
 		}
 
 		data->alarms = w83627ehf_read_value(data,
@@ -736,21 +959,29 @@ static struct sensor_device_attribute sda_in_max[] = {
 	SENSOR_ATTR(in9_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 9),
 };
 
-#define show_fan_reg(reg) \
-static ssize_t \
-show_##reg(struct device *dev, struct device_attribute *attr, \
-	   char *buf) \
-{ \
-	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = \
-		to_sensor_dev_attr(attr); \
-	int nr = sensor_attr->index; \
-	return sprintf(buf, "%d\n", \
-		       fan_from_reg(data->reg[nr], \
-				    div_from_reg(data->fan_div[nr]))); \
+static ssize_t
+show_fan(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct w83627ehf_data *data = w83627ehf_update_device(dev);
+	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
+	int nr = sensor_attr->index;
+	return sprintf(buf, "%d\n",
+		       fan_from_reg(data->REG_FAN[nr],
+				    data->fan[nr],
+				    div_from_reg(data->fan_div[nr])));
+}
+
+static ssize_t
+show_fan_min(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct w83627ehf_data *data = w83627ehf_update_device(dev);
+	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
+	int nr = sensor_attr->index;
+	return sprintf(buf, "%d\n",
+		       fan_from_reg(data->REG_FAN_MIN[nr],
+				    data->fan_min[nr],
+				    div_from_reg(data->fan_div[nr])));
 }
-show_fan_reg(fan);
-show_fan_reg(fan_min);
 
 static ssize_t
 show_fan_div(struct device *dev, struct device_attribute *attr,
@@ -779,6 +1010,18 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	mutex_lock(&data->update_lock);
+	if (is_word_sized(data->REG_FAN_MIN[nr])) {
+		if (!val) {
+			val = 0xff1f;
+		} else {
+			if (val > 1350000U)
+				val = 135000U;
+			val = 1350000U / val;
+			val = (val & 0x1f) | ((val << 3) & 0xff00);
+		}
+		data->fan_min[nr] = val;
+		goto done;	/* Leave fan divider alone */
+	}
 	if (!val) {
 		/* No min limit, alarm disabled */
 		data->fan_min[nr] = 255;
@@ -790,14 +1033,16 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 		data->fan_min[nr] = 254;
 		new_div = 7; /* 128 == (1 << 7) */
 		dev_warn(dev, "fan%u low limit %lu below minimum %u, set to "
-			 "minimum\n", nr + 1, val, fan_from_reg(254, 128));
+			 "minimum\n", nr + 1, val,
+			 fan_from_reg(data->REG_FAN_MIN[nr], 254, 128));
 	} else if (!reg) {
 		/* Speed above this value cannot possibly be represented,
 		   even with the lowest divider (1) */
 		data->fan_min[nr] = 1;
 		new_div = 0; /* 1 == (1 << 0) */
 		dev_warn(dev, "fan%u low limit %lu above maximum %u, set to "
-			 "maximum\n", nr + 1, val, fan_from_reg(1, 1));
+			 "maximum\n", nr + 1, val,
+			 fan_from_reg(data->REG_FAN_MIN[nr], 1, 1));
 	} else {
 		/* Automatically pick the best divider, i.e. the one such
 		   that the min limit will correspond to a register value
@@ -827,10 +1072,11 @@ store_fan_min(struct device *dev, struct device_attribute *attr,
 			nr + 1, div_from_reg(data->fan_div[nr]),
 			div_from_reg(new_div));
 		data->fan_div[nr] = new_div;
-		w83627ehf_write_fan_div(data, nr);
+		w83627ehf_write_fan_div_common(dev, data, nr);
 		/* Give the chip time to sample a new speed value */
 		data->last_updated = jiffies;
 	}
+done:
 	w83627ehf_write_value(data, data->REG_FAN_MIN[nr],
 			      data->fan_min[nr]);
 	mutex_unlock(&data->update_lock);
@@ -884,7 +1130,7 @@ show_temp_label(struct device *dev, struct device_attribute *attr, char *buf)
 	return sprintf(buf, "%s\n", data->temp_label[data->temp_src[nr]]);
 }
 
-#define show_temp_reg(REG, reg) \
+#define show_temp_reg(addr, reg) \
 static ssize_t \
 show_##reg(struct device *dev, struct device_attribute *attr, \
 	   char *buf) \
@@ -894,13 +1140,13 @@ show_##reg(struct device *dev, struct device_attribute *attr, \
 		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
-		       temp_from_reg(W83627EHF_REG_##REG[nr], data->reg[nr])); \
+		       temp_from_reg(data->addr[nr], data->reg[nr])); \
 }
-show_temp_reg(TEMP, temp);
-show_temp_reg(TEMP_OVER, temp_max);
-show_temp_reg(TEMP_HYST, temp_max_hyst);
+show_temp_reg(reg_temp, temp);
+show_temp_reg(reg_temp_over, temp_max);
+show_temp_reg(reg_temp_hyst, temp_max_hyst);
 
-#define store_temp_reg(REG, reg) \
+#define store_temp_reg(addr, reg) \
 static ssize_t \
 store_##reg(struct device *dev, struct device_attribute *attr, \
 	    const char *buf, size_t count) \
@@ -915,14 +1161,14 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	if (err < 0) \
 		return err; \
 	mutex_lock(&data->update_lock); \
-	data->reg[nr] = temp_to_reg(W83627EHF_REG_TEMP_##REG[nr], val); \
-	w83627ehf_write_value(data, W83627EHF_REG_TEMP_##REG[nr], \
+	data->reg[nr] = temp_to_reg(data->addr[nr], val); \
+	w83627ehf_write_value(data, data->addr[nr], \
 			      data->reg[nr]); \
 	mutex_unlock(&data->update_lock); \
 	return count; \
 }
-store_temp_reg(OVER, temp_max);
-store_temp_reg(HYST, temp_max_hyst);
+store_temp_reg(reg_temp_over, temp_max);
+store_temp_reg(reg_temp_hyst, temp_max_hyst);
 
 static ssize_t
 show_temp_type(struct device *dev, struct device_attribute *attr, char *buf)
@@ -938,6 +1184,11 @@ static struct sensor_device_attribute sda_temp_input[] = {
 	SENSOR_ATTR(temp2_input, S_IRUGO, show_temp, NULL, 1),
 	SENSOR_ATTR(temp3_input, S_IRUGO, show_temp, NULL, 2),
 	SENSOR_ATTR(temp4_input, S_IRUGO, show_temp, NULL, 3),
+	SENSOR_ATTR(temp5_input, S_IRUGO, show_temp, NULL, 4),
+	SENSOR_ATTR(temp6_input, S_IRUGO, show_temp, NULL, 5),
+	SENSOR_ATTR(temp7_input, S_IRUGO, show_temp, NULL, 6),
+	SENSOR_ATTR(temp8_input, S_IRUGO, show_temp, NULL, 7),
+	SENSOR_ATTR(temp9_input, S_IRUGO, show_temp, NULL, 8),
 };
 
 static struct sensor_device_attribute sda_temp_label[] = {
@@ -945,6 +1196,11 @@ static struct sensor_device_attribute sda_temp_label[] = {
 	SENSOR_ATTR(temp2_label, S_IRUGO, show_temp_label, NULL, 1),
 	SENSOR_ATTR(temp3_label, S_IRUGO, show_temp_label, NULL, 2),
 	SENSOR_ATTR(temp4_label, S_IRUGO, show_temp_label, NULL, 3),
+	SENSOR_ATTR(temp5_label, S_IRUGO, show_temp_label, NULL, 4),
+	SENSOR_ATTR(temp6_label, S_IRUGO, show_temp_label, NULL, 5),
+	SENSOR_ATTR(temp7_label, S_IRUGO, show_temp_label, NULL, 6),
+	SENSOR_ATTR(temp8_label, S_IRUGO, show_temp_label, NULL, 7),
+	SENSOR_ATTR(temp9_label, S_IRUGO, show_temp_label, NULL, 8),
 };
 
 static struct sensor_device_attribute sda_temp_max[] = {
@@ -954,6 +1210,18 @@ static struct sensor_device_attribute sda_temp_max[] = {
 		    store_temp_max, 1),
 	SENSOR_ATTR(temp3_max, S_IRUGO | S_IWUSR, show_temp_max,
 		    store_temp_max, 2),
+	SENSOR_ATTR(temp4_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 3),
+	SENSOR_ATTR(temp5_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 4),
+	SENSOR_ATTR(temp6_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 5),
+	SENSOR_ATTR(temp7_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 6),
+	SENSOR_ATTR(temp8_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 7),
+	SENSOR_ATTR(temp9_max, S_IRUGO | S_IWUSR, show_temp_max,
+		    store_temp_max, 8),
 };
 
 static struct sensor_device_attribute sda_temp_max_hyst[] = {
@@ -963,6 +1231,18 @@ static struct sensor_device_attribute sda_temp_max_hyst[] = {
 		    store_temp_max_hyst, 1),
 	SENSOR_ATTR(temp3_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
 		    store_temp_max_hyst, 2),
+	SENSOR_ATTR(temp4_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 3),
+	SENSOR_ATTR(temp5_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 4),
+	SENSOR_ATTR(temp6_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 5),
+	SENSOR_ATTR(temp7_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 6),
+	SENSOR_ATTR(temp8_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 7),
+	SENSOR_ATTR(temp9_max_hyst, S_IRUGO | S_IWUSR, show_temp_max_hyst,
+		    store_temp_max_hyst, 8),
 };
 
 static struct sensor_device_attribute sda_temp_alarm[] = {
@@ -1048,6 +1328,7 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
 	unsigned long val;
@@ -1060,12 +1341,25 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 
 	if (!val || (val > 4 && val != data->pwm_enable_orig[nr]))
 		return -EINVAL;
+	/* SmartFan III mode is not supported on NCT6776F */
+	if (sio_data->kind == nct6776 && val == 4)
+		return -EINVAL;
+
 	mutex_lock(&data->update_lock);
-	reg = w83627ehf_read_value(data, W83627EHF_REG_PWM_ENABLE[nr]);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x03 << W83627EHF_PWM_ENABLE_SHIFT[nr]);
-	reg |= (val - 1) << W83627EHF_PWM_ENABLE_SHIFT[nr];
-	w83627ehf_write_value(data, W83627EHF_REG_PWM_ENABLE[nr], reg);
+	if (sio_data->kind == nct6775 || sio_data->kind == nct6776) {
+		reg = w83627ehf_read_value(data,
+					   NCT6775_REG_FAN_MODE[nr]);
+		reg &= 0x0f;
+		reg |= (val - 1) << 4;
+		w83627ehf_write_value(data,
+				      NCT6775_REG_FAN_MODE[nr], reg);
+	} else {
+		reg = w83627ehf_read_value(data, W83627EHF_REG_PWM_ENABLE[nr]);
+		reg &= ~(0x03 << W83627EHF_PWM_ENABLE_SHIFT[nr]);
+		reg |= (val - 1) << W83627EHF_PWM_ENABLE_SHIFT[nr];
+		w83627ehf_write_value(data, W83627EHF_REG_PWM_ENABLE[nr], reg);
+	}
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -1113,6 +1407,7 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
 	int nr = sensor_attr->index;
 	u16 reg;
@@ -1127,13 +1422,22 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 	val = SENSORS_LIMIT(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
 
 	mutex_lock(&data->update_lock);
-	reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
-	data->tolerance[nr] = val;
-	if (nr == 1)
-		reg = (reg & 0x0f) | (val << 4);
-	else
+	if (sio_data->kind == nct6775 || sio_data->kind == nct6776) {
+		/* Limit tolerance further for NCT6776F */
+		if (sio_data->kind == nct6776 && val > 7)
+			val = 7;
+		reg = w83627ehf_read_value(data, NCT6775_REG_FAN_MODE[nr]);
 		reg = (reg & 0xf0) | val;
-	w83627ehf_write_value(data, W83627EHF_REG_TOLERANCE[nr], reg);
+		w83627ehf_write_value(data, NCT6775_REG_FAN_MODE[nr], reg);
+	} else {
+		reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
+		if (nr == 1)
+			reg = (reg & 0x0f) | (val << 4);
+		else
+			reg = (reg & 0xf0) | val;
+		w83627ehf_write_value(data, W83627EHF_REG_TOLERANCE[nr], reg);
+	}
+	data->tolerance[nr] = val;
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -1350,7 +1654,8 @@ static void w83627ehf_device_remove_files(struct device *dev)
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_max_step_arrays); i++) {
 		struct sensor_device_attribute *attr =
 		  &sda_sf3_max_step_arrays[i];
-		if (data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff)
+		if (data->REG_FAN_STEP_OUTPUT &&
+		    data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff)
 			device_remove_file(dev, &attr->dev_attr);
 	}
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays_fan4); i++)
@@ -1381,10 +1686,10 @@ static void w83627ehf_device_remove_files(struct device *dev)
 			continue;
 		device_remove_file(dev, &sda_temp_input[i].dev_attr);
 		device_remove_file(dev, &sda_temp_label[i].dev_attr);
-		if (i > 2)
-			break;
 		device_remove_file(dev, &sda_temp_max[i].dev_attr);
 		device_remove_file(dev, &sda_temp_max_hyst[i].dev_attr);
+		if (i > 2)
+			continue;
 		device_remove_file(dev, &sda_temp_alarm[i].dev_attr);
 		device_remove_file(dev, &sda_temp_type[i].dev_attr);
 	}
@@ -1409,13 +1714,13 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
 	for (i = 0; i < NUM_REG_TEMP; i++) {
 		if (!(data->have_temp & (1 << i)))
 			continue;
-		if (!W83627EHF_REG_TEMP_CONFIG[i])
+		if (!data->reg_temp_config[i])
 			continue;
 		tmp = w83627ehf_read_value(data,
-					   W83627EHF_REG_TEMP_CONFIG[i]);
+					   data->reg_temp_config[i]);
 		if (tmp & 0x01)
 			w83627ehf_write_value(data,
-					      W83627EHF_REG_TEMP_CONFIG[i],
+					      data->reg_temp_config[i],
 					      tmp & 0xfe);
 	}
 
@@ -1434,13 +1739,39 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
 	}
 }
 
+static void w82627ehf_swap_tempreg(struct w83627ehf_data *data,
+				   int r1, int r2)
+{
+	u16 tmp;
+
+	tmp = data->temp_src[r1];
+	data->temp_src[r1] = data->temp_src[r2];
+	data->temp_src[r2] = tmp;
+
+	tmp = data->reg_temp[r1];
+	data->reg_temp[r1] = data->reg_temp[r2];
+	data->reg_temp[r2] = tmp;
+
+	tmp = data->reg_temp_over[r1];
+	data->reg_temp_over[r1] = data->reg_temp_over[r2];
+	data->reg_temp_over[r2] = tmp;
+
+	tmp = data->reg_temp_hyst[r1];
+	data->reg_temp_hyst[r1] = data->reg_temp_hyst[r2];
+	data->reg_temp_hyst[r2] = tmp;
+
+	tmp = data->reg_temp_config[r1];
+	data->reg_temp_config[r1] = data->reg_temp_config[r2];
+	data->reg_temp_config[r2] = tmp;
+}
+
 static int __devinit w83627ehf_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct w83627ehf_sio_data *sio_data = dev->platform_data;
 	struct w83627ehf_data *data;
 	struct resource *res;
-	u8 fan4pin, fan5pin, en_vrm10;
+	u8 fan3pin, fan4pin, fan4min, fan5pin, en_vrm10;
 	int i, err = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1466,9 +1797,11 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 
 	/* 627EHG and 627EHF have 10 voltage inputs; 627DHG and 667HG have 9 */
 	data->in_num = (sio_data->kind == w83627ehf) ? 10 : 9;
-	/* 667HG has 3 pwms */
+	/* 667HG, NCT6775F, and NCT6776F have 3 pwms */
 	data->pwm_num = (sio_data->kind == w83667hg
-			 || sio_data->kind == w83667hg_b) ? 3 : 4;
+			 || sio_data->kind == w83667hg_b
+			 || sio_data->kind == nct6775
+			 || sio_data->kind == nct6776) ? 3 : 4;
 
 	data->have_temp = 0x07;
 	/* Check temp3 configuration bit for 667HG */
@@ -1479,15 +1812,98 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		if (reg & 0x01)
 			data->have_temp &= ~(1 << 2);
 		else
-			data->in6_skip = 1; /* Either temp3 or in6 */
+			data->in6_skip = 1;	/* either temp3 or in6 */
+	}
+
+	/* Deal with temperature register setup first. */
+	if (sio_data->kind == nct6775 || sio_data->kind == nct6776) {
+		int mask = 0;
+
+		/*
+		 * Display temperature sensor output only if it monitors
+		 * a source other than one already reported. Always display
+		 * first three temperature registers, though.
+		 */
+		for (i = 0; i < NUM_REG_TEMP; i++) {
+			u8 src;
+
+			data->reg_temp[i] = NCT6775_REG_TEMP[i];
+			data->reg_temp_over[i] = NCT6775_REG_TEMP_OVER[i];
+			data->reg_temp_hyst[i] = NCT6775_REG_TEMP_HYST[i];
+			data->reg_temp_config[i] = NCT6775_REG_TEMP_CONFIG[i];
+
+			src = w83627ehf_read_value(data,
+						   NCT6775_REG_TEMP_SOURCE[i]);
+			src &= 0x1f;
+			if (src && !(mask & (1 << src))) {
+				data->have_temp |= 1 << i;
+				mask |= 1 << src;
+			}
+
+			data->temp_src[i] = src;
+
+			/*
+			 * Now do some register swapping if index 0..2 don't
+			 * point to SYSTIN(1), CPUIN(2), and AUXIN(3).
+			 * Idea is to have the first three attributes
+			 * report SYSTIN, CPUIN, and AUXIN if possible
+			 * without overriding the basic system configuration.
+			 */
+			if (i > 0 && data->temp_src[0] != 1
+			    && data->temp_src[i] == 1)
+				w82627ehf_swap_tempreg(data, 0, i);
+			if (i > 1 && data->temp_src[1] != 2
+			    && data->temp_src[i] == 2)
+				w82627ehf_swap_tempreg(data, 1, i);
+			if (i > 2 && data->temp_src[2] != 3
+			    && data->temp_src[i] == 3)
+				w82627ehf_swap_tempreg(data, 2, i);
+		}
+		if (sio_data->kind == nct6776) {
+			/*
+			 * On NCT6776, AUXTIN and VIN3 pins are shared.
+			 * Only way to detect it is to check if AUXTIN is used
+			 * as a temperature source, and if that source is
+			 * enabled.
+			 *
+			 * If that is the case, disable in6, which reports VIN3.
+			 * Otherwise disable temp3.
+			 */
+			if (data->temp_src[2] == 3) {
+				u8 reg;
+
+				if (data->reg_temp_config[2])
+					reg = w83627ehf_read_value(data,
+						data->reg_temp_config[2]);
+				else
+					reg = 0; /* Assume AUXTIN is used */
+
+				if (reg & 0x01)
+					data->have_temp &= ~(1 << 2);
+				else
+					data->in6_skip = 1;
+			}
+		}
+
+		data->temp_label = nct6776_temp_label;
 	} else if (sio_data->kind == w83667hg_b) {
 		u8 reg;
 
+		/*
+		 * Temperature sources are selected with bank 0, registers 0x49
+		 * and 0x4a.
+		 */
+		for (i = 0; i < ARRAY_SIZE(W83627EHF_REG_TEMP); i++) {
+			data->reg_temp[i] = W83627EHF_REG_TEMP[i];
+			data->reg_temp_over[i] = W83627EHF_REG_TEMP_OVER[i];
+			data->reg_temp_hyst[i] = W83627EHF_REG_TEMP_HYST[i];
+			data->reg_temp_config[i] = W83627EHF_REG_TEMP_CONFIG[i];
+		}
 		reg = w83627ehf_read_value(data, 0x4a);
 		data->temp_src[0] = reg >> 5;
 		reg = w83627ehf_read_value(data, 0x49);
 		data->temp_src[1] = reg & 0x07;
-		data->temp_src[2] = (reg >> 4)  & 0x07;
+		data->temp_src[2] = (reg >> 4) & 0x07;
 
 		/*
 		 * W83667HG-B has another temperature register at 0x7e.
@@ -1516,22 +1932,54 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			data->in6_skip = 1;
 
 		data->temp_label = w83667hg_b_temp_label;
+	} else {
+		/* Temperature sources are fixed */
+		for (i = 0; i < 3; i++) {
+			data->reg_temp[i] = W83627EHF_REG_TEMP[i];
+			data->reg_temp_over[i] = W83627EHF_REG_TEMP_OVER[i];
+			data->reg_temp_hyst[i] = W83627EHF_REG_TEMP_HYST[i];
+			data->reg_temp_config[i] = W83627EHF_REG_TEMP_CONFIG[i];
+		}
 	}
 
-	data->REG_PWM = W83627EHF_REG_PWM;
-	data->REG_TARGET = W83627EHF_REG_TARGET;
-	data->REG_FAN = W83627EHF_REG_FAN;
-	data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
-	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
-	data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
-	data->REG_FAN_STOP_TIME = W83627EHF_REG_FAN_STOP_TIME;
-	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
-	if (sio_data->kind == w83667hg_b) {
+	if (sio_data->kind == nct6775) {
+		data->REG_PWM = NCT6775_REG_PWM;
+		data->REG_TARGET = NCT6775_REG_TARGET;
+		data->REG_FAN = W83627EHF_REG_FAN;
+		data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
+		data->REG_FAN_START_OUTPUT = NCT6775_REG_FAN_START_OUTPUT;
+		data->REG_FAN_STOP_OUTPUT = NCT6775_REG_FAN_STOP_OUTPUT;
+		data->REG_FAN_STOP_TIME = NCT6775_REG_FAN_STOP_TIME;
+		data->REG_FAN_MAX_OUTPUT = NCT6775_REG_FAN_MAX_OUTPUT;
+		data->REG_FAN_STEP_OUTPUT = NCT6775_REG_FAN_STEP_OUTPUT;
+	} else if (sio_data->kind == nct6776) {
+		data->REG_PWM = NCT6775_REG_PWM;
+		data->REG_TARGET = NCT6775_REG_TARGET;
+		data->REG_FAN = NCT6776_REG_FAN;
+		data->REG_FAN_MIN = NCT6776_REG_FAN_MIN;
+		data->REG_FAN_START_OUTPUT = NCT6775_REG_FAN_START_OUTPUT;
+		data->REG_FAN_STOP_OUTPUT = NCT6775_REG_FAN_STOP_OUTPUT;
+		data->REG_FAN_STOP_TIME = NCT6775_REG_FAN_STOP_TIME;
+	} else if (sio_data->kind == w83667hg_b) {
+		data->REG_PWM = W83627EHF_REG_PWM;
+		data->REG_TARGET = W83627EHF_REG_TARGET;
+		data->REG_FAN = W83627EHF_REG_FAN;
+		data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
+		data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
+		data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
+		data->REG_FAN_STOP_TIME = W83627EHF_REG_FAN_STOP_TIME;
 		data->REG_FAN_MAX_OUTPUT =
 		  W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B;
 		data->REG_FAN_STEP_OUTPUT =
 		  W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B;
 	} else {
+		data->REG_PWM = W83627EHF_REG_PWM;
+		data->REG_TARGET = W83627EHF_REG_TARGET;
+		data->REG_FAN = W83627EHF_REG_FAN;
+		data->REG_FAN_MIN = W83627EHF_REG_FAN_MIN;
+		data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
+		data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
+		data->REG_FAN_STOP_TIME = W83627EHF_REG_FAN_STOP_TIME;
 		data->REG_FAN_MAX_OUTPUT =
 		  W83627EHF_REG_FAN_MAX_OUTPUT_COMMON;
 		data->REG_FAN_STEP_OUTPUT =
@@ -1544,7 +1992,8 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
 	/* Read VID value */
-	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b ||
+	    sio_data->kind == nct6775 || sio_data->kind == nct6776) {
 		/* W83667HG has different pins for VID input and output, so
 		we can get the VID input values directly at logical device D
 		0xe3. */
@@ -1595,12 +2044,27 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	/* fan4 and fan5 share some pins with the GPIO and serial flash */
-	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
-		fan5pin = superio_inb(sio_data->sioreg, 0x27) & 0x20;
+	if (sio_data->kind == nct6775) {
+		/* On NCT6775, fan4 shares pins with the fdc interface */
+		fan3pin = 1;
+		fan4pin = !(superio_inb(sio_data->sioreg, 0x2A) & 0x80);
+		fan4min = 0;
+		fan5pin = 0;
+	} else if (sio_data->kind == nct6776) {
+		fan3pin = !(superio_inb(sio_data->sioreg, 0x24) & 0x40);
+		fan4pin = !!(superio_inb(sio_data->sioreg, 0x1C) & 0x01);
+		fan5pin = !!(superio_inb(sio_data->sioreg, 0x1C) & 0x02);
+		fan4min = fan4pin;
+	} else if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
+		fan3pin = 1;
 		fan4pin = superio_inb(sio_data->sioreg, 0x27) & 0x40;
+		fan5pin = superio_inb(sio_data->sioreg, 0x27) & 0x20;
+		fan4min = fan4pin;
 	} else {
-		fan5pin = !(superio_inb(sio_data->sioreg, 0x24) & 0x02);
+		fan3pin = 1;
 		fan4pin = !(superio_inb(sio_data->sioreg, 0x29) & 0x06);
+		fan5pin = !(superio_inb(sio_data->sioreg, 0x24) & 0x02);
+		fan4min = fan4pin;
 	}
 	superio_exit(sio_data->sioreg);
 
@@ -1610,15 +2074,36 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	   connected fan5 as input unless they are emitting log 1, which
 	   is not the default. */
 
-	data->has_fan = 0x07; /* fan1, fan2 and fan3 */
-	i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
-	if ((i & (1 << 2)) && fan4pin)
-		data->has_fan |= (1 << 3);
-	if (!(i & (1 << 1)) && fan5pin)
-		data->has_fan |= (1 << 4);
+	data->has_fan = data->has_fan_min = 0x03; /* fan1 and fan2 */
+
+	data->has_fan |= (fan3pin << 2);
+	data->has_fan_min |= (fan3pin << 2);
+
+	/*
+	 * NCT6775F and NCT6776F don't have the W83627EHF_REG_FANDIV1 register
+	 */
+	if (sio_data->kind == nct6775 || sio_data->kind == nct6776) {
+		data->has_fan |= (fan4pin << 3) | (fan5pin << 4);
+		data->has_fan_min |= (fan4min << 3) | (fan5pin << 4);
+	} else {
+		i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
+		if ((i & (1 << 2)) && fan4pin) {
+			data->has_fan |= (1 << 3);
+			data->has_fan_min |= (1 << 3);
+		}
+		if (!(i & (1 << 1)) && fan5pin) {
+			data->has_fan |= (1 << 4);
+			data->has_fan_min |= (1 << 4);
+		}
+	}
 
 	/* Read fan clock dividers immediately */
-	w83627ehf_update_fan_div(data);
+	w83627ehf_update_fan_div_common(dev, data);
+
+	/* Read pwm data to save original values */
+	w83627ehf_update_pwm_common(dev, data);
+	for (i = 0; i < data->pwm_num; i++)
+		data->pwm_enable_orig[i] = data->pwm_enable[i];
 
 	/* Read pwm data to save original values */
 	w83627ehf_update_pwm_common(dev, data);
@@ -1635,7 +2120,8 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_max_step_arrays); i++) {
 		struct sensor_device_attribute *attr =
 		  &sda_sf3_max_step_arrays[i];
-		if (data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff) {
+		if (data->REG_FAN_STEP_OUTPUT &&
+		    data->REG_FAN_STEP_OUTPUT[attr->index] != 0xff) {
 			err = device_create_file(dev, &attr->dev_attr);
 			if (err)
 				goto exit_remove;
@@ -1668,12 +2154,20 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			if ((err = device_create_file(dev,
 					&sda_fan_input[i].dev_attr))
 				|| (err = device_create_file(dev,
-					&sda_fan_alarm[i].dev_attr))
-				|| (err = device_create_file(dev,
-					&sda_fan_div[i].dev_attr))
-				|| (err = device_create_file(dev,
-					&sda_fan_min[i].dev_attr)))
+					&sda_fan_alarm[i].dev_attr)))
 				goto exit_remove;
+			if (sio_data->kind != nct6776) {
+				err = device_create_file(dev,
+						&sda_fan_div[i].dev_attr);
+				if (err)
+					goto exit_remove;
+			}
+			if (data->has_fan_min & (1 << i)) {
+				err = device_create_file(dev,
+						&sda_fan_min[i].dev_attr);
+				if (err)
+					goto exit_remove;
+			}
 			if (i < data->pwm_num &&
 				((err = device_create_file(dev,
 					&sda_pwm[i].dev_attr))
@@ -1701,12 +2195,21 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 			if (err)
 				goto exit_remove;
 		}
+		if (data->reg_temp_over[i]) {
+			err = device_create_file(dev,
+				&sda_temp_max[i].dev_attr);
+			if (err)
+				goto exit_remove;
+		}
+		if (data->reg_temp_hyst[i]) {
+			err = device_create_file(dev,
+				&sda_temp_max_hyst[i].dev_attr);
+			if (err)
+				goto exit_remove;
+		}
 		if (i > 2)
-			break;
-		if ((err = device_create_file(dev, &sda_temp_max[i].dev_attr))
-			|| (err = device_create_file(dev,
-				&sda_temp_max_hyst[i].dev_attr))
-			|| (err = device_create_file(dev,
+			continue;
+		if ((err = device_create_file(dev,
 				&sda_temp_alarm[i].dev_attr))
 			|| (err = device_create_file(dev,
 				&sda_temp_type[i].dev_attr)))
@@ -1767,6 +2270,8 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
 	static const char __initdata sio_name_W83667HG[] = "W83667HG";
 	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
+	static const char __initdata sio_name_NCT6775[] = "NCT6775F";
+	static const char __initdata sio_name_NCT6776[] = "NCT6776F";
 
 	u16 val;
 	const char *sio_name;
@@ -1803,6 +2308,14 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 		sio_data->kind = w83667hg_b;
 		sio_name = sio_name_W83667HG_B;
 		break;
+	case SIO_NCT6775_ID:
+		sio_data->kind = nct6775;
+		sio_name = sio_name_NCT6775;
+		break;
+	case SIO_NCT6776_ID:
+		sio_data->kind = nct6776;
+		sio_name = sio_name_NCT6776;
+		break;
 	default:
 		if (val != 0xffff)
 			pr_debug("unsupported chip ID: 0x%04x\n", val);
-- 
1.7.3.1

