Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0LPPiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:38:54 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42379 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0LPPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=a8MwJNzICjgw0tYHzI+l7rKunJGMTPOqoNuRbwq1EGqI1Eu/bBIiK2x4M44hISZZP6
         oBbHj2O6SeRTlfzkPNHciKSCqkTur0p7Jf924vqFCFinq9q/A7nNuNnQ3dx1Ngfk5URp
         691OZ6ekqaDX/S3CCJrNrvwbVw6K1BYo5yyWc=
MIME-Version: 1.0
In-Reply-To: <20101216103550.GA5946@sortiz-mobl>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
	<20101216103550.GA5946@sortiz-mobl>
Date: Thu, 16 Dec 2010 15:38:52 +0000
X-Google-Sender-Auth: KjlFwdF9qqp8WQa5PNlvx4mOPoE
Message-ID: <AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
Subject: Re: MFD cell structure and sharing of resources
From: Daniel Drake <dsd@laptop.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Fox <pgf@laptop.org>, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e644cb7cd0e562049788d9a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e644cb7cd0e562049788d9a1
Content-Type: text/plain; charset=ISO-8859-1

Hi Samuel,

Thanks for your valuable input here!

On 16 December 2010 10:35, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> 2. Continue with Andres' olpc-xo1-pm patch that makes that driver act
>> as a driver for both acpi & pms. When both resources are available, it
>> could probe an olpc-xo1-sci platform device as a child of itself,
>> having the ACPI resource shared on the platform_device level (similar
>> to how MFD shares resources via cells).
> This sounds like an acceptable solution to me.

This is also the one that stuck out to me.

There are complications though.


Firstly, passing down the resources from mfd to olpc-xo1-pm, then from
olpc-xo1-pm using "struct resource" doesn't work - the 2nd passing
down fails because the platform layer checks that the resources are
free.

This can be worked around by using platform_data to pass the required
info from olpc-xo1-pm to olpc-xo1-sci (the base register addresses).


Secondly, the olpc-xo1-pm driver is going to have a couple of sysfs
nodes that will be used by userspace.

Under the current design they appear as e.g.:
/sys/devices/pci0000:00/0000:00:0f.0/cs5535-acpi/wakeup_reason

However, it only appears under cs5535-acpi because that's the device
that appeared second (out of acpi + pms). If the probe order ever
changed, the path would change too.
This could be worked around by storing both pointers (acpi + pms) and
choosing one that the olpc-xo1-pm parts will always live under. But as
this detail represents an interface to userspace we should be careful
and try and get it right first time. That wakeup_reason node is not
really related to cs5535, it's an OLPC-specific thing (since the
wakeups can be caused by things totally separate from the geode hw).
So I'd feel a lot more comfortable if that path was less related to
cs5535.

This problem extends to olpc-xo1-sci which becomes a child of
olpc-xo1-pm, and creates another bunch of sysfs nodes e.g.
/sys/devices/pci0000:00/0000:00:0f.0/cs5535-acpi/olpc-xo1-sci/lid_wake_mode



I have one solution in mind but I'm not sure if it goes beyond your
definition of what a mfd cell should be:

cs5535-mfd creates and registers a MFD cell specifically for
olpc-xo1-pm if it finds itself running on an XO laptop. The cell has
the 2 resources that are needed by that driver, and has name
"olpc-xo1-pm". Therefore our sysfs paths start with:
/sys/devices/pci0000:00/0000:00:0f.0/olpc-xo1-pm/

olpc-xo1-pm is then simplified and doesn't have to pretend to be a
driver for 2 devices. It just waits for that mfd cell to cause it to
be probed, then immediately has both resources available to it.

The first problem is also solved (clean sharing of resources between
olpc-xo1-pm and olpc-xo1-sci). olpc-xo1-pm creates olpc-xo1-sci as a
child device, therefore olpc-xo1-sci can access the resources of its
parent as follows:
    platform_get_resource(to_platform_device(pdev->dev.parent),
IORESOURCE_IO, 0);

Attaching a cs5535-mfd patch to illustrate what I mean a bit clearer
(compile tested only). The OLPC-specific code in cs5536-mfd compiles
away to nothing on CONFIG_OLPC=n

Thoughts?

Daniel

