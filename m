Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1GAAa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:30:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:45164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1GAAa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:30:58 -0400
Date: Fri, 1 Jul 2011 00:30:51 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-3e7cf5b00dd5b577b4ee9b2a66e40fb670ef210b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-32, fpu: Fix DNA exception during check_fpu()
Git-Commit-ID: 3e7cf5b00dd5b577b4ee9b2a66e40fb670ef210b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 00:30:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e7cf5b00dd5b577b4ee9b2a66e40fb670ef210b
Gitweb:     http://git.kernel.org/tip/3e7cf5b00dd5b577b4ee9b2a66e40fb670ef210b
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 30 Jun 2011 17:19:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 Jun 2011 17:29:47 -0700

x86-32, fpu: Fix DNA exception during check_fpu()

Before check_fpu() is called, we have cr0.TS bit set and hence the floating
point code to check the FDIV bug was generating a DNA exception.

Use kernel_fpu_begin()/kernel_fpu_end() around the floating point
code to avoid this unnecessary device not available exception during
boot.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1309479572.2665.1372.camel@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 525514c..46674fb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,6 +62,8 @@ static void __init check_fpu(void)
 		return;
 	}
 
+	kernel_fpu_begin();
+
 	/*
 	 * trap_init() enabled FXSR and company _before_ testing for FP
 	 * problems here.
@@ -80,6 +82,8 @@ static void __init check_fpu(void)
 		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
 
+	kernel_fpu_end();
+
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");
