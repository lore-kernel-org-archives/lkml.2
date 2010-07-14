Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0GNHfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:35:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38222 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0GNHfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kldS/p7xKEmtPx+k+SQlsHAccsSQCVv8vk7tydjbsBWH4Z4JJo1hG38IdVnRsJKn9s
         02Nb6tM8BPHWNpN/jr94MTpbTfSmiA3+mTb02V5z0yY/BqQL2ARqJi60sqvrgmYJFSEW
         kFLWLC4vQytcuam0d/mDBNtm7HAVObnLhclgU=
MIME-Version: 1.0
In-Reply-To: <20100714161045.ef028769.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100712155348.GA2815@barrios-desktop>
	<20100713093006.GB14504@cmpxchg.org>
	<20100713154335.GB2815@barrios-desktop>
	<1279038933.10995.9.camel@nimitz>
	<20100713164423.GC2815@barrios-desktop>
	<20100714092301.69e7e628.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTin8tdw4VmfCPHE0TR3f-l7ao8ngQJcepTDPpMAC@mail.gmail.com>
	<20100714161045.ef028769.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 Jul 2010 16:35:22 +0900
Message-ID: <AANLkTilVVKdLNC0OJfVv5N5GGXL9bwXJfOLC5NHE-Qc4@mail.gmail.com>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux@arm.linux.org.uk,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 4:10 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 14 Jul 2010 15:44:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi, Kame.
>>
>> On Wed, Jul 14, 2010 at 9:23 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Wed, 14 Jul 2010 01:44:23 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> > If you _really_ can't make the section size smaller, and the vast
>> >> > majority of the sections are fully populated, you could hack something
>> >> > in.  We could, for instance, have a global list that's mostly readonly
>> >> > which tells you which sections need to be have their sizes closely
>> >> > inspected.  That would work OK if, for instance, you only needed to
>> >> > check a couple of memory sections in the system.  It'll start to suck if
>> >> > you made the lists very long.
>> >>
>> >> Thanks for advise. As I say, I hope Russell accept 16M section.
>> >>
>> >
>> > It seems what I needed was good sleep....
>> > How about this if 16M section is not acceptable ?
>> >
>> > == NOT TESTED AT ALL, EVEN NOT COMPILED ==
>> >
>> > register address of mem_section to memmap itself's page struct's pg->private field.
>> > This means the page is used for memmap of the section.
>> > Otherwise, the page is used for other purpose and memmap has a hole.
>>
>> It's a very good idea. :)
>> But can this handle case that a page on memmap pages have struct page
>> descriptor of hole?
>> I mean one page can include 128 page descriptor(4096 / 32).
> yes.
>
>> In there, 64 page descriptor is valid but remain 64 page descriptor is on hole.
>> In this case, free_memmap doesn't free the page.
>
> yes. but in that case, there are valid page decriptor for 64pages of holes.
> pfn_valid() should return true but PG_reserved is set.
> (This is usual behavior.)
>
> My intention is that
>
>  - When all 128 page descriptors are unused, free_memmap() will free it.
>   In that case, clear page->private of a page for freed page descriptors.
>
>  - When some of page descriptors are used, free_memmap() can't free it
>   and page->private points to &mem_section. We may have memmap for memory
>   hole but pfn_valid() is a function to check there is memmap or not.
>   The bahavior of pfn_valid() is valid.
>   Anyway, you can't free only half of page.

Okay. I missed PageReserved.
Your idea seems to be good. :)

I looked at pagetypeinfo_showblockcount_print.
It doesn't check PageReserved. Instead of it, it does ugly memmap_valid_within.
Can't we remove it and change it with PageReserved?


-- 
Kind regards,
Minchan Kim
