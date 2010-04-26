Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0DZT3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:29:31 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51617 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 08/19] staging:iio:max1363 move to new abi.
Date: Mon, 26 Apr 2010 20:31:10 +0100
Message-Id: <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/adc/Kconfig        |    1 +
 drivers/staging/iio/adc/Makefile       |    2 +-
 drivers/staging/iio/adc/max1363.h      |  122 +++---
 drivers/staging/iio/adc/max1363_core.c |  762 +++++++++++++++++++-------------
 drivers/staging/iio/adc/max1363_ring.c |   65 ++-
 5 files changed, 548 insertions(+), 404 deletions(-)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index 3989c0c..101ea4b 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -7,6 +7,7 @@ config MAX1363
 	tristate "MAXIM max1363 ADC driver"
 	depends on I2C
 	select IIO_TRIGGER if IIO_RING_BUFFER
+	select MAX1363_RING_BUFFER
 	help
 	  Say yes here to build support for many MAXIM i2c analog to digital
 	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
diff --git a/drivers/staging/iio/adc/Makefile b/drivers/staging/iio/adc/Makefile
index 08cee5c..18c9376 100644
--- a/drivers/staging/iio/adc/Makefile
+++ b/drivers/staging/iio/adc/Makefile
@@ -3,6 +3,6 @@
 #
 
 max1363-y := max1363_core.o
-max1363-$(CONFIG_MAX1363_RING_BUFFER) += max1363_ring.o
+max1363-y += max1363_ring.o
 
 obj-$(CONFIG_MAX1363) += max1363.o
diff --git a/drivers/staging/iio/adc/max1363.h b/drivers/staging/iio/adc/max1363.h
index c112fbe..72cf367 100644
--- a/drivers/staging/iio/adc/max1363.h
+++ b/drivers/staging/iio/adc/max1363.h
@@ -72,77 +72,54 @@
  * @numvals:	The number of values returned by a single scan
  */
 struct max1363_mode {
-	const char	*name;
 	int8_t		conf;
-	int		numvals;
+	long		modemask;
 };
 
-#define MAX1363_MODE_SINGLE(_num) {					\
-		.name = #_num,						\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
+#define MAX1363_MODE_SINGLE(_num, _mask) {				\
+		.conf = MAX1363_CHANNEL_SEL(_num)			\
 			| MAX1363_CONFIG_SCAN_SINGLE_1			\
 			| MAX1363_CONFIG_SE,				\
-			.numvals = 1,					\
+			.modemask = _mask,				\
 			}
 
-#define MAX1363_MODE_SINGLE_TIMES_8(_num) {				\
-		.name = #_num"x8",					\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
-			| MAX1363_CONFIG_SCAN_SINGLE_8			\
-			| MAX1363_CONFIG_SE,				\
-			.numvals = 8,					\
-			}
-
-#define MAX1363_MODE_SCAN_TO_CHANNEL(_num) {				\
-		.name = "0..."#_num,					\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
+#define MAX1363_MODE_SCAN_TO_CHANNEL(_num, _mask) {			\
+		.conf = MAX1363_CHANNEL_SEL(_num)			\
 			| MAX1363_CONFIG_SCAN_TO_CS			\
 			| MAX1363_CONFIG_SE,				\
-			.numvals = _num + 1,				\
+			.modemask = _mask,				\
 			}
 
 
 /* note not available for max1363 hence naming */
-#define MAX1236_MODE_SCAN_MID_TO_CHANNEL(_mid, _num) {			\
-		.name = #_mid"..."#_num,				\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
+#define MAX1236_MODE_SCAN_MID_TO_CHANNEL(_mid, _num, _mask) {		\
+		.conf = MAX1363_CHANNEL_SEL(_num)			\
 			| MAX1236_SCAN_MID_TO_CHANNEL			\
 			| MAX1363_CONFIG_SE,				\
-			.numvals = _num - _mid + 1			\
+			.modemask = _mask				\
 }
 
-#define MAX1363_MODE_DIFF_SINGLE(_nump, _numm) {			\
-		.name = #_nump"-"#_numm,				\
-			.conf = MAX1363_CHANNEL_SEL(_nump)		\
+#define MAX1363_MODE_DIFF_SINGLE(_nump, _numm, _mask) {			\
+		.conf = MAX1363_CHANNEL_SEL(_nump)			\
 			| MAX1363_CONFIG_SCAN_SINGLE_1			\
 			| MAX1363_CONFIG_DE,				\
-			.numvals = 1,					\
-			}
-
-#define MAX1363_MODE_DIFF_SINGLE_TIMES_8(_nump, _numm) {		\
-		.name = #_nump"-"#_numm,				\
-			.conf = MAX1363_CHANNEL_SEL(_nump)		\
-			| MAX1363_CONFIG_SCAN_SINGLE_8			\
-			| MAX1363_CONFIG_DE,				\
-			.numvals = 1,					\
+			.modemask = _mask				\
 			}
 
 /* Can't think how to automate naming so specify for now */
-#define MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(_name, _num, _numvals) { \
-		.name = #_name,						\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
+#define MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(_num, _numvals, _mask) { \
+		.conf = MAX1363_CHANNEL_SEL(_num)			\
 			| MAX1363_CONFIG_SCAN_TO_CS			\
 			| MAX1363_CONFIG_DE,				\
-			.numvals = _numvals,				\
+			.modemask = _mask				\
 			}
 
 /* note only available for max1363 hence naming */
-#define MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(_name, _num, _numvals) { \
-    .name = #_name,							\
-			.conf = MAX1363_CHANNEL_SEL(_num)		\
+#define MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL(_num, _numvals, _mask) { \
+		.conf = MAX1363_CHANNEL_SEL(_num)			\
 			| MAX1236_SCAN_MID_TO_CHANNEL			\
 			| MAX1363_CONFIG_SE,				\
-			.numvals = _numvals,				\
+			.modemask = _mask				\
 }
 
 /* Not currently handled */
