Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0CQILD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:11:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0CQIK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:10:57 -0400
Date: Wed, 17 Mar 2010 09:10:41 +0100
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
Subject: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100317081041.GC16374@elte.hu>
References: <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA00F1F.1090907@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/16/2010 12:39 PM, Ingo Molnar wrote:
> >>If we look at the use-case, it's going to be something like, a user is
> >>creating virtual machines and wants to get performance information about
> >>them.
> >>
> >>Having to run a separate tool like perf is not going to be what they would
> >>expect they had to do.  Instead, they would either use their existing GUI
> >>tool (like virt-manager) or they would use their management interface
> >>(either QMP or libvirt).
> >>
> >>The complexity of interaction is due to the fact that perf shouldn't be a
> >>stand alone tool.  It should be a library or something with a programmatic
> >>interface that another tool can make use of.
> >But ... a GUI interface/integration is of course possible too, and it's being
> >worked on.
> >
> >perf is mainly a kernel developer tool, and kernel developers generally dont
> >use GUIs to do their stuff: which is the (sole) reason why its first ~850
> >commits of tools/perf/ were done without a GUI. We go where our developers
> >are.
> >
> >In any case it's not an excuse to have no proper command-line tooling. In fact
> >if you cannot get simpler, more atomic command-line tooling right then you'll
> >probably doubly suck at doing a GUI as well.
> 
> It's about who owns the user interface.
> 
> If qemu owns the user interface, than we can satisfy this in a very simple 
> way by adding a perf monitor command.  If we have to support third party 
> tools, then it significantly complicates things.

Of course illogical modularization complicates things 'significantly'.

I wish both you and Avi looked back 3-4 years and realized what made KVM so 
successful back then and why the hearts and minds of virtualization developers 
were captured by KVM almost overnight.

KVM's main strength back then was that it was a surprisingly functional piece 
of code offered by a 10 KLOC patch - right on the very latest upstream kernel. 
Code was shared with upstream, there was version parity, and it all was in the 
same single repo which was (and is) a pleasure to develop on.

Unlike Xen, which was a 200+ KLOC patch on top of a forked 10 MLOC kernel a 
few upstream versions back. Xen had constant version friction due to that fork 
and due to that forced/false separation/modularization: Xen _itself_ was a 
fork of Linux to begin with. (for exampe Xen still had my copyrights last i 
checked, which it got from old Linux code i worked on)

That forced separation and version friction in Xen was a development and 
productization nightmare, and developing on KVM was a truly refreshing 
experience. (I'll go out on a limb to declare that you wont find a _single_ 
developer on this list who will tells us otherwise.)

Fast forward to 2010. The kernel side of KVM is maximum goodness - by far the 
worst-quality remaining aspects of KVM are precisely in areas that you 
mention: 'if we have to support third party tools, then it significantly 
complicates things'. You kept Qemu as an external 'third party' entity to KVM, 
and KVM is clearly hurting from that - just see the recent KVM usability 
thread for examples about suckage.

So a similar 'complication' is the crux of the matter behind KVM quality 
problems: you've not followed through with the original KVM vision and you 
have not applied that concept to Qemu!

And please realize that the user does not care that KVM's kernel bits are top 
notch, if the rest of the package has sucky aspects: it's always the weakest 
link of the chain that matters to the user.

Xen sucked because of such design shortsightedness on the kernel level, and 
now KVM suffers from it on the user space level.

If you want to jump to the next level of technological quality you need to fix 
this attitude and you need to go back to the design roots of KVM. Concentrate 
on Qemu (as that is the weakest link now), make it a first class member of the 
KVM repo and simplify your development model by having a single repo:

 - move a clean (and minimal) version of the Qemu code base to tools/kvm/, in
   the upstream kernel repo, and work on that from that point on.

 - co-develop new features within the same patch. Release new versions of
   kvm-qemu and the kvm bits at the same time (together with the upstream
   kernel), at well defined points in time.

 - encourage kernel-space and user-space KVM developers to work on both 
   user-space and kernel-space bits as a single unit. It's one project and a
   single experience to the user.

 - [ and probably libvirt should go there too ]

If KVM's hypervisor and guest kernel code can enjoy the benefits of a single 
repository, why cannot the rest of KVM enjoy the same developer goodness? Only 
fixing that will bring the break-through in quality - not more manpower 
really.

Yes, i've read a thousand excuses for why this is an absolutely impossible and 
a bad thing to do, and none of them was really convincing to me - and you also 
have become rather emotional about all the arguments so it's hard to argue 
about it on a technical basis.

We made a similar (admittedly very difficult ...) design jump from oprofile to 
perf, and i can tell you from that experience that it's day and night, both in 
terms of development and in terms of the end result!

( We recently also made another, kernel/kernel unification that had a very
  positive result: we unified the 32-bit and 64-bit x86 architectures. Even 
  within the same repo the unification of technology is generally a good 
  thing. The KVM/Qemu situation is different - it's more similar to the perf 
  design. )

Not having to fight artificial package boundaries and forced package 
separation is very refreshing experience to a developer - and very rewarding 
and flexible to develop on. ABI compatibility is _easier_ to maintain in such 
a model. It's quite similar to the jump from Xen hacking to KVM hacking (i did 
both). It's a bit like the jump from CVS to Git. Trust me, you _cannot_ know 
the difference if you havent tried a similar jump with Qemu.

Anyway, you made your position about this rather clear and you are clearly 
uncompromising, so i just wanted to post this note to the list: you'll waste 
years of your life on a visibly crappy development model that has been unable 
to break through a magic usability barrier for the past 2-3 years - just like 
the Xen mis-design has wasted so many people's time and effort in kernel 
space.

Thanks,

	Ingo
