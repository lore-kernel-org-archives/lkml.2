Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2FRC0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:26:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45145 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753624Ab2FRC0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:26:08 -0400
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] thinkpad_acpi: Convert dbg_printk to tp_dbg and tp_vdbg
Date: Sun, 17 Jun 2012 19:25:12 -0700
Message-Id: <d8ab2f07efe50ddd9d3db8612c1cc333cb7e5813.1339985627.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1339985626.git.joe@perches.com>
References: <cover.1339985626.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Add #define DEBUG and use pr_debug to enable dynamic debugging.
Coalesce formats and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/thinkpad_acpi.c |  358 ++++++++++++++++------------------
 1 files changed, 165 insertions(+), 193 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 8b5610d..7744bbe 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -392,34 +392,35 @@ static bool tpacpi_uwb_emulstate;
  *  Debugging helpers
  */
 
-#define dbg_printk(a_dbg_level, format, arg...)				\
+#define DEBUG
+
+#define tp_dbg(a_dbg_level, format, ...)				\
 do {									\
 	if (dbg_level & (a_dbg_level))					\
-		printk(KERN_DEBUG pr_fmt("%s: " format),		\
-		       __func__, ##arg);				\
+		pr_debug("%s: " format, __func__, ##__VA_ARGS__);	\
 } while (0)
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUG
-#define vdbg_printk dbg_printk
+#define tp_vdbg tp_dbg
 static const char *str_supported(int is_supported);
 #else
 static inline const char *str_supported(int is_supported) { return ""; }
-#define vdbg_printk(a_dbg_level, format, arg...)	\
-	no_printk(format, ##arg)
+#define tp_vdbg(a_dbg_level, format, ...)				\
+	eliminated_printk(format, ##__VA_ARGS__)
 #endif
 
 static void tpacpi_log_usertask(const char * const what)
 {
-	printk(KERN_DEBUG pr_fmt("%s: access by process with PID %d\n"),
-	       what, task_tgid_vnr(current));
+	pr_debug("%s: access by process with PID %d\n",
+		 what, task_tgid_vnr(current));
 }
 
-#define tpacpi_disclose_usertask(what, format, arg...)			\
+#define tpacpi_disclose_usertask(what, format, ...)			\
 do {									\
 	if (unlikely((dbg_level & TPACPI_DBG_DISCLOSETASK) &&		\
 		     (tpacpi_lifecycle == TPACPI_LIFE_RUNNING))) {	\
-		printk(KERN_DEBUG pr_fmt("%s: PID %d: " format),	\
-		       what, task_tgid_vnr(current), ## arg);		\
+		pr_debug("%s: PID %d: " format,				\
+			 what, task_tgid_vnr(current), ##__VA_ARGS__);	\
 	}								\
 } while (0)
 
@@ -680,21 +681,20 @@ static void __init drv_acpi_handle_init(const char *name,
 	int i;
 	acpi_status status;
 
-	vdbg_printk(TPACPI_DBG_INIT, "trying to locate ACPI handle for %s\n",
+	tp_vdbg(TPACPI_DBG_INIT, "trying to locate ACPI handle for %s\n",
 		name);
 
 	for (i = 0; i < num_paths; i++) {
 		status = acpi_get_handle(parent, paths[i], handle);
 		if (ACPI_SUCCESS(status)) {
-			dbg_printk(TPACPI_DBG_INIT,
-				   "Found ACPI handle %s for %s\n",
-				   paths[i], name);
+			tp_dbg(TPACPI_DBG_INIT,
+			       "Found ACPI handle %s for %s\n",
+			       paths[i], name);
 			return;
 		}
 	}
 
-	vdbg_printk(TPACPI_DBG_INIT, "ACPI handle for %s not found\n",
-		    name);
+	tp_vdbg(TPACPI_DBG_INIT, "ACPI handle for %s not found\n", name);
 	*handle = NULL;
 }
 
@@ -714,9 +714,9 @@ static void __init tpacpi_acpi_handle_locate(const char *name,
 	acpi_handle device_found;
 
 	BUG_ON(!name || !hid || !handle);
-	vdbg_printk(TPACPI_DBG_INIT,
-			"trying to locate ACPI handle for %s, using HID %s\n",
-			name, hid);
+	tp_vdbg(TPACPI_DBG_INIT,
+		"trying to locate ACPI handle for %s, using HID %s\n",
+		name, hid);
 
 	memset(&device_found, 0, sizeof(device_found));
 	status = acpi_get_devices(hid, tpacpi_acpi_handle_locate_callback,
@@ -726,12 +726,11 @@ static void __init tpacpi_acpi_handle_locate(const char *name,
 
 	if (ACPI_SUCCESS(status)) {
 		*handle = device_found;
-		dbg_printk(TPACPI_DBG_INIT,
-			   "Found ACPI handle for %s\n", name);
+		tp_dbg(TPACPI_DBG_INIT, "Found ACPI handle for %s\n", name);
 	} else {
-		vdbg_printk(TPACPI_DBG_INIT,
-			    "Could not locate an ACPI handle for %s: %s\n",
-			    name, acpi_format_exception(status));
+		tp_vdbg(TPACPI_DBG_INIT,
+			"Could not locate an ACPI handle for %s: %s\n",
+			name, acpi_format_exception(status));
 	}
 }
 
@@ -758,8 +757,7 @@ static int __init setup_acpi_notify(struct ibm_struct *ibm)
 	if (!*ibm->acpi->handle)
 		return 0;
 
-	vdbg_printk(TPACPI_DBG_INIT,
-		"setting up ACPI notify for %s\n", ibm->name);
+	tp_vdbg(TPACPI_DBG_INIT, "setting up ACPI notify for %s\n", ibm->name);
 
 	rc = acpi_bus_get_device(*ibm->acpi->handle, &ibm->acpi->device);
 	if (rc < 0) {
@@ -797,8 +795,8 @@ static int __init register_tpacpi_subdriver(struct ibm_struct *ibm)
 {
 	int rc;
 
-	dbg_printk(TPACPI_DBG_INIT,
-		"registering %s as an ACPI driver\n", ibm->name);
+	tp_dbg(TPACPI_DBG_INIT, "registering %s as an ACPI driver\n",
+	       ibm->name);
 
 	BUG_ON(!ibm->acpi);
 
@@ -1215,9 +1213,8 @@ static int tpacpi_rfk_hook_set_block(void *data, bool blocked)
 	struct tpacpi_rfk *tp_rfk = data;
 	int res;
 
-	dbg_printk(TPACPI_DBG_RFKILL,
-		   "request to change radio state to %s\n",
-		   blocked ? "blocked" : "unblocked");
+	tp_dbg(TPACPI_DBG_RFKILL, "request to change radio state to %s\n",
+	       blocked ? "blocked" : "unblocked");
 
 	/* try to set radio state */
 	res = (tp_rfk->ops->set_status)(blocked ?
@@ -3016,8 +3013,8 @@ static void hotkey_exit(void)
 
 	kfree(hotkey_keycode_map);
 
-	dbg_printk(TPACPI_DBG_EXIT | TPACPI_DBG_HKEY,
-		   "restoring original HKEY status and mask\n");
+	tp_dbg(TPACPI_DBG_EXIT | TPACPI_DBG_HKEY,
+	       "restoring original HKEY status and mask\n");
 	/* yes, there is a bitwise or below, we want the
 	 * functions to be called even if one of them fail */
 	if (((tp_features.hotkey_mask &&
@@ -3223,8 +3220,8 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	unsigned long quirks;
 	unsigned long keymap_id;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			"initializing hotkey subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+		"initializing hotkey subdriver\n");
 
 	BUG_ON(!tpacpi_inputdev);
 	BUG_ON(tpacpi_inputdev->open != NULL ||
@@ -3241,9 +3238,8 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	/* hotkey not supported on 570 */
 	tp_features.hotkey = hkey_handle != NULL;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-		"hotkeys are %s\n",
-		str_supported(tp_features.hotkey));
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+		"hotkeys are %s\n", str_supported(tp_features.hotkey));
 
 	if (!tp_features.hotkey)
 		return 1;
@@ -3279,7 +3275,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 			 * MHKV 0x100 in A31, R40, R40e,
 			 * T4x, X31, and later
 			 */
-			vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+			tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
 				"firmware HKEY interface version: 0x%x\n",
 				hkeyv);
 
@@ -3297,7 +3293,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 		}
 	}
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
 		"hotkey masks are %s\n",
 		str_supported(tp_features.hotkey_mask));
 
@@ -3368,8 +3364,8 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	keymap_id = tpacpi_check_quirks(tpacpi_keymap_qtable,
 					ARRAY_SIZE(tpacpi_keymap_qtable));
 	BUG_ON(keymap_id >= ARRAY_SIZE(tpacpi_keymaps));
-	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-		   "using keymap number %lu\n", keymap_id);
+	tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+	       "using keymap number %lu\n", keymap_id);
 
 	memcpy(hotkey_keycode_map, &tpacpi_keymaps[keymap_id],
 		TPACPI_HOTKEY_MAP_SIZE);
@@ -3424,13 +3420,13 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 				& ~hotkey_all_mask
 				& ~hotkey_reserved_mask;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-		    "hotkey source mask 0x%08x, polling freq %u\n",
-		    hotkey_source_mask, hotkey_poll_freq);
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+		"hotkey source mask 0x%08x, polling freq %u\n",
+		hotkey_source_mask, hotkey_poll_freq);
 #endif
 
-	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			"enabling firmware HKEY event interface...\n");
+	tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+	       "enabling firmware HKEY event interface...\n");
 	res = hotkey_status_set(true);
 	if (res) {
 		hotkey_exit();
@@ -3445,14 +3441,13 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 	}
 	hotkey_user_mask = (hotkey_acpi_mask | hotkey_source_mask)
 				& ~hotkey_reserved_mask;
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
 		"initial masks: user=0x%08x, fw=0x%08x, poll=0x%08x\n",
 		hotkey_user_mask, hotkey_acpi_mask, hotkey_source_mask);
 
-	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			"legacy ibm/hotkey event reporting over procfs %s\n",
-			(hotkey_report_mode < 2) ?
-				"enabled" : "disabled");
+	tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+	       "legacy ibm/hotkey event reporting over procfs %s\n",
+	       (hotkey_report_mode < 2) ? "enabled" : "disabled");
 
 	tpacpi_inputdev->open = &hotkey_inputdev_open;
 	tpacpi_inputdev->close = &hotkey_inputdev_close;
@@ -3936,9 +3931,8 @@ static int bluetooth_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	vdbg_printk(TPACPI_DBG_RFKILL,
-		"will attempt to %s bluetooth\n",
-		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
+	tp_vdbg(TPACPI_DBG_RFKILL, "will attempt to %s bluetooth\n",
+		state == TPACPI_RFK_RADIO_ON ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
@@ -4003,8 +3997,7 @@ static void bluetooth_shutdown(void)
 			TP_ACPI_BLTH_SAVE_STATE))
 		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else
-		vdbg_printk(TPACPI_DBG_RFKILL,
-			"bluetooth state saved to NVRAM\n");
+		tp_vdbg(TPACPI_DBG_RFKILL, "bluetooth state saved to NVRAM\n");
 }
 
 static void bluetooth_exit(void)
