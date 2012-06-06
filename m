Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2FFIgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:36:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:42319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab2FFIgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153587800"
Message-ID: <4FCF160D.8010404@intel.com>
Date: Wed, 06 Jun 2012 16:34:21 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v6 2/2] x86 mce: use new printk recursion disabling interface
References: <4FBF3295.7090608@intel.com>  <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>  <1338165058.14538.209.camel@ymzhang.sh.intel.com>  <4FC2E8CF.2040109@intel.com> <4FC2E944.6060903@intel.com>  <20120604171202.GA8533@x1.osrc.amd.com>  <1338856360.14538.220.camel@ymzhang.sh.intel.com>  <20120605081448.GA7097@liondog.tnic> <4FCDD72A.9030701@intel.com>  <4FCDD78A.3070106@intel.com> <20120605151542.GA10669@x1.osrc.amd.com> <1338942965.14538.233.camel@ymzhang.sh.intel.com> <4FCF155B.3090705@intel.com>
In-Reply-To: <4FCF155B.3090705@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

On x86 machines, some times MCE happens just when kernel calls printk
to output some log info to serial console, while usually MCE module in
kernel is used to print out some hardware error information, such like
bad cache or bad memory bank. That causes printk recursion and printk
would omit MCE printk output.

We hit it when running MTBF testing on Android ATOM mobiles.

Here in mce_panic, we choose to disable printk recursion to make sure
MCE logs printed out.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
v6: move the disabling checking in print_mce

---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2afcbd2..6056e94 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -242,6 +242,7 @@ static void print_mce(struct mce *m)
 {
 	int ret = 0;
 
+	printk_recursion_check_disable();
 	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
@@ -275,10 +276,13 @@ static void print_mce(struct mce *m)
 	 * (if the CPU has an implementation for that)
 	 */
 	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
-	if (ret == NOTIFY_STOP)
+	if (ret == NOTIFY_STOP) {
+		printk_recursion_check_enable();
 		return;
+	}
 
 	pr_emerg_ratelimited(HW_ERR "Run the above through 'mcelog --ascii'\n");
+	printk_recursion_check_enable();
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
-- 
1.7.1
