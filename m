Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1LBT2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:28:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56452 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753866Ab1LBT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:28:28 -0500
Message-ID: <4ED9267F.10106@fb.com>
Date: Fri, 2 Dec 2011 11:26:55 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
References: <20111121145114.049265181@chello.nl>
In-Reply-To: <20111121145114.049265181@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-02_05:2011-12-02,2011-12-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/11 6:51 AM, Peter Zijlstra wrote:
> These few patches implement x86 RDPMC support and add an extention to the self
> monitoring data to also allow additional time updates using userspace TSC reads.
>
> There's a few loose ends, but it mostly seems to work.

I haven't had a chance to test this out yet. But low overhead, always on 
perf counters is something we're very interested in. Thanks for 
implementing it.

However, I suspect the major cost of leaving the perf counters always on 
seems to be in the hit on context switches, rather than the cost of 
reading the perf counters themselves. For eg:

   Baseline:

    (for i in `seq 1 10`; do numactl --cpunodebind 1 ./lat_ctx -P1 -s32k 
4; done) 2>&1 | tee lmbench1.log

   1 event:

   (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -e 
instructions ./lat_ctx -P1 -s32k 4; done) 2>&1 | tee lmbench2.log

   2 events:

   (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -e 
cycles,instructions ./lat_ctx -P1 -s32k 4; done) 2>&1 | tee lmbench3.log

   Baseline: 2.2us
   One event: 6.8us
   Two events: 7.2us

The cost seems to be at roughly 5us (I measured 2.6.38 and 3.2-rc2). 
I'll dig a bit more on what may be going on here.

  -Arun
