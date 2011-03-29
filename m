Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1C2WWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:42 -0400
Received: from mail.perches.com ([173.55.12.10]:4386 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1C2WWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:39 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/23] thinkpad_acpi: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:50 -0700
Message-Id: <fa217d39b5969d81ef97e9c0d91177fe827fd969.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Removed local TPACPI_<level> #defines, convert to pr_<level>.
Neaten dbg_<foo> macros.
Added a few missing newlines to logging messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/thinkpad_acpi.c |  471 ++++++++++++++--------------------
 1 files changed, 187 insertions(+), 284 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index a08561f..f6e6e0b 100644
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
@@ -388,34 +379,35 @@ static int tpacpi_uwb_emulstate;
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
@@ -562,7 +554,7 @@ static int acpi_evalf(acpi_handle handle,
 	int quiet;
 
 	if (!*fmt) {
-		printk(TPACPI_ERR "acpi_evalf() called with empty format\n");
+		pr_err("acpi_evalf() called with empty format\n");
 		return 0;
 	}
 
@@ -587,7 +579,7 @@ static int acpi_evalf(acpi_handle handle,
 			break;
 			/* add more types as needed */
 		default:
-			printk(TPACPI_ERR "acpi_evalf() called "
+			pr_err("acpi_evalf() called "
 			       "with invalid format character '%c'\n", c);
 			va_end(ap);
 			return 0;
@@ -616,13 +608,13 @@ static int acpi_evalf(acpi_handle handle,
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
@@ -766,8 +758,7 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 
 	rc = acpi_bus_get_device(*ibm->acpi->handle, &ibm->acpi->device);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_get_device(%s) failed: %d\n",
-			ibm->name, rc);
+		pr_err("acpi_bus_get_device(%s) failed: %d\n", ibm->name, rc);
 		return -ENODEV;
 	}
 
@@ -780,12 +771,10 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
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
@@ -810,8 +799,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	ibm->acpi->driver = kzalloc(sizeof(struct acpi_driver), GFP_KERNEL);
 	if (!ibm->acpi->driver) {
-		printk(TPACPI_ERR
-		       "failed to allocate memory for ibm->acpi->driver\n");
+		pr_err("failed to allocate memory for ibm->acpi->driver\n");
 		return -ENOMEM;
 	}
 
@@ -822,7 +810,7 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 
 	rc = acpi_bus_register_driver(ibm->acpi->driver);
 	if (rc < 0) {
-		printk(TPACPI_ERR "acpi_bus_register_driver(%s) failed: %d\n",
+		pr_err("acpi_bus_register_driver(%s) failed: %d\n",
 		       ibm->name, rc);
 		kfree(ibm->acpi->driver);
 		ibm->acpi->driver = NULL;
@@ -1080,15 +1068,14 @@ static int parse_strtoul(const char *buf,
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
@@ -1263,8 +1250,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 						&tpacpi_rfk_rfkill_ops,
 						atp_rfk);
 	if (!atp_rfk || !atp_rfk->rfkill) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for rfkill class\n");
+		pr_err("failed to allocate memory for rfkill class\n");
 		kfree(atp_rfk);
 		return -ENOMEM;
 	}
@@ -1274,9 +1260,8 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
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
@@ -1290,9 +1275,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
-		printk(TPACPI_ERR
-			"failed to register %s rfkill switch: %d\n",
-			name, res);
+		pr_err("failed to register %s rfkill switch: %d\n", name, res);
 		rfkill_destroy(atp_rfk->rfkill);
 		kfree(atp_rfk);
 		return res;
@@ -1300,7 +1283,7 @@ static int __init tpacpi_new_rfkill(const enum tpacpi_rfk_id id,
 
 	tpacpi_rfkill_switches[id] = atp_rfk;
 
-	printk(TPACPI_INFO "rfkill switch %s: radio is %sblocked\n",
+	pr_info("rfkill switch %s: radio is %sblocked\n",
 		name, (sw_state || hw_state) ? "" : "un");
 	return 0;
 }
@@ -1824,10 +1807,8 @@ static void __init tpacpi_check_outdated_fw(void)
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
@@ -2116,9 +2097,7 @@ void static hotkey_mask_warn_incomplete_mask(void)
 		(hotkey_all_mask | TPACPI_HKEY_NVRAM_KNOWN_MASK);
 
 	if (wantedmask)
-		printk(TPACPI_NOTICE
-			"required events 0x%08x not enabled!\n",
-			wantedmask);
+		pr_notice("required events 0x%08x not enabled!\n", wantedmask);
 }
 
 /*
@@ -2156,10 +2135,9 @@ static int hotkey_mask_set(u32 mask)
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
@@ -2183,13 +2161,11 @@ static int hotkey_user_mask_set(const u32 mask)
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
@@ -2573,8 +2549,7 @@ static void hotkey_poll_setup(const bool may_warn)
 					NULL, TPACPI_NVRAM_KTHREAD_NAME);
 			if (IS_ERR(tpacpi_hotkey_task)) {
 				tpacpi_hotkey_task = NULL;
-				printk(TPACPI_ERR
-				       "could not create kernel thread "
+				pr_err("could not create kernel thread "
 				       "for hotkey polling\n");
 			}
 		}
@@ -2582,11 +2557,10 @@ static void hotkey_poll_setup(const bool may_warn)
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
@@ -2810,13 +2784,13 @@ static ssize_t hotkey_source_mask_store(struct device *dev,
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
 
@@ -3047,8 +3021,7 @@ static void hotkey_exit(void)
 	if (((tp_features.hotkey_mask &&
 	      hotkey_mask_set(hotkey_orig_mask)) |
 	     hotkey_status_set(false)) != 0)
-		printk(TPACPI_ERR
-		       "failed to restore hot key mask "
+		pr_err("failed to restore hot key mask "
 		       "to BIOS defaults\n");
 }
 
@@ -3287,10 +3260,9 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
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
@@ -3303,8 +3275,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 			/* Paranoia check AND init hotkey_all_mask */
 			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
 					"MHKA", "qd")) {
-				printk(TPACPI_ERR
-				       "missing MHKA handler, "
+				pr_err("missing MHKA handler, "
 				       "please report this to %s\n",
 				       TPACPI_MAIL);
 				/* Fallback: pre-init for FN+F3,F4,F12 */
@@ -3342,16 +3313,14 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
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
@@ -3362,8 +3331,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	if (!res && acpi_evalf(hkey_handle, &status, "MHKG", "qd")) {
 		tp_features.hotkey_tablet = 1;
 		tabletsw_state = !!(status & TP_HOTKEY_TABLET_MASK);
-		printk(TPACPI_INFO
-			"possible tablet mode switch found; "
+		pr_info("possible tablet mode switch found; "
 			"ThinkPad in %s mode\n",
 			(tabletsw_state) ? "tablet" : "laptop");
 		res = add_to_attr_set(hotkey_dev_attributes,
@@ -3381,8 +3349,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
 					GFP_KERNEL);
 	if (!hotkey_keycode_map) {
-		printk(TPACPI_ERR
-			"failed to allocate memory for key map\n");
+		pr_err("failed to allocate memory for key map\n");
 		res = -ENOMEM;
 		goto err_exit;
 	}
@@ -3425,13 +3392,11 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
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
@@ -3538,8 +3503,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 
 	case TP_HKEY_EV_WKUP_S3_BATLOW: /* Battery on critical low level/S3 */
 	case TP_HKEY_EV_WKUP_S4_BATLOW: /* Battery on critical low level/S4 */
-		printk(TPACPI_ALERT
-			"EMERGENCY WAKEUP: battery almost empty\n");
+		pr_alert("EMERGENCY WAKEUP: battery almost empty\n");
 		/* how to auto-heal: */
 		/* 2313: woke up from S3, go to S4/S5 */
 		/* 2413: woke up from S4, go to S5 */
@@ -3550,9 +3514,7 @@ static bool hotkey_notify_wakeup(const u32 hkey,
 	}
 
 	if (hotkey_wakeup_reason != TP_ACPI_WAKEUP_NONE) {
-		printk(TPACPI_INFO
-		       "woke up due to a hot-unplug "
-		       "request...\n");
+		pr_info("woke up due to a hot-unplug request...\n");
 		hotkey_wakeup_reason_notify_change();
 	}
 	return true;
@@ -3604,37 +3566,31 @@ static bool hotkey_notify_thermal(const u32 hkey,
 
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
 
@@ -3651,8 +3607,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 	bool known_ev;
 
 	if (event != 0x80) {
-		printk(TPACPI_ERR
-		       "unknown HKEY notification event %d\n", event);
+		pr_err("unknown HKEY notification event %d\n", event);
 		/* forward it to userspace, maybe it knows how to handle it */
 		acpi_bus_generate_netlink_event(
 					ibm->acpi->device->pnp.device_class,
@@ -3663,7 +3618,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 
 	while (1) {
 		if (!acpi_evalf(hkey_handle, &hkey, "MHKP", "d")) {
-			printk(TPACPI_ERR "failed to retrieve HKEY event\n");
+			pr_err("failed to retrieve HKEY event\n");
 			return;
 		}
 
@@ -3691,8 +3646,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			switch (hkey) {
 			case TP_HKEY_EV_BAYEJ_ACK:
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "bay ejected\n");
+				pr_info("bay ejected\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 				break;
@@ -3708,8 +3662,7 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 			/* 0x4000-0x4FFF: dock-related wakeups */
 			if (hkey == TP_HKEY_EV_UNDOCK_ACK) {
 				hotkey_autosleep_ack = 1;
-				printk(TPACPI_INFO
-				       "undocked\n");
+				pr_info("undocked\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
 			} else {
@@ -3740,11 +3693,9 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
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
@@ -3777,8 +3728,7 @@ static void hotkey_resume(void)
 
 	if (hotkey_status_set(true) < 0 ||
 	    hotkey_mask_set(hotkey_acpi_mask) < 0)
-		printk(TPACPI_ERR
-		       "error while attempting to reset the event "
+		pr_err("error while attempting to reset the event "
 		       "firmware interface\n");
 
 	tpacpi_send_radiosw_update();
@@ -3823,14 +3773,12 @@ static void hotkey_enabledisable_warn(bool enable)
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
@@ -4009,8 +3957,7 @@ static void bluetooth_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
 			TP_ACPI_BLTH_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save bluetooth state to NVRAM\n");
+		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"bluestooth state saved to NVRAM\n");
@@ -4049,8 +3996,7 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
 		tp_features.bluetooth = 1;
-		printk(TPACPI_INFO
-			"bluetooth switch emulation enabled\n");
+		pr_info("bluetooth switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.bluetooth &&
@@ -4201,8 +4147,7 @@ static void wan_shutdown(void)
 	/* Order firmware to save current state to NVRAM */
 	if (!acpi_evalf(NULL, NULL, "\\WGSV", "vd",
 			TP_ACPI_WGSV_SAVE_STATE))
-		printk(TPACPI_NOTICE
-			"failed to save WWAN state to NVRAM\n");
+		pr_notice("failed to save WWAN state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
 			"WWAN state saved to NVRAM\n");
@@ -4239,8 +4184,7 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
 		tp_features.wan = 1;
-		printk(TPACPI_INFO
-			"wwan switch emulation enabled\n");
+		pr_info("wwan switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.wan &&
@@ -4380,8 +4324,7 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
 		tp_features.uwb = 1;
-		printk(TPACPI_INFO
-			"uwb switch emulation enabled\n");
+		pr_info("uwb switch emulation enabled\n");
 	} else
 #endif
 	if (tp_features.uwb &&
@@ -4485,7 +4428,7 @@ static void video_exit(void)
 	dbg_printk(TPACPI_DBG_EXIT,
 		   "restoring original video autoswitch mode\n");
 	if (video_autosw_set(video_orig_autosw))
-		printk(TPACPI_ERR "error while trying to restore original "
+		pr_err("error while trying to restore original "
 			"video autoswitch mode\n");
 }
 
@@ -4558,8 +4501,7 @@ static int video_outputsw_set(int status)
 		res = acpi_evalf(vid_handle, NULL,
 				 "ASWT", "vdd", status * 0x100, 0);
 		if (!autosw && video_autosw_set(autosw)) {
-			printk(TPACPI_ERR
-			       "video auto-switch left enabled due to error\n");
+			pr_err("video auto-switch left enabled due to error\n");
 			return -EIO;
 		}
 		break;
@@ -4628,8 +4570,7 @@ static int video_outputsw_cycle(void)
 		return -ENOSYS;
 	}
 	if (!autosw && video_autosw_set(autosw)) {
-		printk(TPACPI_ERR
-		       "video auto-switch left enabled due to error\n");
+		pr_err("video auto-switch left enabled due to error\n");
 		return -EIO;
 	}
 
@@ -5346,7 +5287,7 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	tpacpi_leds = kzalloc(sizeof(*tpacpi_leds) * TPACPI_LED_NUMLEDS,
 			      GFP_KERNEL);
 	if (!tpacpi_leds) {
-		printk(TPACPI_ERR "Out of memory for LED data\n");
+		pr_err("Out of memory for LED data\n");
 		return -ENOMEM;
 	}
 
@@ -5365,9 +5306,8 @@ static int __init led_init(struct ibm_init_struct *iibm)
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
@@ -5637,17 +5577,16 @@ static void thermal_dump_all_sensors(void)
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
@@ -5767,14 +5706,12 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
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
@@ -6127,8 +6064,8 @@ static int __init tpacpi_query_bcl_levels(acpi_handle handle)
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
@@ -6212,18 +6149,15 @@ static void __init tpacpi_detect_brightness_capabilities(void)
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
@@ -6258,22 +6192,19 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 
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
@@ -6317,19 +6248,17 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
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
@@ -6802,8 +6731,7 @@ static int __init volume_create_alsa_mixer(void)
 	rc = snd_card_create(alsa_index, alsa_id, THIS_MODULE,
 			    sizeof(struct tpacpi_alsa_data), &card);
 	if (rc < 0 || !card) {
-		printk(TPACPI_ERR
-			"Failed to create ALSA card structures: %d\n", rc);
+		pr_err("Failed to create ALSA card structures: %d\n", rc);
 		return 1;
 	}
 
@@ -6837,9 +6765,8 @@ static int __init volume_create_alsa_mixer(void)
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
@@ -6848,8 +6775,7 @@ static int __init volume_create_alsa_mixer(void)
 	ctl_mute = snd_ctl_new1(&volume_alsa_control_mute, NULL);
 	rc = snd_ctl_add(card, ctl_mute);
 	if (rc < 0) {
-		printk(TPACPI_ERR "Failed to create ALSA mute control: %d\n",
-			rc);
+		pr_err("Failed to create ALSA mute control: %d\n", rc);
 		goto err_exit;
 	}
 	data->ctl_mute_id = &ctl_mute->id;
@@ -6857,7 +6783,7 @@ static int __init volume_create_alsa_mixer(void)
 	snd_card_set_dev(card, &tpacpi_pdev->dev);
 	rc = snd_card_register(card);
 	if (rc < 0) {
-		printk(TPACPI_ERR "Failed to register ALSA card: %d\n", rc);
+		pr_err("Failed to register ALSA card: %d\n", rc);
 		goto err_exit;
 	}
 
@@ -6913,9 +6839,8 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 		return -EINVAL;
 
 	if (volume_mode == TPACPI_VOL_MODE_UCMS_STEP) {
-		printk(TPACPI_ERR
-			"UCMS step volume mode not implemented, "
-			"please contact %s\n", TPACPI_MAIL);
+		pr_err("UCMS step volume mode not implemented, "
+		       "please contact %s\n", TPACPI_MAIL);
 		return 1;
 	}
 
@@ -6979,13 +6904,11 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 
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
@@ -7047,12 +6970,10 @@ static int volume_write(char *buf)
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
@@ -7127,8 +7048,7 @@ static void inline volume_alsa_notify_change(void)
 
 static int __init volume_init(struct ibm_init_struct *iibm)
 {
-	printk(TPACPI_INFO
-		"volume: disabled as there is no ALSA support in this kernel\n");
+	pr_info("volume: disabled as there is no ALSA support in this kernel\n");
 
 	return 1;
 }
@@ -7335,9 +7255,8 @@ TPACPI_HANDLE(sfan, ec, "SFAN",	/* 570 */
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
@@ -7724,8 +7643,7 @@ static void fan_watchdog_reset(void)
 		if (!queue_delayed_work(tpacpi_wq, &fan_watchdog_task,
 				msecs_to_jiffies(fan_watchdog_maxinterval
 						 * 1000))) {
-			printk(TPACPI_ERR
-			       "failed to queue the fan watchdog, "
+			pr_err("failed to queue the fan watchdog, "
 			       "watchdog will not trigger\n");
 		}
 	} else
@@ -7739,11 +7657,11 @@ static void fan_watchdog_fire(struct work_struct *ignored)
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
@@ -8047,8 +7965,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 					"secondary fan support enabled\n");
 			}
 		} else {
-			printk(TPACPI_ERR
-			       "ThinkPad ACPI EC access misbehaving, "
+			pr_err("ThinkPad ACPI EC access misbehaving, "
 			       "fan status and control unavailable\n");
 			return 1;
 		}
@@ -8148,9 +8065,8 @@ static void fan_suspend(pm_message_t state)
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
@@ -8205,13 +8121,11 @@ static void fan_resume(void)
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
 
@@ -8303,8 +8217,8 @@ static int fan_write_cmd_level(const char *cmd, int *rc)
 
 	*rc = fan_set_level_safe(level);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "level command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("level command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set level to %d\n", level);
@@ -8319,8 +8233,8 @@ static int fan_write_cmd_enable(const char *cmd, int *rc)
 
 	*rc = fan_set_enable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "enable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("enable command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "enable\n");
 
@@ -8334,8 +8248,8 @@ static int fan_write_cmd_disable(const char *cmd, int *rc)
 
 	*rc = fan_set_disable();
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "disable command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("disable command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan", "disable\n");
 
@@ -8354,8 +8268,8 @@ static int fan_write_cmd_speed(const char *cmd, int *rc)
 
 	*rc = fan_set_speed(speed);
 	if (*rc == -ENXIO)
-		printk(TPACPI_ERR "speed command accepted for unsupported "
-		       "access mode %d", fan_control_access_mode);
+		pr_err("speed command accepted for unsupported access mode %d\n",
+		       fan_control_access_mode);
 	else if (!*rc)
 		tpacpi_disclose_usertask("procfs fan",
 			"set speed to %d\n", speed);
@@ -8558,8 +8472,8 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
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
@@ -8581,8 +8495,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		entry = proc_create_data(ibm->name, mode, proc_dir,
 					 &dispatch_proc_fops, ibm);
 		if (!entry) {
-			printk(TPACPI_ERR "unable to create proc entry %s\n",
-			       ibm->name);
+			pr_err("unable to create proc entry %s\n", ibm->name);
 			ret = -ENODEV;
 			goto err_out;
 		}
@@ -8682,13 +8595,11 @@ static int __must_check __init get_thinkpad_model_data(
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
@@ -8732,8 +8643,7 @@ static int __init probe_for_thinkpad(void)
 	tpacpi_acpi_handle_locate("ec", TPACPI_ACPI_EC_HID, &ec_handle);
 	if (!ec_handle) {
 		if (is_thinkpad)
-			printk(TPACPI_ERR
-				"Not yet supported ThinkPad detected!\n");
+			pr_err("Not yet supported ThinkPad detected!\n");
 		return -ENODEV;
 	}
 
@@ -8745,10 +8655,10 @@ static int __init probe_for_thinkpad(void)
 
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
@@ -8757,7 +8667,7 @@ static void __init thinkpad_acpi_init_banner(void)
 	BUG_ON(!thinkpad_id.vendor);
 
 	if (thinkpad_id.model_str)
-		printk(TPACPI_INFO "%s %s, model %s\n",
+		pr_info("%s %s, model %s\n",
 			(thinkpad_id.vendor == PCI_VENDOR_ID_IBM) ?
 				"IBM" : ((thinkpad_id.vendor ==
 						PCI_VENDOR_ID_LENOVO) ?
@@ -9023,8 +8933,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = get_thinkpad_model_data(&thinkpad_id);
 	if (ret) {
-		printk(TPACPI_ERR
-			"unable to get DMI data: %d\n", ret);
+		pr_err("unable to get DMI data: %d\n", ret);
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9050,16 +8959,14 @@ static int __init thinkpad_acpi_module_init(void)
 
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
@@ -9067,8 +8974,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = platform_driver_register(&tpacpi_hwmon_pdriver);
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to register hwmon platform driver\n");
+		pr_err("unable to register hwmon platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9081,8 +8987,7 @@ static int __init thinkpad_acpi_module_init(void)
 					&tpacpi_hwmon_pdriver.driver);
 	}
 	if (ret) {
-		printk(TPACPI_ERR
-		       "unable to create sysfs driver attributes\n");
+		pr_err("unable to create sysfs driver attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9095,7 +9000,7 @@ static int __init thinkpad_acpi_module_init(void)
 	if (IS_ERR(tpacpi_pdev)) {
 		ret = PTR_ERR(tpacpi_pdev);
 		tpacpi_pdev = NULL;
-		printk(TPACPI_ERR "unable to register platform device\n");
+		pr_err("unable to register platform device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
@@ -9105,16 +9010,14 @@ static int __init thinkpad_acpi_module_init(void)
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
@@ -9123,14 +9026,14 @@ static int __init thinkpad_acpi_module_init(void)
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
@@ -9162,7 +9065,7 @@ static int __init thinkpad_acpi_module_init(void)
 
 	ret = input_register_device(tpacpi_inputdev);
 	if (ret < 0) {
-		printk(TPACPI_ERR "unable to register input device\n");
+		pr_err("unable to register input device\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	} else {
-- 
1.7.4.2.g597a6.dirty

