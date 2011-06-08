Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1FHOpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:45:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1FHOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:45:42 -0400
Message-ID: <4DEF8B10.6060904@monstr.eu>
Date: Wed, 08 Jun 2011 16:45:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Williams <john.williams@petalogix.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Look for physical address from user space address/fixup - NET_DMA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I do some investigation how to speedup memory operations 
(memcopy/memset/copy_tofrom_user/etc) by dma to improve ethernet performance 
(currently for PAGE_SIZE operations).

I profiled kernel and copy_tofrom_user is the weakest place for network 
operations. I have optimize it by loop unrolling which gave me 20% better 
throughput but still no enough.

Then I added hw dma to the design and changed u-boot mem operations (saved me 5s 
in bootup time - loading 20MB kernel through 100Mbit/s LAN) and also I have add 
support to Linux memcpy (haven't measured improvement but there is some).

For copy_tofrom_user is situation a little bit complicated but I have prototyped 
it by dma without fixup to see improvement. There could be next 20%.

Based on this I have measured spending time on this code and I found that most 
of the time is spent on looking for physical address from user space address.
I need to get physical address because dma requires it. It is around 70% of 
total time.

I use for Microblaze the part of code shown below but it is slow. Do you know 
how to do it faster?

	pmd_t *pmdp;
	pte_t *ptep;
	pmdp = pmd_offset(pud_offset(
			pgd_offset(current->mm, address),
					address), address);

	preempt_disable();
	ptep = pte_offset_map(pmdp, address);
	if (pte_present(*ptep)) {
		address = (unsigned long) page_address(pte_page(*ptep));
		/* MS: I need add offset in page */
		address += address & ~PAGE_MASK;
		/* MS address is virtual */
		address = virt_to_phys(address);
	}
	pte_unmap(ptep);
	preempt_enable();


Currently this is my bottleneck to get better improvement.

Not sure if someone has ever tried to replace by dma with fixup support. That's 
the second thing where I would like to hear your opinion. Would it be possible 
to simplify it by access user space address and address + PAGE_SIZE? Or any 
other scheme?

There is also one option NET_DMA where I expect that dma will be used instead of 
mem operations. Is it correct assumption? Because I see that there are no irqs 
coming from dma. Dma test is working well.

Eric, David: How is it supposed to work?


Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
