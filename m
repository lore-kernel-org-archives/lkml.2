Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KQOuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:50:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2KQOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:50:31 -0500
Date: Sat, 17 Nov 2012 15:50:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3, v2] AMD64 EDAC: Cleanup type usage to be consistent
Message-ID: <20121117145040.GH16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
 <1352095526-6522-3-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352095526-6522-3-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 02:05:26PM +0800, Daniel J Blueman wrote:
> As the Northbridge IDs are at most 16-bits, use the same type
> consistently and cleanup some indexes to use smaller types.
> 
> v2: Drop unneeded changes and changes Boris will cleanup later
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/include/asm/amd_nb.h    |    2 +-
>  arch/x86/include/asm/processor.h |    2 +-
>  arch/x86/kernel/cpu/amd.c        |    4 ++--
>  drivers/edac/amd64_edac.c        |   14 +++++++-------
>  drivers/edac/amd64_edac.h        |    6 +++---
>  5 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 9f5532a..b0815a0 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
>  	return ((amd_northbridges.flags & feature) == feature);
>  }
>  
> -static inline struct amd_northbridge *node_to_amd_nb(int node)
> +static inline struct amd_northbridge *node_to_amd_nb(u16 node)
>  {
>  	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>  }
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index ad1fc85..eb3ba58 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -934,7 +934,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
>  extern int get_tsc_mode(unsigned long adr);
>  extern int set_tsc_mode(unsigned int val);
>  
> -extern int amd_get_nb_id(int cpu);
> +extern u16 amd_get_nb_id(int cpu);

This is correct - this function actually returns cpu_llc_id which is
u16. However, other places in the kernel save the result in an int which
is not absolutely kosher but I guess this is ok since sizeof(int) >=
sizeof(u16) on x86.

Someone should probably go and fix the rest of the places where
amd_get_nb_id is being used when someone is bored :-).

>  struct aperfmperf {
>  	u64 aperf, mperf;
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f7e98a2..52cab1f 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -364,9 +364,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
>  #endif
>  }
>  
> -int amd_get_nb_id(int cpu)
> +u16 amd_get_nb_id(int cpu)
>  {
> -	int id = 0;
> +	u16 id = 0;
>  #ifdef CONFIG_SMP
>  	id = per_cpu(cpu_llc_id, cpu);
>  #endif
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 5dfe452..a3e297a 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
>   * DRAM base/limit associated with node_id
>   */
>  static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
> -				   unsigned nid)
> +				   u8 nid)
>  {
>  	u64 addr;
>  
> @@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
>  						u64 sys_addr)
>  {
>  	struct amd64_pvt *pvt;
> -	unsigned node_id;
> +	u8 node_id;
>  	u32 intlv_en, bits;
>  
>  	/*
> @@ -1349,7 +1349,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
>  }
>  
>  /* Convert the sys_addr to the normalized DCT address */
> -static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
> +static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
>  				 u64 sys_addr, bool hi_rng,
>  				 u32 dct_sel_base_addr)
>  {
> @@ -1400,7 +1400,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
>   * checks if the csrow passed in is marked as SPARED, if so returns the new
>   * spare row
>   */
> -static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
> +static int f10_process_possible_spare(struct amd64_pvt *pvt, u16 dct, int csrow)
>  {
>  	int tmp_cs;
>  
> @@ -1425,7 +1425,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
>   *	-EINVAL:  NOT FOUND
>   *	0..csrow = Chip-Select Row
>   */
> -static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
> +static int f1x_lookup_addr_in_dct(u64 in_addr, u16 nid, u8 dct)

This nid comes from dram_dst_node and it is

#define dram_dst_node(pvt, i)		((u8)(pvt->ranges[i].lim.lo & 0x7))

so nid is only three bits wide. It actually should be u8.

>  {
>  	struct mem_ctl_info *mci;
>  	struct amd64_pvt *pvt;
> @@ -2257,7 +2257,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  }
>  
>  /* get all cores on this DCT */
> -static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
> +static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
>  {
>  	int cpu;
>  
> @@ -2267,7 +2267,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
>  }
>  
>  /* check MCG_CTL on all the cpus on this node */
> -static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
> +static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
>  {
>  	cpumask_var_t mask;
>  	int cpu, nbe;
> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> index 90cae61..a2ea6a4 100644
> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -332,7 +332,7 @@ struct amd64_pvt {
>  	/* pci_device handles which we utilize */
>  	struct pci_dev *F1, *F2, *F3;
>  
> -	unsigned mc_node_id;	/* MC index of this MC node */
> +	u16 mc_node_id;		/* MC index of this MC node */
>  	int ext_model;		/* extended model value of this node */
>  	int channel_count;
>  
> @@ -368,7 +368,7 @@ struct amd64_pvt {
>  	struct error_injection injection;
>  };
>  
> -static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
> +static inline u64 get_dram_base(struct amd64_pvt *pvt, u8 i)
>  {
>  	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
>  
> @@ -378,7 +378,7 @@ static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
>  	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
>  }
>  
> -static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
> +static inline u64 get_dram_limit(struct amd64_pvt *pvt, u8 i)
>  {
>  	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
>  
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
Boris.
