Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1DSBCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:02:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55151 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DSBCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:02:13 -0400
Date: Tue, 19 Apr 2011 01:02:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-d8d9766c8c29f71c37bc4b74cc9fcf6a192c9bfd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tj@kernel.org,
        tglx@linutronix.de, jbaron@redhat.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tj@kernel.org,
        tglx@linutronix.de, jbaron@redhat.com, hpa@linux.intel.com
In-Reply-To: <1303166160-10315-4-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-4-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Change NOP selection for certain Intel CPUs
Git-Commit-ID: d8d9766c8c29f71c37bc4b74cc9fcf6a192c9bfd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 01:02:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d9766c8c29f71c37bc4b74cc9fcf6a192c9bfd
Gitweb:     http://git.kernel.org/tip/d8d9766c8c29f71c37bc4b74cc9fcf6a192c9bfd
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 18 Apr 2011 15:31:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 18 Apr 2011 16:40:32 -0700

x86, cpu: Change NOP selection for certain Intel CPUs

Due to a decoder implementation quirk, some specific Intel CPUs
actually perform better with the "k8_nops" than with the
SDM-recommended NOPs.  For runtime-selected NOPs, if we detect those
specific CPUs then use the k8_nops instead of the ones we would
normally use.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/r/1303166160-10315-4-git-send-email-hpa@linux.intel.com
---
 arch/x86/kernel/alternative.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 846f61e..c0501ea 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -199,7 +199,19 @@ void __init arch_init_ideal_nops(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (boot_cpu_has(X86_FEATURE_NOPL)) {
+		/*
+		 * Due to a decoder implementation quirk, some
+		 * specific Intel CPUs actually perform better with
+		 * the "k8_nops" than with the SDM-recommended NOPs.
+		 */
+		if (boot_cpu_data.x86 == 6 &&
+		    boot_cpu_data.x86_model >= 0x0f &&
+		    boot_cpu_data.x86_model != 0x1c &&
+		    boot_cpu_data.x86_model != 0x26 &&
+		    boot_cpu_data.x86_model != 0x27 &&
+		    boot_cpu_data.x86_model < 0x30) {
+			ideal_nops = k8_nops;
+		} else if (boot_cpu_has(X86_FEATURE_NOPL)) {
 			   ideal_nops = p6_nops;
 		} else {
 #ifdef CONFIG_X86_64
