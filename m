Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0DAV4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:56:50 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:36512 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0DAV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:56:48 -0400
Date: Thu, 1 Apr 2010 14:54:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH -v2] ibft, x86: Change reserve_ibft_region() to
 find_ibft_region()
Message-Id: <20100401145448.31e56d0e.randy.dunlap@oracle.com>
In-Reply-To: <4BB510FB.80601@kernel.org>
References: <4BB3FFE4.4010909@kernel.org>
	<4BB510FB.80601@kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BB51659.00B6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Apr 2010 14:32:43 -0700 Yinghai Lu wrote:

> 
> 
> So arch code could decide the way to reserve the ibft.
> 
> And We should reserve ibft as early as possible, instead of BOOTMEM stage,
> in case the table is in RAM range and is not reserved by BIOS.
> 
> move that just sfter find_smp_config()
> 
> Also when CONFIG_NO_BOOTMEM=y, We will not have reserve_bootmem() anymorea
> 
> -v2: fix typo about ibft pointed by Konrad Rzeszutek Wilk <konrad@darnok.org>


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> CC: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/setup.c            |   14 ++++++++++++--
>  drivers/firmware/iscsi_ibft_find.c |   11 ++++++++---
>  include/linux/iscsi_ibft.h         |    8 ++++++--
>  3 files changed, 26 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -608,6 +608,16 @@ static int __init setup_elfcorehdr(char
>  early_param("elfcorehdr", setup_elfcorehdr);
>  #endif
>  
> +static __init void reserve_ibft_region(void)
> +{
> +	unsigned long addr, size = 0;
> +
> +	addr = find_ibft_region(&size);
> +
> +	if (size)
> +		reserve_early_overlap_ok(addr, addr + size, "ibft");

	where is the correction?


> +}
> +
>  #ifdef CONFIG_X86_RESERVE_LOW_64K
>  static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
>  {
> @@ -910,6 +920,8 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	find_smp_config();
>  
> +	reserve_ibft_region();
> +
>  	reserve_trampoline_memory();
>  
>  #ifdef CONFIG_ACPI_SLEEP
> @@ -977,8 +989,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  	dma32_reserve_bootmem();
>  
> -	reserve_ibft_region();
> -
>  #ifdef CONFIG_KVM_CLOCK
>  	kvmclock_init();
>  #endif
> Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL_GPL(ibft_addr);
>   * Routine used to find the iSCSI Boot Format Table. The logical
>   * kernel address is set in the ibft_addr global variable.
>   */
> -void __init reserve_ibft_region(void)
> +unsigned long __init find_ibft_region(unsigned long *sizep)
>  {
>  	unsigned long pos;
>  	unsigned int len = 0;
> @@ -78,6 +78,11 @@ void __init reserve_ibft_region(void)
>  			}
>  		}
>  	}
> -	if (ibft_addr)
> -		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
> +	if (ibft_addr) {
> +		*sizep = PAGE_ALIGN(len);
> +		return pos;
> +	}
> +
> +	*sizep = 0;
> +	return 0;
>  }
> Index: linux-2.6/include/linux/iscsi_ibft.h
> ===================================================================
> --- linux-2.6.orig/include/linux/iscsi_ibft.h
> +++ linux-2.6/include/linux/iscsi_ibft.h
> @@ -42,9 +42,13 @@ extern struct ibft_table_header *ibft_ad
>   * mapped address is set in the ibft_addr variable.
>   */
>  #ifdef CONFIG_ISCSI_IBFT_FIND
> -extern void __init reserve_ibft_region(void);
> +unsigned long find_ibft_region(unsigned long *sizep);
>  #else
> -static inline void reserve_ibft_region(void) { }
> +static inline unsigned long find_ibft_region(unsigned long *sizep)
> +{
> +	*sizep = 0;
> +	return 0;
> +}
>  #endif
>  
>  #endif /* ISCSI_IBFT_H */
> --


---
~Randy
