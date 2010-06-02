Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0FBJAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0FBJAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:00:50 -0400
Message-ID: <4C061DAB.6000804@redhat.com>
Date: Wed, 02 Jun 2010 12:00:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <20100601172730.GB11880@basil.fritz.box> <4C05C722.1010804@redhat.com> <20100602085055.GA14221@basil.fritz.box>
In-Reply-To: <20100602085055.GA14221@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 11:50 AM, Andi Kleen wrote:
> On Wed, Jun 02, 2010 at 05:51:14AM +0300, Avi Kivity wrote:
>    
>> On 06/01/2010 08:27 PM, Andi Kleen wrote:
>>      
>>> On Tue, Jun 01, 2010 at 07:52:28PM +0300, Avi Kivity wrote:
>>>
>>>        
>>>> We are running everything on NUMA (since all modern machines are now NUMA).
>>>>    At what scale do the issues become observable?
>>>>
>>>>          
>>> On Intel platforms it's visible starting with 4 sockets.
>>>
>>>        
>> Can you recommend a benchmark that shows bad behaviour?  I'll run it with
>>      
> Pretty much anything with high lock contention.
>    

Okay, we'll try to measure it here as soon as we can switch it into numa 
mode.

>> Do  you have any idea how we can tackle both problems?
>>      
> Apparently Xen has something, perhaps that can be leveraged
> (but I haven't looked at their solution in detail)
>
> Otherwise I would probably try to start with a adaptive
> spinlock that at some point calls into the HV (or updates
> shared memory?), like john cooper suggested. The tricky part here would
> be to find the thresholds and fit that state into
> paravirt ops and the standard spinlock_t.
>
>    

There are two separate problems: the more general problem is that the 
hypervisor can put a vcpu to sleep while holding a lock, causing other 
vcpus to spin until the end of their time slice.  This can only be 
addressed with hypervisor help.  The second problem is that the extreme 
fairness of ticket locks causes lots of context switches if the 
hypervisor helps, and aggravates the first problem horribly if it 
doesn't (since now a vcpu will spin waiting for its ticket even if the 
lock is unlocked).

So yes, we'll need hypervisor assistance, but even with that we'll need 
to reduce ticket lock fairness (retaining global fairness but 
sacrificing some local fairness).  I imagine that will be helpful for 
non-virt as well as local unfairness reduces bounciness.

-- 
error compiling committee.c: too many arguments to function

