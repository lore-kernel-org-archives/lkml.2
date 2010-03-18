Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0CRNhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0CRNhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:37:24 -0400
Message-ID: <4BA22C72.9030503@redhat.com>
Date: Thu, 18 Mar 2010 15:36:50 +0200
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
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu>
In-Reply-To: <20100318130047.GA7424@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 03:00 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/18/2010 01:48 PM, Ingo Molnar wrote:
>>
>>      
>>>> It's not inevitable, if the projects are badly run, you'll have high
>>>> latencies, but projects don't have to be badly run.
>>>>          
>>> So the 64K dollar question is, why does Qemu still suck?
>>>        
>> Where people sent patches, it doesn't suck (or sucks less). Where they
>> don't, it still sucks. [...]
>>      
> So is your point that the development process and basic code structure does
> not matter at all, it's just a matter of people sending patches? I beg to
> differ ...
>    

The development process of course matters, and we have worked hard to 
fix qemu's.  Basic code structure also matters, but you don't fix that 
with cp.

>> [...]  And it cost way more than $64K.
>>
>> If moving things to tools/ helps, let's move Fedora to tools/.
>>      
> Those bits of Fedora which deeply relate to the kernel - yes.
> Those bits that are arguably separate - nope.
>    

A qemu GUI is not deeply related to the kernel.  Or at all.

>>>> How is a patch for the qemu GUI eject button and the kvm shadow mmu
>>>> related? Should a single maintainer deal with both?
>>>>          
>>> We have co-maintainers for perf that have a different focus. It works
>>> pretty well.
>>>        
>> And it works well when I have patches that change x86 core and kvm. But
>> that's no longer a single repository and we have to coordinate.
>>      
> Actually, it works much better if, contrary to your proposal it ends up in a
> single repo. Last i checked both of us really worked on such a project, run by
> some guy. (Named Linus or so.)
>    

Well, when last I sent x86 patches, they went to you and hpa, applied to 
tip, from which I had to merge them back.  Two repositories.  After 
several weeks they did end up in a third repository, Linus'.  The 
process isn't trivial or fast, but it works.

>>> Look at git log tools/perf/ and how user-space and kernel-space components
>>> interact in practice. You'll patches that only impact one side, but you'll
>>> see very big overlap both in contributor identity and in patches as well.
>>>
>>> Also, let me put similar questions in a bit different way:
>>>
>>>   - ' how is an in-kernel PIT emulation connected to Qemu's PIT emulation? '
>>>        
>> Both implement the same spec.  One is be a code derivative of the other (via
>> Xen).
>>
>>      
>>>   - ' how is the in-kernel dynticks implementation related to Qemu's
>>>       implementation of hardware timers? '
>>>        
>> The quality of host kernel timers directly determines the quality of
>> qemu's timer emulation.
>>
>>      
>>>   - ' how is an in-kernel event for a CD-ROM eject connected to an in-Qemu
>>>       eject event? '
>>>        
>> Both implement the same spec.  The kernel of course needs to handle
>> all implementation variants, while qemu only needs to implement it
>> once.
>>
>>      
>>>   - ' how is a new hardware virtualization feature related to being able to
>>>       configure and use it via Qemu? '
>>>        
>> Most features (example: npt) are transparent to userspace, some are
>> not.  When they are not, we introduce an ioctl() to kvm for
>> controlling the feature, and a command-line switch to qemu for
>> calling it.
>>
>>      
>>>   - ' how is the in-kernel x86 decoder/emulator related to the Qemu x86
>>>       emulator? '
>>>        
>> Both implement the same spec.  Note qemu is not an emulator but a
>> binary translator.
>>
>>      
>>>   - ' how is the performance of the qemu GUI related to the way VGA buffers are
>>>       mapped and accelerated by KVM? '
>>>        
>> kvm needs to support direct mapping when possible and efficient data
>> transfer when not.  The latter will obviously be much slower.  When
>> direct mapping is possible, kvm needs to track pages touched by the
>> guest to avoid full screen redraws.  The rest (interfacing to X or
>> vnc, implementing emulated hardware acceleration, full-screen mode,
>> etc.) are unrelated.
>>
>>      
>>> They are obviously deeply related.
>>>        
>> Not at all. [...]
>>      
> You are obviously arguing for something like UML. Fortunately KVM is not that.
> Or i hope it isnt.
>    

I am not arguing for UML and don't understand why you think so.

>> [...]  kvm in fact knows nothing about vga, to take your last
>> example. [...]
>>      
> Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG ioctl.
>
> See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().
>
> It started out as a VGA optimization (also used by live migration) and even
> today it's mostly used by the VGA drivers - albeit a weak one.
>
> I wish there were stronger VGA optimizations implemented, copying the dirty
> bitmap is not a particularly performant solution.

The VGA dirty bitmap is 256 bytes in length.  Copying it doesn't take 
any time at all.

People are in fact working on a copy-less dirty bitmap solution, for 
live migration of very large memory guests.  Expect set_bit_user() 
patches for tip.git.

>   (although it's certainly
> better than full emulation) Graphics performance is one of the more painful
> aspects of KVM usability today.
>    

If you have suggestions for further optimizations (or even patches) I'd 
love to hear them.

One solution we are working on is QXL, a framebuffer-less graphics card 
designed for spice.  The use case is again server based (hosted 
desktops) but may be adapted for desktop-on-desktop use.

>> [...]  To suggest that qemu needs to be close to the kernel to benefit from
>> the kernel's timer implementation means we don't care about providing
>> quality timing except to ourselves, which luckily isn't the case.
>>      
> That is not what i said. I said they are closely related, and where
> technologies are closely related, project proximity turns into project
> unification at a certain stage.
>    

I really don't see how.  So what if both qemu and kvm implement an 
i8254?  They can't share any code since the internal APIs are so 
different.  Even worse for the x86 emulator as qemu and kvm are 
fundamentally different.  Even more with the qemu timers and kernel 
dyntick code.

>> Some time ago the various desktops needed directory change
>> notification, and people implemented inotify (or whatever it's
>> called today).  No one suggested tools/gnome/ and tools/kde/.
>>      
> You are misconstruing and misrepresenting my argument - i'd expect better.
> Gnome and KDE runs on other kernels as well and is generally not considered
> close to the kernel.
>    

qemu runs on other kernels (including Windows), just without kvm.

> Do you seriously argue that Qemu has nothing to do with KVM these days?
>    

The vast majority of qemu has nothing to do with kvm, all the kvm 
interface bits are in two files.  Things like the GUI, the VNC server, 
IDE emulation, the management interface (the monitor), live migration, 
qcow2 and ~15 other file format drivers, chipset emulation, USB 
controller emulation, snapshot support, slirp, serial port emulation, 
and a zillion other details have nothing to do with kvm.

>>> The quality of a development process is not defined by the easy cases
>>> where no project unification is needed. The quality of a development
>>> process is defined by the _difficult_ cases.
>>>        
>> That's true, but we don't have issues at the qemu/kvm boundary. Note we do
>> have issues at the qemu/aio interfaces and qemu/net interfaces (out of which
>> vhost-net was born) but these wouldn't be solved by tools/qemu/.
>>      
> That was not what i suggested. They would be solved by what i proposed:
> tools/kvm/, right?
>    

If they were, it would be worth it.

-- 
error compiling committee.c: too many arguments to function

