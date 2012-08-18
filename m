Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2HRJ5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:57:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54442 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2HRJ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:57:16 -0400
Date: Sat, 18 Aug 2012 11:57:18 +0200
From: Thomas Haschka <haschka@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Patch: Thermostat doesn't cool Harddrives (12 inch Powerbooks,
 Ibooks G4)
Message-ID: <20120818115718.7cbfb18f@astronef.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//=89q2/BOPdSLOXj.SCe/In"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_//=89q2/BOPdSLOXj.SCe/In
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody!

It was quite hot here in Austria in the recent days and I found out
that the fan in my 12 inch powerbook only kicked in on CPU, GPU usage,
while on Mac OS X sides the fan ran nearly all the time (hot as it
was)... 

I looked into the therm_adt746 driver and found out that the
temperature sensor at the harddrive's bottom in the powerbook was not
taken into account, but it should as one of the air inlets is just
besides the harddrive, and it is thus also cooled by the fan, ( on can
verfy that by spinning up the fans an reading out the hdd temp ) .. 

I created a patch to fix the situation, and I guess that it is pretty
urgent as I imagine lot's of powerbooks running with their disk
uncooled.. 

Here goes the patch

Thanks for making it accessible.. 

Thomas

diff -uprN linux/drivers/macintosh/therm_adt746x.c
linux-mod/drivers/macintosh/therm_adt746x.c ---
linux/drivers/macintosh/therm_adt746x.c	2012-08-10
12:42:38.000000000 +0200 +++
linux-mod/drivers/macintosh/therm_adt746x.c	2012-08-18
11:29:41.000000000 +0200 @@ -2,6 +2,7 @@
  * Device driver for the i2c thermostat found on the iBook G4, Albook
G4 *
  * Copyright (C) 2003, 2004 Colin Leroy, Rasmus Rohde, Benjamin
Herrenschmidt
+ *                     2012 Thomas Haschka
  *
  * Documentation from 115254175ADT7467_pra.pdf and
3686221171167ADT7460_b.pdf
  * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7467
@@ -29,6 +30,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
+#include <asm/system.h>
 #include <asm/sections.h>
 
 #undef DEBUG
@@ -38,20 +40,21 @@
 #define AUTO_MASK    0x20
 #define INVERT_MASK  0x10
 
-static u8 TEMP_REG[3]    = {0x26, 0x25, 0x27}; /* local, sensor1,
sensor2 */ -static u8 LIMIT_REG[3]   = {0x6b, 0x6a, 0x6c}; /* local,
sensor1, sensor2 */ -static u8 MANUAL_MODE[2] = {0x5c, 0x5d};       
-static u8 REM_CONTROL[2] = {0x00, 0x40};
-static u8 FAN_SPEED[2]   = {0x28, 0x2a};
-static u8 FAN_SPD_SET[2] = {0x30, 0x31};
-
-static u8 default_limits_local[3] = {70, 50, 70};    /* local,
sensor1, sensor2 */ -static u8 default_limits_chip[3] = {80, 65,
80};    /* local, sensor1, sensor2 */ -static const char
*sensor_location[3] = { "?", "?", "?" }; +static u8 TEMP_REG[3] =
{ 0x26, 0x25, 0x27 };	/* local, sensor1, sensor2 */ +static u8
LIMIT_REG[3] = { 0x6b, 0x6a, 0x6c };	/* local, sensor1, sensor2
*/ +static u8 MANUAL_MODE[2] = { 0x5c, 0x5d }; +static u8
REM_CONTROL[2] = { 0x00, 0x40 }; +static u8 FAN_SPEED[2] = { 0x28,
0x2a }; +static u8 FAN_SPD_SET[2] = { 0x30, 0x31 };
+
+static u8 default_limits_local[3] = { 45, 50, 70 };	/* local,
sensor1, sensor2 */ +static u8 default_limits_chip[3] = { 70, 65,
80 };	/* local, sensor1, sensor2 */ +
+static const char *sensor_location[3];
 
 static int limit_adjust;
 static int fan_speed = -1;
