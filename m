Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1LHTIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:08:32 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:45758 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1LHTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:08:31 -0500
Date: Thu, 8 Dec 2011 15:08:08 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ibft: Fix finding IBFT ACPI table on UEFI
Message-ID: <20111208190808.GA25433@andromeda.dapyr.net>
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net> <4EE0EB51.5010900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE0EB51.5010900@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 08:52:33AM -0800, Yinghai Lu wrote:
> 
> Found one system with UEFI/iBFT, Kernel does not detect the iBFT during
                                   ^^^^^ - lowercase 'kernel' please.
> iscsi_ibft module loading.

I get this when compiling it:

Setup is 16588 bytes (padded to 16896 bytes).
System is 6277 kB
CRC 7fe65506
Kernel: arch/x86/boot/bzImage is ready  (#2)
ERROR: "find_ibft_region" [drivers/firmware/iscsi_ibft.ko] undefined!

This is on i386 x86 build when doing 'make allmodconfig'.

> 
> the root cause: for x86, We have calling of find_ibft_region() much early.
                          ^^ - You only need to uppercase it if you
start a sentence - which is not what you are doing. So please make it
lowercase.
> in setup_arch() before ACPI is enabled.

This is what I changed the git description to:

 Root cause: on x86 (UEFI), we are calling find_ibft_region() much
 earlier - specifically in setup_arch() before ACPI is enabled.

> 
> Try to call find_ibft_region() second time in ibft_init().
> 
> At that time ACPI iBFT already get permanent mapped with ioremap.
> So isa_virt_to_bus will get wrong phys from right virt address.
> We could just skip that phys address printing.
> 
> For legacy one, print the found address early.
> 
> -v2: update comments and description according to Konrad.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/firmware/iscsi_ibft.c      |   14 ++++++++++++--
>  drivers/firmware/iscsi_ibft_find.c |    1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/firmware/iscsi_ibft.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft.c
> @@ -753,9 +753,19 @@ static int __init ibft_init(void)
>  {
>  	int rc = 0;
>  
> +	/*
> +	   Retry as on UEFI systems the setup_arch()/find_ibft_region()
> +	   is called before ACPI tables are parsed so we never
> +	   get the data.
> +	*/
> +	if (!ibft_addr) {
> +		unsigned long size = 0;
> +
> +		find_ibft_region(&size);
> +	}
> +
>  	if (ibft_addr) {
> -		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
> -		       (u64)isa_virt_to_bus(ibft_addr));
> +		pr_info("iBFT detected.\n");
>  
>  		rc = ibft_check_device();
>  		if (rc)
> Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
> @@ -94,6 +94,7 @@ static int __init find_ibft_in_mem(void)
>  				 * the table cannot be valid. */
>  				if (pos + len <= (IBFT_END-1)) {
>  					ibft_addr = (struct acpi_table_ibft *)virt;
> +					pr_info("iBFT found at 0x%lx.\n", pos);
>  					goto done;
>  				}
>  			}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
