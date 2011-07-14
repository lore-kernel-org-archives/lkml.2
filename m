Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1GNDUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:20:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52347 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1GNDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:20:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1E6086.4060902@jp.fujitsu.com>
Date: Thu, 14 Jul 2011 12:20:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: page allocator: Reconsider zones for allocation
 after direct reclaim
References: <1310389274-13995-1-git-send-email-mgorman@suse.de> <1310389274-13995-4-git-send-email-mgorman@suse.de> <4E1CE9FF.3050707@jp.fujitsu.com> <20110713111017.GG7529@suse.de>
In-Reply-To: <20110713111017.GG7529@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/13 20:10), Mel Gorman wrote:
> On Wed, Jul 13, 2011 at 09:42:39AM +0900, KOSAKI Motohiro wrote:
>> (2011/07/11 22:01), Mel Gorman wrote:
>>> With zone_reclaim_mode enabled, it's possible for zones to be considered
>>> full in the zonelist_cache so they are skipped in the future. If the
>>> process enters direct reclaim, the ZLC may still consider zones to be
>>> full even after reclaiming pages. Reconsider all zones for allocation
>>> if direct reclaim returns successfully.
>>>
>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>
>> Hmmm...
>>
>> I like the concept, but I'm worry about a corner case a bit.
>>
>> If users are using cpusets/mempolicy, direct reclaim don't scan all zones.
>> Then, zlc_clear_zones_full() seems too aggressive operation.
> 
> As the system is likely to be running slow if it is in direct reclaim
> that the complexity of being careful about which zone was cleared was
> not worth it.
> 
>> Instead, couldn't we turn zlc->fullzones off from kswapd?
>>
> 
> Which zonelist should it clear (there are two) and when should it
> happen? If it clears it on each cycle around balance_pgdat(), there
> is no guarantee that it'll be cleared between when direct reclaim
> finishes and an attempt is made to allocate.

Hmm..

Probably I'm now missing the point of this patch. Why do we need
to guarantee tightly coupled zlc cache and direct reclaim? IIUC,
zlc cache mean "to avoid free list touch if they have no free mem".
So, any free page increasing point is acceptable good, I thought.
In the other hand, direct reclaim finishing has no guarantee to
zones of zonelist have enough free memory because it has bailing out logic.

So, I think we don't need to care zonelist, just kswapd turn off
their own node.

And, just curious, If we will have a proper zlc clear point, why
do we need to keep HZ timeout?









