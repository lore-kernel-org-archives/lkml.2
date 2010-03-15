Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082Ab0COOp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:45:56 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:53429 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab0COOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:45:55 -0400
Message-ID: <4B9E481D.5020709@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 15:45:49 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <20100311154124.e1e23900.akpm@linux-foundation.org> <4B99E19E.6070301@linux.vnet.ibm.com> <20100312020526.d424f2a8.akpm@linux-foundation.org> <20100312104712.GB18274@csn.ul.ie> <4B9A3049.7010602@linux.vnet.ibm.com> <20100312093755.b2393b33.akpm@linux-foundation.org> <20100315122948.GJ18274@csn.ul.ie>
In-Reply-To: <20100315122948.GJ18274@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman wrote:
> On Fri, Mar 12, 2010 at 09:37:55AM -0500, Andrew Morton wrote:
>> On Fri, 12 Mar 2010 13:15:05 +0100 Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> wrote:
>>
>>>> It still feels a bit unnatural though that the page allocator waits on
>>>> congestion when what it really cares about is watermarks. Even if this
>>>> patch works for Christian, I think it still has merit so will kick it a
>>>> few more times.
>>> In whatever way I can look at it watermark_wait should be supperior to 
>>> congestion_wait. Because as Mel points out waiting for watermarks is 
>>> what is semantically correct there.
>> If a direct-reclaimer waits for some thresholds to be achieved then what
>> task is doing reclaim?
>>
>> Ultimately, kswapd. 
> 
> Well, not quite. The direct reclaimer will still wake up after a timeout
> and try again regardless of whether watermarks have been met or not. The
> intention is to back after after direct reclaim has failed. Granted, the
> window during which a direct reclaim finishes and an allocation attempt
> occurs is unnecessarily large. This may be addressed by the patch that
> changes where cond_resched() is called.
> 
>> This will introduce a hard dependency upon kswapd
>> activity.  This might introduce scalability problems.  And latency
>> problems if kswapd if off doodling with a slow device (say), or doing a
>> journal commit.  And perhaps deadlocks if kswapd tries to take a lock
>> which one of the waiting-for-watermark direct relcaimers holds.
>>
> 
> What lock could they be holding? Even if that is the case, the direct
> reclaimers do not wait indefinitily.
> 
>> Generally, kswapd is an optional, best-effort latency optimisation
>> thing and we haven't designed for it to be a critical service. 
>> Probably stuff would break were we to do so.
>>
> 
> No disagreements there.
> 
>> This is one of the reasons why we avoided creating such dependencies in
>> reclaim.  Instead, what we do when a reclaimer is encountering lots of
>> dirty or in-flight pages is
>>
>> 	msleep(100);
>>
>> then try again.  We're waiting for the disks, not kswapd.
>>
>> Only the hard-wired 100 is a bit silly, so we made the "100" variable,
>> inversely dependent upon the number of disks and their speed.  If you
>> have more and faster disks then you sleep for less time.
>>
>> And that's what congestion_wait() does, in a very simplistic fashion. 
>> It's a facility which direct-reclaimers use to ratelimit themselves in
>> inverse proportion to the speed with which the system can retire writes.
>>
> 
> The problem being hit is when a direct reclaimer goes to sleep waiting
> on congestion when in reality there were not lots of dirty or in-flight
> pages. It goes to sleep for the wrong reasons and doesn't get woken up
> again until the timeout expires.
> 
> Bear in mind that even if congestion clears, it just means that dirty
> pages are now clean although I admit that the next direct reclaim it
> does is going to encounter clean pages and should succeed.
> 
> Lets see how the other patch that changes when cond_reched() gets called
> gets on. If it also works out, then it's harder to justify this patch.
> If it doesn't work out then it'll need to be kicked another few times.
> 

Unfortunately "page-allocator: Attempt page allocation immediately after 
direct reclaim" don't help. No improvement in the regression we had 
fixed with the watermark wait patch.

-> *kick*^^


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
