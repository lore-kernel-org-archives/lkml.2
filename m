Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1HAUgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab1HAUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:36:18 -0400
Date: Mon, 1 Aug 2011 16:36:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 03/10] kdump: Add size to elfcorehdr kernel parameter
Message-ID: <20110801203607.GI3805@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
 <20110727125807.853426542@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727125807.853426542@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 02:55:07PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently only the address of the pre-allocated ELF header is passed with
> the elfcorehdr= kernel parameter. In order to reserve memory for the header
> in the 2nd kernel also the size is required. To pass the size with this
> patch the syntax of the kernel parameter is extended as follows:
> 
> elfcorehdr=[size[KMG]@]offset[KMG]
> 
> This change is backward compatible because elfcorehdr=size is still allowed.

Generally vmcore parses elfcorehdr to figure out the sizes. kexec-tools
knows about it and relevant memory is excluded from second kernel's map
with the help of memmap= command line option.

Can you please mention that this is only s390 specific requirement as
there are no memmap= equivalent options and somehow dump tools wants
to know how big the elf header size is?

Thanks
Vivek

> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  Documentation/kernel-parameters.txt |    6 +++---
>  include/linux/crash_dump.h          |    1 +
>  kernel/crash_dump.c                 |   11 +++++++++++
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -717,10 +717,10 @@ bytes respectively. Such letter suffixes
>  			See Documentation/block/as-iosched.txt and
>  			Documentation/block/deadline-iosched.txt for details.
>  
> -	elfcorehdr=	[IA64,PPC,SH,X86]
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
