Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1DDRGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:06:33 -0400
Received: from mail.perches.com ([173.55.12.10]:4481 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1DDRG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:06:29 -0400
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] thinkpad_acpi: Convert printks to pr_<level>
Date: Mon,  4 Apr 2011 10:06:25 -0700
Message-Id: <c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <20110404130036.GB16669@srcf.ucam.org>
References: <20110404130036.GB16669@srcf.ucam.org>
In-Reply-To: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
References: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Removed local TPACPI_<level> #defines, convert to pr_<level>.
Neaten dbg_<foo> macros.
Added a few missing newlines to logging messages.
Added static inline str_supported for !CONFIG_THINKPAD_ACPI_DEBUG vdbg_printk
defect reported by Sedat Dilek <sedat.dilek@googlemail.com>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/thinkpad_acpi.c |  472 ++++++++++++++--------------------
 1 files changed, 188 insertions(+), 284 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2eaecd4..846945e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -21,6 +21,8 @@
  *  02110-1301, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define TPACPI_VERSION "0.24"
 #define TPACPI_SYSFS_VERSION 0x020700
 
@@ -223,17 +225,6 @@ enum tpacpi_hkey_event_t {
 
 #define TPACPI_MAX_ACPI_ARGS 3
 
-/* printk headers */
-#define TPACPI_LOG TPACPI_FILE ": "
-#define TPACPI_EMERG	KERN_EMERG	TPACPI_LOG
-#define TPACPI_ALERT	KERN_ALERT	TPACPI_LOG
-#define TPACPI_CRIT	KERN_CRIT	TPACPI_LOG
-#define TPACPI_ERR	KERN_ERR	TPACPI_LOG
-#define TPACPI_WARN	KERN_WARNING	TPACPI_LOG
-#define TPACPI_NOTICE	KERN_NOTICE	TPACPI_LOG
-#define TPACPI_INFO	KERN_INFO	TPACPI_LOG
-#define TPACPI_DEBUG	KERN_DEBUG	TPACPI_LOG
-
 /* Debugging printk groups */
 #define TPACPI_DBG_ALL		0xffff
 #define TPACPI_DBG_DISCLOSETASK	0x8000
@@ -388,34 +379,36 @@ static int tpacpi_uwb_emulstate;
  *  Debugging helpers
  */
 
-#define dbg_printk(a_dbg_level, format, arg...) \
-	do { if (dbg_level & (a_dbg_level)) \
-		printk(TPACPI_DEBUG "%s: " format, __func__ , ## arg); \
-	} while (0)
+#define dbg_printk(a_dbg_level, format, arg...)				\
+do {									\
+	if (dbg_level & (a_dbg_level))					\
+		printk(KERN_DEBUG pr_fmt("%s: " format),		\
+		       __func__, ##arg);				\
+} while (0)
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUG
 #define vdbg_printk dbg_printk
 static const char *str_supported(int is_supported);
 #else
-#define vdbg_printk(a_dbg_level, format, arg...) \
-	do { } while (0)
+static inline const char *str_supported(int is_supported) { return ""; }
+#define vdbg_printk(a_dbg_level, format, arg...)	\
+	no_printk(format, ##arg)
 #endif
 
 static void tpacpi_log_usertask(const char * const what)
 {
-	printk(TPACPI_DEBUG "%s: access by process with PID %d\n",
-		what, task_tgid_vnr(current));
+	printk(KERN_DEBUG pr_fmt("%s: access by process with PID %d\n"),
+	       what, task_tgid_vnr(current));
 }
 
-#define tpacpi_disclose_usertask(what, format, arg...) \
-	do { \
-		if (unlikely( \
-		    (dbg_level & TPACPI_DBG_DISCLOSETASK) && \
-		    (tpacpi_lifecycle == TPACPI_LIFE_RUNNING))) { \
-			printk(TPACPI_DEBUG "%s: PID %d: " format, \
-				what, task_tgid_vnr(current), ## arg); \
-		} \
-	} while (0)
+#define tpacpi_disclose_usertask(what, format, arg...)			\
+do {									\
+	if (unlikely((dbg_level & TPACPI_DBG_DISCLOSETASK) &&		\
+		     (tpacpi_lifecycle == TPACPI_LIFE_RUNNING))) {	\
+		printk(KERN_DEBUG pr_fmt("%s: PID %d: " format),	\
+		       what, task_tgid_vnr(current), ## arg);		\
+	}								\
+} while (0)
 
 /*
  * Quirk handling helpers
@@ -553,7 +546,7 @@ static int acpi_evalf(acpi_handle handle,
 	int quiet;
 
 	if (!*fmt) {
-		printk(TPACPI_ERR "acpi_evalf() called with empty format\n");
+		pr_err("acpi_evalf() called with empty format\n");
 		return 0;
 	}
 
@@ -578,7 +571,7 @@ static int acpi_evalf(acpi_handle handle,
 			break;
 			/* add more types as needed */
 		default:
-			printk(TPACPI_ERR "acpi_evalf() called "
+			pr_err("acpi_evalf() called "
 			       "with invalid format character '%c'\n", c);
 			va_end(ap);
 			return 0;
@@ -607,13 +600,13 @@ static int acpi_evalf(acpi_handle handle,
 		break;
 		/* add more types as needed */
 	default:
-		printk(TPACPI_ERR "acpi_evalf() called "
+		pr_err("acpi_evalf() called "
 		       "with invalid format character '%c'\n", res_type);
 		return 0;
 	}
 
 	if (!success && !quiet)
-		printk(TPACPI_ERR "acpi_evalf(%s, %s, ...) failed: %s\n",
+		pr_err("acpi_evalf(%s, %s, ...) failed: %s\n",
 		       method, fmt0, acpi_format_exception(status));
 
 	return success;
@@ -757,8 +750,7 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 
 	rc = acpi_bus_get_device(*ibm->acpi->handle, &ibm->acpi->device);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_get_device(%s) failed: %d\n",
-			ibm->name, rc);
+		pr_err("acpi_bus_get_device(%s) failed: %d\n", ibm->name, rc);
 		return -ENODEV;
 	}
 
@@ -771,12 +763,10 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 			ibm->acpi->type, dispatch_acpi_notify, ibm);
 	if (ACPI_FAILURE(status)) {
 		if (status == AE_ALREADY_EXISTS) {
-			printk(TPACPI_NOTICE
-			       "another device driver is already "
-			       "handling %s events\n", ibm->name);
+			pr_notice("another device driver is already "
+				  "handling %s events\n", ibm->name);
 		} else {
-			printk(TPACPI_ERR
-			       "acpi_install_notify_handler(%s) failed: %s\n",
+			pr_err("acpi_install_notify_handler(%s) failed: %s\n",
 			       ibm->name, acpi_format_exception(status));
 		}
 		return -ENODEV;
@@ -801,8 +791,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	ibm->acpi->driver = kzalloc(sizeof(struct acpi_driver), GFP_KERNEL);
 	if (!ibm->acpi->driver) {
-		printk(TPACPI_ERR
-		       "failed to allocate memory for ibm->acpi->driver\n");
+		pr_err("failed to allocate memory for ibm->acpi->driver\n");
 		return -ENOMEM;
 	}
 
@@ -813,7 +802,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	rc = acpi_bus_register_driver(ibm->acpi->driver);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_register_driver(%s) failed: %d\n",
+		pr_err("acpi_bus_register_driver(%s) failed: %d\n",
 		       ibm->name, rc);
 		kfree(ibm->acpi->driver);
 		ibm->acpi->driver = NULL;
@@ -1071,15 +1060,14 @@ static int parse_strtoul(const char *buf,
 static void tpacpi_disable_brightness_delay(void)
 {
 	if (acpi_evalf(hkey_handle, NULL, "PWMS", "qvd", 0))
-		printk(TPACPI_NOTICE
-			"ACPI backlight control delay disabled\n");
+		pr_notice("ACPI backlight control delay disabled\n");
 }
 
 static void printk_deprecated_attribute(const char * const what,
 					const char * const details)
 {
 	tpacpi_log_usertask("deprecated sysfs attribute");
-	printk(TPACPI_WARN "WARNING: sysfs attribute %s is deprecated and "
+	pr_warn("WARNING: sysfs attribute %s is deprecated and "
 		"will be removed. %s\n",
 		what, details);
 }
@@ -1254,8 +1242,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 						&tpacpi_rfk_rfkill_ops,
 						atp_rfk);
 	if (!atp_rfk || !atp_rfk->rfkill) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for rfkill class\n");
+		pr_err("failed to allocate memory for rfkill class\n");
 		kfree(atp_rfk);
 		return -ENOMEM;
 	}
@@ -1265,9 +1252,8 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	sw_status = (tp_rfkops->get_status)();
 	if (sw_status < 0) {
-		printk(TPACPI_ERR
-			"failed to read initial state for %s, error %d\n",
-			name, sw_status);
+		pr_err("failed to read initial state for %s, error %d\n",
+		       name, sw_status);
 	} else {
 		sw_state = (sw_status == TPACPI_RFK_RADIO_OFF);
 		if (set_default) {
@@ -1281,9 +1267,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
-		printk(TPACPI_ERR
-			"failed to register %s rfkill switch: %d\n",
-			name, res);
+		pr_err("failed to register %s rfkill switch: %d\n", name, res);
 		rfkill_destroy(atp_rfk->rfkill);
 		kfree(atp_rfk);
 		return res;
@@ -1291,7 +1275,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	tpacpi_rfkill_switches[id] = atp_rfk;
 
-	printk(TPACPI_INFO "rfkill switch %s: radio is %sblocked\n",
+	pr_info("rfkill switch %s: radio is %sblocked\n",
 		name, (sw_state || hw_state) ? "" : "un");
 	return 0;
 }
@@ -1815,10 +1799,8 @@ static void __init tpacpi_check_outdated_fw(void)
 		 * broken, or really stable to begin with, so it is
 		 * best if the user upgrades the firmware anyway.
 		 */
-		printk(TPACPI_WARN
-			"WARNING: Outdated ThinkPad BIOS/EC firmware\n");
-		printk(TPACPI_WARN
-			"WARNING: This firmware may be missing critical bug "
+		pr_warn("WARNING: Outdated ThinkPad BIOS/EC firmware\n");
+		pr_warn("WARNING: This firmware may be missing critical bug "
 			"fixes and/or important features\n");
 	}
 }
@@ -2107,9 +2089,7 @@ void static hotkey_mask_warn_incomplete_mask(void)
 		(hotkey_all_mask | TPACPI_HKEY_NVRAM_KNOWN_MASK);
 
 	if (wantedmask)
-		printk(TPACPI_NOTICE
-			"required events 0x%08x not enabled!\n",
-			wantedmask);
+		pr_notice("required events 0x%08x not enabled!\n", wantedmask);
 }
 
 /*
@@ -2147,10 +2127,9 @@ static int hotkey_mask_set(u32 mask)
 	 * a given event.
 	 */
 	if (!hotkey_mask_get() && !rc && (fwmask & ~hotkey_acpi_mask)) {
-		printk(TPACPI_NOTICE
-		       "asked for hotkey mask 0x%08x, but "
-		       "firmware forced it to 0x%08x\n",
-		       fwmask, hotkey_acpi_mask);
+		pr_notice("asked for hotkey mask 0x%08x, but "
+			  "firmware forced it to 0x%08x\n",
+			  fwmask, hotkey_acpi_mask);
 	}
 
 	if (tpacpi_lifecycle != TPACPI_LIFE_EXITING)
@@ -2174,13 +2153,11 @@ static int hotkey_user_mask_set(const u32 mask)
 	    (mask == 0xffff || mask == 0xffffff ||
 	     mask == 0xffffffff)) {
 		tp_warned.hotkey_mask_ff = 1;
-		printk(TPACPI_NOTICE
-		       "setting the hotkey mask to 0x%08x is likely "
-		       "not the best way to go about it\n", mask);
-		printk(TPACPI_NOTICE
-		       "please consider using the driver defaults, "
-		       "and refer to up-to-date thinkpad-acpi "
-		       "documentation\n");
+		pr_notice("setting the hotkey mask to 0x%08x is likely "
+			  "not the best way to go about it\n", mask);
+		pr_notice("please consider using the driver defaults, "
+			  "and refer to up-to-date thinkpad-acpi "
+			  "documentation\n");
 	}
 
 	/* Try to enable what the user asked for, plus whatever we need.
@@ -2564,8 +2541,7 @@ static void hotkey_poll_setup(const bool may_warn)
 					NULL, TPACPI_NVRAM_KTHREAD_NAME);
 			if (IS_ERR(tpacpi_hotkey_task)) {
 				tpacpi_hotkey_task = NULL;
-				printk(TPACPI_ERR
-				       "could not create kernel thread "
+				pr_err("could not create kernel thread "
 				       "for hotkey polling\n");
 			}
 		}
@@ -2573,11 +2549,10 @@ static void hotkey_poll_setup(const bool may_warn)
 		hotkey_poll_stop_sync();
 		if (may_warn && (poll_driver_mask || poll_user_mask) &&
 		    hotkey_poll_freq == 0) {
-			printk(TPACPI_NOTICE
-				"hot keys 0x%08x and/or events 0x%08x "
-				"require polling, which is currently "
-				"disabled\n",
-				poll_user_mask, poll_driver_mask);
+			pr_notice("hot keys 0x%08x and/or events 0x%08x "
+				  "require polling, which is currently "
+				  "disabled\n",
+				  poll_user_mask, poll_driver_mask);
 		}
 	}
 }
@@ -2801,13 +2776,13 @@ static ssize_t hotkey_source_mask_store(struct device *dev,
 	mutex_unlock(&hotkey_mutex);
 
 	if (rc < 0)
-		printk(TPACPI_ERR "hotkey_source_mask: failed to update the"
-			"firmware event mask!\n");
+		pr_err("hotkey_source_mask: "
+		       "failed to update the firmware event mask!\n");
 
 	if (r_ev)
-		printk(TPACPI_NOTICE "hotkey_source_mask: "
-			"some important events were disabled: "
-			"0x%04x\n", r_ev);
+		pr_notice("hotkey_source_mask: "
+			  "some important events were disabled: 0x%04x\n",
+			  r_ev);
 
 	tpacpi_disclose_usertask("hotkey_source_mask", "set to 0x%08lx\n", t);
 
@@ -3038,8 +3013,7 @@ static void hotkey_exit(void)
 	if (((tp_features.hotkey_mask &&
 	      hotkey_mask_set(hotkey_orig_mask)) |
 	     hotkey_status_set(false)) != 0)
-		printk(TPACPI_ERR
-		       "failed to restore hot key mask "
+		pr_err("failed to restore hot key mask "
 		       "to BIOS defaults\n");
 }
 
@@ -3278,10 +3252,9 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	   for HKEY interface version 0x100 */
 	if (acpi_evalf(hkey_handle, &hkeyv, "MHKV", "qd")) {
 		if ((hkeyv >> 8) != 1) {
-			printk(TPACPI_ERR "unknown version of the "
-			       "HKEY interface: 0x%x\n", hkeyv);
-			printk(TPACPI_ERR "please report this to %s\n",
-			       TPACPI_MAIL);
+			pr_err("unknown version of the HKEY interface: 0x%x\n",
+			       hkeyv);
+			pr_err("please report this to %s\n", TPACPI_MAIL);
 		} else {
 			/*
 			 * MHKV 0x100 in A31, R40, R40e,
@@ -3294,8 +3267,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 			/* Paranoia check AND init hotkey_all_mask */
 			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
 					"MHKA", "qd")) {
-				printk(TPACPI_ERR
-				       "missing MHKA handler, "
+				pr_err("missing MHKA handler, "
 				       "please report this to %s\n",
 				       TPACPI_MAIL);
 				/* Fallback: pre-init for FN+F3,F4,F12 */
@@ -3333,16 +3305,14 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	if (dbg_wlswemul) {
 		tp_features.hotkey_wlsw = 1;
 		radiosw_state = !!tpacpi_wlsw_emulstate;
-		printk(TPACPI_INFO
-			"radio switch emulation enabled\n");
+		pr_info("radio switch emulation enabled\n");
 	} else
 #endif
 	/* Not all thinkpads have a hardware radio switch */
 	if (acpi_evalf(hkey_handle, &status, "WLSW", "qd")) {
 		tp_features.hotkey_wlsw = 1;
 		radiosw_state = !!status;
-		printk(TPACPI_INFO
-			"radio switch found; radios are %s\n",
+		pr_info("radio switch found; radios are %s\n",
 			enabled(status, 0));
 	}
 	if (tp_features.hotkey_wlsw)
@@ -3353,8 +3323,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
 		tp_features.hotkey_tablet = 1;
 		tabletsw_state = !!(status & TP_HOTKEY_TABLET_MASK);
-		printk(TPACPI_INFO
-			"possible tablet mode switch found; "
+		pr_info("possible tablet mode switch found; "
 			"ThinkPad in %s mode\n",
 			(tabletsw_state) ? "tablet" : "laptop");
 		res = add_to_attr_set(hotkey_dev_attributes,
@@ -3372,8 +3341,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
 					GFP_KERNEL);
 	if (!hotkey_keycode_map) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for key map\n");
+		pr_err("failed to allocate memory for key map\n");
 		res = -ENOMEM;
 		goto err_exit;
 	}
@@ -3416,13 +3384,11 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	 * userspace. tpacpi_detect_brightness_capabilities() must have
 	 * been called before this point  */
 	if (tp_features.bright_acpimode && acpi_video_backlight_support()) {
-		printk(TPACPI_INFO
-		       "This ThinkPad has standard ACPI backlight "
-		       "brightness control, supported by the ACPI "
-		       "video driver\n");
-		printk(TPACPI_NOTICE
-		       "Disabling thinkpad-acpi brightness events "
-		       "by default...\n");
+		pr_info("This ThinkPad has standard ACPI backlight "
+			"brightness control, supported by the ACPI "
+			"video driver\n");
+		pr_notice("Disabling thinkpad-acpi brightness events "
+			  "by default...\n");
 
 		/* Disable brightness up/down on Lenovo thinkpads when
 		 * ACPI is handling them, otherwise it is plain impossible
@@ -3529,8 +3495,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 
 	case TP_HKEY_EV_WKUP_S3_BATLOW: /* Battery on critical low level/S3 */
 	case TP_HKEY_EV_WKUP_S4_BATLOW: /* Battery on critical low level/S4 */
-		printk(TPACPI_ALERT
-			"EMERGENCY WAKEUP: battery almost empty\n");
+		pr_alert("EMERGENCY WAKEUP: battery almost empty\n");
 		/* how to auto-heal: */
 		/* 2313: woke up from S3, go to S4/S5 */
 		/* 2413: woke up from S4, go to S5 */
@@ -3541,9 +3506,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 	}
 
 	if (hotkey_wakeup_reason != TP_ACPI_WAKEUP_NONE) {
-		printk(TPACPI_INFO
-		       "woke up due to a hot-unplug "
-		       "request...\n");
+		pr_info("woke up due to a hot-unplug request...\n");
 		hotkey_wakeup_reason_notify_change();
 	}
 	return true;
@@ -3595,37 +3558,31 @@ static bool hotkey_notify_thermal(const u32 hkey,
 
 	switch (hkey) {
 	case TP_HKEY_EV_THM_TABLE_CHANGED:
-		printk(TPACPI_INFO
-			"EC reports that Thermal Table has changed\n");
+		pr_info("EC reports that Thermal Table has changed\n");
 		/* recommended action: do nothing, we don't have
 		 * Lenovo ATM information */
 		return true;
 	case TP_HKEY_EV_ALARM_BAT_HOT:
-		printk(TPACPI_CRIT
-			"THERMAL ALARM: battery is too hot!\n");
+		pr_crit("THERMAL ALARM: battery is too hot!\n");
 		/* recommended action: warn user through gui */
 		break;
 	case TP_HKEY_EV_ALARM_BAT_XHOT:
-		printk(TPACPI_ALERT
-			"THERMAL EMERGENCY: battery is extremely hot!\n");
+		pr_alert("THERMAL EMERGENCY: battery is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
 	case TP_HKEY_EV_ALARM_SENSOR_HOT:
-		printk(TPACPI_CRIT
-			"THERMAL ALARM: "
+		pr_crit("THERMAL ALARM: "
 			"a sensor reports something is too hot!\n");
 		/* recommended action: warn user through gui, that */
 		/* some internal component is too hot */
 		break;
 	case TP_HKEY_EV_ALARM_SENSOR_XHOT:
-		printk(TPACPI_ALERT
-			"THERMAL EMERGENCY: "
-			"a sensor reports something is extremely hot!\n");
+		pr_alert("THERMAL EMERGENCY: "
+			 "a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
 	default:
-		printk(TPACPI_ALERT
-			 "THERMAL ALERT: unknown thermal alarm received\n");
+		pr_alert("THERMAL ALERT: unknown thermal alarm received\n");
 		known = false;
 	}
 
@@ -3642,8 +3599,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 	bool known_ev;
 
 	if (event != 0x80) {
-		printk(TPACPI_ERR
-		       "unknown HKEY notification event %d\n", event);
+		pr_err("unknown HKEY notification event %d\n", event);
 		/* forward it to userspace, maybe it knows how to handle it */
 		acpi_bus_generate_netlink_event(
 					ibm->acpi->device->pnp.device_class,
@@ -3654,7 +3610,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 
 	while (1) {
 		if (!acpi_evalf(hkey_handle, &hkey, "MHKP", "d")) {
-			printk(TPACPI_ERR "failed to retrieve HKEY event\n");
+			pr_err("failed to retrieve HKEY event\n");
 			return;
 		}
 
@@ -3682,8 +3638,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			switch (hkey) {
 			case TP_HKEY_EV_BAYEJ_ACK:
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "bay ejected\n");
+				pr_info("bay ejected\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 				break;
@@ -3699,8 +3654,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			/* 0x4000-0x4FFF: dock-related wakeups */
 			if (hkey == TP_HKEY_EV_UNDOCK_ACK) {
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "undocked\n");
+				pr_info("undocked\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 			} else {
@@ -3731,11 +3685,9 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			known_ev = false;
 		}
 		if (!known_ev) {
-			printk(TPACPI_NOTICE
-			       "unhandled HKEY event 0x%04x\n", hkey);
-			printk(TPACPI_NOTICE
-			       "please report the conditions when this "
-			       "event happened to %s\n", TPACPI_MAIL);
+			pr_notice("unhandled HKEY event 0x%04x\n", hkey);
+			pr_notice("please report the conditions when this "
+				  "event happened to %s\n", TPACPI_MAIL);
 		}
 
 		/* Legacy events */
@@ -3768,8 +3720,7 @@ static void hotkey_resume(void)
 
 	if (hotkey_status_set(true) < 0 ||
 	    hotkey_mask_set(hotkey_acpi_mask) < 0)
-		printk(TPACPI_ERR
-		       "error while attempting to reset the event "
+		pr_err("error while attempting to reset the event "
 		       "firmware interface\n");
 
 	tpacpi_send_radiosw_update();
@@ -3814,14 +3765,12 @@ static void hotkey_enabledisable_warn(bool enable)
 {
 	tpacpi_log_usertask("procfs hotkey enable/disable");
 	if (!WARN((tpacpi_lifecycle == TPACPI_LIFE_RUNNING || !enable),
-			TPACPI_WARN
-			"hotkey enable/disable functionality has been "
-			"removed from the driver.  Hotkeys are always "
-			"enabled\n"))
-		printk(TPACPI_ERR
-			"Please remove the hotkey=enable module "
-			"parameter, it is deprecated.  Hotkeys are always "
-			"enabled\n");
+		  pr_fmt("hotkey enable/disable functionality has been "
+			 "removed from the driver.  "
+			 "Hotkeys are always enabled.\n")))
+		pr_err("Please remove the hotkey=enable module "
+		       "parameter, it is deprecated.  "
+		       "Hotkeys are always enabled.\n");
 }
 
 static int hotkey_write(char *buf)
@@ -4000,8 +3949,7 @@ static void bluetooth_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
 			TP_ACPI_BLTH_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save bluetooth state to NVRAM\n");
+		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"bluestooth state saved to NVRAM\n");
@@ -4040,8 +3988,7 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
 		tp_features.bluetooth = 1;
-		printk(TPACPI_INFO
-			"bluetooth switch emulation enabled\n");
+		pr_info("bluetooth switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.bluetooth &&
@@ -4192,8 +4139,7 @@ static void wan_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\WGSV", "vd",
 			TP_ACPI_WGSV_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save WWAN state to NVRAM\n");
+		pr_notice("failed to save WWAN state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"WWAN state saved to NVRAM\n");
@@ -4230,8 +4176,7 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
 		tp_features.wan = 1;
-		printk(TPACPI_INFO
-			"wwan switch emulation enabled\n");
+		pr_info("wwan switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.wan &&
@@ -4371,8 +4316,7 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
 		tp_features.uwb = 1;
-		printk(TPACPI_INFO
-			"uwb switch emulation enabled\n");
+		pr_info("uwb switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.uwb &&
@@ -4485,7 +4429,7 @@ static void video_exit(void)
 	dbg_printk(TPACPI_DBG_EXIT,
 		   "restoring original video autoswitch mode\n");
 	if (video_autosw_set(video_orig_autosw))
-		printk(TPACPI_ERR "error while trying to restore original "
+		pr_err("error while trying to restore original "
 			"video autoswitch mode\n");
 }
 
@@ -4558,8 +4502,7 @@ static int video_outputsw_set(int status)
 		res = acpi_evalf(vid_handle, NULL,
 				 "ASWT", "vdd", status * 0x100, 0);
 		if (!autosw && video_autosw_set(autosw)) {
-			printk(TPACPI_ERR
-			       "video auto-switch left enabled due to error\n");
+			pr_err("video auto-switch left enabled due to error\n");
 			return -EIO;
 		}
 		break;
@@ -4628,8 +4571,7 @@ static int video_outputsw_cycle(void)
 		return -ENOSYS;
 	}
 	if (!autosw && video_autosw_set(autosw)) {
-		printk(TPACPI_ERR
-		       "video auto-switch left enabled due to error\n");
+		pr_err("video auto-switch left enabled due to error\n");
 		return -EIO;
 	}
 
@@ -5346,7 +5288,7 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	tpacpi_leds = kzalloc(sizeof(*tpacpi_leds) * TPACPI_LED_NUMLEDS,
 			      GFP_KERNEL);
 	if (!tpacpi_leds) {
-		printk(TPACPI_ERR "Out of memory for LED data\n");
+		pr_err("Out of memory for LED data\n");
 		return -ENOMEM;
 	}
 
@@ -5365,9 +5307,8 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	}
 
 #ifdef CONFIG_THINKPAD_ACPI_UNSAFE_LEDS
-	printk(TPACPI_NOTICE
-		"warning: userspace override of important "
-		"firmware LEDs is enabled\n");
+	pr_notice("warning: userspace override of important "
+		  "firmware LEDs is enabled\n");
 #endif
 	return 0;
 }
@@ -5637,17 +5578,16 @@ static void thermal_dump_all_sensors(void)
 	if (n <= 0)
 		return;
 
-	printk(TPACPI_NOTICE
-		"temperatures (Celsius):");
+	pr_notice("temperatures (Celsius):");
 
 	for (i = 0; i < n; i++) {
 		if (t.temp[i] != TPACPI_THERMAL_SENSOR_NA)
-			printk(KERN_CONT " %d", (int)(t.temp[i] / 1000));
+			pr_cont(" %d", (int)(t.temp[i] / 1000));
 		else
-			printk(KERN_CONT " N/A");
+			pr_cont(" N/A");
 	}
 
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 /* sysfs temp##_input -------------------------------------------------- */
@@ -5767,14 +5707,12 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 		if (ta1 == 0) {
 			/* This is sheer paranoia, but we handle it anyway */
 			if (acpi_tmp7) {
-				printk(TPACPI_ERR
-				       "ThinkPad ACPI EC access misbehaving, "
+				pr_err("ThinkPad ACPI EC access misbehaving, "
 				       "falling back to ACPI TMPx access "
 				       "mode\n");
 				thermal_read_mode = TPACPI_THERMAL_ACPI_TMP07;
 			} else {
-				printk(TPACPI_ERR
-				       "ThinkPad ACPI EC access misbehaving, "
+				pr_err("ThinkPad ACPI EC access misbehaving, "
 				       "disabling thermal sensors access\n");
 				thermal_read_mode = TPACPI_THERMAL_NONE;
 			}
@@ -6127,8 +6065,8 @@ static int __init tpacpi_query_bcl_levels(acpi_handle handle)
 	if (ACPI_SUCCESS(acpi_evaluate_object(handle, "_BCL", NULL, &buffer))) {
 		obj = (union acpi_object *)buffer.pointer;
 		if (!obj || (obj->type != ACPI_TYPE_PACKAGE)) {
-			printk(TPACPI_ERR "Unknown _BCL data, "
-			       "please report this to %s\n", TPACPI_MAIL);
+			pr_err("Unknown _BCL data, please report this to %s\n",
+			       TPACPI_MAIL);
 			rc = 0;
 		} else {
 			rc = obj->package.count;
@@ -6212,18 +6150,15 @@ static void __init tpacpi_detect_brightness_capabilities(void)
 	switch (b) {
 	case 16:
 		bright_maxlvl = 15;
-		printk(TPACPI_INFO
-		       "detected a 16-level brightness capable ThinkPad\n");
+		pr_info("detected a 16-level brightness capable ThinkPad\n");
 		break;
 	case 8:
 	case 0:
 		bright_maxlvl = 7;
-		printk(TPACPI_INFO
-		       "detected a 8-level brightness capable ThinkPad\n");
+		pr_info("detected a 8-level brightness capable ThinkPad\n");
 		break;
 	default:
-		printk(TPACPI_ERR
-		       "Unsupported brightness interface, "
+		pr_err("Unsupported brightness interface, "
 		       "please contact %s\n", TPACPI_MAIL);
 		tp_features.bright_unkfw = 1;
 		bright_maxlvl = b - 1;
@@ -6258,22 +6193,19 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 
 	if (acpi_video_backlight_support()) {
 		if (brightness_enable > 1) {
-			printk(TPACPI_INFO
-			       "Standard ACPI backlight interface "
-			       "available, not loading native one.\n");
+			pr_info("Standard ACPI backlight interface "
+				"available, not loading native one\n");
 			return 1;
 		} else if (brightness_enable == 1) {
-			printk(TPACPI_WARN
-				"Cannot enable backlight brightness support, "
+			pr_warn("Cannot enable backlight brightness support, "
 				"ACPI is already handling it.  Refer to the "
-				"acpi_backlight kernel parameter\n");
+				"acpi_backlight kernel parameter.\n");
 			return 1;
 		}
 	} else if (tp_features.bright_acpimode && brightness_enable > 1) {
-		printk(TPACPI_NOTICE
-			"Standard ACPI backlight interface not "
-			"available, thinkpad_acpi native "
-			"brightness control enabled\n");
+		pr_notice("Standard ACPI backlight interface not "
+			  "available, thinkpad_acpi native "
+			  "brightness control enabled\n");
 	}
 
 	/*
@@ -6317,19 +6249,17 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	if (IS_ERR(ibm_backlight_device)) {
 		int rc = PTR_ERR(ibm_backlight_device);
 		ibm_backlight_device = NULL;
-		printk(TPACPI_ERR "Could not register backlight device\n");
+		pr_err("Could not register backlight device\n");
 		return rc;
 	}
 	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
 			"brightness is supported\n");
 
 	if (quirks & TPACPI_BRGHT_Q_ASK) {
-		printk(TPACPI_NOTICE
-			"brightness: will use unverified default: "
-			"brightness_mode=%d\n", brightness_mode);
-		printk(TPACPI_NOTICE
-			"brightness: please report to %s whether it works well "
-			"or not on your ThinkPad\n", TPACPI_MAIL);
+		pr_notice("brightness: will use unverified default: "
+			  "brightness_mode=%d\n", brightness_mode);
+		pr_notice("brightness: please report to %s whether it works well "
+			  "or not on your ThinkPad\n", TPACPI_MAIL);
 	}
 
 	/* Added by mistake in early 2007.  Probably useless, but it could
@@ -6802,8 +6732,7 @@ static int __init volume_create_alsa_mixer(void)
 	rc = snd_card_create(alsa_index, alsa_id, THIS_MODULE,
 			    sizeof(struct tpacpi_alsa_data), &card);
 	if (rc < 0 || !card) {
-		printk(TPACPI_ERR
-			"Failed to create ALSA card structures: %d\n", rc);
+		pr_err("Failed to create ALSA card structures: %d\n", rc);
 		return 1;
 	}
 
@@ -6837,9 +6766,8 @@ static int __init volume_create_alsa_mixer(void)
 		ctl_vol = snd_ctl_new1(&volume_alsa_control_vol, NULL);
 		rc = snd_ctl_add(card, ctl_vol);
 		if (rc < 0) {
-			printk(TPACPI_ERR
-				"Failed to create ALSA volume control: %d\n",
-				rc);
+			pr_err("Failed to create ALSA volume control: %d\n",
+			       rc);
 			goto err_exit;
 		}
 		data->ctl_vol_id = &ctl_vol->id;
@@ -6848,8 +6776,7 @@ static int __init volume_create_alsa_mixer(void)
 	ctl_mute = snd_ctl_new1(&volume_alsa_control_mute, NULL);
 	rc = snd_ctl_add(card, ctl_mute);
 	if (rc < 0) {
-		printk(TPACPI_ERR "Failed to create ALSA mute control: %d\n",
-			rc);
+		pr_err("Failed to create ALSA mute control: %d\n", rc);
 		goto err_exit;
 	}
 	data->ctl_mute_id = &ctl_mute->id;
@@ -6857,7 +6784,7 @@ static int __init volume_create_alsa_mixer(void)
 	snd_card_set_dev(card, &tpacpi_pdev->dev);
 	rc = snd_card_register(card);
 	if (rc < 0) {
-		printk(TPACPI_ERR "Failed to register ALSA card: %d\n", rc);
+		pr_err("Failed to register ALSA card: %d\n", rc);
 		goto err_exit;
 	}
 
@@ -6913,9 +6840,8 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 		return -EINVAL;
 
 	if (volume_mode == TPACPI_VOL_MODE_UCMS_STEP) {
-		printk(TPACPI_ERR
-			"UCMS step volume mode not implemented, "
-			"please contact %s\n", TPACPI_MAIL);
+		pr_err("UCMS step volume mode not implemented, "
+		       "please contact %s\n", TPACPI_MAIL);
 		return 1;
 	}
 
@@ -6979,13 +6905,11 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 
 	rc = volume_create_alsa_mixer();
 	if (rc) {
-		printk(TPACPI_ERR
-			"Could not create the ALSA mixer interface\n");
+		pr_err("Could not create the ALSA mixer interface\n");
 		return rc;
 	}
 
-	printk(TPACPI_INFO
-		"Console audio control enabled, mode: %s\n",
+	pr_info("Console audio control enabled, mode: %s\n",
 		(volume_control_allowed) ?
 			"override (read/write)" :
 			"monitor (read only)");
@@ -7047,12 +6971,10 @@ static int volume_write(char *buf)
 	if (!volume_control_allowed && tpacpi_lifecycle != TPACPI_LIFE_INIT) {
 		if (unlikely(!tp_warned.volume_ctrl_forbidden)) {
 			tp_warned.volume_ctrl_forbidden = 1;
-			printk(TPACPI_NOTICE
-				"Console audio control in monitor mode, "
-				"changes are not allowed.\n");
-			printk(TPACPI_NOTICE
-				"Use the volume_control=1 module parameter "
-				"to enable volume control\n");
+			pr_notice("Console audio control in monitor mode, "
+				  "changes are not allowed\n");
+			pr_notice("Use the volume_control=1 module parameter "
+				  "to enable volume control\n");
 		}
 		return -EPERM;
 	}
@@ -7127,8 +7049,7 @@ static void inline volume_alsa_notify_change(void)
 
 static int __init volume_init(struct ibm_init_struct *iibm)
 {
-	printk(TPACPI_INFO
-		"volume: disabled as there is no ALSA support in this kernel\n");
+	pr_info("volume: disabled as there is no ALSA support in this kernel\n");
 
 	return 1;
 }
@@ -7335,9 +7256,8 @@ TPACPI_HANDLE(sfan, ec, "SFAN",	/* 570 */
 static void fan_quirk1_setup(void)
 {
 	if (fan_control_initial_status == 0x07) {
-		printk(TPACPI_NOTICE
-		       "fan_init: initial fan status is unknown, "
-		       "assuming it is in auto mode\n");
+		pr_notice("fan_init: initial fan status is unknown, "
+			  "assuming it is in auto mode\n");
 		tp_features.fan_ctrl_status_undef = 1;
 	}
 }
@@ -7724,8 +7644,7 @@ static void fan_watchdog_reset(void)
 		if (!queue_delayed_work(tpacpi_wq, &fan_watchdog_task,
 				msecs_to_jiffies(fan_watchdog_maxinterval
 						 * 1000))) {
-			printk(TPACPI_ERR
-			       "failed to queue the fan watchdog, "
+			pr_err("failed to queue the fan watchdog, "
 			       "watchdog will not trigger\n");
 		}
 	} else
@@ -7739,11 +7658,11 @@ static void fan_watchdog_fire(struct work_struct *ignored)
 	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
 		return;
 
-	printk(TPACPI_NOTICE "fan watchdog: enabling fan\n");
+	pr_notice("fan watchdog: enabling fan\n");
 	rc = fan_set_enable();
 	if (rc < 0) {
-		printk(TPACPI_ERR "fan watchdog: error %d while enabling fan, "
-			"will try again later...\n", -rc);
+		pr_err("fan watchdog: error %d while enabling fan, "
+		       "will try again later...\n", -rc);
 		/* reschedule for later */
 		fan_watchdog_reset();
 	}
@@ -8047,8 +7966,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 					"secondary fan support enabled\n");
 			}
 		} else {
-			printk(TPACPI_ERR
-			       "ThinkPad ACPI EC access misbehaving, "
+			pr_err("ThinkPad ACPI EC access misbehaving, "
 			       "fan status and control unavailable\n");
 			return 1;
 		}
@@ -8148,9 +8066,8 @@ static void fan_suspend(pm_message_t state)
 	fan_control_resume_level = 0;
 	rc = fan_get_status_safe(&fan_control_resume_level);
 	if (rc < 0)
-		printk(TPACPI_NOTICE
-			"failed to read fan level for later "
-			"restore during resume: %d\n", rc);
+		pr_notice("failed to read fan level for later "
+			  "restore during resume: %d\n", rc);
 
 	/* if it is undefined, don't attempt to restore it.
 	 * KEEP THIS LAST */
@@ -8205,13 +8122,11 @@ static void fan_resume(void)
 		return;
 	}
 	if (do_set) {
-		printk(TPACPI_NOTICE
-			"restoring fan level to 0x%02x\n",
-			fan_control_resume_level);
+		pr_notice("restoring fan level to 0x%02x\n",
+			  fan_control_resume_level);
 		rc = fan_set_level_safe(fan_control_resume_level);
 		if (rc < 0)
-			printk(TPACPI_NOTICE
-				"failed to restore fan level: %d\n", rc);
+			pr_notice("failed to restore fan level: %d\n", rc);
 	}
 }
 
@@ -8303,8 +8218,8 @@ static int fan_write_cmd_level(const char *cmd, int *rc)
 
 	*rc = fan_set_level_safe(level);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "level command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("level command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set level to %d\n", level);
@@ -8319,8 +8234,8 @@ static int fan_write_cmd_enable(const char *cmd, int *rc)
 
 	*rc = fan_set_enable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "enable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("enable command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "enable\n");
 
@@ -8334,8 +8249,8 @@ static int fan_write_cmd_disable(const char *cmd, int *rc)
 
 	*rc = fan_set_disable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "disable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("disable command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "disable\n");
 
@@ -8354,8 +8269,8 @@ static int fan_write_cmd_speed(const char *cmd, int *rc)
 
 	*rc = fan_set_speed(speed);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "speed command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("speed command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set speed to %d\n", speed);
@@ -8558,8 +8473,8 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		if (ibm->acpi->notify) {
 			ret = setup_acpi_notify(ibm);
 			if (ret == -ENODEV) {
-				printk(TPACPI_NOTICE "disabling subdriver %s\n",
-					ibm->name);
+				pr_notice("disabling subdriver %s\n",
+					  ibm->name);
 				ret = 0;
 				goto err_out;
 			}
@@ -8581,8 +8496,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		entry = proc_create_data(ibm->name, mode, proc_dir,
 					 &dispatch_proc_fops, ibm);
 		if (!entry) {
-			printk(TPACPI_ERR "unable to create proc entry %s\n",
-			       ibm->name);
+			pr_err("unable to create proc entry %s\n", ibm->name);
 			ret = -ENODEV;
 			goto err_out;
 		}
@@ -8682,13 +8596,11 @@ static int __must_check __init get_thinkpad_model_data(
 				tp->ec_release = (ec_fw_string[4] << 8)
 						| ec_fw_string[5];
 			} else {
-				printk(TPACPI_NOTICE
-					"ThinkPad firmware release %s "
-					"doesn't match the known patterns\n",
-					ec_fw_string);
-				printk(TPACPI_NOTICE
-					"please report this to %s\n",
-					TPACPI_MAIL);
+				pr_notice("ThinkPad firmware release %s "
+					  "doesn't match the known patterns\n",
+					  ec_fw_string);
+				pr_notice("please report this to %s\n",
+					  TPACPI_MAIL);
 			}
 			break;
 		}
@@ -8732,8 +8644,7 @@ static int __init probe_for_thinkpad(void)
 	tpacpi_acpi_handle_locate("ec", TPACPI_ACPI_EC_HID, &ec_handle);
 	if (!ec_handle) {
 		if (is_thinkpad)
-			printk(TPACPI_ERR
-				"Not yet supported ThinkPad detected!\n");
+			pr_err("Not yet supported ThinkPad detected!\n");
 		return -ENODEV;
 	}
 
@@ -8745,10 +8656,10 @@ static int __init probe_for_thinkpad(void)
 
 static void __init thinkpad_acpi_init_banner(void)
 {
-	printk(TPACPI_INFO "%s v%s\n", TPACPI_DESC, TPACPI_VERSION);
-	printk(TPACPI_INFO "%s\n", TPACPI_URL);
+	pr_info("%s v%s\n", TPACPI_DESC, TPACPI_VERSION);
+	pr_info("%s\n", TPACPI_URL);
 
-	printk(TPACPI_INFO "ThinkPad BIOS %s, EC %s\n",
+	pr_info("ThinkPad BIOS %s, EC %s\n",
 		(thinkpad_id.bios_version_str) ?
 			thinkpad_id.bios_version_str : "unknown",
 		(thinkpad_id.ec_version_str) ?
@@ -8757,7 +8668,7 @@ static void __init thinkpad_acpi_init_banner(void)
 	BUG_ON(!thinkpad_id.vendor);
 
 	if (thinkpad_id.model_str)
-		printk(TPACPI_INFO "%s %s, model %s\n",
+		pr_info("%s %s, model %s\n",
 			(thinkpad_id.vendor == PCI_VENDOR_ID_IBM) ?
 				"IBM" : ((thinkpad_id.vendor ==
 						PCI_VENDOR_ID_LENOVO) ?
@@ -9023,8 +8934,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = get_thinkpad_model_data(&thinkpad_id);
 	if (ret) {
-		printk(TPACPI_ERR
-			"unable to get DMI data: %d\n", ret);
+		pr_err("unable to get DMI data: %d\n", ret);
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9050,16 +8960,14 @@ static int __init thinkpad_acpi_module_init(void)
 
 	proc_dir = proc_mkdir(TPACPI_PROC_DIR, acpi_root_dir);
 	if (!proc_dir) {
-		printk(TPACPI_ERR
-		       "unable to create proc dir " TPACPI_PROC_DIR);
+		pr_err("unable to create proc dir " TPACPI_PROC_DIR "\n");
 		thinkpad_acpi_module_exit();
 		return -ENODEV;
 	}
 
 	ret = platform_driver_register(&tpacpi_pdriver);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to register main platform driver\n");
+		pr_err("unable to register main platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9067,8 +8975,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = platform_driver_register(&tpacpi_hwmon_pdriver);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to register hwmon platform driver\n");
+		pr_err("unable to register hwmon platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9081,8 +8988,7 @@ static int __init thinkpad_acpi_module_init(void)
 					&tpacpi_hwmon_pdriver.driver);
 	}
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to create sysfs driver attributes\n");
+		pr_err("unable to create sysfs driver attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9095,7 +9001,7 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_pdev)) {
 		ret = PTR_ERR(tpacpi_pdev);
 		tpacpi_pdev = NULL;
-		printk(TPACPI_ERR "unable to register platform device\n");
+		pr_err("unable to register platform device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9105,16 +9011,14 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_sensors_pdev)) {
 		ret = PTR_ERR(tpacpi_sensors_pdev);
 		tpacpi_sensors_pdev = NULL;
-		printk(TPACPI_ERR
-		       "unable to register hwmon platform device\n");
+		pr_err("unable to register hwmon platform device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
 	ret = device_create_file(&tpacpi_sensors_pdev->dev,
 				 &dev_attr_thinkpad_acpi_pdev_name);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to create sysfs hwmon device attributes\n");
+		pr_err("unable to create sysfs hwmon device attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9123,14 +9027,14 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_hwmon)) {
 		ret = PTR_ERR(tpacpi_hwmon);
 		tpacpi_hwmon = NULL;
-		printk(TPACPI_ERR "unable to register hwmon device\n");
+		pr_err("unable to register hwmon device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
 	mutex_init(&tpacpi_inputdev_send_mutex);
 	tpacpi_inputdev = input_allocate_device();
 	if (!tpacpi_inputdev) {
-		printk(TPACPI_ERR "unable to allocate input device\n");
+		pr_err("unable to allocate input device\n");
 		thinkpad_acpi_module_exit();
 		return -ENOMEM;
 	} else {
@@ -9162,7 +9066,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = input_register_device(tpacpi_inputdev);
 	if (ret < 0) {
-		printk(TPACPI_ERR "unable to register input device\n");
+		pr_err("unable to register input device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	} else {
-- 
1.7.4.2.g597a6.dirty

