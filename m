Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2IXQ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab2IXQ0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:26:10 -0400
Message-ID: <50608994.3050004@redhat.com>
Date: Mon, 24 Sep 2012 18:25:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20120921115942.27611.67488.sendpatchset@codeblue>  <20120921120000.27611.71321.sendpatchset@codeblue>  <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com>  <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <1348503266.11847.99.camel@twins>
In-Reply-To: <1348503266.11847.99.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 06:14 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 18:06 +0200, Avi Kivity wrote:
>> 
>> We would probably need a ->sched_exit() preempt notifier to make this
>> work.  Peter, I know how much you love those, would it be acceptable? 
> 
> Where exactly do you want this? TASK_DEAD? or another exit?

TASK_DEAD of the task that registered the preempt notifier.

The idea is that I want to hold on to the notifier even when exiting to
userspace.  Since userspace is under no obligation to call kvm again, I
need a chance to unregister the notifier and otherwise clean up.

Eh, looking at the code, we'll have a ->sched_out() after the state is
set to TASK_DEAD.  So all we need to do is examine the state.  We'll
need to examine the state anyway to see if we were preempted or blocking.

-- 
error compiling committee.c: too many arguments to function
