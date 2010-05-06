Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0EFOSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:18:18 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:54620
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758631Ab0EFOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:18:11 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1dbaL1432Pab9bhzz1202hzz6ff19h6d525hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L204VR-01-BM6-02
X-M-MSG: 
Date: Thu, 6 May 2010 16:13:58 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Jiri Benc <jbenc@suse.cz>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
Message-ID: <20100506141358.GB20994@aftab>
References: <20100422190917.467545308@kvm.kroah.org>
 <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
 <20100505180228.GC15804@aftab>
 <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
 <20100506081721.GA20616@aftab>
 <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, May 06, 2010 at 09:46:21AM -0400

> Well, we have
> 
> 	#ifdef CONFIG_K8_NB
> 	static inline struct pci_dev *node_to_k8_nb_misc(int node)
> 	{
> 		return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
> 	}
> 	#else
> 	static inline struct pci_dev *node_to_k8_nb_misc(int node)
> 	{
> 		return NULL;
> 	}
> 	#endif
> 
> So it legitimately returns NULL in two cases:
> 
> 	1) if someone passes too large node
> 	2) if CONFIG_K8_NB is unset
> 
> 1) Either we assume that node will always be in the range (i.e. 
> amd_get_nb_id() will never go crazy return anything bogus), and then we 
> could just drop the test completely. Or we want to check for such the 
> possibility, and then node_to_k8_nb_misc() is going to return NULL in such 
> cases, and so we want to check for it.

No, we want to check it since K8_NB has many users - not only L3.

> 2) is now moot, as all three in-tree callers are now under proper ifdefs 
> (CONFIG_CPU_SUP_AMD, which depends on CONFIG_K8_NB after your patch has 
> been applied). So I believe we could remove it, right?

I don't think I understand "remove it" here. Which "it" you're referring to?

> Either way, current state seems inconsistent. So either we should add the 
> return value check to amd_calc_l3_indices() as well, or remove all the 
> NULL magic altogether, i.e. the (untested) patch below.
> 
> What do you think?

Take a look at 

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=f2b20e41407fccfcfacf927ff91ec888832a37af

This does

+       if (num_k8_northbridges == 0)
+               return;

in amd_check_l3_disable().

So if K8_NB has failed initializing for some reason, we never go near
the pci devs and the node_to_k8_nb_misc() calls since we effectively
disable the L3 functionality.

Thus the NULL pointer checks you remove in the patch below are
superfluous, I agree, and I have already removed those in my tree along
with the other improvements/fixes I'm working on right now.

> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: x86, cacheinfo: remove unnecessary NULL pointer checks
> 
> As K8_NB thing is now always initialized on AMD CPUs, and we don't have 
> any caller that would be outside CONFIG_CPU_SUP_AMD/CONFIG_K8_NB, it is 
> safe to assume that kb_northbridges has been always initialized).
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
>  arch/x86/include/asm/k8.h             |   10 +---------
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ------
>  2 files changed, 1 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> index f70e600..0cff8ba 100644
> --- a/arch/x86/include/asm/k8.h
> +++ b/arch/x86/include/asm/k8.h
> @@ -15,17 +15,9 @@ extern int k8_get_nodes(struct bootnode *nodes);
>  extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
>  extern int k8_scan_nodes(void);
>  
> -#ifdef CONFIG_K8_NB
>  static inline struct pci_dev *node_to_k8_nb_misc(int node)
>  {
> -	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
> +	return k8_northbridges[node];
>  }
> -#else
> -static inline struct pci_dev *node_to_k8_nb_misc(int node)
> -{
> -	return NULL;
> -}
> -#endif
> -
>  
>  #endif /* _ASM_X86_K8_H */
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index b3eeb66..6c5f3cd 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -355,9 +355,6 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
>  	if (!this_leaf->can_disable)
>  		return -EINVAL;
>  
> -	if (!dev)
> -		return -EINVAL;
> -
>  	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
>  	return sprintf(buf, "0x%08x\n", reg);
>  }
> @@ -388,9 +385,6 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	if (!dev)
> -		return -EINVAL;
> -
>  	if (strict_strtoul(buf, 10, &val) < 0)
>  		return -EINVAL;
>  
> 
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.
> 

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

