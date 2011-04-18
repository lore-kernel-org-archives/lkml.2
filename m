Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1DROB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:01:26 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42282 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1DROBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:01:15 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Date: Mon, 18 Apr 2011 16:00:22 +0200
Message-Id: <1303135222-17118-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The default notifier doesn't make a lot of sense to call in the
correctable errors case. Drop it and emit the mcelog decoding hint only
in the uncorrectable errors case and when no notifier is registered.
Also, limit issuing the "mcelog --ascii" message in the rare case when
we dump unreported CEs before panicking.

While at it, remove unused old x86_mce_decode_callback from the header.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |   23 ++++++-----------------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..021979a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -142,8 +142,6 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
-extern void (*x86_mce_decode_callback)(struct mce *m);
-
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68e2303..679bd9e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -105,20 +105,6 @@ static int			cpu_missing;
 ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
 EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
 
-static int default_decode_mce(struct notifier_block *nb, unsigned long val,
-			       void *data)
-{
-	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
-	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
-
-	return NOTIFY_STOP;
-}
-
-static struct notifier_block mce_dec_nb = {
-	.notifier_call = default_decode_mce,
-	.priority      = -1,
-};
-
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
@@ -212,6 +198,8 @@ void mce_log(struct mce *mce)
 
 static void print_mce(struct mce *m)
 {
+	int ret = 0;
+
 	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
@@ -239,7 +227,10 @@ static void print_mce(struct mce *m)
 	 * Print out human-readable details about the MCE error,
 	 * (if the CPU has an implementation for that)
 	 */
-	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	if (ret != NOTIFY_STOP)
+		printk_ratelimited(KERN_EMERG HW_ERR
+				   "Run the above through 'mcelog --ascii'\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -1721,8 +1712,6 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
-
 	mcheck_intel_therm_init();
 
 	return 0;
-- 
1.7.4.rc2

