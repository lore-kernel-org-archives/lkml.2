Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528Ab2ERGFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:05:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab2ERGFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:05:23 -0400
Date: Fri, 18 May 2012 16:05:07 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120518160507.63cddc24@notabene.brown>
In-Reply-To: <20120515012634.GF25482@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
	<20120501213958.GA15560@ioremap.net>
	<20120502162627.50544c8b@notabene.brown>
	<20120503175857.GA13988@ioremap.net>
	<20120504070838.5bd23110@notabene.brown>
	<20120503212706.GA26612@ioremap.net>
	<20120509114349.5ceee472@notabene.brown>
	<20120515012634.GF25482@ioremap.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X/ZvnM6XFw++czYS9IDfIWn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X/ZvnM6XFw++czYS9IDfIWn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 05:26:34 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Wed, May 09, 2012 at 11:43:49AM +1000, NeilBrown (neilb@suse.de) wrote:
> > However lockdep didn't like it.  There are ordering problems between th=
is
> > mutex and and sysfs's s_active.
> >=20
> > When you access battery properies via sysfs, the sysfs lock is taken fi=
rst,
> > then the master->mutex.
> > When w1_reconnect_slaves calls through to device_del and sys_addrm_fini=
sh,
> > the mutex is held while the sysfs lock is wanted.
>=20
> I only came to idea of not allowing sysfs in ->probe() and instead
> introduce new callback, which will initialize 'external' to w1 core
> parts without holding master's mutex
>=20

The more I think about it, the more I think that we really need to split the
lock in two.  That is the only way to avoid a potential deadlock with sysfs.

What do you think of the following?  It works for me but I cannot test the
other battery controllers or masters.

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Fri, 18 May 2012 15:59:52 +1000
Subject: [PATCH] W1: split master mutex to avoid deadlocks.

The 'mutex' in struct w1_master is use for two very different
purposes.

Firstly it protects various data structures such as the list of all
slaves.

Secondly it protects the w1 buss against concurrent accesses.

This can lead to deadlocks when the ->probe code called while adding a
slave needs to talk on the bus, as is the case for power_supply
devices.
ds2780 and ds2781 drivers contain a work around to track which
process hold the lock simply to avoid this deadlock.  bq27000 doesn't
have that work around and so deadlocks.

There are other possible deadlocks involving sysfs.
When removing a device the sysfs s_active lock is held, so the lock
that protects the slave list must take precedence over s_active.
However when access power_supply attributes via sysfs, the s_active
lock must take precedence over the lock that protects accesses to
the bus.

So to avoid deadlocks between w1 slaves and sysfs, these must be
two separate locks.  Making them separate means that the work around
in ds2780 and ds2781 can be removed.

So this patch:
 - adds a new mutex: "bus_mutex" which serialises access to the bus.
 - takes mutex in w1_search and ds1wm_search while they access
   the bus for searching.  The mutex is dropped before calling the
   callback which adds the slave.
 - changes all slaves to use bus_mutex instead of mutex to
   protect access to the bus
 - removes w1_ds2790_io_nolock and w1_ds2781_io_nolock, and the
   related code from drivers/power/ds278[01]_battery.c which
   calls them.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index de31cae..74fad94 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -39,7 +39,6 @@ struct ds2780_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
-	struct task_struct *mutex_holder;
 };
=20
 enum current_types {
@@ -64,10 +63,7 @@ static inline struct power_supply *to_power_supply(struc=
t device *dev)
 static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
 	char *buf, int addr, size_t count, int io)
 {
-	if (dev_info->mutex_holder =3D=3D current)
-		return w1_ds2780_io_nolock(dev_info->w1_dev, buf, addr, count, io);
-	else
-		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
+	return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
 }
=20
 static inline int ds2780_read8(struct ds2780_device_info *dev_info, u8 *va=
l,
@@ -779,7 +775,6 @@ static int __devinit ds2780_battery_probe(struct platfo=
rm_device *pdev)
 	dev_info->bat.properties	=3D ds2780_battery_props;
 	dev_info->bat.num_properties	=3D ARRAY_SIZE(ds2780_battery_props);
 	dev_info->bat.get_property	=3D ds2780_battery_get_property;
-	dev_info->mutex_holder		=3D current;
=20
 	ret =3D power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -809,8 +804,6 @@ static int __devinit ds2780_battery_probe(struct platfo=
rm_device *pdev)
 		goto fail_remove_bin_file;
 	}
