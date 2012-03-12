Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2CLOzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2CLOzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:55:37 -0400
Message-ID: <4F5E0E5C.8040508@redhat.com>
Date: Mon, 12 Mar 2012 10:55:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: Control page reclaim granularity
References: <20120308073412.GA6975@gmail.com> <20120308093514.GA28856@barrios>
In-Reply-To: <20120308093514.GA28856@barrios>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 04:35 AM, Minchan Kim wrote:
> On Thu, Mar 08, 2012 at 03:34:13PM +0800, Zheng Liu wrote:
>> Hi list,
>>
>> Recently we encounter a problem about page reclaim.  I abstract it in here.
>> The problem is that there are two different file types.  One is small index
>> file, and another is large data file.  The index file is mmaped into memory,
>> and application hope that they can be kept in memory and don't be reclaimed
>> too frequently.  The data file is manipulted by read/write, and they should
>> be reclaimed more frequently than the index file.

They should indeed be.  The data pages should not get promoted
to the active list unless they get referenced twice while on
the inactive list.

Mmaped pages, on the other hand, get promoted to the active
list after just one reference.

Also, as long as the inactive file list is larger than the
active file list, we do not reclaim active file pages at
all.

> I  think it's a regression since 2.6.28.
> Before we were trying to keep mapped pages in memory(See calc_reclaim_mapped).
> But we removed that routine when we applied split lru page replacement.
> Rik, KOSAKI. What's the rationale?

One main reason is scalability.  We have to treat pages
in such a way that we do not have to search through
gigabytes of memory to find a few eviction candidates
to place on the inactive list - where they could get
reused and stopped from eviction again.

-- 
All rights reversed
