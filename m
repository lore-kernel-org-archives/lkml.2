Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0CXN6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab0CXN6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:58:16 -0400
Message-ID: <4BAA1A53.20207@redhat.com>
Date: Wed, 24 Mar 2010 15:57:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org>
In-Reply-To: <20100324134642.GD14800@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 03:46 PM, Joerg Roedel wrote:
> On Wed, Mar 24, 2010 at 03:05:02PM +0200, Avi Kivity wrote:
>    
>> On 03/24/2010 02:50 PM, Joerg Roedel wrote:
>>      
>    
>>> I don't want the tool for myself only. A typical perf user expects that
>>> it works transparent.
>>>        
>> A typical kvm user uses libvirt, so we can integrate it with that.
>>      
> Someone who uses libvirt and virt-manager by default is probably not
> interested in this feature at the same level a kvm developer is. And
> developers tend not to use libvirt for low-level kvm development.  A
> number of developers have stated in this thread already that they would
> appreciate a solution for guest enumeration that would not involve
> libvirt.
>    

So would I.  But when I weigh the benefit of truly transparent 
system-wide perf integration for users who don't use libvirt but do use 
perf, versus the cost of transforming kvm from a single-process API to a 
system-wide API with all the complications that I've listed, it comes 
out in favour of not adding the API.

Those few users can probably script something to cover their needs.

>> Someone needs to know about the new guest to fetch its symbols.  Or do
>> you want that part in the kernel too?
>>      
> The samples will be tagged with the guest-name (and some additional
> information perf needs). Perf userspace can access the symbols then
> through /sys/kvm/guest0/fs/...
>    

I take that as a yes?  So we need a virtio-serial client in the kernel 
(which might be exploitable by a malicious guest if buggy) and a 
fs-over-virtio-serial client in the kernel (also exploitable).

>>> Depends on how it is designed. A filesystem approach was already
>>> mentioned. We could create /sys/kvm/ for example to expose information
>>> about virtual machines to userspace. This would not require any new
>>> security hooks.
>>>        
>> Who would set the security context on those files?
>>      
> An approach like: "The files are owned and only readable by the same
> user that started the vm." might be a good start. So a user can measure
> its own guests and root can measure all of them.
>    

That's not how sVirt works.  sVirt isolates a user's VMs from each 
other, so if a guest breaks into qemu it can't break into other guests 
owned by the same user.

The users who need this API (!libvirt and perf) probably don't care 
about sVirt, but a new API must not break it.

>> Plus, we need cgroup  support so you can't see one container's guests
>> from an unrelated container.
>>      
> cgroup support is an issue but we can solve that too. Its in general
> still less complex than going through the whole libvirt-qemu-kvm stack.
>    

It's a tradeoff.  IMO, going through qemu is the better way, and also 
provides more information.

>> Integration with qemu would allow perf to tell us that the guest is
>> hitting the interrupt status register of a virtio-blk device in pci
>> slot 5 (the information is already available through the kvm_mmio
>> trace event, but  only qemu can decode it).
>>      
> Yeah that would be interesting information. But it is more related to
> tracing than to pmu measurements.
> The information which you mentioned above are probably better
> captured by an extension of trace-events to userspace.
>    

It's all related.  You start with perf, see a problem with mmio, call up 
a histogram of mmio or interrupts or whatever, then zoom in on the 
misbehaving device.

-- 
error compiling committee.c: too many arguments to function

