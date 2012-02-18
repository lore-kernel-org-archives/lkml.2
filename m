Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2BRKnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:43:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab2BRKm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:42:59 -0500
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de> <4F3D5B35.4000606@redhat.com> <8A20A1D8-9CB7-4256-A9BD-03D972C5292A@suse.de> <4F3F76BE.8020308@redhat.com>
In-Reply-To: <4F3F76BE.8020308@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <6B5D15A5-4EEE-4F83-A2AE-666E6AE80AC8@suse.de>
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
X-Mailer: iPhone Mail (9A406)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Date: Sat, 18 Feb 2012 11:43:42 +0100
To: Avi Kivity <avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18.02.2012, at 11:00, Avi Kivity <avi@redhat.com> wrote:

> On 02/17/2012 02:19 AM, Alexander Graf wrote:
>>> 
>>> Or we try to be less clever unless we have a really compelling reason. 
>>> qemu monitor and gdb support aren't compelling reasons to optimize.
>> 
>> The goal here was simplicity with a grain of performance concerns.
>> 
> 
> Shared memory is simple in one way, but in other ways it is more
> complicated since it takes away the kernel's freedom in how it manages
> the data, how it's laid out, and whether it can lazify things or not.

Yes and no. Shared memory is a means of transferring data. If it's implemented by copying internally or by implicit sychronization is orthogonal to that.

With the interface as is, we can now on newer CPUs (which need changes to user space to work anyways) take the current interface and add a new CAP + ioctl that allows us to force flush the TLYb into the shared buffer. That way we maintain backwards compatibility, memory savings, no in kernel vmalloc cluttering etc. on all CPUs, but get the checkpoint to actually have useful contents for new CPUs.

I don't see the problem really. The data is the architected layout of the TLB. It contains all the data that can possibly make up a TLB entry according to the booke spec. If we wanted to copy different data, we'd need a different ioctl too.

> 
>> So what would you be envisioning? Should we make all of the MMU walker code in target-ppc KVM aware so it fetches that single way it actually cares about on demand from the kernel? That is pretty intrusive and goes against the general nicely fitting in principle of how KVM integrates today.
> 
> First, it's trivial, when you access a set you call
> cpu_synchronize_tlb(set), just like how you access the registers when
> you want them.

Yes, which is reasonably intrusive and going to be necessary with LRAT.

> 
> Second, and more important, how a random version of qemu works is
> totally immaterial to the kvm userspace interface.  qemu could change in
> 15 different ways and so could the kernel, and other users exist. 
> Fitting into qemu's current model is not a goal (if qemu happens to have
> a good model, use it by all means; and clashing with qemu is likely an
> indication the something is wrong -- but the two projects need to be
> decoupled).

Sure. In fact, in this case, the two were developed together. QEMU didn't have support for this specific TLB type, so we combined the development efforts. This way any new user space has a very easy time to implement it too, because we didn't model the KVM parts after QEMU, but the QEMU parts after KVM.

I still think it holds true that the KVM interface is very easy to plug in to any random emulation project. And to achieve that, the interface should be as little intrusive as possible wrt its requirements. The one we have seemed to fit that pretty well. Sure, we need a special flush command for newer CPUs, but at least we don't have to always copy. We only copy when we need to.

> 
>> Also, we need to store the guest TLB somewhere. With this model, we can just store it in user space memory, so we keep only a single copy around, reducing memory footprint. If we had to copy it, we would need more than a single copy.
> 
> That's the whole point.  You could store it on the cpu hardware, if the
> cpu allows it.  Forcing it into always-synchronized shared memory takes
> that ability away from you.

Yup. So the correct comment to make would be "don't make the shared TLB always synchronized", which I agree with today. I still think that the whole idea of passing kvm user space memory to work on is great. It reduces vmalloc footprint, it reduces copying, and it keeps data at one place, reducing chances to mess up.

Having it defined to always be in sync was a mistake, but one we can easily fix. That's why the CAP and ioctl interfaces are so awesome ;). I strongly believe that I can't predict the future. So designing an interface that holds stable for the next 10 years is close to imposdible. with an easily extensible interface however, it becomes almost trivial tk fix earlier messups ;).


Alex

