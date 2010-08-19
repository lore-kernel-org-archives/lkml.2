Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0HSNHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:07:08 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:10093 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0HSNHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:07:05 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1418M98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7EHRI-01-GN8-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 14:22:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 0/5] sched: add new 'book' scheduling domain
Message-ID: <20100819122210.GF4659@loge.amd.com>
References: <20100812172544.655648128@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20100812172544.655648128@de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 01:25:44PM -0400, Heiko Carstens wrote:
> This patch set adds (yet) another scheduling domain to the scheduler.

All that stuff reminds me of quite similar patches to introduce a
multi-node scheduling domain for Magny-Cours CPUs.

I am afraid that this stuff won't make it upstream and we both have to
review Peter's suggestions from last year to come up with a more
genarelized/flexible way to handle different scheduling domains.


> The reason for this is that the recent (s390) z196 architecture has
> four cache levels and uniform memory access (sort of -- see below).
> The cpu/cache/memory hierarchy is as follows:

> Each cpu has its private L1 (64KB I-cache + 128KB D-cache) and L2 (1.5MB)
> cache.
> A core consists of four cpus with a 24MB shared L3 cache.
> A book consists of six cores with a 192MB shared L4 cache.

> The z196 architecture has no SMT.

  [...]

> A boot of a logical partition with 20 cpus, shared on two books, gives these
> initializion output to the console:

Below output shows that there is some odd distribution of your CPUs in
the different domain levels. Is this caused by the fact that not all
CPUs of a core and book were assigned to your logical partition?

For better understanding is the following CPUs-to-core/book mapping correct for
your example?

Book  |  Core  | CPU
------+--------+---------
 0    |   0    |  0,1,2,3
 0    |   1    |  4,5
 1    |   0    |  6,9
 1    |   1    |  10,11
 1    |   2    |  12,13
 1    |   3    |  14,15,16
 1    |   4    |  17,18,19

> Brought up 20 CPUs
> CPU0 attaching sched-domain:
>  domain 0: span 0-5 level BOOK
>   groups: 0 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048)

Why isn't there a range 0-3 instead of "0 1-3"?
And why isn't cpu_power=4096?
Ah, I think that for CPU 0 just the power information is
missing, So we have 3 groups:

0 (cpu_power=1024) 1-3 (cpu_power=3071) 4-5 (cpu_power=2048)

And the MC level is folded because it doesn't add anything in this
case.

So the mapping is in fact

Book  |  Core  | CPU
------+--------+---------
 0    |   0    |  0
 0    |   1    |  1,2,3
 0    |   2    |  4,5
 1    |   0    |  6,9
 1    |   1    |  10,11
 1    |   2    |  12,13
 1    |   3    |  14,15,16
 1    |   4    |  17,18,19


>   domain 1: span 0-19 level CPU
>    groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)
> CPU1 attaching sched-domain:
>  domain 0: span 1-3 level MC
>   groups: 1 2 3
>   domain 1: span 0-5 level BOOK
>    groups: 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048) 0
>    domain 2: span 0-19 level CPU
>     groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)

It's odd that for CPU 1 the BOOK domain groups differ from those shown
for CPU0.

> CPU2 attaching sched-domain:
>  domain 0: span 1-3 level MC
>   groups: 2 3 1
>   domain 1: span 0-5 level BOOK
>    groups: 1-3 (cpu_power = 3072) 4-5 (cpu_power = 2048) 0

Again for CPU 0 the cpu_power is missing. I think that is confusing.
For better readability that sould also be displayed (if a group
consists of only 1 CPU).

>    domain 2: span 0-19 level CPU
>     groups: 0-5 (cpu_power = 6144) 6-19 (cpu_power = 14336)

     [snip the rest]



Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


