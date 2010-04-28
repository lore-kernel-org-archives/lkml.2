Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0D1NWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:22:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53120 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab0D1NWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:22:10 -0400
X-Sasl-enc: G3vKTGmCEPPEiChv1wVS1LlHG6W5z89vZKhVeDEF4qKN 1272460928
Message-ID: <4BD8367E.3020204@ladisch.de>
Date: Wed, 28 Apr 2010 15:22:06 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/hpet: work around wrong number of timers in ID register
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not every HPET implementation gets the index of the last timer correct;
if this field is erroneously set to the timer count, such as on my
SB710, the kernel will allocate one additional timer that does not
actually exist.

To work around this, create a helper function to read the number of
timers and to check that the last timer actually exists.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
v2: log a message on offending hardware

 arch/x86/kernel/hpet.c |   43 ++++++++++++++++++++++++++++-------------
 drivers/char/hpet.c    |    2 -
 2 files changed, 31 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -163,6 +163,32 @@ do {								\
 		_hpet_print_config(__FUNCTION__, __LINE__);	\
 } while (0)
 
+#if defined(CONFIG_HPET) || defined(CONFIG_HPET_EMULATE_RTC) || \
+    defined(CONFIG_PCI_MSI)
+static unsigned int hpet_get_num_timers(void)
+{
+	u32 id;
+	unsigned int number;
+
+	id = hpet_readl(HPET_ID);
+	number = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+
+	/*
+	 * The number field should contain the index of the last timer, not the
+	 * count of timers.  For hardware such as SB710 that gets this wrong,
+	 * check that the last timer actually exists by testing if any
+	 * interrupt routing bits are set.
+	 */
+	if (number > 2 && hpet_readl(HPET_Tn_CFG(number - 1) + 4) == 0) {
+		number--;
+		printk_once(KERN_INFO "hpet: number of timers reduced to %u\n",
+			    number);
+	}
+
+	return number;
+}
+#endif
+
 /*
  * When the hpet driver (/dev/hpet) is enabled, we need to reserve
  * timer 0 and timer 1 in case of RTC emulation.
@@ -178,7 +204,7 @@ static void hpet_reserve_platform_timers
 	unsigned int nrtimers, i;
 	struct hpet_data hd;
 
-	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+	nrtimers = hpet_get_num_timers();
 
 	memset(&hd, 0, sizeof(hd));
 	hd.hd_phys_address	= hpet_address;
@@ -600,7 +626,6 @@ static void init_one_hpet_msi_clockevent
 
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
-	unsigned int id;
 	unsigned int num_timers;
 	unsigned int num_timers_used = 0;
 	int i;
@@ -610,10 +635,8 @@ static void hpet_msi_capability_lookup(u
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return;
-	id = hpet_readl(HPET_ID);
 
-	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
-	num_timers++; /* Value read out starts from 0 */
+	num_timers = hpet_get_num_timers();
 	hpet_print_config();
 
 	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
@@ -839,7 +862,6 @@ static int hpet_clocksource_register(voi
  */
 int __init hpet_enable(void)
 {
-	unsigned int id;
 	int i;
 
 	if (!is_hpet_capable())
@@ -877,11 +899,6 @@ int __init hpet_enable(void)
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 
-	/*
-	 * Read the HPET ID register to retrieve the IRQ routing
-	 * information and the number of channels
-	 */
-	id = hpet_readl(HPET_ID);
 	hpet_print_config();
 
 #ifdef CONFIG_HPET_EMULATE_RTC
@@ -889,14 +906,14 @@ int __init hpet_enable(void)
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
@@ -858,7 +858,7 @@ int hpet_alloc(struct hpet_data *hdp)
 
 	ntimer = ((cap & HPET_NUM_TIM_CAP_MASK) >> HPET_NUM_TIM_CAP_SHIFT) + 1;
 
-	if (hpetp->hp_ntimer != ntimer) {
+	if (hpetp->hp_ntimer > ntimer) {
 		printk(KERN_WARNING "hpet: number irqs doesn't agree"
 		       " with number of timers\n");
 		kfree(hpetp);
