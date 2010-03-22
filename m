Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0CVUQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0CVUQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:16:18 -0400
Message-ID: <4BA7CFF4.8080102@redhat.com>
Date: Mon, 22 Mar 2010 22:15:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <20100322192033.GC21919@elte.hu> <4BA7C885.5010901@redhat.com> <20100322200617.GD3306@elte.hu>
In-Reply-To: <20100322200617.GD3306@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:06 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/22/2010 09:20 PM, Ingo Molnar wrote:
>>      
>>> * Avi Kivity<avi@redhat.com>   wrote:
>>>
>>>        
>>>>> Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by
>>>>> Anthony. There's numerous ways that this can break:
>>>>>            
>>>> I don't like it either.  We have libvirt for enumerating guests.
>>>>          
>>> Which has pretty much the same problems to the ${HOME}/.qemu/qmp/ solution,
>>> obviously.
>>>        
>> It doesn't follow.  The libvirt daemon could/should own guests from all
>> users.  I don't know if it does so now, but nothing is preventing it
>> technically.
>>      
> It's hard for me to argue against a hypothetical implementation, but all
> user-space driven solutions for resource enumeration i've seen so far had
> weaknesses that kernel-based solutions dont have.
>    

Correct.  kernel-based solutions also have issues.

>> If qemu hangs, the guest hangs a few milliseconds later.
>>      
> I think you didnt understand my point. I am talking about 'perf kvm top'
> hanging if Qemu hangs.
>    

Use non-blocking I/O, report that guest as dead.  No point in profiling 
it, it isn't making any progress.

> With a proper in-kernel enumeration the kernel would always guarantee the
> functionality, even if the vcpu does not make progress (i.e. it's "hung").
>
> With this implemented in Qemu we lose that kind of robustness guarantee.
>    

If qemu has a bug in the resource enumeration code, you can't profile 
one guest.  If the kernel has a bug in the resource enumeration code, 
the system either panics or needs to be rebooted later.

> And especially during development (when developers use instrumentation the
> most) is it important to have robust instrumentation that does not hang along
> with the Qemu process.
>    

It's nice not to have kernel oopses either.  So when code can be in 
userspace, that's where it should be.

>> If qemu fails, you lose your guest.  If libvirt forgets about a
>> guest, you can't do anything with it any more.  These are more
>> serious problems than 'perf kvm' not working. [...]
>>      
> How on earth can you justify a bug ("perf kvm top" hanging) with that there
> are other bugs as well?
>    

There's no reason for 'perf kvm top' to hang if some process is not 
responsive.  That would be a perf bug.

> Basically you are arguing the equivalent that a gdb session would be fine to
> become unresponsive if the debugged task hangs. Fortunately ptrace is
> kernel-based and it never 'hangs' if the user-space process hangs somewhere.
>    

Neither gdb nor perf should hang.

> This is an essential property of good instrumentation.
>
> So the enumeration method you suggested is a poor, sub-part solution, simple
> as that.
>    

Or, you misunderstood it.

>> [...] Qemu and libvirt have to be robust anyway, we can rely on them.  Like
>> we have to rely on init, X, sshd, and a zillion other critical tools.
>>      
> We can still profile any of those tools without the profiler breaking if the
> debugged tool breaks ...
>    

You can't profile without qemu.

>>> By your argument it would be perfectly fine to implement /proc purely via
>>> user-space, correct?
>>>        
>> I would have preferred /proc to be implemented via syscalls called directly
>> from tools, and good tools written to expose the information in it.  When
>> computers were slower 'top' would spend tons of time opening and closing all
>> those tiny files and parsing them.  Of course the kernel needs to provide
>> the information.
>>      
> (Then you'll be enjoyed to hear that perf has enabled exactly that, and that we
> are working towards that precise usecase.)
>    

Are you exporting /proc/pid data via the perf syscall?  If so, I think 
that's a good move.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

