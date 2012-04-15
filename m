Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2DOCEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 22:04:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42031 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2DOCEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 22:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120414235238.GA11131@redhat.com>
References: <20120414235238.GA11131@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 19:03:44 -0700
X-Google-Sender-Auth: _NiZ3_lnTOg1p-YH6VPxZZXSQiI
Message-ID: <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com>
Subject: Re: ptrace && fpu_lazy_restore
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5b7aec084d304bdae1ef4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b7aec084d304bdae1ef4
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Apr 14, 2012 at 4:52 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> But I am not sure about the fix, and in any case I need more time
> to read this new code.

Oh, the fix is obviously correct. Yes, when we write to the FPU state
area, we need to invalidate the cached copy in the FPU itself.

It used to be that you could never have cached FPU contents unless you
owned the CPU (well, not strictly true - we used to do *really* lazy
FPU save/restone long long long ago in the pre-SMP days too), so this
bug is new with the lazy restore.

The only part I don't like about it is how hacky the location is. It
turns out that if the process *itself* does a "init_fpu()" call, then
the call to "unlazy_fpu()" will do the right thing and invalidate the
FPU state by setting fpu_owner_task to zero. But when we're ptracing
and doing an "init_fpu()" for somebody else, we'll skip that all,
because you can only really unlazy_fpu() yourself.

But that means that "init_fpu()" acts subtly differently depending on
whether you call it on yourself, or on another process.

So I actually think that I would prefer the patch that invalidates the
FPU caches more aggressively. Sure, we don't really *need* to
invalidate if we're just reading, but I'd almost prefer to just have
it done once in "init_fpu()".

The only case where we care about the FPU caches remaining is actually
the nice normal "we just switched tasks through normal scheduling".
Any path that calls "init_fpu()" is special enough that I think we
should just make sure the FPU state is all in memory. Hmm?

So I think I'd prefer the attached (UNTESTED!) oneliner instead.

If that works fine for people, how about sending it back to me with a
commit log and sign-off? I don't want to get credit for this patch
that is just a "let's do it in a different place" version of yours.

                             Linus

--001636c5b7aec084d304bdae1ef4
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h11galb00

IGFyY2gveDg2L2tlcm5lbC9pMzg3LmMgfCAgICAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9pMzg3LmMgYi9hcmNoL3g4Ni9r
ZXJuZWwvaTM4Ny5jCmluZGV4IDc3MzRiY2JiNWEzYS4uMmQ2ZTY0OThjMTc2IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvaTM4Ny5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9pMzg3LmMKQEAg
LTIzNSw2ICsyMzUsNyBAQCBpbnQgaW5pdF9mcHUoc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiAJ
aWYgKHRza191c2VkX21hdGgodHNrKSkgewogCQlpZiAoSEFWRV9IV0ZQICYmIHRzayA9PSBjdXJy
ZW50KQogCQkJdW5sYXp5X2ZwdSh0c2spOworCQl0c2stPnRocmVhZC5mcHUubGFzdF9jcHUgPSB+
MDsKIAkJcmV0dXJuIDA7CiAJfQogCg==
--001636c5b7aec084d304bdae1ef4--
