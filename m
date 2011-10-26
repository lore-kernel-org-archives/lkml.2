Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1JZTAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:00:09 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:32879 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1JZTAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:00:07 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Wed, 26 Oct 2011 14:59:17 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyTYDbXBJTOX34hQ3Wt4TyFmqWAIwAsSVhZ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B4@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
 <20110901100650.6d884589.rdunlap@xenotime.net>
 <20110901152650.7a63cb8b@annuminas.surriel.com>
 <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
 <20111011125419.2702b5dc.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
 <20111011135445.f580749b.akpm@linux-foundation.org>
 <4E95917D.3080507@redhat.com>
 <20111012122018.690bdf28.akpm@linux-foundation.org>,<4E95F167.5050709@redhat.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B1@USINDEVS02.corp.hds.com>,<alpine.DEB.2.00.1110231419070.17218@chino.kir.corp.google.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B3@USINDEVS02.corp.hds.com>,<alpine.DEB.2.00.1110251446340.26017@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110251446340.26017@chino.kir.corp.google.com>
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
 definitions=main-1110260203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

emaOn 10/25/2011 05:50 PM, David Rientjes wrote:
> On Mon, 24 Oct 2011, Satoru Moriya wrote:
> 
>>>> We do.
>>>> Basically we need this kind of feature for almost all our latency
>>>> sensitive applications to avoid latency issue in memory allocation.
>>>
>>> These are all realtime?
>>
>> Do you mean that these are all realtime process?
>>
>> If so, answer is depending on the situation. In the some situations,
>> we can set these applications as rt-task. But the other situation,
>> e.g. using some middlewares, package softwares etc, we can't set them
>> as rt-task because they are not built for running as rt-task. And also
>> it is difficult to rebuilt them for working as rt-task because they
>> usually have huge code base.
>>
> 
> If this problem affects processes that aren't realtime, then your only 
> option is to increase /proc/sys/vm/min_free_kbytes.  It's unreasonable to 
> believe that the VM should be able to reclaim in the background at the 
> same rate that an application is allocating huge amounts of memory without 
> allowing there to be a buffer.  Adding another tunable isn't going to 
> address that situation better than min_free_kbytes.


Even if allocating memory in user space causes latency issues, usually
allocation itself doesn't continue for a long time. Therefore if we
can keep enough free memory, we can avoid latency issue in this situation.

min_free_kbytes makes min wmark bigger too. It means that the amount of
memory user processes can use without penalty(direct reclaim) decrease
unnecessarily, this is what we'd like to avoid.


>> As I reported another mail, changing kswapd priority does not mitigate
>> even my simple testcase very much. Of course, reclaiming above the high
>> wmark may solve the issue on some workloads but if an application can
>> allocate memory more than high wmark - min wmark which is extended and
>> fast enough, latency issue will happen.
>> Unless this latency concern is fixed, customers doesn't use vanilla
>> kernel.
>>
> And you have yet to provide an expression that shows what a sane setting 
> for this tunable will be.  In fact, it seems like you're just doing trial 
> and error and finding where it works pretty well for a certain VM 
> implementation in a certain kernel.  That's simply not a maintainable 
> userspace interface!


Try and error is tuning itself. When we tune a system, we usually set
some knobs, run some benchmarks/tests/etc., evaluate results and
decide which is the best configuration.

Regards,
Satoru