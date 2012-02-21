Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2BUWnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:43:39 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53433 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2BUWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:43:35 -0500
MIME-Version: 1.0
In-Reply-To: <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 14:43:14 -0800
X-Google-Sender-Auth: 0vo5crqX0paqdDR5FLvi94gdxdo
Message-ID: <CA+55aFxkbsZN3yG6d9DPGiXmiuX-wOURJcC0hAUN3Qbykv1UhQ@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d62584175c0304b9812410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d62584175c0304b9812410
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Feb 19, 2012 at 5:42 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
>
> 2.) while debugging above issue: I did find an minor bug in sys_poll() - nobody did take care of my proposed patch: https://lkml.org/lkml/2011/9/24/35

Ok, so I started out forward-porting that patch to current -git
(trivial: it's just that the system call tables are differently
generated now), but the more I look at it, the more I suspect that we
should perhaps just globally fix "sys_poll()" to have the timeout
argument be 'int'.

Because that *is* the standard user interface (just do "man 2 poll"),
and while all of the git history (and all of the BK history) we've had
it as "long", I suspect we should just fix it.

So I suspect the correct patch is just as attached instead: make
sys_poll() just take an "int timeout". Any user who tried to use a
long value would already have got truncated by glibc - I just checked.

Of course, there is a remote possibility that somebody might not use
glibc, and have used "poll()" with the raw system call interface, and
depended on using a 64-bit "long timeout" on 64-bit architectures.

But quite frankly, that sounds rather unlikely in the extreme.

Comments? If we do this, and somebody actually reports that they use a
64-bit timeout, we could always go back to the broken 'long' argument,
and take your patch to fix the compat case.

                  Linus

--0016e6d62584175c0304b9812410
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyxismw70

IGFyY2gvczM5MC9rZXJuZWwvY29tcGF0X3dyYXBwZXIuUyB8ICAgIDIgKy0KIGZzL3NlbGVjdC5j
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIGluY2x1ZGUvbGludXgvc3lzY2FsbHMu
aCAgICAgICAgICB8ICAgIDIgKy0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9rZXJuZWwvY29tcGF0X3dyYXBw
ZXIuUyBiL2FyY2gvczM5MC9rZXJuZWwvY29tcGF0X3dyYXBwZXIuUwppbmRleCAxOGM1MWRmOWZl
MDYuLmZmNjA1YTM5Y2Y0MyAxMDA2NDQKLS0tIGEvYXJjaC9zMzkwL2tlcm5lbC9jb21wYXRfd3Jh
cHBlci5TCisrKyBiL2FyY2gvczM5MC9rZXJuZWwvY29tcGF0X3dyYXBwZXIuUwpAQCAtNjYyLDcg
KzY2Miw3IEBAIEVOVFJZKHN5czMyX2dldHJlc3VpZDE2X3dyYXBwZXIpCiBFTlRSWShzeXMzMl9w
b2xsX3dyYXBwZXIpCiAJbGxndHIJJXIyLCVyMgkJCSMgc3RydWN0IHBvbGxmZCAqCiAJbGxnZnIJ
JXIzLCVyMwkJCSMgdW5zaWduZWQgaW50Ci0JbGdmcgklcjQsJXI0CQkJIyBsb25nCisJbGdmcgkl
cjQsJXI0CQkJIyBpbnQKIAlqZwlzeXNfcG9sbAkJIyBicmFuY2ggdG8gc3lzdGVtIGNhbGwKIAog
RU5UUlkoc3lzMzJfc2V0cmVzZ2lkMTZfd3JhcHBlcikKZGlmZiAtLWdpdCBhL2ZzL3NlbGVjdC5j
IGIvZnMvc2VsZWN0LmMKaW5kZXggZDMzNDE4ZmRjODU4Li5lNzgyMjU4ZDBkZTMgMTAwNjQ0Ci0t
LSBhL2ZzL3NlbGVjdC5jCisrKyBiL2ZzL3NlbGVjdC5jCkBAIC05MTIsNyArOTEyLDcgQEAgc3Rh
dGljIGxvbmcgZG9fcmVzdGFydF9wb2xsKHN0cnVjdCByZXN0YXJ0X2Jsb2NrICpyZXN0YXJ0X2Js
b2NrKQogfQogCiBTWVNDQUxMX0RFRklORTMocG9sbCwgc3RydWN0IHBvbGxmZCBfX3VzZXIgKiwg
dWZkcywgdW5zaWduZWQgaW50LCBuZmRzLAotCQlsb25nLCB0aW1lb3V0X21zZWNzKQorCQlpbnQs
IHRpbWVvdXRfbXNlY3MpCiB7CiAJc3RydWN0IHRpbWVzcGVjIGVuZF90aW1lLCAqdG8gPSBOVUxM
OwogCWludCByZXQ7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3N5c2NhbGxzLmggYi9pbmNs
dWRlL2xpbnV4L3N5c2NhbGxzLmgKaW5kZXggNTE1NjY5ZmEzYzFkLi44ZWMxMTUzZmY1N2IgMTAw
NjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc3lzY2FsbHMuaAorKysgYi9pbmNsdWRlL2xpbnV4L3N5
c2NhbGxzLmgKQEAgLTYyNCw3ICs2MjQsNyBAQCBhc21saW5rYWdlIGxvbmcgc3lzX3NvY2tldHBh
aXIoaW50LCBpbnQsIGludCwgaW50IF9fdXNlciAqKTsKIGFzbWxpbmthZ2UgbG9uZyBzeXNfc29j
a2V0Y2FsbChpbnQgY2FsbCwgdW5zaWduZWQgbG9uZyBfX3VzZXIgKmFyZ3MpOwogYXNtbGlua2Fn
ZSBsb25nIHN5c19saXN0ZW4oaW50LCBpbnQpOwogYXNtbGlua2FnZSBsb25nIHN5c19wb2xsKHN0
cnVjdCBwb2xsZmQgX191c2VyICp1ZmRzLCB1bnNpZ25lZCBpbnQgbmZkcywKLQkJCQlsb25nIHRp
bWVvdXQpOworCQkJCWludCB0aW1lb3V0KTsKIGFzbWxpbmthZ2UgbG9uZyBzeXNfc2VsZWN0KGlu
dCBuLCBmZF9zZXQgX191c2VyICppbnAsIGZkX3NldCBfX3VzZXIgKm91dHAsCiAJCQlmZF9zZXQg
X191c2VyICpleHAsIHN0cnVjdCB0aW1ldmFsIF9fdXNlciAqdHZwKTsKIGFzbWxpbmthZ2UgbG9u
ZyBzeXNfb2xkX3NlbGVjdChzdHJ1Y3Qgc2VsX2FyZ19zdHJ1Y3QgX191c2VyICphcmcpOwo=
--0016e6d62584175c0304b9812410--
