Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1CHSyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:54:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57784 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1CHSyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uo7elJqkhRVoVmBfiOg3I10tOedm7eXrc32FGPbn9v7KHEnDcSPNyza3ldGUQN3HUR
         IiKcw8+dZ6xy5qDy4fZ6sCvBUAyy3n1z+gkMAeMK7renYHdIfMqqn8XTvBqr1BlM1097
         lHXHpGqNCPuUUWUAvnw9cCAcmg3OGAQ91bE2U=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103081728300.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
	<4D6D6980.7060304@kernel.org>
	<alpine.DEB.2.00.1103071527500.2968@kaball-desktop>
	<AANLkTi=aUGdjvtvy81FimMZB5PZNzASXHN0BZHWHUuLs@mail.gmail.com>
	<alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
	<AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com>
	<alpine.DEB.2.00.1103081728300.2968@kaball-desktop>
Date: Tue, 8 Mar 2011 10:54:51 -0800
X-Google-Sender-Auth: p1GVpXnsF7vW8Re4T9YfqP78C9Q
Message-ID: <AANLkTinkA5UNfdAqhnJYgC+czPrNYtOtfY332JCvZXy-@mail.gmail.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 9:40 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Tue, 8 Mar 2011, Yinghai Lu wrote:
>> On Tue, Mar 8, 2011 at 4:14 AM, Stefano Stabellini
>> <stefano.stabellini@eu.citrix.com> wrote:
>> >> > [    0.000000] DEBUG alloc low page(cf965000, 00001000)
>> >>
>> >> these are not mapped yet, and need to use early_ioremap.
>> >
>> > In fact we are mapping them inside alloc_low_page. No need for
>> > map_low_page, right?
>>
>> alloc_low_page return virtual address, but it can not be used to
>> access that position right away.
>> so in that case map_low_page is used to convert that virtual address
>> to phy address and then to early map address.
>
> Are you sure?
> I am looking at this piece of code under kernel_physical_mapping_init:
>
>
> ---
>        pud = alloc_low_page(&pud_phys);
>                last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
>                                                 page_size_mask);
>                unmap_low_page(pud);
> ---
>
> and the implementaion of alloc_low_page is:
>
> ---
> static __ref void *alloc_low_page(unsigned long *phys)
> {
>        unsigned long pfn = pgt_buf_end++;
>        void *adr;
>
>        if (after_bootmem) {
>                adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
>                *phys = __pa(adr);
>
>                return adr;
>        }
>
>        if (pfn >= pgt_buf_top)
>                panic("alloc_low_page: ran out of memory");
>
>        adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
>        clear_page(adr);
>        *phys  = pfn * PAGE_SIZE;
>        return adr;
> }
> ---
>
> It looks to me that map_low_page is never called in this code path.
> If I read the code correctly map_low_page is only used to map pagetable
> pages that are already mapped (see the debug logging I posted in the
> previous email) so it is not useful.


[    0.000000] kernel direct mapping tables up to 7f750000 @
[0x7f74c000-0x7f74ffff] pre-allocated
[    0.000000] DEBUG map_low_page phys    243a000
[    0.000000] DEBUG map_low_page phys    243e000
[    0.000000] DEBUG alloc_low_page phys   7f74c000
[    0.000000] DEBUG map_low_page phys    243a000
[    0.000000] DEBUG map_low_page phys   7f74c000
[    0.000000] DEBUG alloc_low_page phys   7f74d000
