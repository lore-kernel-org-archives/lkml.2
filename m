Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1EYTkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:40:40 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3576 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1EYTki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:40:38 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Arend van Spriel" <arend@broadcom.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Arend van Spriel" <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Dan Carpenter" <error27@gmail.com>
Subject: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
Date: Wed, 25 May 2011 21:40:26 +0200
Message-ID: <1306352426-1899-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
X-WSS-ID: 61C383AC1IC11826308-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brcm80211 driver in the staging tree has a cordic function to
determine cosine and sine for a given angle. Feedback received from
John Linville suggested that these kind of functions should be made
available to others as a library function in the kernel tree.

V1:
- code taken from brcm80211 driver and added kernel-doc comments.
- code compiled and tested for x86 architecture using brcm80211 driver.
- code compiled for x86_64, ARM, and MIPS architectures.

Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dan Carpenter <error27@gmail.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/linux/cordic.h |   48 +++++++++++++++++++++++
 lib/Kconfig            |    7 +++
 lib/Makefile           |    2 +
 lib/cordic.c           |   99 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 156 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cordic.h
 create mode 100644 lib/cordic.c

diff --git a/include/linux/cordic.h b/include/linux/cordic.h
new file mode 100644
index 0000000..28443a6
--- /dev/null
+++ b/include/linux/cordic.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __CORDIC_H_
+#define __CORDIC_H_
+
+#include <linux/types.h>
+
+/**
+ * struct - i/q coordinate.
+ *
+ * @i: real part of coordinate (in phase).
+ * @q: imaginary part of coordinate (quadrature).
+ */
+struct cordic_iq {
+	s32 i;
+	s32 q;
+};
+
+/**
+ * cordic_calc_iq() - calculates the i/q coordinate for given angle.
+ *
+ * @theta: angle in degrees for which i/q coordinate is to be calculated.
+ * @coord: function output parameter holding the i/q coordinate.
+ *
+ * The function calculates the i/q coordinate for a given angle using
+ * cordic algorithm. The coordinate consists of a real (i) and an
+ * imaginary (q) part. The real part is essentially the cosine of the
+ * angle and the imaginary part is the sine of the angle. The returned
+ * values are scaled by 2^16 for precision. The range for theta is
+ * for -180 degrees to +180 degrees. Passed values outside this range are
+ * converted before doing the actual calculation.
+ */
+void cordic_calc_iq(s32 theta, struct cordic_iq *coord);
+
+#endif /* __CORDIC_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index ff9e5a3..5c70204 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -279,4 +279,11 @@ config AVERAGE
 
 	  If unsure, say N.
 
+config CORDIC
+	tristate "Cordic function"
+	help
+	  The option provides arithmetic function using cordic algorithm
+	  so its calculations are in fixed point. Modules can select this
+	  when they require this function. Module will be called cordic.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 704959d..9e3c1b0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -117,6 +117,8 @@ obj-$(CONFIG_AVERAGE) += average.o
 
 obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
+obj-$(CONFIG_CORDIC) += cordic.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/cordic.c b/lib/cordic.c
new file mode 100644
index 0000000..3952258
--- /dev/null
+++ b/lib/cordic.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/module.h>
+#include <linux/cordic.h>
+
+#define CORDIC_ANGLE_GEN	39797
+#define CORDIC_PRECISION_SHIFT	16
+#define	CORDIC_NUM_ITER		(CORDIC_PRECISION_SHIFT + 2)
+
+#define	FIXED(X)	((s32)((X) << CORDIC_PRECISION_SHIFT))
+#define	FLOAT(X)	(((X) >= 0) \
+		? ((((X) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1) \
+		: -((((-(X)) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1))
+
+static const s32 AtanTbl[] = {
+	2949120,
+	1740967,
+	919879,
+	466945,
+	234379,
+	117304,
+	58666,
+	29335,
+	14668,
+	7334,
+	3667,
+	1833,
+	917,
+	458,
+	229,
+	115,
+	57,
+	29
+};
+
+/*
+ * cordic_calc_iq() - calculates the i/q coordinate for given angle
+ *
+ * theta: angle in degrees for which i/q coordinate is to be calculated
+ * coord: function output parameter holding the i/q coordinate
+ */
+void cordic_calc_iq(s32 theta, struct cordic_iq *coord)
+{
+	s32 angle, valtmp;
+	unsigned iter;
+	int signx = 1;
+	int signtheta;
+
+	coord->i = CORDIC_ANGLE_GEN;
+	coord->q = 0;
+	angle = 0;
+
+	theta = FIXED(theta);
+	signtheta = (theta < 0) ? -1 : 1;
+	theta = ((theta + FIXED(180) * signtheta) % FIXED(360)) -
+		FIXED(180) * signtheta;
+
+	if (FLOAT(theta) > 90) {
+		theta -= FIXED(180);
+		signx = -1;
+	} else if (FLOAT(theta) < -90) {
+		theta += FIXED(180);
+		signx = -1;
+	}
+
+	for (iter = 0; iter < CORDIC_NUM_ITER; iter++) {
+		if (theta > angle) {
+			valtmp = coord->i - (coord->q >> iter);
+			coord->q += (coord->i >> iter);
+			angle += AtanTbl[iter];
+		} else {
+			valtmp = coord->i + (coord->q >> iter);
+			coord->q -= (coord->i >> iter);
+			angle -= AtanTbl[iter];
+		}
+		coord->i = valtmp;
+	}
+
+	coord->i *= signx;
+	coord->q *= signx;
+}
+EXPORT_SYMBOL(cordic_calc_iq);
+
+MODULE_DESCRIPTION("Cordic functions");
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.4.1