-static bool verbose;
+static int verbose;
 
 MODULE_AUTHOR("Colin Leroy <colin@colino.net>");
 MODULE_DESCRIPTION("Driver for ADT746x thermostat in iBook G4 and "
@@ -59,43 +62,44 @@ MODULE_DESCRIPTION("Driver for ADT746x t
 MODULE_LICENSE("GPL");
 
 module_param(limit_adjust, int, 0644);
-MODULE_PARM_DESC(limit_adjust,"Adjust maximum temperatures (50
sensor1, 70 sensor2) " +MODULE_PARM_DESC(limit_adjust,
+		 "Adjust maximum temperatures (50 sensor1, 70 sensor2)
" "by N degrees.");
 
 module_param(fan_speed, int, 0644);
-MODULE_PARM_DESC(fan_speed,"Specify starting fan speed (0-255) "
+MODULE_PARM_DESC(fan_speed, "Specify starting fan speed (0-255) "
 		 "(default 64)");
 
 module_param(verbose, bool, 0);
-MODULE_PARM_DESC(verbose,"Verbose log operations "
-		 "(default 0)");
+MODULE_PARM_DESC(verbose, "Verbose log operations " "(default 0)");
 
 struct thermostat {
-	struct i2c_client	*clt;
-	u8			temps[3];
-	u8			cached_temp[3];
-	u8			initial_limits[3];
-	u8			limits[3];
-	int			last_speed[2];
-	int			last_var[2];
-	int			pwm_inv[2];
-	struct task_struct	*thread;
-	struct platform_device	*pdev;
-	enum {
-		ADT7460,
-		ADT7467
-	}			type;
+	struct i2c_client *clt;
+	u8 temps[3];
+	u8 cached_temp[3];
+	u8 initial_limits[3];
+	u8 limits[3];
+	int last_speed[2];
+	int last_var[2];
+	int pwm_inv[2];
 };
 
+static enum { ADT7460, ADT7467 } therm_type;
+static int therm_bus, therm_address;
+static struct platform_device *of_dev;
+static struct thermostat *thermostat;
+static struct task_struct *thread_therm = NULL;
+
 static void write_both_fan_speed(struct thermostat *th, int speed);
 static void write_fan_speed(struct thermostat *th, int speed, int fan);
+static void thermostat_create_files(void);
+static void thermostat_remove_files(void);
 
-static int
-write_reg(struct thermostat* th, int reg, u8 data)
+static int write_reg(struct thermostat *th, int reg, u8 data)
 {
 	u8 tmp[2];
 	int rc;
-	
+
 	tmp[0] = reg;
 	tmp[1] = data;
 	rc = i2c_master_send(th->clt, (const char *)tmp, 2);
@@ -106,13 +110,12 @@ write_reg(struct thermostat* th, int reg
 	return 0;
 }
 
-static int
-read_reg(struct thermostat* th, int reg)
+static int read_reg(struct thermostat *th, int reg)
 {
 	u8 reg_addr, data;
 	int rc;
 
-	reg_addr = (u8)reg;
+	reg_addr = (u8) reg;
 	rc = i2c_master_send(th->clt, &reg_addr, 1);
 	if (rc < 0)
 		return rc;
@@ -124,75 +127,137 @@ read_reg(struct thermostat* th, int reg)
 	return data;
 }
 
+static struct i2c_driver thermostat_driver;
+
+static int attach_thermostat(struct i2c_adapter *adapter)
+{
+	unsigned long bus_no;
+	struct i2c_board_info info;
+	struct i2c_client *client;
+
+	if (strncmp(adapter->name, "uni-n", 5))
+		return -ENODEV;
+	bus_no = simple_strtoul(adapter->name + 6, NULL, 10);
+	if (bus_no != therm_bus)
+		return -ENODEV;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "therm_adt746x", I2C_NAME_SIZE);
+	info.addr = therm_address;
+	client = i2c_new_device(adapter, &info);
+	if (!client)
+		return -ENODEV;
+
+	/*
+	 * Let i2c-core delete that device on driver removal.
+	 * This is safe because i2c-core holds the core_lock mutex for
us.
+	 */
+	list_add_tail(&client->detected, &thermostat_driver.clients);
+	return 0;
+}
+
+static int remove_thermostat(struct i2c_client *client)
+{
+	struct thermostat *th = i2c_get_clientdata(client);
+	int i;
+
+	thermostat_remove_files();
+
+	if (thread_therm != NULL) {
+		kthread_stop(thread_therm);
+	}
+
+	printk(KERN_INFO "adt746x: Putting max temperatures back from "
+	       "%d, %d, %d to %d, %d, %d\n",
+	       th->limits[0], th->limits[1], th->limits[2],
+	       th->initial_limits[0], th->initial_limits[1],
+	       th->initial_limits[2]);
+
+	for (i = 0; i < 3; i++)
+		write_reg(th, LIMIT_REG[i], th->initial_limits[i]);
+
+	write_both_fan_speed(th, -1);
+
+	thermostat = NULL;
+
+	kfree(th);
+
+	return 0;
+}
+
 static int read_fan_speed(struct thermostat *th, u8 addr)
 {
 	u8 tmp[2];
 	u16 res;
-	
+
 	/* should start with low byte */
 	tmp[1] = read_reg(th, addr);
 	tmp[0] = read_reg(th, addr + 1);
-	
+
 	res = tmp[1] + (tmp[0] << 8);
 	/* "a value of 0xffff means that the fan has stopped" */
-	return (res == 0xffff ? 0 : (90000*60)/res);
+	return (res == 0xffff ? 0 : (90000 * 60) / res);
 }
 
 static void write_both_fan_speed(struct thermostat *th, int speed)
 {
 	write_fan_speed(th, speed, 0);
-	if (th->type == ADT7460)
+	if (therm_type == ADT7460)
 		write_fan_speed(th, speed, 1);
 }
 
 static void write_fan_speed(struct thermostat *th, int speed, int fan)
 {
 	u8 manual;
-	
-	if (speed > 0xff) 
+
+	if (speed > 0xff)
 		speed = 0xff;
-	else if (speed < -1) 
+	else if (speed < -1)
 		speed = 0;
-	
-	if (th->type == ADT7467 && fan == 1)
+
+	if (therm_type == ADT7467 && fan == 1)
 		return;
-	
+
 	if (th->last_speed[fan] != speed) {
 		if (verbose) {
 			if (speed == -1)
-				printk(KERN_DEBUG "adt746x: Setting
speed to automatic "
-					"for %s fan.\n",
sensor_location[fan+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting speed to
automatic "
+				       "for %s fan.\n",
+				       sensor_location[fan + 1]);
 			else
-				printk(KERN_DEBUG "adt746x: Setting
speed to %d "
-					"for %s fan.\n", speed,
sensor_location[fan+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting speed to %d "
+				       "for %s fan.\n", speed,
+				       sensor_location[fan + 1]);
 		}
 	} else
 		return;
-	
+
 	if (speed >= 0) {
 		manual = read_reg(th, MANUAL_MODE[fan]);
 		manual &= ~INVERT_MASK;
 		write_reg(th, MANUAL_MODE[fan],
-			manual | MANUAL_MASK | th->pwm_inv[fan]);
+			  manual | MANUAL_MASK | th->pwm_inv[fan]);
 		write_reg(th, FAN_SPD_SET[fan], speed);
 	} else {
 		/* back to automatic */
-		if(th->type == ADT7460) {
+		if (therm_type == ADT7460) {
 			manual = read_reg(th,
-				MANUAL_MODE[fan]) & (~MANUAL_MASK);
+					  MANUAL_MODE[fan]) &
(~MANUAL_MASK); manual &= ~INVERT_MASK;
 			manual |= th->pwm_inv[fan];
 			write_reg(th,
-				MANUAL_MODE[fan],
manual|REM_CONTROL[fan]);
+				  MANUAL_MODE[fan], manual |
REM_CONTROL[fan]); } else {
 			manual = read_reg(th, MANUAL_MODE[fan]);
 			manual &= ~INVERT_MASK;
 			manual |= th->pwm_inv[fan];
-			write_reg(th, MANUAL_MODE[fan],
manual&(~AUTO_MASK));
+			write_reg(th, MANUAL_MODE[fan], manual &
(~AUTO_MASK)); }
 	}
-	
-	th->last_speed[fan] = speed;			
+
+	th->last_speed[fan] = speed;
 }
 
 static void read_sensors(struct thermostat *th)
@@ -200,22 +265,22 @@ static void read_sensors(struct thermost
 	int i = 0;
 
 	for (i = 0; i < 3; i++)
-		th->temps[i]  = read_reg(th, TEMP_REG[i]);
+		th->temps[i] = read_reg(th, TEMP_REG[i]);
 }
 
 #ifdef DEBUG
 static void display_stats(struct thermostat *th)
 {
 	if (th->temps[0] != th->cached_temp[0]
-	||  th->temps[1] != th->cached_temp[1]
-	||  th->temps[2] != th->cached_temp[2]) {
+	    || th->temps[1] != th->cached_temp[1]
+	    || th->temps[2] != th->cached_temp[2]) {
 		printk(KERN_INFO "adt746x: Temperature infos:"
-				 " thermostats: %d,%d,%d;"
-				 " limits: %d,%d,%d;"
-				 " fan speed: %d RPM\n",
-				 th->temps[0], th->temps[1],
th->temps[2],
-				 th->limits[0],  th->limits[1],
th->limits[2],
-				 read_fan_speed(th, FAN_SPEED[0]));
+		       " thermostats: %d,%d,%d;"
+		       " limits: %d,%d,%d;"
+		       " fan speed: %d RPM\n",
+		       th->temps[0], th->temps[1], th->temps[2],
+		       th->limits[0], th->limits[1], th->limits[2],
+		       read_fan_speed(th, FAN_SPEED[0]));
 	}
 	th->cached_temp[0] = th->temps[0];
 	th->cached_temp[1] = th->temps[1];
@@ -223,16 +288,86 @@ static void display_stats(struct thermos
 }
 #endif
 
-static void update_fans_speed (struct thermostat *th)
+static void update_fans_speed(struct thermostat *th)
 {
-	int lastvar = 0; /* last variation, for iBook */
-	int i = 0;
 
-	/* we don't care about local sensor, so we start at sensor 1 */
-	for (i = 1; i < 3; i++) {
+	if (therm_type == ADT7460) {
+
+		int lastvar = 0;
+		int i = 0;
+
+		/* we don't care about local sensor, so we start at
sensor 1 */
+		for (i = 1; i < 3; i++) {
+			int started = 0;
+			int fan_number = (therm_type == ADT7460 && i
== 2);
+			int var = th->temps[i] - th->limits[i];
+
+			if (var > -1) {
+				int step = (255 - fan_speed) / 7;
+				int new_speed = 0;
+
+				/* hysteresis : change fan speed only
if variation is
+				 * more than two degrees */
+				if (abs(var -
th->last_var[fan_number]) < 2)
+					continue;
+
+				started = 1;
+				new_speed = fan_speed + ((var - 1) *
step); +
+				if (new_speed < fan_speed)
+					new_speed = fan_speed;
+				if (new_speed > 255)
+					new_speed = 255;
+
+				if (verbose)
+					printk(KERN_DEBUG
+					       "adt746x: Setting fans
speed to %d "
+					       "(limit exceeded by %d
on %s)\n",
+					       new_speed, var,
+
sensor_location[fan_number + 1]);
+				write_both_fan_speed(th, new_speed);
+				th->last_var[fan_number] = var;
+			} else if (var < -2) {
+				/* don't stop fan if sensor2 is cold
and sensor1 is not
+				 * so cold (lastvar >= -1) */
+				if (i == 2 && lastvar < -1) {
+					if
(th->last_speed[fan_number] != 0)
+						if (verbose)
+
printk(KERN_DEBUG
+
"adt746x: Stopping "
+
"fans.\n");
+					write_both_fan_speed(th, 0);
+				}
+			}
+
+			lastvar = var;
+
+			if (started)
+				return;	/* we don't want to
re-stop the fan
+					 * if sensor1 is heating and 
+                                         * sensor2 is not */
+		}
+
+	} else {		
+                /* Single FAN laptops i.e. 12 inch Powerbook, 
+                 * 13 inch Ibook G4 */
+		int lastvar = 0;
+		int i = 0;
+		int var = 0;
+		int var_sensor[3];
 		int started = 0;
-		int fan_number = (th->type == ADT7460 && i == 2);
-		int var = th->temps[i] - th->limits[i];
+		int fan_number = 0;
+
+		/* we CARE about the HDD sensor, so we start at sensor
0 */
+		for (i = 0; i < 3; i++) {
+			var_sensor[i] = th->temps[i] - th->limits[i];
+		}
+		var = var_sensor[0];
+		for (i = 1; i < 3; i++) {
+			if (var_sensor[i] > var) {
+				var = var_sensor[i];
+			}
+		}
 
 		if (var > -1) {
 			int step = (255 - fan_speed) / 7;
@@ -241,10 +376,10 @@ static void update_fans_speed (struct th
 			/* hysteresis : change fan speed only if
variation is
 			 * more than two degrees */
 			if (abs(var - th->last_var[fan_number]) < 2)
-				continue;
+				return;
 
 			started = 1;
-			new_speed = fan_speed + ((var-1)*step);
+			new_speed = fan_speed + ((var - 1) * step);
 
 			if (new_speed < fan_speed)
 				new_speed = fan_speed;
@@ -252,38 +387,36 @@ static void update_fans_speed (struct th
 				new_speed = 255;
 
 			if (verbose)
-				printk(KERN_DEBUG "adt746x: Setting
fans speed to %d "
-						 "(limit exceeded by
%d on %s)\n",
-						new_speed, var,
-
sensor_location[fan_number+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting fans speed to
%d "
+				       "(limit exceeded by %d on
%s)\n",
+				       new_speed, var,
+				       sensor_location[fan_number +
1]); write_both_fan_speed(th, new_speed);
 			th->last_var[fan_number] = var;
 		} else if (var < -2) {
-			/* don't stop fan if sensor2 is cold and
sensor1 is not
-			 * so cold (lastvar >= -1) */
-			if (i == 2 && lastvar < -1) {
-				if (th->last_speed[fan_number] != 0)
-					if (verbose)
-						printk(KERN_DEBUG
"adt746x: Stopping "
-							"fans.\n");
-				write_both_fan_speed(th, 0);
-			}
+			if (th->last_speed[fan_number] != 0)
+				if (verbose)
+					printk(KERN_DEBUG "adt746x:
Stopping "
+					       "fans.\n");
+			write_both_fan_speed(th, 0);
 		}
 
 		lastvar = var;
 
 		if (started)
-			return; /* we don't want to re-stop the fan
-				* if sensor1 is heating and sensor2 is
not */
+			return;
+
 	}
+
 }
 
 static int monitor_task(void *arg)
 {
-	struct thermostat* th = arg;
+	struct thermostat *th = arg;
 
 	set_freezable();
-	while(!kthread_should_stop()) {
+	while (!kthread_should_stop()) {
 		try_to_freeze();
 		msleep_interruptible(2000);
 
@@ -292,7 +425,7 @@ static int monitor_task(void *arg)
 			read_sensors(th);
 #else
 		read_sensors(th);
-#endif		
+#endif
 
 		if (fan_speed != -1)
 			update_fans_speed(th);
@@ -311,190 +444,20 @@ static void set_limit(struct thermostat
 	/* Set sensor1 limit higher to avoid powerdowns */
 	th->limits[i] = default_limits_chip[i] + limit_adjust;
 	write_reg(th, LIMIT_REG[i], th->limits[i]);
-		
+
 	/* set our limits to normal */
 	th->limits[i] = default_limits_local[i] + limit_adjust;
 }
 
-#define BUILD_SHOW_FUNC_INT(name, data)
\ -static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)	\
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	return sprintf(buf, "%d\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_INT_LITE(name,
data)				\ -static ssize_t
show_##name(struct device *dev, struct device_attribute *attr, char
*buf)	\
-{								\
-	return sprintf(buf, "%d\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_STR(name, data)
\ -static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)       \
-{								\
-	return sprintf(buf, "%s\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_FAN(name, data)
\ -static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)       \
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	return sprintf(buf, "%d (%d rpm)\n", 			\
-		th->last_speed[data],				\
-		read_fan_speed(th, FAN_SPEED[data])		\
-		);						\
-}
-
-#define BUILD_STORE_FUNC_DEG(name, data)			\
-static ssize_t store_##name(struct device *dev, struct
device_attribute *attr, const char *buf, size_t n) \
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	int val;						\
-	int i;							\
-	val = simple_strtol(buf, NULL, 10);			\
-	printk(KERN_INFO "Adjusting limits by %d degrees\n",
val);	\
-	limit_adjust = val;					\
-	for (i=0; i < 3; i++)					\
-		set_limit(th, i);				\
-	return n;						\
-}
-
-#define BUILD_STORE_FUNC_INT(name, data)			\
-static ssize_t store_##name(struct device *dev, struct
device_attribute *attr, const char *buf, size_t n) \
-{								\
-	int val;						\
-	val = simple_strtol(buf, NULL, 10);			\
-	if (val < 0 || val > 255)				\
-		return -EINVAL;
\
-	printk(KERN_INFO "Setting specified fan speed to %d\n",
val);	\
-	data = val;						\
-	return n;						\
-}
-
-BUILD_SHOW_FUNC_INT(sensor1_temperature,	 (read_reg(th,
TEMP_REG[1]))) -BUILD_SHOW_FUNC_INT(sensor2_temperature,
(read_reg(th, TEMP_REG[2])))
-BUILD_SHOW_FUNC_INT(sensor1_limit,		 th->limits[1])
-BUILD_SHOW_FUNC_INT(sensor2_limit,		 th->limits[2])
-BUILD_SHOW_FUNC_STR(sensor1_location,
sensor_location[1])
-BUILD_SHOW_FUNC_STR(sensor2_location,
sensor_location[2]) - -BUILD_SHOW_FUNC_INT_LITE(specified_fan_speed,
fan_speed) -BUILD_STORE_FUNC_INT(specified_fan_speed,fan_speed) -
-BUILD_SHOW_FUNC_FAN(sensor1_fan_speed,	 0)
-BUILD_SHOW_FUNC_FAN(sensor2_fan_speed,	 1)
-
-BUILD_SHOW_FUNC_INT_LITE(limit_adjust,	 limit_adjust)
-BUILD_STORE_FUNC_DEG(limit_adjust,	 th)
-		
-static DEVICE_ATTR(sensor1_temperature,	S_IRUGO,
-		   show_sensor1_temperature,NULL);
-static DEVICE_ATTR(sensor2_temperature,	S_IRUGO,
-		   show_sensor2_temperature,NULL);
-static DEVICE_ATTR(sensor1_limit, S_IRUGO,
-		   show_sensor1_limit,	NULL);
-static DEVICE_ATTR(sensor2_limit, S_IRUGO,
-		   show_sensor2_limit,	NULL);
-static DEVICE_ATTR(sensor1_location, S_IRUGO,
-		   show_sensor1_location, NULL);
-static DEVICE_ATTR(sensor2_location, S_IRUGO,
-		   show_sensor2_location, NULL);
-
-static DEVICE_ATTR(specified_fan_speed,
S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH,
-		   show_specified_fan_speed,store_specified_fan_speed);
-
-static DEVICE_ATTR(sensor1_fan_speed,	S_IRUGO,
-		   show_sensor1_fan_speed,	NULL);
-static DEVICE_ATTR(sensor2_fan_speed,	S_IRUGO,
-		   show_sensor2_fan_speed,	NULL);
-
-static DEVICE_ATTR(limit_adjust,
S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH,
-		   show_limit_adjust,	store_limit_adjust);
-
-static void thermostat_create_files(struct thermostat *th)
-{
-	struct device_node *np = th->clt->dev.of_node;
-	struct device *dev;
-	int err;
-
-	/* To maintain ABI compatibility with userspace, create
-	 * the old style platform driver and attach the attributes
-	 * to it here
-	 */
-	th->pdev = of_platform_device_create(np, "temperatures", NULL);
-	if (!th->pdev)
-		return;
-	dev = &th->pdev->dev;
-	dev_set_drvdata(dev, th);
-	err = device_create_file(dev, &dev_attr_sensor1_temperature);
-	err |= device_create_file(dev, &dev_attr_sensor2_temperature);
-	err |= device_create_file(dev, &dev_attr_sensor1_limit);
-	err |= device_create_file(dev, &dev_attr_sensor2_limit);
-	err |= device_create_file(dev, &dev_attr_sensor1_location);
-	err |= device_create_file(dev, &dev_attr_sensor2_location);
-	err |= device_create_file(dev, &dev_attr_limit_adjust);
-	err |= device_create_file(dev, &dev_attr_specified_fan_speed);
-	err |= device_create_file(dev, &dev_attr_sensor1_fan_speed);
-	if(th->type == ADT7460)
-		err |= device_create_file(dev,
&dev_attr_sensor2_fan_speed);
-	if (err)
-		printk(KERN_WARNING
-			"Failed to create temperature attribute
file(s).\n"); -}
-
-static void thermostat_remove_files(struct thermostat *th)
-{
-	struct device *dev;
-
-	if (!th->pdev)
-		return;
-	dev = &th->pdev->dev;
-	device_remove_file(dev, &dev_attr_sensor1_temperature);
-	device_remove_file(dev, &dev_attr_sensor2_temperature);
-	device_remove_file(dev, &dev_attr_sensor1_limit);
-	device_remove_file(dev, &dev_attr_sensor2_limit);
-	device_remove_file(dev, &dev_attr_sensor1_location);
-	device_remove_file(dev, &dev_attr_sensor2_location);
-	device_remove_file(dev, &dev_attr_limit_adjust);
-	device_remove_file(dev, &dev_attr_specified_fan_speed);
-	device_remove_file(dev, &dev_attr_sensor1_fan_speed);	
-	if (th->type == ADT7460)
-		device_remove_file(dev, &dev_attr_sensor2_fan_speed);
-	of_device_unregister(th->pdev);
-
-}
-
 static int probe_thermostat(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
-	struct device_node *np = client->dev.of_node;
-	struct thermostat* th;
-	const __be32 *prop;
-	int i, rc, vers, offset = 0;
-
-	if (!np)
-		return -ENXIO;
-	prop = of_get_property(np, "hwsensor-params-version", NULL);
-	if (!prop)
-		return -ENXIO;
-	vers = be32_to_cpup(prop);
-	printk(KERN_INFO "adt746x: version %d (%ssupported)\n",
-	       vers, vers == 1 ? "" : "un");
-	if (vers != 1)
-		return -ENXIO;
-
-	if (of_get_property(np, "hwsensor-location", NULL)) {
-		for (i = 0; i < 3; i++) {
-			sensor_location[i] = of_get_property(np,
-					"hwsensor-location", NULL) +
offset; -
-			if (sensor_location[i] == NULL)
-				sensor_location[i] = "";
+	struct thermostat *th;
+	int rc;
+	int i;
 
-			printk(KERN_INFO "sensor %d: %s\n", i,
sensor_location[i]);
-			offset += strlen(sensor_location[i]) + 1;
-		}
-	}
+	if (thermostat)
+		return 0;
 
 	th = kzalloc(sizeof(struct thermostat), GFP_KERNEL);
 	if (!th)
@@ -502,7 +465,6 @@ static int probe_thermostat(struct i2c_c
 
 	i2c_set_clientdata(client, th);
 	th->clt = client;
-	th->type = id->driver_data;
 
 	rc = read_reg(th, CONFIG_REG);
 	if (rc < 0) {
@@ -514,8 +476,8 @@ static int probe_thermostat(struct i2c_c
 	/* force manual control to start the fan quieter */
 	if (fan_speed == -1)
 		fan_speed = 64;
-	
-	if (th->type == ADT7460) {
+
+	if (therm_type == ADT7460) {
 		printk(KERN_INFO "adt746x: ADT7460 initializing\n");
 		/* The 7460 needs to be started explicitly */
 		write_reg(th, CONFIG_REG, 1);
@@ -528,10 +490,12 @@ static int probe_thermostat(struct i2c_c
 	}
 
 	printk(KERN_INFO "adt746x: Lowering max temperatures from %d,
%d, %d"
-			 " to %d, %d, %d\n",
-			 th->initial_limits[0], th->initial_limits[1],
-			 th->initial_limits[2], th->limits[0],
th->limits[1],
-			 th->limits[2]);
+	       " to %d, %d, %d\n",
+	       th->initial_limits[0], th->initial_limits[1],
+	       th->initial_limits[2], th->limits[0], th->limits[1],
+	       th->limits[2]);
+
+	thermostat = th;
 
 	/* record invert bit status because fw can corrupt it after
suspend */ th->pwm_inv[0] = read_reg(th, MANUAL_MODE[0]) & INVERT_MASK;
@@ -550,63 +514,199 @@ static int probe_thermostat(struct i2c_c
 		/* automatic mode */
 		write_both_fan_speed(th, -1);
 	}
-	
-	th->thread = kthread_run(monitor_task, th, "kfand");
-	if (th->thread == ERR_PTR(-ENOMEM)) {
+
+	thread_therm = kthread_run(monitor_task, th, "kfand");
+
+	if (thread_therm == ERR_PTR(-ENOMEM)) {
 		printk(KERN_INFO "adt746x: Kthread creation failed\n");
-		th->thread = NULL;
+		thread_therm = NULL;
 		return -ENOMEM;
 	}
 
-	thermostat_create_files(th);
-
-	return 0;
-}
-
-static int remove_thermostat(struct i2c_client *client)
-{
-	struct thermostat *th = i2c_get_clientdata(client);
-	int i;
-	
-	thermostat_remove_files(th);
-
-	if (th->thread != NULL)
-		kthread_stop(th->thread);
-
-	printk(KERN_INFO "adt746x: Putting max temperatures back from "
-			 "%d, %d, %d to %d, %d, %d\n",
-		th->limits[0], th->limits[1], th->limits[2],
-		th->initial_limits[0], th->initial_limits[1],
-		th->initial_limits[2]);
-
-	for (i = 0; i < 3; i++)
-		write_reg(th, LIMIT_REG[i], th->initial_limits[i]);
-
-	write_both_fan_speed(th, -1);
-
-	kfree(th);
+	thermostat_create_files();
 
 	return 0;
 }
 
 static const struct i2c_device_id therm_adt746x_id[] = {
-	{ "MAC,adt7460", ADT7460 },
-	{ "MAC,adt7467", ADT7467 },
-	{ }
+	{"therm_adt746x", 0},
+	{}
 };
-MODULE_DEVICE_TABLE(i2c, therm_adt746x_id);
 
 static struct i2c_driver thermostat_driver = {
 	.driver = {
-		.name	= "therm_adt746x",
-	},
+		   .name = "therm_adt746x",
+		   },
+	.attach_adapter = attach_thermostat,
 	.probe = probe_thermostat,
 	.remove = remove_thermostat,
 	.id_table = therm_adt746x_id,
 };
 
+/* 
+ * Now, unfortunately, sysfs doesn't give us a nice void * we could
+ * pass around to the attribute functions, so we don't really have
+ * choice but implement a bunch of them...
+ *
+ * FIXME, it does now...
+ */
+#define BUILD_SHOW_FUNC_INT(name, data)
\ +static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)	\
+{								\
+	return sprintf(buf, "%d\n", data);			\
+}
+
+#define BUILD_SHOW_FUNC_STR(name, data)
\ +static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)       \
+{								\
+	return sprintf(buf, "%s\n", data);			\
+}
+
+#define BUILD_SHOW_FUNC_FAN(name, data)
\ +static ssize_t show_##name(struct device *dev, struct
device_attribute *attr, char *buf)       \
+{								\
+	return sprintf(buf, "%d (%d rpm)\n", 			\
+		thermostat->last_speed[data],			\
+		read_fan_speed(thermostat, FAN_SPEED[data])	\
+		);						\
+}
+
+#define BUILD_STORE_FUNC_DEG(name, data)			\
+static ssize_t store_##name(struct device *dev, struct
device_attribute *attr, const char *buf, size_t n) \
+{								\
+	int val;						\
+	int i;							\
+	val = simple_strtol(buf, NULL, 10);			\
+	printk(KERN_INFO "Adjusting limits by %d degrees\n",
val);	\
+	limit_adjust = val;					\
+	for (i=0; i < 3; i++)					\
+		set_limit(thermostat, i);			\
+	return n;						\
+}
+
+#define BUILD_STORE_FUNC_INT(name, data)			\
+static ssize_t store_##name(struct device *dev, struct
device_attribute *attr, const char *buf, size_t n) \
+{								\
+	int val;						\
+	val = simple_strtol(buf, NULL, 10);			\
+	if (val < 0 || val > 255)				\
+		return -EINVAL;
\
+	printk(KERN_INFO "Setting specified fan speed to %d\n",
val);	\
+	data = val;						\
+	return n;						\
+}
+BUILD_SHOW_FUNC_INT(sensor0_temperature, (read_reg(thermostat,
TEMP_REG[0])))
+    BUILD_SHOW_FUNC_INT(sensor1_temperature, (read_reg(thermostat,
TEMP_REG[1])))
+    BUILD_SHOW_FUNC_INT(sensor2_temperature, (read_reg(thermostat,
TEMP_REG[2])))
+    BUILD_SHOW_FUNC_INT(sensor0_limit, thermostat->limits[0])
+    BUILD_SHOW_FUNC_INT(sensor1_limit, thermostat->limits[1])
+    BUILD_SHOW_FUNC_INT(sensor2_limit, thermostat->limits[2])
+    BUILD_SHOW_FUNC_STR(sensor0_location, sensor_location[0])
+    BUILD_SHOW_FUNC_STR(sensor1_location, sensor_location[1])
+    BUILD_SHOW_FUNC_STR(sensor2_location, sensor_location[2])
+
+    BUILD_SHOW_FUNC_INT(specified_fan_speed, fan_speed)
+    BUILD_SHOW_FUNC_FAN(sensor1_fan_speed, 0)
+    BUILD_SHOW_FUNC_FAN(sensor2_fan_speed, 1)
+
+    BUILD_STORE_FUNC_INT(specified_fan_speed, fan_speed)
+    BUILD_SHOW_FUNC_INT(limit_adjust, limit_adjust)
+    BUILD_STORE_FUNC_DEG(limit_adjust, thermostat)
+
+static DEVICE_ATTR(sensor0_temperature, S_IRUGO,
+		   show_sensor0_temperature, NULL);
+static DEVICE_ATTR(sensor1_temperature, S_IRUGO,
+		   show_sensor1_temperature, NULL);
+static DEVICE_ATTR(sensor2_temperature, S_IRUGO,
+		   show_sensor2_temperature, NULL);
+static DEVICE_ATTR(sensor0_limit, S_IRUGO, show_sensor0_limit, NULL);
+static DEVICE_ATTR(sensor1_limit, S_IRUGO, show_sensor1_limit, NULL);
+static DEVICE_ATTR(sensor2_limit, S_IRUGO, show_sensor2_limit, NULL);
+static DEVICE_ATTR(sensor0_location, S_IRUGO, show_sensor0_location,
NULL); +static DEVICE_ATTR(sensor1_location, S_IRUGO,
show_sensor1_location, NULL); +static DEVICE_ATTR(sensor2_location,
S_IRUGO, show_sensor2_location, NULL); +
+static DEVICE_ATTR(specified_fan_speed, S_IRUSR | S_IWUSR | S_IRGRP |
S_IROTH,
+		   show_specified_fan_speed,
store_specified_fan_speed); +
+static DEVICE_ATTR(sensor1_fan_speed, S_IRUGO, show_sensor1_fan_speed,
NULL); +static DEVICE_ATTR(sensor2_fan_speed, S_IRUGO,
show_sensor2_fan_speed, NULL); +
+static DEVICE_ATTR(limit_adjust, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+		   show_limit_adjust, store_limit_adjust);
+
 static int __init thermostat_init(void)
 {
+	struct device_node *np;
+	const u32 *prop;
+	int i = 0, offset = 0;
+
+	np = of_find_node_by_name(NULL, "fan");
+	if (!np)
+		return -ENODEV;
+	if (of_device_is_compatible(np, "adt7460"))
+		therm_type = ADT7460;
+	else if (of_device_is_compatible(np, "adt7467"))
+		therm_type = ADT7467;
+	else {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	prop = of_get_property(np, "hwsensor-params-version", NULL);
+	printk(KERN_INFO "adt746x: version %d (%ssupported)\n", *prop,
+	       (*prop == 1) ? "" : "un");
+	if (*prop != 1) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	/* look for bus either by path or using "reg" */
+	if (strstr(np->full_name, "/i2c-bus@") != NULL) {
+		const char *tmp_bus = (strstr(np->full_name,
"/i2c-bus@") + 9);
+		therm_bus = tmp_bus[0] - '0';
+	} else {
+		therm_bus = ((*prop) >> 8) & 0x0f;
+	}
+
+	therm_address = ((*prop) & 0xff) >> 1;
+
+	printk(KERN_INFO "adt746x: Thermostat bus: %d, address:
0x%02x, "
+	       "limit_adjust: %d, fan_speed: %d\n",
+	       therm_bus, therm_address, limit_adjust, fan_speed);
+
+	if (of_get_property(np, "hwsensor-location", NULL)) {
+		for (i = 0; i < 3; i++) {
+			sensor_location[i] = of_get_property(np,
+
"hwsensor-location",
+							     NULL) +
offset; +
+			if (sensor_location[i] == NULL)
+				sensor_location[i] = "";
+
+			printk(KERN_INFO "sensor %d: %s\n", i,
+			       sensor_location[i]);
+			offset += strlen(sensor_location[i]) + 1;
+		}
+	} else {
+		sensor_location[0] = "?";
+		sensor_location[1] = "?";
+		sensor_location[2] = "?";
+	}
+
+	of_dev = of_platform_device_create(np, "temperatures", NULL);
+	of_node_put(np);
+
+	if (of_dev == NULL) {
+		printk(KERN_ERR "Can't register temperatures
device !\n");
+		return -ENODEV;
+	}
 #ifndef CONFIG_I2C_POWERMAC
 	request_module("i2c-powermac");
 #endif
@@ -614,9 +714,58 @@ static int __init thermostat_init(void)
 	return i2c_add_driver(&thermostat_driver);
 }
 
+static void thermostat_create_files(void)
+{
+	int err;
+
+	err = device_create_file(&of_dev->dev,
&dev_attr_sensor0_temperature);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor1_temperature);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor2_temperature);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor0_limit);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor1_limit);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor2_limit);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor0_location);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor1_location);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor2_location);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_limit_adjust);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_specified_fan_speed);
+	err |= device_create_file(&of_dev->dev,
&dev_attr_sensor1_fan_speed);
+	if (therm_type == ADT7460)
+		err |=
+		    device_create_file(&of_dev->dev,
+				       &dev_attr_sensor2_fan_speed);
+	if (err)
+		printk(KERN_WARNING
+		       "Failed to create temperature attribute
file(s).\n"); +}
+
+static void thermostat_remove_files(void)
+{
+	if (of_dev) {
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor0_temperature);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor1_temperature);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor2_temperature);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor0_limit);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor1_limit);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor2_limit);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor0_location);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor1_location);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor2_location);
+		device_remove_file(&of_dev->dev,
&dev_attr_limit_adjust);
+		device_remove_file(&of_dev->dev,
&dev_attr_specified_fan_speed);
+		device_remove_file(&of_dev->dev,
&dev_attr_sensor1_fan_speed); +
+		if (therm_type == ADT7460)
+			device_remove_file(&of_dev->dev,
+
&dev_attr_sensor2_fan_speed); +
+	}
+}
+
 static void __exit thermostat_exit(void)
 {
 	i2c_del_driver(&thermostat_driver);
+	of_device_unregister(of_dev);
 }
 
 module_init(thermostat_init);


