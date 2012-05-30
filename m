Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab2E3Gbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:31:55 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:34095 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862Ab2E3Gbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:31:53 -0400
Date: Wed, 30 May 2012 08:31:48 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Anthony Olech <Anthony.Olech@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [GIT PULL REQUEST] watchdog - v3.5 Merge window part 2
Message-ID: <20120530063148.GZ3074@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This changeset contains following changes:
* Add support for multiple watchdog devices. We use dynamically
  allocated device id's for this.
* Add locking into the generic watchdog infrastructure.
* Add support for dynamically allocated watchdog_device structs
  so that we can deal with devices that get unbound.
* convert following drivers to the generic watchdog framework:
  sch5627, sch5636 and sp805_wdt.
* Add DA9052/53 PMIC watchdog support
* Fix printk format warnings for iTCO_wdt.c

This will update the following files:

 b/Documentation/watchdog/watchdog-kernel-api.txt |   43 ++
 b/Documentation/watchdog/watchdog-parameters.txt |    5 
 b/drivers/hwmon/Kconfig                          |    6 
 b/drivers/hwmon/sch5627.c                        |    2 
 b/drivers/hwmon/sch5636.c                        |    2 
 b/drivers/hwmon/sch56xx-common.c                 |  406 ++++-------------------
 b/drivers/hwmon/sch56xx-common.h                 |    2 
 b/drivers/watchdog/Kconfig                       |   13 
 b/drivers/watchdog/Makefile                      |    1 
 b/drivers/watchdog/da9052_wdt.c                  |  251 ++++++++++++++
 b/drivers/watchdog/iTCO_wdt.c                    |    6 
 b/drivers/watchdog/sp805_wdt.c                   |  249 +++++---------
 b/drivers/watchdog/via_wdt.c                     |    2 
 b/drivers/watchdog/watchdog_core.c               |   74 +++-
 b/drivers/watchdog/watchdog_core.h               |   37 ++
 b/drivers/watchdog/watchdog_dev.c                |  375 ++++++++++++++++-----
 b/include/linux/watchdog.h                       |   28 +
 drivers/watchdog/watchdog_dev.h                  |   33 -
 18 files changed, 922 insertions(+), 613 deletions(-)

with these Changes:

commit 4b98b32aefb2c143a40cdaa254eb905f1bb06b5d
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Mon May 14 13:15:20 2012 -0700

    watchdog: iTCO_wdt.c: fix printk format warnings
    
    Fix printk format warnings:
    
    drivers/watchdog/iTCO_wdt.c:577:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
    drivers/watchdog/iTCO_wdt.c:594:3: warning: format '%04llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
    drivers/watchdog/iTCO_wdt.c:600:2: warning: format '%04llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d9df0ef1eb9e1048f0ab4a6e93c85f60c5594c2f
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:17 2012 +0530

    watchdog: sp805_wdt: Add clk_{un}prepare support
    
    clk_{un}prepare() routines are required for required on some platforms to run
    part of clk enable/disable() routines from contexts that can schedule.
    
    This patch adds support for these routines in sp805 driver.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4a516539faba13deca2399cff8faaa84d251a4ea
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:52:16 2012 +0530

    watchdog: sp805_wdt: convert to watchdog core
    
    This patch converts existing sp805 watchdog driver to use already in place
    common infrastructure present in watchdog core. With this lot of code goes away.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2d8c7ff52c2459a25034ac8ddc230e67cc0e2b67
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Thu May 24 22:18:58 2012 +0200

    hwmon/sch56xx: Depend on watchdog for watchdog core functions
    
    Since the watchdog code in sch56xx-common now uses the watchdog core, the
    Kconfig entires for the sch5627 and sch5636 should depend on WATCHDOG
    being set. Also select the watchdog core when we select one of the drivers.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bb644913a7d6dabcc4a1640817fa7b68938a56eb
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu May 24 18:58:02 2012 +0300

    watchdog: sch56xx-common: set correct bits in register()
    
    WDOG_NO_WAY_OUT (3) and WDOG_ACTIVE (0) are the bit numbers, not a mask.
    So "data->wddev.status |= WDOG_ACTIVE;" was intended to set bit zero but
    it is a no-op.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Acked-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 664a0d7862a6b10c709d4b4a3655fe2c59a20064
Author: Ashish Jangam <ashish.jangam@kpitcummins.com>
Date:   Thu May 24 18:31:14 2012 +0530

    Watchdog: DA9052/53 PMIC watchdog support
    
    This driver adds support for the watchdog functionality provided by
    the Dialog Semiconductor DA9052 PMIC chip.
    
    Tested on samsung smdkv6410 and i.mx53 QS boards.
    
    Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
    Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 54e2dc9341aca23d5241699e3b74c8dce609fa2d
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:27 2012 +0200

    watchdog: sch56xx-common: Add proper ref-counting of watchdog data
    
    This fixes referencing free-ed memory in the corner case where /dev/watchdog
    is open when the platform driver gets unbound from the platform device.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 85a2e40cb5053574cd3b1f33c00194309ce3704c
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:25 2012 +0200

    watchdog: sch56xx: Remove unnecessary checks for register changes
    
    Since the watchdog core keeps track of the watchdog's active state, start/stop
    will never get called when no changes are necessary. So we can remove the
    check for the output_enable register changing before writing it (which is
    an expensive operation).
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fb551405c0f8e15d6fc7ae6e16a5e15382f8b8ac
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:24 2012 +0200

    watchdog: sch56xx: Use watchdog core
    
    Convert sch56xx drivers to the generic watchdog core.
    
    Note this patch depends on the "watchdog: Add multiple device support" patch
    from Alan Cox.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e907df32725204d6d2cb79b872529911c8eadcdf
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:26 2012 +0200

    watchdog: Add support for dynamically allocated watchdog_device structs
    
    If a driver's watchdog_device struct is part of a dynamically allocated
    struct (which it often will be), merely locking the module is not enough,
    even with a drivers module locked, the driver can be unbound from the device,
    examples:
    1) The root user can unbind it through sysfd
    2) The i2c bus master driver being unloaded for an i2c watchdog
    
    I will gladly admit that these are corner cases, but we still need to handle
    them correctly.
    
    The fix for this consists of 2 parts:
    1) Add ref / unref operations, so that the driver can refcount the struct
       holding the watchdog_device struct and delay freeing it until any
       open filehandles referring to it are closed
    2) Most driver operations will do IO on the device and the driver should not
       do any IO on the device after it has been unbound. Rather then letting each
       driver deal with this internally, it is better to ensure at the watchdog
       core level that no operations (other then unref) will get called after
       the driver has called watchdog_unregister_device(). This actually is the
       bulk of this patch.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f4e9c82f64b524314a390b13d3ba7d483f09258f
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:26 2012 +0200

    watchdog: Add Locking support
    
    This patch fixes some potential multithreading issues, despite only
    allowing one process to open the /dev/watchdog device, we can still get
    called multiple times at the same time, since a program could be using thread,
    or could share the fd after a fork.
    
    This causes 2 potential problems:
    1) watchdog_start / open do an unlocked test_n_set / test_n_clear,
       if these 2 race, the watchdog could be stopped while the active
       bit indicates it is running or visa versa.
    
    2) Most watchdog_dev drivers probably assume that only one
       watchdog-op will get called at a time, this is not necessary
       true atm.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7a87982420e5e126bfefeb42232d1fd92052794e
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Tue May 22 11:40:26 2012 +0200

    watchdog: watchdog_dev: Rewrite wrapper code
    
    Rewrite and extend the wrapper code so that we can easily introduce
    locking (this to be able to prevent potential multithreading issues).
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3dfd6218da4cb9d0eae596581a08de9959aa2b1f
Author: Alan Cox <alan@linux.intel.com>
Date:   Fri May 11 12:00:22 2012 +0200

    watchdog: use dev_ functions
    
    While they are registered all our watchdogs now have a valid device object
    so we can in turn use that to report problems nicely.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d6b469d915ae348b3bb8b25034063d6870ff4a00
Author: Alan Cox <alan@linux.intel.com>
Date:   Fri May 11 12:00:20 2012 +0200

    watchdog: create all the proper device files
    
    Create the watchdog class and it's associated devices.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2bbeed016dd96045ec82c3a309afddcc3a0db1d2
Author: Alan Cox <alan@linux.intel.com>
Date:   Fri May 11 12:00:19 2012 +0200

    watchdog: Add a flag to indicate the watchdog doesn't reboot things
    
    Some watchdogs merely trigger external alarms and controls. In a managed
    environment this is very useful but we want drivers to be able to figure
    out which is which now multiple dogs can be loaded. Thus add an ALARMONLY
    feature flag.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 45f5fed30a6460ec58f159ff297a2974153a97de
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu May 10 21:48:59 2012 +0200

    watchdog: Add multiple device support
    
    We keep the old /dev/watchdog interface file for the first watchdog via
    miscdev. This is basically a cut and paste of the relevant interface code
    from the rtc driver layer tweaked for watchdog.
    
    Revised to fix problems noted by Hans de Goede
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fb5f6658163412dce22724e906e324ab7fd62c18
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon May 21 15:33:05 2012 +0200

    watchdog: watchdog_core.h: make functions extern
    
    Make the functions in watchdog_core.h extern like it should.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6cfb5aa836884bcd66e2c5d0a101e97ba78aaafd
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon May 21 15:31:06 2012 +0200

    watchdog: correct the name of the watchdog_core inlude file
    
    The watchdog_core include file should have been named
    watchdog_core.h and not watchdog_dev.h . Correct this.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 257f8c4aae392654d4ab846030b9f4518f16ed32
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Mar 12 09:51:56 2012 +0530

    watchdog: Add watchdog_active() routine
    
    Some watchdog may need to check if watchdog is ACTIVE or not, for example in
    their suspend/resume hooks.
    
    This patch adds this routine and changes the core drivers to use it.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 09a46e739780aab2eadf47afdefa70c9cd69d83d
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Fri Apr 20 13:28:24 2012 -0700

    watchdog: watchdog_dev: include private header to pickup global symbol prototypes
    
    Include the private watchdog_dev.h header to pickup the prototypes for the
    watchdog_dev_register/unregister functions.
    
    This quiets the following sparse warnings:
    
    warning: symbol 'watchdog_dev_register' was not declared. Should it be static?
    warning: symbol 'watchdog_dev_unregister' was not declared. Should it be static?
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 25fe430..086638f 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -1,6 +1,6 @@
 The Linux WatchDog Timer Driver Core kernel API.
 ===============================================
