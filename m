Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2ARU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:26:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2ARU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:26:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
References: <20120116183730.GB21112@redhat.com> <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
 <20120117164523.GA17070@redhat.com> <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
 <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
 <20120117170512.GB17070@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 12:26:17 -0800
X-Google-Sender-Auth: XAcnKrY-7TgL-yu3DPjmqflAc2U
Message-ID: <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Indan Zupancic <indan@nul.nu>, "H. Peter Anvin" <hpa@zytor.com>
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
Content-Type: multipart/mixed; boundary=0016e6dd9912ed1e9704b6d34341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dd9912ed1e9704b6d34341
Content-Type: text/plain; charset=ISO-8859-1

Added Peter to the cc, since this is now about some x86-specific
things. Ingo was already cc'd earlier.

On Wed, Jan 18, 2012 at 11:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Using the high bits of 'eflags' might work. Hopefully nobody tests
> that. IOW, something like the attached might work. It just sets bit#32
> in eflags if the system call is a compat call.

So that description was bogus, it was what my original patch did, but
not the one I actually sent out (Peter - you can find it on lkml,
although the description below is probably sufficient for you to
understand what it does, or the obvious nature of the attached patch
for strace).

The one I sent out *unconditionally* sets one bit in the high bits of
the returned value of the eflags register from ptrace(), very much on
purpose. That way you can unambiguously see whether it's an old kernel
(bits clear) or a new kernel that supports the feature. On a new
kernel, bit #32 of eflags will be set for a native 64-bit system call,
and bit #33 will be set for a compat system call.

And some testing says that it works. In particular, I have a patch to
strace-4.6 that is able to correctly decode my mixed-case binary that
uses both the compat system call and the native system calls from
64-bit long mode. Also, it looks like gdb ignores the high bits of
eflags, since it "knows" that eflags is just a 32-bit register even in
64-bit mode, so the fact that we set some random bits in there doesn't
end up being noisy for at least one debugger.

HOWEVER. I'm not going to guarantee that this is the right approach.
It seems to work, and it clearly gives people real information, but
whether this is the best way to do things or not is open.

The reason I picked 'eflags' was that it

 (a) was easy from an implementation standpoint, since we already have
to handle reading of eflags specially in ptrace (we have to fake out
the resume bit)

 (b) it "kind of" makes sense to make high bits be "system flags",
with low bits being "cpu flags", so it fits at least *some* kind of
conceptual model.

 (c) the other sane places to put it (high bits of CS and/or ORIG_AX)
were being used and compared as 64-bit values at least by strace.
Whether eflags works for all users, I have no idea, but generally you
would never compare eflags for one particular value - you might check
individual bits in eflags, but hopefully setting a few new bits should
not be something that any legacy user would ever really notice.

So there are reasons to think that my patch is sane, but...

Here's the strace patch, so people can look. I didn't even test it on
an old kernel, but the fallback case to the old behavior looks
trivial.

Comments?

                     Linus

--0016e6dd9912ed1e9704b6d34341
Content-Type: text/x-patch; charset=US-ASCII; name="strace.diff"
Content-Disposition: attachment; filename="strace.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxksvvwp1

IHN5c2NhbGwuYyB8ICAgMjEgKysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQs
IDE5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc3lzY2FsbC5j
IGIvc3lzY2FsbC5jCmluZGV4IGU2NmFjMGE5NTU4Mi4uZWRkOWNiODA0MzE4IDEwMDY0NAotLS0g
YS9zeXNjYWxsLmMKKysrIGIvc3lzY2FsbC5jCkBAIC05MDEsMTQgKzkwMSwzMSBAQCBnZXRfc2Nu
byhzdHJ1Y3QgdGNiICp0Y3ApCiAJCWxvbmcgdmFsOwogCQlpbnQgcGlkID0gdGNwLT5waWQ7CiAK
KwkJLyogQ2hlY2sgdGhlIGhpZ2ggYml0cyBvZiBlZmxhZ3MgZm9yIHByb2Nlc3NvciBtb2RlICov
CisJCWlmICh1cGVlayh0Y3AsIDgqRUZMQUdTLCAmdmFsKSA8IDApCisJCQlyZXR1cm4gLTE7CisJ
CXZhbCA+Pj0gMzI7CiAJCS8qIENoZWNrIENTIHJlZ2lzdGVyIHZhbHVlLiBPbiB4ODYtNjQgbGlu
dXggaXQgaXM6CiAJCSAqIAkweDMzCWZvciBsb25nIG1vZGUgKDY0IGJpdCkKIAkJICogCTB4MjMJ
Zm9yIGNvbXBhdGliaWxpdHkgbW9kZSAoMzIgYml0KQogCQkgKiBJdCB0YWtlcyBvbmx5IG9uZSBw
dHJhY2UgYW5kIHRodXMgZG9lc24ndCBuZWVkCiAJCSAqIHRvIGJlIGNhY2hlZC4KIAkJICovCi0J
CWlmICh1cGVlayh0Y3AsIDgqQ1MsICZ2YWwpIDwgMCkKLQkJCXJldHVybiAtMTsKKwkJc3dpdGNo
ICh2YWwgJiAzKSB7CisJCWNhc2UgMDoKKwkJCS8qIExlZ2FjdSBjYXNlOiBjaGVjayBDUyAqLwor
CQkJaWYgKHVwZWVrKHRjcCwgOCpDUywgJnZhbCkgPCAwKQorCQkJCXJldHVybiAtMTsKKwkJCWJy
ZWFrOworCQljYXNlIDE6CisJCQkvKiAiTG9uZyBtb2RlIiB2YWx1ZSAqLworCQkJdmFsID0gMHgz
MzsKKwkJCWJyZWFrOworCQljYXNlIDI6CisJCQkvKiBDb21wYXRpYmlsaXR5IG1vZGUgKi8KKwkJ
CXZhbCA9IDB4MjM7CisJCQlicmVhazsKKwkJfQogCQlzd2l0Y2ggKHZhbCkgewogCQkJY2FzZSAw
eDIzOiBjdXJycGVycyA9IDE7IGJyZWFrOwogCQkJY2FzZSAweDMzOiBjdXJycGVycyA9IDA7IGJy
ZWFrOwo=
--0016e6dd9912ed1e9704b6d34341--