--MP_//=89q2/BOPdSLOXj.SCe/In
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=therm_adt746x.patch

diff -uprN linux/drivers/macintosh/therm_adt746x.c linux-mod/drivers/macintosh/therm_adt746x.c
--- linux/drivers/macintosh/therm_adt746x.c	2012-08-10 12:42:38.000000000 +0200
+++ linux-mod/drivers/macintosh/therm_adt746x.c	2012-08-18 11:29:41.000000000 +0200
@@ -2,6 +2,7 @@
  * Device driver for the i2c thermostat found on the iBook G4, Albook G4
  *
  * Copyright (C) 2003, 2004 Colin Leroy, Rasmus Rohde, Benjamin Herrenschmidt
+ *                     2012 Thomas Haschka
  *
  * Documentation from 115254175ADT7467_pra.pdf and 3686221171167ADT7460_b.pdf
  * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7467
@@ -29,6 +30,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
+#include <asm/system.h>
 #include <asm/sections.h>
 
 #undef DEBUG
@@ -38,20 +40,21 @@
 #define AUTO_MASK    0x20
 #define INVERT_MASK  0x10
 
-static u8 TEMP_REG[3]    = {0x26, 0x25, 0x27}; /* local, sensor1, sensor2 */
-static u8 LIMIT_REG[3]   = {0x6b, 0x6a, 0x6c}; /* local, sensor1, sensor2 */
-static u8 MANUAL_MODE[2] = {0x5c, 0x5d};       
-static u8 REM_CONTROL[2] = {0x00, 0x40};
-static u8 FAN_SPEED[2]   = {0x28, 0x2a};
-static u8 FAN_SPD_SET[2] = {0x30, 0x31};
-
-static u8 default_limits_local[3] = {70, 50, 70};    /* local, sensor1, sensor2 */
-static u8 default_limits_chip[3] = {80, 65, 80};    /* local, sensor1, sensor2 */
-static const char *sensor_location[3] = { "?", "?", "?" };
+static u8 TEMP_REG[3] = { 0x26, 0x25, 0x27 };	/* local, sensor1, sensor2 */
+static u8 LIMIT_REG[3] = { 0x6b, 0x6a, 0x6c };	/* local, sensor1, sensor2 */
+static u8 MANUAL_MODE[2] = { 0x5c, 0x5d };
+static u8 REM_CONTROL[2] = { 0x00, 0x40 };
+static u8 FAN_SPEED[2] = { 0x28, 0x2a };
+static u8 FAN_SPD_SET[2] = { 0x30, 0x31 };
+
+static u8 default_limits_local[3] = { 45, 50, 70 };	/* local, sensor1, sensor2 */
+static u8 default_limits_chip[3] = { 70, 65, 80 };	/* local, sensor1, sensor2 */
+
+static const char *sensor_location[3];
 
 static int limit_adjust;
 static int fan_speed = -1;
