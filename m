Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2JFNLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:11:46 -0400
Received: from r00tworld.com ([212.85.137.150]:58627 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2JFNLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:11:44 -0400
From: "PaX Team" <pageexec@freemail.hu>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Date: Sat, 06 Oct 2012 15:11:12 +0200
MIME-Version: 1.0
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
Reply-to: pageexec@freemail.hu
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>,
        spender@grsecurity.net
Message-ID: <50702DF0.32447.D66E777@pageexec.freemail.hu>
In-reply-to: <CAKFga-eLC+2utN05Yu_CwEMLsXNi64Fn0zv36O5T=u7ncn+B+Q@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>, <506D8669.30501.3087FAA@pageexec.freemail.hu>, <CAKFga-eLC+2utN05Yu_CwEMLsXNi64Fn0zv36O5T=u7ncn+B+Q@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Sat, 06 Oct 2012 15:11:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Oct 2012 at 15:56, Ard Biesheuvel wrote:

> 2012/10/4 PaX Team <pageexec@freemail.hu>:
> The main difference here is that it is much easier to doctor a set of
> stack frames that issues a mprotect(+PROT_EXEC) on the whole address
> space than it is to re-issue the exact same mmap() call (with
> MAP_FIXED this time, and the exact offset the kernel decided to load
> it this time around) that will put the same code/data in exactly the
> same place in memory (relocated and all) without blowing up your
> process.

sadly, this is not true at all, for multiple reasons:

1. not all archs pass (all) parameters on the stack (arm, amd64 come to
   mind), so the content of the stack at the time the bug is triggered
   is not too relevant, gadgets can be used to construct anything later.

2. the exploit payload doesn't need to be on the process/thread stack
   at all. in fact, the more reliable exploits have for long used some
   form of heap spraying and stack pivoting to increase the chances of
   success. see also

   https://www.corelan.be/index.php/2010/06/16/exploit-writing-tutorial-part-10-chaining-dep-with-rop-the-rubikstm-cube/

3. exploit techniques moved away from simple linear stack overwrites
   and shellcode execution over a decade ago, the relevant methods all
   rely on ret2libc/ROP style exploitation. this has been automated to
   the point that tools can analyze binaries to extract a gadget dictionary
   (think 'insn set') and feed it into a gadget compiler that will produce
   a working and reliable exploit automatically. suggested reading:

   http://users.ece.cmu.edu/~ejschwar/bib/schwartz_2011_rop-abstract.html

4. for your particular suggestions about mprotect vs. mmap: mprotect cannot
   be called with arbitrary parameters either, the start address must fall
   inside a mapping and the end address must fall within the process address
   space limit and the protection bits can't have arbitrary bits set either.

   regarding reissuing the exact same mmap call: i just mentioned this to
   show that the PROT_FINAL proposal is circumventible (easily so, if we
   assume the attacker you mention in the changelog), obviously in a real
   life exploit scenario we wouldn't care about this, the attacker would
   simply create an rwx mapping and copy the shellcode there and execute
   it from there. and if for some reason rwx mappings are prevented otherwise,
   an rw mapping will do perfectly fine for a gadget based exploit (to the
   point that iOS jailbreaks implement *kernel* exploits with gadgets).

> In our specific implementation, it is mainly about rodata
> (public keys) rather than executable code, but the same applies; for
> us, it is more about rigging binaries: the attacker may not be
> interested in hijacking the whole process, but just nop'ing out some
> code that makes the process behave more to his liking.

and how do you prevent an attack from overmapping that rodata map? is there
something in your LSM that 'cements' specific mappings into the address
space (and some mechanism that does the same to all writable pointers
that refer to said mappings)?

also what about mprotect(PROT_NONE), i.e., instead of trying to acquire
more rights, degrade them? is that allowed? does your app handle this
properly? (these are side questions, just trying to poke holes ;)

> > i'm guessing again that their LSM tries to tackle the above described
> > scenarios except we don't know if this LSM will ever become public,
> > whether/how other LSMs will acquire the same capabilities and why it's
> > not mentioned in the PROT_FINAL submission that by itself this feature
> > doesn't increase security. i'm also wondering what kind of policy can
> > allow ld.so to load a library but forbid it a second time, it doesn't
> > seem compatible with real-life cases (think dynamically loaded and
> > unloaded plugins), not to mention the control of anonymous mappings.
> >
> 
> The LSM encapsulates the policy, and relies on the PROT_FINAL feature.
> The fact that the policy can impose the use of PROT_FINAL in
> particular cases[...]

i don't understand something here: if your kernel can detect when to use
PROT_FINAL, then why do you need it at all? why doesn't the kernel at
that point simply enforce the behaviour of PROT_FINAL itself (not unlike
PaX/MPROTECT does with runtime codegen)? in other words, why do you need
userland to tell the kernel about PROT_FINAL when your kernel can already
detect its need (dictated by the policy you mentioned above).

> [...]makes the implementation of the policy potentially
> much simpler than that of PaX MPROTECT (but not necessarily as
> secure).

the 'policy' to manage PaX/MPROTECT is very simple. you enable it in the
kernel, and you get MPROTECT enabled on all apps by default. if you want
to disable it on an app, you set it in the binary or in grsec's RBAC policy
(a single line per subject), i don't think you can get it done any simpler
than that. but it'd certainly help to see more details about how you intend
to use this and equally importantly, how the other LSMs could make use of
it. and by 'use' i mean 'increase security of the system'.

> However, let's decide first whether there is a point to having some
> control over the VM_MAY* flags directly. If yes, then the patch makes
> sense, otherwise it doesn't. How policies may be built on top of that
> is part of another debate.

there's certainly a point (i've been doing it for 12 years now), but to
make an mprotect flag into an actual security feature, it had better pass
simple tests, such as non-circumventability. any method relying on userland
playing nice is already suspect of being the wrong way and right now i don't
see how PROT_FINAL could be used for actual security.

> > ptrace cares about VM_MAYWRITE which PROT_FINAL can take away (under
> > PaX MPROTECT'ed processes cannot be debugged with sw breakpoints).
> >
> 
> My bad: I spent some time looking at access_process_vm() but could not
> find any references to the vma permissions.

look at get_user_pages and how the 'force' parameter is passed down/handled
later.

> >> Could we at least agree on the fundamental notion that the special
> >> powers the loader has to modify .text and .rodata sections are hardly
> >> ever needed by the programs themselves? In that sense, this is similar
> >> to dropping root privileges when not required anymore, and that is
> >> typically recognized as a sensible idea.
> >
> > the difference is that the uid is a process-wide attribute, whereas
> > PROT_FINAL isn't, unlike PaX's MPROTECT. in other words, dropping root
> > is irreversible but PROT_FINAL isn't, one just has to create an entirely
> > new mapping to acquire the access rights that PROT_FINAL was supposed to
> > prevent (again, all this modulo an LSM and policies).
> >
> 
> There remains a fundamental difference between the ability to
> manipulate existing mappings and creating entirely new ones.

what would be that fundamental difference? for an exploit writer it's the
same (even automated) effort.

> Especially when trying to manipulate GOT/PLT or vtable entries or
> tweak the behavior of a program in other subtle ways, mmap()'ing the
> same file again is just not going to cut it.

don't get too hooked up on mapping the same file, i just mentioned it
to prove that userland can circumvent the PROT_FINAL feature as designed.
a real exploit would of course do something different after the initial
control flow hijacking. as a sidenote, the GOT is already read-only these
days under RELRO and BIND_NOW.

cheers,
  PaX Team

