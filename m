Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1DMNhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:37:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42995 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1DMNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:37:17 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Russ Anderson <rja@sgi.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: [PATCH 2/3] x86, MCE: Drop default decoding notifier
Date: Wed, 13 Apr 2011 15:36:49 +0200
Message-Id: <1302701810-2471-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <20110413132409.GB1900@gere.osrc.amd.com>
References: <20110413132409.GB1900@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The default notifier doesn't make a lot of sense to call in the
correctable errors case. Drop it and emit the mcelog decoding hint only
in the uncorrectable errors case and when no notifier is registered.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++-----------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..871d3c4 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -117,6 +117,8 @@ struct mce_log {
 
 extern struct atomic_notifier_head x86_mce_decoder_chain;
 
+extern atomic_t mce_decoders;
+
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <asm/atomic.h>
@@ -142,8 +144,6 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
-extern void (*x86_mce_decode_callback)(struct mce *m);
-
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68e2303..3069608 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -105,19 +105,8 @@ static int			cpu_missing;
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
+atomic_t mce_decoders = ATOMIC_INIT(0);
+EXPORT_SYMBOL_GPL(mce_decoders);
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -239,7 +228,11 @@ static void print_mce(struct mce *m)
 	 * Print out human-readable details about the MCE error,
 	 * (if the CPU has an implementation for that)
 	 */
-	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	if (!atomic_read(&mce_decoders)) {
+		pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
+		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
+	} else
+		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -589,7 +582,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 */
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
-			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
+			if (atomic_read(&mce_decoders))
+				atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
 		}
 
 		/*
@@ -1721,8 +1715,6 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
-
 	mcheck_intel_therm_init();
 
 	return 0;
-- 
1.7.4.rc2