@@ -4022,8 +4015,8 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 	int res;
 	int status = 0;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
-			"initializing bluetooth subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+		"initializing bluetooth subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(hkey);
 
@@ -4032,10 +4025,9 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 	tp_features.bluetooth = hkey_handle &&
 	    acpi_evalf(hkey_handle, &status, "GBDC", "qd");
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
 		"bluetooth is %s, status 0x%02x\n",
-		str_supported(tp_features.bluetooth),
-		status);
+		str_supported(tp_features.bluetooth), status);
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_bluetoothemul) {
@@ -4047,8 +4039,8 @@ static int __init bluetooth_init(struct ibm_init_struct *iibm)
 	    !(status & TP_ACPI_BLUETOOTH_HWPRESENT)) {
 		/* no bluetooth hardware present in system */
 		tp_features.bluetooth = 0;
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
-			   "bluetooth hardware not installed\n");
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+		       "bluetooth hardware not installed\n");
 	}
 
 	if (!tp_features.bluetooth)
@@ -4126,9 +4118,8 @@ static int wan_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	vdbg_printk(TPACPI_DBG_RFKILL,
-		"will attempt to %s wwan\n",
-		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
+	tp_vdbg(TPACPI_DBG_RFKILL, "will attempt to %s wwan\n",
+		state == TPACPI_RFK_RADIO_ON ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
@@ -4193,8 +4184,7 @@ static void wan_shutdown(void)
 			TP_ACPI_WGSV_SAVE_STATE))
 		pr_notice("failed to save WWAN state to NVRAM\n");
 	else
