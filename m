Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0IDBMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:12:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IDBMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GCFOtnjFI/xsMiGXdxX1SdctQhSmjPLRnBkNnOhMgWvwxMQTgZlumgcqs2u3DXL4oL
         mBuoptMtGTYJh8jmvfQw==
MIME-Version: 1.0
In-Reply-To: <20100903145646.15063c1d.akpm@linux-foundation.org>
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
	<20100903140649.09dee316.akpm@linux-foundation.org>
	<AANLkTimTpj+CSvGx=HC4qnArBV9jxORkKoDA9eap3_cN@mail.gmail.com>
	<20100903145646.15063c1d.akpm@linux-foundation.org>
Date: Fri, 3 Sep 2010 18:12:03 -0700
Message-ID: <AANLkTi=gDnMjTfC756wABD_K6evk+hEOtp_7JVvnwjki@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Venkatesh Pallipadi <venki@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 2:56 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 3 Sep 2010 14:47:03 -0700
> Ying Han <yinghan@google.com> wrote:
>
>> > We don't have any quantitative data on the effect of these excess tlb
>> > flushes, which makes it difficult to decide which kernel versions
>> > should receive this patch.
>> >
>> > Help?
>>
>> Andrew:
>>
>> We observed the degradation on 2.6.34 compared to 2.6.26 kernel. The
>> workload we are running is doing 4k-random-write which runs about 3-4
>> minutes. We captured the TLB shootsdowns before/after:
>>
>> Before the change:
>> TLB: 29435 22208 37146 25332 47952 43698 43545 40297 49043 44843 46127
>> 50959 47592 46233 43698 44690 TLB shootdowns [HSUM =  662798 ]
>>
>> After the change:
>> TLB: 2340 3113 1547 1472 2944 4194 2181 1212 2607 4373 1690 1446 2310
>> 3784 1744 1134 TLB shootdowns [HSUM =  38091 ]
>
> Do you have data on how much additional CPU time (and/or wall time) was
> consumed?
>

Just reran the workload to get this data
- after - before of /proc/interrupts:TLB
- after - before of /proc/stat:cpu
  (output is: "cpu" user nice sys idle iowait irq softirq steal guest guestnice)

Without this change
TLB: 28550 21232 33876 14300 40661 43118 38227 34887 34376 38208 35735
33591 36305 43649 36558 42013 TLB shootdowns [HSUM =  555286 ]
cpu 41056 381 17945 308706 26447 39 9713 0 0 0

With this change
TLB: 660 1088 761 474 778 1050 697 551 712 1353 651 730 788 1419 574
521 TLB shootdowns [HSUM =  12807 ]
cpu 40375 231 16622 204115 19317 36 9464 0 0 0

This is on a 16 way system, so 16 * 100 count in cpu line above counts as 1s.

I don't think all the reduction in CPU time (especially idle time!)
can be attributed to this change. There is some run to run variation
especially with the setup and teardown of the tests. But, there is a
notable reduction in user, system and irq time. For what its worth,
for this particular workload, throughput number reported by the run is
4% up.

Thanks,
Venki
