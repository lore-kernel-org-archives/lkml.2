Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0G0GLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:11:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41134 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0GLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FWps23KOXZNrMdj70ISMUT23os+i/8UpBNJe+XGKNy+YQ/hQEA5bXKDCICDAw7iYbY
         ZI5Ma1zZCo5puJTesfA1gGHLRqhDVKVjgjI0a+tXEIJv1SHBtosrIFhs1F9/sv3KPQOT
         PXP15n68qc3BIco7ODu4Bj5zIbgu4+YDZ4fp4=
MIME-Version: 1.0
In-Reply-To: <pfn.valid.v4.reply.1@mdm.bga.com>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1007261136160.5438@router.home>
	<pfn.valid.v4.reply.1@mdm.bga.com>
Date: Tue, 27 Jul 2010 15:11:12 +0900
Message-ID: <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Minchan Kim <minchan.kim@gmail.com>
To: miltonm@bga.com
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 2:55 PM,  <miltonm@bga.com> wrote:
> [Sorry if i missed or added anyone on cc, patchwork.kernel.org  LKML is not
> working and I'm not subscribed to the list ]

Readd them. :)

>
> On Mon Jul 26 2010 about 12:47:37 EST, Christoph Lameter wrote:
>> On Tue, 27 Jul 2010, Minchan Kim wrote:
>>
>> > This patch registers address of mem_section to memmap itself's page struct's
>> > pg->private field. This means the page is used for memmap of the section.
>> > Otherwise, the page is used for other purpose and memmap has a hole.
>
>>
>> > +void mark_valid_memmap(unsigned long start, unsigned long end);
>> > +
>> > +#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
>> > +static inline int memmap_valid(unsigned long pfn)
>> > +{
>> > + struct page *page = pfn_to_page(pfn);
>> > + struct page *__pg = virt_to_page(page);
>> > + return page_private(__pg) == (unsigned long)__pg;
>>
>>
>> What if page->private just happens to be the value of the page struct?
>> Even if that is not possible today, someday someone may add new
>> functionality to the kernel where page->pivage == page is used for some
>> reason.
>>
>> Checking for PG_reserved wont work?
>
> I had the same thought and suggest setting it to the memory section block,
> since that is a uniquie value (unlike PG_reserved),

You mean setting pg->private to mem_section address?
I hope I understand your point.

Actually, KAMEZAWA tried it at first version but I changed it.
That's because I want to support this mechanism to ARM FLATMEM.(It
doesn't have mem_section)


>
>> > static inline int pfn_valid(unsigned long pfn)
>> > {
>> > + struct mem_section *ms;
>> > if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
>> > return 0;
>> > - return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
>> > + ms = __nr_to_section(pfn_to_section_nr(pfn));
>> > + return valid_section(ms) && memmap_valid(pfn);
>
> .. and we already have computed it when we use it so we could pass it as
> a parameter (to both _valid and mark_valid).

I hope this can support FALTMEM which have holes(ex, ARM).

>
> milton
>



-- 
Kind regards,
Minchan Kim