-		vdbg_printk(TPACPI_DBG_RFKILL,
-			"WWAN state saved to NVRAM\n");
+		tp_vdbg(TPACPI_DBG_RFKILL, "WWAN state saved to NVRAM\n");
 }
 
 static void wan_exit(void)
@@ -4212,18 +4202,17 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 	int res;
 	int status = 0;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
-			"initializing wan subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+		"initializing wan subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(hkey);
 
 	tp_features.wan = hkey_handle &&
 	    acpi_evalf(hkey_handle, &status, "GWAN", "qd");
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
 		"wan is %s, status 0x%02x\n",
-		str_supported(tp_features.wan),
-		status);
+		str_supported(tp_features.wan), status);
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_wwanemul) {
@@ -4235,8 +4224,8 @@ static int __init wan_init(struct ibm_init_struct *iibm)
 	    !(status & TP_ACPI_WANCARD_HWPRESENT)) {
 		/* no wan hardware present in system */
 		tp_features.wan = 0;
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
-			   "wan hardware not installed\n");
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+		       "wan hardware not installed\n");
 	}
 
 	if (!tp_features.wan)
@@ -4313,9 +4302,8 @@ static int uwb_set_status(enum tpacpi_rfkill_state state)
 {
 	int status;
 
-	vdbg_printk(TPACPI_DBG_RFKILL,
-		"will attempt to %s UWB\n",
-		(state == TPACPI_RFK_RADIO_ON) ? "enable" : "disable");
+	tp_vdbg(TPACPI_DBG_RFKILL, "will attempt to %s UWB\n",
+		state == TPACPI_RFK_RADIO_ON ? "enable" : "disable");
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
@@ -4352,18 +4340,17 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 	int res;
 	int status = 0;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
-			"initializing uwb subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+		"initializing uwb subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(hkey);
 
 	tp_features.uwb = hkey_handle &&
 	    acpi_evalf(hkey_handle, &status, "GUWB", "qd");
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
 		"uwb is %s, status 0x%02x\n",
-		str_supported(tp_features.uwb),
-		status);
+		str_supported(tp_features.uwb), status);
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 	if (dbg_uwbemul) {
@@ -4375,8 +4362,7 @@ static int __init uwb_init(struct ibm_init_struct *iibm)
 	    !(status & TP_ACPI_UWB_HWPRESENT)) {
 		/* no uwb hardware present in system */
 		tp_features.uwb = 0;
-		dbg_printk(TPACPI_DBG_INIT,
-			   "uwb hardware not installed\n");
+		tp_dbg(TPACPI_DBG_INIT, "uwb hardware not installed\n");
 	}
 
 	if (!tp_features.uwb)
