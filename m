Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0CSO4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0CSO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:56:19 -0400
Date: Fri, 19 Mar 2010 15:53:58 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Avi Kivity <avi@redhat.com>,
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
Message-ID: <20100319145358.GC29874@random.random>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E7E2.3010803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1E7E2.3010803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

not really trying to get into the CC list of this discussion ;) but
for what is worth I'd like to share my opinion on the matter.

On Thu, Mar 18, 2010 at 09:44:18AM +0100, Jes Sorensen wrote:
> What made KVM so successful was that the core kernel of the hypervisor
> was designed the right way, as a kernel module where it belonged. It was
> obvious to anyone who had been exposed to the main competition at the
> time, Xen, that this was the right approach. What has ended up killing
> Xen in the end is the not-invented-here approach of copying everything
> over, reformatting it, and rewriting half of it, which made it
> impossible to maintain and support as a single codebase. At my previous

Full agreement with that. CVS/git/patches and development model is
next to irrelevant compared to the basic design of the code.

qemu (and especially qemu-kvm) is surely much closer to perf, than a
firefox or openoffice, because there is some tight interconnect with
the kernel API. And the skills required to produce useful patches in
qemu are similar to the skills requires to produce useful patches for
the kernel, more often than not a new feature in kvm also requires
some merging of a qemu-kvm side patch (it always happened to me so far
;). But clearly we've to draw a barrier somewhere and while I could
see things like systemtap and util-linux included into the kernel and
perf already is, I've an hard time to see userland code supporting
kernels other than linux into the kernel.

I think that's probably where I'd draw the line. Let's say somebody
creates a pure paravirt userland for kvm without full driver emulation
that only runs on a linux kernel and no other OS, maybe that thing
wouldn't be so controversial to include into the kernel as qemu
is. qemu is clearly beyond the "only-running-on-a-linux-kernel"
barrier...

I'd definitely start with systemtap, which I think is even more
suitable than perf to be merged into the kernel. Things useful only
for developers like perf/systemtap makes even more sense to fetch
silently hidden in a single pull. Those projects are so ideal to fetch
together because you run your own compiled userland binary and not an
rpm, and you need very latest kernel and userland package and sometime
new userland might not work so well with older kernel too and the
other way around. they're tool for developers and no developer cares
about API as they rebuild latest userland code anyway, they almost
don't require backwards compatibility of kernel.

> So far your argument would justify pulling all of gdb into the kernel
> git tree as well, to support the kgdb efforts, or gcc so we can get rid
> of the gcc version quirks in the kernel header files, e2fsprogs and
> equivalent for _all_ file systems included in the kernel so we can make
> sure our fs tools never get out of sync with whats supported in the
> kernel......

It also boils down to the maintainer, where the code is, defines the
maintainer who pushes/commits it to the central repository that
everyone pulls from. And having the code into Linus's tree doesn't
make sense unless Linus is interested to follow and review qemu. So
it'd only create blind pulls.

But I entirely see what Ingo is going after and I have no doubt that
contribution increases if some code is merged into the kernel even if
it's userland. The more people clones a project, the more people
builds, uses, reads the code and has incentive to contribute... and
there's nothing else like the linux git tree to give visibility to a
project and get more contributions (well as long as the pulled code
requires similar skills to the kernel code of course). Plus it's
annoying to go on web, find url to clone, clone.. running make is
faster. But this purely is a PR effect. It's like free ads, to get
more people using and looking into the code because it's already on
the harddisk and you've only to run make. After somebody gets familiar
with the pulled userland code because it find it in the tree and it
didn't need to search the web and cut-and-paste and stuff, clone a new
repo, I think it wouldn't matter anymore to have it into the kernel or
not. Like for perf, by now I doubt it'd get less contributions if it's
moved out of the kernel tree. The only reason to leave it there is if
Linus actively checks the code before pulling it.

So I think what would be nice maybe to get the PR/ads positive effect
and get more _users_ (and later developers) involved without actually
merging, is a command like:

   git clone linux-2.6
   cd linux-2.6
   tools/clone-project qemu-kvm
   tools/clone-project qemu
   tools/clone-project systemtap
   tools/clone-project seabios
   tools/clone-project e2fsprogs
   tools/clone-project perf
   ...

And then maybe a git-send-email or similar command that would do the
right thing and send it to the right list or similar. Learning the
process of other projects is time consuming and requires some effort.

But as far as qemu-kvm goes, the visibility is already there, and most
people that could possibly contribute to the kernel side already has
the userland cloned and pulls regularly from it so I doubt it'd
generate anything remotely as beneficial like it did for
perf. systemtap is really _identical_ to perf. You include it, lots
more developers toys with it by just running "make", they find a bug
and they fixes it, and they keep on contributing new features later
after they got familiar with it. As usual ;).

In separate mail Ingo said:

> Btw., i made similar arguments to Avi about 3 years ago when it was
> going upstream, that qemu should be unified with KVM. This is more
> true today than ever.

Well not sure if with KVM you mean qemu-kvm or KVM kernel code, but I
would see an huge value and a win-win situation to see qemu-kvm and
qemu unified. It's out of my reach how there can be still be a
difference considering that nobody runs qemu with perhaps the
exception of the maintainers themself. There's not even a qemu/kvm
directory in qemu. These are the real problems that should be
solved... Every time I've to send a patch I've to check if it also
applies to qemu. I usually start with qemu-kvm to do my development
there, and then I cross fingers and I hope the patch applies clean
against qemu too, and send it there in that case. qemu and qemu-kvm
are the same thing, it's the same people, it's the same community,
it's the same skills, it's an absolute waste that a little amount of
code isn't merged so we can all work on the same tree.  And it's not
an huge patch at all if compared to the size of qemu-kvm... so there
can't be any technical explanation for qemu to take a tangent
here.

So my suggestion is to start with what will give a _real_ tangible
benefit to developers (i.e. to all work on the same branch), the PR
effect of merging it into the kernel would be minor for qemu-kvm,
it really doesn't matter which url we pull the code from as long as
there is only 1 url and not 2.
