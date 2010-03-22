Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0CVTFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:05:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab0CVTE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:04:59 -0400
Message-ID: <4BA7BF3B.8050901@redhat.com>
Date: Mon, 22 Mar 2010 21:04:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, sandmann@daimi.au.dk
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <4BA6900B.1040408@redhat.com> <20100321215207.GA13219@elte.hu> <4BA712F0.5030806@redhat.com> <20100322112340.GD3483@elte.hu> <4BA76746.1000505@redhat.com> <84144f021003220601q1b4b9050x5eb87dfaf10c3c85@mail.gmail.com> <20100322145437.GG14201@elte.hu>
In-Reply-To: <20100322145437.GG14201@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:54 PM, Ingo Molnar wrote:
> * Pekka Enberg<penberg@cs.helsinki.fi>  wrote:
>
>    
>> Hi Avi,
>>
>> On Mon, Mar 22, 2010 at 2:49 PM, Avi Kivity<avi@redhat.com>  wrote:
>>      
>>> Seems like perf is also split, with sysprof being developed outside the
>>> kernel. ?Will you bring sysprof into the kernel? ?Will every feature be
>>> duplicated in prof and sysprof?
>>>        
>> I am glad you brought it up! Sysprof was historically outside of the kernel
>> (with it's own kernel module, actually). While the GUI was nice, it was much
>> harder to set up compared to oprofile so it wasn't all that popular. Things
>> improved slightly when Ingo merged the custom kernel module but the
>> _userspace_ part of sysprof was lagging behind a bit. I don't know what's
>> the situation now that they've switched over to perf syscalls but you
>> probably get my point.
>>
>> It would be nice if the two projects merged but I honestly don't see any
>> fundamental problem with two (or more) co-existing projects. Friendly
>> competition will ultimately benefit the users (think KDE and Gnome here).
>>      
> See my previous mail - what i see as the most healthy project model is to have
> a full solution reference implementation, connected to a flexible halo of
> plugins or sub-apps.
>
> Firefox does that, KDE does that, and Gnome as well to a certain degree.
>
> The 'halo' provides a constant feedback of new features, and it also provides
> competition and pressure on the 'main' code to be top-notch.
>
> The problem i see with KVM is that there's no reference implementation! There
> is _only_ the KVM kernel part which is not functional in itself. Surrounded by
> a 'halo' - where none of the entities is really 'the' reference implementation
> we call 'KVM'.
>    

The reference implementation is qemu-kvm.git, in the future qemu.git.  
Like the reference implementation of device-mapper is 
lvm2/device-mapper, not tools/device-mapper.

> This causes constant quality problems as the developers of the main project
> dont have constant pressure towards good quality (it is not their
> responsibility to care about user-space bits after all),

The developers of the main project are very much aware that users don't 
call the ioctls directly but instead use qemu.

>   plus it causes a lack
> of focus as well: integration between (friendly) competing user-space
> components is a lot harder than integration within a single framework such as
> Firefox.
>    

We are very focused, just not on what you think we should be focused.

> I hope this explains my points about modularization a bit better! I suggested
> KVM to grow a user-space tool component in the kernel repo in tools/kvm/,
> which would become the reference implementation for tooling. User-space
> projects can still provide alternative tooling or can plug into this tooling,
> just like they are doing it now. So the main effect isnt even on those
> projects but on the kernel developers. The ABI remains and all the user-space
> packages and projects remain.
>    

Seems like wanton duplication of effort.  Can we throw so many 
developer-years away on duplicate projects?  Assuming not all are true 
volunteers (85% for 2.6.33) who will fund this duplicate effort?

> Yes, i thought Qemu would be a prime candidate to be the baseline for
> tools/kvm/, but i guess that has become socially impossible now after this
> flamewar. It's not a big problem in the big scheme of things: tools/kvm/ is
> best grown up from a small towards larger size anyway ...
>    

Qemu is open source, you can cp it into tools/kvm.  Rewriting it from 
scratch is a mammoth effort, there's a reason kvm, Xen, and virtualbox 
all use qemu.  Qemu itself copied code from bochs.  Writing this stuff 
is hard, especially if there is something already working.

You'll probably get much better threading (the qemu device model is 
still single threaded), but it will take years to reach where qemu is 
already at.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

