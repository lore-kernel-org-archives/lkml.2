Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2DSRAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:00:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52299 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2DSRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzbAMYqAHKURRneuLqAoE2=YScq7NNFmTjC1F9pHeWE6Q@mail.gmail.com>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
	<CAPM=9tzWO46u5L1jnRvi_zhgOhmzH1df7cQTnP6+0Kh4Znpn7g@mail.gmail.com>
	<20120419164113.GA3467@shadowen.org>
	<CAPM=9twXZyo6qkwunuYARVsZM8EDX4O0Dja6Kgp7ofXH2Gys3Q@mail.gmail.com>
	<CAPM=9txduppN_R9brXm8haattUn=jEOvQUaynN-vgxNerD7qUw@mail.gmail.com>
	<20120419095516.595649b3@jbarnes-desktop>
	<CAPM=9tzbAMYqAHKURRneuLqAoE2=YScq7NNFmTjC1F9pHeWE6Q@mail.gmail.com>
Date: Thu, 19 Apr 2012 18:00:48 +0100
Message-ID: <CAPM=9tzfYtjxjM6tkj3p2mo=teALApyFxU3QAUkCBpBFnp3DSQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andy Whitcroft <apw@canonical.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f235477151cf604be0b1d4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f235477151cf604be0b1d4b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>>
>>> On Thu, Apr 19, 2012 at 5:47 PM, Dave Airlie <airlied@gmail.com> wrote:
>>> > On Thu, Apr 19, 2012 at 5:41 PM, Andy Whitcroft <apw@canonical.com> w=
rote:
>>> >> On Thu, Apr 19, 2012 at 05:30:03PM +0100, Dave Airlie wrote:
>>> >>> On Thu, Apr 19, 2012 at 5:22 PM, Andy Whitcroft <apw@canonical.com>=
 wrote:
>>> >>> > We have been carrying a (rather poor) patch for an issue we ident=
ified in
>>> >>> > the DRM driver. =A0This issue is triggered when a DRM device is i=
nitialising
>>> >>> > and userspace attempts to open it, typically in response to the s=
ysfs
>>> >>> > device added event. =A0Basically we allocate the minor numbers ma=
king
>>> >>> > the device available, and then call the drm load callback. =A0Unt=
il this
>>> >>> > completes the device is really not ready and these early opens ty=
pically
>>> >>> > lead to oopses.
>>> >>> >
>>> >>> > We have been using the following patch to avoid this by marking t=
he minors
>>> >>> > as in error until the load method has completed. =A0This avoids t=
he early
>>> >>> > open by simply erroring out the opens with EAGAIN. =A0Obviously w=
e should
>>> >>> > be delaying the open until the load method complete.
>>> >>> >
>>> >>> > I include the existing patch for completness (it is not really re=
ady for
>>> >>> > merging) to illustrate the issue. =A0I think it is logical that t=
he wait
>>> >>> > should simply be delayed until the load has completed. =A0I am pr=
oposing
>>> >>> > to include a wait queue associated with the idr cache for the drm=
 minors
>>> >>> > which we can use to allow open callers to wait_event_interruptibl=
e() on.
>>> >>> > I'll be putting together a prototype shortly and will follow up w=
ith it.
>>> >>> >
>>> >>> > Thoughts?
>>> >>>
>>> >>> Couldn't we just delay registering things until the driver is ready=
 to
>>> >>> accept an open?
>>> >>>
>>> >>> Granted the midlayer of drm doesn't make that easy,
>>> >>
>>> >> It seems that we need the dri minor allocated before we hit the load
>>> >> function as things are done right now.
>>> >>
>>> >>> thanks for sending this out, it keeps falling off my radar, I don't
>>> >>> think I've ever seen this reported on RHEL/Fedora, which makes me
>>> >>> wonder what we are doing that makes us lucky.
>>> >>
>>> >> We never hit it until we started doing things earlier and quicker. =
=A0I first
>>> >> found it in the prettification of boot so we were keen to get plymou=
th
>>> >> running as soon as possible. =A0That lead to random panics and me fi=
nding
>>> >> this bug. =A0The window is tiny as far as I know and it tends to be =
specific
>>> >> machines and specific package combinations which trigger it reliably=
.
>>> >>
>>> >> I suspect that a proper fix would allow delaying the registration as=
 you
>>> >> suggest but in the interim a wait would at least avoid the issues we=
 are