-Last reviewed: 16-Mar-2012
+Last reviewed: 22-May-2012
 
 Wim Van Sebroeck <wim@iguana.be>
 
@@ -39,6 +39,10 @@ watchdog_device structure.
 The watchdog device structure looks like this:
 
 struct watchdog_device {
+	int id;
+	struct cdev cdev;
+	struct device *dev;
+	struct device *parent;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
@@ -46,10 +50,20 @@ struct watchdog_device {
 	unsigned int min_timeout;
 	unsigned int max_timeout;
 	void *driver_data;
+	struct mutex lock;
 	unsigned long status;
 };
 
 It contains following fields:
+* id: set by watchdog_register_device, id 0 is special. It has both a
+  /dev/watchdog0 cdev (dynamic major, minor 0) as well as the old
+  /dev/watchdog miscdev. The id is set automatically when calling
+  watchdog_register_device.
+* cdev: cdev for the dynamic /dev/watchdog<id> device nodes. This
+  field is also populated by watchdog_register_device.
+* dev: device under the watchdog class (created by watchdog_register_device).
+* parent: set this to the parent device (or NULL) before calling
+  watchdog_register_device.
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
@@ -61,6 +75,7 @@ It contains following fields:
 * driver_data: a pointer to the drivers private data of a watchdog device.
   This data should only be accessed via the watchdog_set_drvdata and
   watchdog_get_drvdata routines.
+* lock: Mutex for WatchDog Timer Driver Core internal use only.
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the watchdog timer
   running/active, is the nowayout bit set, is the device opened via
@@ -78,6 +93,8 @@ struct watchdog_ops {
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
 	unsigned int (*get_timeleft)(struct watchdog_device *);
+	void (*ref)(struct watchdog_device *);
+	void (*unref)(struct watchdog_device *);
 	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
@@ -85,6 +102,21 @@ It is important that you first define the module owner of the watchdog timer
 driver's operations. This module owner will be used to lock the module when
 the watchdog is active. (This to avoid a system crash when you unload the
 module and /dev/watchdog is still open).
+
+If the watchdog_device struct is dynamically allocated, just locking the module
+is not enough and a driver also needs to define the ref and unref operations to
+ensure the structure holding the watchdog_device does not go away.
+
+The simplest (and usually sufficient) implementation of this is to:
+1) Add a kref struct to the same structure which is holding the watchdog_device
+2) Define a release callback for the kref which frees the struct holding both
+3) Call kref_init on this kref *before* calling watchdog_register_device()
+4) Define a ref operation calling kref_get on this kref
+5) Define a unref operation calling kref_put on this kref
+6) When it is time to cleanup:
+ * Do not kfree() the struct holding both, the last kref_put will do this!
+ * *After* calling watchdog_unregister_device() call kref_put on the kref
+
 Some operations are mandatory and some are optional. The mandatory operations
 are:
 * start: this is a pointer to the routine that starts the watchdog timer
@@ -125,6 +157,10 @@ they are supported. These optional routines/operations are:
   (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
   watchdog's info structure).
 * get_timeleft: this routines returns the time that's left before a reset.
+* ref: the operation that calls kref_get on the kref of a dynamically
+  allocated watchdog_device struct.
+* unref: the operation that calls kref_put on the kref of a dynamically
+  allocated watchdog_device struct.
 * ioctl: if this routine is present then it will be called first before we do
   our own internal ioctl call handling. This routine should return -ENOIOCTLCMD
   if a command is not supported. The parameters that are passed to the ioctl
@@ -144,6 +180,11 @@ bit-operations. The status bits that are defined are:
   (This bit should only be used by the WatchDog Timer Driver Core).
 * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
   If this bit is set then the watchdog timer will not be able to stop.
+* WDOG_UNREGISTERED: this bit gets set by the WatchDog Timer Driver Core
+  after calling watchdog_unregister_device, and then checked before calling
+  any watchdog_ops, so that you can be sure that no operations (other then
+  unref) will get called after unregister, even if userspace still holds a
+  reference to /dev/watchdog
 
   To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
   timer device) you can either:
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 17ddd82..04fddba 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -78,6 +78,11 @@ wd0_timeout: Default watchdog0 timeout in 1/10secs
 wd1_timeout: Default watchdog1 timeout in 1/10secs
 wd2_timeout: Default watchdog2 timeout in 1/10secs
 -------------------------------------------------
+da9052wdt:
+timeout: Watchdog timeout in seconds. 2<= timeout <=131, default=2.048s
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 davinci_wdt:
 heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
 -------------------------------------------------
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 7cd9bf4..6f1d167 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1036,8 +1036,9 @@ config SENSORS_SCH56XX_COMMON
 
 config SENSORS_SCH5627
 	tristate "SMSC SCH5627"
-	depends on !PPC
+	depends on !PPC && WATCHDOG
 	select SENSORS_SCH56XX_COMMON
+	select WATCHDOG_CORE
 	help
 	  If you say yes here you get support for the hardware monitoring
 	  features of the SMSC SCH5627 Super-I/O chip including support for
@@ -1048,8 +1049,9 @@ config SENSORS_SCH5627
 
 config SENSORS_SCH5636
 	tristate "SMSC SCH5636"
-	depends on !PPC
+	depends on !PPC && WATCHDOG
 	select SENSORS_SCH56XX_COMMON
+	select WATCHDOG_CORE
 	help
 	  SMSC SCH5636 Super I/O chips include an embedded microcontroller for
 	  hardware monitoring solutions, allowing motherboard manufacturers to
diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index 8ec6dfb..8342275 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -579,7 +579,7 @@ static int __devinit sch5627_probe(struct platform_device *pdev)
 	}
 
 	/* Note failing to register the watchdog is not a fatal error */
-	data->watchdog = sch56xx_watchdog_register(data->addr,
+	data->watchdog = sch56xx_watchdog_register(&pdev->dev, data->addr,
 			(build_code << 24) | (build_id << 8) | hwmon_rev,
 			&data->update_lock, 1);
 
diff --git a/drivers/hwmon/sch5636.c b/drivers/hwmon/sch5636.c
index 906d4ed..96a7e68 100644
--- a/drivers/hwmon/sch5636.c
+++ b/drivers/hwmon/sch5636.c
@@ -510,7 +510,7 @@ static int __devinit sch5636_probe(struct platform_device *pdev)
 	}
 
 	/* Note failing to register the watchdog is not a fatal error */
