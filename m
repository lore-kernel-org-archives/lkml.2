Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab1DLVrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:47:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673Ab1DLVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
 <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com>
 <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com> <20110412192059.GA14360@redhat.com>
 <BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com> <BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
 <BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com> <BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 14:46:48 -0700
Message-ID: <BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: multipart/mixed; boundary=001636920a1a3f278404a0bfa2e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636920a1a3f278404a0bfa2e4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2011 at 1:56 PM, Robert =C5=9Awi=C4=99cki <robert@swiecki.n=
et> wrote:
>
> Ok, just to update you with what I'm currently doing:
>
> I'm testing now with 2.6.39-rc3 - according to
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.39-rc3
> it has vma_to_resize patch included
> (982134ba62618c2d69fbbbd166d0a11ee3b7e3d8) - I applied the latest
> Linus' patch for sys_mlock (the one patching memory.c and mlock.c),
> disabled the sys_madvise in the fuzzer, and now I got the following
> (full kdb dump attached)

Ok, that's different from the apparent livelock.

Except it once again is one of the BUG_ON's in vma_prio_tree_add() -
and again, your kgdb thing has corrupted the bug information.

Can you make a bug-report to the kgdb people? It's annoying as hell
that all the *critical* bug information that the kernel prints out
apparently gets totally lost when you attach with the debugger. It's
not an Oops, it should have that nice BUG: together with filename and
line number.

> <d>Pid: 18598, comm: iknowthis Not tainted 2.6.39-rc3 #1<c> Dell Inc.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Precision WorkStation 39=
0 =C2=A0 =C2=A0<c>/0GH911<c>
> <d>RIP: 0010:[<ffffffff8116c842>] =C2=A0[<ffffffff8116c842>] vma_prio_tre=
e_add+0xc2/0xd0

Code disassembly shows:

   0:	58                   	pop    %rax
   1:	48 89 7e 68          	mov    %rdi,0x68(%rsi)
   5:	c9                   	leaveq
   6:	c3                   	retq
   7:	66 90                	xchg   %ax,%ax
   9:	48 8b 56 50          	mov    0x50(%rsi),%rdx
   d:	48 8d 47 50          	lea    0x50(%rdi),%rax
  11:	48 89 42 08          	mov    %rax,0x8(%rdx)
  15:	48 89 57 50          	mov    %rdx,0x50(%rdi)
  19:	48 8d 56 50          	lea    0x50(%rsi),%rdx
  1d:	48 89 57 58          	mov    %rdx,0x58(%rdi)
  21:	48 89 46 50          	mov    %rax,0x50(%rsi)
  25:	c9                   	leaveq
  26:	c3                   	retq
  27:*	0f 0b                	ud2         <-- trapping instruction
  29:	eb fe                	jmp    0x29
  2b:*	0f 0b                	ud2         <-- trapping instruction
  2d:	eb fe                	jmp    0x2d
  2f:	eb 08                	jmp    0x39

and scripts/decodecode is wrong, it's the _second_ of the two ud2's
that traps, as shown by the Code: line.

But whether that is the first or the second in the source code, who
knows? Gcc may have re-ordered things completely, and kdb has thrown
away the information that the kernel should have printed out.

Anyway, it looks _very_ much exactly like the old mremap() issue. But
if you are running -rc3, then you already have commit 42933bac11e8 in
your tree, so maybe there is some other way to trigger a vm_pgoff
overflow.

You've lost Hugh's patch that did the vma dump instead of having the
BUG_ON(). Can you try that one? And once more, I think that if you had
CONFIG_OPTIMIZE_SIZE on, then I think gcc wouldn't re-order the basic
blocks, and the BUG_ON() info would be easier to track.

> Call Trace:
> =C2=A0[<ffffffff8116c9a1>] vma_prio_tree_insert+0x41/0x60
> =C2=A0[<ffffffff8117cb8c>] __vma_link_file+0x4c/0x90
> =C2=A0[<ffffffff8117d568>] vma_adjust+0xe8/0x570
> =C2=A0[<ffffffff8117db31>] __split_vma+0x141/0x280
> =C2=A0[<ffffffff8117dc95>] split_vma+0x25/0x30
> =C2=A0[<ffffffff8117c1a1>] mlock_fixup+0x171/0x1c0
> =C2=A0[<ffffffff8117c529>] do_mlock+0xc9/0x100
> =C2=A0[<ffffffff8117c6d7>] sys_mlock+0xe7/0x130
> =C2=A0[<ffffffff82284e03>] ia32_do_call+0x13/0x13

Hmm. mlock() itself should not be causing any pgoff expansion.

I wonder if this is related to that whole stack expansion thing (you
clearly are hitting the stack vma judging by the other bug you found),
and we have a pgoff underflow when expanding the stack?

Attached patch for your enjoyment. COMPLETELY UNTESTED, as usual.

Guys, can you think of any other thing that might expand a mapping?
Rather than find them one-by-one as Robert plays with his fuzzer?

                      Linus

--001636920a1a3f278404a0bfa2e4
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmfd03sc1

IG1tL21tYXAuYyB8ICAgMTMgKysrKysrKystLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbW0vbW1hcC5jIGIvbW0vbW1h
cC5jCmluZGV4IDJlYzhlYjVhOWNkZC4uOGMwNWU1YjQzYjY5IDEwMDY0NAotLS0gYS9tbS9tbWFw
LmMKKysrIGIvbW0vbW1hcC5jCkBAIC0xODE0LDExICsxODE0LDE0IEBAIHN0YXRpYyBpbnQgZXhw
YW5kX2Rvd253YXJkcyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwKIAkJc2l6ZSA9IHZtYS0+
dm1fZW5kIC0gYWRkcmVzczsKIAkJZ3JvdyA9ICh2bWEtPnZtX3N0YXJ0IC0gYWRkcmVzcykgPj4g
UEFHRV9TSElGVDsKIAotCQllcnJvciA9IGFjY3Rfc3RhY2tfZ3Jvd3RoKHZtYSwgc2l6ZSwgZ3Jv
dyk7Ci0JCWlmICghZXJyb3IpIHsKLQkJCXZtYS0+dm1fc3RhcnQgPSBhZGRyZXNzOwotCQkJdm1h
LT52bV9wZ29mZiAtPSBncm93OwotCQkJcGVyZl9ldmVudF9tbWFwKHZtYSk7CisJCWVycm9yID0g
LUVOT01FTTsKKwkJaWYgKGdyb3cgPD0gdm1hLT52bV9wZ29mZikgeworCQkJZXJyb3IgPSBhY2N0
X3N0YWNrX2dyb3d0aCh2bWEsIHNpemUsIGdyb3cpOworCQkJaWYgKCFlcnJvcikgeworCQkJCXZt
YS0+dm1fc3RhcnQgPSBhZGRyZXNzOworCQkJCXZtYS0+dm1fcGdvZmYgLT0gZ3JvdzsKKwkJCQlw
ZXJmX2V2ZW50X21tYXAodm1hKTsKKwkJCX0KIAkJfQogCX0KIAl2bWFfdW5sb2NrX2Fub25fdm1h
KHZtYSk7Cg==
--001636920a1a3f278404a0bfa2e4--
