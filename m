Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab1DNO7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab1DNO7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:59:14 -0400
Message-ID: <4DA70BB4.4020407@redhat.com>
Date: Thu, 14 Apr 2011 10:59:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v2] x86, MCE: Drop default decoding notifier
References: <20110413132409.GB1900@gere.osrc.amd.com> <1302701810-2471-2-git-send-email-bp@amd64.org> <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab> <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab> <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com> <4DA5D9FB.1010503@redhat.com> <20110413173705.GJ2791@aftab>
In-Reply-To: <20110413173705.GJ2791@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In the worst case, we will report 32 CEs before panicking. For that case
> we either do printk_once as Tony suggested or we ratelimit it. I'll
> update the patch.
> 

Okay ... how 'bout using Tony's printk_once() just after the call to
print_mce() in mce_panic()? [uncompiled and untested patch below]

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
index 3385ea2..6ecfea5 100644
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
+	if (ret != NOTIFY_STOP && (m->status & MCI_STATUS_UC))
+		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' "
+			 "to decode.\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -289,6 +280,8 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 			continue;
 		if (!(m->status & MCI_STATUS_UC)) {
 			print_mce(m);
+			printk_once(KERN_EMERG HW_ERR "MCE Corrected Error(s) "
+				    "detected.");
 			if (!apei_err)
 				apei_err = apei_write_mce(m);
 		}
@@ -1722,8 +1715,6 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
-
 	mcheck_intel_therm_init();
 
 	return 0;
