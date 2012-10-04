Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2JDNYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:24:33 -0400
Received: from r00tworld.com ([212.85.137.150]:43874 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2JDNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:24:32 -0400
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 09:24:31 EDT
From: "PaX Team" <pageexec@freemail.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Date: Thu, 04 Oct 2012 14:51:53 +0200
MIME-Version: 1.0
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
Reply-to: pageexec@freemail.hu
CC: Ard Biesheuvel <ard.biesheuvel@gmail.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Message-ID: <506D8669.30501.3087FAA@pageexec.freemail.hu>
In-reply-to: <CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>, <20121003141804.f9896690.akpm@linux-foundation.org>, <CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Thu, 04 Oct 2012 14:51:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Oct 2012 at 15:19, Kees Cook wrote:
> On Wed, Oct 3, 2012 at 2:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > It sounds as though the PaX developers could provide useful review
> > input on this proposal.  Do they know about it?  If so, what is their
> > position?
> 
> I'd rather not speak for them, but I understood it to be along the
> lines of "that's nice, we'll keep ours." :) (Now added to CC.)

thanks for the heads up Kees ;). i've read through the thread since
the first post in August and i have one big lingering question before
i can say anything about the implementation: what is the whole point
of this exercise? in particular, what kind of threat model underlies
the design? what do we expect from an attacker? what restrictions does
he operate under?

i'm asking these basic questions because i have the feeling that there's
some misundertanding here. the following is my speculation based on Ard's
first post that was quoted below already (https://lkml.org/lkml/2012/8/14/448):

> >> This patch adds support for the PROT_FINAL flag to
> >> the mmap() and mprotect() syscalls.
> >>
> >> The PROT_FINAL flag indicates that the requested set
> >> of protection bits should be final, i.e., it shall
> >> not be allowed for a subsequent mprotect call to
> >> set protection bits that were not set already.
> >>
> >> This is mainly intended for the dynamic linker,
> >> which sets up the address space on behalf of
> >> dynamic binaries. By using this flag, it can
> >> prevent exploited code from remapping read-only
> >> executable code or data sections read-write.

now this last paragraph/sentence seems to be the closest thing that
describes a scenario where we have some vulnerability (i'm guessing
of the memory corruption kind) that allows an attacker (exploit writer)
to force the attacked vulnerable application to perform a gratuitous
mprotect(PROT_WRITE|PROT_EXEC) on some library/etc mapping and prepare
it for shellcode injection/execution (a.k.a. 'game over' or the 'holy
grail' ;). so far so good. the question that arises here is that what
prevents the same exploit technique (say, ret2libc in this case) from
executing an open/mmap(PROT_WRITE|PROT_EXEC) of the very same library
that PROT_FINAL would protect? or just a plain anon mmap that is just as
good for shellcode execution? in other words, if the attacker can make
the attacked application execute mprotect with arbitrary parameters,
then why can't the same attacker execute open/mmap/etc as well, completely
circumventing the proposed solution? i hope you see now why this issue
has to be settled before anyone looks into the implementation details.

now later in the thread Ard said this:

> The 'interface' we use is a LSM .ko which registers handlers for
> mmap() and mprotect() that fail the respective invocations if the
> passed arguments do not adhere to the policy.

i'm guessing again that their LSM tries to tackle the above described
scenarios except we don't know if this LSM will ever become public,
whether/how other LSMs will acquire the same capabilities and why it's
not mentioned in the PROT_FINAL submission that by itself this feature
doesn't increase security. i'm also wondering what kind of policy can
allow ld.so to load a library but forbid it a second time, it doesn't
seem compatible with real-life cases (think dynamically loaded and
unloaded plugins), not to mention the control of anonymous mappings.

last but not least, just saw this from Ard while not on CC:

> ptrace() doesn't care whether or not the process itself can write to
> its .text segment.

ptrace cares about VM_MAYWRITE which PROT_FINAL can take away (under
PaX MPROTECT'ed processes cannot be debugged with sw breakpoints).

> Could we at least agree on the fundamental notion that the special
> powers the loader has to modify .text and .rodata sections are hardly
> ever needed by the programs themselves? In that sense, this is similar
> to dropping root privileges when not required anymore, and that is
> typically recognized as a sensible idea.

the difference is that the uid is a process-wide attribute, whereas
PROT_FINAL isn't, unlike PaX's MPROTECT. in other words, dropping root
is irreversible but PROT_FINAL isn't, one just has to create an entirely
new mapping to acquire the access rights that PROT_FINAL was supposed to
prevent (again, all this modulo an LSM and policies).

> > Again: has this proposal been reviewed by the glibc maintainers?  If
> > Also, you earlier stated that "It's a more direct version of PaX's
> > "MPROTECT" feature[1]".  This is useful information.  Please update the
> > changelog to describe that PaX feature and to describe the difference
> > between the two, and the reasons for that difference.
> 
> AIUI, it's much more aggressive. It tries to protect all processes
> automatically (rather than this which is at the request of the
> process) and gets in the way of things like Java that expect to be
> able to do w+x mappings.

for the gory details: http://pax.grsecurity.net/docs/mprotect.txt.
the basic idea is that you either grant a process the ability to
generate code at runtime (in whatever form) or you take it away for
good, as nobody has come up with a secure middle-ground so far (it's
a very non-trivial exercise to create such a mechanism assuming the
generic 'attacker can read/write arbitrary memory' model).

as for java/etc, PaX has a per-process control mechanism to disable
this enforcement, but it's static (decided at process creation time,
ideally from a MAC system), not dynamic (something an attack could
abuse).

cheers,
 PaX Team

