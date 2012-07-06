Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2GFBAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:00:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39334 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2GFBAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120704092006.GH14154@suse.de>
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
	<20120703140705.af23d4d3.akpm@linux-foundation.org>
	<4FF39F0E.4070300@huawei.com>
	<20120704092006.GH14154@suse.de>
Date: Thu, 5 Jul 2012 18:00:09 -0700
X-Google-Sender-Auth: pSIo6RlJwMjr1G7zCDs6CmDpWPU
Message-ID: <CAE9FiQXAuqj5V_ZrZPs3qr93XQS1tCO=qOBP7mCsDCqXQQ5PoQ@mail.gmail.com>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
From: Yinghai Lu <yinghai@kernel.org>
To: Mel Gorman <mgorman@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 2:20 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Jul 04, 2012 at 09:40:30AM +0800, Jiang Liu wrote:
>> > It's a bit ugly calling set_pageblock_order() from both sparse_init()
>> > and from free_area_init_core().  Can we find a single place from which
>> > to call it?  It looks like here:
>> >
>> > --- a/init/main.c~a
>> > +++ a/init/main.c
>> > @@ -514,6 +514,7 @@ asmlinkage void __init start_kernel(void
>> >                __stop___param - __start___param,
>> >                -1, -1, &unknown_bootoption);
>> >
>> > +   set_pageblock_order();
>> >     jump_label_init();
>> >
>> >     /*
>> >
>> > would do the trick?
>> >
>> > (free_area_init_core is __paging_init and set_pageblock_order() is
>> > __init.  I'm too lazy to work out if that's wrong)
>>
>> Hi Andrew,
>>       Thanks for you comments. Yes, this's an issue.
>> And we are trying to find a way to setup  pageorder_block as
>> early as possible. Yinghai has suggested a good way for IA64,
>> but we still need help from PPC experts because PPC has the
>> same issue and I'm not familiar with PPC architecture.
>> We will submit another patch once we find an acceptable
>> solution here.
>
> I think it's overkill to try and do this on a per-architecture basis unless
> you are aware of a case where the per-architecture code cares about the
> value of pageblock_order. I find it implausible that the architecture
> needs to know the value very early in boot as pageblock_order is part of
> the arch-independent memory model. Andrew's suggestion seems reasonable
> to me once the section mess is figured out.

cma, dma_continugous_reserve is referring pageblock_order very early too.
just after init_memory_mapping() for x86's setup_arch.

so set pageblock_order early looks like my -v2 patch is right way.

current question: need to powerpc guys to check who to set that early.

Thanks

Yinghai
