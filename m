Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0GLO6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:58:22 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42712 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0GLO6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:58:21 -0400
X-Greylist: delayed 1132 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2010 10:58:21 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19515.10504.325328.644473@stoffel.org>
Date: Mon, 12 Jul 2010 10:39:04 -0400
From: "John Stoffel" <john@stoffel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.35-rc3] select useful number of entries for DMA debugging...
In-Reply-To: <AANLkTinEaJ7Hr9qTck53n2h0NU6nKyX3Qx-slV3RF8kU@mail.gmail.com>
References: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
	<AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com>
	<AANLkTinLjhLoQJ8URiuCKqgntiLEKxCesNEPZ8b24uLu@mail.gmail.com>
	<20100710154331.GF10080@8bytes.org>
	<AANLkTin24TP3qcCb4c0-dLfqysyBDYSrPiO3UXtp-Y1n@mail.gmail.com>
	<AANLkTinEaJ7Hr9qTck53n2h0NU6nKyX3Qx-slV3RF8kU@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Daniel" == Daniel J Blueman <daniel.blueman@gmail.com> writes:

Daniel> On 11 July 2010 12:54, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> On 10 July 2010 16:43, Joerg Roedel <joro@8bytes.org> wrote:
>>> On Sat, Jul 10, 2010 at 03:52:04PM +0100, Daniel J Blueman wrote:
>>>> On 9 July 2010 22:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> > On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
>>>> > <daniel.blueman@gmail.com> wrote:
>>>> >> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
>>>> >> enabled, I've consistently seen it exhaust the allocated entries during
>>>> >> boot, giving 'DMA-API: debugging out of memory - disabling'.
>>>> >>
>>>> >> Increase number of entries to allow DMA debugging again.
>>>> >
>>>> > Rather than increase the default that gets allocated whenever anybody
>>>> > enables the DMA debugging, I'd really prefer to see people use the
>>>> > kernel command line option if they run out. After all, it's a (pretty
>>>> > esoteric) debug option, and the number of required entries depends on
>>>> > machine configuration. I'd rather not make the default cover a huge
>>>> > number, when you could just add
>>>> >
>>>> >   dma_debug_entries=65536
>>>> >
>>>> > on the kernel boot command line instead for machines that want/need it..
>>>> 
>>>> That said, I am seeing the DMA pool exhaust on a single socket Core i5
>>>> system with Intel graphics and no other adapters - seems like a fairly
>>>> common case. If eg 25% of developers will be using similar to this,
>>>> maybe it's good to make DMA debugging less immediately esoteric?
>>>> 
>>>> On the other hand, I would immediately agree if the exhaustion
>>>> occurred on an atypical setup.
>>> 
>>> How much memory do you have in this machine? We could probably make the
>>> number of pre-allocated entries dependent on the memory available in the
>>> machine like Ingo suggested some time ago to avoid such problems.
>> 
>> I have 4GB. Since this change is specific to x86, I guess the only
>> corner case we need to protect from this change is developers on small
>> x86 embedded systems such as MIDs, so lowering the allocated size on
>> <1GB systems makes sense.

Daniel> How about something like this? If you think ~18800 entries on a 1GB
Daniel> system is better, let me know and I'll quickly respin. The calculation
Daniel> seems reasonable for other arches.

Daniel> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
Daniel> enabled, I've seen consistent exhaustion of the allocated entries during
Daniel> boot, giving 'DMA-API: debugging out of memory - disabling'.

Daniel> Increase the default number of entries to allow DMA debugging again, but
Daniel> assign a reasonable lower limit for systems with less memory (eg ~37600
Daniel> entries on a 1GB system), to prevent excessive use.

Daniel> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Daniel> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
Daniel> index a4ac764..0766fcf 100644
Daniel> --- a/arch/x86/kernel/pci-dma.c
Daniel> +++ b/arch/x86/kernel/pci-dma.c
Daniel> @@ -52,7 +52,7 @@ struct device x86_dma_fallback_dev = {
Daniel>  EXPORT_SYMBOL(x86_dma_fallback_dev);

Daniel>  /* Number of entries preallocated for DMA-API debugging */
Daniel> -#define PREALLOC_DMA_DEBUG_ENTRIES       32768
Daniel> +#define PREALLOC_DMA_DEBUG_ENTRIES       65536

Daniel>  int dma_set_mask(struct device *dev, u64 mask)
Daniel>  {
Daniel> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
Daniel> index ba8b670..2d1f965 100644
Daniel> --- a/lib/dma-debug.c
Daniel> +++ b/lib/dma-debug.c
Daniel> @@ -736,6 +736,10 @@ void dma_debug_init(u32 num_entries)

Daniel>  	if (req_entries)
Daniel>  		num_entries = req_entries;
Daniel> +	else
Daniel> +		/* for systems with less memory, limit to a proportional amount of memory */
Daniel> +		/* eg 1GB memory, 4KB pages ~ 37600 entries */
Daniel> +		num_entries = min(num_entries, (unsigned int)(totalram_pages >>
Daniel> (PAGE_SHIFT - 10)));

Daniel>  	if (prealloc_memory(num_entries) != 0) {
Daniel>  		pr_err("DMA-API: debugging out of memory error - disabled\n");

Maybe you could update this to mention the kernel parameter
"dma_debug_entries=xxxxx" so that people could use to increase this
value?  It would make it simpler and easier to find it it's logged
nicely?

Thanks,
John


