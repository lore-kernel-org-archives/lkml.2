Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0KVAao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:30:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42114 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0KVAam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SWcrPwlpqUfXnqQ7AU5ySgiw+9fyS0JsgTlDhBsojAysAwLbMqvVvKG2Nz3BtFmPqR
         D1Rl/syEwBDvm7HVfLllEldbnOmdIjxBF5oxvnTXmDt4zaeZ3KzlH/YjmZEuN1aLZz3Y
         2ZR0691aTVP3kgBkN8P941zGoPdDrG7yo5Nyo=
MIME-Version: 1.0
In-Reply-To: <20101119125653.16dd5452.akpm@linux-foundation.org>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20101119125653.16dd5452.akpm@linux-foundation.org>
Date: Mon, 22 Nov 2010 02:30:39 +0200
Message-ID: <AANLkTikyjzyT7EW02gXBV+9vnFnHYBUURKizdx9wetib@mail.gmail.com>
Subject: Re: [PATCH 0/4] big chunk memory allocator v4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, m.nazarewicz@samsung.com,
        pawel@osciak.com, andi.kleen@intel.com,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 19 Nov 2010 17:10:33 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Hi, this is an updated version.
>>
>> No major changes from the last one except for page allocation function.
>> removed RFC.
>>
>> Order of patches is
>>
>> [1/4] move some functions from memory_hotplug.c to page_isolation.c
>> [2/4] search physically contiguous range suitable for big chunk alloc.
>> [3/4] allocate big chunk memory based on memory hotplug(migration) technique
>> [4/4] modify page allocation function.
>>
>> For what:
>>
>>   I hear there is requirements to allocate a chunk of page which is larger than
>>   MAX_ORDER. Now, some (embeded) device use a big memory chunk. To use memory,
>>   they hide some memory range by boot option (mem=) and use hidden memory
>>   for its own purpose. But this seems a lack of feature in memory management.

Actually, now that's not needed any more by using memblock:
http://article.gmane.org/gmane.linux.ports.arm.omap/44978

>>   This patch adds
>>       alloc_contig_pages(start, end, nr_pages, gfp_mask)
>>   to allocate a chunk of page whose length is nr_pages from [start, end)
>>   phys address. This uses similar logic of memory-unplug, which tries to
>>   offline [start, end) pages. By this, drivers can allocate 30M or 128M or
>>   much bigger memory chunk on demand. (I allocated 1G chunk in my test).
>>
>>   But yes, because of fragmentation, this cannot guarantee 100% alloc.
>>   If alloc_contig_pages() is called in system boot up or movable_zone is used,
>>   this allocation succeeds at high rate.
>
> So this is an alternatve implementation for the functionality offered
> by Michal's "The Contiguous Memory Allocator framework".
>
>>   I tested this on x86-64, and it seems to work as expected. But feedback from
>>   embeded guys are appreciated because I think they are main user of this
>>   function.
>
> From where I sit, feedback from the embedded guys is *vital*, because
> they are indeed the main users.
>
> Michal, I haven't made a note of all the people who are interested in
> and who are potential users of this code.  Your patch series has a
> billion cc's and is up to version 6.  Could I ask that you review and
> test this code, and also hunt down other people (probably at other
> organisations) who can do likewise for us?  Because until we hear from
> those people that this work satisfies their needs, we can't really
> proceed much further.

As I've explained before, a contiguous memory allocator would be nice,
but on ARM many drivers not only need contiguous memory, but
non-cacheable, and this requires removing the memory from normal
kernel mapping in early boot.

Cheers.

-- 
Felipe Contreras
