Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DAXFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:05:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23089 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1DAXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:05:42 -0400
Message-ID: <4D965A08.2080203@kernel.org>
Date: Fri, 01 Apr 2011 16:04:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net>	<20110331090524.07ad0069@xenia.leun.net>	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>	<201103312348.53678.rjw@sisk.pl>	<4D94FE37.8070109@kernel.org>	<alpine.DEB.2.00.1104011230550.16492@kaball-desktop>	<4D95F80D.7070201@kernel.org>	<4D95FBDD.9050901@zytor.com>	<alpine.DEB.2.00.1104011729000.16492@kaball-desktop>	<4D961FBC.2030105@zytor.com>	<4D962837.2070300@kernel.org>	<4D96294B.5050909@zytor.com>	<4D962D72.2010501@kernel.org>	<4D9633E7.1010707@zytor.com>	<AANLkTi=VzMh84szSBNujVU8oLZfzQd_z2bg+O3K_8GMd@mail.gmail.com>	<4D9643F1.1090807@zytor.com> <AANLkTimd22epcYvZRrvP5p3CzArpnR3To_mKCjdKKuf8@mail.gmail.com> <4D9646C6.7060301@zytor.com>
In-Reply-To: <4D9646C6.7060301@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D965A1A.0041,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 02:42 PM, H. Peter Anvin wrote:
>
> And why on Earth is it worth saving a couple of instructions (and
> introducing code ugliness and a more complex testing matrix) in the case
> when it is not?

Please check this one, it moves storing mmu_cr4 to arch_prepare_suspend.

Thanks

Yinghai

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

[PATCH -v5] x86: Save cr4 to mmu_cr4_features at boot time

Save cr4 to mmu_cr4_features at boot time

Michael reported 2.6.38.2 hibernation is broken by one backported patch.
it cause a freeze when resuming from hibernation

| "x86: Cleanup highmap after brk is concluded"
| commit id e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.

it turns out the mmu_cr4 save it lost somehow.

-v3: read back cr4 for 32bit too according to HPA
-v4: use cpuid_level to check if we can read cr4 according to HPA
      don't touch mmu_cr4_features if CONFIG_HIBERNATION is defined from Yinghai
-v5: reduce the using of CONFIG_HIBERNATION

Bisected-and-tested-by: Michael Leun <lkml20101129@newton.leun.net>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
  arch/x86/include/asm/processor.h  |    2 --
  arch/x86/include/asm/suspend_32.h |    2 +-
  arch/x86/include/asm/suspend_64.h |    5 +----
  arch/x86/kernel/setup.c           |   16 +++++++++++++++-
  4 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -212,12 +212,26 @@ struct cpuinfo_x86 boot_cpu_data __read_
  EXPORT_SYMBOL(boot_cpu_data);
  #endif
  
-
+/*
+ * mmu_cr4_features has two purposes:
+ *  a. head_32.S will access cr4 according if X86_CR4_PAE is set in it.
+ *  b. store read back cr4 for hibernation
+ */
  #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
  unsigned long mmu_cr4_features;
  #else
  unsigned long mmu_cr4_features = X86_CR4_PAE;
  #endif
+#ifdef CONFIG_HIBERNATION
+int arch_prepare_suspend(void)
+{
+	/* a CPU has CR4 iff it has CPUID --- hpa */
+	if (boot_cpu_data.cpuid_level >= 0)
+		mmu_cr4_features = read_cr4();
+
+	return 0;
+}
+#endif
  
  /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
  int bootloader_type, bootloader_version;
Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -601,7 +601,6 @@ static inline void set_in_cr4(unsigned l
  {
  	unsigned long cr4;
  
-	mmu_cr4_features |= mask;
  	cr4 = read_cr4();
  	cr4 |= mask;
  	write_cr4(cr4);
@@ -611,7 +610,6 @@ static inline void clear_in_cr4(unsigned
  {
  	unsigned long cr4;
  
-	mmu_cr4_features &= ~mask;
  	cr4 = read_cr4();
  	cr4 &= ~mask;
  	write_cr4(cr4);
Index: linux-2.6/arch/x86/include/asm/suspend_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/suspend_32.h
+++ linux-2.6/arch/x86/include/asm/suspend_32.h
@@ -9,7 +9,7 @@
  #include <asm/desc.h>
  #include <asm/i387.h>
  
-static inline int arch_prepare_suspend(void) { return 0; }
+int arch_prepare_suspend(void);
  
  /* image of the saved processor state */
  struct saved_context {
Index: linux-2.6/arch/x86/include/asm/suspend_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/suspend_64.h
+++ linux-2.6/arch/x86/include/asm/suspend_64.h
@@ -9,10 +9,7 @@
  #include <asm/desc.h>
  #include <asm/i387.h>
  
-static inline int arch_prepare_suspend(void)
-{
-	return 0;
-}
+int arch_prepare_suspend(void);
  
  /*
   * Image of the saved processor state, used by the low level ACPI suspend to