@@ -4444,7 +4430,7 @@ static int __init video_init(struct ibm_init_struct *iibm)
 {
 	int ivga;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing video subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing video subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(vid);
 	if (tpacpi_is_ibm())
@@ -4469,7 +4455,7 @@ static int __init video_init(struct ibm_init_struct *iibm)
 		/* all others */
 		video_supported = TPACPI_VIDEO_NEW;
 
-	vdbg_printk(TPACPI_DBG_INIT, "video is %s, mode %d\n",
+	tp_vdbg(TPACPI_DBG_INIT, "video is %s, mode %d\n",
 		str_supported(video_supported != TPACPI_VIDEO_NONE),
 		video_supported);
 
@@ -4478,8 +4464,7 @@ static int __init video_init(struct ibm_init_struct *iibm)
 
 static void video_exit(void)
 {
-	dbg_printk(TPACPI_DBG_EXIT,
-		   "restoring original video autoswitch mode\n");
+	tp_dbg(TPACPI_DBG_EXIT, "restoring original video autoswitch mode\n");
 	if (video_autosw_set(video_orig_autosw))
 		pr_err("error while trying to restore original "
 			"video autoswitch mode\n");
@@ -4835,7 +4820,7 @@ static int __init light_init(struct ibm_init_struct *iibm)
 {
 	int rc;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing light subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing light subdriver\n");
 
 	if (tpacpi_is_ibm()) {
 		TPACPI_ACPIHANDLE_INIT(ledb);
@@ -4853,7 +4838,7 @@ static int __init light_init(struct ibm_init_struct *iibm)
 		tp_features.light_status =
 			acpi_evalf(ec_handle, NULL, "KBLT", "qv");
 
-	vdbg_printk(TPACPI_DBG_INIT, "light is %s, light status is %s\n",
+	tp_vdbg(TPACPI_DBG_INIT, "light is %s, light status is %s\n",
 		str_supported(tp_features.light),
 		str_supported(tp_features.light_status));
 
@@ -4955,12 +4940,11 @@ static int __init cmos_init(struct ibm_init_struct *iibm)
 {
 	int res;
 
-	vdbg_printk(TPACPI_DBG_INIT,
-		"initializing cmos commands subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing cmos commands subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(cmos);
 
-	vdbg_printk(TPACPI_DBG_INIT, "cmos commands are %s\n",
+	tp_vdbg(TPACPI_DBG_INIT, "cmos commands are %s\n",
 		str_supported(cmos_handle != NULL));
 
 	res = device_create_file(&tpacpi_pdev->dev, &dev_attr_cmos_command);
@@ -5327,11 +5311,11 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	int rc;
 	unsigned long useful_leds;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing LED subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing LED subdriver\n");
 
 	led_supported = led_init_detect_mode();
 
-	vdbg_printk(TPACPI_DBG_INIT, "LED commands are %s, mode %d\n",
+	tp_vdbg(TPACPI_DBG_INIT, "LED commands are %s, mode %d\n",
 		str_supported(led_supported), led_supported);
 
 	if (led_supported == TPACPI_LED_NONE)
@@ -5450,11 +5434,11 @@ static int __init beep_init(struct ibm_init_struct *iibm)
 {
 	unsigned long quirks;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing beep subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing beep subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(beep);
 
-	vdbg_printk(TPACPI_DBG_INIT, "beep is %s\n",
+	tp_vdbg(TPACPI_DBG_INIT, "beep is %s\n",
 		str_supported(beep_handle != NULL));
 
 	quirks = tpacpi_check_quirks(beep_quirk_table,
@@ -5729,7 +5713,7 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 	int acpi_tmp7;
 	int res;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing thermal subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing thermal subdriver\n");
 
 	acpi_tmp7 = acpi_evalf(ec_handle, NULL, "TMP7", "qv");
 
@@ -5787,7 +5771,7 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 		thermal_read_mode = TPACPI_THERMAL_NONE;
 	}
 
-	vdbg_printk(TPACPI_DBG_INIT, "thermal is %s, mode %d\n",
+	tp_vdbg(TPACPI_DBG_INIT, "thermal is %s, mode %d\n",
 		str_supported(thermal_read_mode != TPACPI_THERMAL_NONE),
 		thermal_read_mode);
 
@@ -5932,7 +5916,7 @@ static void tpacpi_brightness_checkpoint_nvram(void)
 	if (brightness_mode != TPACPI_BRGHT_MODE_ECNVRAM)
 		return;
 
-	vdbg_printk(TPACPI_DBG_BRGHT,
+	tp_vdbg(TPACPI_DBG_BRGHT,
 		"trying to checkpoint backlight level to NVRAM...\n");
 
 	if (mutex_lock_killable(&brightness_mutex) < 0)
@@ -5950,13 +5934,13 @@ static void tpacpi_brightness_checkpoint_nvram(void)
 				TP_NVRAM_POS_LEVEL_BRIGHTNESS);
 		b_nvram |= lec;
 		nvram_write_byte(b_nvram, TP_NVRAM_ADDR_BRIGHTNESS);
-		dbg_printk(TPACPI_DBG_BRGHT,
-			   "updated NVRAM backlight level to %u (0x%02x)\n",
-			   (unsigned int) lec, (unsigned int) b_nvram);
+		tp_dbg(TPACPI_DBG_BRGHT,
+		       "updated NVRAM backlight level to %u (0x%02x)\n",
+		       (unsigned int)lec, (unsigned int)b_nvram);
 	} else
-		vdbg_printk(TPACPI_DBG_BRGHT,
-			   "NVRAM backlight level already is %u (0x%02x)\n",
-			   (unsigned int) lec, (unsigned int) b_nvram);
+		tp_vdbg(TPACPI_DBG_BRGHT,
+			"NVRAM backlight level already is %u (0x%02x)\n",
+			(unsigned int)lec, (unsigned int)b_nvram);
 
 unlock:
 	mutex_unlock(&brightness_mutex);
@@ -6031,8 +6015,7 @@ static int brightness_set(unsigned int value)
 	if (value > bright_maxlvl || value < 0)
 		return -EINVAL;
 
-	vdbg_printk(TPACPI_DBG_BRGHT,
-			"set backlight level to %d\n", value);
+	tp_vdbg(TPACPI_DBG_BRGHT, "set backlight level to %d\n", value);
 
 	res = mutex_lock_killable(&brightness_mutex);
 	if (res < 0)
@@ -6063,9 +6046,8 @@ static int brightness_update_status(struct backlight_device *bd)
 		 bd->props.power == FB_BLANK_UNBLANK) ?
 				bd->props.brightness : 0;
 
-	dbg_printk(TPACPI_DBG_BRGHT,
-			"backlight: attempt to set level to %d\n",
-			level);
+	tp_dbg(TPACPI_DBG_BRGHT, "backlight: attempt to set level to %d\n",
+	       level);
 
 	/* it is the backlight class's job (caller) to handle
 	 * EINTR and other errors properly */
@@ -6187,8 +6169,8 @@ static void __init tpacpi_detect_brightness_capabilities(void)
 {
 	unsigned int b;
 
-	vdbg_printk(TPACPI_DBG_INIT,
-		    "detecting firmware brightness interface capabilities\n");
+	tp_vdbg(TPACPI_DBG_INIT,
+		"detecting firmware brightness interface capabilities\n");
 
 	/* we could run a quirks check here (same table used by
 	 * brightness_init) if needed */
@@ -6223,7 +6205,7 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	int b;
 	unsigned long quirks;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing brightness subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing brightness subdriver\n");
 
 	mutex_init(&brightness_mutex);
 
@@ -6237,9 +6219,8 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		return 1;
 
 	if (!brightness_enable) {
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
-			   "brightness support disabled by "
-			   "module parameter\n");
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
+		       "brightness support disabled by module parameter\n");
 		return 1;
 	}
 
@@ -6276,9 +6257,9 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		else
 			brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
 
-		dbg_printk(TPACPI_DBG_BRGHT,
-			   "driver auto-selected brightness_mode=%d\n",
-			   brightness_mode);
+		tp_dbg(TPACPI_DBG_BRGHT,
+		       "driver auto-selected brightness_mode=%d\n",
+		       brightness_mode);
 	}
 
 	/* Safety */
@@ -6304,8 +6285,8 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		pr_err("Could not register backlight device\n");
 		return rc;
 	}
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
-			"brightness is supported\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
+		"brightness is supported\n");
 
 	if (quirks & TPACPI_BRGHT_Q_ASK) {
 		pr_notice("brightness: will use unverified default: "
@@ -6320,9 +6301,8 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	 * it in place just in case */
 	backlight_update_status(ibm_backlight_device);
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
-			"brightness: registering brightness hotkeys "
-			"as change notification\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
+		"brightness: registering brightness hotkeys as change notification\n");
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);
@@ -6342,8 +6322,8 @@ static void brightness_shutdown(void)
 static void brightness_exit(void)
 {
 	if (ibm_backlight_device) {
-		vdbg_printk(TPACPI_DBG_EXIT | TPACPI_DBG_BRGHT,
-			    "calling backlight_device_unregister()\n");
+		tp_vdbg(TPACPI_DBG_EXIT | TPACPI_DBG_BRGHT,
+			"calling backlight_device_unregister()\n");
 		backlight_device_unregister(ibm_backlight_device);
 	}
 
@@ -6506,7 +6486,7 @@ static void tpacpi_volume_checkpoint_nvram(void)
 	if (!volume_control_allowed)
 		return;
 
-	vdbg_printk(TPACPI_DBG_MIXER,
+	tp_vdbg(TPACPI_DBG_MIXER,
 		"trying to checkpoint mixer state to NVRAM...\n");
 
 	if (tp_features.mixer_no_level_control)
@@ -6527,13 +6507,13 @@ static void tpacpi_volume_checkpoint_nvram(void)
 		b_nvram &= ~ec_mask;
 		b_nvram |= lec;
 		nvram_write_byte(b_nvram, TP_NVRAM_ADDR_MIXER);
-		dbg_printk(TPACPI_DBG_MIXER,
-			   "updated NVRAM mixer status to 0x%02x (0x%02x)\n",
-			   (unsigned int) lec, (unsigned int) b_nvram);
+		tp_dbg(TPACPI_DBG_MIXER,
+		       "updated NVRAM mixer status to 0x%02x (0x%02x)\n",
+		       (unsigned int)lec, (unsigned int)b_nvram);
 	} else {
-		vdbg_printk(TPACPI_DBG_MIXER,
-			   "NVRAM mixer status already is 0x%02x (0x%02x)\n",
-			   (unsigned int) lec, (unsigned int) b_nvram);
+		tp_vdbg(TPACPI_DBG_MIXER,
+			"NVRAM mixer status already is 0x%02x (0x%02x)\n",
+			(unsigned int)lec, (unsigned int)b_nvram);
 	}
 
 unlock:
@@ -6549,7 +6529,7 @@ static int volume_get_status_ec(u8 *status)
 
 	*status = s;
 
-	dbg_printk(TPACPI_DBG_MIXER, "status 0x%02x\n", s);
+	tp_dbg(TPACPI_DBG_MIXER, "status 0x%02x\n", s);
 
 	return 0;
 }
@@ -6564,7 +6544,7 @@ static int volume_set_status_ec(const u8 status)
 	if (!acpi_ec_write(TP_EC_AUDIO, status))
 		return -EIO;
 
-	dbg_printk(TPACPI_DBG_MIXER, "set EC mixer to 0x%02x\n", status);
+	tp_dbg(TPACPI_DBG_MIXER, "set EC mixer to 0x%02x\n", status);
 
 	return 0;
 }
@@ -6603,8 +6583,7 @@ unlock:
 
 static int volume_alsa_set_mute(const bool mute)
 {
-	dbg_printk(TPACPI_DBG_MIXER, "ALSA: trying to %smute\n",
-		   (mute) ? "" : "un");
+	tp_dbg(TPACPI_DBG_MIXER, "ALSA: trying to %smute\n", mute ? "" : "un");
 	return __volume_set_mute_ec(mute);
 }
 
@@ -6612,8 +6591,7 @@ static int volume_set_mute(const bool mute)
 {
 	int rc;
 
-	dbg_printk(TPACPI_DBG_MIXER, "trying to %smute\n",
-		   (mute) ? "" : "un");
+	tp_dbg(TPACPI_DBG_MIXER, "trying to %smute\n", mute ? "" : "un");
 
 	rc = __volume_set_mute_ec(mute);
 	return (rc < 0) ? rc : 0;
@@ -6650,8 +6628,8 @@ unlock:
 
 static int volume_alsa_set_volume(const u8 vol)
 {
-	dbg_printk(TPACPI_DBG_MIXER,
-		   "ALSA: trying to set volume level to %hu\n", vol);
+	tp_dbg(TPACPI_DBG_MIXER,
+	       "ALSA: trying to set volume level to %hu\n", vol);
 	return __volume_set_volume_ec(vol);
 }
 
@@ -6879,7 +6857,7 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	unsigned long quirks;
 	int rc;
 
-	vdbg_printk(TPACPI_DBG_INIT, "initializing volume subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT, "initializing volume subdriver\n");
 
 	mutex_init(&volume_mutex);
 
@@ -6905,9 +6883,8 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	 * When disabled, don't install the subdriver at all
 	 */
 	if (!alsa_enable) {
-		vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
-			    "ALSA mixer disabled by parameter, "
-			    "not loading volume subdriver...\n");
+		tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+			"ALSA mixer disabled by parameter, not loading volume subdriver...\n");
 		return 1;
 	}
 
@@ -6934,26 +6911,26 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	}
 
 	if (volume_capabilities != TPACPI_VOL_CAP_AUTO)
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
-				"using user-supplied volume_capabilities=%d\n",
-				volume_capabilities);
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+		       "using user-supplied volume_capabilities=%d\n",
+		       volume_capabilities);
 
 	if (volume_mode == TPACPI_VOL_MODE_AUTO ||
 	    volume_mode == TPACPI_VOL_MODE_MAX) {
 		volume_mode = TPACPI_VOL_MODE_ECNVRAM;
 
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
-				"driver auto-selected volume_mode=%d\n",
-				volume_mode);
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+		       "driver auto-selected volume_mode=%d\n",
+		       volume_mode);
 	} else {
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
-				"using user-supplied volume_mode=%d\n",
-				volume_mode);
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+		       "using user-supplied volume_mode=%d\n",
+		       volume_mode);
 	}
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
-			"mute is supported, volume control is %s\n",
-			str_supported(!tp_features.mixer_no_level_control));
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+		"mute is supported, volume control is %s\n",
+		str_supported(!tp_features.mixer_no_level_control));
 
 	rc = volume_create_alsa_mixer();
 	if (rc) {
@@ -6966,7 +6943,7 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 			"override (read/write)" :
 			"monitor (read only)");
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
 		"registering volume hotkeys as change notification\n");
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 			| TP_ACPI_HKEY_VOLUP_MASK
@@ -7523,7 +7500,7 @@ static int fan_set_level(int level)
 		return -ENXIO;
 	}
 