@@ -158,35 +135,43 @@ struct max1363_mode {
  * clear what all the various options actually do. Alternative suggestions
  * that don't require user to have intimate knowledge of the chip welcomed.
  */
+enum max1363_channels {
+	max1363_in0, max1363_in1, max1363_in2, max1363_in3,
+	max1363_in4, max1363_in5, max1363_in6, max1363_in7,
+	max1363_in8, max1363_in9, max1363_in10, max1363_in11,
+
+	max1363_in0min1, max1363_in2min3,
+	max1363_in4min5, max1363_in6min7,
+	max1363_in8min9, max1363_in10min11,
+
+	max1363_in1min0, max1363_in3min2,
+	max1363_in5min4, max1363_in7min6,
+	max1363_in9min8, max1363_in11min10,
+	};
 
 /* This must be maintained along side the max1363_mode_table in max1363_core */
 enum max1363_modes {
 	/* Single read of a single channel */
 	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11,
-	/* Eight reads of a single channel */
-	se0, se1, se2, se3, se4, se5, se6, se7, se8, se9, se10, se11,
-	/* Scan to channel */
-	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6,
-	s0to7, s0to8, s0to9, s0to10, s0to11,
 	/* Differential single read */
 	d0m1, d2m3, d4m5, d6m7, d8m9, d10m11,
 	d1m0, d3m2, d5m4, d7m6, d9m8, d11m10,
-	/* Differential single read 8 times */
-	de0m1, de2m3, de4m5, de6m7, de8m9, de10m11,
-	de1m0, de3m2, de5m4, de7m6, de9m8, de11m10,
-	/* Differential scan to channel */
-	d0m1to2m3, d0m1to4m5, d0m1to6m7, d0m1to8m9, d0m1to10m11,
-	d1m0to3m2, d1m0to5m4, d1m0to7m6, d1m0to9m8, d1m0to11m10,
-	/* Scan mid to channel max123{6-9} only */
-	s2to3, s6to7, s6to8, s6to9, s6to10, s6to11,
-	/* Differential scan mid to channel */
-	s6m7to8m9, s6m7to10m11, s7m6to9m8, s7m6to11m10,
+	/* Scan to channel and mid to channel where overlapping */
+	s0to1, s0to2, s2to3, s0to3, s0to4, s0to5, s0to6,
+	s6to7, s0to7, s6to8, s0to8, s6to9,
+	s0to9, s6to10, s0to10, s6to11, s0to11,
+	/* Differential scan to channel and mid to channel where overlapping */
+	d0m1to2m3, d0m1to4m5, d0m1to6m7, d6m7to8m9,
+	d0m1to8m9, d6m7to10m11, d0m1to10m11, d1m0to3m2,
+	d1m0to5m4, d1m0to7m6, d7m6to9m8, d1m0to9m8,
+	d7m6to11m10, d1m0to11m10,
 };
 
 /**
  * struct max1363_chip_info - chip specifc information
  * @name:		indentification string for chip
  * @num_inputs:		number of physical inputs on chip
+ * @bits:		accuracy of the adc in bits
  * @int_vref_mv:	the internal reference voltage
  * @monitor_mode:	whether the chip supports monitor interrupts
  * @mode_list:		array of available scan modes
@@ -196,11 +181,14 @@ enum max1363_modes {
 struct max1363_chip_info {
 	const char			*name;
 	u8				num_inputs;
+	u8				bits;
 	u16				int_vref_mv;
 	bool				monitor_mode;
 	const enum max1363_modes	*mode_list;
 	int				num_modes;
 	enum max1363_modes		default_mode;
+	struct attribute_group		*dev_attrs;
+	struct attribute_group		*scan_attrs;
 };
 
 
@@ -212,6 +200,7 @@ struct max1363_chip_info {
  * @configbyte:		cache of current device config byte
  * @chip_info:		chip model specific constants, available modes etc
  * @current_mode:	the scan mode of this chip
+ * @requestedmask:	a valid requested set of channels
  * @poll_work:		bottom half of polling interrupt handler
  * @protect_ring:	used to ensure only one polling bh running at a time
  * @reg:		supply regulator
@@ -223,16 +212,21 @@ struct max1363_state {
 	char				configbyte;
 	const struct max1363_chip_info	*chip_info;
 	const struct max1363_mode	*current_mode;
+	u32				requestedmask;
 	struct work_struct		poll_work;
 	atomic_t			protect_ring;
 	struct iio_trigger		*trig;
 	struct regulator		*reg;
 };
+
+const struct max1363_mode
+*max1363_match_mode(u32 mask, const struct max1363_chip_info *ci);
+
+int max1363_set_scan_mode(struct max1363_state *st);
+
 #ifdef CONFIG_MAX1363_RING_BUFFER
 
-ssize_t max1363_scan_from_ring(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf);
+int max1363_single_channel_from_ring(long mask, struct max1363_state *st);
 int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev);
 void max1363_ring_cleanup(struct iio_dev *indio_dev);
 
@@ -250,14 +244,12 @@ static inline int max1363_initialize_ring(struct iio_ring_buffer *ring)
 	return 0;
 };
 
-
-static inline ssize_t max1363_scan_from_ring(struct device *dev,
-					     struct device_attribute *attr,
-					     char *buf)
+int max1363_single_channel_from_ring(long mask, struct max1363_state *st)
 {
-	return 0;
+	return -EINVAL;
 };
 
+
 static inline int
 max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
 {
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 790d1cc..e82f3e7 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -1,27 +1,26 @@
  /*
- * linux/drivers/industrialio/adc/max1363.c
- * Copyright (C) 2008 Jonathan Cameron
- *
- * based on linux/drivers/i2c/chips/max123x
- * Copyright (C) 2002-2004 Stefan Eletzhofer
- *
- * based on linux/drivers/acron/char/pcf8583.c
- * Copyright (C) 2000 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * max1363.c
- *
- * Partial support for max1363 and similar chips.
- *
- * Not currently implemented.
- *
- * - Monitor interrrupt generation.
- * - Control of internal reference.
- * - Sysfs scan interface currently assumes unipolar mode.
- */
+  * iio/adc/max1363.c
+  * Copyright (C) 2008-2010 Jonathan Cameron
+  *
+  * based on linux/drivers/i2c/chips/max123x
+  * Copyright (C) 2002-2004 Stefan Eletzhofer
+  *
+  * based on linux/drivers/acron/char/pcf8583.c
+  * Copyright (C) 2000 Russell King
+  *
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License version 2 as
+  * published by the Free Software Foundation.
+  *
+  * max1363.c
+  *
+  * Partial support for max1363 and similar chips.
+  *
+  * Not currently implemented.
+  *
+  * - Monitor interrrupt generation.
+  * - Control of internal reference.
+  */
 
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
@@ -38,118 +37,318 @@
 #include "../iio.h"
 #include "../sysfs.h"
 
+#include "../ring_generic.h"
+#include "adc.h"
 #include "max1363.h"
 
-/* Available scan modes.
- * Awkwardly the associated enum is in the header so it is available to
- * the ring buffer code.
- */
-static const struct  max1363_mode max1363_mode_table[] = {
-	MAX1363_MODE_SINGLE(0),
-	MAX1363_MODE_SINGLE(1),
-	MAX1363_MODE_SINGLE(2),
-	MAX1363_MODE_SINGLE(3),
-	MAX1363_MODE_SINGLE(4),
-	MAX1363_MODE_SINGLE(5),
-	MAX1363_MODE_SINGLE(6),
-	MAX1363_MODE_SINGLE(7),
-	MAX1363_MODE_SINGLE(8),
-	MAX1363_MODE_SINGLE(9),
-	MAX1363_MODE_SINGLE(10),
-	MAX1363_MODE_SINGLE(11),
-
-	MAX1363_MODE_SINGLE_TIMES_8(0),
-	MAX1363_MODE_SINGLE_TIMES_8(1),
-	MAX1363_MODE_SINGLE_TIMES_8(2),
-	MAX1363_MODE_SINGLE_TIMES_8(3),
-	MAX1363_MODE_SINGLE_TIMES_8(4),
-	MAX1363_MODE_SINGLE_TIMES_8(5),
-	MAX1363_MODE_SINGLE_TIMES_8(6),
-	MAX1363_MODE_SINGLE_TIMES_8(7),
-	MAX1363_MODE_SINGLE_TIMES_8(8),
-	MAX1363_MODE_SINGLE_TIMES_8(9),
-	MAX1363_MODE_SINGLE_TIMES_8(10),
-	MAX1363_MODE_SINGLE_TIMES_8(11),
-
-	MAX1363_MODE_SCAN_TO_CHANNEL(1),
-	MAX1363_MODE_SCAN_TO_CHANNEL(2),
-	MAX1363_MODE_SCAN_TO_CHANNEL(3),
-	MAX1363_MODE_SCAN_TO_CHANNEL(4),
-	MAX1363_MODE_SCAN_TO_CHANNEL(5),
-	MAX1363_MODE_SCAN_TO_CHANNEL(6),
-	MAX1363_MODE_SCAN_TO_CHANNEL(7),
-	MAX1363_MODE_SCAN_TO_CHANNEL(8),
-	MAX1363_MODE_SCAN_TO_CHANNEL(9),
-	MAX1363_MODE_SCAN_TO_CHANNEL(10),
-	MAX1363_MODE_SCAN_TO_CHANNEL(11),
-
-	MAX1363_MODE_DIFF_SINGLE(0, 1),
-	MAX1363_MODE_DIFF_SINGLE(2, 3),
-	MAX1363_MODE_DIFF_SINGLE(4, 5),
-	MAX1363_MODE_DIFF_SINGLE(6, 7),
-	MAX1363_MODE_DIFF_SINGLE(8, 9),
-	MAX1363_MODE_DIFF_SINGLE(10, 11),
-	MAX1363_MODE_DIFF_SINGLE(1, 0),
-	MAX1363_MODE_DIFF_SINGLE(3, 2),
-	MAX1363_MODE_DIFF_SINGLE(5, 4),
-	MAX1363_MODE_DIFF_SINGLE(7, 6),
-	MAX1363_MODE_DIFF_SINGLE(9, 8),
-	MAX1363_MODE_DIFF_SINGLE(11, 10),
-
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(0, 1),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(2, 3),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(4, 5),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(6, 7),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(8, 9),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(10, 11),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(1, 0),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(3, 2),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(5, 4),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(7, 6),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(9, 8),
-	MAX1363_MODE_DIFF_SINGLE_TIMES_8(11, 10),
-
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...2-3, 2, 2),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...4-5, 4, 3),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...6-7, 6, 4),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...8-9, 8, 5),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...10-11, 10, 6),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...3-2, 3, 2),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...5-4, 5, 3),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...7-6, 7, 4),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...9-8, 9, 5),
-	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...11-10, 11, 6),
-
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(2, 3),
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 7),
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 8),
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 9),
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 10),
-	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 11),
-
-	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(6-7...8-9, 8, 2),
-	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(6-7...10-11, 10, 3),
-	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(7-6...9-8, 9, 2),
-	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(7-6...11-10, 11, 3),
+/* Here we claim all are 16 bits. This currently does no harm and saves
+ * us a lot of scan element listings */
+
+#define MAX1363_SCAN_EL(number)						\
+	IIO_SCAN_EL_C(in##number, number, IIO_UNSIGNED(16), 0, NULL);
+#define MAX1363_SCAN_EL_D(p, n, number)					\
+	IIO_SCAN_NAMED_EL_C(in##p##m##in##n, in##p-in##n,		\
+			number, IIO_SIGNED(16), 0 , NULL);
+
+static MAX1363_SCAN_EL(0);
+static MAX1363_SCAN_EL(1);
+static MAX1363_SCAN_EL(2);
+static MAX1363_SCAN_EL(3);
+static MAX1363_SCAN_EL(4);
+static MAX1363_SCAN_EL(5);
+static MAX1363_SCAN_EL(6);
+static MAX1363_SCAN_EL(7);
+static MAX1363_SCAN_EL(8);
+static MAX1363_SCAN_EL(9);
+static MAX1363_SCAN_EL(10);
+static MAX1363_SCAN_EL(11);
+static MAX1363_SCAN_EL_D(0, 1, 12);
+static MAX1363_SCAN_EL_D(2, 3, 13);
+static MAX1363_SCAN_EL_D(4, 5, 14);
+static MAX1363_SCAN_EL_D(6, 7, 15);
+static MAX1363_SCAN_EL_D(8, 9, 16);
+static MAX1363_SCAN_EL_D(10, 11, 17);
+static MAX1363_SCAN_EL_D(1, 0, 18);
+static MAX1363_SCAN_EL_D(3, 2, 19);
+static MAX1363_SCAN_EL_D(5, 4, 20);
+static MAX1363_SCAN_EL_D(7, 6, 21);
+static MAX1363_SCAN_EL_D(9, 8, 22);
+static MAX1363_SCAN_EL_D(11, 10, 23);
+
+static const struct max1363_mode max1363_mode_table[] = {
+	/* All of the single channel options first */
+	MAX1363_MODE_SINGLE(0, 1 << 0),
+	MAX1363_MODE_SINGLE(1, 1 << 1),
+	MAX1363_MODE_SINGLE(2, 1 << 2),
+	MAX1363_MODE_SINGLE(3, 1 << 3),
+	MAX1363_MODE_SINGLE(4, 1 << 4),
+	MAX1363_MODE_SINGLE(5, 1 << 5),
+	MAX1363_MODE_SINGLE(6, 1 << 6),
+	MAX1363_MODE_SINGLE(7, 1 << 7),
+	MAX1363_MODE_SINGLE(8, 1 << 8),
+	MAX1363_MODE_SINGLE(9, 1 << 9),
+	MAX1363_MODE_SINGLE(10, 1 << 10),
+	MAX1363_MODE_SINGLE(11, 1 << 11),
+
+	MAX1363_MODE_DIFF_SINGLE(0, 1, 1 << 12),
+	MAX1363_MODE_DIFF_SINGLE(2, 3, 1 << 13),
+	MAX1363_MODE_DIFF_SINGLE(4, 5, 1 << 14),
+	MAX1363_MODE_DIFF_SINGLE(6, 7, 1 << 15),
+	MAX1363_MODE_DIFF_SINGLE(8, 9, 1 << 16),
+	MAX1363_MODE_DIFF_SINGLE(10, 11, 1 << 17),
+	MAX1363_MODE_DIFF_SINGLE(1, 0, 1 << 18),
+	MAX1363_MODE_DIFF_SINGLE(3, 2, 1 << 19),
+	MAX1363_MODE_DIFF_SINGLE(5, 4, 1 << 20),
+	MAX1363_MODE_DIFF_SINGLE(7, 6, 1 << 21),
+	MAX1363_MODE_DIFF_SINGLE(9, 8, 1 << 22),
+	MAX1363_MODE_DIFF_SINGLE(11, 10, 1 << 23),
+
+	/* The multichannel scans next */
+	MAX1363_MODE_SCAN_TO_CHANNEL(1, 0x003),
+	MAX1363_MODE_SCAN_TO_CHANNEL(2, 0x007),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(2, 3, 0x00C),
+	MAX1363_MODE_SCAN_TO_CHANNEL(3, 0x00F),
+	MAX1363_MODE_SCAN_TO_CHANNEL(4, 0x01F),
+	MAX1363_MODE_SCAN_TO_CHANNEL(5, 0x03F),
+	MAX1363_MODE_SCAN_TO_CHANNEL(6, 0x07F),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 7, 0x0C0),
+	MAX1363_MODE_SCAN_TO_CHANNEL(7, 0x0FF),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 8, 0x1C0),
+	MAX1363_MODE_SCAN_TO_CHANNEL(8, 0x1FF),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 9, 0x3C0),
+	MAX1363_MODE_SCAN_TO_CHANNEL(9, 0x3FF),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 10, 0x7C0),
+	MAX1363_MODE_SCAN_TO_CHANNEL(10, 0x7FF),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 11, 0xFC0),
+	MAX1363_MODE_SCAN_TO_CHANNEL(11, 0xFFF),
+
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(2, 2, 0x003000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(4, 3, 0x007000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(6, 4, 0x00F000),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL(8, 2, 0x018000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(8, 5, 0x01F000),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL(10, 3, 0x038000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(10, 6, 0x3F000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(3, 2, 0x0C0000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(5, 3, 0x1C0000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(7, 4, 0x3C0000),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL(9, 2, 0x600000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(9, 5, 0x7C0000),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL(11, 3, 0xE00000),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL(11, 6, 0xFC0000),
 };
 
+const struct max1363_mode
+*max1363_match_mode(u32 mask, const struct max1363_chip_info *ci) {
+	int i;
+	if (mask)
+		for (i = 0; i < ci->num_modes; i++)
+			if (!((~max1363_mode_table[ci->mode_list[i]]
+			       .modemask) &
+			      mask))
+				return &max1363_mode_table[ci
+							   ->mode_list[i]];
+	return 0;
+};
+
+static ssize_t max1363_show_precision(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_state *st = iio_dev_get_devdata(dev_info);
+	return sprintf(buf, "%d\n", st->chip_info->bits);
+}
+
+static IIO_DEVICE_ATTR(in_precision, S_IRUGO, max1363_show_precision,
+		       NULL, 0);
+
+static int max1363_write_basic_config(struct i2c_client *client,
+				      unsigned char d1,
+				      unsigned char d2)
+{
+	int ret;
+	u8 *tx_buf = kmalloc(2 , GFP_KERNEL);
+
+	if (!tx_buf)
+		return -ENOMEM;
+	tx_buf[0] = d1;
+	tx_buf[1] = d2;
+
+	ret = i2c_master_send(client, tx_buf, 2);
+	kfree(tx_buf);
+
+	return (ret > 0) ? 0 : ret;
+}
+
+int max1363_set_scan_mode(struct max1363_state *st)
+{
+	st->configbyte &= ~(MAX1363_CHANNEL_SEL_MASK
+			    | MAX1363_SCAN_MASK
+			    | MAX1363_SE_DE_MASK);
+	st->configbyte |= st->current_mode->conf;
+
+	return max1363_write_basic_config(st->client,
+					  st->setupbyte,
+					  st->configbyte);
+}
+
+static ssize_t max1363_read_single_channel(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_state *st = iio_dev_get_devdata(dev_info);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	struct i2c_client *client = st->client;
+	int ret = 0, len = 0;
+	s32 data ;
+	char rxbuf[2];
+	long mask;
+
+	mutex_lock(&dev_info->mlock);
+	/* If ring buffer capture is occuring, query the buffer */
+	if (iio_ring_enabled(dev_info)) {
+		mask = max1363_mode_table[this_attr->address].modemask;
+		data = max1363_single_channel_from_ring(mask, st);
+		if (data < 0) {
+			ret = data;
+			goto error_ret;
+		}
+	} else {
+		/* Check to see if current scan mode is correct */
+		if (st->current_mode !=
+		    &max1363_mode_table[this_attr->address]) {
+			/* Update scan mode if needed */
+			st->current_mode
+				= &max1363_mode_table[this_attr->address];
+			ret = max1363_set_scan_mode(st);
+			if (ret)
+				goto error_ret;
+		}
+		/* Get reading */
+		data = i2c_master_recv(client, rxbuf, 2);
+		if (data < 0) {
+			ret = data;
+			goto error_ret;
+		}
+		data = (s32)(rxbuf[1]) | ((s32)(rxbuf[0] & 0x0F)) << 8;
+	}
+	/* Pretty print the result */
+	len = sprintf(buf, "%u\n", data);
+
+error_ret:
+	mutex_unlock(&dev_info->mlock);
+	return ret ? ret : len;
+}
+
+/* Direct read attribtues */
+static IIO_DEV_ATTR_IN_RAW(0, max1363_read_single_channel, _s0);
+static IIO_DEV_ATTR_IN_RAW(1, max1363_read_single_channel, _s1);
+static IIO_DEV_ATTR_IN_RAW(2, max1363_read_single_channel, _s2);
+static IIO_DEV_ATTR_IN_RAW(3, max1363_read_single_channel, _s3);
+static IIO_DEV_ATTR_IN_RAW(4, max1363_read_single_channel, _s4);
+static IIO_DEV_ATTR_IN_RAW(5, max1363_read_single_channel, _s5);
+static IIO_DEV_ATTR_IN_RAW(6, max1363_read_single_channel, _s6);
+static IIO_DEV_ATTR_IN_RAW(7, max1363_read_single_channel, _s7);
+static IIO_DEV_ATTR_IN_RAW(8, max1363_read_single_channel, _s8);
+static IIO_DEV_ATTR_IN_RAW(9, max1363_read_single_channel, _s9);
+static IIO_DEV_ATTR_IN_RAW(10, max1363_read_single_channel, _s10);
+static IIO_DEV_ATTR_IN_RAW(11, max1363_read_single_channel, _s11);
+
+static IIO_DEV_ATTR_IN_DIFF_RAW(0, 1, max1363_read_single_channel, d0m1);
+static IIO_DEV_ATTR_IN_DIFF_RAW(2, 3, max1363_read_single_channel, d2m3);
+static IIO_DEV_ATTR_IN_DIFF_RAW(4, 5, max1363_read_single_channel, d4m5);
+static IIO_DEV_ATTR_IN_DIFF_RAW(6, 7, max1363_read_single_channel, d6m7);
+static IIO_DEV_ATTR_IN_DIFF_RAW(8, 9, max1363_read_single_channel, d8m9);
+static IIO_DEV_ATTR_IN_DIFF_RAW(10, 11, max1363_read_single_channel, d10m11);
+static IIO_DEV_ATTR_IN_DIFF_RAW(1, 0, max1363_read_single_channel, d1m0);
+static IIO_DEV_ATTR_IN_DIFF_RAW(3, 2, max1363_read_single_channel, d3m2);
+static IIO_DEV_ATTR_IN_DIFF_RAW(5, 4, max1363_read_single_channel, d5m4);
+static IIO_DEV_ATTR_IN_DIFF_RAW(7, 6, max1363_read_single_channel, d7m6);
+static IIO_DEV_ATTR_IN_DIFF_RAW(9, 8, max1363_read_single_channel, d9m8);
+static IIO_DEV_ATTR_IN_DIFF_RAW(11, 10, max1363_read_single_channel, d11m10);
+
+
+static ssize_t max1363_show_scale(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	/* Driver currently only support internal vref */
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_state *st = iio_dev_get_devdata(dev_info);
+	/* Corresponds to Vref / 2^(bits) */
+
+	if ((1 << (st->chip_info->bits + 1))
+	    > st->chip_info->int_vref_mv)
+		return sprintf(buf, "0.5\n");
+	else
+		return sprintf(buf, "%d\n",
+			st->chip_info->int_vref_mv >> st->chip_info->bits);
+}
+
+IIO_DEVICE_ATTR(in_scale, S_IRUGO, max1363_show_scale, NULL, 0);
+
+static ssize_t max1363_show_name(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_state *st = iio_dev_get_devdata(dev_info);
+	return sprintf(buf, "%s\n", st->chip_info->name);
+}
+
+IIO_DEVICE_ATTR(name, S_IRUGO, max1363_show_name, NULL, 0);
+
 /* Applies to max1363 */
 static const enum max1363_modes max1363_mode_list[] = {
 	_s0, _s1, _s2, _s3,
-	se0, se1, se2, se3,
 	s0to1, s0to2, s0to3,
 	d0m1, d2m3, d1m0, d3m2,
-	de0m1, de2m3, de1m0, de3m2,
 	d0m1to2m3, d1m0to3m2,
 };
 
+static struct attribute *max1363_device_attrs[] = {
+	&iio_dev_attr_in0_raw.dev_attr.attr,
+	&iio_dev_attr_in1_raw.dev_attr.attr,
+	&iio_dev_attr_in2_raw.dev_attr.attr,
+	&iio_dev_attr_in3_raw.dev_attr.attr,
+	&iio_dev_attr_in0min1_raw.dev_attr.attr,
+	&iio_dev_attr_in2min3_raw.dev_attr.attr,
+	&iio_dev_attr_in1min0_raw.dev_attr.attr,
+	&iio_dev_attr_in3min2_raw.dev_attr.attr,
+	&iio_dev_attr_name.dev_attr.attr,
+	&iio_dev_attr_in_scale.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group max1363_dev_attr_group = {
+	.attrs = max1363_device_attrs,
+};
+
+static struct attribute *max1363_scan_el_attrs[] = {
+	&iio_scan_el_in0.dev_attr.attr,
+	&iio_scan_el_in1.dev_attr.attr,
+	&iio_scan_el_in2.dev_attr.attr,
+	&iio_scan_el_in3.dev_attr.attr,
+	&iio_scan_el_in0min1.dev_attr.attr,
+	&iio_scan_el_in2min3.dev_attr.attr,
+	&iio_scan_el_in1min0.dev_attr.attr,
+	&iio_scan_el_in3min2.dev_attr.attr,
+	&iio_dev_attr_in_precision.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group max1363_scan_el_group = {
+	.name = "scan_elements",
+	.attrs = max1363_scan_el_attrs,
+};
+
 /* Appies to max1236, max1237 */
 static const enum max1363_modes max1236_mode_list[] = {
 	_s0, _s1, _s2, _s3,
-	se0, se1, se2, se3,
 	s0to1, s0to2, s0to3,
 	d0m1, d2m3, d1m0, d3m2,
-	de0m1, de2m3, de1m0, de3m2,
 	d0m1to2m3, d1m0to3m2,
 	s2to3,
 };
@@ -157,19 +356,83 @@ static const enum max1363_modes max1236_mode_list[] = {
 /* Applies to max1238, max1239 */
 static const enum max1363_modes max1238_mode_list[] = {
 	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11,
-	se0, se1, se2, se3, se4, se5, se6, se7, se8, se9, se10, se11,
 	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6,
 	s0to7, s0to8, s0to9, s0to10, s0to11,
 	d0m1, d2m3, d4m5, d6m7, d8m9, d10m11,
 	d1m0, d3m2, d5m4, d7m6, d9m8, d11m10,
-	de0m1, de2m3, de4m5, de6m7, de8m9, de10m11,
-	de1m0, de3m2, de5m4, de7m6, de9m8, de11m10,
 	d0m1to2m3, d0m1to4m5, d0m1to6m7, d0m1to8m9, d0m1to10m11,
 	d1m0to3m2, d1m0to5m4, d1m0to7m6, d1m0to9m8, d1m0to11m10,
 	s6to7, s6to8, s6to9, s6to10, s6to11,
-	s6m7to8m9, s6m7to10m11, s7m6to9m8, s7m6to11m10,
+	d6m7to8m9, d6m7to10m11, d7m6to9m8, d7m6to11m10,
 };
 
+static struct attribute *max1238_device_attrs[] = {
+	&iio_dev_attr_in0_raw.dev_attr.attr,
+	&iio_dev_attr_in1_raw.dev_attr.attr,
+	&iio_dev_attr_in2_raw.dev_attr.attr,
+	&iio_dev_attr_in3_raw.dev_attr.attr,
+	&iio_dev_attr_in4_raw.dev_attr.attr,
+	&iio_dev_attr_in5_raw.dev_attr.attr,
+	&iio_dev_attr_in6_raw.dev_attr.attr,
+	&iio_dev_attr_in7_raw.dev_attr.attr,
+	&iio_dev_attr_in8_raw.dev_attr.attr,
+	&iio_dev_attr_in9_raw.dev_attr.attr,
+	&iio_dev_attr_in10_raw.dev_attr.attr,
+	&iio_dev_attr_in11_raw.dev_attr.attr,
+	&iio_dev_attr_in0min1_raw.dev_attr.attr,
+	&iio_dev_attr_in2min3_raw.dev_attr.attr,
+	&iio_dev_attr_in4min5_raw.dev_attr.attr,
+	&iio_dev_attr_in6min7_raw.dev_attr.attr,
+	&iio_dev_attr_in8min9_raw.dev_attr.attr,
+	&iio_dev_attr_in10min11_raw.dev_attr.attr,
+	&iio_dev_attr_in1min0_raw.dev_attr.attr,
+	&iio_dev_attr_in3min2_raw.dev_attr.attr,
+	&iio_dev_attr_in5min4_raw.dev_attr.attr,
+	&iio_dev_attr_in7min6_raw.dev_attr.attr,
+	&iio_dev_attr_in9min8_raw.dev_attr.attr,
+	&iio_dev_attr_in11min10_raw.dev_attr.attr,
+	&iio_dev_attr_name.dev_attr.attr,
+	&iio_dev_attr_in_scale.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group max1238_dev_attr_group = {
+	.attrs = max1238_device_attrs,
+};
+
+static struct attribute *max1238_scan_el_attrs[] = {
+	&iio_scan_el_in0.dev_attr.attr,
+	&iio_scan_el_in1.dev_attr.attr,
+	&iio_scan_el_in2.dev_attr.attr,
+	&iio_scan_el_in3.dev_attr.attr,
+	&iio_scan_el_in4.dev_attr.attr,
+	&iio_scan_el_in5.dev_attr.attr,
+	&iio_scan_el_in6.dev_attr.attr,
+	&iio_scan_el_in7.dev_attr.attr,
+	&iio_scan_el_in8.dev_attr.attr,
+	&iio_scan_el_in9.dev_attr.attr,
+	&iio_scan_el_in10.dev_attr.attr,
+	&iio_scan_el_in11.dev_attr.attr,
+	&iio_scan_el_in0min1.dev_attr.attr,
+	&iio_scan_el_in2min3.dev_attr.attr,
+	&iio_scan_el_in4min5.dev_attr.attr,
+	&iio_scan_el_in6min7.dev_attr.attr,
+	&iio_scan_el_in8min9.dev_attr.attr,
+	&iio_scan_el_in10min11.dev_attr.attr,
+	&iio_scan_el_in1min0.dev_attr.attr,
+	&iio_scan_el_in3min2.dev_attr.attr,
+	&iio_scan_el_in5min4.dev_attr.attr,
+	&iio_scan_el_in7min6.dev_attr.attr,
+	&iio_scan_el_in9min8.dev_attr.attr,
+	&iio_scan_el_in11min10.dev_attr.attr,
+	&iio_dev_attr_in_precision.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group max1238_scan_el_group = {
+	.name = "scan_elements",
+	.attrs = max1238_scan_el_attrs,
+};
 
 enum { max1361,
        max1362,
@@ -190,118 +453,130 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 	{
 		.name = "max1361",
 		.num_inputs = 4,
+		.bits = 10,
+		.int_vref_mv = 2048,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1362",
 		.num_inputs = 4,
+		.bits = 10,
+		.int_vref_mv = 4096,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1363",
 		.num_inputs = 4,
+		.bits = 12,
+		.int_vref_mv = 2048,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1364",
 		.num_inputs = 4,
+		.bits = 12,
+		.int_vref_mv = 4096,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1136",
 		.num_inputs = 4,
+		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1137",
 		.num_inputs = 4,
+		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1138",
 		.num_inputs = 12,
+		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
 	}, {
 		.name = "max1139",
 		.num_inputs = 12,
+		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
 	}, {
 		.name = "max1236",
 		.num_inputs = 4,
+		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1237",
 		.num_inputs = 4,
+		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
 	}, {
 		.name = "max1238",
 		.num_inputs = 12,
+		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
 	}, {
 		.name = "max1239",
 		.num_inputs = 12,
+		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
 	},
 };
 
-static int max1363_write_basic_config(struct i2c_client *client,
-				      unsigned char d1,
-				      unsigned char d2)
-{
-	int ret;
-	u8 *tx_buf = kmalloc(2 , GFP_KERNEL);
-	if (!tx_buf)
-		return -ENOMEM;
-	tx_buf[0] = d1;
-	tx_buf[1] = d2;
-
-	ret = i2c_master_send(client, tx_buf, 2);
-	kfree(tx_buf);
-	return (ret > 0) ? 0 : ret;
-}
-
-static int max1363_set_scan_mode(struct max1363_state *st)
-{
-	st->configbyte &= ~(MAX1363_CHANNEL_SEL_MASK
-			    | MAX1363_SCAN_MASK
-			    | MAX1363_SE_DE_MASK);
-	st->configbyte |= st->current_mode->conf;
-
-	return max1363_write_basic_config(st->client,
-					  st->setupbyte,
-					  st->configbyte);
-}
-
 static int max1363_initial_setup(struct max1363_state *st)
 {
 	st->setupbyte = MAX1363_SETUP_AIN3_IS_AIN3_REF_IS_VDD
@@ -318,167 +593,6 @@ static int max1363_initial_setup(struct max1363_state *st)
 	return max1363_set_scan_mode(st);
 }
 
-static ssize_t max1363_show_av_scan_modes(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
-	int i, len = 0;
-
-	for (i = 0; i < st->chip_info->num_modes; i++)
-		len += sprintf(buf + len, "%s ",
-			       max1363_mode_table[st->chip_info
-						  ->mode_list[i]].name);
-	len += sprintf(buf + len, "\n");
-
-	return len;
-}
-
-
-/* The dev here is the sysfs related one, not the underlying i2c one */
-static ssize_t max1363_scan_direct(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
-	int len = 0, ret, i;
-	struct i2c_client *client = st->client;
-	char *rxbuf;
-
-	if (st->current_mode->numvals == 0)
-		return 0;
-	rxbuf = kmalloc(st->current_mode->numvals*2, GFP_KERNEL);
-	if (rxbuf == NULL)
-		return -ENOMEM;
-
-	/* Interpretation depends on whether these are signed or not!*/
-	/* Assume not for now */
-	ret = i2c_master_recv(client, rxbuf, st->current_mode->numvals*2);
-
-	if (ret < 0)
-		return ret;
-	for (i = 0; i < st->current_mode->numvals; i++)
-		len += sprintf(buf+len, "%d ",
-			       ((int)(rxbuf[i*2+0]&0x0F) << 8)
-			       + ((int)(rxbuf[i*2+1])));
-	kfree(rxbuf);
-	len += sprintf(buf + len, "\n");
-
-	return len;
-}
-
-static ssize_t max1363_scan(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	int ret;
-
-	mutex_lock(&dev_info->mlock);
-	if (dev_info->currentmode == INDIO_RING_TRIGGERED)
-		ret = max1363_scan_from_ring(dev, attr, buf);
-	else
-		ret = max1363_scan_direct(dev, attr, buf);
-	mutex_unlock(&dev_info->mlock);
-
-	return ret;
-}
-
-/* Cannot query the device, so use local copy of state */
-static ssize_t max1363_show_scan_mode(struct device *dev,
-				      struct device_attribute *attr,
-				      char *buf)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
-
-	return sprintf(buf, "%s\n", st->current_mode->name);
-}
-
-static const struct max1363_mode
-*__max1363_find_mode_in_ci(const struct max1363_chip_info *info,
-				  const char *buf)
-{
-	int i;
-	for (i = 0; i <  info->num_modes; i++)
-		if (strcmp(max1363_mode_table[info->mode_list[i]].name, buf)
-		    == 0)
-			return &max1363_mode_table[info->mode_list[i]];
-	return NULL;
-}
-
-static ssize_t max1363_store_scan_mode(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf,
-				       size_t len)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
-	const struct max1363_mode *new_mode;
-	int ret;
-
-	mutex_lock(&dev_info->mlock);
-	new_mode = NULL;
-	/* Avoid state changes if a ring buffer is enabled */
-	if (!iio_ring_enabled(dev_info)) {
-		new_mode
-			= __max1363_find_mode_in_ci(st->chip_info, buf);
-		if (!new_mode) {
-			ret = -EINVAL;
-			goto error_ret;
-		}
-		st->current_mode = new_mode;
-		ret =  max1363_set_scan_mode(st);
-		if (ret)
-			goto error_ret;
-	} else {
-		ret = -EBUSY;
-		goto error_ret;
-	}
-	mutex_unlock(&dev_info->mlock);
-
-	return len;
-
-error_ret:
-	mutex_unlock(&dev_info->mlock);
-
-	return ret;
-}
-
-IIO_DEV_ATTR_AVAIL_SCAN_MODES(max1363_show_av_scan_modes);
-IIO_DEV_ATTR_SCAN_MODE(S_IRUGO | S_IWUSR,
-		       max1363_show_scan_mode,
-		       max1363_store_scan_mode);
-
-IIO_DEV_ATTR_SCAN(max1363_scan);
-
-static ssize_t max1363_show_name(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
-{
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
-	return sprintf(buf, "%s\n", st->chip_info->name);
-}
-
-IIO_DEVICE_ATTR(name, S_IRUGO, max1363_show_name, NULL, 0);
-
-/*name export */
-
-static struct attribute *max1363_attributes[] = {
-	&iio_dev_attr_available_scan_modes.dev_attr.attr,
-	&iio_dev_attr_scan_mode.dev_attr.attr,
-	&iio_dev_attr_scan.dev_attr.attr,
-	&iio_dev_attr_name.dev_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group max1363_attribute_group = {
-	.attrs = max1363_attributes,
-};
-
 static int __devinit max1363_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
@@ -506,6 +620,7 @@ static int __devinit max1363_probe(struct i2c_client *client,
 		ret = -ENODEV;
 		goto error_free_st;
 	}
+
 	st->reg = regulator_get(&client->dev, "vcc");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
@@ -520,20 +635,36 @@ static int __devinit max1363_probe(struct i2c_client *client,
 		goto error_disable_reg;
 	}
 
+	st->indio_dev->available_scan_masks
+		= kzalloc(GFP_KERNEL,
+			sizeof(*st->indio_dev->available_scan_masks)*
+			(st->chip_info->num_modes + 1));
+	if (!st->indio_dev->available_scan_masks) {
+		ret = -ENOMEM;
+		goto error_free_device;
+	}
+
+	for (i = 0; i < st->chip_info->num_modes; i++)
+		st->indio_dev->available_scan_masks[i] =
+			max1363_mode_table[st->chip_info->mode_list[i]]
+			.modemask;
 	/* Estabilish that the iio_dev is a child of the i2c device */
 	st->indio_dev->dev.parent = &client->dev;
-	st->indio_dev->attrs = &max1363_attribute_group;
+	st->indio_dev->attrs = st->chip_info->dev_attrs;
+
+	/* Todo: this shouldn't be here. */
+	st->indio_dev->scan_el_attrs = st->chip_info->scan_attrs;
 	st->indio_dev->dev_data = (void *)(st);
 	st->indio_dev->driver_module = THIS_MODULE;
 	st->indio_dev->modes = INDIO_DIRECT_MODE;
 
 	ret = max1363_initial_setup(st);
 	if (ret)
-		goto error_free_device;
+		goto error_free_available_scan_masks;
 
 	ret = max1363_register_ring_funcs_and_init(st->indio_dev);
 	if (ret)
-		goto error_free_device;
+		goto error_free_available_scan_masks;
 
 	ret = iio_device_register(st->indio_dev);
 	if (ret)
@@ -545,6 +676,8 @@ static int __devinit max1363_probe(struct i2c_client *client,
 	return 0;
 error_cleanup_ring:
 	max1363_ring_cleanup(st->indio_dev);
+error_free_available_scan_masks:
+	kfree(st->indio_dev->available_scan_masks);
 error_free_device:
 	if (!regdone)
 		iio_free_device(st->indio_dev);
@@ -569,6 +702,7 @@ static int max1363_remove(struct i2c_client *client)
 	struct iio_dev *indio_dev = st->indio_dev;
 	max1363_uninitialize_ring(indio_dev->ring);
 	max1363_ring_cleanup(indio_dev);
+	kfree(st->indio_dev->available_scan_masks);
 	iio_device_unregister(indio_dev);
 	if (!IS_ERR(st->reg)) {
 		regulator_disable(st->reg);
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index f94fe2d..6003f7e 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -17,6 +17,7 @@
 #include <linux/sysfs.h>
 #include <linux/list.h>
 #include <linux/i2c.h>
+#include <linux/bitops.h>
 
 #include "../iio.h"
 #include "../ring_generic.h"
@@ -26,32 +27,36 @@
 
 #include "max1363.h"
 
-ssize_t max1363_scan_from_ring(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
+/* Todo: test this */
+int max1363_single_channel_from_ring(long mask, struct max1363_state *st)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *info = dev_info->dev_data;
-	int i, ret, len = 0;
-	char *ring_data;
+	unsigned long numvals;
+	int count = 0, ret;
+	u8 *ring_data;
+	if (!(st->current_mode->modemask & mask)) {
+		ret = -EBUSY;
+		goto error_ret;
+	}
+	numvals = hweight_long(st->current_mode->modemask);
 
-	ring_data = kmalloc(info->current_mode->numvals*2, GFP_KERNEL);
+	ring_data = kmalloc(numvals*2, GFP_KERNEL);
 	if (ring_data == NULL) {
 		ret = -ENOMEM;
 		goto error_ret;
 	}
-	ret = dev_info->ring->access.read_last(dev_info->ring, ring_data);
+	ret = st->indio_dev->ring->access.read_last(st->indio_dev->ring,
+						ring_data);
 	if (ret)
 		goto error_free_ring_data;
-	len += sprintf(buf+len, "ring ");
-	for (i = 0; i < info->current_mode->numvals; i++)
-		len += sprintf(buf + len, "%d ",
-			       ((int)(ring_data[i*2 + 0] & 0x0F) << 8)
-			       + ((int)(ring_data[i*2 + 1])));
-	len += sprintf(buf + len, "\n");
-	kfree(ring_data);
-
-	return len;
+	/* Need a count of channels prior to this one */
+	mask >>= 1;
+	while (mask) {
+		if (mask && st->current_mode->modemask)
+			count++;
+		mask >>= 1;
+	}
+	return ((int)(ring_data[count*2 + 0] & 0x0F) << 8)
+		+ (int)(ring_data[count*2 + 1]);
 
 error_free_ring_data:
 	kfree(ring_data);
@@ -70,9 +75,22 @@ static int max1363_ring_preenable(struct iio_dev *indio_dev)
 {
 	struct max1363_state *st = indio_dev->dev_data;
 	size_t d_size;
+	unsigned long numvals;
+
+	/*
+	 * Need to figure out the current mode based upon the requested
+	 * scan mask in iio_dev
+	 */
+	st->current_mode = max1363_match_mode(st->indio_dev->scan_mask,
+					st->chip_info);
+	if (!st->current_mode)
+		return -EINVAL;
+
+	max1363_set_scan_mode(st);
 
+	numvals = hweight_long(st->current_mode->modemask);
 	if (indio_dev->ring->access.set_bpd) {
-		d_size = st->current_mode->numvals*2 + sizeof(s64);
+		d_size = numvals*2 + sizeof(s64);
 		if (d_size % 8)
 			d_size += 8 - (d_size % 8);
 		indio_dev->ring->access.set_bpd(indio_dev->ring, d_size);
@@ -145,9 +163,10 @@ static void max1363_poll_bh_to_ring(struct work_struct *work_s)
 	__u8 *rxbuf;
 	int b_sent;
 	size_t d_size;
+	unsigned long numvals = hweight_long(st->current_mode->modemask);
 
 	/* Ensure the timestamp is 8 byte aligned */
-	d_size = st->current_mode->numvals*2 + sizeof(s64);
+	d_size = numvals*2 + sizeof(s64);
 	if (d_size % sizeof(s64))
 		d_size += sizeof(s64) - (d_size % sizeof(s64));
 
@@ -159,16 +178,14 @@ static void max1363_poll_bh_to_ring(struct work_struct *work_s)
 	 * might as well have this test in here in the meantime as it does
 	 * no harm.
 	 */
-	if (st->current_mode->numvals == 0)
+	if (numvals == 0)
 		return;
 
 	rxbuf = kmalloc(d_size,	GFP_KERNEL);
 	if (rxbuf == NULL)
 		return;
 
-	b_sent = i2c_master_recv(st->client,
-				 rxbuf,
-				 st->current_mode->numvals*2);
+	b_sent = i2c_master_recv(st->client, rxbuf, numvals*2);
 	if (b_sent < 0)
 		goto done;
 
-- 
1.6.4.4