>>> >> seeing. =A0I will see how awful it looks.
>>> >
>>> > Just to confirm its the drm_sysfs_device_add that causes the race we =
care about.
>>> >
>>> > it needs to happen after the driver is happy. Since it calls
>>> > device_register and that is what triggers udev magic to load the
>>> > userspace.
>>> >
>>> > If you have a userspace app banging on a static device node that migh=
t
>>> > need another set of fun fixes.
>>>
>>> Okay the sysfs add and the idr_replace are the things we need to delay.
>>
>> Since you can still get at things with a static node, it seems like
>> locking is the real issue here? =A0Is there no mutex we can take across
>> init to block any openers until we're done?
>
> well the idr replace should be the thing that matters, since before
> that openers get -ENODEV, after it they end up success.
> we may need a lock around that once we fix the logic.\

Here's my predinner hack, contains random rtl change as well, plz ignore.

now for dinner.

Dave.

--e89a8f235477151cf604be0b1d4b
Content-Type: application/octet-stream; name=myhack
Content-Disposition: attachment; filename=myhack
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h182375j0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fcGNpLmMgYi9kcml2ZXJzL2dwdS9kcm0v
ZHJtX3BjaS5jCmluZGV4IDEzZjNkOTMuLjIzYjQ3MmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1
L2RybS9kcm1fcGNpLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9wY2kuYwpAQCAtMzY3LDYg
KzM2NywxMSBAQCBpbnQgZHJtX2dldF9wY2lfZGV2KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25z
dCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50LAogCiAJbGlzdF9hZGRfdGFpbCgmZGV2LT5kcml2
ZXJfaXRlbSwgJmRyaXZlci0+ZGV2aWNlX2xpc3QpOwogCisJaWYgKGRybV9jb3JlX2NoZWNrX2Zl
YXR1cmUoZGV2LCBEUklWRVJfTU9ERVNFVCkpIHsKKwkJZHJtX2FjdGl2YXRlX21pbm9yKCZkZXYt
PmNvbnRyb2wpOworCX0KKwlkcm1fYWN0aXZhdGVfbWlub3IoJmRldi0+cHJpbWFyeSk7CisKIAlE
Uk1fSU5GTygiSW5pdGlhbGl6ZWQgJXMgJWQuJWQuJWQgJXMgZm9yICVzIG9uIG1pbm9yICVkXG4i
LAogCQkgZHJpdmVyLT5uYW1lLCBkcml2ZXItPm1ham9yLCBkcml2ZXItPm1pbm9yLCBkcml2ZXIt
PnBhdGNobGV2ZWwsCiAJCSBkcml2ZXItPmRhdGUsIHBjaV9uYW1lKHBkZXYpLCBkZXYtPnByaW1h
cnktPmluZGV4KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fc3R1Yi5jIGIvZHJp
dmVycy9ncHUvZHJtL2RybV9zdHViLmMKaW5kZXggYWE0NTRmOC4uNzAzYzA1YSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9ncHUvZHJtL2RybV9zdHViLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9z
dHViLmMKQEAgLTM1Nyw3ICszNTcsNyBAQCBpbnQgZHJtX2dldF9taW5vcihzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2LCBzdHJ1Y3QgZHJtX21pbm9yICoqbWlub3IsIGludCB0eXBlKQogCW5ld19taW5v
ci0+aW5kZXggPSBtaW5vcl9pZDsKIAlJTklUX0xJU1RfSEVBRCgmbmV3X21pbm9yLT5tYXN0ZXJf
bGlzdCk7CiAKLQlpZHJfcmVwbGFjZSgmZHJtX21pbm9yc19pZHIsIG5ld19taW5vciwgbWlub3Jf
aWQpOworCS8vaWRyX3JlcGxhY2UoJmRybV9taW5vcnNfaWRyLCBuZXdfbWlub3IsIG1pbm9yX2lk
KTsKIAogCWlmICh0eXBlID09IERSTV9NSU5PUl9MRUdBQ1kpIHsKIAkJcmV0ID0gZHJtX3Byb2Nf
aW5pdChuZXdfbWlub3IsIG1pbm9yX2lkLCBkcm1fcHJvY19yb290KTsKQEAgLTM3NSwxMyArMzc1
LDE0IEBAIGludCBkcm1fZ2V0X21pbm9yKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIHN0cnVjdCBk
cm1fbWlub3IgKiptaW5vciwgaW50IHR5cGUpCiAJCWdvdG8gZXJyX2cyOwogCX0KICNlbmRpZgot
CisjaWYgMAogCXJldCA9IGRybV9zeXNmc19kZXZpY2VfYWRkKG5ld19taW5vcik7CiAJaWYgKHJl
dCkgewogCQlwcmludGsoS0VSTl9FUlIKIAkJICAgICAgICJEUk06IEVycm9yIHN5c2ZzX2Rldmlj
ZV9hZGQuXG4iKTsKIAkJZ290byBlcnJfZzI7CiAJfQorI2VuZGlmCiAJKm1pbm9yID0gbmV3X21p
bm9yOwogCiAJRFJNX0RFQlVHKCJuZXcgbWlub3IgYXNzaWduZWQgJWRcbiIsIG1pbm9yX2lkKTsK
QEAgLTQwMCw2ICs0MDEsMTggQEAgZXJyX2lkcjoKIH0KIEVYUE9SVF9TWU1CT0woZHJtX2dldF9t
aW5vcik7CiAKK2ludCBkcm1fYWN0aXZhdGVfbWlub3Ioc3RydWN0IGRybV9taW5vciAqbWlub3Ip
Cit7CisJaW50IHJldDsKKwlpZHJfcmVwbGFjZSgmZHJtX21pbm9yc19pZHIsIG1pbm9yLCBtaW5v
ci0+aW5kZXgpOworCXJldCA9IGRybV9zeXNmc19kZXZpY2VfYWRkKG1pbm9yKTsKKwlpZiAocmV0
KSB7CisJCXByaW50ayhLRVJOX0VSUiAiRFJNOiBFcnJvciBzeXNmc19kZXZpY2VfYWRkLlxuIik7
CisJfQorCXJldHVybiByZXQ7Cit9CitFWFBPUlRfU1lNQk9MKGRybV9hY3RpdmF0ZV9taW5vcik7
CisKIC8qKgogICogUHV0IGEgc2Vjb25kYXJ5IG1pbm9yIG51bWJlci4KICAqCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsd2lmaS9wY2kuYwppbmRleCAyODhiMDM1Li5jYzE1ZmRiIDEwMDY0NAotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0bHdpZmkvcGNpLmMKQEAgLTE5NDEsNiArMTk0MSw3IEBAIHZvaWQgcnRsX3BjaV9kaXNjb25u
ZWN0KHN0cnVjdCBwY2lfZGV2ICpwZGV2KQogCQlydGxfZGVpbml0X2RlZmVycmVkX3dvcmsoaHcp
OwogCQlydGxwcml2LT5pbnRmX29wcy0+YWRhcHRlcl9zdG9wKGh3KTsKIAl9CisJcnRscHJpdi0+
Y2ZnLT5vcHMtPmRpc2FibGVfaW50ZXJydXB0KGh3KTsKIAogCS8qZGVpbml0IHJma2lsbCAqLwog
CXJ0bF9kZWluaXRfcmZraWxsKGh3KTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvZHJtL2RybVAuaCBi
L2luY2x1ZGUvZHJtL2RybVAuaAppbmRleCBkZDczMTA0Li4zYTU2MDZmIDEwMDY0NAotLS0gYS9p
bmNsdWRlL2RybS9kcm1QLmgKKysrIGIvaW5jbHVkZS9kcm0vZHJtUC5oCkBAIC0xNTA2LDYgKzE1
MDYsNyBAQCBleHRlcm4gdm9pZCBkcm1fbWFzdGVyX3B1dChzdHJ1Y3QgZHJtX21hc3RlciAqKm1h
c3Rlcik7CiAKIGV4dGVybiB2b2lkIGRybV9wdXRfZGV2KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYp
OwogZXh0ZXJuIGludCBkcm1fcHV0X21pbm9yKHN0cnVjdCBkcm1fbWlub3IgKiptaW5vcik7Citl
eHRlcm4gaW50IGRybV9hY3RpdmF0ZV9taW5vcihzdHJ1Y3QgZHJtX21pbm9yICptaW5vcik7CiBl
eHRlcm4gdm9pZCBkcm1fdW5wbHVnX2RldihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KTsKIGV4dGVy
biB1bnNpZ25lZCBpbnQgZHJtX2RlYnVnOwogCg==
--e89a8f235477151cf604be0b1d4b--
