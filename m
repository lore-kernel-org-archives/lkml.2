Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0DVTsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:48:52 -0400
Received: from kroah.org ([198.145.64.141]:41055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab0DVT25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:57 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.107862583@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [109/197] x86, lib: Add wbinvd smp helpers
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit a7b480e7f30b3813353ec009f10f2ac7a6669f3b upstream.

Add wbinvd_on_cpu and wbinvd_on_all_cpus stubs for executing wbinvd on a
particular CPU.

[ hpa: renamed lib/smp.c to lib/cache-smp.c ]
[ hpa: wbinvd_on_all_cpus() returns int, but wbinvd() returns
  void.  Thus, the former cannot be a macro for the latter,
  replace with an inline function. ]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-2-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/smp.h |    9 +++++++++
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/cache-smp.c   |   19 +++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -135,6 +135,8 @@ int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
+void wbinvd_on_cpu(int cpu);
+int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
@@ -147,6 +149,13 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+#else /* !CONFIG_SMP */
+#define wbinvd_on_cpu(cpu)     wbinvd()
+static inline int wbinvd_on_all_cpus(void)
+{
+	wbinvd();
+	return 0;
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for x86 specific library files.
 #
 
-obj-$(CONFIG_SMP) += msr-smp.o
+obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
--- /dev/null
+++ b/arch/x86/lib/cache-smp.c
@@ -0,0 +1,19 @@
+#include <linux/smp.h>
+#include <linux/module.h>
+
+static void __wbinvd(void *dummy)
+{
+	wbinvd();
+}
+
+void wbinvd_on_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_cpu);
+
+int wbinvd_on_all_cpus(void)
+{
+	return on_each_cpu(__wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_all_cpus);


