Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab2E3JlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:41:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59292 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2E3JlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:41:19 -0400
Message-ID: <4FC5EB3C.7040505@gmail.com>
Date: Wed, 30 May 2012 05:41:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>    <1337965359-29725-14-git-send-email-aarcange@redhat.com>   <1338297385.26856.74.camel@twins> <4FC4D58A.50800@redhat.com>  <1338303251.26856.94.camel@twins> <4FC5D973.3080108@gmail.com> <1338368763.26856.207.camel@twins>
In-Reply-To: <1338368763.26856.207.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 5:06 AM), Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 04:25 -0400, KOSAKI Motohiro wrote:
>> (5/29/12 10:54 AM), Peter Zijlstra wrote:
>>> On Tue, 2012-05-29 at 09:56 -0400, Rik van Riel wrote:
>>>> On 05/29/2012 09:16 AM, Peter Zijlstra wrote:
>>>>> On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
>>>>
>>>>> 24 bytes per page.. or ~0.6% of memory gone. This is far too great a
>>>>> price to pay.
>>>>>
>>>>> At LSF/MM Rik already suggested you limit the number of pages that can
>>>>> be migrated concurrently and use this to move the extra list_head out of
>>>>> struct page and into a smaller amount of extra structures, reducing the
>>>>> total overhead.
>>>>
>>>> For THP, we should be able to track this NUMA info on a
>>>> 2MB page granularity.
>>>
>>> Yeah, but that's another x86-only feature, _IF_ we're going to do this
>>> it must be done for all archs that have CONFIG_NUMA, thus we're stuck
>>> with 4k (or other base page size).
>>
>> Even if THP=n, we don't need 4k granularity. All modern malloc implementation have
>> per-thread heap (e.g. glibc call it as arena) and it is usually 1-8MB size. So, if
>> it is larger than 2MB, we can always use per-pmd tracking. iow, memory consumption
>> reduce to 1/512.
>
> Yes, and we all know objects allocated in one thread are never shared
> with other threads.. the producer-consumer pattern seems fairly popular
> and will destroy your argument.

THP also strike producer-consumer pattern. But, as far as I know, people haven't observed
significant performance degression. thus I _guessed_ performance critical producer-consumer
pattern is rare. Just guess.


>> My suggestion is, track per-pmd (i.e. 2M size) granularity and fix glibc too (current
>> glibc malloc has dynamically arena size adjusting feature and then it often become
>> less than 2M).
>
> The trouble with making this per pmd is that you then get the false
> sharing per pmd, so if there's shared data on the 2m page you'll not
> know where to put it.
>
> I also know of some folks who did a strict per-cpu allocator based on
> some kernel patches I hope to see posted sometime soon. This because if
> you have many more threads than cpus the wasted space in your areas is
> tremendous.

