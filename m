Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0GMOj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:39:58 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:52911 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab0GMOj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:39:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19516.31370.717799.659547@stoffel.org>
Date: Tue, 13 Jul 2010 10:39:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stoffel <john@stoffel.org>
Subject: Re: [2.6.35-rc5] select useful number of entries for DMA debugging 
	v3...
In-Reply-To: <AANLkTik8ayaGvOHfjATDGl2vLjToLFgnFvKtcXcMK9RD@mail.gmail.com>
References: <AANLkTik8ayaGvOHfjATDGl2vLjToLFgnFvKtcXcMK9RD@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Signed-off-by: John Stoffel <john@stoffel.org>

>> 
Daniel> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
Daniel> index a4ac764..0766fcf 100644
Daniel> --- a/arch/x86/kernel/pci-dma.c
Daniel> +++ b/arch/x86/kernel/pci-dma.c
Daniel> @@ -52,7 +52,7 @@ struct device x86_dma_fallback_dev = {
Daniel>  EXPORT_SYMBOL(x86_dma_fallback_dev);
>> 
Daniel>  /* Number of entries preallocated for DMA-API debugging */
Daniel> -#define PREALLOC_DMA_DEBUG_ENTRIES       32768
Daniel> +#define PREALLOC_DMA_DEBUG_ENTRIES       65536
>> 
Daniel>  int dma_set_mask(struct device *dev, u64 mask)
Daniel>  {
Daniel> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
Daniel> index ba8b670..2d1f965 100644
Daniel> --- a/lib/dma-debug.c
Daniel> +++ b/lib/dma-debug.c
Daniel> @@ -736,6 +736,10 @@ void dma_debug_init(u32 num_entries)
>> 
Daniel>         if (req_entries)
Daniel>                 num_entries = req_entries;
Daniel> +       else
Daniel> +               /* for systems with less memory, limit to a proportional amount of memory */
Daniel> +               /* eg 1GB memory, 4KB pages ~ 37600 entries */
Daniel> +               num_entries = min(num_entries, (unsigned int)(totalram_pages >>
Daniel> (PAGE_SHIFT - 10)));
>> 
Daniel>         if (prealloc_memory(num_entries) != 0) {
Daniel>                 pr_err("DMA-API: debugging out of memory error - disabled\n");
>> 
>> Maybe you could update this to mention the kernel parameter
>> "dma_debug_entries=xxxxx" so that people could use to increase this
>> value?  It would make it simpler and easier to find it it's logged
>> nicely?

Daniel> Good comment. Fixed checkpatch compliance and rediffed against
Daniel> 2.6.35-rc5. Linus/Ingo - is this more acceptable?

Daniel> ---

Daniel> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
Daniel> enabled, I've seen consistent exhaustion of the allocated entries during
Daniel> boot, giving 'DMA-API: debugging out of memory - disabling'.

Daniel> Increase the default number of entries to allow DMA debugging again, but
Daniel> assign a reasonable lower limit for systems with less memory (eg ~38000
Daniel> entries on a 1GB system), to prevent excessive use.

Daniel> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Daniel> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
Daniel> index 4b7e3d8..5ff7f12 100644
Daniel> --- a/arch/x86/kernel/pci-dma.c
Daniel> +++ b/arch/x86/kernel/pci-dma.c
Daniel> @@ -53,7 +53,7 @@ struct device x86_dma_fallback_dev = {
Daniel>  EXPORT_SYMBOL(x86_dma_fallback_dev);

Daniel>  /* Number of entries preallocated for DMA-API debugging */
Daniel> -#define PREALLOC_DMA_DEBUG_ENTRIES       32768
Daniel> +#define PREALLOC_DMA_DEBUG_ENTRIES       65536

Daniel>  int dma_set_mask(struct device *dev, u64 mask)
Daniel>  {
Daniel> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
Daniel> index 01e6427..b689ac7 100644
Daniel> --- a/lib/dma-debug.c
Daniel> +++ b/lib/dma-debug.c
Daniel> @@ -487,7 +487,8 @@ static int prealloc_memory(u32 num_entries)
Daniel>  	num_free_entries = num_entries;
Daniel>  	min_free_entries = num_entries;

Daniel> -	pr_info("DMA-API: preallocated %d debug entries\n", num_entries);
Daniel> +	pr_info("DMA-API: preallocated %d debug entries; boot with "
Daniel> +		"dma_debug_entries=N to change\n", num_entries);

Daniel>  	return 0;

Daniel> @@ -736,6 +737,13 @@ void dma_debug_init(u32 num_entries)

Daniel>  	if (req_entries)
Daniel>  		num_entries = req_entries;
Daniel> +	else
Daniel> +		/*
Daniel> +		 * For systems with less memory, limit to a proportional
Daniel> +		 * amount of memory, eg 1GB memory, 4KB pages ~ 38000 entries
Daniel> +		 */
Daniel> +		num_entries = min(num_entries,
Daniel> +			(unsigned int)(totalram_pages >> (PAGE_SHIFT - 10)));

Daniel>  	if (prealloc_memory(num_entries) != 0) {
Daniel>  		pr_err("DMA-API: debugging out of memory error - disabled\n");
Daniel> -- 
Daniel> Daniel J Blueman
