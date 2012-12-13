Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2LMXoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:44:04 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:33780 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2LMXoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:44:02 -0500
X-Greylist: delayed 4641 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 18:44:02 EST
From: Satoru Moriya <satoru.moriya@hds.com>
To: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Topic: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Thread-Index: AQHN2LHkBEwhfYwtskuvG7nk0rbXIZgW3T8AgABSm4CAAAnhgIAAFiQw
Date: Thu, 13 Dec 2012 22:25:43 +0000
Message-ID: <8631DC5930FA9E468F04F3FD3A5D007214AD2FA2@USINDEM103.corp.hds.com>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
 <20121213103420.GW1009@suse.de> <20121213152959.GE21644@dhcp22.suse.cz>
 <20121213160521.GG21644@dhcp22.suse.cz>
In-Reply-To: <20121213160521.GG21644@dhcp22.suse.cz>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-13_09:2012-12-13,2012-12-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212130224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/13/2012 11:05 AM, Michal Hocko wrote:> On Thu 13-12-12 16:29:59, Michal Hocko wrote:
>> On Thu 13-12-12 10:34:20, Mel Gorman wrote:
>>> On Wed, Dec 12, 2012 at 04:43:34PM -0500, Johannes Weiner wrote:
>>>> When a reclaim scanner is doing its final scan before giving up and 
>>>> there is swap space available, pay no attention to swappiness 
>>>> preference anymore.  Just swap.
>>>>
>>>> Note that this change won't make too big of a difference for 
>>>> general
>>>> reclaim: anonymous pages are already force-scanned when there is 
>>>> only very little file cache left, and there very likely isn't when 
>>>> the reclaimer enters this final cycle.
>>>>
>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>
>>> Ok, I see the motivation for your patch but is the block inside 
>>> still wrong for what you want? After your patch the block looks like 
>>> this
>>>
>>>                 if (sc->priority || noswap) {
>>>                         scan >>= sc->priority;
>>>                         if (!scan && force_scan)
>>>                                 scan = SWAP_CLUSTER_MAX;
>>>                         scan = div64_u64(scan * fraction[file], denominator);
>>>                 }
>>>
>>> if sc->priority == 0 and swappiness==0 then you enter this block but 
>>> fraction[0] for anonymous pages will also be 0 and because of the 
>>> ordering of statements there, scan will be
>>>
>>> scan = scan * 0 / denominator
>>>
>>> so you are still not reclaiming anonymous pages in the swappiness=0 
>>> case. What did I miss?
>>
>> Yes, now that you have mentioned that I realized that it really 
>> doesn't make any sense. fraction[0] is _always_ 0 for swappiness==0. 
>> So we just made a bigger pressure on file LRUs. So this sounds like a 
>> misuse of the swappiness. This all has been introduced with fe35004f 
>> (mm: avoid swapping out with swappiness==0).
>>
>> I think that removing swappiness check make sense but I am not sure 
>> it does what the changelog says. It should have said that checking 
>> swappiness doesn't make any sense for small LRUs.
>
> Bahh, wait a moment. Now I remember why the check made sense 
> especially for memcg.
> It made "don't swap _at all_ for swappiness==0" for real - you are 
> even willing to sacrifice OOM. Maybe this is OK for the global case 
> because noswap would safe you here (assuming that there is no swap if 
> somebody doesn't want to swap at all and swappiness doesn't play such 
> a big role) but for memcg you really might want to prevent from 
> swapping - not everybody has memcg swap extension enabled and swappiness is handy then.
> So I am not sure this is actually what we want. Need to think about it.

I introduced swappiness check here with fe35004f because, in some
cases, we prefer OOM to swap out pages to detect problems as soon
as possible. Basically, we design the system not to swap out and
so if it causes swapping, something goes wrong.

Regards,
Satoru
