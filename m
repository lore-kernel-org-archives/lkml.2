Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0CVIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:46:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50615 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab0CVIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:46:14 -0400
X-Sasl-enc: 12m1NpTTtfVVSvrRbWGOVArACxJoGqVF2VIqo16thlwK 1269247573
Message-ID: <4BA72E50.4000708@ladisch.de>
Date: Mon, 22 Mar 2010 09:46:08 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: hpet: work around wrong number of timers in ID register
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every HPET implementation gets the index of the last timer correct;
if this field is erroneously set to the timer count, the kernel will
allocate one additional timer that does not actually exist.

To work around this, create a helper function to read the number of
timers and to check that the last timer actually exists.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 arch/x86/kernel/hpet.c |   39 ++++++++++++++++++++++++++-------------
 drivers/char/hpet.c    |    2 +-
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -162,6 +162,28 @@
 		_hpet_print_config(__FUNCTION__, __LINE__);	\
 } while (0)
 
+#if defined(CONFIG_HPET) || defined(CONFIG_HPET_EMULATE_RTC) || \
+    defined(CONFIG_PCI_MSI)
+static unsigned int hpet_get_num_timers(void)
+{
+	u32 id, number;
+
+	id = hpet_readl(HPET_ID);
+	number = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+
+	/*
+	 * The number field should contain the index of the last timer, not the
+	 * count of timers.  For hardware that gets this wrong, check that the
+	 * last timer actually exists by testing if any interrupt routing bits
+	 * are set; unimplemented registers read 0 on SB710.
+	 */
+	if (number > 2 && hpet_readl(HPET_Tn_CFG(number - 1) + 4) == 0)
+		number--;
+
+	return number;
+}
+#endif
+
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
  * timer 0 and timer 1 in case of RTC emulation.
@@ -177,7 +199,7 @@ static void hpet_reserve_platform_timers
 	unsigned int nrtimers, i;
 	struct hpet_data hd;
 
-	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+	nrtimers = hpet_get_num_timers();
 
 	memset(&hd, 0, sizeof(hd));
 	hd.hd_phys_address	= hpet_address;
@@ -593,7 +615,6 @@ static void init_one_hpet_msi_clockevent
 
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
-	unsigned int id;
 	unsigned int num_timers;
 	unsigned int num_timers_used = 0;
 	int i;
@@ -603,10 +624,8 @@ static void hpet_msi_capability_lookup(u
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return;
-	id = hpet_readl(HPET_ID);
 
-	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
-	num_timers++; /* Value read out starts from 0 */
+	num_timers = hpet_get_num_timers();
 	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
@@ -832,7 +851,6 @@ static int hpet_clocksource_register(voi
  */
 int __init hpet_enable(void)
 {
-	unsigned int id;
 	int i;
 
 	if (!is_hpet_capable())
@@ -870,11 +888,6 @@ int __init hpet_enable(void)
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 
-	/*
-	 * Read the HPET ID register to retrieve the IRQ routing
-	 * information and the number of channels
-	 */
-	id = hpet_readl(HPET_ID);
 	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
@@ -882,14 +895,14 @@ int __init hpet_enable(void)
 	 * The legacy routing mode needs at least two channels, tick timer
 	 * and the rtc emulation channel.
 	 */
-	if (!(id & HPET_ID_NUMBER))
+	if (hpet_get_num_timers() < 2)
 		goto out_nohpet;
 #endif
 
 	if (hpet_clocksource_register())
 		goto out_nohpet;
 
-	if (id & HPET_ID_LEGSUP) {
+	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
 		return 1;
 	}
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -857,7 +857,7 @@ int hpet_alloc(struct hpet_data *hdp)
 
 	ntimer = ((cap & HPET_NUM_TIM_CAP_MASK) >> HPET_NUM_TIM_CAP_SHIFT) + 1;
 
-	if (hpetp->hp_ntimer != ntimer) {
+	if (hpetp->hp_ntimer > ntimer) {
 		printk(KERN_WARNING "hpet: number irqs doesn't agree"
 		       " with number of timers\n");
 		kfree(hpetp);
