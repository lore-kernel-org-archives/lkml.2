Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0JNVL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:11:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab0JNVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:21 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
References: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Oct 2010 14:09:30 -0700
Message-ID: <AANLkTimKtTo=Lh6CzEHhZPLUNgU87uvw+mX+zKmxzJAB@mail.gmail.com>
Subject: Re: commit 0eead9ab breaks ia64 build
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e644ded877ef9c04929a2113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e644ded877ef9c04929a2113
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2010 at 1:58 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Just pulled Linus latest and get these errors on ia64 build:
>
> In file included from arch/ia64/kernel/elfcore.c:2:
> include/linux/coredump.h: In function =91dump_write=92:
> include/linux/coredump.h:14: error: implicit declaration of function =91a=
ccess_ok=92
> include/linux/coredump.h:14: error: =91VERIFY_READ=92 undeclared (first
> use in this function)
>
> I guess I have to start juggling some #includes ... anyone else have prob=
lems?

Hmm. I thought that <linux/mm.h> would get it, but apparently not -
we'd need <asm/uaccess.h>.

I also (as I commented in the commit) suspect that we shouldn't do the
raw '->write()' call AT ALL, and that was always wrong. So another way
of fixing the problem with the missing access_ok() is to just use
vfs_write(), which does everything right. The reason I didn't do it is
that I suspect we shouldn't count core-dumping as a "write", so the
statistics done by vfs_write() are probably wrong.

Anyway, the real problem is that those functions really shouldn't be
inline functions to begin with. They're doing function calls, they
aren't critical, and dump_seek() in particular is too large by far. So
I suspect the proper fix is to just uninline them and put them in
fs/exec.c as real functions.

IOW, like the attached. Does that work for you?

                        Linus

--0016e644ded877ef9c04929a2113
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfa4h4ao0

