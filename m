Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0GNQHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:07:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45399
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab0GNQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:07:14 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz1432N936eM8b9cnzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5K23P-01-8V8-02
X-M-MSG: 
Date: Wed, 14 Jul 2010 18:07:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Michal Schmidt <mschmidt@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100714160704.GA10473@kryptos.osrc.amd.com>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100713185957.2866.50995.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>
Date: Tue, Jul 13, 2010 at 08:59:58PM +0200

Hi,

> On my system with AMD Phenom II X6 I am seeing pauses at boot (usually during
> udev startup) which require a key press to continue. It only happens if C1E is
> enabled in the BIOS.
> 
> It's caused by the APIC timer's inability to wake up the CPU from C1E (AMD
> erratum #400). Linux has a workaround for it, but it's not being applied
> correctly in this case. Though c1e_idle() detects C1E just fine, by the time
> acpi_idle ('processor.ko' module) takes over, it is forgotten.
> 
> After AMD C1E is detected, it is not sufficient to flag it in boot_cpu_data,
> because the flag will get cleared in identify_cpu() when more CPUs are brought
> up later. The fix is to mark the flag as forced.

I don't think that the workaround is wrong, assuming I'm not missing
something. I'm seeing the following sequence on my machine here in which
the cores are brought up and checked for c1e:

The BSP does

start_kernel()
|->check_bugs()
   |->identify_boot_cpu() 	# here we do select_idle_routine(), i.e. pm_idle = c1e_idle
...
|->rest_init()
   |->kernel_thread(kernel_init,... )

and kernel_init() does smp_init() where we init the rest of the cores.

Now, each core does

start_secondary()
|->smp_callin()
   |->smp_store_cpu_info	# here we copy boot_cpu_data for the starting AP
     |->identify_secondary_cpu
        |->identify_cpu
	   |->select_idle_routine() # here we exit early since pm_idle is set already


now all the cores except the BSP do cpu_idle but since bits 27,28 in the
int pending MSR (see below) are not set yet, they spin a bit in cpu_idle
doing default_idle. You can see this with my debugging patch below.

Now here comes the key moment - the BSP enters cpu_idle _after_ all APs
have been initialized and does set X86_FEATURE_AMDC1E. We haven't set
the c1e_detected variable earlier since the hardware sets bit 28 in
MSR_K8_INT_PENDING_MSG, C1eOnCmpHalt only after all cores have entered
halt. After this bit is set, we set c1e_detected and switch to broadcast
mode on each core.

Now the question is, why does your system doesn't do that in that order?
And I don't think your patch is the right fix - it doesn't change
anything in the above sequence on my system except enabling the "amdc1e"
feature string in /proc/cpuinfo which we don't need actually since dmesg
already contains that info.

And the more puzzling question is, how does your patch fix your
system...?

So, IMHO, what is more likely is that it has something to do with
https://bugzilla.kernel.org/show_bug.cgi?id=15289, as John pointed out
earlier (thanks John, Michal's situation looks quite similar).

So, please apply the debug patch below and send me your whole dmesg to
see what happens. Also, I'd like to see whether the SMI bit (27) in that
same MSR is set so please do when the machine is up

for i in $(seq 0 5); do lsmsr -c $i Int -V 3; done

after installing the x86info tool.

Thanks.

C1E dbg patch:

---
 arch/x86/include/asm/acpi.h |   11 +++++++++--
 arch/x86/kernel/process.c   |   12 ++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index aa2c39d..39b8348 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -123,6 +123,9 @@ extern void acpi_reserve_wakeup_memory(void);
  */
 static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 {
+
+	pr_err("%s: enter\n", __func__);
+
 	/*
 	 * Early models (<=5) of AMD Opterons are not supposed to go into
 	 * C2 state.
@@ -134,10 +137,14 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
-	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	else if (boot_cpu_has(X86_FEATURE_AMDC1E)) {
+		pr_err("%s: C1E\n", __func__);
 		return 1;
-	else
+	}
+	else {
+		pr_err("%s: max_cstate: %d\n", __func__, max_cstate);
 		return max_cstate;
+	}
 }
 
 static inline bool arch_has_acpi_pdc(void)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cfe109d..116c8bd 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -573,6 +573,18 @@ static void c1e_idle(void)
 	if (need_resched())
 		return;
 
+	if (!boot_cpu_has(X86_FEATURE_AMDC1E)) {
+		u32 lo, hi;
+
+		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
+		pr_err("%s: bits 0x%08x\n",
+			__func__, lo & K8_INTP_C1E_ACTIVE_MASK);
+
+		pr_err("%s: cpu: %d, c1e_detected: %d\n",
+			__func__, raw_smp_processor_id(), c1e_detected);
+	}
+
 	if (!c1e_detected) {
 		u32 lo, hi;
 
-- 
1.7.0



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

