Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2IXP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:58:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab2IXP6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:58:47 -0400
Message-ID: <50608323.9000603@redhat.com>
Date: Mon, 24 Sep 2012 17:58:27 +0200
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
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue>   <20120921120019.27611.66093.sendpatchset@codeblue>   <50607BBE.8070507@redhat.com> <1348500861.11847.72.camel@twins>  <50607F9B.7090701@redhat.com> <1348501929.11847.81.camel@twins>
In-Reply-To: <1348501929.11847.81.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:52 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 17:43 +0200, Avi Kivity wrote:
>> Wouldn't this correspond to the scheduler interrupt firing and causing a
>> reschedule?  I thought the timer was programmed for exactly the point in
>> time that CFS considers the right time for a switch.  But I'm basing
>> this on my mental model of CFS, not CFS itself. 
> 
> No, we tried this for hrtimer kernels for a while, but programming
> hrtimers the whole time (every actual task-switch) turns out to be far
> too expensive. So we're back to HZ ticks and 'polling' the preemption
> state.

Ok, so I wasn't completely off base.

With HZ=1000, we can only be faster than the poll by a millisecond than
the interrupt-driven schedule(), and we need to be a lot faster.

> Even if we remove all the hrtimer infrastructure overhead (can do with a
> few hacks) setting the hardware requires going out to the LAPIC, which
> is stupid slow.
> 
> Some hardware actually has fast/reliable/usable timers, sadly none of it
> is popular.

There is the TSC deadline timer mode of newer Intels.  Programming the
timer is a simple wrmsr, and it will fire immediately if it already
expired.  Unfortunately on AMDs it is not available, and on virtual
hardware it will be slow (~1-2 usec).

-- 
error compiling committee.c: too many arguments to function
