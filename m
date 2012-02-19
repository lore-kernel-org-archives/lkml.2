Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2BSSpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 13:45:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2BSSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 13:45:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.181.12.106 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 10:45:26 -0800
X-Google-Sender-Auth: gdl82ug2x8yvYJ-ND_wiuthIuhw
Message-ID: <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Thomas Meyer <thomas@m3y3r.de>, Ian Kent <raven@themaw.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043c7ec0f8291d04b9559553
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043c7ec0f8291d04b9559553
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Feb 19, 2012 at 5:42 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
>
> Theoretically yes, practically (at least with Fedora 15/16) no. I did hit these two bugs:
>
> 1.) autofs4 interface is broken between x86 and x86_64. as systemd uses autofs, this bug hangs the boot process as e.g. binfmt is mounted via autofs. see also http://lists.freedesktop.org/archives/systemd-devel/2011-September/003396.html

Duh.

That is just broken.

The code even *talks* about how the packet layout is the same on
32-bit and 64-bit architectures, and that's largely true.

However, while true, x86-64 has 8-byte alignment for 'long', and
x86-32 has 4-byte alignment. Which means that even though the
structure layout is exactly the same, on x86-64 the *alignment* issue
will push it out to 304 bytes.

That's just stupid. We've had that problem before. It's easy to
overlook, but that packet is just mis-designed.

The attached patch isn't pretty, but this is definitely a kernel bug.
Binary compatibility is *important*, dammit.

Does this fix it?

Sadly, the *right* fix would have been to just mark the structure
packed, or select a maximum name length that padded things out to 8
bytes on all architectures, but we can't change that any more, because
changing the size on native 32-bit would break binaries there.

> 2.) while debugging above issue: I did find an minor bug in sys_poll() - nobody did take care of my proposed patch: https://lkml.org/lkml/2011/9/24/35

Looks correct, and searching my lkml archives shows that it was acked
by Eric. But it never went any further.

Mind re-sending that patch updated for the x86 system call
re-organization? Sure, I could do it myself, but it would be much
better if somebody who then actually *tests* the end result did it
(hpa cc'd, just because he's the one that touched the x86 compat layer
system call table thing. "Tag, you're it")

Anyway, if that, together with the sizeof hack in the attached patch,
makes everything work for you, I'll happily apply both of them.

                          Linus

--f46d043c7ec0f8291d04b9559553
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyufass10

IGZzL2F1dG9mczQvd2FpdHEuYyB8ICAgMjEgKysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGVz
IGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvYXV0b2ZzNC93YWl0cS5jIGIvZnMvYXV0b2ZzNC93YWl0cS5jCmluZGV4IGRhODg3NmQzOGE3
Yi4uZjZmY2NhNThlMGUzIDEwMDY0NAotLS0gYS9mcy9hdXRvZnM0L3dhaXRxLmMKKysrIGIvZnMv
YXV0b2ZzNC93YWl0cS5jCkBAIC0xNSw2ICsxNSw3IEBACiAjaW5jbHVkZSA8bGludXgvdGltZS5o
PgogI2luY2x1ZGUgPGxpbnV4L3NpZ25hbC5oPgogI2luY2x1ZGUgPGxpbnV4L2ZpbGUuaD4KKyNp
bmNsdWRlIDxsaW51eC9jb21wYXQuaD4KICNpbmNsdWRlICJhdXRvZnNfaS5oIgogCiAvKiBXZSBt
YWtlIHRoaXMgYSBzdGF0aWMgdmFyaWFibGUgcmF0aGVyIHRoYW4gYSBwYXJ0IG9mIHRoZSBzdXBl
cmJsb2NrOyBpdApAQCAtOTEsNiArOTIsMjMgQEAgc3RhdGljIGludCBhdXRvZnM0X3dyaXRlKHN0
cnVjdCBhdXRvZnNfc2JfaW5mbyAqc2JpLAogCiAJcmV0dXJuIChieXRlcyA+IDApOwogfQorCisv
KgorICogVGhlIGF1dG9mc192NSBwYWNrZXQgd2FzIG1pc2Rlc2lnbmVkLgorICoKKyAqIFRoZSBw
YWNrZXRzIGFyZSBpZGVudGljYWwgb24geDg2LTMyIGFuZCB4ODYtNjQsIGJ1dCBoYXZlIGRpZmZl
cmVudAorICogYWxpZ25tZW50LiBXaGljaCBtZWFucyB0aGF0ICdzaXplb2YoKScgd2lsbCBnaXZl
IGRpZmZlcmVudCByZXN1bHRzLgorICogRml4IGl0IHVwIGZvciB0aGUgY2FzZSBvZiBydW5uaW5n
IDMyLWJpdCB1c2VyIG1vZGUgb24gYSA2NC1iaXQga2VybmVsLgorICovCitzdGF0aWMgbm9pbmxp
bmUgc2l6ZV90IGF1dG9mc192NV9wYWNrZXRfc2l6ZSh2b2lkKQoreworCXNpemVfdCBwa3RzeiA9
IHNpemVvZihzdHJ1Y3QgYXV0b2ZzX3Y1X3BhY2tldCk7CisjaWYgZGVmaW5lZChDT05GSUdfWDg2
XzY0KSAmJiBkZWZpbmVkKENPTkZJR19DT01QQVQpCisJaWYgKGlzX2NvbXBhdF90YXNrKCkpCisJ
CXBrdHN6IC09IDQ7CisjZW5kaWYKKwlyZXR1cm4gcGt0c3o7Cit9CiAJCiBzdGF0aWMgdm9pZCBh
dXRvZnM0X25vdGlmeV9kYWVtb24oc3RydWN0IGF1dG9mc19zYl9pbmZvICpzYmksCiAJCQkJIHN0
cnVjdCBhdXRvZnNfd2FpdF9xdWV1ZSAqd3EsCkBAIC0xNTUsOCArMTczLDcgQEAgc3RhdGljIHZv
aWQgYXV0b2ZzNF9ub3RpZnlfZGFlbW9uKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqc2JpLAogCXsK
IAkJc3RydWN0IGF1dG9mc192NV9wYWNrZXQgKnBhY2tldCA9ICZwa3QudjVfcGt0LnY1X3BhY2tl
dDsKIAotCQlwa3RzeiA9IHNpemVvZigqcGFja2V0KTsKLQorCQlwa3RzeiA9IGF1dG9mc192NV9w
YWNrZXRfc2l6ZSgpOwogCQlwYWNrZXQtPndhaXRfcXVldWVfdG9rZW4gPSB3cS0+d2FpdF9xdWV1
ZV90b2tlbjsKIAkJcGFja2V0LT5sZW4gPSB3cS0+bmFtZS5sZW47CiAJCW1lbWNweShwYWNrZXQt
Pm5hbWUsIHdxLT5uYW1lLm5hbWUsIHdxLT5uYW1lLmxlbik7Cg==
--f46d043c7ec0f8291d04b9559553--
