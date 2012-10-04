Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab2JDVTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:19:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44231 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2JDVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:19:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Seth Forshee <seth.forshee@canonical.com>,
        Daniel Kurtz <djkurtz@chromium.org>, Alan Swanson <swanson@ukfsn.org>,
        Arteom <arutemus@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 47/56] Input: synaptics - adjust threshold for treating position values as negative
Date: Thu,  4 Oct 2012 14:16:08 -0700
Message-Id: <20121004211157.463834090@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 824efd37415961d38821ecbd9694e213fb2e8b32 upstream.

Commit c039450 (Input: synaptics - handle out of bounds values from the
hardware) caused any hardware reported values over 7167 to be treated as
a wrapped-around negative value. It turns out that some firmware uses
the value 8176 to indicate a finger near the edge of the touchpad whose
actual position cannot be determined. This value now gets treated as
negative, which can cause pointer jumps and broken edge scrolling on
these machines.

I only know of one touchpad which reports negative values, and this
hardware never reports any value lower than -8 (i.e. 8184). Moving the
threshold for treating a value as negative up to 8176 should work fine
then for any hardware we currently know about, and since we're dealing
with unspecified behavior it's probably the best we can do. The special
8176 value is also likely to result in sudden jumps in position, so
let's also clamp this to the maximum specified value for the axis.

BugLink: http://bugs.launchpad.net/bugs/1046512
https://bugzilla.kernel.org/show_bug.cgi?id=46371

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
Tested-by: Alan Swanson <swanson@ukfsn.org>
Tested-by: Arteom <arutemus@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -53,14 +53,19 @@
 #define ABS_POS_BITS 13
 
 /*
- * Any position values from the hardware above the following limits are
- * treated as "wrapped around negative" values that have been truncated to
- * the 13-bit reporting range of the hardware. These are just reasonable
- * guesses and can be adjusted if hardware is found that operates outside
- * of these parameters.
+ * These values should represent the absolute maximum value that will
+ * be reported for a positive position value. Some Synaptics firmware
+ * uses this value to indicate a finger near the edge of the touchpad
+ * whose precise position cannot be determined.
+ *
+ * At least one touchpad is known to report positions in excess of this
+ * value which are actually negative values truncated to the 13-bit
+ * reporting range. These values have never been observed to be lower
+ * than 8184 (i.e. -8), so we treat all values greater than 8176 as
+ * negative and any other value as positive.
  */
-#define X_MAX_POSITIVE (((1 << ABS_POS_BITS) + XMAX) / 2)
-#define Y_MAX_POSITIVE (((1 << ABS_POS_BITS) + YMAX) / 2)
+#define X_MAX_POSITIVE 8176
+#define Y_MAX_POSITIVE 8176
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -604,11 +609,21 @@ static int synaptics_parse_hw_state(cons
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 	}
 
-	/* Convert wrap-around values to negative */
+	/*
+	 * Convert wrap-around values to negative. (X|Y)_MAX_POSITIVE
+	 * is used by some firmware to indicate a finger at the edge of
+	 * the touchpad whose precise position cannot be determined, so
+	 * convert these values to the maximum axis value.
+	 */
 	if (hw->x > X_MAX_POSITIVE)
 		hw->x -= 1 << ABS_POS_BITS;
+	else if (hw->x == X_MAX_POSITIVE)
+		hw->x = XMAX;
+
 	if (hw->y > Y_MAX_POSITIVE)
 		hw->y -= 1 << ABS_POS_BITS;
+	else if (hw->y == Y_MAX_POSITIVE)
+		hw->y = YMAX;
 
 	return 0;
 }


