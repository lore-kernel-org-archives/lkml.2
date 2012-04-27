Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2D0T4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:56:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57039 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2D0T4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:56:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120427.152404.2292425516870981391.davem@davemloft.net>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 12:56:20 -0700
X-Google-Sender-Auth: a1KUxpSWL6t1_D18v45n-OkEIfg
Message-ID: <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: David Miller <davem@davemloft.net>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Content-Type: multipart/mixed; boundary=0016e6d99d1bd8dbc304beae8009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d99d1bd8dbc304beae8009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
>
> If you can pull that off, it would certainly work and be the best
> solution.
>
> BTW, this has happened before, we had this same problem passing data
> over netlink sockets. =A0And since it's packetized already we had a
> slightly easier time dealing with it.

Ok, so here's a fairly quick hack.

NOTE! I haven't actually tested this, because I don't use autofs
(well, not knowingly - maybe I have a machine that actually does).

What it does is add a new "packetized" flag to pipes, which does two
simple things:
 - do not merge write data in pipe buffers when writing
 - when reading, consider a pipe buffer to be "spent" when any of the
data has been read

Of course, if you write more than PIPE_BUFFER bytes, the packetization
doesn't work, but hey, if you do that, it's your own damn problem.

Then, this just makes (for debugging!) autofs always write eight extra
bytes of garbage (NOTE NOTE NOTE! This will write uninitialized data,
so this is literally just for debugging this particular issue), so
that if the whole "kernel writes a few bytes extra" approach with pipe
packetization doesn't work, you would see it even on native 32-bit or
64-bit mode, without having to even test the special case of "32-bit
automount binary on a 64-bit kernel". So *anybody* who uses autofs can
test this patch and see if autofs still works for them despite the
extra padding on the write.

So note the "+8" in autofs_v5_packet_size(). It's there on purpose,
but it needs to be removed for actual final results if this works for
testing.

Comments? The patch looks fairly simple. The "packetized pipe" might
even be useful for other users and maybe we might want to expose it as
an actual pipe fcntl, but right now the only thing that sets that flag
is autofs.

Does this even work? I might well have missed some obvious thing, this
was put together pretty quickly, but I think the *concept* may be the
right approach to this whole mess.

(And yes, we could probably just pack the "struct pipe_inode_info"
better. We don't really need 32 bits for the pipe writer count etc.
But to make the patch simple, I just added a whole new bitfield, which
will just grow that silly structure).

                       Linus

--0016e6d99d1bd8dbc304beae8009
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1jnts5y0

