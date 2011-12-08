Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1LHOai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:30:38 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:41336 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1LHOah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:30:37 -0500
Date: Thu, 8 Dec 2011 10:29:58 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ibft: Fix finding ibft with ACPI tables
Message-ID: <20111208142958.GA4096@andromeda.dapyr.net>
References: <4EE073BB.6080403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE073BB.6080403@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:22:19AM -0800, Yinghai Lu wrote:
> Found one system with UEFI/iBFT is not detected.

Excellent.

I have some comment in regards to the patch - it needs to be
split in two: one part being _just_ the bug-fix, and the other
being the cleanup/fixing printk.

Please fix the subject - it should say: "Fix finding IBFT ACPI tables
on UEFI."

> 
> the root cause: for x86, We move calling of find_ibft_region() much earlier.
> in setup_arch() before ACPI is enabled.

We move calling? When did the find_ibft_region() get moved?

I think you mean "find_ibft_region() gets called in setup_arch(), which
is done before ACPI is enabled on UEFI. Hence it does not find the IBFT
table' ?

What about the 'memblock_reserve' that find_ibft_region calls? Do
we need to make a special call on UEFI to reserve that region? Or is
that not neccessary since it is an ACPI table and has already
been reserved?
> 
> Try to all find_ibft_region() second times in ibft_init()
         ^^^ - all?                    ^^^^ - time

How many iBFT tables are there? You can drop the 'all'.

> 
> at that time ACPI iBFT already get permanent mapped with ioremap.
> So isa_virt_to_bus will get wrong phys from right virt address.

.. "will get wrong physical address from the virtual address."


> We could just skip that printing.

That sounds like another patch - a cleanup patch actually.

> For legacy one, print the found address early.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> 
> ---
>  drivers/firmware/iscsi_ibft.c      |   18 +++++++++++++++---
>  drivers/firmware/iscsi_ibft_find.c |    1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/firmware/iscsi_ibft.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft.c
> @@ -753,9 +753,21 @@ static int __init ibft_init(void)
>  {
>  	int rc = 0;
>  
> +	/* find that from acpi tables */
> +	if (!ibft_addr) {
> +		unsigned long size = 0;
> +
> +		find_ibft_region(&size);
> +		barrier();

barrier? Please provide a comment detailing why you need it.

> +	}
> +
>  	if (ibft_addr) {
> -		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
> -		       (u64)isa_virt_to_bus(ibft_addr));
> +		/*
> +		 * Second try is from acpi permanent map with ioremap
> +		 *  can not simply convert back to phys addr.
> +		 *  and We don't need to print that table phys addr.

That comment makes sense in the git description but not in this
code path (b/c when you look at the code you won't think of printing
the "iBFT detected at XXX" comment.

You should move part of this comment to the "if (!ibft_addr)" and just
say:
"Retry as on UEFI systems the setup_arch is called before ACPI tables
are parsed is setup
so we never get the data."

> +		 */
> +		pr_info("iBFT detected.\n");
>  
>  		rc = ibft_check_device();
>  		if (rc)
> @@ -770,7 +782,7 @@ static int __init ibft_init(void)
>  		if (rc)
>  			goto out_free;
>  	} else
> -		printk(KERN_INFO "No iBFT detected.\n");
> +		pr_info("No iBFT detected.\n");
>  
>  	return 0;
>  
> Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
> @@ -94,6 +94,7 @@ static int __init find_ibft_in_mem(void)
>  				 * the table cannot be valid. */
>  				if (pos + len <= (IBFT_END-1)) {
>  					ibft_addr = (struct acpi_table_ibft *)virt;
> +					pr_info("iBFT found at 0x%lx.\n", pos);

On legacy hardware we will get then:

iBFT found at 0xXXX
...
iBFT detected.

Which I am not sure is really needed. We could just get rid of this
iBFT found at 0xXX - but that is a seperate patch - a cleanup patch.

Peter, do you know if Anaconda scans the dmesg for the 'iBFT'? I presume
not (since the SysFS exists).

Please resend the fix by itself and also a cleanup patch. Thank you!
