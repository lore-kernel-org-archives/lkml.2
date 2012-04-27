Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2D0X1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:27:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50066 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab2D0X1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120427234215.079a1565@pyramind.ukuu.org.uk>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <20120427234215.079a1565@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 16:27:17 -0700
X-Google-Sender-Auth: nlyhAKsNPtQFc-tVI9eCxNPCBNA
Message-ID: <CA+55aFxq4TunFa8mqJk5MHfvvFSg7Dr54acW7Cnqc5amOPdqrg@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Content-Type: multipart/mixed; boundary=f46d0442887e33ccb804beb17305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0442887e33ccb804beb17305
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Apr 27, 2012 at 3:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> The obvious way to set the flag would seem to me to also btake O_DIRECT
> on the pipe as meaning this ?

Ok, that really does seem to be pretty natural.

The attached patch implements that, and makes autofs automatically set
the O_DIRECT flag. And now that it is exposed to user-space, here's a
test-program that uses it:

  [torvalds@i5 ~]$ cat packet.c
  #define _GNU_SOURCE
  #include <unistd.h>
  #include <fcntl.h>
  #include <stdio.h>
  #include <stdlib.h>

  #define REPORT(op,fd,size) do { 			\
  	int ret = op(fd, buffer, size);			\
  	fprintf(stderr, #op "(%d)=%d\n", size, ret);	\
  } while (0)

  #define WRITE(x) REPORT(write,fd[1],x)
  #define READ(x) REPORT(read,fd[0],x)

  int main(void)
  {
  	int fd[2];
  	static char buffer[1024];

  	if (pipe2(fd, O_DIRECT)) {
  		perror("pipe2 O_DIRECT");
  		exit(1);
  	}
  	WRITE(8);
  	WRITE(12);
  	WRITE(300);
  	WRITE(5);
  	READ(64);
  	READ(64);
  	WRITE(7);
  	READ(64);
  	READ(64);
  	READ(64);
  	return 0;
  }

which results in this output:

  [torvalds@i5 ~]$ ./a.out
  write(8)=8
  write(12)=12
  write(300)=300
  write(5)=5
  read(64)=8
  read(64)=12
  write(7)=7
  read(64)=64
  read(64)=5
  read(64)=7

iow, notice how all the read() calls return individual packets (and
the 300-byte packet was truncated to 64 bytes).

HOWEVER. I haven't actually tested the autofs part. But I suspect it
"should just work".

Thomas, Michael, can you test whether this patch (again: note the "+8"
in autofs_v5_packet_size() purely for debug purposes, so this would be
interesting to test for other people too) makes your setups work?

                           Linus

--f46d0442887e33ccb804beb17305
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1jvf37q0

