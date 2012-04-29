Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2D2Nzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:55:39 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36969 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2D2Nzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:55:38 -0400
Date: Sun, 29 Apr 2012 15:55:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 1/3] x86/tlb_info: get last level TLB entry number of CPU
Message-ID: <20120429135529.GA2713@aftab.osrc.amd.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
 <1335603099-2624-2-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335603099-2624-2-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 04:51:37PM +0800, Alex Shi wrote:
> For 4KB pages, x86 CPU has 2 or 1 level TLB, first level is data TLB and
> instruction TLB, second level is shared TLB for both data and instructions.
> 
> For hupe page TLB, usually there is just one level and seperated by 2MB/4MB
> and 1GB.
> 
> Although each levels TLB size is important for performance tuning, but for
> genernal and rude optimizing, just last level TLB entry number is suitable.
> And in fact, last level TLB has the biggest entry number.
> 
> This patch will get the biggest TLB entry number and use it in furture TLB
> optimizing.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  arch/x86/include/asm/processor.h |   12 +++
>  arch/x86/kernel/cpu/common.c     |  163 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/cpu.h        |    1 +
>  3 files changed, 176 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 4fa7dcc..a91504b 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -61,6 +61,18 @@ static inline void *current_text_addr(void)
>  # define ARCH_MIN_MMSTRUCT_ALIGN	0
>  #endif
>  
> +enum tlb_infos {
> +	ENTRIES,
> +	/* ASS_WAYS, */

We don't need associativity?

> +	NR_INFO
> +};
> +
> +extern u16 __read_mostly tlb_lli_4k[NR_INFO];
> +extern u16 __read_mostly tlb_lli_2m[NR_INFO];
> +extern u16 __read_mostly tlb_lli_4m[NR_INFO];
> +extern u16 __read_mostly tlb_lld_4k[NR_INFO];
> +extern u16 __read_mostly tlb_lld_2m[NR_INFO];
> +extern u16 __read_mostly tlb_lld_4m[NR_INFO];

[..]

> +void __cpuinit cpu_detect_tlb_sizes()
> +{
> +	int i, j, n;
> +	unsigned int regs[4];
> +	unsigned char *desc = (unsigned char *)regs;
> +
> +	/* Number of times to iterate */
> +	n = cpuid_eax(2) & 0xFF;
> +
> +	for (i = 0 ; i < n ; i++) {
> +		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);

Ok, getting TLB sizes on AMD is easier :), see dirty patch below.

Also, there's cpuinfo_x86.x86_tlbsize which is L1 iTLB + L1 dTLB 4K
entries. The tlb sizes below could probably be integrated/cached there
too if this proves to bring some speedup.

But initial testing looks good:

This is Linus' git from today:

my pid is 2798 n=32 l=1024 p=512 t=1
get 256K pages with one byte writing uses 689ms, 2629ns/time
mprotect use 71ms 2178ns/time, 14103 times/thread/ms, cost 70ns/time
my pid is 2800 n=32 l=1024 p=512 t=2
get 256K pages with one byte writing uses 686ms, 2620ns/time
mprotect use 82ms 2508ns/time, 14272 times/thread/ms, cost 70ns/time
my pid is 2803 n=32 l=1024 p=512 t=4
get 256K pages with one byte writing uses 686ms, 2620ns/time
mprotect use 102ms 3120ns/time, 15332 times/thread/ms, cost 65ns/time
my pid is 2808 n=32 l=1024 p=512 t=8
get 256K pages with one byte writing uses 686ms, 2617ns/time
mprotect use 142ms 4350ns/time, 16930 times/thread/ms, cost 59ns/time
my pid is 2817 n=32 l=1024 p=512 t=16
get 256K pages with one byte writing uses 671ms, 2562ns/time
mprotect use 226ms 6925ns/time, 20508 times/thread/ms, cost 48ns/time
my pid is 2834 n=32 l=1024 p=512 t=32
get 256K pages with one byte writing uses 679ms, 2593ns/time
mprotect use 497ms 15182ns/time, 31891 times/thread/ms, cost 31ns/time
my pid is 2867 n=32 l=1024 p=512 t=64
get 256K pages with one byte writing uses 675ms, 2575ns/time
mprotect use 394ms 12031ns/time, 12727 times/thread/ms, cost 78ns/time
my pid is 2932 n=32 l=1024 p=512 t=128
get 256K pages with one byte writing uses 680ms, 2597ns/time
mprotect use 1425ms 43506ns/time, 11718 times/thread/ms, cost 85ns/time

and this is with your patches ontop:

my pid is 2817 n=32 l=1024 p=512 t=1
get 256K pages with one byte writing uses 680ms, 2597ns/time
mprotect use 120ms 3691ns/time, 35043 times/thread/ms, cost 28ns/time
my pid is 2819 n=32 l=1024 p=512 t=2
get 256K pages with one byte writing uses 678ms, 2588ns/time
mprotect use 133ms 4079ns/time, 36233 times/thread/ms, cost 27ns/time
my pid is 2822 n=32 l=1024 p=512 t=4
get 256K pages with one byte writing uses 675ms, 2578ns/time
mprotect use 162ms 4953ns/time, 38283 times/thread/ms, cost 26ns/time
my pid is 2827 n=32 l=1024 p=512 t=8
get 256K pages with one byte writing uses 680ms, 2593ns/time
mprotect use 243ms 7425ns/time, 42101 times/thread/ms, cost 23ns/time
my pid is 2836 n=32 l=1024 p=512 t=16
get 256K pages with one byte writing uses 673ms, 2570ns/time
mprotect use 356ms 10869ns/time, 45748 times/thread/ms, cost 21ns/time
my pid is 2853 n=32 l=1024 p=512 t=32
get 256K pages with one byte writing uses 667ms, 2545ns/time
mprotect use 460ms 14063ns/time, 35435 times/thread/ms, cost 28ns/time
my pid is 2886 n=32 l=1024 p=512 t=64
get 256K pages with one byte writing uses 672ms, 2564ns/time
mprotect use 1298ms 39641ns/time, 23971 times/thread/ms, cost 41ns/time
my pid is 2951 n=32 l=1024 p=512 t=128
get 256K pages with one byte writing uses 673ms, 2567ns/time
mprotect use 2682ms 81873ns/time, 12956 times/thread/ms, cost 77ns/time

