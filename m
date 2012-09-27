Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2I0Inr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab2I0Inm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:43:42 -0400
Message-ID: <50641195.5040208@redhat.com>
Date: Thu, 27 Sep 2012 10:43:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <50615EE4.1040809@linux.vnet.ibm.com> <50616781.3000406@redhat.com> <20120925232122.e6fabbc5c472148aeec70234@gmail.com>
In-Reply-To: <20120925232122.e6fabbc5c472148aeec70234@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 04:21 PM, Takuya Yoshikawa wrote:
> On Tue, 25 Sep 2012 10:12:49 +0200
> Avi Kivity <avi@redhat.com> wrote:
> 
>> It will.  The tradeoff is between false-positive costs (undercommit) and
>> true positive costs (overcommit).  I think undercommit should perform
>> well no matter what.
>> 
>> If we utilize preempt notifiers to track overcommit dynamically, then we
>> can vary the spin time dynamically.  Keep it long initially, as we get
>> more preempted vcpus make it shorter.
> 
> What will happen if we pin each vcpu thread to some core?
> I don't want to see so many vcpu threads moving around without
> being pinned at all.

If you do that you've removed a lot of flexibility from the scheduler,
so overcommit becomes even less likely to work well (a trivial example
is pinning two vcpus from the same vm to the same core -- it's so
obviously bad no one considers doing it).

> In that case, we don't want to make KVM do any work of searching
> a vcpu thread to yield to.

Why not?  If a vcpu thread on another core has been preempted, and is
the lock holder, and we can boost it, then we've fixed our problem.
Even if the spinning thread keeps spinning because it is the only task
eligible to run on its core.

-- 
error compiling committee.c: too many arguments to function
