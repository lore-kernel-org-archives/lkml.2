Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2J3FdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:33:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2J3FdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:33:00 -0400
X-AuditID: cbfee61b-b7f616d00000319b-ed-508f668b5dfa
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH 2/2] therma: exynos: Supports thermal tripping
Date: Tue, 30 Oct 2012 14:32:59 +0900
Message-id: <000101cdb660$05e7ded0$11b79c70$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QAAAg6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd3utP4Ag9dfdCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrxXtrAV/RSuurPzJ1MC4R6CLkZNDQsBE4u2Nh4wQtpjEhXvr
	2boYuTiEBKYzSty89ZsVwpnHJHFy/w1mkCo2AV2JY+u3ACU4OEQE9CROnogHqWEWaGKUaJy/
	CKxGWMBO4sPvzWBTWQRUJa4f+MMEYvMCxVe/uc4MYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnN
	W2aQ+RIC6hKP/uqChEUEjCSeLLnJCFEiIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzgwn0nvYFzVYHGIUYCDUYmHd+OavgAh1sSy4srcQ4wS
	HMxKIrz53v0BQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tSs1NTC1KLYLJMHJxS
	DYxsDGnLhJKqu6/4qmuH7UrcVPbszTm9oH7JJOc1ubtqvfsaZfz11/XvOHD2840YdY27R92V
	dolu7TFpql5S1Jxo+Nt99lq9Bc8eCxxzW3DMWa6Ga4VivHl279nOj7Eqkod3hJ8M25oh4jPN
	OPPV50ut3osTTGdvjep69ojrss3cp+uMtT8UvlNiKc5INNRiLipOBAAOW/HCSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU urgently sends active-high signal (thermal trip) to PMU,
and thermal tripping by hardware logic i.e PMU is performed.
Thermal tripping means that PMU cut off the whole power of SoC
by controlling external voltage regulator.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c             |    7 ++++++-
 include/linux/platform_data/exynos_thermal.h |    4 ++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 6ce6667..edac601 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -53,6 +53,7 @@
 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
+#define EXYNOS_TMU_TRIP_EN             BIT(12)
 #define EXYNOS_TMU_CORE_ON             1
 #define EXYNOS_TMU_CORE_OFF            0
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
@@ -656,6 +657,8 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
        if (data->soc == SOC_ARCH_EXYNOS) {
                con |= pdata->noise_cancel_mode <<
EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
+               if (pdata->trip_en)
+                       con |= EXYNOS_THERMAL_TRIP_EN;
        }

        if (on) {
@@ -762,10 +765,12 @@ static struct exynos_tmu_platform_data const
exynos_default_tmu_data = {
        .trigger_levels[0] = 85,
        .trigger_levels[1] = 103,
        .trigger_levels[2] = 110,
+       .trigger_levels[3] = 120,
        .trigger_level0_en = 1,
        .trigger_level1_en = 1,
        .trigger_level2_en = 1,
-       .trigger_level3_en = 0,
+       .trigger_level3_en = 1,
+       .trip_en = 1,
        .gain = 8,
        .reference_voltage = 16,
        .noise_cancel_mode = 4,
diff --git a/include/linux/platform_data/exynos_thermal.h
b/include/linux/platform_data/exynos_thermal.h
index a7bdb2f..9e44aac 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -79,6 +79,9 @@ struct freq_clip_table {
  * @trigger_level3_en:
  *     1 = enable trigger_level3 interrupt,
  *     0 = disable trigger_level3 interrupt
+ * @trip_en:
+ *     1 = enable thermal tripping
+ *     0 = disable thermal tripping
  * @gain: gain of amplifier in the positive-TC generator block
  *     0 <= gain <= 15
  * @reference_voltage: reference voltage of amplifier
@@ -102,6 +105,7 @@ struct exynos_tmu_platform_data {
        bool trigger_level1_en;
        bool trigger_level2_en;
        bool trigger_level3_en;
+       bool trip_en;

        u8 gain;
        u8 reference_voltage;
--
1.7.4.1

