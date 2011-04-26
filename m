Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1DZHlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:41:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56282 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282Ab1DZHlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SBpuYn+KgE/IzKLcN2vKFb/hZf5iqF3EPWy2yt+gwf3zu9nItmNRULXMtQe3erWCaV
         cfUcBh5VdnMx7pBHmXdw964uqKan3nAqhpdeQB0OxsabHyK9+P9rIGTnxKBQysIF0spv
         Tg1xTNO1zxMQeLQ6GK7khldd+GFsMJJEQEaz8=
MIME-Version: 1.0
In-Reply-To: <20110426063421.GC19717@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
Date: Tue, 26 Apr 2011 16:41:04 +0900
Message-ID: <BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
Subject: Re: readahead and oom
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Tue, Apr 26, 2011 at 3:34 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Apr 26, 2011 at 02:29:15PM +0800, Dave Young wrote:
>> On Tue, Apr 26, 2011 at 2:25 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > On Tue, Apr 26, 2011 at 02:07:17PM +0800, Dave Young wrote:
>> >> On Tue, Apr 26, 2011 at 2:05 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> >> > On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >> >> On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
>> >> >>> Hi,
>> >> >>>
>> >> >>> When memory pressure is high, readahead could cause oom killing.
>> >> >>> IMHO we should stop readaheading under such circumstances。If it's true
>> >> >>> how to fix it?
>> >> >>
>> >> >> Good question. Before OOM there will be readahead thrashings, which
>> >> >> can be addressed by this patch:
>> >> >>
>> >> >> http://lkml.org/lkml/2010/2/2/229
>> >> >
>> >> > Hi, I'm not clear about the patch, could be regard as below cases?
>> >> > 1) readahead alloc fail due to low memory such as other large allocation
>> >>
>> >> For example vm balloon allocate lots of memory, then readahead could
>> >> fail immediately and then oom
>> >
>> > If true, that would be the problem of vm balloon. It's not good to
>> > consume lots of memory all of a sudden, which will likely impact lots
>> > of kernel subsystems.
>> >
>> > btw readahead page allocations are completely optional. They are OK to
>> > fail and in theory shall not trigger OOM on themselves. We may
>> > consider passing __GFP_NORETRY for readahead page allocations.
>>
>> Good idea, care to submit a patch?
>
> Here it is :)
>
> Thanks,
> Fengguang
> ---
> readahead: readahead page allocations is OK to fail
>
> Pass __GFP_NORETRY for readahead page allocations.
>
> readahead page allocations are completely optional. They are OK to
> fail and in particular shall not trigger OOM on themselves.
>
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/pagemap.h |    5 +++++
>  mm/readahead.c          |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> --- linux-next.orig/include/linux/pagemap.h     2011-04-26 14:27:46.000000000 +0800
> +++ linux-next/include/linux/pagemap.h  2011-04-26 14:29:31.000000000 +0800
> @@ -219,6 +219,11 @@ static inline struct page *page_cache_al
>        return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
>  }
>
> +static inline struct page *page_cache_alloc_cold_noretry(struct address_space *x)
> +{
> +       return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_NORETRY);

It makes sense to me but it could make a noise about page allocation
failure. I think it's not desirable.
How about adding __GFP_NOWARAN?


-- 
Kind regards,
Minchan Kim
