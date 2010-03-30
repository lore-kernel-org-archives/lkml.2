Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0C3JGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:06:47 -0400
Received: from vps.mortis.eu ([79.99.135.181]:57687 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0C3JGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:06:44 -0400
Date: Tue, 30 Mar 2010 11:06:39 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Wim Van Sebroeck <wim@iguana.be>, Laurens Leemans <laurens@signips.com>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] watchdog: f71808e_wdt: new watchdog driver
 for Fintek F71808E
Message-ID: <20100330090639.GA8822@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <1269523063-30346-2-git-send-email-me@mortis.eu>
 <1269523063-30346-3-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1269523063-30346-3-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2010 at 02:17:43PM +0100, Giel van Schijndel wrote:
> Add a new watchdog driver for the Fintek F71808E Super I/O chip.

Updated patch:
 * fixes a bug where detection wouldn't function properly if a
   non-Fintek device was found (or a wrong Super I/O port chosen).
 * Add support for the F71882FG

NOTE: This patch depends on patch [1] (applied in [2]) and patch [3].

[1] https://patchwork.kernel.org/patch/89023/
[2] http://git.kernel.org/?p=3Dlinux/kernel/git/jbarnes/pci-2.6.git;a=3Dcom=
mit;h=3D316607809324cc796c0809630b6ae8a768404296
[3] https://patchwork.kernel.org/patch/88235/

Patch after this line:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[RFC] watchdog: f71808e_wdt: new watchdog driver for Fintek F71808E

Add a new watchdog driver for the Fintek F71808E Super I/O chip.
---
 drivers/watchdog/Kconfig       |   11 +
 drivers/watchdog/Makefile      |    1 +
 drivers/watchdog/f71808e_wdt.c |  767 ++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 779 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/f71808e_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 050ee14..d973105 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -366,6 +366,17 @@ config ALIM7101_WDT
=20
 	  Most people will say N.
=20
+config F71808E_WDT
+	tristate "Fintek F71808E Watchdog"
+	depends on X86 && EXPERIMENTAL
+	help
+	  This is the driver for the hardware watchdog on the Fintek
+	  F71808E Super I/O chip.
+
+	  You can compile this driver directly into the kernel, or use
+	  it as a module.  The module will be called f71808e_wdt.
+
+
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
 	depends on CS5535_MFGPT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 475c611..6f0f3d9 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_ACQUIRE_WDT) +=3D acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) +=3D advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) +=3D alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) +=3D alim7101_wdt.o
