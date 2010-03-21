Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0CUVbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0CUVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:31:15 -0400
Message-ID: <4BA6900B.1040408@redhat.com>
Date: Sun, 21 Mar 2010 23:30:51 +0200
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu>
In-Reply-To: <20100321203121.GA30194@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 10:31 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/21/2010 09:17 PM, Ingo Molnar wrote:
>>      
>>> Adding any new daemon to an existing guest is a deployment and usability
>>> nightmare.
>>>        
>> The logical conclusion of that is that everything should be built into the
>> kernel. [...]
>>      
> Only if you apply it as a totalitarian rule.
>
> Furthermore, the logical conclusion of _your_ line of argument (applied in a
> totalitarian manner) is that 'nothing should be built into the kernel'.
>    

I'm certainly a minimalist, but that doesn't follow.  Things that 
require privileged access, or access to the page cache, or that can't be 
made to perform otherwise should certainly be in the kernel.  That's why 
I submitted kvm for inclusion in the first place.

If it's something that can work just as well in userspace but we can't 
be bothered to fix any 'deployment nightmares', then they shouldn't be 
in the kernel.  Examples include lvm2 and mdadm (which truly are 
'deployment nightmares' - you need to start them before you have access 
to your filesystem - yet they work somehow).

> I.e. you are arguing for microkernel Linux, while you see me as arguing for a
> monolithic kernel.
>    

No. I'm arguing for reducing bloat wherever possible.  Kernel code is 
more expensive than userspace code in every metric possible.

> Reality is that we are somewhere inbetween, we are neither black nor white:
> it's shades of grey.
>
> If we want to do a good job with all this then we observe subsystems, we see
> how they relate to the physical world and decide about how to shape them. We
> identify long-term changes and re-design modularization boundaries in
> hindsight - when we got them wrong initially. We dont try to rationalize the
> status-quo.
>    

I'm not for the status quo either - I'm for reducing the kernel code 
footprint whereever it doesn't impact performance or break clean interfaces.

> Lets see one example of that thought process in action: Oprofile.
>
> We saw that the modularization of oprofile was a total nightmare: a separate
> kernel-space and a separate user-space component, which was in constant
> version friction. The ABI between them was stiffling: it was hard to change it
> (you needed to trickle that through the tool as well which was on a different
> release schedule, etc.e tc.)
>
> The result was sucky usability that never went beyond some basic 'you can do
> profiling' threshold. The subsystem worked well within that design box, and it
> was worked on by highly competent people - but it was still far, far away from
> the potential it could have achieved.
>
> So we observed those problems and decided to do something about it:
>
>   - We unified the two parts into a single maintenance domain. There's
>     the kernel-side in kernel/perf_event.c and arch/*/*/perf_event.c,
>     plus the user-side in tools/perf/. The two are connected by a very
>     flexible, forwards and backwards compatible ABI.
>    

That's useful because perf is still small.  If it were a full fledged 
350KLOC GUI, then most of the development would concentrate on the GUI 
and very little (relatively) would have to do with the kernel.

Qemu is in that state today.  Please, please look at the recent commits 
and check how many have actually anything to do with kvm, and how many 
with everything else.

>   - We moved much more code into the kernel, realizing that transparent
>     and robust instrumentation should be offered instead of punting
>     abstractions into user-space (which is in a disadvantaged position
>     to implement system-wide abstractions).
>    

No argument.

I have a similar experience with kvm.  The user/kernel break is at the 
cpu virtualization level - that is kvm is solely responsible for 
emulating a cpu and userspace is responsible for emulating devices.  An 
exception was made for the PIC/IOAPIC/PIT due to performance 
considerations - they are emulated in the kernel as well.

A common FAQ is why do we not emulate real-mode instructions in qemu.  
The answer is that it the interface to kvm would be insane - it would 
emulate a partial cpu.  All other users of that interface would have to 
implement an emulator (there is also a practical argument - the qemu 
emulator does not implement atomics correctly wrt other threads).

>   - We created a no-bullsh*t approach to usability. perf is by no means
>     perfect, but it's written by developers for developers and if you report a
>     bug to us we'll act on it before anything else. Furthermore the kernel
>     developers do the user-space coding as well, so there's no chinese
>     wall separating them. Kernel-space becomes aware of the intricacies of
>     user-space and user-space developers become aware of the difficulties of
>     kernel-space as well. It's a good mix in our experience.
>    

Excellent.  However qemu is written by developers for their users, and 
their users are not worried about an eject button in the qemu SDL 
interface, or about running the qemu command line by hand.  They have 
complicated management interfaces that do everything, so we concentrate, 
for example, on a robust RPC interface for qemu.  That means nothing for 
command line users but is critical for our users.

I am not _against_ excellent support for command-line users, but I am 
not going to divert the resources I control (=me) into something that is 
not needed by my users.  I encourage anyone who wants to improve 
usability to subscribe to qemu-devel and contribute, they will receive a 
warm welcome.

> The thing is (and i doubt you are surprised that i say that), i see a similar
> situation with KVM. The basic parameters are comparable to Oprofile: it has a
> kernel-space component and a KVM-specific user-space. By all practical means
> the two are one and the same, but are maintained as different projects.
>    

There is tight cooperation between the maintainers and developers of 
these two projects.  Most developers are subscibed to both mailing lists 
and many have contributed to both repositories.  There does not appear 
to be a problem with release schedules.

> I have followed KVM since its inception with great interest. I saw its good
> initial design, i tried it early on and even wrote various patches for it. So
> i care more about KVM than a random observer would, but this preference and
> passion for KVM's good technical sides does not cloud my judgement when it
> comes to its weaknesses.
>
> In fact the weaknesses are far more important to identify and express
> publicly, so i tend to concentrate on them. Dont take this as me blasting KVM,
> we both know the many good aspects of KVM.
>
> So, as i explained it earlier in greater detail the modularization of KVM into
> a separate kernel-space and user-space component is one of its worst current
> weaknesses, and it has become the main stiffling force in the way of a better
> KVM experience to users.
>
> That, IMO, is the 'weakest link' of KVM today and no matter how well the rest
> of KVM gets improved those nice bits all get unfairly ignored when the user
> cannot have a usable and good desktop experience and thinks that KVM is
> crappy.
>    

Thanks.  I agree the user experience when launching qemu from the 
command line is miles behind virtualbox and vmware workstation.  What I 
disagree is that this is how a typical user will first experience kvm - 
most distributions now integrate virt-manager which allows you much 
better graphical interaction.

Unfortunately, virt-manager is still server-oriented (for example, it 
uses VNC instead of displaying directly to X), and is hardly polished to 
the same level as commercial tools.  However, you cannot force someone 
to write good desktop integration for qemu, it has to come from someone 
with the itch, the experience, the capability, and the time.

> I think you should think outside the initial design box you have created 4
> years ago, you should consider iterating the model and you should consider the
> alternative i suggested: move (or create) KVM tooling to tools/kvm/ and treat
> it as a single project from there on.
>    

Do you really think that tools/kvm/ would create a good GUI for kvm?  
lkml is hardly the place where GUI developers and designers congregate.  
Please, if any of you GUI experts are reading this, please consider 
contributing to qemu directly.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