=20
-	dev_info->mutex_holder =3D NULL;
-
 	return 0;
=20
 fail_remove_bin_file:
@@ -830,8 +823,6 @@ static int __devexit ds2780_battery_remove(struct platf=
orm_device *pdev)
 {
 	struct ds2780_device_info *dev_info =3D platform_get_drvdata(pdev);
=20
-	dev_info->mutex_holder =3D current;
-
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
=20
diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
index ca0d653..9943e4d 100644
--- a/drivers/power/ds2781_battery.c
+++ b/drivers/power/ds2781_battery.c
@@ -37,7 +37,6 @@ struct ds2781_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
-	struct task_struct *mutex_holder;
 };
=20
 enum current_types {
@@ -62,11 +61,7 @@ static inline struct power_supply *to_power_supply(struc=
t device *dev)
 static inline int ds2781_battery_io(struct ds2781_device_info *dev_info,
 	char *buf, int addr, size_t count, int io)
 {
-	if (dev_info->mutex_holder =3D=3D current)
-		return w1_ds2781_io_nolock(dev_info->w1_dev, buf, addr,
-				count, io);
-	else
-		return w1_ds2781_io(dev_info->w1_dev, buf, addr, count, io);
+	return w1_ds2781_io(dev_info->w1_dev, buf, addr, count, io);
 }
=20
 int w1_ds2781_read(struct ds2781_device_info *dev_info, char *buf,
@@ -783,7 +778,6 @@ static int __devinit ds2781_battery_probe(struct platfo=
rm_device *pdev)
 	dev_info->bat.properties	=3D ds2781_battery_props;
 	dev_info->bat.num_properties	=3D ARRAY_SIZE(ds2781_battery_props);
 	dev_info->bat.get_property	=3D ds2781_battery_get_property;
-	dev_info->mutex_holder		=3D current;
=20
 	ret =3D power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -813,8 +807,6 @@ static int __devinit ds2781_battery_probe(struct platfo=
rm_device *pdev)
 		goto fail_remove_bin_file;
 	}
=20
-	dev_info->mutex_holder =3D NULL;
-
 	return 0;
=20
 fail_remove_bin_file:
@@ -834,8 +826,6 @@ static int __devexit ds2781_battery_remove(struct platf=
orm_device *pdev)
 {
 	struct ds2781_device_info *dev_info =3D platform_get_drvdata(pdev);
=20
-	dev_info->mutex_holder =3D current;
-
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
=20
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index a0c8965..530a2d3 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -334,7 +334,9 @@ static void ds1wm_search(void *data, struct w1_master *=
master_dev,
 			return;
 		}
=20
+		mutex_lock(&master_dev->bus_mutex);
 		if (ds1wm_reset(ds1wm_data)) {
+			mutex_unlock(&master_dev->bus_mutex);
 			dev_dbg(&ds1wm_data->pdev->dev,
 				"pass: %d reset error (or no slaves)\n", pass);
 			break;
@@ -387,6 +389,7 @@ static void ds1wm_search(void *data, struct w1_master *=
master_dev,
=20
 		}
 		if (ds1wm_data->read_error) {
+			mutex_unlock(&master_dev->bus_mutex);
 			dev_err(&ds1wm_data->pdev->dev,
 				"pass: %d read error, retrying\n", pass);
 			break;
@@ -400,6 +403,7 @@ static void ds1wm_search(void *data, struct w1_master *=
master_dev,
 		dev_dbg(&ds1wm_data->pdev->dev,
 			"pass: %d resetting bus\n", pass);
 		ds1wm_reset(ds1wm_data);
+		mutex_unlock(&master_dev->bus_mutex);
 		if ((r_prime & ((u64)1 << 63)) && (d & ((u64)1 << 63))) {
 			dev_err(&ds1wm_data->pdev->dev,
 				"pass: %d bus error, retrying\n", pass);
diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 52ad812..773dca5 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -31,10 +31,10 @@ static int w1_bq27000_read(struct device *dev, unsigned=
 int reg)
 	u8 val;
 	struct w1_slave *sl =3D container_of(dev->parent, struct w1_slave, dev);
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val =3D w1_read_8(sl->master);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return val;
 }
diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index 7c8cdb8..485dc34 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -52,11 +52,11 @@ static int _read_reg(struct w1_slave *sl, u8 address, u=
nsigned char* buf)
 	if (!buf)
 		return -EINVAL;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	dev_dbg(&sl->dev, "mutex locked");
=20
 	if (w1_reset_select_slave(sl)) {
-		mutex_unlock(&sl->master->mutex);
+		mutex_unlock(&sl->master->bus_mutex);
 		return -EIO;
 	}
=20
@@ -66,7 +66,7 @@ static int _read_reg(struct w1_slave *sl, u8 address, uns=
igned char* buf)
 	w1_write_block(sl->master, wrbuf, 3);
 	*buf =3D w1_read_8(sl->master);
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	dev_dbg(&sl->dev, "mutex unlocked");
 	return 1;
 }
@@ -165,7 +165,7 @@ static ssize_t w1_f29_write_output(
 		return -EFAULT;
=20
 	dev_dbg(&sl->dev, "locking mutex for write_output");
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	dev_dbg(&sl->dev, "mutex locked");
=20
 	if (w1_reset_select_slave(sl))
@@ -200,14 +200,14 @@ static ssize_t w1_f29_write_output(
 		/* read the result of the READ_PIO_REGS command */
 		if (w1_read_8(sl->master) =3D=3D *buf) {
 			/* success! */
-			mutex_unlock(&sl->master->mutex);
+			mutex_unlock(&sl->master->bus_mutex);
 			dev_dbg(&sl->dev,
 				"mutex unlocked, retries:%d", retries);
 			return 1;
 		}
 	}
 error:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	dev_dbg(&sl->dev, "mutex unlocked in error, retries:%d", retries);
=20
 	return -EIO;
@@ -228,7 +228,7 @@ static ssize_t w1_f29_write_activity(
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (w1_reset_select_slave(sl))
 		goto error;
@@ -236,7 +236,7 @@ static ssize_t w1_f29_write_activity(
 	while (retries--) {
 		w1_write_8(sl->master, W1_F29_FUNC_RESET_ACTIVITY_LATCHES);
 		if (w1_read_8(sl->master) =3D=3D W1_F29_SUCCESS_CONFIRM_BYTE) {
-			mutex_unlock(&sl->master->mutex);
+			mutex_unlock(&sl->master->bus_mutex);
 			return 1;
 		}
 		if (w1_reset_resume_command(sl->master))
@@ -244,7 +244,7 @@ static ssize_t w1_f29_write_activity(
 	}
=20
 error:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return -EIO;
 }
=20
@@ -263,7 +263,7 @@ static ssize_t w1_f29_write_status_control(
 	if (count !=3D 1 || off !=3D 0)
 		return -EFAULT;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (w1_reset_select_slave(sl))
 		goto error;
@@ -285,12 +285,12 @@ static ssize_t w1_f29_write_status_control(
 		w1_write_block(sl->master, w1_buf, 3);
 		if (w1_read_8(sl->master) =3D=3D *buf) {
 			/* success! */
-			mutex_unlock(&sl->master->mutex);
+			mutex_unlock(&sl->master->bus_mutex);
 			return 1;
 		}
 	}
 error:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return -EIO;
 }
diff --git a/drivers/w1/slaves/w1_ds2423.c b/drivers/w1/slaves/w1_ds2423.c
index 7a7dbe5..40a10b5 100644
--- a/drivers/w1/slaves/w1_ds2423.c
+++ b/drivers/w1/slaves/w1_ds2423.c
@@ -66,7 +66,7 @@ static ssize_t w1_counter_read(struct device *device,
 	wrbuf[0]	=3D 0xA5;
 	wrbuf[1]	=3D rom_addr & 0xFF;
 	wrbuf[2]	=3D rom_addr >> 8;
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->bus_mutex);
 	if (!w1_reset_select_slave(sl)) {
 		w1_write_block(dev, wrbuf, 3);
 		read_byte_count =3D 0;
@@ -124,7 +124,7 @@ static ssize_t w1_counter_read(struct device *device,
 	} else {
 		c -=3D snprintf(out_buf + PAGE_SIZE - c, c, "Connection error");
 	}
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->bus_mutex);
 	return PAGE_SIZE - c;
 }
=20
diff --git a/drivers/w1/slaves/w1_ds2431.c b/drivers/w1/slaves/w1_ds2431.c
index 84e2410..984b303 100644
--- a/drivers/w1/slaves/w1_ds2431.c
+++ b/drivers/w1/slaves/w1_ds2431.c
@@ -107,7 +107,7 @@ static ssize_t w1_f2d_read_bin(struct file *filp, struc=
t kobject *kobj,
 	if (count =3D=3D 0)
 		return 0;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	/* read directly from the EEPROM in chunks of W1_F2D_READ_MAXLEN */
 	while (todo > 0) {
@@ -126,7 +126,7 @@ static ssize_t w1_f2d_read_bin(struct file *filp, struc=
t kobject *kobj,
 		off +=3D W1_F2D_READ_MAXLEN;
 	}
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return count;
 }
@@ -214,7 +214,7 @@ static ssize_t w1_f2d_write_bin(struct file *filp, stru=
ct kobject *kobj,
 	if (count =3D=3D 0)
 		return 0;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	/* Can only write data in blocks of the size of the scratchpad */
 	addr =3D off;
@@ -259,7 +259,7 @@ static ssize_t w1_f2d_write_bin(struct file *filp, stru=
ct kobject *kobj,
 	}
=20
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return count;
 }
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 0f7b8f9..85f2cdb 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -107,7 +107,7 @@ static ssize_t w1_f23_read_bin(struct file *filp, struc=
t kobject *kobj,
 	if ((count =3D w1_f23_fix_count(off, count, W1_EEPROM_SIZE)) =3D=3D 0)
 		return 0;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
=20
@@ -138,7 +138,7 @@ static ssize_t w1_f23_read_bin(struct file *filp, struc=
t kobject *kobj,
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
=20
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return count;
 }
@@ -233,7 +233,7 @@ static ssize_t w1_f23_write_bin(struct file *filp, stru=
ct kobject *kobj,
 	}
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	/* Can only write data to one page at a time */
 	idx =3D 0;
@@ -251,7 +251,7 @@ static ssize_t w1_f23_write_bin(struct file *filp, stru=
ct kobject *kobj,
 	}
=20
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return count;
 }
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 5754c9a..aa7bd5f 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -31,7 +31,7 @@ static int w1_ds2760_io(struct device *dev, char *buf, in=
t addr, size_t count,
 	if (!dev)
 		return 0;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (addr > DS2760_DATA_SIZE || addr < 0) {
 		count =3D 0;
@@ -54,7 +54,7 @@ static int w1_ds2760_io(struct device *dev, char *buf, in=
t addr, size_t count,
 	}
=20
 out:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return count;
 }
@@ -76,14 +76,14 @@ static int w1_ds2760_eeprom_cmd(struct device *dev, int=
 addr, int cmd)
 	if (!dev)
 		return -EINVAL;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (w1_reset_select_slave(sl) =3D=3D 0) {
 		w1_write_8(sl->master, cmd);
 		w1_write_8(sl->master, addr);
 	}
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return 0;
 }
=20
diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 39f78c0..7b09307 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -60,30 +60,16 @@ int w1_ds2780_io(struct device *dev, char *buf, int add=
r, size_t count,
 	if (!dev)
 		return -ENODEV;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	ret =3D w1_ds2780_do_io(dev, buf, addr, count, io);
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return ret;
 }
 EXPORT_SYMBOL(w1_ds2780_io);
=20
-int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr, size_t co=
unt,
-			int io)
-{
-	int ret;
-
-	if (!dev)
-		return -ENODEV;
-
-	ret =3D w1_ds2780_do_io(dev, buf, addr, count, io);
-
-	return ret;
-}
-EXPORT_SYMBOL(w1_ds2780_io_nolock);
-
 int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl =3D container_of(dev, struct w1_slave, dev);
@@ -91,14 +77,14 @@ int w1_ds2780_eeprom_cmd(struct device *dev, int addr, =
int cmd)
 	if (!dev)
 		return -EINVAL;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (w1_reset_select_slave(sl) =3D=3D 0) {
 		w1_write_8(sl->master, cmd);
 		w1_write_8(sl->master, addr);
 	}
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(w1_ds2780_eeprom_cmd);
diff --git a/drivers/w1/slaves/w1_ds2780.h b/drivers/w1/slaves/w1_ds2780.h
index 7373793..a1fba79 100644
--- a/drivers/w1/slaves/w1_ds2780.h
+++ b/drivers/w1/slaves/w1_ds2780.h
@@ -124,8 +124,6 @@
=20
 extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t co=
unt,
 			int io);
-extern int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr,
-			size_t count, int io);
 extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
=20
 #endif /* !_W1_DS2780_H */
diff --git a/drivers/w1/slaves/w1_ds2781.c b/drivers/w1/slaves/w1_ds2781.c
index 0d0c798..877daf7 100644
--- a/drivers/w1/slaves/w1_ds2781.c
+++ b/drivers/w1/slaves/w1_ds2781.c
@@ -58,30 +58,16 @@ int w1_ds2781_io(struct device *dev, char *buf, int add=
r, size_t count,
 	if (!dev)
 		return -ENODEV;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	ret =3D w1_ds2781_do_io(dev, buf, addr, count, io);
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
=20
 	return ret;
 }
 EXPORT_SYMBOL(w1_ds2781_io);
=20
-int w1_ds2781_io_nolock(struct device *dev, char *buf, int addr, size_t co=
unt,
-			int io)
-{
-	int ret;
-
-	if (!dev)
-		return -ENODEV;
-
-	ret =3D w1_ds2781_do_io(dev, buf, addr, count, io);
-
-	return ret;
-}
-EXPORT_SYMBOL(w1_ds2781_io_nolock);
-
 int w1_ds2781_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl =3D container_of(dev, struct w1_slave, dev);
@@ -89,14 +75,14 @@ int w1_ds2781_eeprom_cmd(struct device *dev, int addr, =
int cmd)
 	if (!dev)
 		return -EINVAL;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
=20
 	if (w1_reset_select_slave(sl) =3D=3D 0) {
 		w1_write_8(sl->master, cmd);
 		w1_write_8(sl->master, addr);
 	}
=20
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(w1_ds2781_eeprom_cmd);
diff --git a/drivers/w1/slaves/w1_ds2781.h b/drivers/w1/slaves/w1_ds2781.h
index 82bc664..557dfb0 100644
--- a/drivers/w1/slaves/w1_ds2781.h
+++ b/drivers/w1/slaves/w1_ds2781.h
@@ -129,8 +129,6 @@
=20
 extern int w1_ds2781_io(struct device *dev, char *buf, int addr, size_t co=
unt,
 			int io);
-extern int w1_ds2781_io_nolock(struct device *dev, char *buf, int addr,
-			size_t count, int io);
 extern int w1_ds2781_eeprom_cmd(struct device *dev, int addr, int cmd);
=20
 #endif /* !_W1_DS2781_H */
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index ff29ae7..d90062b 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -179,7 +179,7 @@ static ssize_t w1_therm_read(struct device *device,
 	int i, max_trying =3D 10;
 	ssize_t c =3D PAGE_SIZE;
=20
-	i =3D mutex_lock_interruptible(&dev->mutex);
+	i =3D mutex_lock_interruptible(&dev->bus_mutex);
 	if (i !=3D 0)
 		return i;
=20
@@ -207,19 +207,19 @@ static ssize_t w1_therm_read(struct device *device,
 			w1_write_8(dev, W1_CONVERT_TEMP);
=20
 			if (external_power) {
-				mutex_unlock(&dev->mutex);
+				mutex_unlock(&dev->bus_mutex);
=20
 				sleep_rem =3D msleep_interruptible(tm);
 				if (sleep_rem !=3D 0)
 					return -EINTR;
=20
-				i =3D mutex_lock_interruptible(&dev->mutex);
+				i =3D mutex_lock_interruptible(&dev->bus_mutex);
 				if (i !=3D 0)
 					return i;
 			} else if (!w1_strong_pullup) {
 				sleep_rem =3D msleep_interruptible(tm);
 				if (sleep_rem !=3D 0) {
-					mutex_unlock(&dev->mutex);
+					mutex_unlock(&dev->bus_mutex);
 					return -EINTR;
 				}
 			}
@@ -258,7 +258,7 @@ static ssize_t w1_therm_read(struct device *device,
=20
 	c -=3D snprintf(buf + PAGE_SIZE - c, c, "t=3D%d\n",
 		w1_convert_temp(rom, sl->family->fid));
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->bus_mutex);
=20
 	return PAGE_SIZE - c;
 }
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9761950..31af83e 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -887,16 +887,21 @@ void w1_search(struct w1_master *dev, u8 search_type,=
 w1_slave_found_callback cb
 		 *
 		 * Return 0 - device(s) present, 1 - no devices present.
 		 */
+		mutex_lock(&dev->bus_mutex);
 		if (w1_reset_bus(dev)) {
+			mutex_unlock(&dev->bus_mutex);
 			dev_dbg(&dev->dev, "No devices present on the wire.\n");
 			break;
 		}
=20
 		/* Do fast search on single slave bus */
 		if (dev->max_slave_count =3D=3D 1) {
+			int rv;
 			w1_write_8(dev, W1_READ_ROM);
+			rv =3D w1_read_block(dev, (u8 *)&rn, 8);
+			mutex_unlock(&dev->bus_mutex);
=20
-			if (w1_read_block(dev, (u8 *)&rn, 8) =3D=3D 8 && rn)
+			if (rv =3D=3D 8 && rn)
 				cb(dev, rn);
=20
 			break;
@@ -929,10 +934,12 @@ void w1_search(struct w1_master *dev, u8 search_type,=
 w1_slave_found_callback cb
 			rn |=3D (tmp64 << i);
=20
 			if (kthread_should_stop()) {
+				mutex_unlock(&dev->bus_mutex);
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
 		}
+		mutex_unlock(&dev->bus_mutex);
=20
 		if ( (triplet_ret & 0x03) !=3D 0x03 ) {
 			if ( (desc_bit =3D=3D last_zero) || (last_zero < 0))
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 4d012ca..45908e5 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -180,6 +180,7 @@ struct w1_master
=20
 	struct task_struct	*thread;
 	struct mutex		mutex;
+	struct mutex		bus_mutex;
=20
 	struct device_driver	*driver;
 	struct device		dev;
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 6828835..5314341 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -76,6 +76,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_=
count, int slave_ttl,
=20
 	INIT_LIST_HEAD(&dev->slist);
 	mutex_init(&dev->mutex);
+	mutex_init(&dev->bus_mutex);
=20
 	memcpy(&dev->dev, device, sizeof(struct device));
 	dev_set_name(&dev->dev, "w1_bus_master%u", dev->id);

--Sig_/X/ZvnM6XFw++czYS9IDfIWn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Xmkznsnt1WYoG5AQI0qw//WmLY8fsMf53xPwUcggTYj3qQ3mXpcMA1
eFcz8X1FER4B44s0MESA7DItwI5YZk4YsFMJOaoC9h8KqGDRHQi7xa5MvINP7lLD
yVA3hEB3v8c1BU9l9JQGPPXXf0RJn3xkk2aCTGn+Y45LoEWheahuLGTJFjG3HzPt
cDz89WwkGFhjI51SQdSomIaZK90oD53ZmtQ8ZcRl00ezg82cmCxT0JmL9VIt1oRY
idRkDPfp0hqan35P0iF2eIBnnyZY0I/bhGa2tXhiWJE9x6AAm7Bp/SIBNljNhpg5
CX102aZdTg0+Bg7Wdx2KPl4w4aIAzTK1F8z4SyHkwW6EeGNVnwUjuAV5o/xjtq6j
brd2U6M1DiAB+13uYqQ52l4Ag6YE0gdFsCnkTeQgZJKp6vj0iBpK3pgxnl5qxp3a
q2OLVjG7kCo3u7zEJb7t8qz0uk4yMTua6I1qVjfsuv5Az23u35bf1nwI8vzzqFdX
lzDOT5Mr/TSrxvkES0Or1QRhEPNd5gmKIRgFWaWAcYq7qbFgZhVTO7UwCC1EsAYF
DAu/hdyB7NW0iHwQ9lvyNCRaQdKcK3yk7q9UCF68KMK2cYmeENGrO8/vq0NVQTWg
SXQEe44j9BPyU9CXO7Y5ANh/BYbSNVmRDtUtPSnF5b5Wc9nBfYeQageSF0k6ALeJ
1J3fLzY0RXk=
=gx9s
-----END PGP SIGNATURE-----

--Sig_/X/ZvnM6XFw++czYS9IDfIWn--
