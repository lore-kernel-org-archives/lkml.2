Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0KPToU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:44:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab0KPToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:44:18 -0500
MIME-Version: 1.0
In-Reply-To: <1289934800.2109.653.camel@laptop>
References: <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <1289931715.2109.648.camel@laptop>
 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm> <1289933965.2109.652.camel@laptop>
 <20101116190916.GD13092@redhat.com> <1289934800.2109.653.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 11:35:42 -0800
Message-ID: <AANLkTinp45D+1XM4vc961RRHWK3WV_N7REY2=34X3ir8@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, david@lang.hm,
        Paul Menage <menage@google.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:13 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Its cpu-controller only, and then only for SCHED_OTHER tasks which are
> proportionally fair.

Well, it's _currently_ CPU controller only. People have already
wondered if we should try to do something similar for IO scheduling
too.

So the thing I think is worth keeping in mind is that the "per-tty
scheduling group" is really just an implementation issue. There is
absolutely no question that it can't be about more than just
scheduling, and that it can't be about more than just tty's also.

And an important thing to keep in mind is that "user interfaces are
bad". The thinner the interface, the better. One of the reasons I
really like autogroup is that it has _no_ interface at all. It's very
much a heuristic, and it has zero user interface (apart from the knob
that turns it on and off, of course). That is a great feature, because
it means that you cannot break the interface. You will never need to
have applications that have special linux-specific hooks in them, or
system daemons who have to touch magical /proc files etc.

One of the problems I found annoying when just testing it using the
plain cgroup interface (before the patch) was the resource management.
You needed root, and they actually made sense requiring root, because
I don't think we _want_ to allow people creating infinite numbers of
cgroups. Vivek's "trivial patch" (shell script) is a major DoS thing,
for example. Letting normal users create cgroups willy-nilly is not a
good idea (and as Vivek already found out, his trivial script leaks
cgroups in a pretty fundamental way).

The tty approach is somewhat self-limiting in that it requires you to
get the tty to get an autogroup. But also, because it's very much a
heuristic and doesn't have any user-visible interfaces, from a kernel
perspective it's wonderful. There are no "semantics" to break. If it
turns out that there is some way to create excessive cgroups, we can
introduce per-user limits etc to say "the heuristic works up to X
cgroups and then you'll just get your own user group". And nobody
would ever notice.

So doing things automatically and without any user interface is about
_more_ than just convenience. If it can be done that way, it is
fundamentally better way to do things. Because it hides the
implementation details, and leaves us open to do totally different
things in the end.

For example, 'cgroups' itself is pretty heavy-weight, and is really
quite smart. Those things nest, etc etc. But with the "it's just a
heuristic", maybe somebody ends up doing a "simplified non-nesting
grouping thing", and if you don't want the whole cgroup thing (I have
always answered no to CONFIG_CGROUPS myself, for example), you could
still do the autogrouping. But you could _not_ cleanly do the
/proc/sys/cgroup/user scripting, because your implementation is no
longer based on the whole cgroups thing.

Now, will any of this ever happen? I dunno. I doubt it will matter.
But it's an example of why I think it's such a great approach, and why
"it just works" is such an important feature.

                       Linus

                       Linus
