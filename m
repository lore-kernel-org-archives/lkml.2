Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0CVUmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0CVUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:42:21 -0400
Message-ID: <4BA7D5CD.7050008@redhat.com>
Date: Mon, 22 Mar 2010 22:40:45 +0200
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
References: <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <20100322192033.GC21919@elte.hu> <4BA7C885.5010901@redhat.com> <20100322200617.GD3306@elte.hu> <4BA7CFF4.8080102@redhat.com> <20100322202937.GA18126@elte.hu>
In-Reply-To: <20100322202937.GA18126@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:29 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> I think you didnt understand my point. I am talking about 'perf kvm top'
>>> hanging if Qemu hangs.
>>>        
>> Use non-blocking I/O, report that guest as dead.  No point in profiling it,
>> it isn't making any progress.
>>      
> Erm, at what point do i decide that a guest is 'dead' versus 'just lagged due
> to lots of IO' ?
>    

qemu shouldn't block due to I/O (it does now, but there is work to fix 
it).  Of course it could be swapping or other things.

Pick a timeout, everything we do has timeouts these days.  It's the 
price we pay for protection: if you put something where a failure can't 
hurt you, you have to be prepared for failure, and you might have false 
alarms.

Is it so horrible for 'perf kvm top'?  No user data loss will happen, 
surely?

On the other hand, if it's in the kernel and it fails, you will lose 
service or perhaps data.

> Also, do you realize that you increase complexity (the use of non-blocking
> IO), just to protect against something that wouldnt happen if the right
> solution was used in the first place?
>    

It's a tradeoff.  Increasing the kernel code size vs. increasing 
userspace size.

>>> With a proper in-kernel enumeration the kernel would always guarantee the
>>> functionality, even if the vcpu does not make progress (i.e. it's "hung").
>>>
>>> With this implemented in Qemu we lose that kind of robustness guarantee.
>>>        
>> If qemu has a bug in the resource enumeration code, you can't profile one
>> guest.  If the kernel has a bug in the resource enumeration code, the system
>> either panics or needs to be rebooted later.
>>      
> This is really simple code, not rocket science. If there's a bug in it we'll
> fix it. On the other hand a 500KLOC+ piece of Qemu code has lots of places to
> hang, so that is a large cross section.
>
>    

The kernel has tons of very simple code (and some very complex code as 
well), and tons of -stable updates as well.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

