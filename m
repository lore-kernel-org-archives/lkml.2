Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab0CRKKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:10:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54725 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0CRKKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:10:36 -0400
Date: Thu, 18 Mar 2010 11:10:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318101025.GA13073@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
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


* Alexander Graf <agraf@suse.de> wrote:

> 
> On 18.03.2010, at 09:56, Ingo Molnar wrote:
> 
> > 
> > * Avi Kivity <avi@redhat.com> wrote:
> > 
> >> On 03/17/2010 10:10 AM, Ingo Molnar wrote:
> >>> 
> >>>> It's about who owns the user interface.
> >>>> 
> >>>> If qemu owns the user interface, than we can satisfy this in a very 
> >>>> simple way by adding a perf monitor command.  If we have to support third 
> >>>> party tools, then it significantly complicates things.
> >>> 
> >>> Of course illogical modularization complicates things 'significantly'.
> >> 
> >> Who should own the user interface then?
> > 
> > If qemu was in tools/kvm/ then we wouldnt have such issues. A single patch (or 
> > series of patches) could modify tools/kvm/, arch/x86/kvm/, virt/ and 
> > tools/perf/.
> 
> It's not a 1:1 connection. There are more users of the KVM interface. To 
> name a few I'm aware of:
> 
> - Mac-on-Linux (PPC)
> - Dolphin (PPC)
> - Xenner (x86)
> - Kuli (s390)

There must be a misunderstanding here: tools/perf/ still has a clear userspace 
interface and ABI. There's external projects making use of it: sysprof and 
libpfm (and probably more i dont know about it). Those projects are also 
contributing back.

Still it's _very_ useful to have a single reference implementation under 
tools/perf/ where we concentrate the best of the code. That is where we make 
sure that each new kernel feature is appropriately implemented in user-space 
as well, that the combination works well together and is releasable to users. 
That is what keeps us all honest: the latency of features is much lower, and 
there's no ping-pong of blame going on between the two components in case of 
bugs or in case of misfeatures.

Same goes for KVM+Qemu: it would be so much nicer to have a single, 
well-focused reference implementation under tools/kvm/ and have improvements 
flow into that code base.

That way KVM developers cannot just shrug "well, GUI suckage is a user-space 
problem" - like the answers i got in the KVM usability thread ...

The buck will stop here.

And if someone thinks he can do better an external project can be started 
anytime. (it may even replace the upstream thing if it's better)

> Having a clear userspace interface is the only viable solution there. And if 
> you're interested, look at my MOL enabling patch. It's less than 500 lines 
> of code.

Why do you suppose that what i propose is an "either or" scenario?

It isnt. I just suggested that instead of letting core KVM fragment its limbs 
into an external entity, put your name behind one good all-around solution and 
focus the development model into a single project.

I.e. do what KVM has done originally in the kernel space to begin with - and 
where it was so much better than Xen: single focus.

Learn from what KVM has done so well in the initial years and use the concept 
on the user-space components as well. The very same arguments that caused KVM 
to integrate into the upstream kernel (instead of being a separate project) 
are a valid basis to integrate the user-space components into tools/kvm/. Dont 
forget your roots and dont assume all your design decisions were correct.

> The kernel/userspace interface really isn't the difficult part. Getting 
> device emulation working properly, easily and fast is.

The kernel/userspace ABI is not difficult at all. Getting device emulation 
working properly, easily and fast indeed is. And my experience is that it is 
not working properly nor quickly at the moment, at all. (see the 'KVM 
usability' thread)

Getting device emulation working properly often involves putting certain 
pieces that are currently done in Qemu into kernel-space. That kind of 
'movement of emulation technology' from user-space component into the 
kernel-space component [or back] would very clearly be helped if those two 
components were in the same repository.

And i have first-hand experience there: we had (and have) similar scenarios 
with tools/perf routinely. We did some aspects in user-space, then decided to 
do it in kernel-space. Sometimes we moved kernel bits to user-space. It was 
very easy and there were no package and version complications as it's a single 
project. Sometimes we even moved bits back and forth until we found the right 
balance.

Thanks,

	Ingo
