Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1EZIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:25:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab1EZIZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:25:35 -0400
Date: Thu, 26 May 2011 10:24:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, gnatapov@redhat.com,
        Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526082451.GB26775@elte.hu>
References: <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Wed, 25 May 2011, Linus Torvalds wrote:
> 
> > And per-system-call permissions are very dubious. What system 
> > calls don't you want to succeed? That ioctl? You just made it 
> > impossible to do a modern graphical application. Yet the kind of 
> > thing where we would _want_ to help users is in making it easier 
> > to sandbox something like the adobe flash player. But without 
> > accelerated direct rendering, that's not going to fly, is it?
> 
> Going back to the initial idea proposed by Will, where seccomp is 
> simply extended to filter all syscalls, there is potential benefit 
> in being able to limit the attack surface of the syscall API.

If controlling the system call boundary is found to be useful then 
the logical next logical step is to realize that limiting it to 
*only* the syscall boundary is shortsighted.

Also, here's a short reminder of the complexity evolution of this 
patch-set, which i've followed since it's been first posted in 2009:

       bitmask (2009):  6 files changed,  194 insertions(+), 22 deletions(-)
 filter engine (2010): 18 files changed, 1100 insertions(+), 21 deletions(-)
 event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)

Interestingly, the events version is *by far* the most flexible one 
in both the short and the long run, and it is also the smallest patch 
...

It's a perfect fit and that's not really surprising: system call 
boundary hardening is about filtering various key parameters - while 
event tracing is about filtering various key parameters as well.

But it goes further than that: SELinux security policies are in 
essence primitive event filters as well, on an abstract level - see 
below for more details.

And yes, the primitive, coarse, per syscall allow/disallow bitmask v1 
version would not be too painful to the core kernel in terms of code 
impact and interaction with other code (it does not interact at all) 
- but it would still be sadly shortsighted to not explore the event 
filters angle, now that we have actual working code.

It would not improve the LSM situation one tiny bit either - the 
bitmask design would guarantee that the seccomp approach can never 
seriously replace the sucky LSM concepts we have in the kernel today.

> This is not security mediation in terms of interaction between 
> things (e.g. "allow A to read B").  It's a _hardening_ feature 
> which prevents a process from being able to invoke potentially 
> hundreds of syscalls is has no need for.  It would allow us to 
> usefully restrict some well-established attack modes, e.g. 
> triggering bugs in kernel code via unneeded syscalls.

If you think about it then you'll see that this artificial 
distinction between 'mediation' and 'hardening' is nonsense!

If we add the appropriate file label field to VFS tracing events 
(which would be useful for many instrumentation reasons as well) then 
the event filtering variant of Will's patch:

   _will be able to do object level security mediation too_

What is at the core of every access control concept, be that DAC, 
MAC, RBAC or ACL? Flexible task specific set of access vectors to 
file and other labeled objects, which cannot be circumvented by that 
task.

