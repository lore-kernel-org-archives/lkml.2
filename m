Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358Ab2EITEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:04:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64931 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2EITEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
 <CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com> <CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 12:03:47 -0700
X-Google-Sender-Auth: RXjYQ3INAZV1EkRHVURsM3B1zq0
Message-ID: <CA+55aFyrSNTh3B7L=Lq1L_Hz=0NEPC95TWmo2-W9odKi+80XJg@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: multipart/mixed; boundary=f46d041824eeef70e204bf9f2aed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041824eeef70e204bf9f2aed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, May 7, 2012 at 1:13 PM, Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> The application was relying on setuid failing in order to do resource lim=
iting
> (the man page for setresuid documents EAGAIN as the error you'll get if y=
ou
> can't switch to the new uid because of RLIMIT_NPROC being exceeded).
> It would detect the error condition and slow down.
> Now it doesn't get an error back and can grow out of control.

Ok. Maybe we could change the logic in set_user() to simply just check
both the soft and the hard limit.

At the hard limit, we just fail it. At the soft limit, we mark the
next execve() for failure.

That would seem to be a very natural model, and it would mean that you
could get the old behavior by simply making the hard limit the same as
the soft limit.

Would that work ok for your use case?

Trivial (but TOTALLY UNTESTED - so maybe it doesn't work) patch attached.

                     Linus

--f46d041824eeef70e204bf9f2aed
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h20razdc0

IGtlcm5lbC9zeXMuYyB8ICAgMTggKysrKysrKysrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc3lz
LmMgYi9rZXJuZWwvc3lzLmMKaW5kZXggZTcwMDZlYjZjMWU0Li5hYjlmMjY2OTMzYWYgMTAwNjQ0
Ci0tLSBhL2tlcm5lbC9zeXMuYworKysgYi9rZXJuZWwvc3lzLmMKQEAgLTY0MiwxMSArNjQyLDE5
IEBAIHN0YXRpYyBpbnQgc2V0X3VzZXIoc3RydWN0IGNyZWQgKm5ldykKIAkgKiBmb3IgcHJvZ3Jh
bXMgZG9pbmcgc2V0KnVpZCgpK2V4ZWN2ZSgpIGJ5IGhhcm1sZXNzbHkgZGVmZXJyaW5nIHRoZQog
CSAqIGZhaWx1cmUgdG8gdGhlIGV4ZWN2ZSgpIHN0YWdlLgogCSAqLwotCWlmIChhdG9taWNfcmVh
ZCgmbmV3X3VzZXItPnByb2Nlc3NlcykgPj0gcmxpbWl0KFJMSU1JVF9OUFJPQykgJiYKLQkJCW5l
d191c2VyICE9IElOSVRfVVNFUikKLQkJY3VycmVudC0+ZmxhZ3MgfD0gUEZfTlBST0NfRVhDRUVE
RUQ7Ci0JZWxzZQotCQljdXJyZW50LT5mbGFncyAmPSB+UEZfTlBST0NfRVhDRUVERUQ7CisJaWYg
KG5ld191c2VyICE9IElOSVRfVVNFUikgeworCQlpbnQgcHJvY2Vzc2VzID0gYXRvbWljX3JlYWQo
Jm5ld191c2VyLT5wcm9jZXNzZXMpOworCisJCS8qIEhhcmQgbGltaXQ6IGZhaWwgaXQgKi8KKwkJ
aWYgKHByb2Nlc3NlcyA+PSBybGltaXRfbWF4KFJMSU1JVF9OUFJPQykpIHsKKwkJCWZyZWVfdWlk
KG5ld191c2VyKTsKKwkJCXJldHVybiAtRUFHQUlOOworCQl9CisKKwkJLyogU29mdCBsaW1pdDog
ZmFpbCB0aGUgbmV4dCBleGVjICovCisJCWlmIChwcm9jZXNzZXMgPj0gcmxpbWl0KFJMSU1JVF9O
UFJPQykpCisJCQljdXJyZW50LT5mbGFncyB8PSBQRl9OUFJPQ19FWENFRURFRDsKKwl9CiAKIAlm
cmVlX3VpZChuZXctPnVzZXIpOwogCW5ldy0+dXNlciA9IG5ld191c2VyOwo=
--f46d041824eeef70e204bf9f2aed--
