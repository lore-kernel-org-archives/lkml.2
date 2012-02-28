Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2B1Sax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:30:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59836 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2B1Sav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:30:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.93 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4B9FFE.5050709@teksavvy.com>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
 <4F4B9FFE.5050709@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 10:30:30 -0800
X-Google-Sender-Auth: SbIPfQwbTjf_ZQWpyHmQsaIcYow
Message-ID: <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
Subject: Re: Linux 3.3-rc5
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6dbde5722267104ba0a6dc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dbde5722267104ba0a6dc2
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 27, 2012 at 7:23 AM, Mark Lord <kernel@teksavvy.com> wrote:
>
> The i8k driver is still b0rked for COMPAT use in linux-3.2.xx,
> and I don't think my patch got picked up by anyone for 3.3 yet:

I really don't like your patch.

It basically compares the ioctl argument by dropping almost all bits.
That looks completely wrong. If I read the patch correctly, it will
now match ioctl's that have *nothing* to do with the i8k ioctls, that
just happen to have a few bits in common.

I also think that your explanation is wrong. The problem is not the
use of _IOR() at all, the problem is that the data structure given
*to* the _IOR() macro is complete grabage. For example:

  #define I8K_GET_SPEED           _IOWR('i', 0x85, size_t)

that "size_t" there is just crap. It's wrong. The ioctl doesn't write
a size_t (which is different sizes on 32-bit and 64-bit), it actually
writes an "int" (which happens to be the same size in both compat and
non-compat).

So the 64-bit code - totally incorrectly - has been compiled with an
ioctl number that implies a 64-bit argument.

EVERY SINGLE IOCTL that is defined for the i8k driver is crap. There
are two that were "int", but they are marked as "broken" because the
data structure *they* write isn't actually "int". But those two are
the ones that just happen to work in both 32-bit and 64-bit mode,
because at least the size of the (incorrect) data structure is the
same.

The ones that have "size_t" aren't marked broken, but those are the
*really* broken ones due to the wrong data structure choice that has a
size that now is different in 32-bit and 64-bit mode.

Quite frankly, I think the right solution is to fix the kernel
interface to the right type (int) that is the same. But because we
don't want to change the user interface, let's make the kernel
*accept* the 8-byte entity and just change it into a 4-byte size, and
leave the user-space visible ioctl numbers the same broken crap - it's
not like the other ioctl numbers had the right size *either*...

IOW, have something like the attached in the ioctl handler (and then
we need to also add the compat handler, as in your patch).

Does this (with your compat_ioctl wrapper addition) also work for you?

                        Linus

--0016e6dbde5722267104ba0a6dc2
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gz79ue4v1

