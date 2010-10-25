Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0JYGwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:37370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0JYGwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:52:41 -0400
Date: Mon, 25 Oct 2010 06:52:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, robert.richter@amd.com,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101025115736.41d51abe.sfr@canb.auug.org.au>
References: <20101025115736.41d51abe.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/oprofile: Fix uninitialized variable use in debug printk
Message-ID: <tip-2c78ffeca98fcd5a1dfd4a322438944506ed5e64@git.kernel.org>
Git-Commit-ID: 2c78ffeca98fcd5a1dfd4a322438944506ed5e64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Oct 2010 06:52:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c78ffeca98fcd5a1dfd4a322438944506ed5e64
Gitweb:     http://git.kernel.org/tip/2c78ffeca98fcd5a1dfd4a322438944506ed5e64
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 25 Oct 2010 08:41:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 08:46:20 +0200

x86/oprofile: Fix uninitialized variable use in debug printk

Stephen Rothwell reported this build warning:

  arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
  arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uninitialized in this function

And correctly observed that indeed the variable is used uninitialized in
this function. The result of this bug can be a debug printk with a bogus
value.

Also fix a few more small details that made this function hard to read
and which probably contributed to the bug being introduced to begin with:

 - Use more symmetric error conditions

 - Remove the !0 obfuscation

 - Add newlines to the printk output

 - Remove bogus linebreaks in printk strings and elsewhere

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20101025115736.41d51abe.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/op_model_amd.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 42fb46f..68759e7 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -281,29 +281,25 @@ static inline int eilvt_is_available(int offset)
 
 static inline int ibs_eilvt_valid(void)
 {
-	u64 val;
 	int offset;
+	u64 val;
 
 	rdmsrl(MSR_AMD64_IBSCTL, val);
+	offset = val & IBSCTL_LVT_OFFSET_MASK;
+
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
-		pr_err(FW_BUG "cpu %d, invalid IBS "
-		       "interrupt offset %d (MSR%08X=0x%016llx)",
-		       smp_processor_id(), offset,
-		       MSR_AMD64_IBSCTL, val);
+		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
 		return 0;
 	}
 
-	offset = val & IBSCTL_LVT_OFFSET_MASK;
-
-	if (eilvt_is_available(offset))
-		return !0;
-
-	pr_err(FW_BUG "cpu %d, IBS interrupt offset %d "
-	       "not available (MSR%08X=0x%016llx)",
-	       smp_processor_id(), offset,
-	       MSR_AMD64_IBSCTL, val);
+	if (!eilvt_is_available(offset)) {
+		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
+		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
+		return 0;
+	}
 
-	return 0;
+	return 1;
 }
 
 static inline int get_ibs_offset(void)