+obj-$(CONFIG_F71808E_WDT) +=3D f71808e_wdt.o
 obj-$(CONFIG_GEODE_WDT) +=3D geodewdt.o
 obj-$(CONFIG_SC520_WDT) +=3D sc520_wdt.o
 obj-$(CONFIG_SBC_FITPC2_WATCHDOG) +=3D sbc_fitpc2_wdt.o
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
new file mode 100644
index 0000000..b0314ea
--- /dev/null
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -0,0 +1,767 @@
+/*************************************************************************=
**
+ *   Copyright (C) 2006 by Hans Edgington <hans@edgington.nl>             =
 *
+ *   Copyright (C) 2007-2009 Hans de Goede <hdegoede@redhat.com>          =
 *
+ *   Copyright (C) 2010 Giel van Schijndel <me@mortis.eu>                 =
 *
+ *                                                                        =
 *
+ *   This program is free software; you can redistribute it and/or modify =
 *
+ *   it under the terms of the GNU General Public License as published by =
 *
+ *   the Free Software Foundation; either version 2 of the License, or    =
 *
+ *   (at your option) any later version.                                  =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of       =
 *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        =
 *
+ *   GNU General Public License for more details.                         =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, write to the                        =
 *
+ *   Free Software Foundation, Inc.,                                      =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
**/
+
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define DRVNAME "f71808e_wdt"
+
+#define SIO_F71808FG_LD_WDT	0x07	/* Watchdog timer logical device */
+#define SIO_UNLOCK_KEY		0x87	/* Key to enable Super-I/O */
+#define SIO_LOCK_KEY		0xAA	/* Key to diasble Super-I/O */
+
+#define SIO_REG_LDSEL		0x07	/* Logical device select */
+#define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
+#define SIO_REG_DEVREV		0x22	/* Device revision */
+#define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */
+#define SIO_REG_ENABLE		0x30	/* Logical device enable */
+#define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
+
+#define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
+#define SIO_F71808_ID		0x0901  /* Chipset ID */
+#define SIO_F71858_ID		0x0507  /* Chipset ID */
+#define SIO_F71862_ID		0x0601	/* Chipset ID */
+#define SIO_F71882_ID		0x0541	/* Chipset ID */
+#define SIO_F71889_ID		0x0723	/* Chipset ID */
+
+#define	F71882FG_REG_START		0x01
+
+#define F71808FG_REG_WDO_CONF		0xf0
+#define F71808FG_REG_WDT_CONF		0xf5
+#define F71808FG_REG_WD_TIME		0xf6
+
+#define F71808FG_FLAG_WDOUT_EN		7
+
+#define F71808FG_FLAG_WDTMOUT_STS	5
+#define F71808FG_FLAG_WD_EN		5
+#define F71808FG_FLAG_WD_PULSE		4
+#define F71808FG_FLAG_WD_UNIT		3
+
+/* Default values */
+#define WATCHDOG_TIMEOUT	60	/* 1 minute default timeout */
+#define WATCHDOG_MAX_TIMEOUT	(60 * 255)
+#define WATCHDOG_PULSE_WIDTH	125	/* 125 ms, default pulse width for
+					   watchdog signal */
+
+static unsigned short force_id;
+module_param(force_id, ushort, 0);
+MODULE_PARM_DESC(force_id, "Override the detected device ID");
+
+static const int max_timeout =3D WATCHDOG_MAX_TIMEOUT;
+static int timeout =3D 60;	/* default timeout in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<=3D timeout <=3D"
+			__MODULE_STRING(WATCHDOG_MAX_TIMEOUT) " (default=3D"
+			__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+static unsigned int pulse_width =3D WATCHDOG_PULSE_WIDTH;
+module_param(pulse_width, uint, 0);
+MODULE_PARM_DESC(pulse_width,
+	"Watchdog signal pulse width. 0(=3Dlevel), 1 ms, 25 ms, 125 ms or 5000 ms"
+			" (default=3D" __MODULE_STRING(WATCHDOG_PULSE_WIDTH) ")");
+
+static int nowayout =3D WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0444);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+static unsigned int start_withtimeout;
+module_param(start_withtimeout, uint, 0);
+MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load w=
ith"
+	" given initial timeout. Zero (default) disables this feature.");
+
+enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg };
+
+static const char *f71808e_names[] =3D {
+	"f71808fg",
+	"f71858fg",
+	"f71862fg",
+	"f71882fg",
+	"f71889fg",
+};
+
+/* Super-I/O Function prototypes */
+static inline int superio_inb(int base, int reg);
+static inline int superio_inw(int base, int reg);
+static inline void superio_outb(int base, int reg, u8 val);
+static inline void superio_set_bit(int base, int reg, int bit);
+static inline void superio_clear_bit(int base, int reg, int bit);
+static inline int superio_enter(int base);
+static inline void superio_select(int base, int ld);
+static inline void superio_exit(int base);
+
+struct watchdog_data {
+	unsigned short	sioaddr;
+	enum chips	type;
+	unsigned long	opened;
+	struct mutex	lock;
+	char		expect_close;
+	struct watchdog_info ident;
+
+	unsigned short	timeout;
+	u8		timer_val;	/* content for the wd_time register */
+	char		minutes_mode;
+	u8		pulse_val;	/* pulse width flag */
+	char		pulse_mode;	/* enable pulse output mode? */
+	char		caused_reboot;	/* last reboot was by the watchdog */
+};
+
+static struct watchdog_data watchdog =3D {
+	.lock =3D __MUTEX_INITIALIZER(watchdog.lock),
+};
+
+/* Super I/O functions */
+static inline int superio_inb(int base, int reg)
+{
+	outb(reg, base);
+	return inb(base + 1);
+}
+
+static int superio_inw(int base, int reg)
+{
+	int val;
+	val  =3D superio_inb(base, reg) << 8;
+	val |=3D superio_inb(base, reg + 1);
+	return val;
+}
+
+static inline void superio_outb(int base, int reg, u8 val)
+{
+	outb(reg, base);
+	outb(val, base + 1);
+}
+
+static inline void superio_set_bit(int base, int reg, int bit)
+{
+	unsigned long val =3D superio_inb(base, reg);
+	__set_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
+static inline void superio_clear_bit(int base, int reg, int bit)
+{
+	unsigned long val =3D superio_inb(base, reg);
+	__clear_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
+static inline int superio_enter(int base)
+{
+	/* Don't step on other drivers' I/O space by accident */
+	if (!request_muxed_region(base, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
+				(int)base);
+		return -EBUSY;
+	}
+
+	/* according to the datasheet the key must be send twice! */
+	outb(SIO_UNLOCK_KEY, base);
+	outb(SIO_UNLOCK_KEY, base);
+
+	return 0;
+}
+
+static inline void superio_select(int base, int ld)
+{
+	outb(SIO_REG_LDSEL, base);
+	outb(ld, base + 1);
+}
+
+static inline void superio_exit(int base)
+{
+	outb(SIO_LOCK_KEY, base);
+	release_region(base, 2);
+}
+
+static int watchdog_set_timeout(int timeout)
+{
+	if (timeout <=3D 0
+	 || timeout >  max_timeout) {
+		printk(KERN_ERR DRVNAME ": watchdog timeout out of range\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&watchdog.lock);
+
+	watchdog.timeout =3D timeout;
+	if (timeout > 0xff) {
+		watchdog.timer_val =3D DIV_ROUND_UP(timeout, 60);
+		watchdog.minutes_mode =3D true;
+	} else {
+		watchdog.timer_val =3D timeout;
+		watchdog.minutes_mode =3D false;
+	}
+
+	mutex_unlock(&watchdog.lock);
+
+	return 0;
+}
+
+static int watchdog_set_pulse_width(unsigned int pw)
+{
+	int err =3D 0;
+
+	mutex_lock(&watchdog.lock);
+
+	if        (pw <=3D    1) {
+		watchdog.pulse_val =3D 0;
+	} else if (pw <=3D   25) {
+		watchdog.pulse_val =3D 1;
+	} else if (pw <=3D  125) {
+		watchdog.pulse_val =3D 2;
+	} else if (pw <=3D 5000) {
+		watchdog.pulse_val =3D 3;
+	} else {
+		printk(KERN_ERR DRVNAME ": pulse width out of range\n");
+		err =3D -EINVAL;
+		goto exit_unlock;
+	}
+
+	watchdog.pulse_mode =3D pw;
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return err;
+}
+
+static int watchdog_keepalive(void)
+{
+	int err =3D 0;
+
+	mutex_lock(&watchdog.lock);
+	err =3D superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	if (watchdog.minutes_mode)
+		/* select minutes for timer units */
+		superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+	else
+		/* select seconds for timer units */
+		superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+
+	/* Set timer value */
+	superio_outb(watchdog.sioaddr, F71808FG_REG_WD_TIME,
+			   watchdog.timeout);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return err;
+}
+
+static int watchdog_start(void)
+{
+	/* Make sure we don't die as soon as the watchdog is enabled below */
+	int err =3D watchdog_keepalive();
+	if (err)
+		return err;
+
+	mutex_lock(&watchdog.lock);
+	err =3D superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	/* Watchdog pin configuration */
+	switch (watchdog.type) {
+	case f71808fg:
+		/* Set pin 21 to GPIO23/WDTRST#, then to WDTRST# */
+		superio_clear_bit(watchdog.sioaddr, 0x2a, 3);
+		superio_clear_bit(watchdog.sioaddr, 0x2b, 3);
+		break;
+
+	case f71882fg:
+		/* Set pin 56 to WDTRST# */
+		superio_set_bit(watchdog.sioaddr, 0x29, 1);
+		break;
+
+	default:
+		/*
+		 * 'default' label to shut up the compiler and catch
+		 * programmer errors
+		 */
+		err =3D -ENODEV;
+		goto exit_superio;
+	}
+
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+	superio_set_bit(watchdog.sioaddr, SIO_REG_ENABLE, 0);
+	superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDO_CONF,
+			F71808FG_FLAG_WDOUT_EN);
+
+	superio_set_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	if (watchdog.pulse_mode) {
+		/* Select "pulse" output mode with given duration */
+		u8 wdt_conf =3D superio_inb(watchdog.sioaddr,
+				F71808FG_REG_WDT_CONF);
+
+		/* Set WD_PSWIDTH bits (1:0) */
+		wdt_conf =3D (wdt_conf & 0xfc) | (watchdog.pulse_val & 0x03);
+		/* Set WD_PULSE to "pulse" mode */
+		wdt_conf |=3D BIT(F71808FG_FLAG_WD_PULSE);
+
+		superio_outb(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				wdt_conf);
+	} else {
+		/* Select "level" output mode */
+		superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_PULSE);
+	}
+
+exit_superio:
+	superio_exit(watchdog.sioaddr);
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+
+	return err;
+}
+
+static int watchdog_stop(void)
+{
+	int err =3D 0;
+
+	mutex_lock(&watchdog.lock);
+	err =3D superio_enter(watchdog.sioaddr);
+	if (err)
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	superio_clear_bit(watchdog.sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+
+	return err;
+}
+
+static int watchdog_get_status(void)
+{
+	int status =3D 0;
+
+	mutex_lock(&watchdog.lock);
+	status =3D (watchdog.caused_reboot) ? WDIOF_CARDRESET : 0;
+	mutex_unlock(&watchdog.lock);
+
+	return status;
+}
+
+static bool watchdog_is_running(void)
+{
+	/*
+	 * if we fail to determine the watchdog's status assume it to be
+	 * running to be on the safe side
+	 */
+	bool is_running =3D true;
+
+	mutex_lock(&watchdog.lock);
+	if (superio_enter(watchdog.sioaddr))
+		goto exit_unlock;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	is_running =3D (superio_inb(watchdog.sioaddr, SIO_REG_ENABLE) & BIT(0))
+		&& (superio_inb(watchdog.sioaddr, F71808FG_REG_WDT_CONF) & F71808FG_FLAG=
_WD_EN);
+
+	superio_exit(watchdog.sioaddr);
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+	return is_running;
+}
+
+/* /dev/watchdog api */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int err;
+
+	/* If the watchdog is alive we don't need to start it again */
+	if (test_and_set_bit(0, &watchdog.opened))
+		return -EBUSY;
+
+	err =3D watchdog_start();
+	if (err) {
+		clear_bit(0, &watchdog.opened);
+		return err;
+	}
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	watchdog.expect_close =3D 0;
+	return nonseekable_open(inode, file);
+}
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &watchdog.opened);
+
+	if (!watchdog.expect_close) {
+		watchdog_keepalive();
+		printk(KERN_CRIT DRVNAME
+			": Unexpected close, not stopping watchdog!\n");
+	} else if (!nowayout) {
+		watchdog_stop();
+	}
+	return 0;
+}
+
+/*
+ *      watchdog_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			bool expect_close =3D false;
+
+			for (i =3D 0; i !=3D count; i++) {
+				char c;
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				expect_close =3D (c =3D=3D 'V');
+			}
+
+			/* Properly order writes across fork()ed processes */
+			mutex_lock(&watchdog.lock);
+			watchdog.expect_close =3D expect_close;
+			mutex_unlock(&watchdog.lock);
+		}
+
+		/* someone wrote to us, we should restart timer */
+		watchdog_keepalive();
+	}
+	return count;
+}
+
+/*
+ *      watchdog_ioctl:
+ *      @inode: inode of the device
+ *      @file: file handle to the device
+ *      @cmd: watchdog command
+ *      @arg: argument pointer
+ *
+ *      The watchdog API defines a common set of functions for all watchdo=
gs
+ *      according to their available features.
+ */
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	int status;
+	int new_options;
+	int new_timeout;
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+
+	uarg.i =3D (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &watchdog.ident,
+			sizeof(watchdog.ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		status =3D watchdog_get_status();
+		if (status < 0)
+			return status;
+		return put_user(status, uarg.i);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, uarg.i))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD)
+			watchdog_stop();
+
+		if (new_options & WDIOS_ENABLECARD)
+			return watchdog_start();
+
+
+	case WDIOC_KEEPALIVE:
+		watchdog_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+
+		if (watchdog_set_timeout(new_timeout))
+			return -EINVAL;
+
+		watchdog_keepalive();
+		/* Fall */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog.timeout, uarg.i);
+
+	default:
+		return -ENOTTY;
+
+	}
+}
+
+static int watchdog_notify_sys(struct notifier_block *this, unsigned long =
code,
+	void *unused)
+{
+	if (code =3D=3D SYS_DOWN || code =3D=3D SYS_HALT)
+		watchdog_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations watchdog_fops =3D {
+	.owner		=3D THIS_MODULE,
+	.llseek		=3D no_llseek,
+	.open		=3D watchdog_open,
+	.release	=3D watchdog_release,
+	.write		=3D watchdog_write,
+	.unlocked_ioctl	=3D watchdog_ioctl,
+};
+
+static struct miscdevice watchdog_miscdev =3D {
+	.minor		=3D WATCHDOG_MINOR,
+	.name		=3D "watchdog",
+	.fops		=3D &watchdog_fops,
+};
+
+static struct notifier_block watchdog_notifier =3D {
+	.notifier_call =3D watchdog_notify_sys,
+};
+
+static int __init watchdog_init(int sioaddr)
+{
+	int wdt_conf, err =3D 0;
+
+	/* No need to lock watchdog.lock here because no entry points
+	 * into the module have been registered yet.
+	 */
+	watchdog.sioaddr =3D sioaddr;
+	watchdog.ident.options =3D WDIOC_SETTIMEOUT
+				| WDIOF_MAGICCLOSE
+				| WDIOF_KEEPALIVEPING;
+
+	snprintf(watchdog.ident.identity,
+		sizeof(watchdog.ident.identity), "%s watchdog",
+		f71808e_names[watchdog.type]);
+
+	err =3D superio_enter(sioaddr);
+	if (err)
+		return err;
+	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+	wdt_conf =3D superio_inb(sioaddr, F71808FG_REG_WDT_CONF);
+	watchdog.caused_reboot =3D wdt_conf & F71808FG_FLAG_WDTMOUT_STS;
+
+	superio_exit(sioaddr);
+
+	err =3D watchdog_set_timeout(timeout);
+	if (err)
+		return err;
+	err =3D watchdog_set_pulse_width(pulse_width);
+	if (err)
+		return err;
+
+	err =3D register_reboot_notifier(&watchdog_notifier);
+	if (err)
+		return err;
+
+	err =3D misc_register(&watchdog_miscdev);
+	if (err) {
+		printk(KERN_ERR DRVNAME
+			": cannot register miscdev on minor=3D%d\n",
+				watchdog_miscdev.minor);
+		goto exit_reboot;
+	}
+
+	if (start_withtimeout) {
+		if (start_withtimeout <=3D 0
+		 || start_withtimeout >  max_timeout) {
+			printk(KERN_ERR DRVNAME
+				": starting timeout out of range\n");
+			err =3D -EINVAL;
+			goto exit_miscdev;
+		}
+
+		err =3D watchdog_start();
+		if (err) {
+			printk(KERN_ERR DRVNAME
+				": cannot start watchdog timer\n");
+			goto exit_miscdev;
+		}
+
+		mutex_lock(&watchdog.lock);
+		err =3D superio_enter(sioaddr);
+		if (err)
+			goto exit_unlock;
+		superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
+
+		if (start_withtimeout > 0xff) {
+			/* select minutes for timer units */
+			superio_set_bit(sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+			superio_outb(sioaddr, F71808FG_REG_WD_TIME,
+				DIV_ROUND_UP(start_withtimeout, 60));
+		} else {
+			/* select seconds for timer units */
+			superio_clear_bit(sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+			superio_outb(sioaddr, F71808FG_REG_WD_TIME,
+				start_withtimeout);
+		}
+
+		superio_exit(sioaddr);
+		mutex_unlock(&watchdog.lock);
+
+		if (nowayout)
+			__module_get(THIS_MODULE);
+
+		printk(KERN_INFO DRVNAME
+			": watchdog started with initial timeout of %u sec\n",
+			start_withtimeout);
+	}
+
+	return 0;
+
+exit_unlock:
+	mutex_unlock(&watchdog.lock);
+exit_miscdev:
+	misc_deregister(&watchdog_miscdev);
+exit_reboot:
+	unregister_reboot_notifier(&watchdog_notifier);
+
+	return err;
+}
+
+static int __init f71808e_find(int sioaddr)
+{
+	u16 devid;
+	int err =3D superio_enter(sioaddr);
+	if (err)
+		return err;
+
+	devid =3D superio_inw(sioaddr, SIO_REG_MANID);
+	if (devid !=3D SIO_FINTEK_ID) {
+		pr_debug(DRVNAME ": Not a Fintek device\n");
+		err =3D -ENODEV;
+		goto exit;
+	}
+
+	devid =3D force_id ? force_id : superio_inw(sioaddr, SIO_REG_DEVID);
+	switch (devid) {
+	case SIO_F71808_ID:
+		watchdog.type =3D f71808fg;
+		break;
+	case SIO_F71882_ID:
+		watchdog.type =3D f71882fg;
+		break;
+	case SIO_F71862_ID:
+	case SIO_F71889_ID:
+		/* These have a watchdog, though it isn't implemented (yet). */
+		err =3D -ENOSYS;
+		goto exit;
+	case SIO_F71858_ID:
+		/* Confirmed (by datasheet) not to have a watchdog. */
+		err =3D -ENODEV;
+		goto exit;
+	default:
+		printk(KERN_INFO DRVNAME ": Unrecognized Fintek device: %04x\n",
+		       (unsigned int)devid);
+		err =3D -ENODEV;
+		goto exit;
+	}
+
+	printk(KERN_INFO DRVNAME ": Found %s watchdog chip, revision %d\n",
+		f71808e_names[watchdog.type],
+		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
+exit:
+	superio_exit(sioaddr);
+	return err;
+}
+
+static int __init f71808e_init(void)
+{
+	static const unsigned short addrs[] =3D { 0x2e, 0x4e };
+	int err =3D -ENODEV;
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(addrs); i++) {
+		err =3D f71808e_find(addrs[i]);
+		if (err =3D=3D 0)
+			break;
+	}
+	if (i =3D=3D ARRAY_SIZE(addrs))
+		return err;
+
+	return watchdog_init(addrs[i]);
+}
+
+static void __exit f71808e_exit(void)
+{
+	if (watchdog_is_running())
+	{
+		printk(KERN_WARNING DRVNAME ": Watchdog timer still running, stopping it=
\n");
+		watchdog_stop();
+	}
+	misc_deregister(&watchdog_miscdev);
+	unregister_reboot_notifier(&watchdog_notifier);
+}
+
+MODULE_DESCRIPTION("F71808E Watchdog Driver");
+MODULE_AUTHOR("Giel van Schijndel <me@mortis.eu>");
+MODULE_LICENSE("GPL");
+
+module_init(f71808e_init);
+module_exit(f71808e_exit);
--=20
1.6.4.4


--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxvxsACgkQZBYm/87l50Je/gCgiZpcw8Tr20tcAtAqGWuUBUGd
fI0An3bTrJTbevQa1aQiNZw09xWsyRhE
=e6pe
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
