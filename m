Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1HPMOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 08:14:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63456 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1HPMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 08:14:32 -0400
MIME-Version: 1.0
Date: Tue, 16 Aug 2011 20:14:31 +0800
Message-ID: <CABC36P7ZBQ9JPVUWw-Ec_f7sMPj9tQ0xF_naMqewF1XpA3nopQ@mail.gmail.com>
Subject: arm bootmem_init() - > find_limits() if CONFIG_HIGHMEM max_low will
 be 0
From: Rong Wang <wangrong8602@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all

I'm recently study the linux memory management, and I'm confused by
this function: find_limits() in bootmem_init()

kernel: 2.6.38

void __init bootmem_init(void)          /* arm/mm/init.c */
{
	unsigned long min, max_low, max_high;

	max_low = max_high = 0;

	find_limits(&min, &max_low, &max_high);

------------------------------------------------------------------------------

static void __init find_limits(unsigned long *min, unsigned long
*max_low,                         /* arm/mm/init.c */
	unsigned long *max_high)
{
	struct meminfo *mi = &meminfo;
	int i;

	*min = -1UL;
	*max_low = *max_high = 0;

	for_each_bank (i, mi) {
		struct membank *bank = &mi->bank[i];
		unsigned long start, end;

		start = bank_pfn_start(bank);
		end = bank_pfn_end(bank);

		if (*min > start)
			*min = start;
		if (*max_high < end)
			*max_high = end;
		if (bank->highmem)
			continue;                                            /* Here, if we
CONFIG_HIGHMEM, and the highmem is set to be 1.

           * so max_low will be 0.

           */
		if (*max_low < end)
			*max_low = end;
	}
}

-------------------------------------------------------------------------------------

arm_bootmem_init(min, max_low);                            /* arm/mm/init.c */

-------------------------------------------------------------------------------------

static void __init arm_bootmem_init(unsigned long start_pfn,
	unsigned long end_pfn)
{
	struct memblock_region *reg;
	unsigned int boot_pages;
	phys_addr_t bitmap;
	pg_data_t *pgdat;

	/*
	 * Allocate the bootmem bitmap page.  This must be in a region
	 * of memory which has already been mapped.
	 */
	boot_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
     /* Here, because max_low is 0, and min is the minimum pfn the
board has(normally is not zero)

                                             * so the (end_pfn -
start_pfn) < 0

                                             */

My question is : I do not clearly see how the codes support HIGHMEM ?
and even more, how can the parameter passed to bootmem_bootmap_pages
is a negtive number?

This is my first question to the mail-list, thanks for your help.
