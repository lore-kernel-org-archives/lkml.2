Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab1EZRNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:13:15 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54490 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1EZRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:13:14 -0400
Date: Thu, 26 May 2011 22:42:51 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: [Patch 2/6] x86: mce: Convert mce code to xpanic
Message-ID: <20110526171251.GB17988@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526170722.GB23266@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit aea29c4a9324f24b5c61e7c3919a8137a53be935
Author: Andi Kleen <ak@linux.intel.com>
Date:   Fri Nov 19 18:42:02 2010 +0100

    x86: mce: Convert mce code to xpanic
    
    - Pass in the panic timeout directly instead of
    abusing global variable.
    - Disable backtraces and kexecs on machine check panics
    because they don't do anything useful.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.slim_kdump.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6.slim_kdump/arch/x86/kernel/cpu/mcheck/mce.c
@@ -258,9 +258,8 @@ static void wait_for_panic(void)
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
-	if (panic_timeout == 0)
-		panic_timeout = mce_panic_timeout;
-	panic("Panicing machine check CPU died");
+	xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, 0,
+		"Panicing machine check CPU died");
 }
 
 static void mce_panic(char *msg, struct mce *final, char *exp)
@@ -316,9 +315,8 @@ static void mce_panic(char *msg, struct
 	if (exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
-		if (panic_timeout == 0)
-			panic_timeout = mce_panic_timeout;
-		panic(msg);
+		xpanic(PANIC_NO_KEXEC|PANIC_NO_BACKTRACE, mce_panic_timeout,
+			msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
 }
