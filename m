Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1EVV5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 17:57:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab1EVV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 17:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105221720040.2065@natty-nar>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 May 2011 14:56:40 -0700
Message-ID: <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
To: Parag Warudkar <parag.lkml@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec52be4ab30191c04a3e46f11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec52be4ab30191c04a3e46f11
Content-Type: text/plain; charset=ISO-8859-1

On Sun, May 22, 2011 at 2:36 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> So on an otherwise working system, with today's git resume from suspend
> goes awry. Distro kernel 2.6.38-8 has no issues and
> CONFIG_DEBUG_SET_MODULE_RONX=y is set for both kernels.
>
> 1) setup_disablecpuid seems to result in executing a NX page -
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [ 2762.672126] BUG: unable to handle kernel paging request at
> ffffffff81aaf74d
> [ 2762.672131] IP: [<ffffffff81aaf74d>] setup_disablecpuid+0x40/0x40

Hmm. The "Code: " line is just full of complete garbage, so I think
the real issue is that you really are trying to execute data.

And that in turn seems to be because "setup_disablecpuid()" has
actually been free'd, because it is marked as __init.

Which is fine at the initial bootup, but not so fine at resume time,
since it was free'd long long ago by then.

And it definitely shouldn' t be called at resume time. There's
something wrong there. That call trace is odd:

  Call Trace:
   [<ffffffff8148a119>] ? identify_cpu+0xd8/0x2d8
   [<ffffffff8148a32d>] identify_secondary_cpu+0x14/0x1b
   [<ffffffff8148bf0f>] smp_store_cpu_info+0x3c/0x3e
   [<ffffffff8148c2ef>] start_secondary+0xf7/0x1d2

because none of those should be calling "setup_disablecpuid()" at all.

Hmm. In fact, RIP is "setup_disablecpuid+0x40/0x40", ie it is one past
the _end_ of setup_disablecpuid.

I suspect that is actually "setup_smep()" that got called, an dthat
there was some garbage data in there that caused it to jump back a
bit.

Does the attached patch fix it?

> 2) Synaptics touchpad which work fine with two fingure gestures etc before
> resume - goes into ps2 mode after resume -
> [ 2783.323947] Synaptics claims to have extended capabilities, but I'm not able to read them.
> [ 2783.774740] Synaptics hardware appears to be different: id(149271-149271), model(114865-114865), caps(d04733-d04733), ext(a40000-0).
> [ 2788.880575] Unable to query Synaptics hardware.

Hmm. I have no idea about this one. Dmitry?

                       Linus

--bcaec52be4ab30191c04a3e46f11
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go0ivwkn0

IGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQs
IDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L2NvbW1vbi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYwppbmRleCBj
YmM3MGEyNzQzMGMuLmI5M2RhNWQ1ZjVhMiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2Nw
dS9jb21tb24uYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jCkBAIC0yNjIsNyAr
MjYyLDcgQEAgc3RhdGljIF9faW5pdCBpbnQgc2V0dXBfZGlzYWJsZV9zbWVwKGNoYXIgKmFyZykK
IH0KIF9fc2V0dXAoIm5vc21lcCIsIHNldHVwX2Rpc2FibGVfc21lcCk7CiAKLXN0YXRpYyBfX2lu
aXQgdm9pZCBzZXR1cF9zbWVwKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKK3N0YXRpYyBfX2NwdWlu
aXQgdm9pZCBzZXR1cF9zbWVwKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIHsKIAlpZiAoY3B1X2hh
cyhjLCBYODZfRkVBVFVSRV9TTUVQKSkgewogCQlpZiAodW5saWtlbHkoZGlzYWJsZV9zbWVwKSkg
ewo=
--bcaec52be4ab30191c04a3e46f11--
