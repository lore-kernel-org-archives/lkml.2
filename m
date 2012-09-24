Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2IXQHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab2IXQHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:07:31 -0400
Message-ID: <5060851E.1030404@redhat.com>
Date: Mon, 24 Sep 2012 18:06:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com>
In-Reply-To: <50607F1F.2040704@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:41 PM, Avi Kivity wrote:
> 
>> 
>> case 2)
>> rq1 : vcpu1->wait(lockA) (spinning)
>> rq2 : vcpu3 (running) ,  vcpu2->holding(lockA) [scheduled out]
>> 
>> I agree that checking rq1 length is not proper in this case, and as you
>> rightly pointed out, we are in trouble here.
>> nr_running()/num_online_cpus() would give more accurate picture here,
>> but it seemed costly. May be load balancer save us a bit here in not
>> running to such sort of cases. ( I agree load balancer is far too
>> complex).
> 
> In theory preempt notifier can tell us whether a vcpu is preempted or
> not (except for exits to userspace), so we can keep track of whether
> it's we're overcommitted in kvm itself.  It also avoids false positives
> from other guests and/or processes being overcommitted while our vm is fine.

It also allows us to cheaply skip running vcpus.

We would probably need a ->sched_exit() preempt notifier to make this
work.  Peter, I know how much you love those, would it be acceptable?
We'd still need yield_to() but the pressure on it might be reduced.

-- 
error compiling committee.c: too many arguments to function
