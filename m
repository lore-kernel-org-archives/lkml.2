Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab0G3Rur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:50:47 -0400
Received: from kroah.org ([198.145.64.141]:35981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab0G3Rf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:11 2010
Message-Id: <20100730173110.930968227@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [091/140] Input: twl40300-keypad - fix handling of "all ground" rows
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 3fea60261e73dbf4a51130d40cafcc8465b0f2c3 upstream.

The Nokia RX51 board code (arch/arm/mach-omap2/board-rx51-peripherals.c)
defines a key map for the matrix keypad keyboard. The hardware seems to
use all of the 8 rows and 8 columns of the keypad, although not all
possible locations are used.

The TWL4030 supports keypads with at most 8 rows and 8 columns. Most keys
are defined with a row and column number between 0 and 7, except

        KEY(0xff, 2, KEY_F9),
        KEY(0xff, 4, KEY_F10),
        KEY(0xff, 5, KEY_F11),

which represent keycodes that should be emitted when entire row is
connected to the ground.  since the driver handles this case as if we
had an extra column in the key matrix. Unfortunately we do not allocate
enough space and end up owerwriting some random memory.

Reported-and-tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   17 ++++++++++++++---
 drivers/input/keyboard/twl4030_keypad.c      |   17 +++++++++++------
 2 files changed, 25 insertions(+), 9 deletions(-)

--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -147,6 +147,10 @@ static void __init rx51_add_gpio_keys(vo
 #endif /* CONFIG_KEYBOARD_GPIO || CONFIG_KEYBOARD_GPIO_MODULE */
 
 static int board_keymap[] = {
+	/*
+	 * Note that KEY(x, 8, KEY_XXX) entries represent "entrire row
+	 * connected to the ground" matrix state.
+	 */
 	KEY(0, 0, KEY_Q),
 	KEY(0, 1, KEY_O),
 	KEY(0, 2, KEY_P),
@@ -154,6 +158,7 @@ static int board_keymap[] = {
 	KEY(0, 4, KEY_BACKSPACE),
 	KEY(0, 6, KEY_A),
 	KEY(0, 7, KEY_S),
+
 	KEY(1, 0, KEY_W),
 	KEY(1, 1, KEY_D),
 	KEY(1, 2, KEY_F),
@@ -162,6 +167,7 @@ static int board_keymap[] = {
 	KEY(1, 5, KEY_J),
 	KEY(1, 6, KEY_K),
 	KEY(1, 7, KEY_L),
+
 	KEY(2, 0, KEY_E),
 	KEY(2, 1, KEY_DOT),
 	KEY(2, 2, KEY_UP),
@@ -169,6 +175,8 @@ static int board_keymap[] = {
 	KEY(2, 5, KEY_Z),
 	KEY(2, 6, KEY_X),
 	KEY(2, 7, KEY_C),
+	KEY(2, 8, KEY_F9),
+
 	KEY(3, 0, KEY_R),
 	KEY(3, 1, KEY_V),
 	KEY(3, 2, KEY_B),
@@ -177,20 +185,23 @@ static int board_keymap[] = {
 	KEY(3, 5, KEY_SPACE),
 	KEY(3, 6, KEY_SPACE),
 	KEY(3, 7, KEY_LEFT),
+
 	KEY(4, 0, KEY_T),
 	KEY(4, 1, KEY_DOWN),
 	KEY(4, 2, KEY_RIGHT),
 	KEY(4, 4, KEY_LEFTCTRL),
 	KEY(4, 5, KEY_RIGHTALT),
 	KEY(4, 6, KEY_LEFTSHIFT),
+	KEY(4, 8, KEY_10),
+
 	KEY(5, 0, KEY_Y),
+	KEY(5, 8, KEY_11),
+
 	KEY(6, 0, KEY_U),
+
 	KEY(7, 0, KEY_I),
 	KEY(7, 1, KEY_F7),
 	KEY(7, 2, KEY_F8),
-	KEY(0xff, 2, KEY_F9),
-	KEY(0xff, 4, KEY_F10),
-	KEY(0xff, 5, KEY_F11),
 };
 
 static struct matrix_keymap_data board_map_data = {
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -50,8 +50,12 @@
  */
 #define TWL4030_MAX_ROWS	8	/* TWL4030 hard limit */
 #define TWL4030_MAX_COLS	8
-#define TWL4030_ROW_SHIFT	3
-#define TWL4030_KEYMAP_SIZE	(TWL4030_MAX_ROWS * TWL4030_MAX_COLS)
+/*
+ * Note that we add space for an extra column so that we can handle
+ * row lines connected to the gnd (see twl4030_col_xlate()).
+ */
+#define TWL4030_ROW_SHIFT	4
+#define TWL4030_KEYMAP_SIZE	(TWL4030_MAX_ROWS << TWL4030_ROW_SHIFT)
 
 struct twl4030_keypad {
 	unsigned short	keymap[TWL4030_KEYMAP_SIZE];
@@ -181,7 +185,7 @@ static int twl4030_read_kp_matrix_state(
 	return ret;
 }
 
-static int twl4030_is_in_ghost_state(struct twl4030_keypad *kp, u16 *key_state)
+static bool twl4030_is_in_ghost_state(struct twl4030_keypad *kp, u16 *key_state)
 {
 	int i;
 	u16 check = 0;
@@ -190,12 +194,12 @@ static int twl4030_is_in_ghost_state(str
 		u16 col = key_state[i];
 
 		if ((col & check) && hweight16(col) > 1)
-			return 1;
+			return true;
 
 		check |= col;
 	}
 
-	return 0;
+	return false;
 }
 
 static void twl4030_kp_scan(struct twl4030_keypad *kp, bool release_all)
@@ -224,7 +228,8 @@ static void twl4030_kp_scan(struct twl40
 		if (!changed)
 			continue;
 
-		for (col = 0; col < kp->n_cols; col++) {
+		/* Extra column handles "all gnd" rows */
+		for (col = 0; col < kp->n_cols + 1; col++) {
 			int code;
 
 			if (!(changed & (1 << col)))


