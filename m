Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1LQOmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 09:42:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47109 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1LQOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 09:42:11 -0500
Date: Sat, 17 Dec 2011 09:42:06 -0500
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
Message-ID: <20111217144206.GF14816@konrad-lan>
References: <20111215210538.GA12248@konrad-lan>
 <CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
 <20111216000716.GA14822@suse.de>
 <CAE9FiQWufpJ7LwNiBnpS9bR_Sk4e5=wNZp2NmKp117+i56h=Sg@mail.gmail.com>
 <CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 04:40:34PM -0800, Yinghai Lu wrote:
> On Thu, Dec 15, 2011 at 4:37 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Dec 15, 2011 at 4:07 PM, Greg KH <gregkh@suse.de> wrote:
> >
> >> The patch as-is does not apply to 2.6.32, so I can't apply it there.  If
> >> you want it applied there, please provide the backport to the above
> >> mentioned email address.
> 
> please check back ported patch for 2.6.36 to 2.6.39
> 
> We don't need to this one for 2.6.32, because EFI/ACPI ibft detecting
> is only added from 2.6.36.

Then 2.6.36 and above should have the fix below. Thanks for porting it
over.
> 
> but 2.6.32 base kernel still could take iscsi_ibft.c related changes
> in the patch, and ignore conflicts with iscs_ibft_find.c.
> but that will add new feature to 2.6.32. Not sure if stable tree
> should take that kind of change.

It could, but I am not too thrilled about it.
> 
> Thanks
> 
> Yinghai

> [PATCH -stable] ibft: Fix finding IBFT ACPI table on UEFI
> 
> commit 935a9fee51c945b8942be2d7b4bae069167b4886 upstream.
> 
> it is backporting for:
> 	kernel 2.6.36, 2.6.37, 2.6.38, 2.6.39
> 
> Found one system with UEFI/iBFT, kernel does not detect the iBFT during
> iscsi_ibft module loading.
> 
> Root cause: on x86 (UEFI), we are calling of find_ibft_region() much earlier
> 	- specifically in setup_arch() before ACPI is enabled.
> 
> Try to split acpi checking code out and call that later
> 
> At that time ACPI iBFT already get permanent mapped with ioremap.
> So isa_virt_to_bus() will get wrong phys from right virt address.
> We could just skip that phys address printing.
> 
> For legacy one, print the found address early.
> 
> -v2: update comments and description according to Konrad.
> -v3: fix problem about module use case that is found by Konrad.
> -v4: use acpi_get_table() instead of acpi_table_parse() to handle module use case that is found by Konrad again..
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/firmware/iscsi_ibft.c      |   42 +++++++++++++++++++++++++++++++++++--
>  drivers/firmware/iscsi_ibft_find.c |   22 +------------------
>  2 files changed, 42 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/firmware/iscsi_ibft.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
> +++ linux-2.6/drivers/firmware/iscsi_ibft.c
> @@ -738,6 +738,37 @@ static void __exit ibft_exit(void)
>  	ibft_cleanup();
>  }
>  
> +#ifdef CONFIG_ACPI
> +static const struct {
> +	char *sign;
> +} ibft_signs[] = {
> +	/*
> +	 * One spec says "IBFT", the other says "iBFT". We have to check
> +	 * for both.
> +	 */
> +	{ ACPI_SIG_IBFT },
> +	{ "iBFT" },
> +};
> +
> +static void __init acpi_find_ibft_region(void)
> +{
> +	int i;
> +	struct acpi_table_header *table = NULL;
> +
> +	if (acpi_disabled)
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++) {
> +		acpi_get_table(ibft_signs[i].sign, 0, &table);
> +		ibft_addr = (struct acpi_table_ibft *)table;
> +	}
> +}
> +#else
> +static void __init acpi_find_ibft_region(void)
> +{
> +}
> +#endif
> +
>  /*
>   * ibft_init() - creates sysfs tree entries for the iBFT data.
>   */
> @@ -745,9 +776,16 @@ static int __init ibft_init(void)
>  {
>  	int rc = 0;
>  
> +	/*
> +	   As on UEFI systems the setup_arch()/find_ibft_region()
> +	   is called before ACPI tables are parsed and it only does
> +	   legacy finding.
> +	*/
> +	if (!ibft_addr)
> +		acpi_find_ibft_region();
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
> @@ -49,14 +49,6 @@ EXPORT_SYMBOL_GPL(ibft_addr);
>  #define VGA_MEM 0xA0000 /* VGA buffer */
>  #define VGA_SIZE 0x20000 /* 128kB */
>  
> -#ifdef CONFIG_ACPI
> -static int __init acpi_find_ibft(struct acpi_table_header *header)
> -{
> -	ibft_addr = (struct acpi_table_ibft *)header;
> -	return 0;
> -}
> -#endif /* CONFIG_ACPI */
> -
>  static int __init find_ibft_in_mem(void)
>  {
>  	unsigned long pos;
> @@ -77,6 +69,7 @@ static int __init find_ibft_in_mem(void)
>  			 * the table cannot be valid. */
>  			if (pos + len <= (IBFT_END-1)) {
>  				ibft_addr = (struct acpi_table_ibft *)virt;
> +				pr_info("iBFT found at 0x%lx.\n", pos);
>  				break;
>  			}
>  		}
> @@ -92,21 +85,10 @@ unsigned long __init find_ibft_region(un
>  
>  	ibft_addr = NULL;
>  
> -#ifdef CONFIG_ACPI
> -	/*
> -	 * One spec says "IBFT", the other says "iBFT". We have to check
> -	 * for both.
> -	 */
> -	if (!ibft_addr)
> -		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
> -	if (!ibft_addr)
> -		acpi_table_parse(IBFT_SIGN, acpi_find_ibft);
> -#endif /* CONFIG_ACPI */
> -
>  	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
>  	 * only use ACPI for this */
>  
> -	if (!ibft_addr && !efi_enabled)
> +	if (!efi_enabled)
>  		find_ibft_in_mem();
>  
>  	if (ibft_addr) {

