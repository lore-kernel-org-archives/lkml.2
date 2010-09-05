Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0IES7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:59:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35465 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0IES7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:59:36 -0400
From: Julia Lawall <julia@diku.dk>
To: Dave Jones <davej@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] arch/x86/kernel/cpu/cpufreq: Fix unsigned return type
Date: Sun,  5 Sep 2010 21:00:20 +0200
Message-Id: <1283713226-8429-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283713226-8429-1-git-send-email-julia@diku.dk>
References: <1283713226-8429-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each case, the function has an unsigned return type, but returns a
negative constant to indicate an error condition.  Each function is only
called once.  For nforce2_detect_chipset, the result is only compared to 0,
and for longrun_determine_freqs, the result is stored in a variable of type
(signed) int.  Thus, for both functions, unsigned can be dropped from the
return type.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |    2 +-
 arch/x86/kernel/cpu/cpufreq/longrun.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index 733093d..141abeb 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -393,7 +393,7 @@ static struct cpufreq_driver nforce2_driver = {
  * Detects nForce2 A2 and C1 stepping
  *
  */
-static unsigned int nforce2_detect_chipset(void)
+static int nforce2_detect_chipset(void)
 {
 	nforce2_dev = pci_get_subsys(PCI_VENDOR_ID_NVIDIA,
 					PCI_DEVICE_ID_NVIDIA_NFORCE2,
diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c b/arch/x86/kernel/cpu/cpufreq/longrun.c
index fc09f14..77945bf 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -165,7 +165,7 @@ static unsigned int longrun_get(unsigned int cpu)
  * TMTA rules:
  * performance_pctg = (target_freq - low_freq)/(high_freq - low_freq)
  */
-static unsigned int __cpuinit longrun_determine_freqs(unsigned int *low_freq,
+static int __cpuinit longrun_determine_freqs(unsigned int *low_freq,
 						      unsigned int *high_freq)
 {
 	u32 msr_lo, msr_hi;