-static bool verbose;
+static int verbose;
 
 MODULE_AUTHOR("Colin Leroy <colin@colino.net>");
 MODULE_DESCRIPTION("Driver for ADT746x thermostat in iBook G4 and "
@@ -59,43 +62,44 @@ MODULE_DESCRIPTION("Driver for ADT746x t
 MODULE_LICENSE("GPL");
 
 module_param(limit_adjust, int, 0644);
-MODULE_PARM_DESC(limit_adjust,"Adjust maximum temperatures (50 sensor1, 70 sensor2) "
+MODULE_PARM_DESC(limit_adjust,
+		 "Adjust maximum temperatures (50 sensor1, 70 sensor2) "
 		 "by N degrees.");
 
 module_param(fan_speed, int, 0644);
-MODULE_PARM_DESC(fan_speed,"Specify starting fan speed (0-255) "
+MODULE_PARM_DESC(fan_speed, "Specify starting fan speed (0-255) "
 		 "(default 64)");
 
 module_param(verbose, bool, 0);
-MODULE_PARM_DESC(verbose,"Verbose log operations "
-		 "(default 0)");
+MODULE_PARM_DESC(verbose, "Verbose log operations " "(default 0)");
 
 struct thermostat {
-	struct i2c_client	*clt;
-	u8			temps[3];
-	u8			cached_temp[3];
-	u8			initial_limits[3];
-	u8			limits[3];
-	int			last_speed[2];
-	int			last_var[2];
-	int			pwm_inv[2];
-	struct task_struct	*thread;
-	struct platform_device	*pdev;
-	enum {
-		ADT7460,
-		ADT7467
-	}			type;
+	struct i2c_client *clt;
+	u8 temps[3];
+	u8 cached_temp[3];
+	u8 initial_limits[3];
+	u8 limits[3];
+	int last_speed[2];
+	int last_var[2];
+	int pwm_inv[2];
 };
 
+static enum { ADT7460, ADT7467 } therm_type;
+static int therm_bus, therm_address;
+static struct platform_device *of_dev;
+static struct thermostat *thermostat;
+static struct task_struct *thread_therm = NULL;
+
 static void write_both_fan_speed(struct thermostat *th, int speed);
 static void write_fan_speed(struct thermostat *th, int speed, int fan);
+static void thermostat_create_files(void);
+static void thermostat_remove_files(void);
 
-static int
-write_reg(struct thermostat* th, int reg, u8 data)
+static int write_reg(struct thermostat *th, int reg, u8 data)
 {
 	u8 tmp[2];
 	int rc;
-	
+
 	tmp[0] = reg;
 	tmp[1] = data;
 	rc = i2c_master_send(th->clt, (const char *)tmp, 2);
@@ -106,13 +110,12 @@ write_reg(struct thermostat* th, int reg
 	return 0;
 }
 
-static int
-read_reg(struct thermostat* th, int reg)
+static int read_reg(struct thermostat *th, int reg)
 {
 	u8 reg_addr, data;
 	int rc;
 
-	reg_addr = (u8)reg;
+	reg_addr = (u8) reg;
 	rc = i2c_master_send(th->clt, &reg_addr, 1);
 	if (rc < 0)
 		return rc;
@@ -124,75 +127,137 @@ read_reg(struct thermostat* th, int reg)
 	return data;
 }
 
+static struct i2c_driver thermostat_driver;
+
+static int attach_thermostat(struct i2c_adapter *adapter)
+{
+	unsigned long bus_no;
+	struct i2c_board_info info;
+	struct i2c_client *client;
+
+	if (strncmp(adapter->name, "uni-n", 5))
+		return -ENODEV;
+	bus_no = simple_strtoul(adapter->name + 6, NULL, 10);
+	if (bus_no != therm_bus)
+		return -ENODEV;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "therm_adt746x", I2C_NAME_SIZE);
+	info.addr = therm_address;
+	client = i2c_new_device(adapter, &info);
+	if (!client)
+		return -ENODEV;
+
+	/*
+	 * Let i2c-core delete that device on driver removal.
+	 * This is safe because i2c-core holds the core_lock mutex for us.
+	 */
+	list_add_tail(&client->detected, &thermostat_driver.clients);
+	return 0;
+}
+
+static int remove_thermostat(struct i2c_client *client)
+{
+	struct thermostat *th = i2c_get_clientdata(client);
+	int i;
+
+	thermostat_remove_files();
+
+	if (thread_therm != NULL) {
+		kthread_stop(thread_therm);
+	}
+
+	printk(KERN_INFO "adt746x: Putting max temperatures back from "
+	       "%d, %d, %d to %d, %d, %d\n",
+	       th->limits[0], th->limits[1], th->limits[2],
+	       th->initial_limits[0], th->initial_limits[1],
+	       th->initial_limits[2]);
+
+	for (i = 0; i < 3; i++)
+		write_reg(th, LIMIT_REG[i], th->initial_limits[i]);
+
+	write_both_fan_speed(th, -1);
+
+	thermostat = NULL;
+
+	kfree(th);
+
+	return 0;
+}
+
 static int read_fan_speed(struct thermostat *th, u8 addr)
 {
 	u8 tmp[2];
 	u16 res;
-	
+
 	/* should start with low byte */
 	tmp[1] = read_reg(th, addr);
 	tmp[0] = read_reg(th, addr + 1);
-	
+
 	res = tmp[1] + (tmp[0] << 8);
 	/* "a value of 0xffff means that the fan has stopped" */
-	return (res == 0xffff ? 0 : (90000*60)/res);
+	return (res == 0xffff ? 0 : (90000 * 60) / res);
 }
 
 static void write_both_fan_speed(struct thermostat *th, int speed)
 {
 	write_fan_speed(th, speed, 0);
-	if (th->type == ADT7460)
+	if (therm_type == ADT7460)
 		write_fan_speed(th, speed, 1);
 }
 
 static void write_fan_speed(struct thermostat *th, int speed, int fan)
 {
 	u8 manual;
-	
-	if (speed > 0xff) 
+
+	if (speed > 0xff)
 		speed = 0xff;
-	else if (speed < -1) 
+	else if (speed < -1)
 		speed = 0;
-	
-	if (th->type == ADT7467 && fan == 1)
+
+	if (therm_type == ADT7467 && fan == 1)
 		return;
-	
+
 	if (th->last_speed[fan] != speed) {
 		if (verbose) {
 			if (speed == -1)
-				printk(KERN_DEBUG "adt746x: Setting speed to automatic "
-					"for %s fan.\n", sensor_location[fan+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting speed to automatic "
+				       "for %s fan.\n",
+				       sensor_location[fan + 1]);
 			else
-				printk(KERN_DEBUG "adt746x: Setting speed to %d "
-					"for %s fan.\n", speed, sensor_location[fan+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting speed to %d "
+				       "for %s fan.\n", speed,
+				       sensor_location[fan + 1]);
 		}
 	} else
 		return;
-	
+
 	if (speed >= 0) {
 		manual = read_reg(th, MANUAL_MODE[fan]);
 		manual &= ~INVERT_MASK;
 		write_reg(th, MANUAL_MODE[fan],
-			manual | MANUAL_MASK | th->pwm_inv[fan]);
+			  manual | MANUAL_MASK | th->pwm_inv[fan]);
 		write_reg(th, FAN_SPD_SET[fan], speed);
 	} else {
 		/* back to automatic */
-		if(th->type == ADT7460) {
+		if (therm_type == ADT7460) {
 			manual = read_reg(th,
-				MANUAL_MODE[fan]) & (~MANUAL_MASK);
+					  MANUAL_MODE[fan]) & (~MANUAL_MASK);
 			manual &= ~INVERT_MASK;
 			manual |= th->pwm_inv[fan];
 			write_reg(th,
-				MANUAL_MODE[fan], manual|REM_CONTROL[fan]);
+				  MANUAL_MODE[fan], manual | REM_CONTROL[fan]);
 		} else {
 			manual = read_reg(th, MANUAL_MODE[fan]);
 			manual &= ~INVERT_MASK;
 			manual |= th->pwm_inv[fan];
-			write_reg(th, MANUAL_MODE[fan], manual&(~AUTO_MASK));
+			write_reg(th, MANUAL_MODE[fan], manual & (~AUTO_MASK));
 		}
 	}
-	
-	th->last_speed[fan] = speed;			
+
+	th->last_speed[fan] = speed;
 }
 
 static void read_sensors(struct thermostat *th)
@@ -200,22 +265,22 @@ static void read_sensors(struct thermost
 	int i = 0;
 
 	for (i = 0; i < 3; i++)
-		th->temps[i]  = read_reg(th, TEMP_REG[i]);
+		th->temps[i] = read_reg(th, TEMP_REG[i]);
 }
 
 #ifdef DEBUG
 static void display_stats(struct thermostat *th)
 {
 	if (th->temps[0] != th->cached_temp[0]
-	||  th->temps[1] != th->cached_temp[1]
-	||  th->temps[2] != th->cached_temp[2]) {
+	    || th->temps[1] != th->cached_temp[1]
+	    || th->temps[2] != th->cached_temp[2]) {
 		printk(KERN_INFO "adt746x: Temperature infos:"
-				 " thermostats: %d,%d,%d;"
-				 " limits: %d,%d,%d;"
-				 " fan speed: %d RPM\n",
-				 th->temps[0], th->temps[1], th->temps[2],
-				 th->limits[0],  th->limits[1],  th->limits[2],
-				 read_fan_speed(th, FAN_SPEED[0]));
+		       " thermostats: %d,%d,%d;"
+		       " limits: %d,%d,%d;"
+		       " fan speed: %d RPM\n",
+		       th->temps[0], th->temps[1], th->temps[2],
+		       th->limits[0], th->limits[1], th->limits[2],
+		       read_fan_speed(th, FAN_SPEED[0]));
 	}
 	th->cached_temp[0] = th->temps[0];
 	th->cached_temp[1] = th->temps[1];
@@ -223,16 +288,86 @@ static void display_stats(struct thermos
 }
 #endif
 
-static void update_fans_speed (struct thermostat *th)
+static void update_fans_speed(struct thermostat *th)
 {
-	int lastvar = 0; /* last variation, for iBook */
-	int i = 0;
 
-	/* we don't care about local sensor, so we start at sensor 1 */
-	for (i = 1; i < 3; i++) {
+	if (therm_type == ADT7460) {
+
+		int lastvar = 0;
+		int i = 0;
+
+		/* we don't care about local sensor, so we start at sensor 1 */
+		for (i = 1; i < 3; i++) {
+			int started = 0;
+			int fan_number = (therm_type == ADT7460 && i == 2);
+			int var = th->temps[i] - th->limits[i];
+
+			if (var > -1) {
+				int step = (255 - fan_speed) / 7;
+				int new_speed = 0;
+
+				/* hysteresis : change fan speed only if variation is
+				 * more than two degrees */
+				if (abs(var - th->last_var[fan_number]) < 2)
+					continue;
+
+				started = 1;
+				new_speed = fan_speed + ((var - 1) * step);
+
+				if (new_speed < fan_speed)
+					new_speed = fan_speed;
+				if (new_speed > 255)
+					new_speed = 255;
+
+				if (verbose)
+					printk(KERN_DEBUG
+					       "adt746x: Setting fans speed to %d "
+					       "(limit exceeded by %d on %s)\n",
+					       new_speed, var,
+					       sensor_location[fan_number + 1]);
+				write_both_fan_speed(th, new_speed);
+				th->last_var[fan_number] = var;
+			} else if (var < -2) {
+				/* don't stop fan if sensor2 is cold and sensor1 is not
+				 * so cold (lastvar >= -1) */
+				if (i == 2 && lastvar < -1) {
+					if (th->last_speed[fan_number] != 0)
+						if (verbose)
+							printk(KERN_DEBUG
+							       "adt746x: Stopping "
+							       "fans.\n");
+					write_both_fan_speed(th, 0);
+				}
+			}
+
+			lastvar = var;
+
+			if (started)
+				return;	/* we don't want to re-stop the fan
+					 * if sensor1 is heating and 
+                                         * sensor2 is not */
+		}
+
+	} else {		
+                /* Single FAN laptops i.e. 12 inch Powerbook, 
+                 * 13 inch Ibook G4 */
+		int lastvar = 0;
+		int i = 0;
+		int var = 0;
+		int var_sensor[3];
 		int started = 0;
-		int fan_number = (th->type == ADT7460 && i == 2);
-		int var = th->temps[i] - th->limits[i];
+		int fan_number = 0;
+
+		/* we CARE about the HDD sensor, so we start at sensor 0 */
+		for (i = 0; i < 3; i++) {
+			var_sensor[i] = th->temps[i] - th->limits[i];
+		}
+		var = var_sensor[0];
+		for (i = 1; i < 3; i++) {
+			if (var_sensor[i] > var) {
+				var = var_sensor[i];
+			}
+		}
 
 		if (var > -1) {
 			int step = (255 - fan_speed) / 7;
@@ -241,10 +376,10 @@ static void update_fans_speed (struct th
 			/* hysteresis : change fan speed only if variation is
 			 * more than two degrees */
 			if (abs(var - th->last_var[fan_number]) < 2)
-				continue;
+				return;
 
 			started = 1;
-			new_speed = fan_speed + ((var-1)*step);
+			new_speed = fan_speed + ((var - 1) * step);
 
 			if (new_speed < fan_speed)
 				new_speed = fan_speed;
@@ -252,38 +387,36 @@ static void update_fans_speed (struct th
 				new_speed = 255;
 
 			if (verbose)
-				printk(KERN_DEBUG "adt746x: Setting fans speed to %d "
-						 "(limit exceeded by %d on %s)\n",
-						new_speed, var,
-						sensor_location[fan_number+1]);
+				printk(KERN_DEBUG
+				       "adt746x: Setting fans speed to %d "
+				       "(limit exceeded by %d on %s)\n",
+				       new_speed, var,
+				       sensor_location[fan_number + 1]);
 			write_both_fan_speed(th, new_speed);
 			th->last_var[fan_number] = var;
 		} else if (var < -2) {
-			/* don't stop fan if sensor2 is cold and sensor1 is not
-			 * so cold (lastvar >= -1) */
-			if (i == 2 && lastvar < -1) {
-				if (th->last_speed[fan_number] != 0)
-					if (verbose)
-						printk(KERN_DEBUG "adt746x: Stopping "
-							"fans.\n");
-				write_both_fan_speed(th, 0);
-			}
+			if (th->last_speed[fan_number] != 0)
+				if (verbose)
+					printk(KERN_DEBUG "adt746x: Stopping "
+					       "fans.\n");
+			write_both_fan_speed(th, 0);
 		}
 
 		lastvar = var;
 
 		if (started)
-			return; /* we don't want to re-stop the fan
-				* if sensor1 is heating and sensor2 is not */
+			return;
+
 	}
+
 }
 
 static int monitor_task(void *arg)
 {
-	struct thermostat* th = arg;
+	struct thermostat *th = arg;
 
 	set_freezable();
-	while(!kthread_should_stop()) {
+	while (!kthread_should_stop()) {
 		try_to_freeze();
 		msleep_interruptible(2000);
 
@@ -292,7 +425,7 @@ static int monitor_task(void *arg)
 			read_sensors(th);
 #else
 		read_sensors(th);
-#endif		
+#endif
 
 		if (fan_speed != -1)
 			update_fans_speed(th);
@@ -311,190 +444,20 @@ static void set_limit(struct thermostat
 	/* Set sensor1 limit higher to avoid powerdowns */
 	th->limits[i] = default_limits_chip[i] + limit_adjust;
 	write_reg(th, LIMIT_REG[i], th->limits[i]);
-		
+
 	/* set our limits to normal */
 	th->limits[i] = default_limits_local[i] + limit_adjust;
 }
 
-#define BUILD_SHOW_FUNC_INT(name, data)				\
-static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)	\
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	return sprintf(buf, "%d\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_INT_LITE(name, data)				\
-static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)	\
-{								\
-	return sprintf(buf, "%d\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_STR(name, data)				\
-static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)       \
-{								\
-	return sprintf(buf, "%s\n", data);			\
-}
-
-#define BUILD_SHOW_FUNC_FAN(name, data)				\
-static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)       \
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	return sprintf(buf, "%d (%d rpm)\n", 			\
-		th->last_speed[data],				\
-		read_fan_speed(th, FAN_SPEED[data])		\
-		);						\
-}
-
-#define BUILD_STORE_FUNC_DEG(name, data)			\
-static ssize_t store_##name(struct device *dev, struct device_attribute *attr, const char *buf, size_t n) \
-{								\
-	struct thermostat *th = dev_get_drvdata(dev);		\
-	int val;						\
-	int i;							\
-	val = simple_strtol(buf, NULL, 10);			\
-	printk(KERN_INFO "Adjusting limits by %d degrees\n", val);	\
-	limit_adjust = val;					\
-	for (i=0; i < 3; i++)					\
-		set_limit(th, i);				\
-	return n;						\
-}
-
-#define BUILD_STORE_FUNC_INT(name, data)			\
-static ssize_t store_##name(struct device *dev, struct device_attribute *attr, const char *buf, size_t n) \
-{								\
-	int val;						\
-	val = simple_strtol(buf, NULL, 10);			\
-	if (val < 0 || val > 255)				\
-		return -EINVAL;					\
-	printk(KERN_INFO "Setting specified fan speed to %d\n", val);	\
-	data = val;						\
-	return n;						\
-}
-
-BUILD_SHOW_FUNC_INT(sensor1_temperature,	 (read_reg(th, TEMP_REG[1])))
-BUILD_SHOW_FUNC_INT(sensor2_temperature,	 (read_reg(th, TEMP_REG[2])))
-BUILD_SHOW_FUNC_INT(sensor1_limit,		 th->limits[1])
-BUILD_SHOW_FUNC_INT(sensor2_limit,		 th->limits[2])
-BUILD_SHOW_FUNC_STR(sensor1_location,		 sensor_location[1])
-BUILD_SHOW_FUNC_STR(sensor2_location,		 sensor_location[2])
-
-BUILD_SHOW_FUNC_INT_LITE(specified_fan_speed, fan_speed)
-BUILD_STORE_FUNC_INT(specified_fan_speed,fan_speed)
-
-BUILD_SHOW_FUNC_FAN(sensor1_fan_speed,	 0)
-BUILD_SHOW_FUNC_FAN(sensor2_fan_speed,	 1)
-
-BUILD_SHOW_FUNC_INT_LITE(limit_adjust,	 limit_adjust)
-BUILD_STORE_FUNC_DEG(limit_adjust,	 th)
-		
-static DEVICE_ATTR(sensor1_temperature,	S_IRUGO,
-		   show_sensor1_temperature,NULL);
-static DEVICE_ATTR(sensor2_temperature,	S_IRUGO,
-		   show_sensor2_temperature,NULL);
-static DEVICE_ATTR(sensor1_limit, S_IRUGO,
-		   show_sensor1_limit,	NULL);
-static DEVICE_ATTR(sensor2_limit, S_IRUGO,
-		   show_sensor2_limit,	NULL);
-static DEVICE_ATTR(sensor1_location, S_IRUGO,
-		   show_sensor1_location, NULL);
-static DEVICE_ATTR(sensor2_location, S_IRUGO,
-		   show_sensor2_location, NULL);
-
-static DEVICE_ATTR(specified_fan_speed,	S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH,
-		   show_specified_fan_speed,store_specified_fan_speed);
-
-static DEVICE_ATTR(sensor1_fan_speed,	S_IRUGO,
-		   show_sensor1_fan_speed,	NULL);
-static DEVICE_ATTR(sensor2_fan_speed,	S_IRUGO,
-		   show_sensor2_fan_speed,	NULL);
-
-static DEVICE_ATTR(limit_adjust,	S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH,
-		   show_limit_adjust,	store_limit_adjust);
-
-static void thermostat_create_files(struct thermostat *th)
-{
-	struct device_node *np = th->clt->dev.of_node;
-	struct device *dev;
-	int err;
-
-	/* To maintain ABI compatibility with userspace, create
-	 * the old style platform driver and attach the attributes
-	 * to it here
-	 */
-	th->pdev = of_platform_device_create(np, "temperatures", NULL);
-	if (!th->pdev)
-		return;
-	dev = &th->pdev->dev;
-	dev_set_drvdata(dev, th);
-	err = device_create_file(dev, &dev_attr_sensor1_temperature);
-	err |= device_create_file(dev, &dev_attr_sensor2_temperature);
-	err |= device_create_file(dev, &dev_attr_sensor1_limit);
-	err |= device_create_file(dev, &dev_attr_sensor2_limit);
-	err |= device_create_file(dev, &dev_attr_sensor1_location);
-	err |= device_create_file(dev, &dev_attr_sensor2_location);
-	err |= device_create_file(dev, &dev_attr_limit_adjust);
-	err |= device_create_file(dev, &dev_attr_specified_fan_speed);
-	err |= device_create_file(dev, &dev_attr_sensor1_fan_speed);
-	if(th->type == ADT7460)
-		err |= device_create_file(dev, &dev_attr_sensor2_fan_speed);
-	if (err)
-		printk(KERN_WARNING
-			"Failed to create temperature attribute file(s).\n");
-}
-
-static void thermostat_remove_files(struct thermostat *th)
-{
-	struct device *dev;
-
-	if (!th->pdev)
-		return;
-	dev = &th->pdev->dev;
-	device_remove_file(dev, &dev_attr_sensor1_temperature);
-	device_remove_file(dev, &dev_attr_sensor2_temperature);
-	device_remove_file(dev, &dev_attr_sensor1_limit);
-	device_remove_file(dev, &dev_attr_sensor2_limit);
-	device_remove_file(dev, &dev_attr_sensor1_location);
-	device_remove_file(dev, &dev_attr_sensor2_location);
-	device_remove_file(dev, &dev_attr_limit_adjust);
-	device_remove_file(dev, &dev_attr_specified_fan_speed);
-	device_remove_file(dev, &dev_attr_sensor1_fan_speed);	
-	if (th->type == ADT7460)
-		device_remove_file(dev, &dev_attr_sensor2_fan_speed);
-	of_device_unregister(th->pdev);
-
-}
-
 static int probe_thermostat(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
-	struct device_node *np = client->dev.of_node;
-	struct thermostat* th;
-	const __be32 *prop;
-	int i, rc, vers, offset = 0;
-
-	if (!np)
-		return -ENXIO;
-	prop = of_get_property(np, "hwsensor-params-version", NULL);
-	if (!prop)
-		return -ENXIO;
-	vers = be32_to_cpup(prop);
-	printk(KERN_INFO "adt746x: version %d (%ssupported)\n",
-	       vers, vers == 1 ? "" : "un");
-	if (vers != 1)
-		return -ENXIO;
-
-	if (of_get_property(np, "hwsensor-location", NULL)) {
-		for (i = 0; i < 3; i++) {
-			sensor_location[i] = of_get_property(np,
-					"hwsensor-location", NULL) + offset;
-
-			if (sensor_location[i] == NULL)
-				sensor_location[i] = "";
+	struct thermostat *th;
+	int rc;
+	int i;
 
-			printk(KERN_INFO "sensor %d: %s\n", i, sensor_location[i]);
-			offset += strlen(sensor_location[i]) + 1;
-		}
-	}
+	if (thermostat)
+		return 0;
 
 	th = kzalloc(sizeof(struct thermostat), GFP_KERNEL);
 	if (!th)
@@ -502,7 +465,6 @@ static int probe_thermostat(struct i2c_c
 
 	i2c_set_clientdata(client, th);
 	th->clt = client;
-	th->type = id->driver_data;
 
 	rc = read_reg(th, CONFIG_REG);
 	if (rc < 0) {
@@ -514,8 +476,8 @@ static int probe_thermostat(struct i2c_c
 	/* force manual control to start the fan quieter */
 	if (fan_speed == -1)
 		fan_speed = 64;
-	
-	if (th->type == ADT7460) {
+
+	if (therm_type == ADT7460) {
 		printk(KERN_INFO "adt746x: ADT7460 initializing\n");
 		/* The 7460 needs to be started explicitly */
 		write_reg(th, CONFIG_REG, 1);
@@ -528,10 +490,12 @@ static int probe_thermostat(struct i2c_c
 	}
 
 	printk(KERN_INFO "adt746x: Lowering max temperatures from %d, %d, %d"
-			 " to %d, %d, %d\n",
-			 th->initial_limits[0], th->initial_limits[1],
-			 th->initial_limits[2], th->limits[0], th->limits[1],
-			 th->limits[2]);
+	       " to %d, %d, %d\n",
+	       th->initial_limits[0], th->initial_limits[1],
+	       th->initial_limits[2], th->limits[0], th->limits[1],
+	       th->limits[2]);
+
+	thermostat = th;
 
 	/* record invert bit status because fw can corrupt it after suspend */
 	th->pwm_inv[0] = read_reg(th, MANUAL_MODE[0]) & INVERT_MASK;
@@ -550,63 +514,199 @@ static int probe_thermostat(struct i2c_c
 		/* automatic mode */
 		write_both_fan_speed(th, -1);
 	}
-	
-	th->thread = kthread_run(monitor_task, th, "kfand");
-	if (th->thread == ERR_PTR(-ENOMEM)) {
+
+	thread_therm = kthread_run(monitor_task, th, "kfand");
+
+	if (thread_therm == ERR_PTR(-ENOMEM)) {
 		printk(KERN_INFO "adt746x: Kthread creation failed\n");
-		th->thread = NULL;
+		thread_therm = NULL;
 		return -ENOMEM;
 	}
 
-	thermostat_create_files(th);
-
-	return 0;
-}
-
-static int remove_thermostat(struct i2c_client *client)
-{
-	struct thermostat *th = i2c_get_clientdata(client);
-	int i;
-	
-	thermostat_remove_files(th);
-
-	if (th->thread != NULL)
-		kthread_stop(th->thread);
-
-	printk(KERN_INFO "adt746x: Putting max temperatures back from "
-			 "%d, %d, %d to %d, %d, %d\n",
-		th->limits[0], th->limits[1], th->limits[2],
-		th->initial_limits[0], th->initial_limits[1],
-		th->initial_limits[2]);
-
-	for (i = 0; i < 3; i++)
-		write_reg(th, LIMIT_REG[i], th->initial_limits[i]);
-
-	write_both_fan_speed(th, -1);
-
-	kfree(th);
+	thermostat_create_files();
 
 	return 0;
 }
 
 static const struct i2c_device_id therm_adt746x_id[] = {
-	{ "MAC,adt7460", ADT7460 },
-	{ "MAC,adt7467", ADT7467 },
-	{ }
+	{"therm_adt746x", 0},
+	{}
 };
-MODULE_DEVICE_TABLE(i2c, therm_adt746x_id);
 
 static struct i2c_driver thermostat_driver = {
 	.driver = {
-		.name	= "therm_adt746x",
-	},
+		   .name = "therm_adt746x",
+		   },
+	.attach_adapter = attach_thermostat,
 	.probe = probe_thermostat,
 	.remove = remove_thermostat,
 	.id_table = therm_adt746x_id,
 };
 
+/* 
+ * Now, unfortunately, sysfs doesn't give us a nice void * we could
+ * pass around to the attribute functions, so we don't really have
+ * choice but implement a bunch of them...
+ *
+ * FIXME, it does now...
+ */
+#define BUILD_SHOW_FUNC_INT(name, data)				\
+static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)	\
+{								\
+	return sprintf(buf, "%d\n", data);			\
+}
+
+#define BUILD_SHOW_FUNC_STR(name, data)				\
+static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)       \
+{								\
+	return sprintf(buf, "%s\n", data);			\
+}
+
+#define BUILD_SHOW_FUNC_FAN(name, data)				\
+static ssize_t show_##name(struct device *dev, struct device_attribute *attr, char *buf)       \
+{								\
+	return sprintf(buf, "%d (%d rpm)\n", 			\
+		thermostat->last_speed[data],			\
+		read_fan_speed(thermostat, FAN_SPEED[data])	\
+		);						\
+}
+
+#define BUILD_STORE_FUNC_DEG(name, data)			\
+static ssize_t store_##name(struct device *dev, struct device_attribute *attr, const char *buf, size_t n) \
+{								\
+	int val;						\
+	int i;							\
+	val = simple_strtol(buf, NULL, 10);			\
+	printk(KERN_INFO "Adjusting limits by %d degrees\n", val);	\
+	limit_adjust = val;					\
+	for (i=0; i < 3; i++)					\
+		set_limit(thermostat, i);			\
+	return n;						\
+}
+
+#define BUILD_STORE_FUNC_INT(name, data)			\
+static ssize_t store_##name(struct device *dev, struct device_attribute *attr, const char *buf, size_t n) \
+{								\
+	int val;						\
+	val = simple_strtol(buf, NULL, 10);			\
+	if (val < 0 || val > 255)				\
+		return -EINVAL;					\
+	printk(KERN_INFO "Setting specified fan speed to %d\n", val);	\
+	data = val;						\
+	return n;						\
+}
+BUILD_SHOW_FUNC_INT(sensor0_temperature, (read_reg(thermostat, TEMP_REG[0])))
+    BUILD_SHOW_FUNC_INT(sensor1_temperature, (read_reg(thermostat, TEMP_REG[1])))
+    BUILD_SHOW_FUNC_INT(sensor2_temperature, (read_reg(thermostat, TEMP_REG[2])))
+    BUILD_SHOW_FUNC_INT(sensor0_limit, thermostat->limits[0])
+    BUILD_SHOW_FUNC_INT(sensor1_limit, thermostat->limits[1])
+    BUILD_SHOW_FUNC_INT(sensor2_limit, thermostat->limits[2])
+    BUILD_SHOW_FUNC_STR(sensor0_location, sensor_location[0])
+    BUILD_SHOW_FUNC_STR(sensor1_location, sensor_location[1])
+    BUILD_SHOW_FUNC_STR(sensor2_location, sensor_location[2])
+
+    BUILD_SHOW_FUNC_INT(specified_fan_speed, fan_speed)
+    BUILD_SHOW_FUNC_FAN(sensor1_fan_speed, 0)
+    BUILD_SHOW_FUNC_FAN(sensor2_fan_speed, 1)
+
+    BUILD_STORE_FUNC_INT(specified_fan_speed, fan_speed)
+    BUILD_SHOW_FUNC_INT(limit_adjust, limit_adjust)
+    BUILD_STORE_FUNC_DEG(limit_adjust, thermostat)
+
+static DEVICE_ATTR(sensor0_temperature, S_IRUGO,
+		   show_sensor0_temperature, NULL);
+static DEVICE_ATTR(sensor1_temperature, S_IRUGO,
+		   show_sensor1_temperature, NULL);
+static DEVICE_ATTR(sensor2_temperature, S_IRUGO,
+		   show_sensor2_temperature, NULL);
+static DEVICE_ATTR(sensor0_limit, S_IRUGO, show_sensor0_limit, NULL);
+static DEVICE_ATTR(sensor1_limit, S_IRUGO, show_sensor1_limit, NULL);
+static DEVICE_ATTR(sensor2_limit, S_IRUGO, show_sensor2_limit, NULL);
+static DEVICE_ATTR(sensor0_location, S_IRUGO, show_sensor0_location, NULL);
+static DEVICE_ATTR(sensor1_location, S_IRUGO, show_sensor1_location, NULL);
+static DEVICE_ATTR(sensor2_location, S_IRUGO, show_sensor2_location, NULL);
+
+static DEVICE_ATTR(specified_fan_speed, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+		   show_specified_fan_speed, store_specified_fan_speed);
+
+static DEVICE_ATTR(sensor1_fan_speed, S_IRUGO, show_sensor1_fan_speed, NULL);
+static DEVICE_ATTR(sensor2_fan_speed, S_IRUGO, show_sensor2_fan_speed, NULL);
+
+static DEVICE_ATTR(limit_adjust, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+		   show_limit_adjust, store_limit_adjust);
+
 static int __init thermostat_init(void)
 {
+	struct device_node *np;
+	const u32 *prop;
+	int i = 0, offset = 0;
+
+	np = of_find_node_by_name(NULL, "fan");
+	if (!np)
+		return -ENODEV;
+	if (of_device_is_compatible(np, "adt7460"))
+		therm_type = ADT7460;
+	else if (of_device_is_compatible(np, "adt7467"))
+		therm_type = ADT7467;
+	else {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	prop = of_get_property(np, "hwsensor-params-version", NULL);
+	printk(KERN_INFO "adt746x: version %d (%ssupported)\n", *prop,
+	       (*prop == 1) ? "" : "un");
+	if (*prop != 1) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
+	/* look for bus either by path or using "reg" */
+	if (strstr(np->full_name, "/i2c-bus@") != NULL) {
+		const char *tmp_bus = (strstr(np->full_name, "/i2c-bus@") + 9);
+		therm_bus = tmp_bus[0] - '0';
+	} else {
+		therm_bus = ((*prop) >> 8) & 0x0f;
+	}
+
+	therm_address = ((*prop) & 0xff) >> 1;
+
+	printk(KERN_INFO "adt746x: Thermostat bus: %d, address: 0x%02x, "
+	       "limit_adjust: %d, fan_speed: %d\n",
+	       therm_bus, therm_address, limit_adjust, fan_speed);
+
+	if (of_get_property(np, "hwsensor-location", NULL)) {
+		for (i = 0; i < 3; i++) {
+			sensor_location[i] = of_get_property(np,
+							     "hwsensor-location",
+							     NULL) + offset;
+
+			if (sensor_location[i] == NULL)
+				sensor_location[i] = "";
+
+			printk(KERN_INFO "sensor %d: %s\n", i,
+			       sensor_location[i]);
+			offset += strlen(sensor_location[i]) + 1;
+		}
+	} else {
+		sensor_location[0] = "?";
+		sensor_location[1] = "?";
+		sensor_location[2] = "?";
+	}
+
+	of_dev = of_platform_device_create(np, "temperatures", NULL);
+	of_node_put(np);
+
+	if (of_dev == NULL) {
+		printk(KERN_ERR "Can't register temperatures device !\n");
+		return -ENODEV;
+	}
 #ifndef CONFIG_I2C_POWERMAC
 	request_module("i2c-powermac");
 #endif
@@ -614,9 +714,58 @@ static int __init thermostat_init(void)
 	return i2c_add_driver(&thermostat_driver);
 }
 
+static void thermostat_create_files(void)
+{
+	int err;
+
+	err = device_create_file(&of_dev->dev, &dev_attr_sensor0_temperature);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_temperature);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_temperature);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor0_limit);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_limit);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_limit);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor0_location);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_location);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_location);
+	err |= device_create_file(&of_dev->dev, &dev_attr_limit_adjust);
+	err |= device_create_file(&of_dev->dev, &dev_attr_specified_fan_speed);
+	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_fan_speed);
+	if (therm_type == ADT7460)
+		err |=
+		    device_create_file(&of_dev->dev,
+				       &dev_attr_sensor2_fan_speed);
+	if (err)
+		printk(KERN_WARNING
+		       "Failed to create temperature attribute file(s).\n");
+}
+
+static void thermostat_remove_files(void)
+{
+	if (of_dev) {
+		device_remove_file(&of_dev->dev, &dev_attr_sensor0_temperature);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor1_temperature);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor2_temperature);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor0_limit);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor1_limit);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor2_limit);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor0_location);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor1_location);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor2_location);
+		device_remove_file(&of_dev->dev, &dev_attr_limit_adjust);
+		device_remove_file(&of_dev->dev, &dev_attr_specified_fan_speed);
+		device_remove_file(&of_dev->dev, &dev_attr_sensor1_fan_speed);
+
+		if (therm_type == ADT7460)
+			device_remove_file(&of_dev->dev,
+					   &dev_attr_sensor2_fan_speed);
+
+	}
+}
+
 static void __exit thermostat_exit(void)
 {
 	i2c_del_driver(&thermostat_driver);
+	of_device_unregister(of_dev);
 }
 
 module_init(thermostat_init);

--MP_//=89q2/BOPdSLOXj.SCe/In--
