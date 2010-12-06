Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0LFRvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:51:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44993 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0LFRvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:51:47 -0500
Message-ID: <4CFD226C.60308@kernel.org>
Date: Mon, 06 Dec 2010 09:50:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        len.brown@intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com> <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org>
In-Reply-To: <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 07:01 AM, tip-bot for Feng Tang wrote:
> Commit-ID:  a6427a341985e0379060c86b50fcdb59883e4102
> Gitweb:     http://git.kernel.org/tip/a6427a341985e0379060c86b50fcdb59883e4102
> Author:     Feng Tang <feng.tang@intel.com>
> AuthorDate: Fri, 3 Dec 2010 12:11:58 +0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 6 Dec 2010 15:58:26 +0100
> 
> x86: Unify current 3 similar ways of saving IRQ info
> 
> There are 3 places defining the similar function of saving IRQ
> vector info into mp_irqs[] array: mmparse/acpi/mrst. This patch
> will reduce the redundant code, and make it only one API:
> 	void mp_save_irq(struct mpc_intsrc *m);
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Len Brown <len.brown@intel.com>
> LKML-Reference: <1291349518-3502-1-git-send-email-feng.tang@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/mpspec.h |    6 ++++++
>  arch/x86/kernel/acpi/boot.c   |   32 +++-----------------------------
>  arch/x86/kernel/mpparse.c     |   14 +++++++-------
>  arch/x86/platform/mrst/mrst.c |   30 ++----------------------------
>  4 files changed, 18 insertions(+), 64 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
> index c82868e..17f4314 100644
> --- a/arch/x86/include/asm/mpspec.h
> +++ b/arch/x86/include/asm/mpspec.h
> @@ -42,6 +42,12 @@ extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
>  
>  #endif /* CONFIG_X86_64 */
>  
> +#ifdef CONFIG_X86_IO_APIC
> +void mp_save_irq(struct mpc_intsrc *m);
> +#else
> +static inline void mp_save_irq(struct mpc_intsrc *m) {}
> +#endif
> +
>  #if defined(CONFIG_MCA) || defined(CONFIG_EISA)
>  extern int mp_bus_id_to_type[MAX_MP_BUSSES];
>  #endif
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 71232b9..006f896 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -949,32 +949,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
>  extern int es7000_plat;
>  #endif
>  
> -static void assign_to_mp_irq(struct mpc_intsrc *m,
> -				    struct mpc_intsrc *mp_irq)
> -{
> -	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
> -}
> -
> -static int mp_irq_cmp(struct mpc_intsrc *mp_irq,
> -				struct mpc_intsrc *m)
> -{
> -	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
> -}
> -
> -static void save_mp_irq(struct mpc_intsrc *m)
> -{
> -	int i;
> -
> -	for (i = 0; i < mp_irq_entries; i++) {
> -		if (!mp_irq_cmp(&mp_irqs[i], m))
> -			return;
> -	}
> -
> -	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
> -	if (++mp_irq_entries == MAX_IRQ_SOURCES)
> -		panic("Max # of irq sources exceeded!!\n");
> -}
> -
>  void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>  {
>  	int ioapic;
> @@ -1005,7 +979,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>  	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
>  	mp_irq.dstirq = pin;	/* INTIN# */
>  
> -	save_mp_irq(&mp_irq);
> +	mp_save_irq(&mp_irq);
>  
>  	isa_irq_to_gsi[bus_irq] = gsi;
>  }
> @@ -1080,7 +1054,7 @@ void __init mp_config_acpi_legacy_irqs(void)
>  		mp_irq.srcbusirq = i; /* Identity mapped */
>  		mp_irq.dstirq = pin;
>  
> -		save_mp_irq(&mp_irq);
> +		mp_save_irq(&mp_irq);
>  	}
>  }
>  
> @@ -1117,7 +1091,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
>  	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
>  	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
>  
> -	save_mp_irq(&mp_irq);
> +	mp_save_irq(&mp_irq);
>  #endif
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index 9af64d9..ecaa897 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -144,7 +144,7 @@ static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
>  		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
>  }
>  
> -static void __init assign_to_mp_irq(struct mpc_intsrc *m,
> +static void assign_to_mp_irq(struct mpc_intsrc *m,
>  				    struct mpc_intsrc *mp_irq)
>  {
>  	mp_irq->dstapic = m->dstapic;
> @@ -168,7 +168,7 @@ static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
>  	m->dstirq = mp_irq->dstirq;
>  }
>  
> -static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
> +static int mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
>  					struct mpc_intsrc *m)
>  {
>  	if (mp_irq->dstapic != m->dstapic)
> @@ -189,7 +189,8 @@ static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
>  	return 0;
>  }
>  
> -static void __init MP_intsrc_info(struct mpc_intsrc *m)
> +/* Will also be called in acpi/sfi related code */
> +void mp_save_irq(struct mpc_intsrc *m)
>  {
>  	int i;
>  
> @@ -207,7 +208,6 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
>  #else /* CONFIG_X86_IO_APIC */
>  static inline void __init MP_bus_info(struct mpc_bus *m) {}
>  static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
> -static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
>  #endif /* CONFIG_X86_IO_APIC */
>  
>  
> @@ -337,7 +337,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
>  			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
>  			break;
>  		case MP_INTSRC:
> -			MP_intsrc_info((struct mpc_intsrc *)mpt);
> +			mp_save_irq((struct mpc_intsrc *)mpt);
>  			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
>  			break;
>  		case MP_LINTSRC:
> @@ -429,13 +429,13 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
>  
>  		intsrc.srcbusirq = i;
>  		intsrc.dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
> -		MP_intsrc_info(&intsrc);
> +		mp_save_irq(&intsrc);
>  	}
>  
>  	intsrc.irqtype = mp_ExtINT;
>  	intsrc.srcbusirq = 0;
>  	intsrc.dstirq = 0;	/* 8259A to INTIN0 */
> -	MP_intsrc_info(&intsrc);
> +	mp_save_irq(&intsrc);
>  }

it breaks compiling when CONFIG_X86_MPPARSE is not defined.

obj-$(CONFIG_X86_MPPARSE)       += mpparse.o


config X86_MPPARSE              
        bool "Enable MPS table" if ACPI
        default y
        depends on X86_LOCAL_APIC
        ---help---              
          For old smp systems that do not have proper acpi support. Newer systems
          (esp with 64bit cpus) with acpi support, MADT and DSDT will override it



Yinghai
