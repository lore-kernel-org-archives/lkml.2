Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0CVToy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0CVTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:44:53 -0400
Message-ID: <4BA7C885.5010901@redhat.com>
Date: Mon, 22 Mar 2010 21:44:05 +0200
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
References: <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <20100322192033.GC21919@elte.hu>
In-Reply-To: <20100322192033.GC21919@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 09:20 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by
>>> Anthony. There's numerous ways that this can break:
>>>        
>> I don't like it either.  We have libvirt for enumerating guests.
>>      
> Which has pretty much the same problems to the ${HOME}/.qemu/qmp/ solution,
> obviously.
>    

It doesn't follow.  The libvirt daemon could/should own guests from all 
users.  I don't know if it does so now, but nothing is preventing it 
technically.

>>>   - Those special files can get corrupted, mis-setup, get out of sync, or can
>>>     be hard to discover.
>>>
>>>   - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
>>>     design flaw: it is per user. When i'm root i'd like to query _all_ current
>>>     guest images, not just the ones started by root. A system might not even
>>>     have a notion of '${HOME}'.
>>>
>>>   - Apps might start KVM vcpu instances without adhering to the
>>>     ${HOME}/.qemu/qmp/ access method.
>>>        
>> - it doesn't work with nfs.
>>      
> So out of a list of 4 disadvantages your reply is that you agree with 3?
>    

I agree with 1-3, disagree with 4, and add 5.  Yes.

>    
>>>   - There is no guarantee for the Qemu process to reply to a request - while
>>>     the kernel can always guarantee an enumeration result. I dont want 'perf
>>>     kvm' to hang or misbehave just because Qemu has hung.
>>>        
>> If qemu doesn't reply, your guest is dead anyway.
>>      
> Erm, but i'm talking about a dead tool here. There's a world of a difference
> between 'kvm top' not showing new entries (because the guest is dead), and
> 'perf kvm top' hanging due to Qemu hanging.
>    

If qemu hangs, the guest hangs a few milliseconds later.

> So it's essentially 4 our of 4. Yet your reply isnt "Ingo you are right" but
> "hey, too bad" ?
>    

My reply is "you are right" (phrased earlier as "I don't like it either" 
meaning I agree with your dislike).  One of your criticisms was invalid, 
IMO, and I pointed it out.

>>> Really, for such reasons user-space is pretty poor at doing system-wide
>>> enumeration and resource management. Microkernels lost for a reason.
>>>        
>> Take a look at your desktop, userspace is doing all of that everywhere, from
>> enumerating users and groups, to deciding how your disks are named.  The
>> kernel only provides the bare facilities.
>>      
> We dont do that for robust system instrumentation, for heaven's sake!
>    

If qemu fails, you lose your guest.  If libvirt forgets about a guest, 
you can't do anything with it any more.  These are more serious problems 
than 'perf kvm' not working.  Qemu and libvirt have to be robust anyway, 
we can rely on them.  Like we have to rely on init, X, sshd, and a 
zillion other critical tools.

> By your argument it would be perfectly fine to implement /proc purely via
> user-space, correct?
>    

I would have preferred /proc to be implemented via syscalls called 
directly from tools, and good tools written to expose the information in 
it.  When computers were slower 'top' would spend tons of time opening 
and closing all those tiny files and parsing them.  Of course the kernel 
needs to provide the information.

>>> You are committing several grave design mistakes here.
>>>        
>> I am committing on the shoulders of giants.
>>      
> Really, this is getting outright ridiculous. You agree with me that Anothony
> suggested a technically inferior solution, yet you even seem to be proud of it
> and are joking about it?
>    

The bit above this was:

>  Really, for such reasons user-space is pretty poor at doing system-wide
>  enumeration and resource management. Microkernels lost for a reason.
>  

In every Linux system userspace is doing or proxying much of the 
enumeration and resource management.  So if enumerating guests in 
userspace is a mistake, then I am not alone in making it.

> And _you_ are complaining about lkml-style hard-talk discussions?
>    

There is a difference between joking and insulting people.  I enjoy 
jokes but I dislike being insulted.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

