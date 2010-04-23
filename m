Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0DWXwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:52:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:43365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab0DWXwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:52:22 -0400
Date: Fri, 23 Apr 2010 23:52:00 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, colin.king@canonical.com, tglx@linutronix.de,
       hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, colin.king@canonical.com, tglx@linutronix.de,
       hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
References: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Disable large pages on CPUs with Atom erratum AAE44
Message-ID: <tip-7a0fc404ae663776e96db43879a0fa24fec1fa3a@git.kernel.org>
Git-Commit-ID: 7a0fc404ae663776e96db43879a0fa24fec1fa3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 23:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a0fc404ae663776e96db43879a0fa24fec1fa3a
Gitweb:     http://git.kernel.org/tip/7a0fc404ae663776e96db43879a0fa24fec1fa3a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 13 Apr 2010 14:40:54 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 23 Apr 2010 16:49:51 -0700

x86: Disable large pages on CPUs with Atom erratum AAE44

Atom erratum AAE44/AAF40/AAG38/AAH41:

"If software clears the PS (page size) bit in a present PDE (page
directory entry), that will cause linear addresses mapped through this
PDE to use 4-KByte pages instead of using a large page after old TLB
entries are invalidated. Due to this erratum, if a code fetch uses
this PDE before the TLB entry for the large page is invalidated then
it may fetch from a different physical address than specified by
either the old large page translation or the new 4-KByte page
translation. This erratum may also cause speculative code fetches from
incorrect addresses."

[http://download.intel.com/design/processor/specupdt/319536.pdf]

Where as commit 211b3d03c7400f48a781977a50104c9d12f4e229 seems to
workaround errata AAH41 (mixed 4K TLBs) it reduces the window of
opportunity for the bug to occur and does not totally remove it.  This
patch disables mixed 4K/4MB page tables totally avoiding the page
splitting and not tripping this processor issue.

This is based on an original patch by Colin King.

Originally-by: Colin Ian King <colin.king@canonical.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/cpu/intel.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7e1cca1..1366c7c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -47,6 +47,27 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+	/*
+	 * Atom erratum AAE44/AAF40/AAG38/AAH41:
+	 *
+	 * A race condition between speculative fetches and invalidating
+	 * a large page.  This is worked around in microcode, but we
+	 * need the microcode to have already been loaded... so if it is
+	 * not, recommend a BIOS update and disable large pages.
+	 */
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
+		u32 ucode, junk;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		sync_core();
+		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
+
+		if (ucode < 0x20e) {
+			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
+			clear_cpu_cap(c, X86_FEATURE_PSE);
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 #else
