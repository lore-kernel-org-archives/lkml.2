Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2K3HBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:01:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab2K3HBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:01:43 -0500
X-IronPort-AV: E=Sophos;i="4.83,346,1352044800"; 
   d="scan'208";a="6306271"
Message-ID: <50B859C6.3020707@cn.fujitsu.com>
Date: Fri, 30 Nov 2012 15:01:26 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, bcrl@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, hughd@google.com, cl@linux.com, mgorman@suse.de,
        minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121129153930.477e9709.akpm@linux-foundation.org> <50B82B0D.8010206@cn.fujitsu.com> <20121129215749.acfd872a.akpm@linux-foundation.org>
In-Reply-To: <20121129215749.acfd872a.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 15:01:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 15:01:12,
	Serialize complete at 2012/11/30 15:01:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/30/2012 01:57 PM, Andrew Morton wrote:
> On Fri, 30 Nov 2012 11:42:05 +0800 Lin Feng <linfeng@cn.fujitsu.com> wrote:
> 
>> hi Andrew,
>>
>> On 11/30/2012 07:39 AM, Andrew Morton wrote:
>>> Tricky.
>>>
>>> I expect the same problem would occur with pages which are under
>>> O_DIRECT I/O.  Obviously O_DIRECT pages won't be pinned for such long
>>> periods, but the durations could still be lengthy (seconds).
>> the offline retry timeout duration is 2 minutes, so to O_DIRECT pages 
>> seem maybe not a problem for the moment.
>>>
>>> Worse is a futex page, which could easily remain pinned indefinitely.
>>>
>>> The best I can think of is to make changes in or around
>>> get_user_pages(), to steal the pages from userspace and replace them
>>> with non-movable ones before pinning them.  The performance cost of
>>> something like this would surely be unacceptable for direct-io, but
>>> maybe OK for the aio ring and futexes.
>> thanks for your advice.
>> I want to limit the impact as little as possible, as mentioned above,
>> direct-io seems not a problem, we needn't touch them. Maybe we can 
>> just change the use of get_user_pages()(in or around) such as aio 
>> ring pages. I will try to find a way to do this.
> 
> What about futexes?
hi Andrew,

Yes, better to find an approach to solve them all.
 
But I'm worried about that if we just confine get_user_pages() to use 
none-movable pages, it will drain the none-movable pages soon. Because
there are many places using get_user_pages() such as some drivers. 

IMHO in most cases get_user_pages() callers should release the pages soon, 
so pages allocated from movable zone should be OK. But I'm not sure if
we get such rule upon get_user_pages(). 
And in other cases we specify get_user_pages() to allocate pages from
none-movable zone. 

So could we add a zone-alloc flags when we call get_user_pages()?

Thanks,
linfeng

> 

