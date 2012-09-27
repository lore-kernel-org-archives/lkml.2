Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2I0IhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2I0IhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:37:03 -0400
Message-ID: <5064101A.5070902@redhat.com>
Date: Thu, 27 Sep 2012 10:36:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com>
In-Reply-To: <5061B437.8070300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 03:40 PM, Raghavendra K T wrote:
> On 09/24/2012 07:46 PM, Raghavendra K T wrote:
>> On 09/24/2012 07:24 PM, Peter Zijlstra wrote:
>>> On Mon, 2012-09-24 at 18:59 +0530, Raghavendra K T wrote:
>>>> However Rik had a genuine concern in the cases where runqueue is not
>>>> equally distributed and lockholder might actually be on a different run
>>>> queue but not running.
>>>
>>> Load should eventually get distributed equally -- that's what the
>>> load-balancer is for -- so this is a temporary situation.
>>>
>>> We already try and favour the non running vcpu in this case, that's what
>>> yield_to_task_fair() is about. If its still not eligible to run, tough
>>> luck.
>>
>> Yes, I agree.
>>
>>>
>>>> Do you think instead of using rq->nr_running, we could get a global
>>>> sense of load using avenrun (something like avenrun/num_onlinecpus)
>>>
>>> To what purpose? Also, global stuff is expensive, so you should try and
>>> stay away from it as hard as you possibly can.
>>
>> Yes, that concern only had made me to fall back to rq->nr_running.
>>
>> Will come back with the result soon.
> 
> Got the result with the patches:
> So here is the result,
> 
> Tried this on a 32 core ple box with HT disabled. 32 guest vcpus with
> 1x and 2x overcommits
> 
> Base = 3.6.0-rc5 + ple handler optimization patches
> A = Base + checking rq_running in vcpu_on_spin() patch
> B = Base + checking rq->nr_running in sched/core
> C = Base - PLE
> 
> ---+-----------+-----------+-----------+-----------+
>    |    Ebizzy result (rec/sec higher is better)   |
> ---+-----------+-----------+-----------+-----------+
>    |    Base   |     A     |      B    |     C     |
> ---+-----------+-----------+-----------+-----------+
> 1x | 2374.1250 | 7273.7500 | 5690.8750 |  7364.3750|
> 2x | 2536.2500 | 2458.5000 | 2426.3750 |    48.5000|
> ---+-----------+-----------+-----------+-----------+
> 
>    % improvements w.r.t BASE
> ---+------------+------------+------------+
>    |      A     |    B       |     C      |
> ---+------------+------------+------------+
> 1x | 206.37603  |  139.70410 |  210.19323 |
> 2x | -3.06555   |  -4.33218  |  -98.08773 |
> ---+------------+------------+------------+
> 
> we are getting the benefit of almost PLE disabled case with this
> approach. With patch B, we have dropped a bit in gain.
> (because we still would iterate vcpus until we decide to do a directed
> yield).

This gives us a good case for tracking preemption on a per-vm basis.  As
long as we aren't preempted, we can keep the PLE window high, and also
return immediately from the handler without looking for candidates.


-- 
error compiling committee.c: too many arguments to function