--0016e644cb7cd0e562049788d9a1
Content-Type: text/plain; charset=US-ASCII; name="mfd-scratch.txt"
Content-Disposition: attachment; filename="mfd-scratch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghrth4pf0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BsYXRmb3JtL29scGMvb2xwYy14bzEuYyBiL2FyY2gveDg2
L3BsYXRmb3JtL29scGMvb2xwYy14bzEuYwppbmRleCAxMjc3NzU2Li40NzIzMTM5IDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9wbGF0Zm9ybS9vbHBjL29scGMteG8xLmMKKysrIGIvYXJjaC94ODYvcGxh
dGZvcm0vb2xwYy9vbHBjLXhvMS5jCkBAIC0xOSw3ICsxOSw3IEBACiAjaW5jbHVkZSA8YXNtL2lv
Lmg+CiAjaW5jbHVkZSA8YXNtL29scGMuaD4KIAotI2RlZmluZSBEUlZfTkFNRSAib2xwYy14bzEi
CisjZGVmaW5lIERSVl9OQU1FICJvbHBjLXhvMS1wbSIKIAogLyogUE1DIHJlZ2lzdGVycyAoUE1T
IGJsb2NrKSAqLwogI2RlZmluZSBQTV9TQ0xLCQkweDEwCkBAIC03MiwxNyArNzIsMjMgQEAgc3Rh
dGljIGludCBfX2RldmluaXQgb2xwY194bzFfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAq
cGRldikKIAkJcmV0dXJuIC1FSU87CiAJfQogCi0JaWYgKHN0cmNtcChwZGV2LT5uYW1lLCAiY3M1
NTM1LXBtcyIpID09IDApCi0JCXBtc19iYXNlID0gcmVzLT5zdGFydDsKLQllbHNlIGlmIChzdHJj
bXAocGRldi0+bmFtZSwgImNzNTUzNS1hY3BpIikgPT0gMCkKLQkJYWNwaV9iYXNlID0gcmVzLT5z
dGFydDsKKwlwbXNfYmFzZSA9IHJlcy0+c3RhcnQ7CiAKLQkvKiBJZiB3ZSBoYXZlIGJvdGggYWRk
cmVzc2VzLCB3ZSBjYW4gb3ZlcnJpZGUgdGhlIHBvd2Vyb2ZmIGhvb2sgKi8KLQlpZiAocG1zX2Jh
c2UgJiYgYWNwaV9iYXNlKSB7Ci0JCXBtX3Bvd2VyX29mZiA9IHhvMV9wb3dlcl9vZmY7Ci0JCXBy
aW50ayhLRVJOX0lORk8gIk9MUEMgWE8tMSBzdXBwb3J0IHJlZ2lzdGVyZWRcbiIpOworCXJlcyA9
IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX0lPLCAxKTsKKwlpZiAoIXJl
cykgeworCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJjYW4ndCBmZXRjaCBkZXZpY2UgcmVzb3VyY2Ug
aW5mb1xuIik7CisJCXJldHVybiAtRUlPOwogCX0KIAorCWlmICghcmVxdWVzdF9yZWdpb24ocmVz
LT5zdGFydCwgcmVzb3VyY2Vfc2l6ZShyZXMpLCBEUlZfTkFNRSkpIHsKKwkJZGV2X2VycigmcGRl
di0+ZGV2LCAiY2FuJ3QgcmVxdWVzdCByZWdpb25cbiIpOworCQlyZXR1cm4gLUVJTzsKKwl9CisK
KwlhY3BpX2Jhc2UgPSByZXMtPnN0YXJ0OworCisJcG1fcG93ZXJfb2ZmID0geG8xX3Bvd2VyX29m
ZjsKKwlwcmludGsoS0VSTl9JTkZPICJPTFBDIFhPLTEgc3VwcG9ydCByZWdpc3RlcmVkXG4iKTsK
IAlyZXR1cm4gMDsKIH0KIApAQCAtOTMsMjcgKzk5LDE5IEBAIHN0YXRpYyBpbnQgX19kZXZleGl0
IG9scGNfeG8xX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCXIgPSBwbGF0
Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9JTywgMCk7CiAJcmVsZWFzZV9yZWdp
b24oci0+c3RhcnQsIHJlc291cmNlX3NpemUocikpOwogCi0JaWYgKHN0cmNtcChwZGV2LT5uYW1l
LCAiY3M1NTM1LXBtcyIpID09IDApCi0JCXBtc19iYXNlID0gMDsKLQllbHNlIGlmIChzdHJjbXAo
cGRldi0+bmFtZSwgImNzNTUzNS1hY3BpIikgPT0gMCkKLQkJYWNwaV9iYXNlID0gMDsKKwlyID0g
cGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfSU8sIDEpOworCXJlbGVhc2Vf
cmVnaW9uKHItPnN0YXJ0LCByZXNvdXJjZV9zaXplKHIpKTsKKworCXBtc19iYXNlID0gMDsKKwlh
Y3BpX2Jhc2UgPSAwOwogCiAJcG1fcG93ZXJfb2ZmID0gTlVMTDsKIAlyZXR1cm4gMDsKIH0KIAot
c3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgY3M1NTM1X3Btc19kcnYgPSB7CitzdGF0aWMg
c3RydWN0IHBsYXRmb3JtX2RyaXZlciB4bzFfcG1fZHJ2ID0gewogCS5kcml2ZXIgPSB7Ci0JCS5u
YW1lID0gImNzNTUzNS1wbXMiLAotCQkub3duZXIgPSBUSElTX01PRFVMRSwKLQl9LAotCS5wcm9i
ZSA9IG9scGNfeG8xX3Byb2JlLAotCS5yZW1vdmUgPSBfX2RldmV4aXRfcChvbHBjX3hvMV9yZW1v
dmUpLAotfTsKLQotc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgY3M1NTM1X2FjcGlfZHJ2
ID0gewotCS5kcml2ZXIgPSB7Ci0JCS5uYW1lID0gImNzNTUzNS1hY3BpIiwKKwkJLm5hbWUgPSBE
UlZfTkFNRSwKIAkJLm93bmVyID0gVEhJU19NT0RVTEUsCiAJfSwKIAkucHJvYmUgPSBvbHBjX3hv
MV9wcm9iZSwKQEAgLTEyMiwyOCArMTIwLDE3IEBAIHN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJp
dmVyIGNzNTUzNV9hY3BpX2RydiA9IHsKIAogc3RhdGljIGludCBfX2luaXQgb2xwY194bzFfaW5p
dCh2b2lkKQogewotCWludCByOwotCi0JciA9IHBsYXRmb3JtX2RyaXZlcl9yZWdpc3RlcigmY3M1
NTM1X3Btc19kcnYpOwotCWlmIChyKQotCQlyZXR1cm4gcjsKLQotCXIgPSBwbGF0Zm9ybV9kcml2
ZXJfcmVnaXN0ZXIoJmNzNTUzNV9hY3BpX2Rydik7Ci0JaWYgKHIpCi0JCXBsYXRmb3JtX2RyaXZl
cl91bnJlZ2lzdGVyKCZjczU1MzVfcG1zX2Rydik7Ci0KLQlyZXR1cm4gcjsKKwlyZXR1cm4gcGxh
dGZvcm1fZHJpdmVyX3JlZ2lzdGVyKCZ4bzFfcG1fZHJ2KTsKIH0KIAogc3RhdGljIHZvaWQgX19l
eGl0IG9scGNfeG8xX2V4aXQodm9pZCkKIHsKLQlwbGF0Zm9ybV9kcml2ZXJfdW5yZWdpc3Rlcigm
Y3M1NTM1X2FjcGlfZHJ2KTsKLQlwbGF0Zm9ybV9kcml2ZXJfdW5yZWdpc3RlcigmY3M1NTM1X3Bt
c19kcnYpOworCXBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVyKCZ4bzFfcG1fZHJ2KTsKIH0KIAog
TU9EVUxFX0FVVEhPUigiRGFuaWVsIERyYWtlIDxkc2RAbGFwdG9wLm9yZz4iKTsKIE1PRFVMRV9M
SUNFTlNFKCJHUEwiKTsKLU1PRFVMRV9BTElBUygicGxhdGZvcm06b2xwYy14bzEiKTsKK01PRFVM
RV9BTElBUygicGxhdGZvcm06IiBEUlZfTkFNRSk7CiAKIG1vZHVsZV9pbml0KG9scGNfeG8xX2lu
aXQpOwogbW9kdWxlX2V4aXQob2xwY194bzFfZXhpdCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL21m
ZC9LY29uZmlnIGIvZHJpdmVycy9tZmQvS2NvbmZpZwppbmRleCAzYTdiODkxLi4yMDMyNDVkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21mZC9LY29uZmlnCisrKyBiL2RyaXZlcnMvbWZkL0tjb25maWcK
QEAgLTU0MCw3ICs1NDAsNyBAQCBjb25maWcgQUIzNTUwX0NPUkUKIGNvbmZpZyBNRkRfQ1M1NTM1
CiAJdHJpc3RhdGUgIlN1cHBvcnQgZm9yIENTNTUzNSBhbmQgQ1M1NTM2IHNvdXRoYnJpZGdlIGNv
cmUgZnVuY3Rpb25zIgogCXNlbGVjdCBNRkRfQ09SRQotCWRlcGVuZHMgb24gUENJCisJZGVwZW5k
cyBvbiBQQ0kgJiYgWDg2CiAJLS0taGVscC0tLQogCSAgVGhpcyBpcyB0aGUgY29yZSBkcml2ZXIg
Zm9yIENTNTUzNS9DUzU1MzYgTUZEIGZ1bmN0aW9ucy4gIFRoaXMgaXMKICAgICAgICAgICBuZWNl
c3NhcnkgZm9yIHVzaW5nIHRoZSBib2FyZCdzIEdQSU8gYW5kIE1GR1BUIGZ1bmN0aW9uYWxpdHku
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9jczU1MzUtbWZkLmMgYi9kcml2ZXJzL21mZC9jczU1
MzUtbWZkLmMKaW5kZXggNTljYTZmMS4uOWVmNWRkOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZmQv
Y3M1NTM1LW1mZC5jCisrKyBiL2RyaXZlcnMvbWZkL2NzNTUzNS1tZmQuYwpAQCAtMjgsNiArMjgs
OCBAQAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L3BjaS5oPgog
CisjaW5jbHVkZSA8YXNtL29scGMuaD4KKwogI2RlZmluZSBEUlZfTkFNRSAiY3M1NTM1LW1mZCIK
IAogZW51bSBjczU1MzVfbWZkX2JhcnMgewpAQCAtNzQsNiArNzYsMTUgQEAgc3RhdGljIF9fZGV2
aW5pdGRhdGEgc3RydWN0IG1mZF9jZWxsIGNzNTUzNV9tZmRfY2VsbHNbXSA9IHsKIAl9LAogfTsK
IAorc3RhdGljIF9fZGV2aW5pdGRhdGEgc3RydWN0IHJlc291cmNlIGNzNTUzNV9tZmRfcmVzb3Vy
Y2VzX3hvMVsyXTsKKworc3RhdGljIF9fZGV2aW5pdGRhdGEgc3RydWN0IG1mZF9jZWxsIGNzNTUz
NV9tZmRfY2VsbF94bzEgPSB7CisJLmlkID0gLTEsCisJLm5hbWUgPSAib2xwYy14bzEtcG0iLAor
CS5udW1fcmVzb3VyY2VzID0gMiwKKwkucmVzb3VyY2VzID0gY3M1NTM1X21mZF9yZXNvdXJjZXNf
eG8xLAorfTsKKwogc3RhdGljIGludCBfX2RldmluaXQgY3M1NTM1X21mZF9wcm9iZShzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwKIAkJY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQogewpAQCAt
MTA2LDggKzExNywyMiBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBjczU1MzVfbWZkX3Byb2JlKHN0
cnVjdCBwY2lfZGV2ICpwZGV2LAogCWRldl9pbmZvKCZwZGV2LT5kZXYsICIlenUgZGV2aWNlcyBy
ZWdpc3RlcmVkLlxuIiwKIAkJCUFSUkFZX1NJWkUoY3M1NTM1X21mZF9jZWxscykpOwogCisJaWYg
KG1hY2hpbmVfaXNfb2xwYygpKSB7CisJCWNzNTUzNV9tZmRfcmVzb3VyY2VzX3hvMVswXSA9IGNz
NTUzNV9tZmRfcmVzb3VyY2VzW1BNU19CQVJdOworCQljczU1MzVfbWZkX3Jlc291cmNlc194bzFb
MV0gPSBjczU1MzVfbWZkX3Jlc291cmNlc1tBQ1BJX0JBUl07CisJCWVyciA9IG1mZF9hZGRfZGV2
aWNlcygmcGRldi0+ZGV2LCAtMSwgJmNzNTUzNV9tZmRfY2VsbF94bzEsIDEsCisJCQkJICAgICAg
TlVMTCwgMCk7CisJCWlmIChlcnIpIHsKKwkJCWRldl9lcnIoJnBkZXYtPmRldiwKKwkJCQkiTUZE
IGFkZCBPTFBDIGRldmljZSBmYWlsOiAlZFxuIiwgZXJyKTsKKwkJCWdvdG8gZXJyX29scGM7CisJ
CX0KKwl9CisKIAlyZXR1cm4gMDsKIAorZXJyX29scGM6CisJbWZkX3JlbW92ZV9kZXZpY2VzKCZw
ZGV2LT5kZXYpOwogZXJyX2Rpc2FibGU6CiAJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOwogCXJl
dHVybiBlcnI7Cg==
--0016e644cb7cd0e562049788d9a1--
