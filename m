Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1KGUdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:33:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:54542 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1KGUdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:33:05 -0500
Date: Mon, 7 Nov 2011 15:32:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Vince Weaver <vince@deater.net>, Anthony Liguori <anthony@codemonkey.ws>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to
 test kernels
Message-ID: <20111107203255.GF24234@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Avi Kivity <avi@redhat.com>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
 <4EB6BAED.2030400@redhat.com>
 <4EB6BEFA.6000303@codemonkey.ws>
 <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 09:53:28PM +0200, Pekka Enberg wrote:
> 
> I'm sure perf developers break the ABI sometimes - that happens
> elsewhere in the kernel as well. However, Ted claimed that perf
> developers use tools/perf as an excuse to break the ABI _on purpose_
> which is something I have hard time believing.

I remember an assertion, probably a year or two ago, probably at the
previous year's kernel summit, that one of the reasons for having the
perf code inline in the kernel was so that synchronized changes could
be made to both the kernel and userspace tool together.  So it's not a
matter of breaking the ABI _on_ _purpose_, it's an assertion that
there is no ABI at all.  Since the perf tool and the kernel tool have
to be built together, so long as a user does that, no harm, no foul.
Recall that Linus has said that he doesn't care about whether or not
something is an ABI; he only care if users code don't perceive
breakage.  If they didn't perceive breakage, then it doesn't matter if
an interface is changed.

So the real question is whether or not this was an excuse to break the
ABI, but whether or not the perf developers acknowledge there is an
ABI at all, and whether it's OK for other developers to depend on the
syscall interface or not.  Actually, though, it shouldn't matter,
because intentions don't matter.

Recall the powertop/ftrace case.  If you expose an interface, and
people start using that interface, then you can't break them, period.
So as far as Vince is concerned, if you have a userspace library which
depends on the perf interface, then you should try out the kernel
after each merge window, and if your library breaks, you should
complain to Ingo and Linus directly, and request that the commit which
broke your tool to be reverted --- because that's the rule; no
breakage is allowed.

As far as kvm-tool being in the kernel, I still don't see particularly
valid arguments for why it should be in the kernel.  It can't be the
perf argument of "we can make simultaneous changes in the userspace
and kernel code", because if those changes break qemu-kvm, then a
complaint to Linus will cause the problem code to be reverted.

As far as the code using the same coding conventions and naming
conventions as the kernel, that to me isn't a particular strong
argument either.  E2fsprogs uses the Signed-off-by lines, and the same
coding conventions of the kernel, and it even has a slightly modified
version of two kernel source file in e2fsprogs (e2fsck/recovery.c and
e2fsck/revoke.c), plus a header file with data structures that have to
be kept in sync with the kernel header file.  But that doesn't make it
"part of the kernel", and it's not a justification for it to be
bundled with the kernel.

Personally, I consider code that runs in userspace as a pretty bright
line, as being "not kernel code", and while perhaps things like
initramfs and the crazy ideas people have had in the past of moving
stuff out of kernel/init.c into userspace might have qualified as
stuff really close to the kernel, something like kvm-tool that runs
way after boot, doesn't even come close.  Wine is another example of
another package that has lots of close kernel ties, but was also not
bundled into the kernel.

The precedent has all mainly been on the "keep the kernel separate"
side of things, and the arguments for bundling it with the kernel are
much weaker, especially since the interface is well-developed, and
there are external users of the interface which means you can't make
changes to the interface willy-nilly.

Indeed, when the perf interface was changing all the time, maybe there
was some convenience to have it be bundled with the kernel, so there
was no need to negotiate interface version numbers, et. al.  But given
how it has to link in so many user space libraries, I personally think
it's fair to ask the question whether now that it has matured, whether
it's time to move it out of the kernel source tree.

Regards,

							- Ted
