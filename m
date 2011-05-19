Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1ESVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:06:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46180 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1ESVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:06:35 -0400
Date: Thu, 19 May 2011 23:06:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mce changes for v2.6.40
Message-ID: <20110519210619.GA11636@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, MCE: Do not taint when handling correctable errors
      x86, mce: Drop the default decoding notifier


 arch/x86/include/asm/mce.h               |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c         |   25 +++++++------------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ---
 3 files changed, 7 insertions(+), 23 deletions(-)

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
index 3385ea2..ff1ae9b 100644
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
@@ -590,7 +582,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
 			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
-			add_taint(TAINT_MACHINE_CHECK);
 		}
 
 		/*
@@ -1722,8 +1713,6 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
-
 	mcheck_intel_therm_init();
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..5846a79 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -187,8 +187,6 @@ static int therm_throt_process(bool new_event, int event, int level)
 				this_cpu,
 				level == CORE_LEVEL ? "Core" : "Package",
 				state->count);
-
-		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (old_event) {
@@ -393,7 +391,6 @@ static void unexpected_thermal_interrupt(void)
 {
 	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
 }
 
 static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
