Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2K2UEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:04:13 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50060 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2K2UEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:04:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121129130844.GI19440@n2100.arm.linux.org.uk>
References: <1350956091-5276-1-git-send-email-spang@chromium.org> <20121129130844.GI19440@n2100.arm.linux.org.uk>
From: Michael Spang <spang@chromium.org>
Date: Thu, 29 Nov 2012 15:03:46 -0500
Message-ID: <CAC5F_1=SEDNsWGdPdFXB+RASV2oaRrnoOx46h2jCDwgNAEZXvQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: Fix page counting in mem_init and show_mem
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 8:08 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Oct 22, 2012 at 09:34:51PM -0400, Michael Spang wrote:
>>       for_each_bank (i, mi) {
>>               struct membank *bank = &mi->bank[i];
>> -             unsigned int pfn1, pfn2;
>> -             struct page *page, *end;
>> +             unsigned int start, end, pfn;
>>
>> -             pfn1 = bank_pfn_start(bank);
>> -             pfn2 = bank_pfn_end(bank);
>> +             start = bank_pfn_start(bank);
>> +             end = bank_pfn_end(bank);
>>
>> -             page = pfn_to_page(pfn1);
>> -             end  = pfn_to_page(pfn2 - 1) + 1;
>> +             for (pfn = start; pfn < end; pfn++) {
>> +                     struct page *page;
>> +
>> +                     if (!pfn_valid(pfn))
>> +                             continue;
>
> This is not a very good fix; what this means is that we end up calling
> pfn_valid() for each and every page in the system, and as pfn_valid()
> may not be a simple test (but a search) we should avoid that when we're
> iterating over all pages in the system.
>
> Firstly, the mem blank information is assumed from the very beginning
> to be aligned with the sparsemem split-up.  This comes from the previous
> discontiguous implementation where this was an absolute requirement.  We
> continue to require that.

Little confused here.

On my system, there are 2 membanks and 8 sparsemem sections.
Obviously, the banks have been further divided into sections by
sparsemem. My problem occurs because this code assumes there's a
single struct page array for the whole bank, when really there are
multiple.

Each struct page array is allocated in a separate call to bootmem.
It's disastrous if bootmem can't allocate them contiguously. This
happens on one of my devices with certain kernel options.

>
> Secondly, if you're worred about the stolen memory, then we need to be
> iterating over the memblock information instead of the membank information.
> This is slightly more complex because memblock will merge neighbouring
> regions into one contiguous entry - and this needs to be split up here.
> This is why I persisted with the membank stuff here as that _should_
> already be appropriately split.
>
> In the long run though, moving to memblock and dealing better with the
> split memory maps (rather than looking up each and every page using
> pfn_to_page()) is the right way to go.

Thanks,
Michael
