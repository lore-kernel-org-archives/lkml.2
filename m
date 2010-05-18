Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0ERIVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:21:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64975 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0ERIVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oXx9/M9wq5lpqHSqIYbG7+o+XiF0r7ugTpkO/h9O890MPoHBBjQapgCTTo4DH6d5aA
         7T3ii8+qs5v4zoeebUSmcffHsm92Vq+43XwFIiR96gJ7u4XFJd+DsmPQfDUzLt4Aw83m
         UYrC9TFEQxcAkn3bTf0UtlHyzMHbgxyq/4TgM=
MIME-Version: 1.0
In-Reply-To: <20100517225426.GA1720@elte.hu>
References: <20100517225225.GA32562@elte.hu> <20100517225426.GA1720@elte.hu>
Date: Tue, 18 May 2010 13:51:15 +0530
Message-ID: <AANLkTilW6KptXsYtKDiPaYZPwQKkPR9L0CO2Nc-39TpA@mail.gmail.com>
Subject: Re: [GIT PULL, v2] x86/cpu changes for v2.6.35
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 18, 2010 at 4:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> Linus,
>>
>> Please pull the latest x86-cleanups-for-linus git tree from:
>
> Correction, the above URI is still the previous pull
> request - the one for x86-cleanups-for-linus is:
>
> Please pull the latest x86-cpu-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus
>
>
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index b3eeb66..33eae20 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -148,13 +148,19 @@ union _cpuid4_leaf_ecx {
>        u32 full;
>  };
>
> +struct amd_l3_cache {
> +       struct   pci_dev *dev;
> +       bool     can_disable;
> +       unsigned indices;
> +       u8       subcaches[4];
> +};
> +
>  struct _cpuid4_info {
>        union _cpuid4_leaf_eax eax;
>        union _cpuid4_leaf_ebx ebx;
>        union _cpuid4_leaf_ecx ecx;
>        unsigned long size;
> -       bool can_disable;
> -       unsigned int l3_indices;
> +       struct amd_l3_cache *l3;
>        DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
>  };
>
> @@ -164,8 +170,7 @@ struct _cpuid4_info_regs {
>        union _cpuid4_leaf_ebx ebx;
>        union _cpuid4_leaf_ecx ecx;
>        unsigned long size;
> -       bool can_disable;
> -       unsigned int l3_indices;
> +       struct amd_l3_cache *l3;
>  };
>
>  unsigned short                 num_cache_leaves;
> @@ -302,87 +307,163 @@ struct _cache_attr {
>  };
>
>  #ifdef CONFIG_CPU_SUP_AMD
> -static unsigned int __cpuinit amd_calc_l3_indices(void)
> +
> +/*
> + * L3 cache descriptors
> + */
> +static struct amd_l3_cache **__cpuinitdata l3_caches;
> +
> +static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
>  {
> -       /*
> -        * We're called over smp_call_function_single() and therefore
> -        * are on the correct cpu.
> -        */
> -       int cpu = smp_processor_id();
> -       int node = cpu_to_node(cpu);
> -       struct pci_dev *dev = node_to_k8_nb_misc(node);
>        unsigned int sc0, sc1, sc2, sc3;
>        u32 val = 0;
>
> -       pci_read_config_dword(dev, 0x1C4, &val);
> +       pci_read_config_dword(l3->dev, 0x1C4, &val);
>
>        /* calculate subcache sizes */
> -       sc0 = !(val & BIT(0));
> -       sc1 = !(val & BIT(4));
> -       sc2 = !(val & BIT(8))  + !(val & BIT(9));
> -       sc3 = !(val & BIT(12)) + !(val & BIT(13));
> +       l3->subcaches[0] = sc0 = !(val & BIT(0));
> +       l3->subcaches[1] = sc1 = !(val & BIT(4));
> +       l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
> +       l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
>
> -       return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
> +       l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
> +}
> +
> +static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
> +{
> +       struct amd_l3_cache *l3;
> +       struct pci_dev *dev = node_to_k8_nb_misc(node);
> +
> +       l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
> +       if (!l3) {
> +               printk(KERN_WARNING "Error allocating L3 struct\n");
> +               return NULL;
> +       }
> +
> +       l3->dev = dev;

This is still Buggy. You are not checking whether dev is NULL or not.
If dev is NULL you should return.

Thanks,
--
Jaswinder Singh.
