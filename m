Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2IXPve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab2IXPvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:51:33 -0400
Message-ID: <50608176.1040805@redhat.com>
Date: Mon, 24 Sep 2012 17:51:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue>  <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com>  <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins>
In-Reply-To: <1348494895.11847.64.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 03:54 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 18:59 +0530, Raghavendra K T wrote:
>> However Rik had a genuine concern in the cases where runqueue is not
>> equally distributed and lockholder might actually be on a different run 
>> queue but not running.
> 
> Load should eventually get distributed equally -- that's what the
> load-balancer is for -- so this is a temporary situation.

What's the expected latency?  This is the whole problem.  Eventually the
scheduler would pick the lock holder as well, the problem is that it's
in the millisecond scale while lock hold times are in the microsecond
scale, leading to a 1000x slowdown.

If we want to yield, we really want to boost someone.

> We already try and favour the non running vcpu in this case, that's what
> yield_to_task_fair() is about. If its still not eligible to run, tough
> luck.

Crazy idea: instead of yielding, just run that other vcpu in the thread
that would otherwise spin.  I can see about a million objections to this
already though.

>> Do you think instead of using rq->nr_running, we could get a global 
>> sense of load using avenrun (something like avenrun/num_onlinecpus) 
> 
> To what purpose? Also, global stuff is expensive, so you should try and
> stay away from it as hard as you possibly can.

Spinning is also expensive.  How about we do the global stuff every N
times, to amortize the cost (and reduce contention)?

-- 
error compiling committee.c: too many arguments to function
