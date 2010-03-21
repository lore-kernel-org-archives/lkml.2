Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0CUKDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0CUKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:03:38 -0400
Message-ID: <4BA5EED9.8020801@redhat.com>
Date: Sun, 21 Mar 2010 12:03:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zamsden@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA294D4.2060700@redhat.com> <20100318211529.GA21367@elte.hu> <4BA2A70B.5080101@redhat.com> <20100318224446.GC19669@elte.hu> <4BA3260D.5090407@redhat.com> <20100320145943.GI29874@random.random>
In-Reply-To: <20100320145943.GI29874@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2010 04:59 PM, Andrea Arcangeli wrote:
> On Fri, Mar 19, 2010 at 09:21:49AM +0200, Avi Kivity wrote:
>    
>> On 03/19/2010 12:44 AM, Ingo Molnar wrote:
>>      
>>> Too bad - there was heavy initial opposition to the arch/x86 unification as
>>> well [and heavy opposition to tools/perf/ as well], still both worked out
>>> extremely well :-)
>>>
>>>        
>> Did you forget that arch/x86 was a merging of a code fork that happened
>> several years previously?  Maybe that fork shouldn't have been done to
>> begin with.
>>      
> We discussed and probably timidly tried to share the sharable
> initially but we realized it was too time wasteful. In addition to
> having to adapt the code to 64bit we would also had to constantly
> solve another problem on top of it (see the various split on _32/_64,
> those takes time to achieve, maybe not huge time but still definitely
> some time and effort). Even in retrospect I am quite sure the way
> x86-64 happened was optimal and if we would go back we would do it
> again the exact same way even if the final object was to have a common
> arch/x86 (and thankfully Linus is flexible and smart enough to realize
> that code that isn't risking to destabilize anything shouldn't be
> forced out just because it's not to a totally
> theoretical-perfect-nitpicking-clean-state yet). It's still a lot of
> work do the unification later as a separate task, but it's not like if
> we did it immediately it would have been a lot less work. It's about
> the same amount of effort and we were able to defer it for later and
> decrease the time to market which surely has contributed to the
> success of x86-64.
>    

In hindsight decisions are much easier.  I agree it was less risky to 
fork than to share.  But if another instruction set forks out a 64-bit 
not-exactly-compatible variant, I'm sure we'll start out shared and not 
fork it, especially if the platform remains the same.

> Problem of qemu is not some lack of GUI or that it's not included in
> the linux kernel git tree, the definitive problem is how to merge
> qemu-kvm/kvm and qlx into it. If you (Avi) were the qemu maintainer I
> am sure there wouldn't two trees so as a developer I would totally
> love it, and I am sure that with you as maintainer it would have a
> chance to move forward with qlx on desktop virtualization without
> proposing to extend vnc instead to achieve a "similar" result (imagine
> if btrfs is published on a website and people starts to discuss if it
> should ever be merged ever because reinventing some part of btrfs
> inside ext5 might achieve ""similar"" results).
>    

The qemu/qemu-kvm fork is definitely hurting.  Some history: when kvm 
started out I pulled qemu for fast hacking and, much like arch/x86_64, I 
couldn't destabilize qemu for something that was completely experimental 
(and closed source at the time).  Moreover, it wasn't clear if the qemu 
community would be interested.

The qemu-kvm fork was designed for minimal intrusion so I could merge 
upstream qemu regularly.  This resulted in kvm integration that was 
fairly ugly.  Later Anthony merged a well-integrated alternative 
implementation (in retrospect this was a mistake IMO - we were left with 
a well tested high performing ugly implementation and a clean, slow, 
untested, and unfeatured implementation, and no one who wants to merge 
the two).  So now it is pretty confusing to read the code which has the 
two alternate implementation sometimes sharing code and sometimes diverging.


> About a GUI for KVM to use on desktop distributions, that is an
> irrelevant concern compared to the lack of protocol more efficient
> than rdesktop/rdp/vnc for desktop virtualization. I've people asking
> me to migrate hundreds of desktops to desktop virtualization on KVM in
> their organizations and I tell them to use spice because I believe
> it's the most efficient option available (at least as far as we stick
> to open source open protocols), there are universities using spice on
> thousand of student desktops, and I think we need paravirt graphics to
> happen ASAP in the main qemu tree too.
>    

That effort will have to wait for the spice project to mature.

> In short: running KVM on the desktop is irrelevant compared to running
> the desktop on KVM so I suggest to focus on what is more important
> first ;).
>    

Anyone can focus on what interests them, if someone has an interest in a 
good desktop-on-desktop experience they should start hacking and sending 
patches.

-- 
error compiling committee.c: too many arguments to function

