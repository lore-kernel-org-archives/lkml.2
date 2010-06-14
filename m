Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0FNJD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:03:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38312 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0FNJDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:03:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 17:59:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
Message-Id: <20100614175912.976f5878.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100614091823.34fac7a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <4C11FF10.4060203@jp.fujitsu.com>
	<4C11FFC0.1030006@jp.fujitsu.com>
	<4C1275BF.3070605@zytor.com>
	<20100614091823.34fac7a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 09:18:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 11 Jun 2010 10:43:27 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 06/11/2010 02:20 AM, Kenji Kaneshige wrote:
> > > If the physical address is too high to be handled by ioremap() in
> > > x86_32 PAE (e.g. more than 36-bit physical address), ioremap() must
> > > return error (NULL). However, current x86 ioremap try to map this too
> > > high physical address, and it causes unexpected behavior.
> > 
> > What unexpected behavior?  It is perfectly legitimately to map such a
> > high address in PAE mode.  We have a 36-bit kernel-imposed limit on
> > *RAM* in 32-bit mode (because we can't manage more than that), but there
> > is no reason it should apply to I/O.
> > 
> 
> I'm sorry for lack of study. 

Now, __ioremap_caller() gets 64 bit argument as physical address.
== 2.6.35-rc2 ==
static void __iomem *__ioremap_caller(resource_size_t phys_addr,
                unsigned long size, unsigned long prot_val, void *caller)
{
==

And check physical address is valid based on the value got from cpuid.
==
      if (!phys_addr_valid(phys_addr)) {
                printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
                       (unsigned long long)phys_addr);
                WARN_ON_ONCE(1);
                return NULL;
        }
==


At 1st, this seems buggy.
==
        /*
         * Don't allow anybody to remap normal RAM that we're using..
         */
        for (pfn = phys_addr >> PAGE_SHIFT;
                                (pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
                                pfn++) {

                int is_ram = page_is_ram(pfn);

                if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
                        return NULL;
                WARN_ON_ONCE(is_ram);
        }
==
If phys_addr > 44bit, pfn should be 64bit. don't it ?
Then, page_is_ram should eat 64bit arguments.

But here, assume phys_addr < 44bit and continue.

Next,
===
      offset = phys_addr & ~PAGE_MASK;
        phys_addr &= PAGE_MASK;
        size = PAGE_ALIGN(last_addr+1) - phys_addr;

this mask ops is bad. as the patch-1 shows.

And, finally, calls get_vm_area.

==
        /*
         * Ok, go for it..
         */
        area = get_vm_area_caller(size, VM_IOREMAP, caller);
        if (!area)
                goto err_free_memtype;
        area->phys_addr = phys_addr;
        vaddr = (unsigned long) area->addr;
==
Because area->phys_addr is 32bit. This may break something if we unmap this later.

And, page table operation is this.
==
       if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
                goto err_free_area;
==

Let's see lib/ioremap.c
==
int ioremap_page_range(unsigned long addr,
                       unsigned long end, unsigned long phys_addr, pgprot_t prot)
{
        pgd_t *pgd;
   
==

Oh, phys_addr is unsigned long again....Then, Kenji-san, what's buggy is this check.
I think.

Thanks,
-Kame





