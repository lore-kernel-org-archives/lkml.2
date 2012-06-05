Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab2FEJ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:57:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:23834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab2FEJ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174951565"
Message-ID: <4FCDD78A.3070106@intel.com>
Date: Tue, 05 Jun 2012 17:55:22 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v5 2/2] x86 mce: use new printk recursion disabling interface
References: <20120524061145.GA18284@liondog.tnic> <20120524155611.b7aeff4d.akpm@linux-foundation.org> <1337905811.14538.206.camel@ymzhang.sh.intel.com> <4FBF3295.7090608@intel.com> <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com> <1338165058.14538.209.camel@ymzhang.sh.intel.com> <4FC2E8CF.2040109@intel.com> <4FC2E944.6060903@intel.com> <20120604171202.GA8533@x1.osrc.amd.com> <1338856360.14538.220.camel@ymzhang.sh.intel.com> <20120605081448.GA7097@liondog.tnic> <4FCDD72A.9030701@intel.com>
In-Reply-To: <4FCDD72A.9030701@intel.com>
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
 arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2afcbd2..906e838 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -306,6 +306,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i, apei_err = 0;
 
+	printk_recursion_check_disable();
 	if (!fake_panic) {
 		/*
 		 * Make sure only one CPU runs in machine check panic
@@ -360,6 +361,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
+	printk_recursion_check_enable();
 }
 
 /* Support code for software error injection */
-- 
1.7.1

