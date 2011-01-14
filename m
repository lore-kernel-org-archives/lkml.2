Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1ANV33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1ANV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:29:27 -0500
Message-ID: <4D30C027.40100@redhat.com>
Date: Fri, 14 Jan 2011 16:29:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 0/4] directed yield for Pause Loop Exiting
References: <20110114030209.53765a0a@annuminas.surriel.com>
In-Reply-To: <20110114030209.53765a0a@annuminas.surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 03:02 AM, Rik van Riel wrote:

> Benchmark "results":
>
> Two 4-CPU KVM guests are pinned to the same 4 physical CPUs.

Unfortunately, it turned out I was running my benchmark on
only two CPU cores, using two HT threads of each core.

I have re-run the benchmark with the guests bound to 4
different CPU cores, one HT on each core.

> One guest runs the AMQP performance test, the other guest runs
> 0, 2 or 4 infinite loops, for CPU overcommit factors of 0, 1.5
> and 4.
>
> The AMQP perftest is run 30 times, with 8 and 16 threads.

8thr	no overcommit	1.5x overcommit		2x overcommit

no PLE	224934		139311			94216.6
PLE	226413		142830			87836.4

16thr	no overcommit	1.5x overcommit		2x overcommit

no PLE	224266		134819			92123.1
PLE	224985		137280			100832

The other conclusions hold - it looks like this test is
doing more to expose issues with the scheduler, than
testing the PLE code.

I have some ideas on how to improve yield(), so it can
do the right thing even in the presence of cgroups.

> Note: there seems to be something wrong with CPU balancing,
> possibly related to cgroups.  The AMQP guest only got about
> 80% CPU time (of 400% total) when running with 2x overcommit,
> as opposed to the expected 200%.  Without PLE, the guest
> seems to get closer to 100% CPU time, which is still far
> below the expected.

> Unfortunately, it looks like this test ended up more as a
> demonstration of other scheduler issues, than as a performance
> test of the PLE code.

-- 
All rights reversed