-	data->watchdog = sch56xx_watchdog_register(data->addr,
+	data->watchdog = sch56xx_watchdog_register(&pdev->dev, data->addr,
 					(revision[0] << 8) | revision[1],
 					&data->update_lock, 0);
 
diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index ce52fc5..4380f5d 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -66,15 +66,10 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 
 struct sch56xx_watchdog_data {
 	u16 addr;
-	u32 revision;
 	struct mutex *io_lock;
-	struct mutex watchdog_lock;
-	struct list_head list; /* member of the watchdog_data_list */
 	struct kref kref;
-	struct miscdevice watchdog_miscdev;
-	unsigned long watchdog_is_open;
-	char watchdog_name[10]; /* must be unique to avoid sysfs conflict */
-	char watchdog_expect_close;
+	struct watchdog_info wdinfo;
+	struct watchdog_device wddev;
 	u8 watchdog_preset;
 	u8 watchdog_control;
 	u8 watchdog_output_enable;
@@ -82,15 +77,6 @@ struct sch56xx_watchdog_data {
 
 static struct platform_device *sch56xx_pdev;
 
-/*
- * Somewhat ugly :( global data pointer list with all sch56xx devices, so that
- * we can find our device data as when using misc_register there is no other
- * method to get to ones device data from the open fop.
- */
-static LIST_HEAD(watchdog_data_list);
-/* Note this lock not only protect list access, but also data.kref access */
-static DEFINE_MUTEX(watchdog_data_mutex);
-
 /* Super I/O functions */
 static inline int superio_inb(int base, int reg)
 {
@@ -272,22 +258,22 @@ EXPORT_SYMBOL(sch56xx_read_virtual_reg12);
  * Watchdog routines
  */
 
-/*
- * Release our data struct when the platform device has been released *and*
- * all references to our watchdog device are released.
- */
-static void sch56xx_watchdog_release_resources(struct kref *r)
+/* Release our data struct when we're unregistered *and*
+   all references to our watchdog device are released */
+static void watchdog_release_resources(struct kref *r)
 {
 	struct sch56xx_watchdog_data *data =
 		container_of(r, struct sch56xx_watchdog_data, kref);
 	kfree(data);
 }
 
-static int watchdog_set_timeout(struct sch56xx_watchdog_data *data,
-				int timeout)
+static int watchdog_set_timeout(struct watchdog_device *wddev,
+				unsigned int timeout)
 {
-	int ret, resolution;
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
+	unsigned int resolution;
 	u8 control;
+	int ret;
 
 	/* 1 second or 60 second resolution? */
 	if (timeout <= 255)
@@ -298,12 +284,6 @@ static int watchdog_set_timeout(struct sch56xx_watchdog_data *data,
 	if (timeout < resolution || timeout > (resolution * 255))
 		return -EINVAL;
 
-	mutex_lock(&data->watchdog_lock);
-	if (!data->addr) {
-		ret = -ENODEV;
-		goto leave;
-	}
-
 	if (resolution == 1)
 		control = data->watchdog_control | SCH56XX_WDOG_TIME_BASE_SEC;
 	else
@@ -316,7 +296,7 @@ static int watchdog_set_timeout(struct sch56xx_watchdog_data *data,
 						control);
 		mutex_unlock(data->io_lock);
 		if (ret)
-			goto leave;
+			return ret;
 
 		data->watchdog_control = control;
 	}
@@ -326,38 +306,17 @@ static int watchdog_set_timeout(struct sch56xx_watchdog_data *data,
 	 * the watchdog countdown.
 	 */
 	data->watchdog_preset = DIV_ROUND_UP(timeout, resolution);
+	wddev->timeout = data->watchdog_preset * resolution;
 
-	ret = data->watchdog_preset * resolution;
-leave:
-	mutex_unlock(&data->watchdog_lock);
-	return ret;
-}
-
-static int watchdog_get_timeout(struct sch56xx_watchdog_data *data)
-{
-	int timeout;
-
-	mutex_lock(&data->watchdog_lock);
-	if (data->watchdog_control & SCH56XX_WDOG_TIME_BASE_SEC)
-		timeout = data->watchdog_preset;
-	else
-		timeout = data->watchdog_preset * 60;
-	mutex_unlock(&data->watchdog_lock);
-
-	return timeout;
+	return 0;
 }
 
-static int watchdog_start(struct sch56xx_watchdog_data *data)
+static int watchdog_start(struct watchdog_device *wddev)
 {
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
 	int ret;
 	u8 val;
 
-	mutex_lock(&data->watchdog_lock);
-	if (!data->addr) {
-		ret = -ENODEV;
-		goto leave_unlock_watchdog;
-	}
-
 	/*
 	 * The sch56xx's watchdog cannot really be started / stopped
 	 * it is always running, but we can avoid the timer expiring
@@ -385,18 +344,14 @@ static int watchdog_start(struct sch56xx_watchdog_data *data)
 	if (ret)
 		goto leave;
 
-	/* 2. Enable output (if not already enabled) */
-	if (!(data->watchdog_output_enable & SCH56XX_WDOG_OUTPUT_ENABLE)) {
-		val = data->watchdog_output_enable |
-		      SCH56XX_WDOG_OUTPUT_ENABLE;
-		ret = sch56xx_write_virtual_reg(data->addr,
-						SCH56XX_REG_WDOG_OUTPUT_ENABLE,
-						val);
-		if (ret)
-			goto leave;
+	/* 2. Enable output */
+	val = data->watchdog_output_enable | SCH56XX_WDOG_OUTPUT_ENABLE;
+	ret = sch56xx_write_virtual_reg(data->addr,
+					SCH56XX_REG_WDOG_OUTPUT_ENABLE, val);
+	if (ret)
+		goto leave;
 
-		data->watchdog_output_enable = val;
-	}
+	data->watchdog_output_enable = val;
 
 	/* 3. Clear the watchdog event bit if set */
 	val = inb(data->addr + 9);
@@ -405,234 +360,70 @@ static int watchdog_start(struct sch56xx_watchdog_data *data)
 
 leave:
 	mutex_unlock(data->io_lock);
-leave_unlock_watchdog:
-	mutex_unlock(&data->watchdog_lock);
 	return ret;
 }
 
-static int watchdog_trigger(struct sch56xx_watchdog_data *data)
+static int watchdog_trigger(struct watchdog_device *wddev)
 {
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
 	int ret;
 
-	mutex_lock(&data->watchdog_lock);
-	if (!data->addr) {
-		ret = -ENODEV;
-		goto leave;
-	}
-
 	/* Reset the watchdog countdown counter */
 	mutex_lock(data->io_lock);
 	ret = sch56xx_write_virtual_reg(data->addr, SCH56XX_REG_WDOG_PRESET,
 					data->watchdog_preset);
 	mutex_unlock(data->io_lock);
-leave:
-	mutex_unlock(&data->watchdog_lock);
+
 	return ret;
 }
 
-static int watchdog_stop_unlocked(struct sch56xx_watchdog_data *data)
+static int watchdog_stop(struct watchdog_device *wddev)
 {
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
 	int ret = 0;
 	u8 val;
 
-	if (!data->addr)
-		return -ENODEV;
-
-	if (data->watchdog_output_enable & SCH56XX_WDOG_OUTPUT_ENABLE) {
-		val = data->watchdog_output_enable &
-		      ~SCH56XX_WDOG_OUTPUT_ENABLE;
-		mutex_lock(data->io_lock);
-		ret = sch56xx_write_virtual_reg(data->addr,
-						SCH56XX_REG_WDOG_OUTPUT_ENABLE,
-						val);
-		mutex_unlock(data->io_lock);
-		if (ret)
-			return ret;
-
-		data->watchdog_output_enable = val;
-	}
-
-	return ret;
-}
-
-static int watchdog_stop(struct sch56xx_watchdog_data *data)
-{
-	int ret;
-
-	mutex_lock(&data->watchdog_lock);
-	ret = watchdog_stop_unlocked(data);
-	mutex_unlock(&data->watchdog_lock);
-
-	return ret;
-}
-
-static int watchdog_release(struct inode *inode, struct file *filp)
-{
-	struct sch56xx_watchdog_data *data = filp->private_data;
-
-	if (data->watchdog_expect_close) {
-		watchdog_stop(data);
-		data->watchdog_expect_close = 0;
-	} else {
-		watchdog_trigger(data);
-		pr_crit("unexpected close, not stopping watchdog!\n");
-	}
-
-	clear_bit(0, &data->watchdog_is_open);
-
-	mutex_lock(&watchdog_data_mutex);
-	kref_put(&data->kref, sch56xx_watchdog_release_resources);
-	mutex_unlock(&watchdog_data_mutex);
+	val = data->watchdog_output_enable & ~SCH56XX_WDOG_OUTPUT_ENABLE;
+	mutex_lock(data->io_lock);
+	ret = sch56xx_write_virtual_reg(data->addr,
+					SCH56XX_REG_WDOG_OUTPUT_ENABLE, val);
+	mutex_unlock(data->io_lock);
+	if (ret)
+		return ret;
 
+	data->watchdog_output_enable = val;
 	return 0;
 }
 
-static int watchdog_open(struct inode *inode, struct file *filp)
+static void watchdog_ref(struct watchdog_device *wddev)
 {
-	struct sch56xx_watchdog_data *pos, *data = NULL;
-	int ret, watchdog_is_open;
-
-	/*
-	 * We get called from drivers/char/misc.c with misc_mtx hold, and we
-	 * call misc_register() from sch56xx_watchdog_probe() with
-	 * watchdog_data_mutex hold, as misc_register() takes the misc_mtx
-	 * lock, this is a possible deadlock, so we use mutex_trylock here.
-	 */
-	if (!mutex_trylock(&watchdog_data_mutex))
-		return -ERESTARTSYS;
-	list_for_each_entry(pos, &watchdog_data_list, list) {
-		if (pos->watchdog_miscdev.minor == iminor(inode)) {
-			data = pos;
-			break;
-		}
-	}
-	/* Note we can never not have found data, so we don't check for this */
-	watchdog_is_open = test_and_set_bit(0, &data->watchdog_is_open);
-	if (!watchdog_is_open)
-		kref_get(&data->kref);
-	mutex_unlock(&watchdog_data_mutex);
-
-	if (watchdog_is_open)
-		return -EBUSY;
-
-	filp->private_data = data;
-
-	/* Start the watchdog */
-	ret = watchdog_start(data);
-	if (ret) {
-		watchdog_release(inode, filp);
-		return ret;
-	}
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
 
-	return nonseekable_open(inode, filp);
+	kref_get(&data->kref);
 }
 
-static ssize_t watchdog_write(struct file *filp, const char __user *buf,
-	size_t count, loff_t *offset)
+static void watchdog_unref(struct watchdog_device *wddev)
 {
-	int ret;
-	struct sch56xx_watchdog_data *data = filp->private_data;
-
-	if (count) {
-		if (!nowayout) {
-			size_t i;
-
-			/* Clear it in case it was set with a previous write */
-			data->watchdog_expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					data->watchdog_expect_close = 1;
-			}
-		}
-		ret = watchdog_trigger(data);
-		if (ret)
-			return ret;
-	}
-	return count;
-}
-
-static long watchdog_ioctl(struct file *filp, unsigned int cmd,
-			   unsigned long arg)
-{
-	struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
-		.identity = "sch56xx watchdog"
-	};
-	int i, ret = 0;
-	struct sch56xx_watchdog_data *data = filp->private_data;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ident.firmware_version = data->revision;
-		if (!nowayout)
-			ident.options |= WDIOF_MAGICCLOSE;
-		if (copy_to_user((void __user *)arg, &ident, sizeof(ident)))
-			ret = -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int __user *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		ret = watchdog_trigger(data);
-		break;
+	struct sch56xx_watchdog_data *data = watchdog_get_drvdata(wddev);
 
-	case WDIOC_GETTIMEOUT:
-		i = watchdog_get_timeout(data);
-		ret = put_user(i, (int __user *)arg);
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(i, (int __user *)arg)) {
-			ret = -EFAULT;
-			break;
-		}
-		ret = watchdog_set_timeout(data, i);
-		if (ret >= 0)
-			ret = put_user(ret, (int __user *)arg);
-		break;
-
-	case WDIOC_SETOPTIONS:
-		if (get_user(i, (int __user *)arg)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		if (i & WDIOS_DISABLECARD)
-			ret = watchdog_stop(data);
-		else if (i & WDIOS_ENABLECARD)
-			ret = watchdog_trigger(data);
-		else
-			ret = -EINVAL;
-		break;
-
-	default:
-		ret = -ENOTTY;
-	}
-	return ret;
+	kref_put(&data->kref, watchdog_release_resources);
 }
 
-static const struct file_operations watchdog_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = watchdog_open,
-	.release = watchdog_release,
-	.write = watchdog_write,
-	.unlocked_ioctl = watchdog_ioctl,
+static const struct watchdog_ops watchdog_ops = {
+	.owner		= THIS_MODULE,
+	.start		= watchdog_start,
+	.stop		= watchdog_stop,
+	.ping		= watchdog_trigger,
+	.set_timeout	= watchdog_set_timeout,
+	.ref		= watchdog_ref,
+	.unref		= watchdog_unref,
 };
 
-struct sch56xx_watchdog_data *sch56xx_watchdog_register(
+struct sch56xx_watchdog_data *sch56xx_watchdog_register(struct device *parent,
 	u16 addr, u32 revision, struct mutex *io_lock, int check_enabled)
 {
 	struct sch56xx_watchdog_data *data;
-	int i, err, control, output_enable;
-	const int watchdog_minors[] = { WATCHDOG_MINOR, 212, 213, 214, 215 };
+	int err, control, output_enable;
 
 	/* Cache the watchdog registers */
 	mutex_lock(io_lock);
@@ -656,82 +447,55 @@ struct sch56xx_watchdog_data *sch56xx_watchdog_register(
 		return NULL;
 
 	data->addr = addr;
-	data->revision = revision;
 	data->io_lock = io_lock;
-	data->watchdog_control = control;
-	data->watchdog_output_enable = output_enable;
-	mutex_init(&data->watchdog_lock);
-	INIT_LIST_HEAD(&data->list);
 	kref_init(&data->kref);
 
-	err = watchdog_set_timeout(data, 60);
-	if (err < 0)
-		goto error;
-
-	/*
-	 * We take the data_mutex lock early so that watchdog_open() cannot
-	 * run when misc_register() has completed, but we've not yet added
-	 * our data to the watchdog_data_list.
-	 */
-	mutex_lock(&watchdog_data_mutex);
-	for (i = 0; i < ARRAY_SIZE(watchdog_minors); i++) {
-		/* Register our watchdog part */
-		snprintf(data->watchdog_name, sizeof(data->watchdog_name),
-			"watchdog%c", (i == 0) ? '\0' : ('0' + i));
-		data->watchdog_miscdev.name = data->watchdog_name;
-		data->watchdog_miscdev.fops = &watchdog_fops;
-		data->watchdog_miscdev.minor = watchdog_minors[i];
-		err = misc_register(&data->watchdog_miscdev);
-		if (err == -EBUSY)
-			continue;
-		if (err)
-			break;
+	strlcpy(data->wdinfo.identity, "sch56xx watchdog",
+		sizeof(data->wdinfo.identity));
+	data->wdinfo.firmware_version = revision;
+	data->wdinfo.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT;
+	if (!nowayout)
+		data->wdinfo.options |= WDIOF_MAGICCLOSE;
+
+	data->wddev.info = &data->wdinfo;
+	data->wddev.ops = &watchdog_ops;
+	data->wddev.parent = parent;
+	data->wddev.timeout = 60;
+	data->wddev.min_timeout = 1;
+	data->wddev.max_timeout = 255 * 60;
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &data->wddev.status);
+	if (output_enable & SCH56XX_WDOG_OUTPUT_ENABLE)
+		set_bit(WDOG_ACTIVE, &data->wddev.status);
+
+	/* Since the watchdog uses a downcounter there is no register to read
+	   the BIOS set timeout from (if any was set at all) ->
+	   Choose a preset which will give us a 1 minute timeout */
+	if (control & SCH56XX_WDOG_TIME_BASE_SEC)
+		data->watchdog_preset = 60; /* seconds */
+	else
+		data->watchdog_preset = 1; /* minute */
 
-		list_add(&data->list, &watchdog_data_list);
-		pr_info("Registered /dev/%s chardev major 10, minor: %d\n",
-			data->watchdog_name, watchdog_minors[i]);
-		break;
-	}
-	mutex_unlock(&watchdog_data_mutex);
+	data->watchdog_control = control;
+	data->watchdog_output_enable = output_enable;
 
+	watchdog_set_drvdata(&data->wddev, data);
+	err = watchdog_register_device(&data->wddev);
 	if (err) {
 		pr_err("Registering watchdog chardev: %d\n", err);
-		goto error;
-	}
-	if (i == ARRAY_SIZE(watchdog_minors)) {
-		pr_warn("Couldn't register watchdog (no free minor)\n");
-		goto error;
+		kfree(data);
+		return NULL;
 	}
 
 	return data;
-
-error:
-	kfree(data);
-	return NULL;
 }
 EXPORT_SYMBOL(sch56xx_watchdog_register);
 
 void sch56xx_watchdog_unregister(struct sch56xx_watchdog_data *data)
 {
-	mutex_lock(&watchdog_data_mutex);
-	misc_deregister(&data->watchdog_miscdev);
-	list_del(&data->list);
-	mutex_unlock(&watchdog_data_mutex);
-
-	mutex_lock(&data->watchdog_lock);
-	if (data->watchdog_is_open) {
-		pr_warn("platform device unregistered with watchdog "
-			"open! Stopping watchdog.\n");
-		watchdog_stop_unlocked(data);
-	}
-	/* Tell the wdog start/stop/trigger functions our dev is gone */
-	data->addr = 0;
-	data->io_lock = NULL;
-	mutex_unlock(&data->watchdog_lock);
-
-	mutex_lock(&watchdog_data_mutex);
-	kref_put(&data->kref, sch56xx_watchdog_release_resources);
-	mutex_unlock(&watchdog_data_mutex);
+	watchdog_unregister_device(&data->wddev);
+	kref_put(&data->kref, watchdog_release_resources);
+	/* Don't touch data after this it may have been free-ed! */
 }
 EXPORT_SYMBOL(sch56xx_watchdog_unregister);
 
diff --git a/drivers/hwmon/sch56xx-common.h b/drivers/hwmon/sch56xx-common.h
index 7475086..704ea2c 100644
--- a/drivers/hwmon/sch56xx-common.h
+++ b/drivers/hwmon/sch56xx-common.h
@@ -27,6 +27,6 @@ int sch56xx_read_virtual_reg16(u16 addr, u16 reg);
 int sch56xx_read_virtual_reg12(u16 addr, u16 msb_reg, u16 lsn_reg,
 			       int high_nibble);
 
-struct sch56xx_watchdog_data *sch56xx_watchdog_register(
+struct sch56xx_watchdog_data *sch56xx_watchdog_register(struct device *parent,
 	u16 addr, u32 revision, struct mutex *io_lock, int check_enabled);
 void sch56xx_watchdog_unregister(struct sch56xx_watchdog_data *data);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d92d748..fe819b7 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -64,6 +64,18 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config DA9052_WATCHDOG
+        tristate "Dialog DA9052 Watchdog"
+        depends on PMIC_DA9052
+        select WATCHDOG_CORE
+        help
+          Support for the watchdog in the DA9052 PMIC. Watchdog trigger
+          cause system reset.
+
+          Say Y here to include support for the DA9052 watchdog.
+          Alternatively say M to compile the driver as a module,
+          which will be called da9052_wdt.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
@@ -87,6 +99,7 @@ config WM8350_WATCHDOG
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
 	depends on ARM_AMBA
+	select WATCHDOG_CORE
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
 	  the timeout is reached.
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 442bfbe..572b39b 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -163,6 +163,7 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 
 # Architecture Independent
+obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
new file mode 100644
index 0000000..3f75129
--- /dev/null
+++ b/drivers/watchdog/da9052_wdt.c
@@ -0,0 +1,251 @@
+/*
+ * System monitoring driver for DA9052 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: Anthony Olech <Anthony.Olech@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/watchdog.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+
+#define DA9052_DEF_TIMEOUT	4
+#define DA9052_TWDMIN		256
+
+struct da9052_wdt_data {
+	struct watchdog_device wdt;
+	struct da9052 *da9052;
+	struct kref kref;
+	unsigned long jpast;
+};
+
+static const struct {
+	u8 reg_val;
+	int time;  /* Seconds */
+} da9052_wdt_maps[] = {
+	{ 1, 2 },
+	{ 2, 4 },
+	{ 3, 8 },
+	{ 4, 16 },
+	{ 5, 32 },
+	{ 5, 33 },  /* Actual time  32.768s so included both 32s and 33s */
+	{ 6, 65 },
+	{ 6, 66 },  /* Actual time 65.536s so include both, 65s and 66s */
+	{ 7, 131 },
+};
+
+
+static void da9052_wdt_release_resources(struct kref *r)
+{
+	struct da9052_wdt_data *driver_data =
+		container_of(r, struct da9052_wdt_data, kref);
+
+	kfree(driver_data);
+}
+
+static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
+{
+	struct da9052_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9052 *da9052 = driver_data->da9052;
+	int ret, i;
+
+	/*
+	 * Disable the Watchdog timer before setting
+	 * new time out.
+	 */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_TWDSCALE, 0);
+	if (ret < 0) {
+		dev_err(da9052->dev, "Failed to disable watchdog bit, %d\n",
+			ret);
+		return ret;
+	}
+	if (timeout) {
+		/*
+		 * To change the timeout, da9052 needs to
+		 * be disabled for at least 150 us.
+		 */
+		udelay(150);
+
+		/* Set the desired timeout */
+		for (i = 0; i < ARRAY_SIZE(da9052_wdt_maps); i++)
+			if (da9052_wdt_maps[i].time == timeout)
+				break;
+
+		if (i == ARRAY_SIZE(da9052_wdt_maps))
+			ret = -EINVAL;
+		else
+			ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+						DA9052_CONTROLD_TWDSCALE,
+						da9052_wdt_maps[i].reg_val);
+		if (ret < 0) {
+			dev_err(da9052->dev,
+				"Failed to update timescale bit, %d\n", ret);
+			return ret;
+		}
+
+		wdt_dev->timeout = timeout;
+		driver_data->jpast = jiffies;
+	}
+
+	return 0;
+}
+
+static void da9052_wdt_ref(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_get(&driver_data->kref);
+}
+
+static void da9052_wdt_unref(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_put(&driver_data->kref, da9052_wdt_release_resources);
+}
+
+static int da9052_wdt_start(struct watchdog_device *wdt_dev)
+{
+	return da9052_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+}
+
+static int da9052_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	return da9052_wdt_set_timeout(wdt_dev, 0);
+}
+
+static int da9052_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9052 *da9052 = driver_data->da9052;
+	unsigned long msec, jnow = jiffies;
+	int ret;
+
+	/*
+	 * We have a minimum time for watchdog window called TWDMIN. A write
+	 * to the watchdog before this elapsed time should cause an error.
+	 */
+	msec = (jnow - driver_data->jpast) * 1000/HZ;
+	if (msec < DA9052_TWDMIN)
+		mdelay(msec);
+
+	/* Reset the watchdog timer */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_WATCHDOG, 1 << 7);
+	if (ret < 0)
+		goto err_strobe;
+
+	/*
+	 * FIXME: Reset the watchdog core, in general PMIC
+	 * is supposed to do this
+	 */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_WATCHDOG, 0 << 7);
+err_strobe:
+	return ret;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9052 Watchdog",
+};
+
+static const struct watchdog_ops da9052_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = da9052_wdt_start,
+	.stop = da9052_wdt_stop,
+	.ping = da9052_wdt_ping,
+	.set_timeout = da9052_wdt_set_timeout,
+	.ref = da9052_wdt_ref,
+	.unref = da9052_wdt_unref,
+};
+
+
+static int __devinit da9052_wdt_probe(struct platform_device *pdev)
+{
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct da9052_wdt_data *driver_data;
+	struct watchdog_device *da9052_wdt;
+	int ret;
+
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(da9052->dev, "Unable to alloacate watchdog device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	driver_data->da9052 = da9052;
+
+	da9052_wdt = &driver_data->wdt;
+
+	da9052_wdt->timeout = DA9052_DEF_TIMEOUT;
+	da9052_wdt->info = &da9052_wdt_info;
+	da9052_wdt->ops = &da9052_wdt_ops;
+	watchdog_set_drvdata(da9052_wdt, driver_data);
+
+	kref_init(&driver_data->kref);
+
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_TWDSCALE, 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to disable watchdog bits, %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = watchdog_register_device(&driver_data->wdt);
+	if (ret != 0) {
+		dev_err(da9052->dev, "watchdog_register_device() failed: %d\n",
+			ret);
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, driver_data);
+err:
+	return ret;
+}
+
+static int __devexit da9052_wdt_remove(struct platform_device *pdev)
+{
+	struct da9052_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
+	kref_put(&driver_data->kref, da9052_wdt_release_resources);
+
+	return 0;
+}
+
+static struct platform_driver da9052_wdt_driver = {
+	.probe = da9052_wdt_probe,
+	.remove = __devexit_p(da9052_wdt_remove),
+	.driver = {
+		.name	= "da9052-watchdog",
+	},
+};
+
+module_platform_driver(da9052_wdt_driver);
+
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-watchdog");
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 741528b..bc47e90 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -575,7 +575,7 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	if (!request_region(iTCO_wdt_private.smi_res->start,
 			resource_size(iTCO_wdt_private.smi_res), dev->name)) {
 		pr_err("I/O address 0x%04llx already in use, device disabled\n",
-		       SMI_EN);
+		       (u64)SMI_EN);
 		ret = -EBUSY;
 		goto unmap_gcs;
 	}