and I definitely like those numbers.

So, assuming others don't have a problem with this approach, I like
this. Haven't looked at the other two patches yet though.

> +
> +		/* If bit 31 is set, this is an unknown format */
> +		for (j = 0 ; j < 3 ; j++)
> +			if (regs[j] & (1 << 31))
> +				regs[j] = 0;
> +
> +		/* Byte 0 is level count, not a descriptor */
> +		for (j = 1 ; j < 16 ; j++)
> +			tlb_lookup(desc[j]);
> +	}
> +	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
> +		"Last level dTLB entires: 4KB %d, 2MB %d, 4MB %d\n",

I'm sure you mean "entries" :-)

> +		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
> +		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
> +		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
> +}
> +
>  void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_X86_HT
> @@ -911,6 +1072,8 @@ void __init identify_boot_cpu(void)
>  #else
>  	vgetcpu_set_mode();
>  #endif
> +	if (boot_cpu_data.cpuid_level >= 2)
> +		cpu_detect_tlb_sizes();
>  }
>  
>  void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index 8bacc78..a102ed1 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -34,4 +34,5 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
>  
>  extern void get_cpu_cap(struct cpuinfo_x86 *c);
>  extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
> +extern void cpu_detect_tlb_sizes(void);
>  #endif /* ARCH_X86_CPU_H */
> -- 

Thanks.

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Sun, 29 Apr 2012 15:23:36 +0200
Subject: [PATCH 2/4] x86: Add AMD TLB size detection

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/common.c |   47 +++++++++++++++++++++++++++++-------------
 arch/x86/kernel/cpu/cpu.h    |    2 +-
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5f14a700a665..9609fa74cfaf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -585,29 +585,48 @@ void tlb_lookup(const unsigned char desc)
 		break;
 	}
 }
-void __cpuinit cpu_detect_tlb_sizes()
+void __cpuinit cpu_detect_tlb_sizes(struct cpuinfo_x86 *c)
 {
 	int i, j, n;
 	unsigned int regs[4];
 	unsigned char *desc = (unsigned char *)regs;
 
-	/* Number of times to iterate */
-	n = cpuid_eax(2) & 0xFF;
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		cpuid(0x80000006, &regs[0], &regs[1], &regs[2], &regs[3]);
 
-	for (i = 0 ; i < n ; i++) {
-		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
+		tlb_lld_2m[ENTRIES] = tlb_lld_4m[ENTRIES] = (regs[0] >> 16) & 0xfff;
+		tlb_lli_2m[ENTRIES] = tlb_lli_4m[ENTRIES] = regs[0] & 0xfff;
+		tlb_lld_4k[ENTRIES] = (regs[1] >> 16) & 0xfff;
+		tlb_lli_4k[ENTRIES] =  regs[1] & 0xfff;
 
-		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
-			if (regs[j] & (1 << 31))
-				regs[j] = 0;
+		/* if any of the L2 TLBs are disabled, use L1 */
+		cpuid(0x80000005, &regs[0], &regs[1], &regs[2], &regs[3]);
 
-		/* Byte 0 is level count, not a descriptor */
-		for (j = 1 ; j < 16 ; j++)
-			tlb_lookup(desc[j]);
+		if (!tlb_lld_2m[ENTRIES])
+			tlb_lld_2m[ENTRIES] = tlb_lld_4m[ENTRIES] = (regs[0] >> 16) & 0xff;
+
+		if (!tlb_lli_2m[ENTRIES])
+			tlb_lli_2m[ENTRIES] = tlb_lli_4m[ENTRIES] = regs[0] & 0xff;
+	} else if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/* Number of times to iterate */
+		n = cpuid_eax(2) & 0xFF;
+
+		for (i = 0 ; i < n ; i++) {
+			cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
+
+			/* If bit 31 is set, this is an unknown format */
+			for (j = 0 ; j < 3 ; j++)
+				if (regs[j] & (1 << 31))
+					regs[j] = 0;
+
+			/* Byte 0 is level count, not a descriptor */
+			for (j = 1 ; j < 16 ; j++)
+				tlb_lookup(desc[j]);
+		}
 	}
+
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
-		"Last level dTLB entires: 4KB %d, 2MB %d, 4MB %d\n",
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
 		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
@@ -1073,7 +1092,7 @@ void __init identify_boot_cpu(void)
 	vgetcpu_set_mode();
 #endif
 	if (boot_cpu_data.cpuid_level >= 2)
-		cpu_detect_tlb_sizes();
+		cpu_detect_tlb_sizes(&boot_cpu_data);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index a102ed1c8eca..01469b6dace1 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -34,5 +34,5 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
-extern void cpu_detect_tlb_sizes(void);
+extern void cpu_detect_tlb_sizes(struct cpuinfo_x86 *c);
 #endif /* ARCH_X86_CPU_H */
-- 
1.7.9.3.362.g71319

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
