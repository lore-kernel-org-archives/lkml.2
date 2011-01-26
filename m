Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1AZMNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:13:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab1AZMNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:13:37 -0500
Subject: Re: [PATCH 01/16] KVM-HDR: register KVM basic header infrastructure
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D400045.2000405@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-2-git-send-email-glommer@redhat.com>
	 <4D400045.2000405@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 10:13:33 -0200
Message-ID: <1296044013.15920.47.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 13:06 +0200, Avi Kivity wrote:
> On 01/24/2011 08:06 PM, Glauber Costa wrote:
> > KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
> > is a piece of shared memory that is visible to both the hypervisor and the guest
> > kernel - but not the guest userspace.
> >
> > The basic idea is that the guest can tell the hypervisor about a specific
> > piece of memory, and what it expects to find in there. This is a generic
> > abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
> > handle a specific request, thus giving us flexibility in some features
> > in the future.
> >
> > KVM (The hypervisor) can change the contents of this piece of memory at
> > will. This works well with paravirtual information, and hopefully
> > normal guest memory - like last update time for the watchdog, for
> > instance.
> >
> > This is basic KVM registration headers. I am keeping headers
> > separate to facilitate backports to people who wants to backport
> > the kernel part but not the hypervisor, or the other way around.
> >
> > Signed-off-by: Glauber Costa<glommer@redhat.com>
> > CC: Avi Kivity<avi@redhat.com>
> > ---
> >   arch/x86/include/asm/kvm_para.h |   11 +++++++++++
> >   1 files changed, 11 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index a427bf7..b0b0ee0 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -21,6 +21,7 @@
> >    */
> >   #define KVM_FEATURE_CLOCKSOURCE2        3
> >   #define KVM_FEATURE_ASYNC_PF		4
> > +#define KVM_FEATURE_MEMORY_AREA		5
> >
> >   /* The last 8 bits are used to indicate how to interpret the flags field
> >    * in pvclock structure. If no bits are set, all flags are ignored.
> > @@ -35,6 +36,16 @@
> >   #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
> >   #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
> >
> > +#define MSR_KVM_REGISTER_MEM_AREA 0x4b564d03
> > +
> > +struct kvm_memory_area {
> > +	__u64 base;
> > +	__u32 size;
> > +	__u32 type;
> > +	__u8  result;
> > +	__u8  pad[3];
> > +};
> > +
> >   #define KVM_MAX_MMU_OP_BATCH           32
> 
> I'm guessing the protocol here is:
> 
> - guest fills in ->base/size/type
> - issues wrmsr
> - host registers the memory and updates ->result
> - guest examines ->result
> 
> there are two issues with this approach:
> 
> - it doesn't lend itself will to live migration.  Extra state must be 
> maintained in the hypervisor.
Yes, but can be queried at any time as well. I don't do it in this
patch, but this is explicitly mentioned in my TODO.

> - it isn't how normal hardware operates
Since we're trying to go for guest cooperation here, I don't really see
a need to stay close to hardware here.

> 
> what's wrong with extending the normal approach of one msr per feature?

* It's harder to do discovery with MSRs. You can't just rely on getting
an error before the idts are properly setups. The way I am proposing
allow us to just try to register a memory area, and get a failure if we
can't handle it, at any time
* To overcome the above, we had usually relied on cpuids. This requires
qemu/userspace cooperation for feature enablement
* This mechanism just bumps us out to userspace if we can't handle a
request. As such, it allows for pure guest kernel -> userspace
communication, that can be used, for instance, to emulate new features
in older hypervisors one does not want to change. BTW, maybe there is
value in exiting to userspace even if we stick to the
one-msr-per-feature approach?