IGRyaXZlcnMvY2hhci9pOGsuYyAgfCAgICA0ICsrKysKIGluY2x1ZGUvbGludXgvaThrLmggfCAg
IDIyICsrKysrKysrKysrKysrKystLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9u
cygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIvaThrLmMgYi9k
cml2ZXJzL2NoYXIvaThrLmMKaW5kZXggNDBjYzBjZjJkZWQ2Li5lNGIxNjEzNTQzZWQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvY2hhci9pOGsuYworKysgYi9kcml2ZXJzL2NoYXIvaThrLmMKQEAgLTMy
Niw2ICszMjYsMTAgQEAgaThrX2lvY3RsX3VubG9ja2VkKHN0cnVjdCBmaWxlICpmcCwgdW5zaWdu
ZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJaWYgKCFhcmdwKQogCQlyZXR1cm4gLUVJ
TlZBTDsKIAorCS8qIFdlIGhhZCBzb21lIGJhZCA2NC1iaXQgY29uZnVzaW9uICovCisJaWYgKChh
cmcgPj4gX0lPQ19TSVpFU0hJRlQpICYgX0lPQ19TSVpFTUFTSykgPT0gOCkKKwkJYXJnIC09IDQg
PDwgX0lPQ19TSVpFU0hJRlQ7CisKIAlzd2l0Y2ggKGNtZCkgewogCWNhc2UgSThLX0JJT1NfVkVS
U0lPTjoKIAkJdmFsID0gaThrX2dldF9iaW9zX3ZlcnNpb24oKTsKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvaThrLmggYi9pbmNsdWRlL2xpbnV4L2k4ay5oCmluZGV4IDFjNDViYTUwNTExNS4u
NjUwZjQwMTVjODljIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2k4ay5oCisrKyBiL2luY2x1
ZGUvbGludXgvaThrLmgKQEAgLTIwLDE0ICsyMCwyNCBAQAogI2RlZmluZSBJOEtfUFJPQwkJIi9w
cm9jL2k4ayIKICNkZWZpbmUgSThLX1BST0NfRk1UCQkiMS4wIgogCisvKgorICogRm9yIGh5c3Rl
cmljYWwgcmFpc2lucyB3ZSBleHBvc2UgdGhlIHdyb25nIHNpemUgdG8gdXNlciBzcGFjZQorICog
aW4gdGhlIGlvY3RsIG51bWJlcmluZy4gVGhlIGFjdHVhbCByZWFsIGRhdGEgc2l6ZSBpcyAiaW50
Ii4KKyAqLworI2lmZGVmIF9fS0VSTkVMX18KKyNkZWZpbmUgYm9ya2VkX2k4a19hcmcgaW50Cisj
ZWxzZQorI2RlZmluZSBib3JrZWRfaThrX2FyZyBzaXplX3QKKyNlbmRpZgorCiAjZGVmaW5lIEk4
S19CSU9TX1ZFUlNJT04JX0lPUiAoJ2knLCAweDgwLCBpbnQpCS8qIGJyb2tlbjogbWVhbnQgNCBi
eXRlcyAqLwogI2RlZmluZSBJOEtfTUFDSElORV9JRAkJX0lPUiAoJ2knLCAweDgxLCBpbnQpCS8q
IGJyb2tlbjogbWVhbnQgMTYgYnl0ZXMgKi8KLSNkZWZpbmUgSThLX1BPV0VSX1NUQVRVUwlfSU9S
ICgnaScsIDB4ODIsIHNpemVfdCkKLSNkZWZpbmUgSThLX0ZOX1NUQVRVUwkJX0lPUiAoJ2knLCAw
eDgzLCBzaXplX3QpCi0jZGVmaW5lIEk4S19HRVRfVEVNUAkJX0lPUiAoJ2knLCAweDg0LCBzaXpl
X3QpCi0jZGVmaW5lIEk4S19HRVRfU1BFRUQJCV9JT1dSKCdpJywgMHg4NSwgc2l6ZV90KQotI2Rl
ZmluZSBJOEtfR0VUX0ZBTgkJX0lPV1IoJ2knLCAweDg2LCBzaXplX3QpCi0jZGVmaW5lIEk4S19T
RVRfRkFOCQlfSU9XUignaScsIDB4ODcsIHNpemVfdCkKKyNkZWZpbmUgSThLX1BPV0VSX1NUQVRV
UwlfSU9SICgnaScsIDB4ODIsIGJvcmtlZF9pOGtfYXJnKQorI2RlZmluZSBJOEtfRk5fU1RBVFVT
CQlfSU9SICgnaScsIDB4ODMsIGJvcmtlZF9pOGtfYXJnKQorI2RlZmluZSBJOEtfR0VUX1RFTVAJ
CV9JT1IgKCdpJywgMHg4NCwgYm9ya2VkX2k4a19hcmcpCisjZGVmaW5lIEk4S19HRVRfU1BFRUQJ
CV9JT1dSKCdpJywgMHg4NSwgYm9ya2VkX2k4a19hcmcpCisjZGVmaW5lIEk4S19HRVRfRkFOCQlf
SU9XUignaScsIDB4ODYsIGJvcmtlZF9pOGtfYXJnKQorI2RlZmluZSBJOEtfU0VUX0ZBTgkJX0lP
V1IoJ2knLCAweDg3LCBib3JrZWRfaThrX2FyZykKIAogI2RlZmluZSBJOEtfRkFOX0xFRlQJCTEK
ICNkZWZpbmUgSThLX0ZBTl9SSUdIVAkJMAo=
--0016e6dbde5722267104ba0a6dc2--
