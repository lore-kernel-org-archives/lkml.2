Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab1D0R4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:56:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab1D0R4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGQusMcThwiI1sObbELWpJ16FVkPiyL5xjXSTe5xK2q6tWL9wpNK6YFB9zT9XbAWw9
         9HKkL+kVDS86fP0MuZbg==
MIME-Version: 1.0
In-Reply-To: <BANLkTim-U3MTnToFPL11NcVnOCig4zJMAQ@mail.gmail.com>
References: <20110427164708.1143395e.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin+rDOWGYq9dg-XcCWs+yT8Yw-VMw@mail.gmail.com>
	<20110427174813.8b34df90.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim-U3MTnToFPL11NcVnOCig4zJMAQ@mail.gmail.com>
Date: Wed, 27 Apr 2011 10:56:11 -0700
Message-ID: <BANLkTi=zoFK2HVC64qqeHVO_kq4KOBLOrA@mail.gmail.com>
Subject: Re: [PATCHv3] memcg: fix get_scan_count for small targets
From: Ying Han <yinghan@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "mgorman@suse.de" <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ying Han <yinghan@google.com>

--Ying
On Wed, Apr 27, 2011 at 2:14 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Wed, Apr 27, 2011 at 5:48 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Wed, 27 Apr 2011 17:48:18 +0900
>> Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>>> On Wed, Apr 27, 2011 at 4:47 PM, KAMEZAWA Hiroyuki
>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> > At memory reclaim, we determine the number of pages to be scanned
>>> > per zone as
>>> >        (anon + file) >> priority.
>>> > Assume
>>> >        scan = (anon + file) >> priority.
>>> >
>>> > If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
>>> > and priority gets higher. This has some problems.
>>> >
>>> >  1. This increases priority as 1 without any scan.
>>> >     To do scan in this priority, amount of pages should be larger than 512M.
>>> >     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
>>> >     batched, later. (But we lose 1 priority.)
>>> >     If memory size is below 16M, pages >> priority is 0 and no scan in
>>> >     DEF_PRIORITY forever.
>>> >
>>> >  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
>>> >     So, x86's ZONE_DMA will never be recoverred until the user of pages
>>> >     frees memory by itself.
>>> >
>>> >  3. With memcg, the limit of memory can be small. When using small memcg,
>>> >     it gets priority < DEF_PRIORITY-2 very easily and need to call
>>> >     wait_iff_congested().
>>> >     For doing scan before priorty=9, 64MB of memory should be used.
>>> >
>>> > Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when
>>> >
>>> >  1. the target is enough small.
>>> >  2. it's kswapd or memcg reclaim.
>>> >
>>> > Then we can avoid rapid priority drop and may be able to recover
>>> > all_unreclaimable in a small zones. And this patch removes nr_saved_scan.
>>> > This will allow scanning in this priority even when pages >> priority
>>> > is very small.
>>> >
>>> > Changelog v2->v3
>>> >  - removed nr_saved_scan completely.
>>> >
>>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>>>
>>> The patch looks good to me but I have a nitpick about just coding style.
>>> How about this? I think below looks better but it's just my private
>>> opinion and I can't insist on my style. If you don't mind it, ignore.
>>>
>>
>> I did this at the 1st try and got bug.....a variable 'file' here is
>> reused and now broken. Renaming it with new variable will be ok, but it
>
> Right you are. I missed that. :)
> Thanks.
>
>
> --
> Kind regards,
> Minchan Kim
>
