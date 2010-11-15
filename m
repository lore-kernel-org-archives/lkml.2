Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0KOQF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:05:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989Ab0KOQF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:05:56 -0500
MIME-Version: 1.0
In-Reply-To: <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
References: <4CD843DC.10106@gmail.com> <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box> <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 08:04:49 -0800
Message-ID: <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Content-Type: multipart/mixed; boundary=20cf301d3e72c4efd60495199a70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf301d3e72c4efd60495199a70
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 15, 2010 at 3:16 AM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> I don't see any problems on the assembly level. =A0i8k_smm is
> not inlined in this case and checks all 3 conditions.

If it really is related to gcc not understanding that "*regs" has
changed due to the memory being an automatic variable, and passing in
"regs" itself as a pointer to that automatic variable together with
the "memory" clobber not being sufficient, than I think it's the lack
of inlining that will automatically hide the bug.

(Side note: and I think this does show how much of a gcc bug it is not
to consider "memory" together with passing in a pointer to an asm to
always be a clobber).

Because if it isn't inlined, then "regs" will be seen a a real pointer
to some external memory (the caller) rather than being optimized to
just be the auto structure on the stack. Because *mem is auto only
within the context of the caller.

Which actually points to a possible simpler:
 - remove the "+m" since it adds too much register pressure
 - mark the i8k_smm() as "noinline" instead.

Quite frankly, I'd hate to add even more crud to that inline asm (to
save/restore the registers manually). It's already not the prettiest
thing around.

So does the attached patch work for everybody?

                             Linus

--20cf301d3e72c4efd60495199a70
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggjjm9k40

IGRyaXZlcnMvY2hhci9pOGsuYyB8ICAgIDYgKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaThr
LmMgYi9kcml2ZXJzL2NoYXIvaThrLmMKaW5kZXggZjA4NjNiZS4uMTAxMDExZSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9jaGFyL2k4ay5jCisrKyBiL2RyaXZlcnMvY2hhci9pOGsuYwpAQCAtMTE0LDcg
KzExNCw3IEBAIHN0YXRpYyBpbmxpbmUgY29uc3QgY2hhciAqaThrX2dldF9kbWlfZGF0YShpbnQg
ZmllbGQpCiAvKgogICogQ2FsbCB0aGUgU3lzdGVtIE1hbmFnZW1lbnQgTW9kZSBCSU9TLiBDb2Rl
IHByb3ZpZGVkIGJ5IEpvbmF0aGFuIEJ1enphcmQuCiAgKi8KLXN0YXRpYyBpbnQgaThrX3NtbShz
dHJ1Y3Qgc21tX3JlZ3MgKnJlZ3MpCitzdGF0aWMgbm9pbmxpbmUgaW50IGk4a19zbW0oc3RydWN0
IHNtbV9yZWdzICpyZWdzKQogewogCWludCByYzsKIAlpbnQgZWF4ID0gcmVncy0+ZWF4OwpAQCAt
MTQyLDcgKzE0Miw3IEBAIHN0YXRpYyBpbnQgaThrX3NtbShzdHJ1Y3Qgc21tX3JlZ3MgKnJlZ3Mp
CiAJCSJsYWhmXG5cdCIKIAkJInNocmwgJDgsJSVlYXhcblx0IgogCQkiYW5kbCAkMSwlJWVheFxu
IgotCQk6Ij1hIihyYyksICIrbSIgKCpyZWdzKQorCQk6Ij1hIihyYykKIAkJOiAgICAiYSIocmVn
cykKIAkJOiAgICAiJWVieCIsICIlZWN4IiwgIiVlZHgiLCAiJWVzaSIsICIlZWRpIiwgIm1lbW9y
eSIpOwogI2Vsc2UKQEAgLTE2OCw3ICsxNjgsNyBAQCBzdGF0aWMgaW50IGk4a19zbW0oc3RydWN0
IHNtbV9yZWdzICpyZWdzKQogCSAgICAibGFoZlxuXHQiCiAJICAgICJzaHJsICQ4LCUlZWF4XG5c
dCIKIAkgICAgImFuZGwgJDEsJSVlYXhcbiIKLQkgICAgOiI9YSIocmMpLCAiK20iICgqcmVncykK
KwkgICAgOiI9YSIocmMpCiAJICAgIDogICAgImEiKHJlZ3MpCiAJICAgIDogICAgIiVlYngiLCAi
JWVjeCIsICIlZWR4IiwgIiVlc2kiLCAiJWVkaSIsICJtZW1vcnkiKTsKICNlbmRpZgo=
--20cf301d3e72c4efd60495199a70--
