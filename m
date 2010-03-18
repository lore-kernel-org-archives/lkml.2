Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0CRIVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0CRIVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:21:04 -0400
Message-ID: <4BA1E24B.6090904@redhat.com>
Date: Thu, 18 Mar 2010 10:20:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu>
In-Reply-To: <20100317081041.GC16374@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 10:10 AM, Ingo Molnar wrote:
>
>> It's about who owns the user interface.
>>
>> If qemu owns the user interface, than we can satisfy this in a very simple
>> way by adding a perf monitor command.  If we have to support third party
>> tools, then it significantly complicates things.
>>      
> Of course illogical modularization complicates things 'significantly'.
>    

Who should own the user interface then?

> Fast forward to 2010. The kernel side of KVM is maximum goodness - by far the
> worst-quality remaining aspects of KVM are precisely in areas that you
> mention: 'if we have to support third party tools, then it significantly
> complicates things'. You kept Qemu as an external 'third party' entity to KVM,
> and KVM is clearly hurting from that - just see the recent KVM usability
> thread for examples about suckage.
>    

Any qemu usability problems are because developers (or their employers) 
are not interested in fixing them, not because of the repository 
location.  Most kvm developer interest is in server-side deployment 
(even for desktop guests), so there is limited effort in implementing a 
virtualbox-style GUI.

>   - move a clean (and minimal) version of the Qemu code base to tools/kvm/, in
>     the upstream kernel repo, and work on that from that point on.
>    

I'll ignore the repository location which should be immaterial to a 
serious developer and concentrate on the 'clean and minimal' aspect, 
since it has some merit.  Qemu development does have a tension between 
the needs of kvm and tcg.  For kvm we need fine-grained threading to 
improve performance and tons of RAS work.  For tcg these are mostly 
meaningless, and the tcg code has sufficient inertia to reduce the rate 
at which we can develop.

Nevertheless, the majority of developers feel that we'll lose more by a 
fork (the community) than we gain by it (reduced constraints).

>   - co-develop new features within the same patch. Release new versions of
>     kvm-qemu and the kvm bits at the same time (together with the upstream
>     kernel), at well defined points in time.
>    

The majority of patches to qemu don't require changes to kvm, and vice 
versa.  The interface between qemu and kvm is fairly narrow, and most of 
the changes are related to save/restore and guest debugging, hardly 
areas of great interest to the causal user.

>   - encourage kernel-space and user-space KVM developers to work on both
>     user-space and kernel-space bits as a single unit. It's one project and a
>     single experience to the user.
>    

When a feature is developed that requires both kernel and qemu changes, 
the same developer makes the changes in both projects.  Having them in 
different repositories does not appear to be a problem.

>   - [ and probably libvirt should go there too ]
>    

Let's make a list of projects who don't need to be in the kernel 
repository, it will probably be shorted.

Seriously, libvirt is a cross-platform cross-hypervisor library, it has 
no business near the Linux kernel.

> If KVM's hypervisor and guest kernel code can enjoy the benefits of a single
> repository,

In fact I try hard not to rely too much on that.  While both kvm guest 
and host code are in the same repo, there is an ABI barrier between them 
because we need to support any guest version on any host version.  When 
designing, writing, or reading guest or host code that interacts across 
that barrier we need to keep forward and backward compatibility in 
mind.  It's very different from normal kernel APIs that we can adapt 
whenever the need arises.

> why cannot the rest of KVM enjoy the same developer goodness? Only
> fixing that will bring the break-through in quality - not more manpower
> really.
>    

I really don't understand why you believe that.  You seem to want a 
virtualbox-style GUI, and lkml is probably the last place in the world 
to develop something like that.  The developers here are mostly 
uninterested in GUI and usability problems, remember these are people 
who thing emacs xor vi is a great editor.

> Yes, i've read a thousand excuses for why this is an absolutely impossible and
> a bad thing to do, and none of them was really convincing to me - and you also
> have become rather emotional about all the arguments so it's hard to argue
> about it on a technical basis.
>
> We made a similar (admittedly very difficult ...) design jump from oprofile to
> perf, and i can tell you from that experience that it's day and night, both in
> terms of development and in terms of the end result!
>    

Maybe it was due to better design and implementation choices.

> ( We recently also made another, kernel/kernel unification that had a very
>    positive result: we unified the 32-bit and 64-bit x86 architectures. Even
>    within the same repo the unification of technology is generally a good
>    thing. The KVM/Qemu situation is different - it's more similar to the perf
>    design. )
>
> Not having to fight artificial package boundaries and forced package
> separation is very refreshing experience to a developer - and very rewarding
> and flexible to develop on. ABI compatibility is _easier_ to maintain in such
> a model. It's quite similar to the jump from Xen hacking to KVM hacking (i did
> both). It's a bit like the jump from CVS to Git. Trust me, you _cannot_ know
> the difference if you havent tried a similar jump with Qemu.
>    

Why is ABI compatibility easier to maintain in a single repo?

> Anyway, you made your position about this rather clear and you are clearly
> uncompromising, so i just wanted to post this note to the list: you'll waste
> years of your life on a visibly crappy development model that has been unable
> to break through a magic usability barrier for the past 2-3 years - just like
> the Xen mis-design has wasted so many people's time and effort in kernel
> space.
>    

Do you really think the echo'n'cat school of usability wants to write a 
GUI?  In linux-2.6.git?

-- 
error compiling committee.c: too many arguments to function

