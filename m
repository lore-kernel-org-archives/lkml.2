Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0FDNOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:14:42 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1884 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0FDNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:14:40 -0400
Date: Fri, 4 Jun 2010 08:19:26 -0500
From: scameron@beardog.cce.hp.com
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com
Subject: Re: + cciss-add-performant-mode-support-for-stars-sirius.patch added to -mm tree
Message-ID: <20100604131926.GO17187@beardog.cce.hp.com>
References: <201006021958.o52Jw7CY013718@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006021958.o52Jw7CY013718@imap1.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 12:58:06PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      cciss: add performant mode support for Stars/Sirius
> has been added to the -mm tree.  Its filename is
>      cciss-add-performant-mode-support-for-stars-sirius.patch
> 

[...snip...]  see my comments below.

> 
> ------------------------------------------------------
> Subject: cciss: add performant mode support for Stars/Sirius
> From: Mike Miller <mike.miller@hp.com>
> 
> Add a mode of controller operation called Performant Mode.  Even though
> cciss has been deprecated in favor of hpsa there are new controllers due
> out next year that HP must support in older vendor distros.  Vendors
> require all fixes/features be upstream.  These new controllers support
> only 16 commands in simple mode but support up to 1024 in performant mode.
> This requires us to add this support at this late date.
> 
> The performant mode transport minimizes host PCI accesses by performinf
> many completions per read.  PCI writes are posted so the host can write
> then immediately get off the bus not waiting for the writwe to complete to
> the target.  In the context of performant mode the host read out to a
> controller pulls all posted writes into host memory ensuring the reply
> queue is coherent.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/block/cciss.c      |  267 ++++++++++++++++++++++++++++-------
>  drivers/block/cciss.h      |  109 +++++++++++++-
>  drivers/block/cciss_cmd.h  |   34 +++-
>  drivers/block/cciss_scsi.c |    6 
>  4 files changed, 353 insertions(+), 63 deletions(-)
> 
> diff -puN drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius drivers/block/cciss.c
> --- a/drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius
> +++ a/drivers/block/cciss.c
> @@ -206,6 +206,11 @@ static void cciss_device_release(struct 
>  static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
>  static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
>  

[...snip...]

> +	set_performant_mode(h, c);
>  	spin_lock_irqsave(&h->lock, flags);
>  	addQ(&h->reqQ, c);
>  	h->Qdepth++;
> @@ -350,6 +366,28 @@ static const char *raid_label[] = { "0",
>  
>  #ifdef CONFIG_PROC_FS
>  
> +static inline u32 next_command(ctlr_info_t *h)
> +{

"next_command(...)" should not be inside "#ifdef CONFIG_PROC_FS"

[... snip...]

>  		dma_prefetch |= 0x8000;
> @@ -3944,38 +4140,8 @@ static int __devinit cciss_pci_init(ctlr
>  	}
>  
>  #ifdef CCISS_DEBUG
>  	return 0;

[...snip...]

>  
>  err_out_free_res:
> @@ -3984,6 +4150,7 @@ err_out_free_res:
>  	 * Smart Array controllers that pci_enable_device does not undo
>  	 */
>  	pci_release_regions(pdev);
> +	cciss_put_controller_into_performant_mode(c);
>  	return err;

^^^ This is calling cciss_put_controller_into_performant_mode() in
the error code path of cciss_pci_init(), and not in the main initialization
code path.  That cannot be correct.

[...snip...]

>  
>  static void __devexit cciss_remove_one(struct pci_dev *pdev)
> @@ -4575,7 +4741,6 @@ static int __init cciss_init(void)
>  	 * array of them, the size must be a multiple of 8 bytes.

^^^ "8 bytes" is no longer correct in the above comment,
should be COMMANDLIST_ALIGNMENT (which is 32 now).

>  	 */
>  	BUILD_BUG_ON(sizeof(CommandList_struct) % COMMANDLIST_ALIGNMENT);
> -
>  	printk(KERN_INFO DRIVER_NAME "\n");
>  

[...snip...]

> @@ -173,12 +174,15 @@ typedef struct _SGDescriptor_struct {
>   * PAD_64 can be adjusted independently as needed for 32-bit
>   * and 64-bits systems.
>   */
> -#define COMMANDLIST_ALIGNMENT (8)
> +#define COMMANDLIST_ALIGNMENT (32)
>  #define IS_64_BIT ((sizeof(long) - 4)/4)
>  #define IS_32_BIT (!IS_64_BIT)
> -#define PAD_32 (0)
> +#define PAD_32 (32)

^^^ if it's supposed to be aligned at 32 bit boundary
(which it is) then PAD_32 should be 0, not 32, if 32 works.

[...snip...]

> @@ -213,6 +213,8 @@ scsi_cmd_stack_setup(int ctlr, struct cc
>  
>  	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
>  	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
> +	/* printk(KERN_WARNING "cciss_scsi.c: 0x%08x 0x%08x 0x%08x\n",
> +			0xdeadbeef, sizeof(*stk->pool), 0xbeefdead); */

^^^ this looks like debug code left in by mistake.

>  	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
>  	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
>  		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
> _
> 


-- steve

