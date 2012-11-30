Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2K3HNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:13:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50957 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2K3HNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:13:45 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B85C8C.2030702@jp.fujitsu.com>
Date: Fri, 30 Nov 2012 16:13:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        mhocko@suse.cz, hughd@google.com, cl@linux.com, mgorman@suse.de,
        minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121129153930.477e9709.akpm@linux-foundation.org> <50B82B0D.8010206@cn.fujitsu.com> <20121129215749.acfd872a.akpm@linux-foundation.org>
In-Reply-To: <20121129215749.acfd872a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/30 14:57), Andrew Morton wrote:
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
>

IIUC, futex's key is now a pair of (mm,address) or (inode, pgoff).
Then, get_user_page() in futex.c will release the page by put_page().
'struct page' is just touched by get_futex_key() to obtain page->mapping info.

Thanks,
-Kame





