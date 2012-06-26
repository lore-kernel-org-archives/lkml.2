Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2FZDOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:14:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48011 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2FZDON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:14:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE9284F.5040001@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 12:11:11 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com> <4FE8CCCD.7080503@redhat.com> <alpine.DEB.2.00.1206251726040.1895@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206251726040.1895@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/26 9:32), David Rientjes wrote:
> On Mon, 25 Jun 2012, Rik van Riel wrote:
>
>> The patch makes sense, however I wonder if it would make
>> more sense in the long run to allow migrate/compaction to
>> temporarily exceed the memcg memory limit for a cgroup,
>> because the original page will get freed again soon anyway.
>>
>> That has the potential to improve compaction success, and
>> reduce compaction related CPU use.
>>
>
> Yeah, Kame brought up the same point with a sample patch by allowing the
> temporary charge for the new page.  It would certainly solve this problem
> in a way that we don't have to even touch compaction, it's disappointing
> that we have to charge memory to do a page migration.  I'm not so sure
> about the approach of temporarily allowing the excess charge, however,
> since it would scale with the number of cpus doing compaction or
> migration, which could end up with PAGE_SIZE * nr_cpu_ids.
>

I don't think it's problem. Even if there are 4096 cpus, it's only 16MB
on that system, which tends to have terabytes of memory.
(We already have 32pages of per-cpu-cache....)

I'd like to post that patch with updating to mmotm.

> I haven't looked at it (yet), but I'm hoping that there's a way to avoid
> charging the temporary page at all until after move_to_new_page()
> succeeds, i.e. find a way to uncharge page before charging newpage.

Hmm...this code has been verrry racy and we did many mis-accounting.
So, I'd like to start from a safe way.

THanks,
-Kame


