Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2A3O3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:29:21 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:49153 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2A3O3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:29:19 -0500
Date: Mon, 30 Jan 2012 15:29:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.3-rc2
Message-ID: <20120130152906.5b1dc015@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12013014-0542-0000-0000-000000D92DE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Christian Borntraeger (1):
      [S390] cleanup entry point definition

Stefan Haberland (2):
      [S390] dasd: revert LCU optimization
      [S390] dasd: revalidate server for new pathgroup

 arch/s390/Makefile              |    1 -
 arch/s390/kernel/vmlinux.lds.S  |    4 +-
 drivers/s390/block/dasd.c       |    6 ++++
 drivers/s390/block/dasd_alias.c |   64 +--------------------------------------
 drivers/s390/block/dasd_eckd.c  |   63 ++++++++++++++++++++++----------------
 drivers/s390/block/dasd_int.h   |    2 +
 6 files changed, 48 insertions(+), 92 deletions(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index e9f3533..0ad2f1e 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -88,7 +88,6 @@ KBUILD_CFLAGS	+= -pipe -fno-strength-reduce -Wno-sign-compare
 KBUILD_AFLAGS	+= $(aflags-y)
 
 OBJCOPYFLAGS	:= -O binary
-LDFLAGS_vmlinux := -e start
 
 head-y		:= arch/s390/kernel/head.o
 head-y		+= arch/s390/kernel/$(if $(CONFIG_64BIT),head64.o,head31.o)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index e4c79eb..21109c6 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -9,12 +9,12 @@
 #ifndef CONFIG_64BIT
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
 OUTPUT_ARCH(s390)
-ENTRY(_start)
+ENTRY(startup)
 jiffies = jiffies_64 + 4;
 #else
 OUTPUT_FORMAT("elf64-s390", "elf64-s390", "elf64-s390")
 OUTPUT_ARCH(s390:64-bit)
-ENTRY(_start)
+ENTRY(startup)
 jiffies = jiffies_64;
 #endif
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index eef27a1..110137e 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3261,6 +3261,12 @@ void dasd_generic_path_event(struct ccw_device *cdev, int *path_event)
 			device->path_data.tbvpm |= eventlpm;
 			dasd_schedule_device_bh(device);
 		}
+		if (path_event[chp] & PE_PATHGROUP_ESTABLISHED) {
+			DBF_DEV_EVENT(DBF_WARNING, device, "%s",
+				      "Pathgroup re-established\n");
+			if (device->discipline->kick_validate)
+				device->discipline->kick_validate(device);
+		}
 	}
 	dasd_put_device(device);
 }
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 553b3c5..b3beed5 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -189,14 +189,12 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
 	unsigned long flags;
 	struct alias_server *server, *newserver;
 	struct alias_lcu *lcu, *newlcu;
-	int is_lcu_known;
 	struct dasd_uid uid;
 
 	private = (struct dasd_eckd_private *) device->private;
 
 	device->discipline->get_uid(device, &uid);
 	spin_lock_irqsave(&aliastree.lock, flags);
-	is_lcu_known = 1;
 	server = _find_server(&uid);
 	if (!server) {
 		spin_unlock_irqrestore(&aliastree.lock, flags);
@@ -208,7 +206,6 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
 		if (!server) {
 			list_add(&newserver->server, &aliastree.serverlist);
 			server = newserver;
-			is_lcu_known = 0;
 		} else {
 			/* someone was faster */
 			_free_server(newserver);
@@ -226,12 +223,10 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
 		if (!lcu) {
 			list_add(&newlcu->lcu, &server->lculist);
 			lcu = newlcu;
-			is_lcu_known = 0;
 		} else {
 			/* someone was faster */
 			_free_lcu(newlcu);
 		}
-		is_lcu_known = 0;
 	}
 	spin_lock(&lcu->lock);
 	list_add(&device->alias_list, &lcu->inactive_devices);
@@ -239,64 +234,7 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
 	spin_unlock(&lcu->lock);
 	spin_unlock_irqrestore(&aliastree.lock, flags);
 
-	return is_lcu_known;
-}
-
-/*
- * The first device to be registered on an LCU will have to do
- * some additional setup steps to configure that LCU on the
- * storage server. All further devices should wait with their
- * initialization until the first device is done.
- * To synchronize this work, the first device will call
- * dasd_alias_lcu_setup_complete when it is done, and all
- * other devices will wait for it with dasd_alias_wait_for_lcu_setup.
- */
-void dasd_alias_lcu_setup_complete(struct dasd_device *device)
-{
-	unsigned long flags;
-	struct alias_server *server;
-	struct alias_lcu *lcu;
-	struct dasd_uid uid;
-
-	device->discipline->get_uid(device, &uid);
-	lcu = NULL;
-	spin_lock_irqsave(&aliastree.lock, flags);
-	server = _find_server(&uid);
-	if (server)
-		lcu = _find_lcu(server, &uid);
-	spin_unlock_irqrestore(&aliastree.lock, flags);
-	if (!lcu) {
-		DBF_EVENT_DEVID(DBF_ERR, device->cdev,
-				"could not find lcu for %04x %02x",
-				uid.ssid, uid.real_unit_addr);
-		WARN_ON(1);
-		return;
-	}
-	complete_all(&lcu->lcu_setup);
-}
-
-void dasd_alias_wait_for_lcu_setup(struct dasd_device *device)
-{
-	unsigned long flags;
-	struct alias_server *server;
-	struct alias_lcu *lcu;
-	struct dasd_uid uid;
-
-	device->discipline->get_uid(device, &uid);
-	lcu = NULL;
-	spin_lock_irqsave(&aliastree.lock, flags);
-	server = _find_server(&uid);
-	if (server)
-		lcu = _find_lcu(server, &uid);
-	spin_unlock_irqrestore(&aliastree.lock, flags);
-	if (!lcu) {
-		DBF_EVENT_DEVID(DBF_ERR, device->cdev,
-				"could not find lcu for %04x %02x",
-				uid.ssid, uid.real_unit_addr);
-		WARN_ON(1);
-		return;
-	}
-	wait_for_completion(&lcu->lcu_setup);
+	return 0;
 }
 
 /*
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index bbcd5e9..70880be 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1534,6 +1534,10 @@ static void dasd_eckd_validate_server(struct dasd_device *device)
 	struct dasd_eckd_private *private;
 	int enable_pav;
 
+	private = (struct dasd_eckd_private *) device->private;
+	if (private->uid.type == UA_BASE_PAV_ALIAS ||
+	    private->uid.type == UA_HYPER_PAV_ALIAS)
+		return;
 	if (dasd_nopav || MACHINE_IS_VM)
 		enable_pav = 0;
 	else
@@ -1542,11 +1546,28 @@ static void dasd_eckd_validate_server(struct dasd_device *device)
 
 	/* may be requested feature is not available on server,
 	 * therefore just report error and go ahead */
