Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0CXE6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0CXE6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:58:31 -0400
Message-ID: <4BA99BCB.5080501@redhat.com>
Date: Wed, 24 Mar 2010 06:57:47 +0200
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
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org>
In-Reply-To: <20100323182153.GA14800@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 08:21 PM, Joerg Roedel wrote:
> On Tue, Mar 23, 2010 at 06:39:58PM +0200, Avi Kivity wrote:
>    
>> On 03/23/2010 04:06 PM, Joerg Roedel wrote:
>>      
>    
>>> And this system wide entity is the kvm module. It creates instances of
>>> 'struct kvm' and destroys them. I see no problem if we just attach a
>>> name to every instance with a good default value like kvm0, kvm1 ... or
>>> guest0, guest1 ... User-space can override the name if it wants. The kvm
>>> module takes care about the names being unique.
>>>
>>>        
>> So, two users can't have a guest named MyGuest each?  What about
>> namespace support?  There's a lot of work in virtualizing all kernel
>> namespaces, you're adding to that.
>>      
> This enumeration is a very small and non-intrusive feature. Making it
> aware of namespaces is easy too.
>    

It's easier (and safer and all the other boring bits) not to do it at 
all in the kernel.

>> What about notifications when guests  are added or removed?
>>      
> Who would be the consumer of such notifications? A 'perf kvm list' can
> live without I guess. If we need them later we can still add them.
>    

System-wide monitoring needs to work equally well for guests started 
before or after the monitor.  Even disregarding that, if you introduce 
an API, people will start using it and complaining if it's incomplete.

The equivalent functionality for network interfaces is in netlink.

>>> This is very much the same as network card numbering is implemented in
>>> the kernel.
>>> Forcing perf to talk to qemu or even libvirt produces to much overhead
>>> imho. Instrumentation only produces useful results with low overhead.
>>>
>>>        
>> It's a setup cost only.
>>      
> My statement was not limited to enumeration, I should have been more
> clear about that. The guest filesystem access-channel is another
> affected part. The 'perf kvm top' command will access the guest
> filesystem regularly and going over qemu would be more overhead here.
>    

Why?  Also, the real cost would be accessing the filesystem, not copying 
data over qemu.

> Providing this in the KVM module directly also has the benefit that it
> would work out-of-the-box with different userspaces too.  Or do we want
> to limit 'perf kvm' to the libvirt-qemu-kvm software stack?
>    

Other userspaces can also provide this functionality, like they have to 
provide disk, network, and display emulation.  The kernel is not a huge 
library.

> Sidenote: I really think we should come to a conclusion about the
>            concept. KVM integration into perf is very useful feature to
> 	  analyze virtualization workloads.
>
>    

Agreed.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

