Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HSOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1HSOZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:25:27 -0400
Date: Fri, 19 Aug 2011 10:25:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, ebiederm@xmission.com,
        mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 2/2] kdump: Add size to elfcorehdr kernel parameter
Message-ID: <20110819142502.GG18656@redhat.com>
References: <20110819141857.052232873@linux.vnet.ibm.com>
 <20110819141940.335341157@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819141940.335341157@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 04:18:59PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently only the address of the pre-allocated ELF header is passed with
> the elfcorehdr= kernel parameter. In order to reserve memory for the header
> in the 2nd kernel also the size is required. Current kdump architecture
> backends use different methods to do that, e.g. x86 uses the memmap= kernel
> parameter. On s390 there is no easy way to transfer this information.
> Therefore the elfcorehdr kernel parameter is extended to also pass the size.
> This now can also be used as standard mechanism by all future kdump
> architecture backends.
> 
> The syntax of the kernel parameter is extended as follows:
> 
> elfcorehdr=[size[KMG]@]offset[KMG]
> 
> This change is backward compatible because elfcorehdr=size is still allowed.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  Documentation/kernel-parameters.txt |    6 +++---
>  include/linux/crash_dump.h          |    1 +
>  kernel/crash_dump.c                 |   11 +++++++++++
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -727,10 +727,10 @@ bytes respectively. Such letter suffixes
>  			See Documentation/block/as-iosched.txt and
>  			Documentation/block/deadline-iosched.txt for details.
>  
> -	elfcorehdr=	[IA-64,PPC,SH,X86]
> +	elfcorehdr=[size[KMG]@]offset[KMG] [IA64,PPC,SH,X86,S390]
>  			Specifies physical address of start of kernel core
> -			image elf header. Generally kexec loader will
> -			pass this option to capture kernel.
> +			image elf header and optionally the size. Generally
> +			kexec loader will pass this option to capture kernel.
>  			See Documentation/kdump/kdump.txt for details.
>  
>  	enable_mtrr_cleanup [X86]
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -10,6 +10,7 @@
>  #define ELFCORE_ADDR_ERR	(-2ULL)
>  
>  extern unsigned long long elfcorehdr_addr;
> +extern unsigned long long elfcorehdr_size;
>  
>  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
>  						unsigned long, int);
> --- a/kernel/crash_dump.c
> +++ b/kernel/crash_dump.c
> @@ -20,8 +20,15 @@ unsigned long saved_max_pfn;
>  unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
>  
>  /*
> + * stores the size of elf header of crash image
> + */
> +unsigned long long elfcorehdr_size;
> +
> +/*
>   * elfcorehdr= specifies the location of elf core header stored by the crashed
>   * kernel. This option will be passed by kexec loader to the capture kernel.
> + *
> + * Syntax: elfcorehdr=[size[KMG]@]offset[KMG]
>   */
>  static int __init setup_elfcorehdr(char *arg)
>  {
> @@ -29,6 +36,10 @@ static int __init setup_elfcorehdr(char
>  	if (!arg)
>  		return -EINVAL;
>  	elfcorehdr_addr = memparse(arg, &end);
> +	if (*end == '@') {
> +		elfcorehdr_size = elfcorehdr_addr;
> +		elfcorehdr_addr = memparse(end + 1, &end);
> +	}
>  	return end > arg ? 0 : -EINVAL;
>  }
>  early_param("elfcorehdr", setup_elfcorehdr);
