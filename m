Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab1C3WOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:14:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:15008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab1C3VFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132636"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hmh@hmh.eng.br, mjg@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [3/275] thinkpad-acpi: add support for model-specific keymaps
Message-Id: <20110330210356.D4E3B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

[ upstream commit d1e14dca6a18aa40394316c872993ae3bc7e311a ]

Use the quirks engine to select model-specific keymaps, which makes
it much easier to extend should we need it.

Keycodes are based on the tables at
http://www.thinkwiki.org/wiki/Default_meanings_of_special_keys.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/thinkpad_acpi.c |   60 ++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 18 deletions(-)

Index: linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:02:58.160347243 -0700
+++ linux-2.6.35.y/drivers/platform/x86/thinkpad_acpi.c	2011-03-29 23:55:37.173515999 -0700
@@ -3093,6 +3093,8 @@
 	TPACPI_Q_IBM('1', 'D', TPACPI_HK_Q_INIMASK), /* X22, X23, X24 */
 };
 
+typedef u16 tpacpi_keymap_t[TPACPI_HOTKEY_MAP_LEN];
+
 static int __init hotkey_init(struct ibm_init_struct *iibm)
 {
 	/* Requirements for changing the default keymaps:
@@ -3124,9 +3126,17 @@
 	 * If the above is too much to ask, don't change the keymap.
 	 * Ask the thinkpad-acpi maintainer to do it, instead.
 	 */
-	static u16 ibm_keycode_map[TPACPI_HOTKEY_MAP_LEN] __initdata = {
+
+	enum keymap_index {
+		TPACPI_KEYMAP_IBM_GENERIC = 0,
+		TPACPI_KEYMAP_LENOVO_GENERIC,
+	};
+
+	static const tpacpi_keymap_t tpacpi_keymaps[] __initconst = {
+	/* Generic keymap for IBM ThinkPads */
+	[TPACPI_KEYMAP_IBM_GENERIC] = {
 		/* Scan Codes 0x00 to 0x0B: ACPI HKEY FN+F1..F12 */
-		KEY_FN_F1,	KEY_FN_F2,	KEY_COFFEE,	KEY_SLEEP,
+		KEY_FN_F1,	KEY_BATTERY,	KEY_COFFEE,	KEY_SLEEP,
 		KEY_WLAN,	KEY_FN_F6, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
 		KEY_FN_F9,	KEY_FN_F10,	KEY_FN_F11,	KEY_SUSPEND,
 
@@ -3157,8 +3167,10 @@
 		/* (assignments unknown, please report if found) */
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
-	};
-	static u16 lenovo_keycode_map[TPACPI_HOTKEY_MAP_LEN] __initdata = {
+		},
+
+	/* Generic keymap for Lenovo ThinkPads */
+	[TPACPI_KEYMAP_LENOVO_GENERIC] = {
 		/* Scan Codes 0x00 to 0x0B: ACPI HKEY FN+F1..F12 */
 		KEY_FN_F1,	KEY_COFFEE,	KEY_BATTERY,	KEY_SLEEP,
 		KEY_WLAN,	KEY_FN_F6, KEY_SWITCHVIDEOMODE, KEY_FN_F8,
@@ -3200,10 +3212,25 @@
 		/* (assignments unknown, please report if found) */
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
+		},
 	};
 
-#define TPACPI_HOTKEY_MAP_SIZE		sizeof(ibm_keycode_map)
-#define TPACPI_HOTKEY_MAP_TYPESIZE	sizeof(ibm_keycode_map[0])
+	static const struct tpacpi_quirk tpacpi_keymap_qtable[] __initconst = {
+		/* Generic maps (fallback) */
+		{
+		  .vendor = PCI_VENDOR_ID_IBM,
+		  .bios = TPACPI_MATCH_ANY, .ec = TPACPI_MATCH_ANY,
+		  .quirks = TPACPI_KEYMAP_IBM_GENERIC,
+		},
+		{
+		  .vendor = PCI_VENDOR_ID_LENOVO,
+		  .bios = TPACPI_MATCH_ANY, .ec = TPACPI_MATCH_ANY,
+		  .quirks = TPACPI_KEYMAP_LENOVO_GENERIC,
+		},
+	};
+
+#define TPACPI_HOTKEY_MAP_SIZE		sizeof(tpacpi_keymap_t)
+#define TPACPI_HOTKEY_MAP_TYPESIZE	sizeof(tpacpi_keymap_t[0])
 
 	int res, i;
 	int status;
@@ -3212,6 +3239,7 @@
 	bool tabletsw_state = false;
 
 	unsigned long quirks;
+	unsigned long keymap_id;
 
 	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
 			"initializing hotkey subdriver\n");
@@ -3352,7 +3380,6 @@
 		goto err_exit;
 
 	/* Set up key map */
-
 	hotkey_keycode_map = kmalloc(TPACPI_HOTKEY_MAP_SIZE,
 					GFP_KERNEL);
 	if (!hotkey_keycode_map) {
@@ -3362,17 +3389,14 @@
 		goto err_exit;
 	}
 
-	if (tpacpi_is_lenovo()) {
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			   "using Lenovo default hot key map\n");
-		memcpy(hotkey_keycode_map, &lenovo_keycode_map,
-			TPACPI_HOTKEY_MAP_SIZE);
-	} else {
-		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			   "using IBM default hot key map\n");
-		memcpy(hotkey_keycode_map, &ibm_keycode_map,
-			TPACPI_HOTKEY_MAP_SIZE);
-	}
+	keymap_id = tpacpi_check_quirks(tpacpi_keymap_qtable,
+					ARRAY_SIZE(tpacpi_keymap_qtable));
+	BUG_ON(keymap_id >= ARRAY_SIZE(tpacpi_keymaps));
+	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+		   "using keymap number %lu\n", keymap_id);
+
+	memcpy(hotkey_keycode_map, &tpacpi_keymaps[keymap_id],
+		TPACPI_HOTKEY_MAP_SIZE);
 
 	input_set_capability(tpacpi_inputdev, EV_MSC, MSC_SCAN);
 	tpacpi_inputdev->keycodesize = TPACPI_HOTKEY_MAP_TYPESIZE;
