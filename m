Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2JDN4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:56:37 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40130 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2JDN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <506D8669.30501.3087FAA@pageexec.freemail.hu>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20121003141804.f9896690.akpm@linux-foundation.org>
	<CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
	<506D8669.30501.3087FAA@pageexec.freemail.hu>
Date: Thu, 4 Oct 2012 15:56:35 +0200
Message-ID: <CAKFga-eLC+2utN05Yu_CwEMLsXNi64Fn0zv36O5T=u7ncn+B+Q@mail.gmail.com>
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: pageexec@freemail.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/4 PaX Team <pageexec@freemail.hu>:

Thanks for taking a look at this matter.

>> >> This is mainly intended for the dynamic linker,
>> >> which sets up the address space on behalf of
>> >> dynamic binaries. By using this flag, it can
>> >> prevent exploited code from remapping read-only
>> >> executable code or data sections read-write.
>
> now this last paragraph/sentence seems to be the closest thing that
> describes a scenario where we have some vulnerability (i'm guessing
> of the memory corruption kind) that allows an attacker (exploit writer)
> to force the attacked vulnerable application to perform a gratuitous
> mprotect(PROT_WRITE|PROT_EXEC) on some library/etc mapping and prepare
> it for shellcode injection/execution (a.k.a. 'game over' or the 'holy
> grail' ;). so far so good. the question that arises here is that what
> prevents the same exploit technique (say, ret2libc in this case) from
> executing an open/mmap(PROT_WRITE|PROT_EXEC) of the very same library
> that PROT_FINAL would protect? or just a plain anon mmap that is just as
> good for shellcode execution? in other words, if the attacker can make
> the attacked application execute mprotect with arbitrary parameters,
> then why can't the same attacker execute open/mmap/etc as well, completely
> circumventing the proposed solution? i hope you see now why this issue
> has to be settled before anyone looks into the implementation details.
>

The main difference here is that it is much easier to doctor a set of
stack frames that issues a mprotect(+PROT_EXEC) on the whole address
space than it is to re-issue the exact same mmap() call (with
MAP_FIXED this time, and the exact offset the kernel decided to load
it this time around) that will put the same code/data in exactly the
same place in memory (relocated and all) without blowing up your
process. In our specific implementation, it is mainly about rodata
(public keys) rather than executable code, but the same applies; for
us, it is more about rigging binaries: the attacker may not be
interested in hijacking the whole process, but just nop'ing out some
code that makes the process behave more to his liking.

>> The 'interface' we use is a LSM .ko which registers handlers for
>> mmap() and mprotect() that fail the respective invocations if the
>> passed arguments do not adhere to the policy.
>
> i'm guessing again that their LSM tries to tackle the above described
> scenarios except we don't know if this LSM will ever become public,
> whether/how other LSMs will acquire the same capabilities and why it's
> not mentioned in the PROT_FINAL submission that by itself this feature
> doesn't increase security. i'm also wondering what kind of policy can
> allow ld.so to load a library but forbid it a second time, it doesn't
> seem compatible with real-life cases (think dynamically loaded and
> unloaded plugins), not to mention the control of anonymous mappings.
>

The LSM encapsulates the policy, and relies on the PROT_FINAL feature.
The fact that the policy can impose the use of PROT_FINAL in
particular cases makes the implementation of the policy potentially
much simpler than that of PaX MPROTECT (but not necessarily as
secure).

However, let's decide first whether there is a point to having some
control over the VM_MAY* flags directly. If yes, then the patch makes
sense, otherwise it doesn't. How policies may be built on top of that
is part of another debate.

> last but not least, just saw this from Ard while not on CC:
>
>> ptrace() doesn't care whether or not the process itself can write to
>> its .text segment.
>
> ptrace cares about VM_MAYWRITE which PROT_FINAL can take away (under
> PaX MPROTECT'ed processes cannot be debugged with sw breakpoints).
>

My bad: I spent some time looking at access_process_vm() but could not
find any references to the vma permissions.

>> Could we at least agree on the fundamental notion that the special
>> powers the loader has to modify .text and .rodata sections are hardly
>> ever needed by the programs themselves? In that sense, this is similar
>> to dropping root privileges when not required anymore, and that is
>> typically recognized as a sensible idea.
>
> the difference is that the uid is a process-wide attribute, whereas
> PROT_FINAL isn't, unlike PaX's MPROTECT. in other words, dropping root
> is irreversible but PROT_FINAL isn't, one just has to create an entirely
> new mapping to acquire the access rights that PROT_FINAL was supposed to
> prevent (again, all this modulo an LSM and policies).
>

There remains a fundamental difference between the ability to
manipulate existing mappings and creating entirely new ones.
Especially when trying to manipulate GOT/PLT or vtable entries or
tweak the behavior of a program in other subtle ways, mmap()'ing the
same file again is just not going to cut it.

Regards,
Ard.
