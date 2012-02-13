Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2BMTi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:38:28 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35722 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2BMTi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:38:27 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Robert Nelson" <robertcnelson@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Arnd Bergmann" <arnd@arndb.de>, "Jonathan Corbet" <corbet@lwn.net>,
        "Mel Gorman" <mel@csn.ul.ie>, "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Rob Clark" <rob.clark@linaro.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Linaro-mm-sig] [PATCHv21 12/16] mm: trigger page reclaim in
 alloc_contig_range() to stabilise watermarks
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
 <1328895151-5196-13-git-send-email-m.szyprowski@samsung.com>
 <CAOCHtYi01NVp1j=MX+0-z7ygW5tJuoswn8eWTQp+0Z5mMGdeQw@mail.gmail.com>
Date: Mon, 13 Feb 2012 11:38:22 -0800
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9mt58ch3l0zgt@mpn-glaptop>
In-Reply-To: <CAOCHtYi01NVp1j=MX+0-z7ygW5tJuoswn8eWTQp+0Z5mMGdeQw@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 10, 2012 at 11:32 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> @@ -5637,6 +5642,56 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>>        return ret > 0 ? 0 : ret;
>>  }
>>
>> +/*
>> + * Update zone's cma pages counter used for watermark level calculation.
>> + */
>> +static inline void __update_cma_wmark_pages(struct zone *zone, int count)
>> +{
>> +       unsigned long flags;
>> +       spin_lock_irqsave(&zone->lock, flags);
>> +       zone->min_cma_pages += count;
>> +       spin_unlock_irqrestore(&zone->lock, flags);
>> +       setup_per_zone_wmarks();
>> +}
>> +
>> +/*
>> + * Trigger memory pressure bump to reclaim some pages in order to be able to
>> + * allocate 'count' pages in single page units. Does similar work as
>> + *__alloc_pages_slowpath() function.
>> + */
>> +static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
>> +{
>> +       enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>> +       struct zonelist *zonelist = node_zonelist(0, gfp_mask);
>> +       int did_some_progress = 0;
>> +       int order = 1;
>> +       unsigned long watermark;
>> +
>> +       /*
>> +        * Increase level of watermarks to force kswapd do his job
>> +        * to stabilise at new watermark level.
>> +        */
>> +       __modify_min_cma_pages(zone, count);

On Mon, 13 Feb 2012 10:57:58 -0800, Robert Nelson <robertcnelson@gmail.com> wrote:
> Hi Marek,   This ^^^ function doesn't seem to exist in this patchset,
> is it in another set posted to lkml?

This should read __update_cma_wmark_pages().  Sorry for the incorrect patch.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
