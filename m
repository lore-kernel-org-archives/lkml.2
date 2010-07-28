Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0G1X2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:48388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab0G1X2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:28:36 -0400
Date: Wed, 28 Jul 2010 23:28:19 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1280336972-865982-3-git-send-email-hans.rosenfeld@amd.com>
References: <1280336972-865982-3-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Use AMD errata checking framework for erratum 383
Message-ID: <tip-1be85a6d93f4207d8c2c6238c4a96895e28cefba@git.kernel.org>
Git-Commit-ID: 1be85a6d93f4207d8c2c6238c4a96895e28cefba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 23:28:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1be85a6d93f4207d8c2c6238c4a96895e28cefba
Gitweb:     http://git.kernel.org/tip/1be85a6d93f4207d8c2c6238c4a96895e28cefba
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 28 Jul 2010 19:09:32 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 28 Jul 2010 13:12:31 -0700

x86, cpu: Use AMD errata checking framework for erratum 383

Use the AMD errata checking framework instead of open-coding the test.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1280336972-865982-3-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/amd.c        |    2 ++
 arch/x86/kvm/svm.c               |    3 +--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eebdc1f..d85637b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -1029,6 +1029,7 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
  * AMD errata checking
  */
 #ifdef CONFIG_CPU_SUP_AMD
+extern const int amd_erratum_383[];
 extern const int amd_erratum_400[];
 extern bool cpu_has_amd_erratum(const int *);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a62a4ae..30f30dc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -632,6 +632,8 @@ const int amd_erratum_400[] =
 	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 
+const int amd_erratum_383[] =
+	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
 bool cpu_has_amd_erratum(const int *erratum)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ce438e0..03b534b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -383,8 +383,7 @@ static void svm_init_erratum_383(void)
 	int err;
 	u64 val;
 
-	/* Only Fam10h is affected */
-	if (boot_cpu_data.x86 != 0x10)
+	if (!cpu_has_amd_erratum(amd_erratum_383))
 		return;
 
 	/* Use _safe variants to not break nested virtualization */
