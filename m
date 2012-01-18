Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2ARTcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:32:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33733 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2ARTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 11:31:53 -0800
X-Google-Sender-Auth: ECp0B7NaPajKx-NXRuC4XWBS29g
Message-ID: <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Indan Zupancic <indan@nul.nu>
Cc: Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: multipart/mixed; boundary=f46d041826943c17c504b6d2817f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041826943c17c504b6d2817f
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 18, 2012 at 5:12 AM, Indan Zupancic <indan@nul.nu> wrote:
>
> So there is this gap and there is no good way to handle it at all for
> user space? And even if it's fixed in the kernel, that won't help with
> older kernels, so it will stay a problem for a while.

Correct.

> Can this int 0x80 trick be blocked for ptraced task (preferably always),
> pretty please?

Nope. Not that I can tell. The "unable to read $pc-2" is a hardware
feature, and we cannot stop users from running the "int 0x80" code.
The only way to block it is to simply not enable the 32-bit
compatibility mode at all, at which point the "int 0x80" interface
simply doesn't exist.

And sure, we could do something in the kernel (like saying that you
cannot do "int 0x80" from 64-bit code by explicitly testing in the
ia32_syscall function), but that has the same "even if it's fixed in
the kernel" issue.

You can test this feature out with a test-program something like this:

  #include <errno.h>
  #include <stdlib.h>
  #include <signal.h>

  #define _GNU_SOURCE
  #include <unistd.h>
  #include <sys/syscall.h>

  void handler(int sig)
  {
	printf("SIGWINCH\n");
  }

  int main(unsigned int argc, char **argv)
  {
	signal(SIGWINCH, handler);
	asm("int $0x80": :"a" (29));	/* sys_pause - 32-bit */
	syscall(34);	/* sys_pause - 64-bit */
  }

which does two "pause()" system calls from 64-bit mode, the first one
using the legacy system call interface.

At least "strace" gets really confused, and will show the first one as

   shmget(0x1c, 140734112566944, 0)        = ? ERESTARTNOHAND (To be restarted)

because it assumes that in 64-bit mode, system call number 29 means
"shmget". It doesn't even look at $pc-2, which (since this code
doesn't try to obfuscate it) would have worked in this case.

I actually checked the strace source code. It has

  #  if 0
                /* This version analyzes the opcode of a syscall instruction.
                 * (int 0x80 on i386 vs. syscall on x86-64)
                 * It works, but is too complicated.
                 */
                unsigned long val, rip, i;

                if (upeek(tcp, 8*RIP, &rip) < 0)
                        perror("upeek(RIP)");

                /* sizeof(syscall) == sizeof(int 0x80) == 2 */
                rip -= 2;
                errno = 0;
              ...

so there is code there that could make it work, but it's #ifdef'ed
out. The actually used code just does

                /* Check CS register value. On x86-64 linux it is:
                 *      0x33    for long mode (64 bit)
                 *      0x23    for compatibility mode (32 bit)
                 * It takes only one ptrace and thus doesn't need
                 * to be cached.
                 */
                if (upeek(tcp, 8*CS, &val) < 0)
                        return -1;
                switch (val) {
                        case 0x23: currpers = 1; break;
                        case 0x33: currpers = 0; break;

which is the reasonable and obvious approach.

I'm looking at "struct user_regs_struct" and there really isn't any
non-architected state there outside of "high bits".

There are high bits that we can hide things in outside of orig_ax - we
do have 64 bits for "cs" for example - but it all boils down to the
same issue: we *will* break something that thinks it knows the details
of this. The advantage of "orig_eax" would be that at least it makes
conceptual sense there.

Using the high bits of 'eflags' might work. Hopefully nobody tests
that. IOW, something like the attached might work. It just sets bit#32
in eflags if the system call is a compat call.

With that, ptrace would at least be able to tell (assuming a new
kernel, of course - it would still need to have the "look at cs" as a
fallback) if it's a compat call or not, but it could do something like

   mode = (eflags >> 32) & 3;
   switch (mode) {
   case 0:
          .. guess it from CS ..
   case 1:
           64-bit
   case 2:
            32-bit
   default:
            Oddity.
   }

or something like that. The idea being that you can also see from
eflags whether the new feature is supported or not.

THIS IS TOTALLY UNTESTED!

                      Linus

--f46d041826943c17c504b6d2817f
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxkqy3cj0

IGFyY2gveDg2L2tlcm5lbC9wdHJhY2UuYyB8ICAgIDggKysrKysrKy0KIDEgZmlsZXMgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2tlcm5lbC9wdHJhY2UuYyBiL2FyY2gveDg2L2tlcm5lbC9wdHJhY2UuYwppbmRleCA1MDI2NzM4
NmI3NjYuLmU3YjAxOWNkODhkMyAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3B0cmFjZS5j
CisrKyBiL2FyY2gveDg2L2tlcm5lbC9wdHJhY2UuYwpAQCAtMzUzLDYgKzM1Myw3IEBAIHN0YXRp
YyBpbnQgc2V0X3NlZ21lbnRfcmVnKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywKIAogc3RhdGlj
IHVuc2lnbmVkIGxvbmcgZ2V0X2ZsYWdzKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykKIHsKKwlp
bnQgYml0ID0gMzI7CiAJdW5zaWduZWQgbG9uZyByZXR2YWwgPSB0YXNrX3B0X3JlZ3ModGFzaykt
PmZsYWdzOwogCiAJLyoKQEAgLTM2MSw3ICszNjIsMTIgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcg
Z2V0X2ZsYWdzKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykKIAlpZiAodGVzdF90c2tfdGhyZWFk
X2ZsYWcodGFzaywgVElGX0ZPUkNFRF9URikpCiAJCXJldHZhbCAmPSB+WDg2X0VGTEFHU19URjsK
IAotCXJldHVybiByZXR2YWw7CisjaWZkZWYgQ09ORklHX0lBMzJfRU1VTEFUSU9OCisJLyogU2V0
IGJpdCAzMiBmb3IgNjQtYml0IHN5c3RlbSBjYWxscywgYml0IDMzIGZvciBjb21wYXQgc3lzdGVt
IGNhbGxzICovCisJYml0ICs9ICh0YXNrX3RocmVhZF9pbmZvKHRhc2spLT5zdGF0dXMgJiBUU19D
T01QQVQpIC8gVFNfQ09NUEFUOworI2VuZGlmCisKKwlyZXR1cm4gcmV0dmFsIHwgKDF1bCA8PCBi
aXQpOwogfQogCiBzdGF0aWMgaW50IHNldF9mbGFncyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ss
IHVuc2lnbmVkIGxvbmcgdmFsdWUpCg==
--f46d041826943c17c504b6d2817f--
