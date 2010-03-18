Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0CRSH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:07:56 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:35622 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CRSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:07:55 -0400
Date: Thu, 18 Mar 2010 17:28:54 +0100
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
Message-ID: <20100318162853.GB447@elte.hu>
References: <20100318085607.GB2157@elte.hu>
 <4BA1FC80.2000401@redhat.com>
 <20100318105013.GB24464@elte.hu>
 <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA21B09.6060706@redhat.com>
 <20100318130047.GA7424@elte.hu>
 <4BA23FE1.5050402@codemonkey.ws>
 <20100318151737.GA2875@elte.hu>
 <4BA250BF.80704@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA250BF.80704@codemonkey.ws>
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

> On 03/18/2010 10:17 AM, Ingo Molnar wrote:
> >* Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >
> >>On 03/18/2010 08:00 AM, Ingo Molnar wrote:
> >>>>[...]  kvm in fact knows nothing about vga, to take your last example.
> >>>>[...]
> >>>Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG
> >>>ioctl.
> >>>
> >>>See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().
> >>>
> >>>It started out as a VGA optimization (also used by live migration) and
> >>>even today it's mostly used by the VGA drivers - albeit a weak one.
> >>>
> >>>I wish there were stronger VGA optimizations implemented, copying the
> >>>dirty bitmap is not a particularly performant solution. (although it's
> >>>certainly better than full emulation) Graphics performance is one of the
> >>>more painful aspects of KVM usability today.
> >>We have to maintain a dirty bitmap because we don't have a paravirtual
> >>graphics driver.  IOW, someone needs to write an Xorg driver.
> >>
> >>Ideally, we could just implement a Linux framebuffer device, right?
> >No, you'd want to interact with DRM.
> 
> Using DRM doesn't help very much.  You still need an X driver and most of 
> the operations you care about (video rendering, window movement, etc) are 
> not operations that need to go through DRM.

You stripped out this bit from my reply:

> > There are all kernel space projects, going through Xorg would be a 
> > horrible waste of performance for full-screen virtualization. It's fine 
> > for the windowed or networked case (and good as a compatibility fallback), 
> > but very much not fine for local desktop use.

For the full-screen case (which is a very common mode of using a guest OS on 
the desktop) there's not much of window management needed. You need to 
save/restore as you switch in/out.

> 3D graphics virtualization is extremely difficult in the non-passthrough 
> case.  It really requires hardware support that isn't widely available today 
> (outside a few NVIDIA chipsets).

Granted it's difficult in the general case.

> >>Xorg framebuffer driver doesn't implement any of the optimizations that the
> >>Linux framebuffer supports and the Xorg driver does not provide use the
> >>kernel's interfaces for providing update regions.
> >>
> >>Of course, we need to pull in X into the kernel to fix this, right?
> >
> > FYI, this part of X has already been pulled into the kernel, it's called 
> > DRM. If then it's being expanded.
> 
> It doesn't provide the things we need to a good user experience. You need 
> things like an absolute input device, host driven display resize, RGBA 
> hardware cursors.  None of these go through DRI and it's those things that 
> really provide the graphics user experience.

With KSM the display resize is in the kernel. Cursor management is not. Yet: i 
think it would be a nice feature as the cursor could move even if Xorg is 
blocked or busy with other things.

> >> Any sufficiently complicated piece of software is going to interact with 
> >> a lot of other projects.  The solution is not to pull it all into one 
> >> massive repository.  It's to build relationships and to find ways to 
> >> efficiently work with the various communities.
> >
> > That's my whole point with this thread: the kernel side of KVM and qemu, 
> > but all practical purposes should not be two 'separate communities'. They 
> > should be one and the same thing.
> 
> I don't know why you keep saying this.  The people who are in these 
> "separate communities" keep claiming that they don't feel this way.

If you are not two separate communities but one community, then why do you go 
through the (somewhat masochistic) self-punishing excercise of keeping the 
project in two different pieces?

In a distant past Qemu was a separate project and KVM was just a newcomer who 
used it for fancy stuff. Today as you say(?) the two communities are one and 
the same. Why not bring it to its logical conclusion?

> I'm not just saying this to be argumentative.  Many of the people in the 
> community have thought this same thing, and tried it themselves, and we've 
> all come to the same conclusion.
> 
> It's certainly possible that we just missed the obvious thing to do but 
> we'll never know that unless someone shows us.

I'm not aware of anyone in the past having attempted to move qemu to 
tools/kvm/ in the uptream kernel repo, and having reported on the experiences 
with such a contribution setup. (obviously it's not possible at all without 
heavy cooperation and acceptance from you and Avi, so this will probably 
remain a thought experiment forever)

If then you must refer to previous attempts to 'strip down' Qemu, right? Those 
attempts didnt really solve the fundamental problem of project code base 
separation.

	Ingo
