Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2I0MEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab2I0MEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:04:42 -0400
Message-ID: <506440AF.9080202@redhat.com>
Date: Thu, 27 Sep 2012 14:03:59 +0200
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
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com> <50643745.6010202@linux.vnet.ibm.com>
In-Reply-To: <50643745.6010202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:23 PM, Raghavendra K T wrote:
>>
>> This gives us a good case for tracking preemption on a per-vm basis.  As
>> long as we aren't preempted, we can keep the PLE window high, and also
>> return immediately from the handler without looking for candidates.
> 
> 1) So do you think, deferring preemption patch ( Vatsa was mentioning
> long back)  is also another thing worth trying, so we reduce the chance
> of LHP.

Yes, we have to keep it in mind.  It will be useful for fine grained
locks, not so much so coarse locks or IPIs.

I would still of course prefer a PLE solution, but if we can't get it to
work we can consider preemption deferral.

> 
> IIRC, with defer preemption :
> we will have hook in spinlock/unlock path to measure depth of lock held,
> and shared with host scheduler (may be via MSRs now).
> Host scheduler 'prefers' not to preempt lock holding vcpu. (or rather
> give say one chance.

A downside is that we have to do that even when undercommitted.

Also there may be a lot of false positives (deferred preemptions even
when there is no contention).

> 
> 2) looking at the result (comparing A & C) , I do feel we have
> significant in iterating over vcpus (when compared to even vmexit)
> so We still would need undercommit fix sugested by PeterZ (improving by
> 140%). ?

Looking only at the current runqueue?  My worry is that it misses a lot
of cases.  Maybe try the current runqueue first and then others.

Or were you referring to something else?

> 
> So looking back at threads/ discussions so far, I am trying to
> summarize, the discussions so far. I feel, at least here are the few
> potential candidates to go in:
> 
> 1) Avoiding double runqueue lock overhead  (Andrew Theurer/ PeterZ)
> 2) Dynamically changing PLE window (Avi/Andrew/Chegu)
> 3) preempt_notify handler to identify preempted VCPUs (Avi)
> 4) Avoiding iterating over VCPUs in undercommit scenario. (Raghu/PeterZ)
> 5) Avoiding unnecessary spinning in overcommit scenario (Raghu/Rik)
> 6) Pv spinlock
> 7) Jiannan's proposed improvements
> 8) Defer preemption patches
> 
> Did we miss anything (or added extra?)
> 
> So here are my action items:
> - I plan to repost this series with what PeterZ, Rik suggested with
> performance analysis.
> - I ll go back and explore on (3) and (6) ..
> 
> Please Let me know..

Undoubtedly we'll think of more stuff.  But this looks like a good start.


-- 
error compiling committee.c: too many arguments to function
