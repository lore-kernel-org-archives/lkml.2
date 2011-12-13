Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1LMOkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:40:35 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:45157 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675Ab1LMOke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:40:34 -0500
Message-ID: <4EE763D0.9060003@tao.ma>
Date: Tue, 13 Dec 2011 22:40:16 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] vmscan/trace: Add 'active' and 'file' info to trace_mm_vmscan_lru_isolate.
References: <1323614784-2924-1-git-send-email-tm@tao.ma> <CAEwNFnCXJuH53ks=qPdHkm_hrcm+Nsh7f5APQx6BgQEQBKC_yQ@mail.gmail.com> <20111212112738.GA3277@csn.ul.ie>
In-Reply-To: <20111212112738.GA3277@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.4.198 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 12/12/2011 07:27 PM, Mel Gorman wrote:
> On Mon, Dec 12, 2011 at 09:59:20AM +0900, Minchan Kim wrote:
>>> <SNIP>
>>> @@ -1237,7 +1237,7 @@ static unsigned long isolate_pages_global(unsigned long nr,
>>>        if (file)
>>>                lru += LRU_FILE;
>>>        return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
>>> -                                                               mode, file);
>>> +                                                       mode, active, file);
>>
>> I guess you want to count exact scanning number of which lru list.
>> But It's impossible now since we do lumpy reclaim so that trace's
>> result is mixed by active/inactive list scanning.
>> And I don't like adding new argument for just trace although it's trivial.
>>
> 
> FWIW, lumpy reclaim is why the trace point does not report the active
> or file information. Seeing active==1 does not imply that only active
> pages were isolated and mode is already there as Minchan points out.
OK, thanks for the info.
> 
> Similarly, seeing file==1 does not imply that only file-backed
> pages were isolated. Any processing script that depends on just this
> information would be misleading.  If more information on how much
> each LRU was scanned is required, the mm_vmscan_lru_shrink_inactive
> tracepoint already reports the number of pages scanned, reclaimed
> and whether the pages isolated were anon, file or both so ordinarily
> I would suggest using just that.
So how can I tell the isolation list status when we do shrink_active_list?
> 
> That said, I see that trace_shrink_flags() is currently misleading as
> it should be used sc->order instead of sc->reclaim_mode to determine
> if it was file, anon or a mix of both that was isolated. That should
> be fixed.
sure, I will see how to work it out.
> 
> If isolate_lru_pages really needs to export the file information,
> then it would be preferable to fix trace_shrink_flags() and use it to
> indicate if it was file, anon or a mix of both that was isolated. The
> information needed to trace this is not available in isolate_lru_pages
> so it would need to be passed down. Even with that, I would also
> like to see trace/postprocess/trace-vmscan-postprocess.pl updated to
> illustrate how this new information can be used to debug a problem
> or at least describe what sort of problem it can debug.
Sorry, I don't ever know the existence of this script. And I will update
this script in the next try.
> 
> 
>> I think 'mode' is more proper rather than  specific 'active'.
>> The 'mode' can achieve your goal without passing new argument "active".
>>
> 
> True.
> 
>> In addition to, current mmotm has various modes.
>> So sometime we can get more specific result rather than vauge 'active'.
>>
> 
> Which also means that trace/postprocess/trace-vmscan-postprocess.pl
> is not using mm_vmscan_lru_isolate properly as it does not understand
> ISOLATE_CLEAN and ISOLATE_UNMAPPED. The impact for the script is that
> the scan count it reports will deviate from what /proc/vmstat reports
> which is irritating.
Let me see whether I can fix it or not.

Thanks
Tao