-	vdbg_printk(TPACPI_DBG_FAN,
+	tp_vdbg(TPACPI_DBG_FAN,
 		"fan control: set fan control register to 0x%02x\n", level);
 	return 0;
 }
@@ -7604,9 +7581,8 @@ static int fan_set_enable(void)
 	mutex_unlock(&fan_mutex);
 
 	if (!rc)
-		vdbg_printk(TPACPI_DBG_FAN,
-			"fan control: set fan control register to 0x%02x\n",
-			s);
+		tp_vdbg(TPACPI_DBG_FAN,
+			"fan control: set fan control register to 0x%02x\n", s);
 	return rc;
 }
 
@@ -7644,7 +7620,7 @@ static int fan_set_disable(void)
 	}
 
 	if (!rc)
-		vdbg_printk(TPACPI_DBG_FAN,
+		tp_vdbg(TPACPI_DBG_FAN,
 			"fan control: set fan control register to 0\n");
 
 	mutex_unlock(&fan_mutex);
@@ -7980,8 +7956,8 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 	int rc;
 	unsigned long quirks;
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
-			"initializing fan subdriver\n");
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
+		"initializing fan subdriver\n");
 
 	mutex_init(&fan_mutex);
 	fan_status_access_mode = TPACPI_FAN_NONE;
