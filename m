Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab0CRIor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab0CRIoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:44:44 -0400
Message-ID: <4BA1E7E2.3010803@redhat.com>
Date: Thu, 18 Mar 2010 09:44:18 +0100
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu>
In-Reply-To: <20100317081041.GC16374@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/10 09:10, Ingo Molnar wrote:
> I wish both you and Avi looked back 3-4 years and realized what made KVM so
> successful back then and why the hearts and minds of virtualization developers
> were captured by KVM almost overnight.

Ingo,

What made KVM so successful was that the core kernel of the hypervisor
was designed the right way, as a kernel module where it belonged. It was
obvious to anyone who had been exposed to the main competition at the
time, Xen, that this was the right approach. What has ended up killing
Xen in the end is the not-invented-here approach of copying everything
over, reformatting it, and rewriting half of it, which made it
impossible to maintain and support as a single codebase. At my previous
employer we ended up dropping all Xen efforts exactly because it was
like maintaining two separate operating system kernels. The key to KVM
is that once you have Linux, you practically have KVM as well.

> Fast forward to 2010. The kernel side of KVM is maximum goodness - by far the
> worst-quality remaining aspects of KVM are precisely in areas that you
> mention: 'if we have to support third party tools, then it significantly
> complicates things'. You kept Qemu as an external 'third party' entity to KVM,
> and KVM is clearly hurting from that - just see the recent KVM usability
> thread for examples about suckage.
>
> So a similar 'complication' is the crux of the matter behind KVM quality
> problems: you've not followed through with the original KVM vision and you
> have not applied that concept to Qemu!

Well there are two ways to go about this. Either you base the KVM
userland on top of an existing project, like QEMU, _or_ you rewrite it
all from scratch. However, there is far more to it than just a couple of
ioctls, for example the stack of reverse device-drivers is a pretty
significant code base, rewriting that and maintaining it is not a
trivial task. It is certainly my belief that the benefit we get from
sharing that with QEMU by far outweighs the cost of forking it and
keeping our own fork in the kernel tree. In fact it would result in
exactly the same problems I mentioned above wrt Xen.

> If you want to jump to the next level of technological quality you need to fix
> this attitude and you need to go back to the design roots of KVM. Concentrate
> on Qemu (as that is the weakest link now), make it a first class member of the
> KVM repo and simplify your development model by having a single repo:
>
>   - move a clean (and minimal) version of the Qemu code base to tools/kvm/, in
>     the upstream kernel repo, and work on that from that point on.

With this you have just thrown away all the benefits of having the QEMU
repository shared with other developers who will actively fix bugs in
components we do care about for KVM.

>   - encourage kernel-space and user-space KVM developers to work on both
>     user-space and kernel-space bits as a single unit. It's one project and a
>     single experience to the user.

This is already happening and a total non issue.

>   - [ and probably libvirt should go there too ]

Now that would be interesting, next we'll have to include things like
libxml in the kernel git tree as well, to make sure libvirt doesn't get
out of sync with the version supplied by your distribution vendor.

> Yes, i've read a thousand excuses for why this is an absolutely impossible and
> a bad thing to do, and none of them was really convincing to me - and you also
> have become rather emotional about all the arguments so it's hard to argue
> about it on a technical basis.

So far your argument would justify pulling all of gdb into the kernel
git tree as well, to support the kgdb efforts, or gcc so we can get rid
of the gcc version quirks in the kernel header files, e2fsprogs and
equivalent for _all_ file systems included in the kernel so we can make
sure our fs tools never get out of sync with whats supported in the
kernel......

> We made a similar (admittedly very difficult ...) design jump from oprofile to
> perf, and i can tell you from that experience that it's day and night, both in
> terms of development and in terms of the end result!

The user components for perf vs oprofile are _tiny_ projects compared to
the portions of QEMU that are actually used by KVM.

Oh and you completely forgot SeaBIOS. KVM+QEMU rely on SeaBIOS too, so
from what you're saying we should pull that into the kernel git
repository as well. Never mind the fact that we share SeaBIOS with the
coreboot project which is very actively adding features to it that
benefit us as well.....

Sorry, but there are times when unification make sense, and there are
times where having a reasonably well designed split makes sense. KVM
had problems with QEMU in the past which resulted in the qemu-kvm branch
of it, which proved to be a major pain to deal with, but that is
fortunately improving and qemu-kvm should go away completely at some
point.

Cheers,
Jes
