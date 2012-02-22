Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2BVCYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:24:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38037 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2BVCYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:24:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.24.202 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 18:24:10 -0800
X-Google-Sender-Auth: m5xJneUBTDBfnJXgvvzzh2uAYLo
Message-ID: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
Subject: compat: autofs v5 packet size ambiguity - update
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        autofs mailing list <autofs@linux.kernel.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=f46d04182598355f2904b9843ace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04182598355f2904b9843ace
Content-Type: text/plain; charset=ISO-8859-1

Btw, thinking more about the autofs patch, I realized that despite it
all working well for Thomas in his case, it's fundamentally wrong.

And it's not fundamentally wrong because of any ambiguities about the
size of the structure: that structure is clearly 304 bytes on x86-64
(and most other platforms, buth 32-bit and 64-bit), but it's 300 bytes
on x86-32 and m68k.

No, the problem is that "is_compat_task()" is not the right check.
It's not the task that *waits* for autofs that matters, it's that damn
autofs daemon task.

IOW, what we actually want to test is whether the other end of that
autofs sbi->pipe is a compat task or not.

And I have no idea how to do that. Can I assume that whoever does the
original "mount()" system call is the daemon? It needs to have that
pipe somehow.. Is there something that the daemon does early on that
we can use to capture whether the daemon is a compat task or not?

Ian, Peter, anybody who knows autofs? Is perhaps one of the ioctl's
always done by the daemon, where we could then use "is_compat_task()"
at that point to figure out whether it is going to expect the 300-byte
packet or the 304-byte packet?

We could just initialize sbi->v5_packet_size to the plain sizeof(),
but when we see that ioctl and realize that the daemon is a x86-32
binary we'd reset the packet size to 300.

Anyway, here's the patch again with a long explanation, but with a
"THIS IS WRONG" comment in the code, and an explanation in the commit
log. It works for Thomas, but it works for the wrong reasons - in his
setup, all binaries are compat binaries, so "is_compat_task()" just
happens to get the right value for the daemon too. But if you have a
mixture of binaries, you might get the autofs *request* in a compat
binary while the daemon is a 64-bit native x86-64 binary, or the other
way around, and then this patch would use the wrong packet size to
communicate with the daemon.

Hmm?

                     Linus

--f46d04182598355f2904b9843ace
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-autofs-work-around-unhappy-compat-problem-on-x86-64.patch"
Content-Disposition: attachment; 
	filename="0001-autofs-work-around-unhappy-compat-problem-on-x86-64.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyxqh8fk0

