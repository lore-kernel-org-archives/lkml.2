Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1JMQzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:55:11 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:40521 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1JMQzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:55:09 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>, Con Kolivas <kernel@kolivas.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Thu, 13 Oct 2011 12:54:40 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyIbLQWyqHT8m0YR2KMWptekQzjowBW8jhg
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB516D459@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
 <20110901100650.6d884589.rdunlap@xenotime.net>
 <20110901152650.7a63cb8b@annuminas.surriel.com>
 <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
 <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=34 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110130169
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 07:22 PM, David Rientjes wrote:
> On Tue, 11 Oct 2011, Satoru Moriya wrote:
> 
> I don't know if your test case is the only thing that Rik is looking 
> at, but if so, then that statement makes me believe that this patch is 
> definitely in the wrong direction, so NACK on it until additional 
> information is presented.  The reasoning is simple: if tuning the 
> bonus given to rt-tasks in the page allocator itself would fix the 
> issue, then we can certainly add logic specifically for rt-tasks that 
> can reclaim more aggressively without needing any tunable from 
> userspace (and _certainly_ not a global tunable that affects every application!).

My test case is just a simple one (maybe too simple), and I tried
to demonstrate following issues that current kernel has with it.

1. Current kernel uses free memory as pagecache.
2. Applications may allocate memory burstly and when it happens
   they may get a latency issue because there are not enough free
   memory. Also the amount of required memory is wide-ranging.
3. Some users would like to control the amount of free memory
   to avoid the situation above.
4. User can't setup the amount of free memory explicitly.
   From user's point of view, the amount of free memory is the delta
   between high watermark - min watermark because below min watermark
   user applications incur a penalty (direct reclaim). The width of
   delta depends on min_free_kbytes, actually min watermark / 2, and
   so if we want to make free memory bigger, we must make
   min_free_kbytes bigger. It's not a intuitive and it introduces
   another problem that is possibility of direct reclaim is increased.

I think my test case is too simple and so we may be able to avoid
the latency issue with my case by setting the workload rt-task,
improving how to decide rt-task bonus and/or introducing the
Con's patches below.

But my concern described above is still alive because whether
latency issue happen or not depends on how heavily workloads
allocate memory at a short time. Of cource we can say same
things for extra_free_kbytes, but we can change it and test
an effect easily.

>>> Does there exist anything like a test case which demonstrates the 
>>> need for this feature?
>>
>> Unfortunately I don't have a real test case but just simple one.
>> And in my simple test case, I can avoid direct reclaim if we set 
>> workload as rt-task.
>>
>> The simple test case I used is following:
>> http://marc.info/?l=linux-mm&m=131605773321672&w=2
>>
> 
> I tried proposing one of Con's patches from his BFS scheduler ("mm: 
> adjust kswapd nice level for high priority page") about 1 1/2 years 
> ago that I recall and believe may significantly help your test case.  
> The thread is at http://marc.info/?t=126743860700002.  (There's a lot 
> of interesting things in Con's patchset that can be pulled into the 
> VM, this isn't the only one.)
> 
> The patch wasn't merged back then because we wanted a test case that 
> was specifically fixed by this issue, and it may be that we have just 
> found one.  If you could try it out without any extra_free_kbytes, I 
> think we may be able to help your situation.

Thank you, David. I'll try my simple workload with it.

Regards,
Satoru