IGZzL2F1dG9mczQvYXV0b2ZzX2kuaCAgfCAgIDEyICsrKysrKysrKysrKwogZnMvYXV0b2ZzNC9k
ZXYtaW9jdGwuYyB8ICAgIDIgKy0KIGZzL2F1dG9mczQvaW5vZGUuYyAgICAgfCAgICAyICstCiBm
cy9hdXRvZnM0L3dhaXRxLmMgICAgIHwgICAxNCArKysrKystLS0tLS0tLQogZnMvcGlwZS5jICAg
ICAgICAgICAgICB8ICAgMTcgKysrKysrKysrKystLS0tLS0KIDUgZmlsZXMgY2hhbmdlZCwgMzEg
aW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvYXV0b2ZzNC9h
dXRvZnNfaS5oIGIvZnMvYXV0b2ZzNC9hdXRvZnNfaS5oCmluZGV4IGViMWNjOTJjZDY3ZC4uYTA3
ODg1YmYwNDYzIDEwMDY0NAotLS0gYS9mcy9hdXRvZnM0L2F1dG9mc19pLmgKKysrIGIvZnMvYXV0
b2ZzNC9hdXRvZnNfaS5oCkBAIC0zNCw2ICszNCw3IEBACiAjaW5jbHVkZSA8bGludXgvc2NoZWQu
aD4KICNpbmNsdWRlIDxsaW51eC9tb3VudC5oPgogI2luY2x1ZGUgPGxpbnV4L25hbWVpLmg+Cisj
aW5jbHVkZSA8bGludXgvcGlwZV9mc19pLmg+CiAjaW5jbHVkZSA8YXNtL2N1cnJlbnQuaD4KICNp
bmNsdWRlIDxhc20vdWFjY2Vzcy5oPgogCkBAIC0yNzAsNiArMjcxLDE3IEBAIGludCBhdXRvZnM0
X2ZpbGxfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICosIHZvaWQgKiwgaW50KTsKIHN0cnVjdCBh
dXRvZnNfaW5mbyAqYXV0b2ZzNF9uZXdfaW5vKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqKTsKIHZv
aWQgYXV0b2ZzNF9jbGVhbl9pbm8oc3RydWN0IGF1dG9mc19pbmZvICopOwogCitzdGF0aWMgaW5s
aW5lIGludCBhdXRvZnNfcHJlcGFyZV9waXBlKHN0cnVjdCBmaWxlICpwaXBlKQoreworCWlmICgh
cGlwZS0+Zl9vcCB8fCAhcGlwZS0+Zl9vcC0+d3JpdGUpCisJCXJldHVybiAtRUlOVkFMOworCWlm
ICghcGlwZS0+Zl9kZW50cnktPmRfaW5vZGUtPmlfcGlwZSkKKwkJcmV0dXJuIC1FSU5WQUw7CisJ
LyogV2Ugd2FudCBhIHBhY2tldCBwaXBlICovCisJcGlwZS0+Zl9mbGFncyB8PSBPX0RJUkVDVDsK
KwlyZXR1cm4gMDsKK30KKwogLyogUXVldWUgbWFuYWdlbWVudCBmdW5jdGlvbnMgKi8KIAogaW50
IGF1dG9mczRfd2FpdChzdHJ1Y3QgYXV0b2ZzX3NiX2luZm8gKixzdHJ1Y3QgZGVudHJ5ICosIGVu
dW0gYXV0b2ZzX25vdGlmeSk7CmRpZmYgLS1naXQgYS9mcy9hdXRvZnM0L2Rldi1pb2N0bC5jIGIv
ZnMvYXV0b2ZzNC9kZXYtaW9jdGwuYwppbmRleCA5ZGFjYjg1ODY3MDEuLjYyNTllNzE0MjAzMiAx
MDA2NDQKLS0tIGEvZnMvYXV0b2ZzNC9kZXYtaW9jdGwuYworKysgYi9mcy9hdXRvZnM0L2Rldi1p
b2N0bC5jCkBAIC0zNzYsNyArMzc2LDcgQEAgc3RhdGljIGludCBhdXRvZnNfZGV2X2lvY3RsX3Nl
dHBpcGVmZChzdHJ1Y3QgZmlsZSAqZnAsCiAJCQllcnIgPSAtRUJBREY7CiAJCQlnb3RvIG91dDsK
IAkJfQotCQlpZiAoIXBpcGUtPmZfb3AgfHwgIXBpcGUtPmZfb3AtPndyaXRlKSB7CisJCWlmIChh
dXRvZnNfcHJlcGFyZV9waXBlKHBpcGUpIDwgMCkgewogCQkJZXJyID0gLUVQSVBFOwogCQkJZnB1
dChwaXBlKTsKIAkJCWdvdG8gb3V0OwpkaWZmIC0tZ2l0IGEvZnMvYXV0b2ZzNC9pbm9kZS5jIGIv
ZnMvYXV0b2ZzNC9pbm9kZS5jCmluZGV4IGQ4ZGMwMDJlOWNjMy4uYzUyNWI3NGRlZWZkIDEwMDY0
NAotLS0gYS9mcy9hdXRvZnM0L2lub2RlLmMKKysrIGIvZnMvYXV0b2ZzNC9pbm9kZS5jCkBAIC0y
OTIsNyArMjkyLDcgQEAgaW50IGF1dG9mczRfZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sg
KnMsIHZvaWQgKmRhdGEsIGludCBzaWxlbnQpCiAJCXByaW50aygiYXV0b2ZzOiBjb3VsZCBub3Qg
b3BlbiBwaXBlIGZpbGUgZGVzY3JpcHRvclxuIik7CiAJCWdvdG8gZmFpbF9kcHV0OwogCX0KLQlp
ZiAoIXBpcGUtPmZfb3AgfHwgIXBpcGUtPmZfb3AtPndyaXRlKQorCWlmIChhdXRvZnNfcHJlcGFy
ZV9waXBlKHBpcGUpIDwgMCkKIAkJZ290byBmYWlsX2ZwdXQ7CiAJc2JpLT5waXBlID0gcGlwZTsK
IAlzYmktPnBpcGVmZCA9IHBpcGVmZDsKZGlmZiAtLWdpdCBhL2ZzL2F1dG9mczQvd2FpdHEuYyBi
L2ZzL2F1dG9mczQvd2FpdHEuYwppbmRleCA5YzA5OGRiNDMzNDQuLjVjZTUwMjYyMDBiOSAxMDA2
NDQKLS0tIGEvZnMvYXV0b2ZzNC93YWl0cS5jCisrKyBiL2ZzL2F1dG9mczQvd2FpdHEuYwpAQCAt
OTcsMTYgKzk3LDE0IEBAIHN0YXRpYyBpbnQgYXV0b2ZzNF93cml0ZShzdHJ1Y3QgYXV0b2ZzX3Ni
X2luZm8gKnNiaSwKICAqCiAgKiBUaGUgcGFja2V0cyBhcmUgaWRlbnRpY2FsIG9uIHg4Ni0zMiBh
bmQgeDg2LTY0LCBidXQgaGF2ZSBkaWZmZXJlbnQKICAqIGFsaWdubWVudC4gV2hpY2ggbWVhbnMg
dGhhdCAnc2l6ZW9mKCknIHdpbGwgZ2l2ZSBkaWZmZXJlbnQgcmVzdWx0cy4KLSAqIEZpeCBpdCB1
cCBmb3IgdGhlIGNhc2Ugb2YgcnVubmluZyAzMi1iaXQgdXNlciBtb2RlIG9uIGEgNjQtYml0IGtl
cm5lbC4KKyAqIEhvd2V2ZXIsIHdlIHBhY2tldGl6ZSB0aGUgcGlwZSwgc28ganVzdCB1c2UgdGhl
IGJpZ2dlciBzaXplLCB0aGUKKyAqIHBpcGUgcmVhZCB3aWxsIGRpc2NhcmQgdGhlIHJlc3QuCisg
KgorICogVGhpcyBhZGRzIG9uIDggYnl0ZXMgb2YgZ2FyYmFnZSBGT1IgREVCVUdHSU5HIE9OTFkh
CiAgKi8KLXN0YXRpYyBub2lubGluZSBzaXplX3QgYXV0b2ZzX3Y1X3BhY2tldF9zaXplKHN0cnVj
dCBhdXRvZnNfc2JfaW5mbyAqc2JpKQorc3RhdGljIGlubGluZSBzaXplX3QgYXV0b2ZzX3Y1X3Bh
Y2tldF9zaXplKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqc2JpKQogewotCXNpemVfdCBwa3RzeiA9
IHNpemVvZihzdHJ1Y3QgYXV0b2ZzX3Y1X3BhY2tldCk7Ci0jaWYgZGVmaW5lZChDT05GSUdfWDg2
XzY0KSAmJiBkZWZpbmVkKENPTkZJR19DT01QQVQpCi0JaWYgKHNiaS0+Y29tcGF0X2RhZW1vbiA+
IDApCi0JCXBrdHN6IC09IDQ7Ci0jZW5kaWYKLQlyZXR1cm4gcGt0c3o7CisJcmV0dXJuIHNpemVv
ZihzdHJ1Y3QgYXV0b2ZzX3Y1X3BhY2tldCkrODsKIH0KIAogc3RhdGljIHZvaWQgYXV0b2ZzNF9u
b3RpZnlfZGFlbW9uKHN0cnVjdCBhdXRvZnNfc2JfaW5mbyAqc2JpLApkaWZmIC0tZ2l0IGEvZnMv
cGlwZS5jIGIvZnMvcGlwZS5jCmluZGV4IDI1ZmVhYTNmYWFjMC4uYzY1MDUxZWI2ODkzIDEwMDY0
NAotLS0gYS9mcy9waXBlLmMKKysrIGIvZnMvcGlwZS5jCkBAIC0zNDYsNiArMzQ2LDExIEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3QgcGlwZV9idWZfb3BlcmF0aW9ucyBhbm9uX3BpcGVfYnVmX29wcyA9
IHsKIAkuZ2V0ID0gZ2VuZXJpY19waXBlX2J1Zl9nZXQsCiB9OwogCitzdGF0aWMgaW5saW5lIGlu
dCBpc19wYWNrZXRpemVkKHN0cnVjdCBmaWxlICpmaWxlKQoreworCXJldHVybiAoZmlsZS0+Zl9m
bGFncyAmIE9fRElSRUNUKSAhPSAwOworfQorCiBzdGF0aWMgc3NpemVfdAogcGlwZV9yZWFkKHN0
cnVjdCBraW9jYiAqaW9jYiwgY29uc3Qgc3RydWN0IGlvdmVjICpfaW92LAogCSAgIHVuc2lnbmVk
IGxvbmcgbnJfc2VncywgbG9mZl90IHBvcykKQEAgLTQwNyw3ICs0MTIsNyBAQCByZWRvOgogCQkJ
cmV0ICs9IGNoYXJzOwogCQkJYnVmLT5vZmZzZXQgKz0gY2hhcnM7CiAJCQlidWYtPmxlbiAtPSBj
aGFyczsKLQkJCWlmICghYnVmLT5sZW4pIHsKKwkJCWlmICghYnVmLT5sZW4gfHwgaXNfcGFja2V0
aXplZChmaWxwKSkgewogCQkJCWJ1Zi0+b3BzID0gTlVMTDsKIAkJCQlvcHMtPnJlbGVhc2UocGlw
ZSwgYnVmKTsKIAkJCQljdXJidWYgPSAoY3VyYnVmICsgMSkgJiAocGlwZS0+YnVmZmVycyAtIDEp
OwpAQCAtNDE2LDcgKzQyMSw3IEBAIHJlZG86CiAJCQkJZG9fd2FrZXVwID0gMTsKIAkJCX0KIAkJ
CXRvdGFsX2xlbiAtPSBjaGFyczsKLQkJCWlmICghdG90YWxfbGVuKQorCQkJaWYgKCF0b3RhbF9s
ZW4gfHwgaXNfcGFja2V0aXplZChmaWxwKSkKIAkJCQlicmVhazsJLyogY29tbW9uIHBhdGg6IHJl
YWQgc3VjY2VlZGVkICovCiAJCX0KIAkJaWYgKGJ1ZnMpCS8qIE1vcmUgdG8gZG8/ICovCkBAIC00
OTAsNyArNDk1LDcgQEAgcGlwZV93cml0ZShzdHJ1Y3Qga2lvY2IgKmlvY2IsIGNvbnN0IHN0cnVj
dCBpb3ZlYyAqX2lvdiwKIAogCS8qIFdlIHRyeSB0byBtZXJnZSBzbWFsbCB3cml0ZXMgKi8KIAlj
aGFycyA9IHRvdGFsX2xlbiAmIChQQUdFX1NJWkUtMSk7IC8qIHNpemUgb2YgdGhlIGxhc3QgYnVm
ZmVyICovCi0JaWYgKHBpcGUtPm5yYnVmcyAmJiBjaGFycyAhPSAwKSB7CisJaWYgKCFpc19wYWNr
ZXRpemVkKGZpbHApICYmIHBpcGUtPm5yYnVmcyAmJiBjaGFycyAhPSAwKSB7CiAJCWludCBsYXN0
YnVmID0gKHBpcGUtPmN1cmJ1ZiArIHBpcGUtPm5yYnVmcyAtIDEpICYKIAkJCQkJCQkocGlwZS0+
YnVmZmVycyAtIDEpOwogCQlzdHJ1Y3QgcGlwZV9idWZmZXIgKmJ1ZiA9IHBpcGUtPmJ1ZnMgKyBs
YXN0YnVmOwpAQCAtMTAxMyw3ICsxMDE4LDcgQEAgc3RydWN0IGZpbGUgKmNyZWF0ZV93cml0ZV9w
aXBlKGludCBmbGFncykKIAkJZ290byBlcnJfZGVudHJ5OwogCWYtPmZfbWFwcGluZyA9IGlub2Rl
LT5pX21hcHBpbmc7CiAKLQlmLT5mX2ZsYWdzID0gT19XUk9OTFkgfCAoZmxhZ3MgJiBPX05PTkJM
T0NLKTsKKwlmLT5mX2ZsYWdzID0gT19XUk9OTFkgfCAoZmxhZ3MgJiAoT19OT05CTE9DSyB8IE9f
RElSRUNUKSk7CiAJZi0+Zl92ZXJzaW9uID0gMDsKIAogCXJldHVybiBmOwpAQCAtMTA0Niw3ICsx
MDUxLDcgQEAgc3RydWN0IGZpbGUgKmNyZWF0ZV9yZWFkX3BpcGUoc3RydWN0IGZpbGUgKndyZiwg
aW50IGZsYWdzKQogCQlyZXR1cm4gRVJSX1BUUigtRU5GSUxFKTsKIAogCXBhdGhfZ2V0KCZ3cmYt
PmZfcGF0aCk7Ci0JZi0+Zl9mbGFncyA9IE9fUkRPTkxZIHwgKGZsYWdzICYgT19OT05CTE9DSyk7
CisJZi0+Zl9mbGFncyA9IE9fUkRPTkxZIHwgKGZsYWdzICYgKE9fTk9OQkxPQ0sgfCBPX0RJUkVD
VCkpOwogCiAJcmV0dXJuIGY7CiB9CkBAIC0xMDU3LDcgKzEwNjIsNyBAQCBpbnQgZG9fcGlwZV9m
bGFncyhpbnQgKmZkLCBpbnQgZmxhZ3MpCiAJaW50IGVycm9yOwogCWludCBmZHcsIGZkcjsKIAot
CWlmIChmbGFncyAmIH4oT19DTE9FWEVDIHwgT19OT05CTE9DSykpCisJaWYgKGZsYWdzICYgfihP
X0NMT0VYRUMgfCBPX05PTkJMT0NLIHwgT19ESVJFQ1QpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAog
CWZ3ID0gY3JlYXRlX3dyaXRlX3BpcGUoZmxhZ3MpOwo=
--f46d0442887e33ccb804beb17305--
