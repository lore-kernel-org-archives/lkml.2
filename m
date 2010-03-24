Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0CXQQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0CXQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:16:48 -0400
Message-ID: <4BAA3AC5.80408@redhat.com>
Date: Wed, 24 Mar 2010 18:16:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com>	 <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com>	 <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com>	 <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com>	 <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com>	 <20100324150137.GE14800@8bytes.org> <1269446622.5109.388.camel@twins>
In-Reply-To: <1269446622.5109.388.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:03 PM, Peter Zijlstra wrote:
> On Wed, 2010-03-24 at 16:01 +0100, Joerg Roedel wrote:
>
>    
>> What I meant was: perf-kernel puts the guest-name into every sample and
>> perf-userspace accesses /sys/kvm/guest_name/fs/ later to resolve the
>> symbols. I leave the question of how the guest-fs is exposed to the host
>> out of this discussion. We should discuss this seperatly.
>>      
> I'd much prefer a pid like suggested later, keeps the samples smaller.
>
> But that said, we need guest kernel events like mmap and context
> switches too, otherwise we simply can't make sense of guest userspace
> addresses, we need to know the guest address space layout.
>    

The kernel knows some of the address space layout, qemu knows all of it.

> So aside from a filesystem content, we first need mmap and context
> switch events to find the files we need to access.
>    

This only works for the guest kernel, we don't know anything about guest 
processes [1].

> And while I appreciate all the security talk, its basically pointless
> anyway, the host can access it anyway, everybody agrees on that, but
> still you're arguing the case..
>    

root can access anything, but we're not talking about root.  The idea is 
to protect against a guest that has exploited its qemu and is now 
attacking the host and its fellow guests.   uid protection is no good 
since we want to isolate the guest from host processes belonging to the 
same uid and from other guests running under the same uid.

[1] We can find out guest pids if we teach the kernel what to 
dereference, i.e. gs:offset1->offset2->offset3.  Of course this varies 
from kernel to kernel, so we need some kind of bytecode that we can run 
in perf nmi context.  Kind of what we need to run an unwinder for 
-fomit-frame-pointer.

-- 
error compiling committee.c: too many arguments to function

