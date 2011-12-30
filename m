Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1L3U3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 15:29:06 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51324 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1L3U3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:29:03 -0500
MIME-Version: 1.0
X-Originating-IP: [89.138.6.173]
In-Reply-To: <20111230160857.GH15729@suse.de>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-6-git-send-email-gilad@benyossef.com>
	<20111223102810.GT3487@suse.de>
	<CAOtvUMd6+ZZVLp-FbbEwbq3UZLRvSRo+_MMYj1aCGT3gBhxMwg@mail.gmail.com>
	<20111230150421.GE15729@suse.de>
	<4EFDD7FA.9000903@tilera.com>
	<20111230160857.GH15729@suse.de>
Date: Fri, 30 Dec 2011 22:29:02 +0200
Message-ID: <CAOtvUMdCJEcDBD2KJ0T=Fygnag4sXaDMziYaH1oyeoQ42iZjaQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mel Gorman <mgorman@suse.de>, Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 6:08 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Fri, Dec 30, 2011 at 10:25:46AM -0500, Chris Metcalf wrote:

>> Alternately, since we really don't want more than one cpu running the drain
>> code anyway, you could imagine using a static cpumask, along with a lock to
>> serialize attempts to drain all the pages.  (Locking here would be tricky,
>> since we need to run on_each_cpu with interrupts enabled, but there's
>> probably some reasonable way to make it work.)
>>
>
> Good suggestion, that would at least shut up my complaining
> about allocation costs! A statically-declared mutex similar
> to hugetlb_instantiation_mutex should do it. The context that
> drain_all_pages is called from will have interrupts enabled.
>
> Serialising processes entering direct reclaim may result in some stalls
> but overall I think the impact of that would be less than increasing
> memory pressure when low on memory.
>

Chris, I like the idea :-)

Actually, assuming for a second that on_each_cpu* and underlying code
wont mind if the cpumask will change mid call (I know it does, just thinking out
loud), you could say you don't even need the lock if you careful in how you
set/unset the per cpu bits of the cpumask, since they track the same thing...

Of course, it'll still cause a load of cache line bouncing, so maybe
it's not worth it.

> It would still be nice to have some data on how much IPIs are reduced
> in practice to confirm the patch really helps.

I agree. I'll prepare the patch and will present the data.

Thanks!
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