@@ -592,13 +592,13 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	if (!request_region(iTCO_wdt_private.tco_res->start,
 			resource_size(iTCO_wdt_private.tco_res), dev->name)) {
 		pr_err("I/O address 0x%04llx already in use, device disabled\n",
-		       TCOBASE);
+		       (u64)TCOBASE);
 		ret = -EBUSY;
 		goto unreg_smi;
 	}
 
 	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04llx)\n",
-		ich_info->name, ich_info->iTCO_version, TCOBASE);
+		ich_info->name, ich_info->iTCO_version, (u64)TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index bbb170e..afcd136 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -16,20 +16,17 @@
 #include <linux/amba/bus.h>
 #include <linux/bitops.h>
 #include <linux/clk.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
-#include <linux/uaccess.h>
 #include <linux/watchdog.h>
 
 /* default timeout in seconds */
@@ -56,6 +53,7 @@
 
 /**
  * struct sp805_wdt: sp805 wdt device structure
+ * @wdd: instance of struct watchdog_device
  * @lock: spin lock protecting dev structure and io access
  * @base: base address of wdt
  * @clk: clock structure of wdt
@@ -65,24 +63,24 @@
  * @timeout: current programmed timeout
  */
 struct sp805_wdt {
+	struct watchdog_device		wdd;
 	spinlock_t			lock;
 	void __iomem			*base;
 	struct clk			*clk;
 	struct amba_device		*adev;
-	unsigned long			status;
-	#define WDT_BUSY		0
-	#define WDT_CAN_BE_CLOSED	1
 	unsigned int			load_val;
 	unsigned int			timeout;
 };
 
