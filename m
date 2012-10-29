Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2J2TyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:54:01 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:33028 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2J2TyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:54:00 -0400
Message-ID: <508EDEC6.7030101@ahsoftware.de>
Date: Mon, 29 Oct 2012 20:53:42 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
References: <508E58FD.2000707@ahsoftware.de> <508E8264.8070807@ahsoftware.de> <20121029165946.GB6614@kroah.com> <508EC69F.2030505@ahsoftware.de> <20121029183250.GB4623@kroah.com>
In-Reply-To: <20121029183250.GB4623@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.10.2012 19:32, schrieb Greg Kroah-Hartman:
> On Mon, Oct 29, 2012 at 07:10:39PM +0100, Alexander Holler wrote:
>> Am 29.10.2012 17:59, schrieb Greg Kroah-Hartman:
>>> On Mon, Oct 29, 2012 at 02:19:32PM +0100, Alexander Holler wrote:
>>>> Am 29.10.2012 11:22, schrieb Alexander Holler:
>>>>> Hello,
>>>>>
>>>>> I've just bisected a problem with 3.6.4.
>>>>>
>>>>> I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6
>>>>> (1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box
>>>>> didn't boot.
>>>>>
>>>>> I can't provide any output, because I don't see if that commit is
>>>>> applied. ;)
>>>>
>>>> That sentence missed an 'any'. But I've now attached a serial, here is
>>>> the output:
>>>
>>> Thanks for this, it should be fixed in the next 3.6.y release, we needed
>>> to add two more commits from upstream:
>>> 	844ab6f993b1d32eb40512503d35ff6ad0c57030
>>> 	f82f64dd9f485e13f29f369772d4a0e868e5633a
>>> If you apply those two, and it doesn't solve the problem for you, please
>>> let us know.
>>
>> They don't applied cleanly, but after fixing the conflicts it seem's
>> to work.
>
> The conflict was in the printk, right?  I fixed that up in the 3.4
> stable tree.

No, I've come up with that on top of 3.6.4:

-----------------
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ab1f6a9..d7aea41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,40 +35,44 @@ struct map_range {
  	unsigned page_size_mask;
  };

-static void __init find_early_table_space(struct map_range *mr, 
unsigned long end,
-					  int use_pse, int use_gbpages)
+/*
+ * First calculate space needed for kernel direct mapping page tables 
to cover
+ * mr[0].start to mr[nr_range - 1].end, while accounting for possible 
2M and 1GB
+ * pages. Then find enough contiguous space for those page tables.
+ */
+static void __init find_early_table_space(struct map_range *mr, int 
nr_range)
  {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	int i;
+	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
+	unsigned long start = 0, good_end;
  	phys_addr_t base;

-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-
-	if (use_gbpages) {
-		unsigned long extra;
-
-		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
-		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	for (i = 0; i < nr_range; i++) {
+		unsigned long range, extra;

-	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
+		range = mr[i].end - mr[i].start;
+		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;

-	if (use_pse) {
-		unsigned long extra;
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
+			extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
+			pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+		} else {
+			pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
+		}

-		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
+			extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
  #ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
+			extra += PMD_SIZE;
  #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
-
-		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+			ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		} else {
+			ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		}
+	}

+	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
  	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);

  #ifdef CONFIG_X86_32
@@ -86,7 +90,7 @@ static void __init find_early_table_space(struct 
map_range *mr, unsigned long en
  	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);

  	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem 
%#010lx-%#010lx]\n",
-		end - 1, pgt_buf_start << PAGE_SHIFT,
+		mr[nr_range - 1].end - 1, pgt_buf_start << PAGE_SHIFT,
  		(pgt_buf_top << PAGE_SHIFT) - 1);
  }

@@ -267,7 +271,7 @@ unsigned long __init_refok 
init_memory_mapping(unsigned long start,
  	 * nodes are discovered.
  	 */
  	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(mr, nr_range);

  	for (i = 0; i < nr_range; i++)
  		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-----------------

> Fixing problems is good :)

At least better than creating them. ;)

Regards,

Alexander
