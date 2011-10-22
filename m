Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1JVALg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 20:11:36 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:33438 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1JVALe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 20:11:34 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 21 Oct 2011 20:11:20 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyJaCUrvXZyeXB1SKm7oyeqjmKcKwG5dKXq
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B2@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
 <20110901100650.6d884589.rdunlap@xenotime.net>
 <20110901152650.7a63cb8b@annuminas.surriel.com>
 <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com>
 <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com>
 <4E959292.9060301@redhat.com>
 <alpine.DEB.2.00.1110121316590.7646@chino.kir.corp.google.com>
 <4E966564.5030902@redhat.com>,<alpine.DEB.2.00.1110122210030.7572@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110122210030.7572@chino.kir.corp.google.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110210304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 01:22 AM, David Rientjes wrote:
> On Thu, 13 Oct 2011, Rik van Riel wrote:
> 
>> Furthermore, I am not sure that giving kswapd more CPU time is
>> going to help, because kswapd could be stuck on some lock, held
>> by a lower priority (or sleeping) context.
>>
>> I agree that the BFS patch would be worth a try, and would be
>> very pleasantly surprised if it worked, but I am not very
>> optimistic about it...
>>
> 
> It may require a combination of Con's patch, increasing the priority of 
> kswapd if a higher priority task kicks it in the page allocator, and an 
> extra bonus on top of the high watermark if it was triggered by a 
> rt-thread -- similar to ALLOC_HARDER but instead reclaiming to 
> (high * 1.25).

I tested Con's patch. The results are following.

1. delayacct result

RECLAIM                     count    delay total  delay average
---------------------------------------------------------------
normal task w/o Con's patch   210       42685857        203us
rt task w/o Con's patch        32        4922368        153us
rt task w   Con's patch        29        4399320        151us


2. /proc/vmstat result
                     normal task w/o  rt task w/o  rt task w/
                         Con's patch  Con's patch  Con's patch
---------------------------------------------------------------------
nr_vmscan_write                    0        13160        14536
pgsteal_dma                        0            0            0
pgsteal_dma32                 182710       175049       169871
pgsteal_normal                 10260         9499        13077
pgsteal_movable                    0            0            0
pgscan_kswapd_dma                  0            0            0
pgscan_kswapd_dma32           127159       149096       147924
pgscan_kswapd_normal           26094        49011        33186
pgscan_kswapd_movable              0            0            0
pgscan_direct_dma                  0            0            0
pgscan_direct_dma32            55551        25923        21947
pgscan_direct_normal            7128         3624         2816
pgscan_direct_movable              0            0            0
kswapd_steal                  134481       157951       159556
kswapd_inodesteal                  0            0            0
kswapd_low_wmark_hit_quickly       0            0            6
kswapd_high_wmark_hit_quickly      0            0            0
allocstall                       324          151          128

Unfortunately, it seems that Con's patch does not improve my
testcase so much. We may need extra bonus on the high watermark if
we take the way above. But necessary bonus depends on workloads,
hardware etc., so it can't be solved with fixed bonus, I think.

> If we're going to go with extra_free_kbytes, then I'd like to see the test 
> case posted with a mathematical formula to show me what I should tune it 
> to be depending on my machine's memory capacity and amount of free RAM 
> when started (and I can use mem= to test it for various capacities).  For 
> this to be merged, there should be a clear expression that shows what the 
> ideal setting of the tunable should be rather than asking for trial-and-
> error to see what works and what doesn't.  If such an expression doesn't 
> exist, then it's clear that the necessary setting will vary significantly 
> as the implementation changes from kernel to kernel.

Hmm, try and error is tuning itself, isn't it? When we tune a system,
we usually set some knobs, run some benchmarks/tests/etc., evaluate
the results and decide which is the appropriate value.

Regards,
Satoru