How can we implement a user-space file object manager via Will's 
event filters approach? It's actually pretty easy:

 - a simple object manager wants to know 'who' does something, 'what'
   it is trying to access, and then wants to generate an allow/deny
   action as a function of the (who,what) parameters:

     - The 'who' is a given as the event filters are per
       task, so different tasks with different roles can have
       different event filters. This is the equivalent of the current
       tasks's security context. [ Event filters installed by the
       parent cannot be removed by child tasks (they cannot even read
       them - it's transparent). ]

     - The most finegrained representation of 'what' are inode
       numbers. Because we do not want to generate rules for every
       single object we want to group objects and want to define
       access rules on different groups. This can be done by defining
       an event that emits file labels.

So a simple object manager would simply use file label event 
attributes and would define simple rules like:

	"(label & tmp_t) || (label & user_home_t)"

to allow access to /tmp and /home files. Filters allow us to define 
arbitrary access vectors to objects in essence. The above filters get 
passed to the kernel as an ASCII string by the object manager task, 
where the filter engine parses it safely and creates atomic 
predicates out of it, which can then be executed at the source of any 
event.

[ We could even implement a transparent AVC-cache equivalent for 
  filters, should the complexity and popularity of them increase: 
  ASCII filters lend themselves very well to hash based caches. ]

Similarly, support for other types of object tagging, network labels, 
etc. can be added as well with little pain: they can be added without 
any change to the basic ABI! Using events filters here makes it a 
very extensible security concept.

It is capable to implement the functional equivalent of most MAC, 
DAC, RBAC and other access control concepts, purely in user-space - 
in addition to 'hardening' (which btw. is really access control too, 
in disguise).

Obviously it is all layered: it is only allowed to control access to 
objects all the other security concepts allow for it to access - i.e. 
this is an unprivileged LSM, a per application security layer if you 
will, that can further refine security policies.

In terms of security models this event filters approach is 
unconditional goodness in my opinion.

> This is orthogonal to access control schemes (such as SELinux), 
> which are about mediating security-relevant interactions between 
> objects.

It's only 'orthogonal' because IMO you make two fundamental mistakes:

 1) You arbitrarily limit SELinux to object based security measures 
    alone.

    Which is not even true btw: SELinux certainly has some hooks it
    uses for pragmatic non-object hardening: for example all the
    places where we fall back to capabilities are places where
    there's a method based restriction not object based restriction.

    The KDSKBENT ioctl check for example in 
    security/selinux/hooks.c::selinux_file_ioctl(), or 
    selinux_vm_enough_memory(), or the CAP_MAC_ADMIN exception in
    selinux_inode_getsecurity() all violate 'pure' DAC concepts but
    obviously for pragmatic reasons SELinux is doing these ...

    mmap_min_addr is a borderline method restriction feature as well:
    it does not really control access to the underlying object (RAM),
    but controls one (of many) access methods to it by controlling
    virtual memory ...

    So SELinux, in a rather hypocritical fashion is already involved 
    in hardening and in filtering, because obviously any practical 
    and pragmatic security system *has to*.

 2) You arbitrarily limit Will's patch to *not* be able to
    implement object based security mechanisms. Why?

Syscall hardening and object based access rules are *deeply* 
connected, conceptually they are subsets of one and the same thing: a 
good, organic security model controlling different hierarchies of 
physical and derived (virtual) resources, which allows flexible 
control of both objects *and* methods.

The 'methods' (the syscalls and other functionality) are *also* a 
derived resource so it's entirely legitimate to control access to 
them. Yes, because they are methods you can also try to use them to 
restrict access to underlying objects - this is what AppArmour is 
about mostly, and yes i agree that in the general case it's not a 
particularly robust method.

And yes, i fully submit that object access control has theoretical 
advantages and it should often be the primary measure that gives a 
robust, often provable backbone to a secure system.

But you'd be out of your mind to not recognize:

 - The utility of controlling access methods (as resources) as well, 
   both to reduce the attack surface in the implementation of those 
   methods, and to allow the easy summary control of objects where 
   there's only a low number of (and often only a single!) access 
   method.

 - The utility of unprivileged security frameworks.

 - The utility of stackable security fetures. (defense in depth, 
   anyone?)

Will's astonishingly small patch:

 event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)

Gives us *all three* of those, while also allowing user-space 
implemented MAC, DAC, RBAC as well.

> One area of possible use is KVM/Qemu, where processes now contain 
> entire operating systems, and the attack surface between them is 
> now much broader e.g. a local unprivileged vulnerability is now 
> effectively a 'remote' full system compromise.

Note that the main reason why Qemu needs access method hardening is 
because it has a dominantly state machine based design which does not 
lend itself very well to an object manager security design.

Note that tools/kvm/ would probably like to implement its own object 
manager model as well in addition to access method restrictions: by 
being virtual hardware it deals with many resources and object 
hierarchies that are simply not known to the host OS's LSM.

Unlike Qemu tools/kvm/ has a design that is very fit for MAC 
concepts: it uses separate helper threads for separate resources 
(this could in many cases even be changed to be separate processes 
which only share access to the guest RAM image) - while Qemu is in 
most parts a state machine, so in tools/kvm/ we can realistically 
have a good object manager and keep an exploit in a networking 
interface driver from being able to access disk driver state.

(I've Cc:-ed Pekka for tools/kvm/.)

> There has been some discussion of this within the KVM project.  
> Using the existing seccomp facility is problematic in that it 
> requires significant reworking of Qemu to a privsep model, which 
> would also then incur a likely unacceptable context switching 
> overhead.  The generalized seccomp filter as proposed by Will would 
> provide a significant reduction in exposed syscalls and thus 
> guest->host attack surface.

... and the event filter based method would *also* allow MAC to be 
defined over physical resources, such as virtual network interfaces, 
virtual disk devices, etc.

You are seriously limiting the capabilities of this feature for no 
good reason i can recognize.

Thanks,

	Ingo
