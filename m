Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0CRPRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:17:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0CRPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:17:47 -0400
Date: Thu, 18 Mar 2010 16:17:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>,
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
Message-ID: <20100318151737.GA2875@elte.hu>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA21B09.6060706@redhat.com>
 <20100318130047.GA7424@elte.hu>
 <4BA23FE1.5050402@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA23FE1.5050402@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/18/2010 08:00 AM, Ingo Molnar wrote:
> >>
> >> [...]  kvm in fact knows nothing about vga, to take your last example. 
> >> [...]
> >
> > Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG 
> > ioctl.
> >
> > See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().
> >
> > It started out as a VGA optimization (also used by live migration) and 
> > even today it's mostly used by the VGA drivers - albeit a weak one.
> >
> > I wish there were stronger VGA optimizations implemented, copying the 
> > dirty bitmap is not a particularly performant solution. (although it's 
> > certainly better than full emulation) Graphics performance is one of the 
> > more painful aspects of KVM usability today.
> 
> We have to maintain a dirty bitmap because we don't have a paravirtual 
> graphics driver.  IOW, someone needs to write an Xorg driver.
>
> Ideally, we could just implement a Linux framebuffer device, right?

No, you'd want to interact with DRM.

( Especially as you want to write guest accelerators passing guest-space 
  OpenGL requests straight to the kernel DRM level. )

Especially if you want to do things like graphics card virtualization, with 
aspects of the graphics driver passed through to the guest OS.

There are all kernel space projects, going through Xorg would be a horrible 
waste of performance for full-screen virtualization. It's fine for the 
windowed or networked case (and good as a compatibility fallback), but very 
much not fine for local desktop use.

> Well, we took that approach in Xen and that sucks even worse because the 
> Xorg framebuffer driver doesn't implement any of the optimizations that the 
> Linux framebuffer supports and the Xorg driver does not provide use the 
> kernel's interfaces for providing update regions.
> 
> Of course, we need to pull in X into the kernel to fix this, right?

FYI, this part of X has already been pulled into the kernel, it's called DRM. 
If then it's being expanded.

> Any sufficiently complicated piece of software is going to interact with a 
> lot of other projects.  The solution is not to pull it all into one massive 
> repository.  It's to build relationships and to find ways to efficiently 
> work with the various communities.

That's my whole point with this thread: the kernel side of KVM and qemu, but 
all practical purposes should not be two 'separate communities'. They should 
be one and the same thing.

Separation makes sense where the relationship is light or strictly 
hierarchical - here it's neither. KVM and Qemu is interconnected, quite 
fundamentally so.

> And we're working on this with X.  We'll have a paravirtual graphics driver 
> very soon.  There are no magic solutions.  We need more developers working 
> on the hard problems.

The thing is, writing up a DRM connector to a guest Linux OS could be done in 
no time. It could be deployed to users in no time as well, with the proper 
development model.

That after years and years of waiting proper GX support is _still_ not 
implemented in KVM is really telling of the efficiency of development based on 
such disjoint 'communities'. Maybe put up a committee as well to increase 
efficiency? ;-)

	Ingo