-	private = (struct dasd_eckd_private *) device->private;
 	DBF_EVENT_DEVID(DBF_WARNING, device->cdev, "PSF-SSC for SSID %04x "
 			"returned rc=%d", private->uid.ssid, rc);
 }
 
+/*
+ * worker to do a validate server in case of a lost pathgroup
+ */
+static void dasd_eckd_do_validate_server(struct work_struct *work)
+{
+	struct dasd_device *device = container_of(work, struct dasd_device,
+						  kick_validate);
+	dasd_eckd_validate_server(device);
+	dasd_put_device(device);
+}
+
+static void dasd_eckd_kick_validate_server(struct dasd_device *device)
+{
+	dasd_get_device(device);
+	/* queue call to do_validate_server to the kernel event daemon. */
+	schedule_work(&device->kick_validate);
+}
+
 static u32 get_fcx_max_data(struct dasd_device *device)
 {
 #if defined(CONFIG_64BIT)
@@ -1588,10 +1609,13 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 	struct dasd_eckd_private *private;
 	struct dasd_block *block;
 	struct dasd_uid temp_uid;
-	int is_known, rc, i;
+	int rc, i;
 	int readonly;
 	unsigned long value;
 
+	/* setup work queue for validate server*/
+	INIT_WORK(&device->kick_validate, dasd_eckd_do_validate_server);
+
 	if (!ccw_device_is_pathgroup(device->cdev)) {
 		dev_warn(&device->cdev->dev,
 			 "A channel path group could not be established\n");
@@ -1651,22 +1675,12 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 		block->base = device;
 	}
 
-	/* register lcu with alias handling, enable PAV if this is a new lcu */
-	is_known = dasd_alias_make_device_known_to_lcu(device);
-	if (is_known < 0) {
-		rc = is_known;
+	/* register lcu with alias handling, enable PAV */
+	rc = dasd_alias_make_device_known_to_lcu(device);
+	if (rc)
 		goto out_err2;
-	}
-	/*
-	 * dasd_eckd_validate_server is done on the first device that
-	 * is found for an LCU. All later other devices have to wait
-	 * for it, so they will read the correct feature codes.
-	 */
-	if (!is_known) {
-		dasd_eckd_validate_server(device);
-		dasd_alias_lcu_setup_complete(device);
-	} else
-		dasd_alias_wait_for_lcu_setup(device);
+
+	dasd_eckd_validate_server(device);
 
 	/* device may report different configuration data after LCU setup */
 	rc = dasd_eckd_read_conf(device);
@@ -4098,7 +4112,7 @@ static int dasd_eckd_restore_device(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private;
 	struct dasd_eckd_characteristics temp_rdc_data;
-	int is_known, rc;
+	int rc;
 	struct dasd_uid temp_uid;
 	unsigned long flags;
 
@@ -4121,14 +4135,10 @@ static int dasd_eckd_restore_device(struct dasd_device *device)
 		goto out_err;
 
 	/* register lcu with alias handling, enable PAV if this is a new lcu */
-	is_known = dasd_alias_make_device_known_to_lcu(device);
-	if (is_known < 0)
-		return is_known;
-	if (!is_known) {
-		dasd_eckd_validate_server(device);
-		dasd_alias_lcu_setup_complete(device);
-	} else
-		dasd_alias_wait_for_lcu_setup(device);
+	rc = dasd_alias_make_device_known_to_lcu(device);
+	if (rc)
+		return rc;
+	dasd_eckd_validate_server(device);
 
 	/* RE-Read Configuration Data */
 	rc = dasd_eckd_read_conf(device);
@@ -4270,6 +4280,7 @@ static struct dasd_discipline dasd_eckd_discipline = {
 	.restore = dasd_eckd_restore_device,
 	.reload = dasd_eckd_reload_device,
 	.get_uid = dasd_eckd_get_uid,
+	.kick_validate = dasd_eckd_kick_validate_server,
 };
 
 static int __init
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index afe8c33..33a6743 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -355,6 +355,7 @@ struct dasd_discipline {
 	int (*reload) (struct dasd_device *);
 
 	int (*get_uid) (struct dasd_device *, struct dasd_uid *);
+	void (*kick_validate) (struct dasd_device *);
 };
 
 extern struct dasd_discipline *dasd_diag_discipline_pointer;
@@ -455,6 +456,7 @@ struct dasd_device {
 	struct work_struct kick_work;
 	struct work_struct restore_device;
 	struct work_struct reload_device;
+	struct work_struct kick_validate;
 	struct timer_list timer;
 
 	debug_info_t *debug_area;