-/* local variables */
-static struct sp805_wdt *wdt;
 static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		"Set to 1 to keep watchdog running after device release");
 
 /* This routine finds load value that will reset system in required timout */
-static void wdt_setload(unsigned int timeout)
+static int wdt_setload(struct watchdog_device *wdd, unsigned int timeout)
 {
+	struct sp805_wdt *wdt = watchdog_get_drvdata(wdd);
 	u64 load, rate;
 
 	rate = clk_get_rate(wdt->clk);
@@ -103,11 +101,14 @@ static void wdt_setload(unsigned int timeout)
 	/* roundup timeout to closest positive integer value */
 	wdt->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
 	spin_unlock(&wdt->lock);
+
+	return 0;
 }
 
 /* returns number of seconds left for reset to occur */
-static u32 wdt_timeleft(void)
+static unsigned int wdt_timeleft(struct watchdog_device *wdd)
 {
+	struct sp805_wdt *wdt = watchdog_get_drvdata(wdd);
 	u64 load, rate;
 
 	rate = clk_get_rate(wdt->clk);
@@ -123,166 +124,96 @@ static u32 wdt_timeleft(void)
 	return div_u64(load, rate);
 }
 
-/* enables watchdog timers reset */
-static void wdt_enable(void)
+static int wdt_config(struct watchdog_device *wdd, bool ping)
 {
-	spin_lock(&wdt->lock);
+	struct sp805_wdt *wdt = watchdog_get_drvdata(wdd);
+	int ret;
 
-	writel_relaxed(UNLOCK, wdt->base + WDTLOCK);
-	writel_relaxed(wdt->load_val, wdt->base + WDTLOAD);
-	writel_relaxed(INT_MASK, wdt->base + WDTINTCLR);
-	writel_relaxed(INT_ENABLE | RESET_ENABLE, wdt->base + WDTCONTROL);
-	writel_relaxed(LOCK, wdt->base + WDTLOCK);
+	if (!ping) {
+		ret = clk_prepare(wdt->clk);
+		if (ret) {
+			dev_err(&wdt->adev->dev, "clock prepare fail");
+			return ret;
+		}
 
-	/* Flush posted writes. */
-	readl_relaxed(wdt->base + WDTLOCK);
-	spin_unlock(&wdt->lock);
-}
+		ret = clk_enable(wdt->clk);
+		if (ret) {
+			dev_err(&wdt->adev->dev, "clock enable fail");
+			clk_unprepare(wdt->clk);
+			return ret;
+		}
+	}
 
-/* disables watchdog timers reset */
-static void wdt_disable(void)
-{
 	spin_lock(&wdt->lock);
 
 	writel_relaxed(UNLOCK, wdt->base + WDTLOCK);
-	writel_relaxed(0, wdt->base + WDTCONTROL);
+	writel_relaxed(wdt->load_val, wdt->base + WDTLOAD);
+
+	if (!ping) {
+		writel_relaxed(INT_MASK, wdt->base + WDTINTCLR);
+		writel_relaxed(INT_ENABLE | RESET_ENABLE, wdt->base +
+				WDTCONTROL);
+	}
+
 	writel_relaxed(LOCK, wdt->base + WDTLOCK);
 
 	/* Flush posted writes. */
 	readl_relaxed(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
+
+	return 0;
 }
 
-static ssize_t sp805_wdt_write(struct file *file, const char *data,
-		size_t len, loff_t *ppos)
+static int wdt_ping(struct watchdog_device *wdd)
 {
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_CAN_BE_CLOSED, &wdt->status);
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				/* Check for Magic Close character */
-				if (c == 'V') {
-					set_bit(WDT_CAN_BE_CLOSED,
-							&wdt->status);
-					break;
-				}
-			}
-		}
-		wdt_enable();
-	}
-	return len;
+	return wdt_config(wdd, true);
 }
 
-static const struct watchdog_info ident = {
-	.options = WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-	.identity = MODULE_NAME,
-};
-
-static long sp805_wdt_ioctl(struct file *file, unsigned int cmd,
-		unsigned long arg)
+/* enables watchdog timers reset */
+static int wdt_enable(struct watchdog_device *wdd)
 {
-	int ret = -ENOTTY;
-	unsigned int timeout;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(timeout, (unsigned int *)arg);
-		if (ret)
-			break;
-
-		wdt_setload(timeout);
-
-		wdt_enable();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(wdt->timeout, (unsigned int *)arg);
-		break;
-	case WDIOC_GETTIMELEFT:
-		ret = put_user(wdt_timeleft(), (unsigned int *)arg);
-		break;
-	}
-	return ret;
+	return wdt_config(wdd, false);
 }
 
-static int sp805_wdt_open(struct inode *inode, struct file *file)
+/* disables watchdog timers reset */
+static int wdt_disable(struct watchdog_device *wdd)
 {
-	int ret = 0;
-
-	if (test_and_set_bit(WDT_BUSY, &wdt->status))
-		return -EBUSY;
-
-	ret = clk_enable(wdt->clk);
-	if (ret) {
-		dev_err(&wdt->adev->dev, "clock enable fail");
-		goto err;
-	}
-
-	wdt_enable();
+	struct sp805_wdt *wdt = watchdog_get_drvdata(wdd);
 
-	/* can not be closed, once enabled */
-	clear_bit(WDT_CAN_BE_CLOSED, &wdt->status);
-	return nonseekable_open(inode, file);
+	spin_lock(&wdt->lock);
 
-err:
-	clear_bit(WDT_BUSY, &wdt->status);
-	return ret;
-}
+	writel_relaxed(UNLOCK, wdt->base + WDTLOCK);
+	writel_relaxed(0, wdt->base + WDTCONTROL);
+	writel_relaxed(LOCK, wdt->base + WDTLOCK);
 
