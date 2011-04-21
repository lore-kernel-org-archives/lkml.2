Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1DUMLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:11:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:37109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1DUMLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:11:06 -0400
Date: Thu, 21 Apr 2011 12:10:44 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-dffa4b2f62ff28c982144c7033001b1ece4d3532@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, rja@sgi.com, Nagananda.Chumbalkar@hp.com,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, rja@sgi.com, Nagananda.Chumbalkar@hp.com,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <20110420102349.GB1361@aftab>
References: <20110420102349.GB1361@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Drop the default decoding notifier
Git-Commit-ID: dffa4b2f62ff28c982144c7033001b1ece4d3532
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 12:10:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dffa4b2f62ff28c982144c7033001b1ece4d3532
Gitweb:     http://git.kernel.org/tip/dffa4b2f62ff28c982144c7033001b1ece4d3532
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 20 Apr 2011 12:23:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Apr 2011 11:35:10 +0200

x86, mce: Drop the default decoding notifier

The default notifier doesn't make a lot of sense to call in the
correctable errors case. Drop it and emit the mcelog decoding
hint only in the uncorrectable errors case and when no notifier
is registered. Also, limit issuing the "mcelog --ascii" message
in the rare case when we dump unreported CEs before panicking.

While at it, remove unused old x86_mce_decode_callback from the
header.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>
Cc: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/20110420102349.GB1361@aftab
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |   24 +++++++-----------------
 2 files changed, 7 insertions(+), 19 deletions(-)

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
index 68e2303..ff1ae9b 100644
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
 
@@ -239,7 +227,11 @@ static void print_mce(struct mce *m)
 	 * Print out human-readable details about the MCE error,
 	 * (if the CPU has an implementation for that)
 	 */
-	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	if (ret == NOTIFY_STOP)
+		return;
+
+	pr_emerg_ratelimited(HW_ERR "Run the above through 'mcelog --ascii'\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -1721,8 +1713,6 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
-
 	mcheck_intel_therm_init();
 
 	return 0;