@@ -8014,8 +7990,8 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 				fan_quirk1_setup();
 			if (quirks & TPACPI_FAN_2FAN) {
 				tp_features.second_fan = 1;
-				dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
-					"secondary fan support enabled\n");
+				tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
+				       "secondary fan support enabled\n");
 			}
 		} else {
 			pr_err("ThinkPad ACPI EC access misbehaving, "
@@ -8051,18 +8027,18 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 		}
 	}
 
-	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
+	tp_vdbg(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
 		"fan is %s, modes %d, %d\n",
 		str_supported(fan_status_access_mode != TPACPI_FAN_NONE ||
-		  fan_control_access_mode != TPACPI_FAN_WR_NONE),
+			      fan_control_access_mode != TPACPI_FAN_WR_NONE),
 		fan_status_access_mode, fan_control_access_mode);
 
 	/* fan control master switch */
 	if (!fan_control_allowed) {
 		fan_control_access_mode = TPACPI_FAN_WR_NONE;
 		fan_control_commands = 0;
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
-			   "fan control features disabled by parameter\n");
+		tp_dbg(TPACPI_DBG_INIT | TPACPI_DBG_FAN,
+		       "fan control features disabled by parameter\n");
 	}
 
 	/* update fan_control_desired_level */
@@ -8095,8 +8071,8 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 
 static void fan_exit(void)
 {
-	vdbg_printk(TPACPI_DBG_EXIT | TPACPI_DBG_FAN,
-		    "cancelling any pending fan watchdog tasks\n");
+	tp_vdbg(TPACPI_DBG_EXIT | TPACPI_DBG_FAN,
+		"cancelling any pending fan watchdog tasks\n");
 
 	/* FIXME: can we really do this unconditionally? */
 	sysfs_remove_group(&tpacpi_sensors_pdev->dev.kobj, &fan_attr_group);
@@ -8450,13 +8426,13 @@ static const char * __init str_supported(int is_supported)
 
 static void ibm_exit(struct ibm_struct *ibm)
 {
-	dbg_printk(TPACPI_DBG_EXIT, "removing %s\n", ibm->name);
+	tp_dbg(TPACPI_DBG_EXIT, "removing %s\n", ibm->name);
 
 	list_del_init(&ibm->all_drivers);
 
 	if (ibm->flags.acpi_notify_installed) {
-		dbg_printk(TPACPI_DBG_EXIT,
-			"%s: acpi_remove_notify_handler\n", ibm->name);
+		tp_dbg(TPACPI_DBG_EXIT,
+		       "%s: acpi_remove_notify_handler\n", ibm->name);
 		BUG_ON(!ibm->acpi);
 		acpi_remove_notify_handler(*ibm->acpi->handle,
 					   ibm->acpi->type,
@@ -8465,15 +8441,14 @@ static void ibm_exit(struct ibm_struct *ibm)
 	}
 
 	if (ibm->flags.proc_created) {
-		dbg_printk(TPACPI_DBG_EXIT,
-			"%s: remove_proc_entry\n", ibm->name);
+		tp_dbg(TPACPI_DBG_EXIT, "%s: remove_proc_entry\n", ibm->name);
 		remove_proc_entry(ibm->name, proc_dir);
 		ibm->flags.proc_created = 0;
 	}
 
 	if (ibm->flags.acpi_driver_registered) {
-		dbg_printk(TPACPI_DBG_EXIT,
-			"%s: acpi_bus_unregister_driver\n", ibm->name);
+		tp_dbg(TPACPI_DBG_EXIT,
+		       "%s: acpi_bus_unregister_driver\n", ibm->name);
 		BUG_ON(!ibm->acpi);
 		acpi_bus_unregister_driver(ibm->acpi->driver);
 		kfree(ibm->acpi->driver);
@@ -8486,7 +8461,7 @@ static void ibm_exit(struct ibm_struct *ibm)
 		ibm->flags.init_called = 0;
 	}
 
-	dbg_printk(TPACPI_DBG_INIT, "finished removing %s\n", ibm->name);
+	tp_dbg(TPACPI_DBG_INIT, "finished removing %s\n", ibm->name);
 }
 
 static int __init ibm_init(struct ibm_init_struct *iibm)
@@ -8502,8 +8477,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 	if (ibm->flags.experimental && !experimental)
 		return 0;
 
-	dbg_printk(TPACPI_DBG_INIT,
-		"probing for %s\n", ibm->name);
+	tp_dbg(TPACPI_DBG_INIT, "probing for %s\n", ibm->name);
 
 	if (iibm->init) {
 		ret = iibm->init(iibm);
@@ -8535,8 +8509,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		}
 	}
 
-	dbg_printk(TPACPI_DBG_INIT,
-		"%s installed\n", ibm->name);
+	tp_dbg(TPACPI_DBG_INIT, "%s installed\n", ibm->name);
 
 	if (ibm->read) {
 		umode_t mode = iibm->base_procfs_mode;
@@ -8560,9 +8533,8 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 	return 0;
 
 err_out:
-	dbg_printk(TPACPI_DBG_INIT,
-		"%s: at error exit path with result %d\n",
-		ibm->name, ret);
+	tp_dbg(TPACPI_DBG_INIT, "%s: at error exit path with result %d\n",
+	       ibm->name, ret);
 
 	ibm_exit(ibm);
 	return (ret < 0)? ret : 0;
@@ -8928,7 +8900,7 @@ static void thinkpad_acpi_module_exit(void)
 		ibm_exit(ibm);
 	}
 
-	dbg_printk(TPACPI_DBG_INIT, "finished subdriver exit path...\n");
+	tp_dbg(TPACPI_DBG_INIT, "finished subdriver exit path...\n");
 
 	if (tpacpi_inputdev) {
 		if (tp_features.input_device_registered)
-- 
1.7.8.111.gad25c.dirty

