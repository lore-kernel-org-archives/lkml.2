Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2HMUXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:23:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2HMUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Forshee <seth.forshee@canonical.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 45/82] Input: synaptics - handle out of bounds values from the hardware
Date: Mon, 13 Aug 2012 13:19:21 -0700
Message-Id: <20120813201750.393562641@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit c0394506e69b37c47d391c2a7bbea3ea236d8ec8 upstream.

The touchpad on the Acer Aspire One D250 will report out of range values
in the extreme lower portion of the touchpad. These appear as abrupt
changes in the values reported by the hardware from very low values to
very high values, which can cause unexpected vertical jumps in the
position of the mouse pointer.

What seems to be happening is that the value is wrapping to a two's
compliment negative value of higher resolution than the 13-bit value
reported by the hardware, with the high-order bits being truncated. This
patch adds handling for these values by converting them to the
appropriate negative values.

The only tricky part about this is deciding when to treat a number as
negative. It stands to reason that if out of range values can be
reported on the low end then it could also happen on the high end, so
not all out of range values should be treated as negative. The approach
taken here is to split the difference between the maximum legitimate
value for the axis and the maximum possible value that the hardware can
report, treating values greater than this number as negative and all
other values as positive. This can be tweaked later if hardware is found
that operates outside of these parameters.

BugLink: http://bugs.launchpad.net/bugs/1001251
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -40,11 +40,27 @@
  * Note that newer firmware allows querying device for maximum useable
  * coordinates.
  */
+#define XMIN 0
+#define XMAX 6143
+#define YMIN 0
+#define YMAX 6143
 #define XMIN_NOMINAL 1472
 #define XMAX_NOMINAL 5472
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+/* Size in bits of absolute position values reported by the hardware */
+#define ABS_POS_BITS 13
+
+/*
+ * Any position values from the hardware above the following limits are
+ * treated as "wrapped around negative" values that have been truncated to
+ * the 13-bit reporting range of the hardware. These are just reasonable
+ * guesses and can be adjusted if hardware is found that operates outside
+ * of these parameters.
+ */
+#define X_MAX_POSITIVE (((1 << ABS_POS_BITS) + XMAX) / 2)
+#define Y_MAX_POSITIVE (((1 << ABS_POS_BITS) + YMAX) / 2)
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -555,6 +571,12 @@ static int synaptics_parse_hw_state(cons
 		hw->right = (buf[0] & 0x02) ? 1 : 0;
 	}
 
+	/* Convert wrap-around values to negative */
+	if (hw->x > X_MAX_POSITIVE)
+		hw->x -= 1 << ABS_POS_BITS;
+	if (hw->y > Y_MAX_POSITIVE)
+		hw->y -= 1 << ABS_POS_BITS;
+
 	return 0;
 }
 