IGZzL2F1dG9mczQvYXV0b2ZzX2kuaCAgICAgfCAgIDExICsrKysrKysrKysrCiBmcy9hdXRvZnM0
L2Rldi1pb2N0bC5jICAgIHwgICAgMiArLQogZnMvYXV0b2ZzNC9pbm9kZS5jICAgICAgICB8ICAg
IDIgKy0KIGZzL2F1dG9mczQvd2FpdHEuYyAgICAgICAgfCAgIDE0ICsrKysrKy0tLS0tLS0tCiBm
cy9waXBlLmMgICAgICAgICAgICAgICAgIHwgICAgNiArKystLS0KIGluY2x1ZGUvbGludXgvcGlw
ZV9mc19pLmggfCAgICAxICsKIDYgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMTMg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvYXV0b2ZzNC9hdXRvZnNfaS5oIGIvZnMvYXV0
b2ZzNC9hdXRvZnNfaS5oCmluZGV4IGViMWNjOTJjZDY3ZC4uZjg2NDJiOGExNzc5IDEwMDY0NAot
LS0gYS9mcy9hdXRvZnM0L2F1dG9mc19pLmgKKysrIGIvZnMvYXV0b2ZzNC9hdXRvZnNfaS5oCkBA
IC0zNCw2ICszNCw3IEBACiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4KICNpbmNsdWRlIDxsaW51
eC9tb3VudC5oPgogI2luY2x1ZGUgPGxpbnV4L25hbWVpLmg+CisjaW5jbHVkZSA8bGludXgvcGlw
ZV9mc19pLmg+CiAjaW5jbHVkZSA8YXNtL2N1cnJlbnQuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vz
cy5oPgogCkBAIC0yNzAsNiArMjcxLDE2IEBAIGludCBhdXRvZnM0X2ZpbGxfc3VwZXIoc3RydWN0
IHN1cGVyX2Jsb2NrICosIHZvaWQgKiwgaW50KTsKIHN0cnVjdCBhdXRvZnNfaW5mbyAqYXV0b2Zz
NF9uZXdfaW5vKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqKTsKIHZvaWQgYXV0b2ZzNF9jbGVhbl9p
bm8oc3RydWN0IGF1dG9mc19pbmZvICopOwogCitzdGF0aWMgaW5saW5lIGludCBhdXRvZnNfcHJl
cGFyZV9waXBlKHN0cnVjdCBmaWxlICpwaXBlKQoreworCWlmICghcGlwZS0+Zl9vcCB8fCAhcGlw
ZS0+Zl9vcC0+d3JpdGUpCisJCXJldHVybiAtRUlOVkFMOworCWlmICghcGlwZS0+Zl9kZW50cnkt
PmRfaW5vZGUtPmlfcGlwZSkKKwkJcmV0dXJuIC1FSU5WQUw7CisJcGlwZS0+Zl9kZW50cnktPmRf
aW5vZGUtPmlfcGlwZS0+cGFja2V0aXplZCA9IDE7CisJcmV0dXJuIDA7Cit9CisKIC8qIFF1ZXVl
IG1hbmFnZW1lbnQgZnVuY3Rpb25zICovCiAKIGludCBhdXRvZnM0X3dhaXQoc3RydWN0IGF1dG9m
c19zYl9pbmZvICosc3RydWN0IGRlbnRyeSAqLCBlbnVtIGF1dG9mc19ub3RpZnkpOwpkaWZmIC0t
Z2l0IGEvZnMvYXV0b2ZzNC9kZXYtaW9jdGwuYyBiL2ZzL2F1dG9mczQvZGV2LWlvY3RsLmMKaW5k
ZXggOWRhY2I4NTg2NzAxLi42MjU5ZTcxNDIwMzIgMTAwNjQ0Ci0tLSBhL2ZzL2F1dG9mczQvZGV2
LWlvY3RsLmMKKysrIGIvZnMvYXV0b2ZzNC9kZXYtaW9jdGwuYwpAQCAtMzc2LDcgKzM3Niw3IEBA
IHN0YXRpYyBpbnQgYXV0b2ZzX2Rldl9pb2N0bF9zZXRwaXBlZmQoc3RydWN0IGZpbGUgKmZwLAog
CQkJZXJyID0gLUVCQURGOwogCQkJZ290byBvdXQ7CiAJCX0KLQkJaWYgKCFwaXBlLT5mX29wIHx8
ICFwaXBlLT5mX29wLT53cml0ZSkgeworCQlpZiAoYXV0b2ZzX3ByZXBhcmVfcGlwZShwaXBlKSA8
IDApIHsKIAkJCWVyciA9IC1FUElQRTsKIAkJCWZwdXQocGlwZSk7CiAJCQlnb3RvIG91dDsKZGlm
ZiAtLWdpdCBhL2ZzL2F1dG9mczQvaW5vZGUuYyBiL2ZzL2F1dG9mczQvaW5vZGUuYwppbmRleCBk
OGRjMDAyZTljYzMuLmM1MjViNzRkZWVmZCAxMDA2NDQKLS0tIGEvZnMvYXV0b2ZzNC9pbm9kZS5j
CisrKyBiL2ZzL2F1dG9mczQvaW5vZGUuYwpAQCAtMjkyLDcgKzI5Miw3IEBAIGludCBhdXRvZnM0
X2ZpbGxfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzLCB2b2lkICpkYXRhLCBpbnQgc2lsZW50
KQogCQlwcmludGsoImF1dG9mczogY291bGQgbm90IG9wZW4gcGlwZSBmaWxlIGRlc2NyaXB0b3Jc
biIpOwogCQlnb3RvIGZhaWxfZHB1dDsKIAl9Ci0JaWYgKCFwaXBlLT5mX29wIHx8ICFwaXBlLT5m
X29wLT53cml0ZSkKKwlpZiAoYXV0b2ZzX3ByZXBhcmVfcGlwZShwaXBlKSA8IDApCiAJCWdvdG8g
ZmFpbF9mcHV0OwogCXNiaS0+cGlwZSA9IHBpcGU7CiAJc2JpLT5waXBlZmQgPSBwaXBlZmQ7CmRp
ZmYgLS1naXQgYS9mcy9hdXRvZnM0L3dhaXRxLmMgYi9mcy9hdXRvZnM0L3dhaXRxLmMKaW5kZXgg
OWMwOThkYjQzMzQ0Li41Y2U1MDI2MjAwYjkgMTAwNjQ0Ci0tLSBhL2ZzL2F1dG9mczQvd2FpdHEu
YworKysgYi9mcy9hdXRvZnM0L3dhaXRxLmMKQEAgLTk3LDE2ICs5NywxNCBAQCBzdGF0aWMgaW50
IGF1dG9mczRfd3JpdGUoc3RydWN0IGF1dG9mc19zYl9pbmZvICpzYmksCiAgKgogICogVGhlIHBh
Y2tldHMgYXJlIGlkZW50aWNhbCBvbiB4ODYtMzIgYW5kIHg4Ni02NCwgYnV0IGhhdmUgZGlmZmVy
ZW50CiAgKiBhbGlnbm1lbnQuIFdoaWNoIG1lYW5zIHRoYXQgJ3NpemVvZigpJyB3aWxsIGdpdmUg
ZGlmZmVyZW50IHJlc3VsdHMuCi0gKiBGaXggaXQgdXAgZm9yIHRoZSBjYXNlIG9mIHJ1bm5pbmcg
MzItYml0IHVzZXIgbW9kZSBvbiBhIDY0LWJpdCBrZXJuZWwuCisgKiBIb3dldmVyLCB3ZSBwYWNr
ZXRpemUgdGhlIHBpcGUsIHNvIGp1c3QgdXNlIHRoZSBiaWdnZXIgc2l6ZSwgdGhlCisgKiBwaXBl
IHJlYWQgd2lsbCBkaXNjYXJkIHRoZSByZXN0LgorICoKKyAqIFRoaXMgYWRkcyBvbiA4IGJ5dGVz
IG9mIGdhcmJhZ2UgRk9SIERFQlVHR0lORyBPTkxZIQogICovCi1zdGF0aWMgbm9pbmxpbmUgc2l6
ZV90IGF1dG9mc192NV9wYWNrZXRfc2l6ZShzdHJ1Y3QgYXV0b2ZzX3NiX2luZm8gKnNiaSkKK3N0
YXRpYyBpbmxpbmUgc2l6ZV90IGF1dG9mc192NV9wYWNrZXRfc2l6ZShzdHJ1Y3QgYXV0b2ZzX3Ni
X2luZm8gKnNiaSkKIHsKLQlzaXplX3QgcGt0c3ogPSBzaXplb2Yoc3RydWN0IGF1dG9mc192NV9w
YWNrZXQpOwotI2lmIGRlZmluZWQoQ09ORklHX1g4Nl82NCkgJiYgZGVmaW5lZChDT05GSUdfQ09N
UEFUKQotCWlmIChzYmktPmNvbXBhdF9kYWVtb24gPiAwKQotCQlwa3RzeiAtPSA0OwotI2VuZGlm
Ci0JcmV0dXJuIHBrdHN6OworCXJldHVybiBzaXplb2Yoc3RydWN0IGF1dG9mc192NV9wYWNrZXQp
Kzg7CiB9CiAKIHN0YXRpYyB2b2lkIGF1dG9mczRfbm90aWZ5X2RhZW1vbihzdHJ1Y3QgYXV0b2Zz
X3NiX2luZm8gKnNiaSwKZGlmZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3BpcGUuYwppbmRleCAy
NWZlYWEzZmFhYzAuLjc2ZmViZGZhZmNjMyAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisrKyBiL2Zz
L3BpcGUuYwpAQCAtNDA3LDcgKzQwNyw3IEBAIHJlZG86CiAJCQlyZXQgKz0gY2hhcnM7CiAJCQli
dWYtPm9mZnNldCArPSBjaGFyczsKIAkJCWJ1Zi0+bGVuIC09IGNoYXJzOwotCQkJaWYgKCFidWYt
PmxlbikgeworCQkJaWYgKCFidWYtPmxlbiB8fCBwaXBlLT5wYWNrZXRpemVkKSB7CiAJCQkJYnVm
LT5vcHMgPSBOVUxMOwogCQkJCW9wcy0+cmVsZWFzZShwaXBlLCBidWYpOwogCQkJCWN1cmJ1ZiA9
IChjdXJidWYgKyAxKSAmIChwaXBlLT5idWZmZXJzIC0gMSk7CkBAIC00MTYsNyArNDE2LDcgQEAg
cmVkbzoKIAkJCQlkb193YWtldXAgPSAxOwogCQkJfQogCQkJdG90YWxfbGVuIC09IGNoYXJzOwot
CQkJaWYgKCF0b3RhbF9sZW4pCisJCQlpZiAoIXRvdGFsX2xlbiB8fCBwaXBlLT5wYWNrZXRpemVk
KQogCQkJCWJyZWFrOwkvKiBjb21tb24gcGF0aDogcmVhZCBzdWNjZWVkZWQgKi8KIAkJfQogCQlp
ZiAoYnVmcykJLyogTW9yZSB0byBkbz8gKi8KQEAgLTQ5MCw3ICs0OTAsNyBAQCBwaXBlX3dyaXRl
KHN0cnVjdCBraW9jYiAqaW9jYiwgY29uc3Qgc3RydWN0IGlvdmVjICpfaW92LAogCiAJLyogV2Ug
dHJ5IHRvIG1lcmdlIHNtYWxsIHdyaXRlcyAqLwogCWNoYXJzID0gdG90YWxfbGVuICYgKFBBR0Vf
U0laRS0xKTsgLyogc2l6ZSBvZiB0aGUgbGFzdCBidWZmZXIgKi8KLQlpZiAocGlwZS0+bnJidWZz
ICYmIGNoYXJzICE9IDApIHsKKwlpZiAoIXBpcGUtPnBhY2tldGl6ZWQgJiYgcGlwZS0+bnJidWZz
ICYmIGNoYXJzICE9IDApIHsKIAkJaW50IGxhc3RidWYgPSAocGlwZS0+Y3VyYnVmICsgcGlwZS0+
bnJidWZzIC0gMSkgJgogCQkJCQkJCShwaXBlLT5idWZmZXJzIC0gMSk7CiAJCXN0cnVjdCBwaXBl
X2J1ZmZlciAqYnVmID0gcGlwZS0+YnVmcyArIGxhc3RidWY7CmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3BpcGVfZnNfaS5oIGIvaW5jbHVkZS9saW51eC9waXBlX2ZzX2kuaAppbmRleCA2ZDYy
NmZmMGNmZDAuLjQ5ZjAzNGFhY2E1ZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9waXBlX2Zz
X2kuaAorKysgYi9pbmNsdWRlL2xpbnV4L3BpcGVfZnNfaS5oCkBAIC00Myw2ICs0Myw3IEBAIHN0
cnVjdCBwaXBlX2J1ZmZlciB7CiAgKiovCiBzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvIHsKIAl3YWl0
X3F1ZXVlX2hlYWRfdCB3YWl0OworCXVuc2lnbmVkIGludCBwYWNrZXRpemVkOjE7CiAJdW5zaWdu
ZWQgaW50IG5yYnVmcywgY3VyYnVmLCBidWZmZXJzOwogCXVuc2lnbmVkIGludCByZWFkZXJzOwog
CXVuc2lnbmVkIGludCB3cml0ZXJzOwo=
--0016e6d99d1bd8dbc304beae8009--