RnJvbSBiY2E3OTNkNjBkMDdkNzk1MDFhODNiNGU4M2E4NTZjM2JkYmZkNTM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IFR1ZSwgMjEgRmViIDIwMTIgMTc6MzY6MDYgLTA4MDAKU3ViamVjdDog
W1BBVENIXSBhdXRvZnM6IHdvcmsgYXJvdW5kIHVuaGFwcHkgY29tcGF0IHByb2JsZW0gb24geDg2
LTY0CgpXaGVuIHRoZSBhdXRvZnMgcHJvdG9jb2wgdmVyc2lvbiA1IHBhY2tldCB0eXBlIHdhcyBh
ZGRlZCBpbiBjb21taXQKNWMwYTMyZmMyY2QwICgiYXV0b2ZzNDogYWRkIG5ldyBwYWNrZXQgdHlw
ZSBmb3IgdjUgY29tbXVuaWNhdGlvbnMiKSwgaXQKb2J2b3VzbHkgdHJpZWQgcXVpdGUgaGFyZCB0
byBiZSB3b3JkLXNpemUgYWdub3N0aWMsIGFuZCB1c2VzIGV4cGxpY2l0bHkKc2l6ZWQgZmllbGRz
IHRoYXQgYXJlIGFsbCBjb3JyZWN0bHkgYWxpZ25lZC4KCkhvd2V2ZXIsIHdpdGggdGhlIGZpbmFs
ICJjaGFyIG5hbWVbTkFNRV9NQVgrMV0iIGFycmF5IGF0IHRoZSBlbmQsIHRoZQphY3R1YWwgc2l6
ZSBvZiB0aGUgc3RydWN0dXJlIGVuZHMgdXAgYmVpbmcgbm90IHZlcnkgd2VsbCBkZWZpbmVkOgpi
ZWNhdXNlIHRoZSBzdHJ1Y3QgaXNuJ3QgbWFya2VkICdwYWNrZWQnLCBkb2luZyBhICJzaXplb2Yo
KSIgb24gaXQgd2lsbAphbGlnbiB0aGUgc2l6ZSBvZiB0aGUgc3RydWN0IHVwIHRvIHRoZSBiaWdn
ZXN0IGFsaWdubWVudCBvZiB0aGUgbWVtYmVycwppdCBoYXMuCgpBbmQgZGVzcGl0ZSBhbGwgdGhl
IG1lbWJlcnMgYmVpbmcgdGhlIHNhbWUsIHRoZSBhbGlnbm1lbnQgb2YgdGhlbSBpcwpkaWZmZXJl
bnQ6IGEgIl9fdTY0IiBoYXMgNC1ieXRlIGFsaWdubWVudCBvbiB4ODYtMzIsIGJ1dCBuYXRpdmUg
OC1ieXRlCmFsaWdubWVudCBvbiB4ODYtNjQuICBBbmQgd2hpbGUgJ05BTUVfTUFYKzEnIGVuZHMg
dXAgYmVpbmcgYSBuaWNlIHJvdW5kCm51bWJlciAoMjU2KSwgdGhlIG5hbWVbXSBhcnJheSBzdGFy
dHMgb3V0IGEgNC1ieXRlIGFsaWduZWQuCgpFbmQgcmVzdWx0OiB0aGUgInBhY2tlZCIgc2l6ZSBv
ZiB0aGUgc3RydWN0dXJlIGlzIDMwMCBieXRlczogNC1ieXRlLCBidXQKbm90IDgtYnl0ZSBhbGln
bmVkLgoKQXMgYSByZXN1bHQsIGRlc3BpdGUgYWxsIHRoZSBmaWVsZHMgYmVpbmcgaW4gdGhlIHNh
bWUgcGxhY2Ugb24gYWxsCmFyY2hpdGVjdHVyZXMsIHNpemVvZigpIHdpbGwgcm91bmQgdXAgdGhh
dCBzaXplIHRvIDMwNCBieXRlcyBvbgphcmNoaXRlY3R1cmVzIHRoYXQgaGF2ZSA4LWJ5dGUgYWxp
Z25tZW50IGZvciB1NjQuCgpOb3RlIHRoYXQgdGhpcyBpcyAqbm90KiBhIHByb2JsZW0gZm9yIDMy
LWJpdCBjb21wYXQgbW9kZSBvbiBQT1dFUiwgc2luY2UKdGhlcmUgX191NjQgaXMgOC1ieXRlIGFs
aWduZWQgZXZlbiBpbiAzMi1iaXQgbW9kZS4gIEJ1dCBvbiB4ODYsIDMyLWJpdAphbmQgNjQtYml0
IGFsaWdubWVudCBpcyBkaWZmZXJlbnQgZm9yIDY0LWJpdCBlbnRpdGllcywgYW5kIGFzIGEgcmVz
dWx0CnRoZSBzdHJ1Y3R1cmUgdGhhdCBoYXMgZXhhY3RseSB0aGUgc2FtZSBsYXlvdXQgaGFzIGRp
ZmZlcmVudCBzaXplcy4KClNvIG9uIHg4Ni02NCwgYnV0IG5vIG90aGVyIGFyY2hpdGVjdHVyZSwg
d2Ugd2lsbCBqdXN0IHN1YnRyYWN0IDQgZnJvbQp0aGUgc2l6ZSBvZiB0aGUgc3RydWN0dXJlIHdo
ZW4gcnVubmluZyBpbiBhIGNvbXBhdCB0YXNrLiAgVGhhdCB3YXkgd2UKd2lsbCB3cml0ZSB0aGUg
cHJvcGVybHkgc2l6ZWQgcGFja2V0IHRoYXQgdXNlciBtb2RlIGV4cGVjdHMuCgpOb3QgcHJldHR5
LiAgU2FkbHksIHRoaXMgdmVyeSBzdWJ0bGUsIGFuZCB1bm5lY2Vzc2FyeSwgc2l6ZSBkaWZmZXJl
bmNlCmhhcyBiZWVuIGVuY29kZWQgaW4gdXNlciBzcGFjZSB0aGF0IHdhbnRzIHRvIHJlYWQgcGFj
a2V0cyBvZiAqZXhhY3RseSoKdGhlIHJpZ2h0IHNpemUsIGFuZCB3aWxsIHJlZnVzZSB0byB0b3Vj
aCBhbnl0aGluZyBlbHNlLgoKQW5kIHRoZSBzYWQgcGFydCBpcyB0aGF0IHRoaXMgcGF0Y2ggaXMg
Kndyb25nKjogd2UgbmVlZCB0byBrbm93IHdoZXRoZXIKdGhlIGF1dG9mcyAqZGFlbW9uKiBpcyBh
IGNvbXBhdCB0YXNrLCBub3cgd2hldGhlciB0aGUgKmN1cnJlbnQqIHRhc2sgaXMKYSBjb21wYXQg
dGFzay4KClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IFRob21hcyBNZXllciA8dGhvbWFzQG0zeTNy
LmRlPgpDYzogSWFuIEtlbnQgPHJhdmVuQHRoZW1hdy5uZXQ+ClNpZ25lZC1vZmYtYnk6IExpbnVz
IFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBmcy9hdXRvZnM0
L3dhaXRxLmMgfCAgIDIyICsrKysrKysrKysrKysrKysrKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwg
MjAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9hdXRvZnM0
L3dhaXRxLmMgYi9mcy9hdXRvZnM0L3dhaXRxLmMKaW5kZXggZGE4ODc2ZDM4YTdiLi5kNGI5MTE5
MDk4NjkgMTAwNjQ0Ci0tLSBhL2ZzL2F1dG9mczQvd2FpdHEuYworKysgYi9mcy9hdXRvZnM0L3dh
aXRxLmMKQEAgLTE1LDYgKzE1LDcgQEAKICNpbmNsdWRlIDxsaW51eC90aW1lLmg+CiAjaW5jbHVk
ZSA8bGludXgvc2lnbmFsLmg+CiAjaW5jbHVkZSA8bGludXgvZmlsZS5oPgorI2luY2x1ZGUgPGxp
bnV4L2NvbXBhdC5oPgogI2luY2x1ZGUgImF1dG9mc19pLmgiCiAKIC8qIFdlIG1ha2UgdGhpcyBh
IHN0YXRpYyB2YXJpYWJsZSByYXRoZXIgdGhhbiBhIHBhcnQgb2YgdGhlIHN1cGVyYmxvY2s7IGl0
CkBAIC05MSw2ICs5MiwyNCBAQCBzdGF0aWMgaW50IGF1dG9mczRfd3JpdGUoc3RydWN0IGF1dG9m
c19zYl9pbmZvICpzYmksCiAKIAlyZXR1cm4gKGJ5dGVzID4gMCk7CiB9CisKKy8qCisgKiBUaGUg
YXV0b2ZzX3Y1IHBhY2tldCB3YXMgbWlzZGVzaWduZWQuCisgKgorICogVGhlIHBhY2tldHMgYXJl
IGlkZW50aWNhbCBvbiB4ODYtMzIgYW5kIHg4Ni02NCwgYnV0IGhhdmUgZGlmZmVyZW50CisgKiBh
bGlnbm1lbnQuIFdoaWNoIG1lYW5zIHRoYXQgJ3NpemVvZigpJyB3aWxsIGdpdmUgZGlmZmVyZW50
IHJlc3VsdHMuCisgKiBGaXggaXQgdXAgZm9yIHRoZSBjYXNlIG9mIHJ1bm5pbmcgMzItYml0IHVz
ZXIgbW9kZSBvbiBhIDY0LWJpdCBrZXJuZWwuCisgKi8KK3N0YXRpYyBub2lubGluZSBzaXplX3Qg
YXV0b2ZzX3Y1X3BhY2tldF9zaXplKHZvaWQpCit7CisJc2l6ZV90IHBrdHN6ID0gc2l6ZW9mKHN0
cnVjdCBhdXRvZnNfdjVfcGFja2V0KTsKKyNpZiBkZWZpbmVkKENPTkZJR19YODZfNjQpICYmIGRl
ZmluZWQoQ09ORklHX0NPTVBBVCkKKwkvKiBUSElTIElTIFdST05HIC0gV0UgU0hPVUxEIENIRUNL
IElGIFRIRSAqREVBTU9OKiBJUyBBIENPTVBBVCBUQVNLISAqLworCWlmIChpc19jb21wYXRfdGFz
aygpKQorCQlwa3RzeiAtPSA0OworI2VuZGlmCisJcmV0dXJuIHBrdHN6OworfQogCQogc3RhdGlj
IHZvaWQgYXV0b2ZzNF9ub3RpZnlfZGFlbW9uKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqc2JpLAog
CQkJCSBzdHJ1Y3QgYXV0b2ZzX3dhaXRfcXVldWUgKndxLApAQCAtMTU1LDggKzE3NCw3IEBAIHN0
YXRpYyB2b2lkIGF1dG9mczRfbm90aWZ5X2RhZW1vbihzdHJ1Y3QgYXV0b2ZzX3NiX2luZm8gKnNi
aSwKIAl7CiAJCXN0cnVjdCBhdXRvZnNfdjVfcGFja2V0ICpwYWNrZXQgPSAmcGt0LnY1X3BrdC52
NV9wYWNrZXQ7CiAKLQkJcGt0c3ogPSBzaXplb2YoKnBhY2tldCk7Ci0KKwkJcGt0c3ogPSBhdXRv
ZnNfdjVfcGFja2V0X3NpemUoKTsKIAkJcGFja2V0LT53YWl0X3F1ZXVlX3Rva2VuID0gd3EtPndh
aXRfcXVldWVfdG9rZW47CiAJCXBhY2tldC0+bGVuID0gd3EtPm5hbWUubGVuOwogCQltZW1jcHko
cGFja2V0LT5uYW1lLCB3cS0+bmFtZS5uYW1lLCB3cS0+bmFtZS5sZW4pOwotLSAKMS43LjkuMTg4
LmcxMjc2Ni5kaXJ0eQoK
--f46d04182598355f2904b9843ace--