-static int sp805_wdt_release(struct inode *inode, struct file *file)
-{
-	if (!test_bit(WDT_CAN_BE_CLOSED, &wdt->status)) {
-		clear_bit(WDT_BUSY, &wdt->status);
-		dev_warn(&wdt->adev->dev, "Device closed unexpectedly\n");
-		return 0;
-	}
+	/* Flush posted writes. */
+	readl_relaxed(wdt->base + WDTLOCK);
+	spin_unlock(&wdt->lock);
 
-	wdt_disable();
 	clk_disable(wdt->clk);
-	clear_bit(WDT_BUSY, &wdt->status);
+	clk_unprepare(wdt->clk);
 
 	return 0;
 }
 
-static const struct file_operations sp805_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = sp805_wdt_write,
-	.unlocked_ioctl = sp805_wdt_ioctl,
-	.open = sp805_wdt_open,
-	.release = sp805_wdt_release,
+static const struct watchdog_info wdt_info = {
+	.options = WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = MODULE_NAME,
 };
 
-static struct miscdevice sp805_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &sp805_wdt_fops,
+static const struct watchdog_ops wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= wdt_enable,
+	.stop		= wdt_disable,
+	.ping		= wdt_ping,
+	.set_timeout	= wdt_setload,
+	.get_timeleft	= wdt_timeleft,
 };
 
 static int __devinit
 sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 {
+	struct sp805_wdt *wdt;
 	int ret = 0;
 
 	if (!devm_request_mem_region(&adev->dev, adev->res.start,
@@ -315,19 +246,26 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	wdt->adev = adev;
+	wdt->wdd.info = &wdt_info;
+	wdt->wdd.ops = &wdt_ops;
+
 	spin_lock_init(&wdt->lock);
-	wdt_setload(DEFAULT_TIMEOUT);
+	watchdog_set_nowayout(&wdt->wdd, nowayout);
+	watchdog_set_drvdata(&wdt->wdd, wdt);
+	wdt_setload(&wdt->wdd, DEFAULT_TIMEOUT);
 
-	ret = misc_register(&sp805_wdt_miscdev);
-	if (ret < 0) {
-		dev_warn(&adev->dev, "cannot register misc device\n");
-		goto err_misc_register;
+	ret = watchdog_register_device(&wdt->wdd);
+	if (ret) {
+		dev_err(&adev->dev, "watchdog_register_device() failed: %d\n",
+				ret);
+		goto err_register;
 	}
+	amba_set_drvdata(adev, wdt);
 
 	dev_info(&adev->dev, "registration successful\n");
 	return 0;
 
-err_misc_register:
+err_register:
 	clk_put(wdt->clk);
 err:
 	dev_err(&adev->dev, "Probe Failed!!!\n");
@@ -336,7 +274,11 @@ err:
 
 static int __devexit sp805_wdt_remove(struct amba_device *adev)
 {
-	misc_deregister(&sp805_wdt_miscdev);
+	struct sp805_wdt *wdt = amba_get_drvdata(adev);
+
+	watchdog_unregister_device(&wdt->wdd);
+	amba_set_drvdata(adev, NULL);
+	watchdog_set_drvdata(&wdt->wdd, NULL);
 	clk_put(wdt->clk);
 
 	return 0;
@@ -345,28 +287,22 @@ static int __devexit sp805_wdt_remove(struct amba_device *adev)
 #ifdef CONFIG_PM
 static int sp805_wdt_suspend(struct device *dev)
 {
-	if (test_bit(WDT_BUSY, &wdt->status)) {
-		wdt_disable();
-		clk_disable(wdt->clk);
-	}
+	struct sp805_wdt *wdt = dev_get_drvdata(dev);
+
+	if (watchdog_active(&wdt->wdd))
+		return wdt_disable(&wdt->wdd);
 
 	return 0;
 }
 
 static int sp805_wdt_resume(struct device *dev)
 {
-	int ret = 0;
+	struct sp805_wdt *wdt = dev_get_drvdata(dev);
 
-	if (test_bit(WDT_BUSY, &wdt->status)) {
-		ret = clk_enable(wdt->clk);
-		if (ret) {
-			dev_err(dev, "clock enable fail");
-			return ret;
-		}
-		wdt_enable();
-	}
+	if (watchdog_active(&wdt->wdd))
+		return wdt_enable(&wdt->wdd);
 
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_PM */
 
@@ -395,11 +331,6 @@ static struct amba_driver sp805_wdt_driver = {
 
 module_amba_driver(sp805_wdt_driver);
 
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-		"Set to 1 to keep watchdog running after device release");
-
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
 MODULE_DESCRIPTION("ARM SP805 Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 5603e31..aa50da3 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -91,7 +91,7 @@ static inline void wdt_reset(void)
 static void wdt_timer_tick(unsigned long data)
 {
 	if (time_before(jiffies, next_heartbeat) ||
-	   (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
+	   (!watchdog_active(&wdt_dev))) {
 		wdt_reset();
 		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 	} else
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 14d768b..6aa46a9 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -34,8 +34,13 @@
 #include <linux/kernel.h>	/* For printk/panic/... */
 #include <linux/watchdog.h>	/* For watchdog specific items */
 #include <linux/init.h>		/* For __init/__exit/... */
+#include <linux/idr.h>		/* For ida_* macros */
+#include <linux/err.h>		/* For IS_ERR macros */
 
-#include "watchdog_dev.h"	/* For watchdog_dev_register/... */
+#include "watchdog_core.h"	/* For watchdog_dev_register/... */
+
+static DEFINE_IDA(watchdog_ida);
+static struct class *watchdog_class;
 
 /**
  * watchdog_register_device() - register a watchdog device
@@ -49,7 +54,7 @@
  */
 int watchdog_register_device(struct watchdog_device *wdd)
 {
-	int ret;
+	int ret, id, devno;
 
 	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -EINVAL;
@@ -74,10 +79,38 @@ int watchdog_register_device(struct watchdog_device *wdd)
 	 * corrupted in a later stage then we expect a kernel panic!
 	 */
 
-	/* We only support 1 watchdog device via the /dev/watchdog interface */
+	mutex_init(&wdd->lock);
+	id = ida_simple_get(&watchdog_ida, 0, MAX_DOGS, GFP_KERNEL);
+	if (id < 0)
+		return id;
+	wdd->id = id;
+
 	ret = watchdog_dev_register(wdd);
 	if (ret) {
-		pr_err("error registering /dev/watchdog (err=%d)\n", ret);
+		ida_simple_remove(&watchdog_ida, id);
+		if (!(id == 0 && ret == -EBUSY))
+			return ret;
+
+		/* Retry in case a legacy watchdog module exists */
+		id = ida_simple_get(&watchdog_ida, 1, MAX_DOGS, GFP_KERNEL);
+		if (id < 0)
+			return id;
+		wdd->id = id;
+
+		ret = watchdog_dev_register(wdd);
+		if (ret) {
+			ida_simple_remove(&watchdog_ida, id);
+			return ret;
+		}
+	}
+
+	devno = wdd->cdev.dev;
+	wdd->dev = device_create(watchdog_class, wdd->parent, devno,
+					NULL, "watchdog%d", wdd->id);
+	if (IS_ERR(wdd->dev)) {
+		watchdog_dev_unregister(wdd);
+		ida_simple_remove(&watchdog_ida, id);
+		ret = PTR_ERR(wdd->dev);
 		return ret;
 	}
 
@@ -95,6 +128,7 @@ EXPORT_SYMBOL_GPL(watchdog_register_device);
 void watchdog_unregister_device(struct watchdog_device *wdd)
 {
 	int ret;
+	int devno = wdd->cdev.dev;
 
 	if (wdd == NULL)
 		return;
@@ -102,9 +136,41 @@ void watchdog_unregister_device(struct watchdog_device *wdd)
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
 		pr_err("error unregistering /dev/watchdog (err=%d)\n", ret);
+	device_destroy(watchdog_class, devno);
+	ida_simple_remove(&watchdog_ida, wdd->id);
+	wdd->dev = NULL;
 }
 EXPORT_SYMBOL_GPL(watchdog_unregister_device);
 
+static int __init watchdog_init(void)
+{
+	int err;
+
+	watchdog_class = class_create(THIS_MODULE, "watchdog");
+	if (IS_ERR(watchdog_class)) {
+		pr_err("couldn't create class\n");
+		return PTR_ERR(watchdog_class);
+	}
+
+	err = watchdog_dev_init();
+	if (err < 0) {
+		class_destroy(watchdog_class);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit watchdog_exit(void)
+{
+	watchdog_dev_exit();
+	class_destroy(watchdog_class);
+	ida_destroy(&watchdog_ida);
+}
+
+subsys_initcall(watchdog_init);
+module_exit(watchdog_exit);
+
 MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
 MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("WatchDog Timer Driver Core");
diff --git a/drivers/watchdog/watchdog_core.h b/drivers/watchdog/watchdog_core.h
new file mode 100644
index 0000000..6c95141
--- /dev/null
+++ b/drivers/watchdog/watchdog_core.h
@@ -0,0 +1,37 @@
+/*
+ *	watchdog_core.h
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+#define MAX_DOGS	32	/* Maximum number of watchdog devices */
+
+/*
+ *	Functions/procedures to be called by the core
+ */
+extern int watchdog_dev_register(struct watchdog_device *);
+extern int watchdog_dev_unregister(struct watchdog_device *);
+extern int __init watchdog_dev_init(void);
+extern void __exit watchdog_dev_exit(void);
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 8558da9..672d169 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -42,10 +42,12 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
-/* make sure we only register one /dev/watchdog device */
-static unsigned long watchdog_dev_busy;
+#include "watchdog_core.h"
+
+/* the dev_t structure to store the dynamically allocated watchdog devices */
+static dev_t watchdog_devt;
 /* the watchdog device behind /dev/watchdog */
-static struct watchdog_device *wdd;
+static struct watchdog_device *old_wdd;
 
 /*
  *	watchdog_ping: ping the watchdog.
@@ -59,13 +61,26 @@ static struct watchdog_device *wdd;
 
 static int watchdog_ping(struct watchdog_device *wddev)
 {
-	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
-		if (wddev->ops->ping)
-			return wddev->ops->ping(wddev);  /* ping the watchdog */
-		else
-			return wddev->ops->start(wddev); /* restart watchdog */
+	int err = 0;
+
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_ping;
 	}
-	return 0;
+
+	if (!watchdog_active(wddev))
+		goto out_ping;
+
+	if (wddev->ops->ping)
+		err = wddev->ops->ping(wddev);  /* ping the watchdog */
+	else
+		err = wddev->ops->start(wddev); /* restart watchdog */
+
+out_ping:
+	mutex_unlock(&wddev->lock);
+	return err;
 }
 
 /*
@@ -79,16 +94,25 @@ static int watchdog_ping(struct watchdog_device *wddev)
 
 static int watchdog_start(struct watchdog_device *wddev)
 {
-	int err;
+	int err = 0;
 
-	if (!test_bit(WDOG_ACTIVE, &wddev->status)) {
-		err = wddev->ops->start(wddev);
-		if (err < 0)
-			return err;
+	mutex_lock(&wddev->lock);
 
-		set_bit(WDOG_ACTIVE, &wddev->status);
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_start;
 	}
-	return 0;
+
+	if (watchdog_active(wddev))
+		goto out_start;
+
+	err = wddev->ops->start(wddev);
+	if (err == 0)
+		set_bit(WDOG_ACTIVE, &wddev->status);
+
+out_start:
+	mutex_unlock(&wddev->lock);
+	return err;
 }
 
 /*
@@ -103,22 +127,155 @@ static int watchdog_start(struct watchdog_device *wddev)
 
 static int watchdog_stop(struct watchdog_device *wddev)
 {
-	int err = -EBUSY;
+	int err = 0;
 
-	if (test_bit(WDOG_NO_WAY_OUT, &wddev->status)) {
-		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
-							wddev->info->identity);
-		return err;
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_stop;
 	}
 
-	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
-		err = wddev->ops->stop(wddev);
-		if (err < 0)
-			return err;
+	if (!watchdog_active(wddev))
+		goto out_stop;
 
+	if (test_bit(WDOG_NO_WAY_OUT, &wddev->status)) {
+		dev_info(wddev->dev, "nowayout prevents watchdog being stopped!\n");
+		err = -EBUSY;
+		goto out_stop;
+	}
+
+	err = wddev->ops->stop(wddev);
+	if (err == 0)
 		clear_bit(WDOG_ACTIVE, &wddev->status);
+
+out_stop:
+	mutex_unlock(&wddev->lock);
+	return err;
+}
+
+/*
+ *	watchdog_get_status: wrapper to get the watchdog status
+ *	@wddev: the watchdog device to get the status from
+ *	@status: the status of the watchdog device
+ *
+ *	Get the watchdog's status flags.
+ */
+
+static int watchdog_get_status(struct watchdog_device *wddev,
+							unsigned int *status)
+{
+	int err = 0;
+
+	*status = 0;
+	if (!wddev->ops->status)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_status;
 	}
-	return 0;
+
+	*status = wddev->ops->status(wddev);
+
+out_status:
+	mutex_unlock(&wddev->lock);
+	return err;
+}
+
+/*
+ *	watchdog_set_timeout: set the watchdog timer timeout
+ *	@wddev: the watchdog device to set the timeout for
+ *	@timeout: timeout to set in seconds
+ */
+
+static int watchdog_set_timeout(struct watchdog_device *wddev,
+							unsigned int timeout)
+{
+	int err;
+
+	if ((wddev->ops->set_timeout == NULL) ||
+	    !(wddev->info->options & WDIOF_SETTIMEOUT))
+		return -EOPNOTSUPP;
+
+	if ((wddev->max_timeout != 0) &&
+	    (timeout < wddev->min_timeout || timeout > wddev->max_timeout))
+		return -EINVAL;
+
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_timeout;
+	}
+
+	err = wddev->ops->set_timeout(wddev, timeout);
+
+out_timeout:
+	mutex_unlock(&wddev->lock);
+	return err;
+}
+
+/*
+ *	watchdog_get_timeleft: wrapper to get the time left before a reboot
+ *	@wddev: the watchdog device to get the remaining time from
+ *	@timeleft: the time that's left
+ *
+ *	Get the time before a watchdog will reboot (if not pinged).
+ */
+
+static int watchdog_get_timeleft(struct watchdog_device *wddev,
+							unsigned int *timeleft)
+{
+	int err = 0;
+
+	*timeleft = 0;
+	if (!wddev->ops->get_timeleft)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_timeleft;
+	}
+
+	*timeleft = wddev->ops->get_timeleft(wddev);
+
+out_timeleft:
+	mutex_unlock(&wddev->lock);
+	return err;
+}
+
+/*
+ *	watchdog_ioctl_op: call the watchdog drivers ioctl op if defined
+ *	@wddev: the watchdog device to do the ioctl on
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ */
+
+static int watchdog_ioctl_op(struct watchdog_device *wddev, unsigned int cmd,
+							unsigned long arg)
+{
+	int err;
+
+	if (!wddev->ops->ioctl)
+		return -ENOIOCTLCMD;
+
+	mutex_lock(&wddev->lock);
+
+	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
+		err = -ENODEV;
+		goto out_ioctl;
+	}
+
+	err = wddev->ops->ioctl(wddev, cmd, arg);
+
+out_ioctl:
+	mutex_unlock(&wddev->lock);
+	return err;
 }
 
 /*
@@ -136,6 +293,7 @@ static int watchdog_stop(struct watchdog_device *wddev)
 static ssize_t watchdog_write(struct file *file, const char __user *data,
 						size_t len, loff_t *ppos)
 {
+	struct watchdog_device *wdd = file->private_data;
 	size_t i;
 	char c;
 
@@ -175,23 +333,24 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
+	struct watchdog_device *wdd = file->private_data;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int val;
 	int err;
 
-	if (wdd->ops->ioctl) {
-		err = wdd->ops->ioctl(wdd, cmd, arg);
-		if (err != -ENOIOCTLCMD)
-			return err;
-	}
+	err = watchdog_ioctl_op(wdd, cmd, arg);
+	if (err != -ENOIOCTLCMD)
+		return err;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, wdd->info,
 			sizeof(struct watchdog_info)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
-		val = wdd->ops->status ? wdd->ops->status(wdd) : 0;
+		err = watchdog_get_status(wdd, &val);
+		if (err)
+			return err;
 		return put_user(val, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(wdd->bootstatus, p);
@@ -215,15 +374,9 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		watchdog_ping(wdd);
 		return 0;
 	case WDIOC_SETTIMEOUT:
-		if ((wdd->ops->set_timeout == NULL) ||
-		    !(wdd->info->options & WDIOF_SETTIMEOUT))
-			return -EOPNOTSUPP;
 		if (get_user(val, p))
 			return -EFAULT;
-		if ((wdd->max_timeout != 0) &&
-		    (val < wdd->min_timeout || val > wdd->max_timeout))
-				return -EINVAL;
-		err = wdd->ops->set_timeout(wdd, val);
+		err = watchdog_set_timeout(wdd, val);
 		if (err < 0)
 			return err;
 		/* If the watchdog is active then we send a keepalive ping
@@ -237,21 +390,21 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			return -EOPNOTSUPP;
 		return put_user(wdd->timeout, p);
 	case WDIOC_GETTIMELEFT:
-		if (!wdd->ops->get_timeleft)
-			return -EOPNOTSUPP;
-
-		return put_user(wdd->ops->get_timeleft(wdd), p);
+		err = watchdog_get_timeleft(wdd, &val);
+		if (err)
+			return err;
+		return put_user(val, p);
 	default:
 		return -ENOTTY;
 	}
 }
 
 /*
- *	watchdog_open: open the /dev/watchdog device.
+ *	watchdog_open: open the /dev/watchdog* devices.
  *	@inode: inode of device
  *	@file: file handle to device
  *
- *	When the /dev/watchdog device gets opened, we start the watchdog.
+ *	When the /dev/watchdog* device gets opened, we start the watchdog.
  *	Watch out: the /dev/watchdog device is single open, so we make sure
  *	it can only be opened once.
  */
@@ -259,6 +412,13 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 static int watchdog_open(struct inode *inode, struct file *file)
 {
 	int err = -EBUSY;
+	struct watchdog_device *wdd;
+
+	/* Get the corresponding watchdog device */
+	if (imajor(inode) == MISC_MAJOR)
+		wdd = old_wdd;
+	else
+		wdd = container_of(inode->i_cdev, struct watchdog_device, cdev);
 
 	/* the watchdog is single open! */
 	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
@@ -275,6 +435,11 @@ static int watchdog_open(struct inode *inode, struct file *file)
 	if (err < 0)
 		goto out_mod;
 
+	file->private_data = wdd;
+
+	if (wdd->ops->ref)
+		wdd->ops->ref(wdd);
+
 	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
 	return nonseekable_open(inode, file);
 
@@ -286,9 +451,9 @@ out:
 }
 
 /*
- *      watchdog_release: release the /dev/watchdog device.
- *      @inode: inode of device
- *      @file: file handle to device
+ *	watchdog_release: release the watchdog device.
+ *	@inode: inode of device
+ *	@file: file handle to device
  *
  *	This is the code for when /dev/watchdog gets closed. We will only
  *	stop the watchdog when we have received the magic char (and nowayout
@@ -297,6 +462,7 @@ out:
 
 static int watchdog_release(struct inode *inode, struct file *file)
 {
+	struct watchdog_device *wdd = file->private_data;
 	int err = -EBUSY;
 
 	/*
@@ -310,7 +476,10 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 	/* If the watchdog was not stopped, send a keepalive ping */
 	if (err < 0) {
-		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
+		mutex_lock(&wdd->lock);
+		if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
+			dev_crit(wdd->dev, "watchdog did not stop!\n");
+		mutex_unlock(&wdd->lock);
 		watchdog_ping(wdd);
 	}
 
@@ -320,6 +489,10 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	/* make sure that /dev/watchdog can be re-opened */
 	clear_bit(WDOG_DEV_OPEN, &wdd->status);
 
+	/* Note wdd may be gone after this, do not use after this! */
+	if (wdd->ops->unref)
+		wdd->ops->unref(wdd);
+
 	return 0;
 }
 
@@ -338,62 +511,92 @@ static struct miscdevice watchdog_miscdev = {
 };
 
 /*
- *	watchdog_dev_register:
+ *	watchdog_dev_register: register a watchdog device
  *	@watchdog: watchdog device
  *
- *	Register a watchdog device as /dev/watchdog. /dev/watchdog
- *	is actually a miscdevice and thus we set it up like that.
+ *	Register a watchdog device including handling the legacy
+ *	/dev/watchdog node. /dev/watchdog is actually a miscdevice and
+ *	thus we set it up like that.
  */
 
 int watchdog_dev_register(struct watchdog_device *watchdog)
 {
-	int err;
-
-	/* Only one device can register for /dev/watchdog */
-	if (test_and_set_bit(0, &watchdog_dev_busy)) {
-		pr_err("only one watchdog can use /dev/watchdog\n");
-		return -EBUSY;
+	int err, devno;
+
+	if (watchdog->id == 0) {
+		watchdog_miscdev.parent = watchdog->parent;
+		err = misc_register(&watchdog_miscdev);
+		if (err != 0) {
+			pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
+				watchdog->info->identity, WATCHDOG_MINOR, err);
+			if (err == -EBUSY)
+				pr_err("%s: a legacy watchdog module is probably present.\n",
+					watchdog->info->identity);
+			return err;
+		}
+		old_wdd = watchdog;
 	}
 
-	wdd = watchdog;
-
-	err = misc_register(&watchdog_miscdev);
-	if (err != 0) {
-		pr_err("%s: cannot register miscdev on minor=%d (err=%d)\n",
-		       watchdog->info->identity, WATCHDOG_MINOR, err);
-		goto out;
+	/* Fill in the data structures */
+	devno = MKDEV(MAJOR(watchdog_devt), watchdog->id);
+	cdev_init(&watchdog->cdev, &watchdog_fops);
+	watchdog->cdev.owner = watchdog->ops->owner;
+
+	/* Add the device */
+	err  = cdev_add(&watchdog->cdev, devno, 1);
+	if (err) {
+		pr_err("watchdog%d unable to add device %d:%d\n",
+			watchdog->id,  MAJOR(watchdog_devt), watchdog->id);
+		if (watchdog->id == 0) {
+			misc_deregister(&watchdog_miscdev);
+			old_wdd = NULL;
+		}
 	}
-
-	return 0;
-
-out:
-	wdd = NULL;
-	clear_bit(0, &watchdog_dev_busy);
 	return err;
 }
 
 /*
- *	watchdog_dev_unregister:
+ *	watchdog_dev_unregister: unregister a watchdog device
  *	@watchdog: watchdog device
  *
- *	Deregister the /dev/watchdog device.
+ *	Unregister the watchdog and if needed the legacy /dev/watchdog device.
  */
 
 int watchdog_dev_unregister(struct watchdog_device *watchdog)
 {
-	/* Check that a watchdog device was registered in the past */
-	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
-		return -ENODEV;
-
-	/* We can only unregister the watchdog device that was registered */
-	if (watchdog != wdd) {
-		pr_err("%s: watchdog was not registered as /dev/watchdog\n",
-		       watchdog->info->identity);
-		return -ENODEV;
+	mutex_lock(&watchdog->lock);
+	set_bit(WDOG_UNREGISTERED, &watchdog->status);
+	mutex_unlock(&watchdog->lock);
+
+	cdev_del(&watchdog->cdev);
+	if (watchdog->id == 0) {
+		misc_deregister(&watchdog_miscdev);
+		old_wdd = NULL;
 	}
-
-	misc_deregister(&watchdog_miscdev);
-	wdd = NULL;
-	clear_bit(0, &watchdog_dev_busy);
 	return 0;
 }
+
+/*
+ *	watchdog_dev_init: init dev part of watchdog core
+ *
+ *	Allocate a range of chardev nodes to use for watchdog devices
+ */
+
+int __init watchdog_dev_init(void)
+{
+	int err = alloc_chrdev_region(&watchdog_devt, 0, MAX_DOGS, "watchdog");
+	if (err < 0)
+		pr_err("watchdog: unable to allocate char dev region\n");
+	return err;
+}
+
+/*
+ *	watchdog_dev_exit: exit dev part of watchdog core
+ *
+ *	Release the range of chardev nodes used for watchdog devices
+ */
+
+void __exit watchdog_dev_exit(void)
+{
+	unregister_chrdev_region(watchdog_devt, MAX_DOGS);
+}
diff --git a/drivers/watchdog/watchdog_dev.h b/drivers/watchdog/watchdog_dev.h
deleted file mode 100644
index bc7612b..0000000
--- a/drivers/watchdog/watchdog_dev.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *	watchdog_core.h
- *
- *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
- *						All Rights Reserved.
- *
- *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
- *
- *	This source code is part of the generic code that can be used
- *	by all the watchdog timer drivers.
- *
- *	Based on source code of the following authors:
- *	  Matt Domsch <Matt_Domsch@dell.com>,
- *	  Rob Radez <rob@osinvestor.com>,
- *	  Rusty Lynch <rusty@linux.co.intel.com>
- *	  Satyam Sharma <satyam@infradead.org>
- *	  Randy Dunlap <randy.dunlap@oracle.com>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
- *	admit liability nor provide warranty for any of this software.
- *	This material is provided "AS-IS" and at no charge.
- */
-
-/*
- *	Functions/procedures to be called by the core
- */
-int watchdog_dev_register(struct watchdog_device *);
-int watchdog_dev_unregister(struct watchdog_device *);
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index ac40716..da70f0f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -45,6 +45,8 @@ struct watchdog_info {
 #define	WDIOF_SETTIMEOUT	0x0080  /* Set timeout (in seconds) */
 #define	WDIOF_MAGICCLOSE	0x0100	/* Supports magic close char */
 #define	WDIOF_PRETIMEOUT	0x0200  /* Pretimeout (in seconds), get/set */
+#define	WDIOF_ALARMONLY		0x0400	/* Watchdog triggers a management or
+					   other external alarm not a reboot */
 #define	WDIOF_KEEPALIVEPING	0x8000	/* Keep alive ping reply */
 
 #define	WDIOS_DISABLECARD	0x0001	/* Turn off the watchdog timer */
@@ -54,6 +56,8 @@ struct watchdog_info {
 #ifdef __KERNEL__
 
 #include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
 
 struct watchdog_ops;
 struct watchdog_device;
@@ -67,6 +71,8 @@ struct watchdog_device;
  * @status:	The routine that shows the status of the watchdog device.
  * @set_timeout:The routine for setting the watchdog devices timeout value.
  * @get_timeleft:The routine that get's the time that's left before a reset.
+ * @ref:	The ref operation for dyn. allocated watchdog_device structs
+ * @unref:	The unref operation for dyn. allocated watchdog_device structs
  * @ioctl:	The routines that handles extra ioctl calls.
  *
  * The watchdog_ops structure contains a list of low-level operations
@@ -84,11 +90,17 @@ struct watchdog_ops {
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
 	unsigned int (*get_timeleft)(struct watchdog_device *);
+	void (*ref)(struct watchdog_device *);
+	void (*unref)(struct watchdog_device *);
 	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 /** struct watchdog_device - The structure that defines a watchdog device
  *
+ * @id:		The watchdog's ID. (Allocated by watchdog_register_device)
+ * @cdev:	The watchdog's Character device.
+ * @dev:	The device for our watchdog
+ * @parent:	The parent bus device
  * @info:	Pointer to a watchdog_info structure.
  * @ops:	Pointer to the list of watchdog operations.
  * @bootstatus:	Status of the watchdog device at boot.
@@ -96,6 +108,7 @@ struct watchdog_ops {
  * @min_timeout:The watchdog devices minimum timeout value.
  * @max_timeout:The watchdog devices maximum timeout value.
  * @driver-data:Pointer to the drivers private data.
+ * @lock:	Lock for watchdog core internal use only.
  * @status:	Field that contains the devices internal status bits.
  *
  * The watchdog_device structure contains all information about a
@@ -103,8 +116,15 @@ struct watchdog_ops {
  *
  * The driver-data field may not be accessed directly. It must be accessed
  * via the watchdog_set_drvdata and watchdog_get_drvdata helpers.
+ *
+ * The lock field is for watchdog core internal use only and should not be
+ * touched.
  */
 struct watchdog_device {
+	int id;
+	struct cdev cdev;
+	struct device *dev;
+	struct device *parent;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
@@ -112,12 +132,14 @@ struct watchdog_device {
 	unsigned int min_timeout;
 	unsigned int max_timeout;
 	void *driver_data;
+	struct mutex lock;
 	unsigned long status;
 /* Bit numbers for status flags */
 #define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
 #define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
+#define WDOG_UNREGISTERED	4	/* Has the device been unregistered */
 };
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
@@ -128,6 +150,12 @@ struct watchdog_device {
 #define WATCHDOG_NOWAYOUT_INIT_STATUS	0
 #endif
 
+/* Use the following function to check wether or not the watchdog is active */
+static inline bool watchdog_active(struct watchdog_device *wdd)
+{
+	return test_bit(WDOG_ACTIVE, &wdd->status);
+}
+
 /* Use the following function to set the nowayout feature */
 static inline void watchdog_set_nowayout(struct watchdog_device *wdd, bool nowayout)
 {
