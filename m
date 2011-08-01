Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1HAPJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:09:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1HAPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:09:03 -0400
Message-ID: <4E36C18B.7050502@gmail.com>
Date: Mon, 01 Aug 2011 17:08:59 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v3] oprofile, x86: Convert memory allocation to static array
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com>
In-Reply-To: <20110801070742.GA11795@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On -rt, allocators don't work from atomic context any more,
and the maximum size of the array is known at compile time.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 94b7450..608874b 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -28,7 +28,7 @@ static int counter_width = 32;
 
 #define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
 
-static u64 *reset_value;
+static u64 reset_value[OP_MAX_COUNTER];
 
 static void ppro_shutdown(struct op_msrs const * const msrs)
 {
@@ -40,10 +40,6 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
-	if (reset_value) {
-		kfree(reset_value);
-		reset_value = NULL;
-	}
 }
 
 static int ppro_fill_in_addresses(struct op_msrs * const msrs)
@@ -79,13 +75,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	u64 val;
 	int i;
 
-	if (!reset_value) {
-		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
-					GFP_ATOMIC);
-		if (!reset_value)
-			return;
-	}
-
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
@@ -141,13 +130,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	/*
-	 * This can happen if perf counters are in use when
-	 * we steal the die notifier NMI.
-	 */
-	if (unlikely(!reset_value))
-		goto out;
-
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -179,8 +161,6 @@ static void ppro_start(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
@@ -196,8 +176,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;


