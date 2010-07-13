Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0GMOLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:11:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47045 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0GMOLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BVGDh+foeBo2vC6+1TJTXr0qXSJvZ8HRWjKy9/EoMTOrSMJed+UiqAdG5m8g4tEWSe
         sw2+8gAZZyL9u9fTEyDyEUB9YndOXy71wSlifq542iSAQtFS2VXUn3QbXKqooKFJ3B37
         x6HMIwMF2W8ZqylVKVvSRsJ9zdjgR8ugB0IME=
MIME-Version: 1.0
Date: Tue, 13 Jul 2010 15:11:37 +0100
Message-ID: <AANLkTik8ayaGvOHfjATDGl2vLjToLFgnFvKtcXcMK9RD@mail.gmail.com>
Subject: Re: [2.6.35-rc5] select useful number of entries for DMA debugging 
	v3...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2010 15:39, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Daniel" == Daniel J Blueman <daniel.blueman@gmail.com> writes:
>
> Daniel> On 11 July 2010 12:54, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>>> On 10 July 2010 16:43, Joerg Roedel <joro@8bytes.org> wrote:
>>>> On Sat, Jul 10, 2010 at 03:52:04PM +0100, Daniel J Blueman wrote:
>>>>> On 9 July 2010 22:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>>> > On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
>>>>> > <daniel.blueman@gmail.com> wrote:
>>>>> >> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
>>>>> >> enabled, I've consistently seen it exhaust the allocated entries during
>>>>> >> boot, giving 'DMA-API: debugging out of memory - disabling'.
>>>>> >>
>>>>> >> Increase number of entries to allow DMA debugging again.
>>>>> >
>>>>> > Rather than increase the default that gets allocated whenever anybody
>>>>> > enables the DMA debugging, I'd really prefer to see people use the
>>>>> > kernel command line option if they run out. After all, it's a (pretty
>>>>> > esoteric) debug option, and the number of required entries depends on
>>>>> > machine configuration. I'd rather not make the default cover a huge
>>>>> > number, when you could just add
>>>>> >
>>>>> >   dma_debug_entries=65536
>>>>> >
>>>>> > on the kernel boot command line instead for machines that want/need it..
>>>>>
>>>>> That said, I am seeing the DMA pool exhaust on a single socket Core i5
>>>>> system with Intel graphics and no other adapters - seems like a fairly
>>>>> common case. If eg 25% of developers will be using similar to this,
>>>>> maybe it's good to make DMA debugging less immediately esoteric?
>>>>>
>>>>> On the other hand, I would immediately agree if the exhaustion
>>>>> occurred on an atypical setup.
>>>>
>>>> How much memory do you have in this machine? We could probably make the
>>>> number of pre-allocated entries dependent on the memory available in the
>>>> machine like Ingo suggested some time ago to avoid such problems.
>>>
>>> I have 4GB. Since this change is specific to x86, I guess the only
>>> corner case we need to protect from this change is developers on small
>>> x86 embedded systems such as MIDs, so lowering the allocated size on
>>> <1GB systems makes sense.
>
> Daniel> How about something like this? If you think ~18800 entries on a 1GB
> Daniel> system is better, let me know and I'll quickly respin. The calculation
> Daniel> seems reasonable for other arches.
>
> Daniel> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
> Daniel> enabled, I've seen consistent exhaustion of the allocated entries during
> Daniel> boot, giving 'DMA-API: debugging out of memory - disabling'.
>
> Daniel> Increase the default number of entries to allow DMA debugging again, but
> Daniel> assign a reasonable lower limit for systems with less memory (eg ~37600
> Daniel> entries on a 1GB system), to prevent excessive use.
>
> Daniel> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
> Daniel> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> Daniel> index a4ac764..0766fcf 100644
> Daniel> --- a/arch/x86/kernel/pci-dma.c
> Daniel> +++ b/arch/x86/kernel/pci-dma.c
> Daniel> @@ -52,7 +52,7 @@ struct device x86_dma_fallback_dev = {
> Daniel>  EXPORT_SYMBOL(x86_dma_fallback_dev);
>
> Daniel>  /* Number of entries preallocated for DMA-API debugging */
> Daniel> -#define PREALLOC_DMA_DEBUG_ENTRIES       32768
> Daniel> +#define PREALLOC_DMA_DEBUG_ENTRIES       65536
>
> Daniel>  int dma_set_mask(struct device *dev, u64 mask)
> Daniel>  {
> Daniel> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> Daniel> index ba8b670..2d1f965 100644
> Daniel> --- a/lib/dma-debug.c
> Daniel> +++ b/lib/dma-debug.c
> Daniel> @@ -736,6 +736,10 @@ void dma_debug_init(u32 num_entries)
>
> Daniel>         if (req_entries)
> Daniel>                 num_entries = req_entries;
> Daniel> +       else
> Daniel> +               /* for systems with less memory, limit to a proportional amount of memory */
> Daniel> +               /* eg 1GB memory, 4KB pages ~ 37600 entries */
> Daniel> +               num_entries = min(num_entries, (unsigned int)(totalram_pages >>
> Daniel> (PAGE_SHIFT - 10)));
>
> Daniel>         if (prealloc_memory(num_entries) != 0) {
> Daniel>                 pr_err("DMA-API: debugging out of memory error - disabled\n");
>
> Maybe you could update this to mention the kernel parameter
> "dma_debug_entries=xxxxx" so that people could use to increase this
> value?  It would make it simpler and easier to find it it's logged
> nicely?

Good comment. Fixed checkpatch compliance and rediffed against
2.6.35-rc5. Linus/Ingo - is this more acceptable?

---

When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
enabled, I've seen consistent exhaustion of the allocated entries during
boot, giving 'DMA-API: debugging out of memory - disabling'.

Increase the default number of entries to allow DMA debugging again, but
assign a reasonable lower limit for systems with less memory (eg ~38000
entries on a 1GB system), to prevent excessive use.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4b7e3d8..5ff7f12 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -53,7 +53,7 @@ struct device x86_dma_fallback_dev = {
 EXPORT_SYMBOL(x86_dma_fallback_dev);

 /* Number of entries preallocated for DMA-API debugging */
-#define PREALLOC_DMA_DEBUG_ENTRIES       32768
+#define PREALLOC_DMA_DEBUG_ENTRIES       65536

 int dma_set_mask(struct device *dev, u64 mask)
 {
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 01e6427..b689ac7 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -487,7 +487,8 @@ static int prealloc_memory(u32 num_entries)
 	num_free_entries = num_entries;
 	min_free_entries = num_entries;

-	pr_info("DMA-API: preallocated %d debug entries\n", num_entries);
+	pr_info("DMA-API: preallocated %d debug entries; boot with "
+		"dma_debug_entries=N to change\n", num_entries);

 	return 0;

@@ -736,6 +737,13 @@ void dma_debug_init(u32 num_entries)

 	if (req_entries)
 		num_entries = req_entries;
+	else
+		/*
+		 * For systems with less memory, limit to a proportional
+		 * amount of memory, eg 1GB memory, 4KB pages ~ 38000 entries
+		 */
+		num_entries = min(num_entries,
+			(unsigned int)(totalram_pages >> (PAGE_SHIFT - 10)));

 	if (prealloc_memory(num_entries) != 0) {
 		pr_err("DMA-API: debugging out of memory error - disabled\n");
-- 
Daniel J Blueman
