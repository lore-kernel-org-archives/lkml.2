Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2ECVCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:02:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60713 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2ECVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <1336077035.3676.5.camel@localhost>
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
 <20120503064722.GN6871@ZenIV.linux.org.uk> <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
 <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
 <4FA2CAD9.6010808@zytor.com> <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
 <1336077035.3676.5.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 14:01:57 -0700
X-Google-Sender-Auth: NAa3HWqCgQRtERe-95ErVP5g3lU
Message-ID: <CA+55aFz1zNWjmOJpJu1pET0U5F5fufBiOkm6ESaVAZkiqwKh4g@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
To: Jana Saout <jana@saout.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0444028e8ed83004bf281e40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0444028e8ed83004bf281e40
Content-Type: text/plain; charset=ISO-8859-1

On Thu, May 3, 2012 at 1:30 PM, Jana Saout <jana@saout.de> wrote:
>
> Instead, now I got an oops on __d_lookup (fs/dcache.c line 155) (kernel
> log excerpt below):

Heh, forgot about that one.

Trivial enough to fix. And I'll just make both of them use the
unaligned load helper function, even if technically I think only the
'ct 'access needs it.

This is just the incremental diff. The "real meat" of the change is
just making it use the helper function instead of the "direct
dereference through a unsigned long pointer cast", but the patch is
bigger than that because I decided to split the whole function up so
that we could do the nicer #include. setup. And because I shouldn't
have done it with an #ifdef inside a function to begin with.

Anyway, the fact that you can trigger these things so quickly
certainly is a good sign that your setup is good at finding it. It
could have been worse. Hopefully I now actually caught all users.

                   Linus

--f46d0444028e8ed83004bf281e40
Content-Type: application/octet-stream; name="dentry_cmp.diff"
Content-Disposition: attachment; filename="dentry_cmp.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1savdy70

IGZzL2RjYWNoZS5jIHwgICAyNiArKysrKysrKysrKysrKysrKysrKysrLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
ZGNhY2hlLmMgYi9mcy9kY2FjaGUuYwppbmRleCBiNjBkZGM0MWQ3ODMuLmI4MDUzMWM5MTc3OSAx
MDA2NDQKLS0tIGEvZnMvZGNhY2hlLmMKKysrIGIvZnMvZGNhY2hlLmMKQEAgLTE0MSwxOCArMTQx
LDI5IEBAIGludCBwcm9jX25yX2RlbnRyeShjdGxfdGFibGUgKnRhYmxlLCBpbnQgd3JpdGUsIHZv
aWQgX191c2VyICpidWZmZXIsCiAgKiBDb21wYXJlIDIgbmFtZSBzdHJpbmdzLCByZXR1cm4gMCBp
ZiB0aGV5IG1hdGNoLCBvdGhlcndpc2Ugbm9uLXplcm8uCiAgKiBUaGUgc3RyaW5ncyBhcmUgYm90
aCBjb3VudCBieXRlcyBsb25nLCBhbmQgY291bnQgaXMgbm9uLXplcm8uCiAgKi8KKyNpZmRlZiBD
T05GSUdfRENBQ0hFX1dPUkRfQUNDRVNTCisKKyNpbmNsdWRlIDxhc20vd29yZC1hdC1hLXRpbWUu
aD4KKy8qCisgKiBOT1RFISAnY3MnIGFuZCAnc2NvdW50JyBjb21lIGZyb20gYSBkZW50cnksIHNv
IGl0IGhhcyBhCisgKiBhbGlnbmVkIGFsbG9jYXRpb24gZm9yIHRoaXMgcGFydGljdWxhciBjb21w
b25lbnQuIFdlIGRvbid0CisgKiBzdHJpY3RseSBuZWVkIHRoZSBsb2FkX3VuYWxpZ25lZF96ZXJv
cGFkKCkgc2FmZXR5LCBidXQgaXQKKyAqIGRvZXNuJ3QgaHVydCBlaXRoZXIuCisgKgorICogSW4g
Y29udHJhc3QsICdjdCcgYW5kICd0Y291bnQnIGNhbiBiZSBmcm9tIGEgcGF0aG5hbWUsIGFuZCBk
bworICogbmVlZCB0aGUgY2FyZWZ1bCB1bmFsaWduZWQgaGFuZGxpbmcuCisgKi8KIHN0YXRpYyBp
bmxpbmUgaW50IGRlbnRyeV9jbXAoY29uc3QgdW5zaWduZWQgY2hhciAqY3MsIHNpemVfdCBzY291
bnQsCiAJCQkJY29uc3QgdW5zaWduZWQgY2hhciAqY3QsIHNpemVfdCB0Y291bnQpCiB7Ci0jaWZk
ZWYgQ09ORklHX0RDQUNIRV9XT1JEX0FDQ0VTUwogCXVuc2lnbmVkIGxvbmcgYSxiLG1hc2s7CiAK
IAlpZiAodW5saWtlbHkoc2NvdW50ICE9IHRjb3VudCkpCiAJCXJldHVybiAxOwogCiAJZm9yICg7
OykgewotCQlhID0gKih1bnNpZ25lZCBsb25nICopY3M7Ci0JCWIgPSAqKHVuc2lnbmVkIGxvbmcg
KiljdDsKKwkJYSA9IGxvYWRfdW5hbGlnbmVkX3plcm9wYWQoY3MpOworCQliID0gbG9hZF91bmFs
aWduZWRfemVyb3BhZChjdCk7CiAJCWlmICh0Y291bnQgPCBzaXplb2YodW5zaWduZWQgbG9uZykp
CiAJCQlicmVhazsKIAkJaWYgKHVubGlrZWx5KGEgIT0gYikpCkBAIC0xNjUsNyArMTc2LDEzIEBA
IHN0YXRpYyBpbmxpbmUgaW50IGRlbnRyeV9jbXAoY29uc3QgdW5zaWduZWQgY2hhciAqY3MsIHNp
emVfdCBzY291bnQsCiAJfQogCW1hc2sgPSB+KH4wdWwgPDwgdGNvdW50KjgpOwogCXJldHVybiB1
bmxpa2VseSghISgoYSBeIGIpICYgbWFzaykpOworfQorCiAjZWxzZQorCitzdGF0aWMgaW5saW5l
IGludCBkZW50cnlfY21wKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmNzLCBzaXplX3Qgc2NvdW50LAor
CQkJCWNvbnN0IHVuc2lnbmVkIGNoYXIgKmN0LCBzaXplX3QgdGNvdW50KQorewogCWlmIChzY291
bnQgIT0gdGNvdW50KQogCQlyZXR1cm4gMTsKIApAQCAtMTc3LDkgKzE5NCwxMCBAQCBzdGF0aWMg
aW5saW5lIGludCBkZW50cnlfY21wKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmNzLCBzaXplX3Qgc2Nv
dW50LAogCQl0Y291bnQtLTsKIAl9IHdoaWxlICh0Y291bnQpOwogCXJldHVybiAwOwotI2VuZGlm
CiB9CiAKKyNlbmRpZgorCiBzdGF0aWMgdm9pZCBfX2RfZnJlZShzdHJ1Y3QgcmN1X2hlYWQgKmhl
YWQpCiB7CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gY29udGFpbmVyX29mKGhlYWQsIHN0cnVj
dCBkZW50cnksIGRfdS5kX3JjdSk7Cg==
--f46d0444028e8ed83004bf281e40--