IGZzL2V4ZWMuYyAgICAgICAgICAgICAgICB8ICAgMzggKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIGluY2x1ZGUvbGludXgvY29yZWR1bXAuaCB8ICAgMzQgKystLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25z
KCspLCAzMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9leGVjLmMgYi9mcy9leGVjLmMK
aW5kZXggODI4ZGQyNC4uMDMyNzhjOSAxMDA2NDQKLS0tIGEvZnMvZXhlYy5jCisrKyBiL2ZzL2V4
ZWMuYwpAQCAtMjAxNCwzICsyMDE0LDQxIEBAIGZhaWxfY3JlZHM6CiBmYWlsOgogCXJldHVybjsK
IH0KKworLyoKKyAqIENvcmUgZHVtcGluZyBoZWxwZXIgZnVuY3Rpb25zLiAgVGhlc2UgYXJlIHRo
ZSBvbmx5IHRoaW5ncyB5b3Ugc2hvdWxkCisgKiBkbyBvbiBhIGNvcmUtZmlsZTogdXNlIG9ubHkg
dGhlc2UgZnVuY3Rpb25zIHRvIHdyaXRlIG91dCBhbGwgdGhlCisgKiBuZWNlc3NhcnkgaW5mby4K
KyAqLworaW50IGR1bXBfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IHZvaWQgKmFkZHIs
IGludCBucikKK3sKKwlyZXR1cm4gYWNjZXNzX29rKFZFUklGWV9SRUFELCBhZGRyLCBucikgJiYg
ZmlsZS0+Zl9vcC0+d3JpdGUoZmlsZSwgYWRkciwgbnIsICZmaWxlLT5mX3BvcykgPT0gbnI7Cit9
CisKK2ludCBkdW1wX3NlZWsoc3RydWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBvZmYpCit7CisJaW50
IHJldCA9IDE7CisKKwlpZiAoZmlsZS0+Zl9vcC0+bGxzZWVrICYmIGZpbGUtPmZfb3AtPmxsc2Vl
ayAhPSBub19sbHNlZWspIHsKKwkJaWYgKGZpbGUtPmZfb3AtPmxsc2VlayhmaWxlLCBvZmYsIFNF
RUtfQ1VSKSA8IDApCisJCQlyZXR1cm4gMDsKKwl9IGVsc2UgeworCQljaGFyICpidWYgPSAoY2hh
ciAqKWdldF96ZXJvZWRfcGFnZShHRlBfS0VSTkVMKTsKKworCQlpZiAoIWJ1ZikKKwkJCXJldHVy
biAwOworCQl3aGlsZSAob2ZmID4gMCkgeworCQkJdW5zaWduZWQgbG9uZyBuID0gb2ZmOworCisJ
CQlpZiAobiA+IFBBR0VfU0laRSkKKwkJCQluID0gUEFHRV9TSVpFOworCQkJaWYgKCFkdW1wX3dy
aXRlKGZpbGUsIGJ1ZiwgbikpIHsKKwkJCQlyZXQgPSAwOworCQkJCWJyZWFrOworCQkJfQorCQkJ
b2ZmIC09IG47CisJCX0KKwkJZnJlZV9wYWdlKCh1bnNpZ25lZCBsb25nKWJ1Zik7CisJfQorCXJl
dHVybiByZXQ7Cit9CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NvcmVkdW1wLmggYi9pbmNs
dWRlL2xpbnV4L2NvcmVkdW1wLmgKaW5kZXggNTk1NzljZi4uYmE0Yjg1YSAxMDA2NDQKLS0tIGEv
aW5jbHVkZS9saW51eC9jb3JlZHVtcC5oCisrKyBiL2luY2x1ZGUvbGludXgvY29yZWR1bXAuaApA
QCAtOSwzNyArOSw3IEBACiAgKiBUaGVzZSBhcmUgdGhlIG9ubHkgdGhpbmdzIHlvdSBzaG91bGQg
ZG8gb24gYSBjb3JlLWZpbGU6IHVzZSBvbmx5IHRoZXNlCiAgKiBmdW5jdGlvbnMgdG8gd3JpdGUg
b3V0IGFsbCB0aGUgbmVjZXNzYXJ5IGluZm8uCiAgKi8KLXN0YXRpYyBpbmxpbmUgaW50IGR1bXBf
d3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IHZvaWQgKmFkZHIsIGludCBucikKLXsKLQly
ZXR1cm4gYWNjZXNzX29rKFZFUklGWV9SRUFELCBhZGRyLCBucikgJiYgZmlsZS0+Zl9vcC0+d3Jp
dGUoZmlsZSwgYWRkciwgbnIsICZmaWxlLT5mX3BvcykgPT0gbnI7Ci19Ci0KLXN0YXRpYyBpbmxp
bmUgaW50IGR1bXBfc2VlayhzdHJ1Y3QgZmlsZSAqZmlsZSwgbG9mZl90IG9mZikKLXsKLQlpbnQg
cmV0ID0gMTsKLQotCWlmIChmaWxlLT5mX29wLT5sbHNlZWsgJiYgZmlsZS0+Zl9vcC0+bGxzZWVr
ICE9IG5vX2xsc2VlaykgewotCQlpZiAoZmlsZS0+Zl9vcC0+bGxzZWVrKGZpbGUsIG9mZiwgU0VF
S19DVVIpIDwgMCkKLQkJCXJldHVybiAwOwotCX0gZWxzZSB7Ci0JCWNoYXIgKmJ1ZiA9IChjaGFy
ICopZ2V0X3plcm9lZF9wYWdlKEdGUF9LRVJORUwpOwotCi0JCWlmICghYnVmKQotCQkJcmV0dXJu
IDA7Ci0JCXdoaWxlIChvZmYgPiAwKSB7Ci0JCQl1bnNpZ25lZCBsb25nIG4gPSBvZmY7Ci0KLQkJ
CWlmIChuID4gUEFHRV9TSVpFKQotCQkJCW4gPSBQQUdFX1NJWkU7Ci0JCQlpZiAoIWR1bXBfd3Jp
dGUoZmlsZSwgYnVmLCBuKSkgewotCQkJCXJldCA9IDA7Ci0JCQkJYnJlYWs7Ci0JCQl9Ci0JCQlv
ZmYgLT0gbjsKLQkJfQotCQlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpYnVmKTsKLQl9Ci0JcmV0
dXJuIHJldDsKLX0KK2V4dGVybiBpbnQgZHVtcF93cml0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgY29u
c3Qgdm9pZCAqYWRkciwgaW50IG5yKTsKK2V4dGVybiBpbnQgZHVtcF9zZWVrKHN0cnVjdCBmaWxl
ICpmaWxlLCBsb2ZmX3Qgb2ZmKTsKIAogI2VuZGlmIC8qIF9MSU5VWF9DT1JFRFVNUF9IICovCg==
--0016e644ded877ef9c04929a2113--
