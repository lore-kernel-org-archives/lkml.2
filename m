Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1I0Oo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:44:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64713 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1I0Oo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110921131637.GF4374@opensource.wolfsonmicro.com>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
	<20110921124936.GA25620@sirena.org.uk>
	<CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
	<20110921131637.GF4374@opensource.wolfsonmicro.com>
Date: Tue, 27 Sep 2011 15:44:56 +0100
X-Google-Sender-Auth: y4l5RWR-sWPWhCMvFbbeA0iMzi0
Message-ID: <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: multipart/mixed; boundary=20cf30050d72b549b004aded5153
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30050d72b549b004aded5153
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2011 at 2:16 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> Not sure how the MFD cells could get at the OF node by using the
>> parent device - if the parent device had a OF node, wouldn't this
>> correspond to the parent instead of the child? Also, as far as I can
>
> Well, obviously. =A0But then with a lot of MFDs (including this one, the
> GPIO driver is entirely specific to the parent) it's not clear that we
> should be splitting the device up in the device tree in the first place
> - our use of MFDs is a Linux implementation detail. =A0If the child is
> specific to the parent it can cooperate with the parent device happily.
>
> My suspicion is that for device tree in cases where the MFD really is
> totally independent of the parent we shouldn't need explicit MFD code to
> instantiate the child at all any more in the same way that we should be
> avoiding this for the SoCs.

The VX855 is somewhat a SoC if you ignore the fact that the processor
is separate.
The software-visible architecture is somewhat messy and may hide this howev=
er.

The fact that it exposes some things as individual PCI devices and
some as behind the ISA bridge (which the mfd driver latches onto) is
probably just there for legacy reasons. Once you get behind that
cover, you see that the VX855 register space is really quite
disorganised with individual bits within the same byte of
configuration space used for vastly different system components (e.g.
gpio bits mixed with acpi and audio stuff in the same byte) and you
get the feeling that this really is a lot of hardware combined. So the
discussion of "independence" is particularly tricky in this case.

Anyway, I think I have come up with an approach on these lines. The
mfd driver latches onto the ISA bridge, and the documented
architecture suggests that a whole bunch of stuff comes off this:
8042, interrupt controller, dma controller, rtc, serial, timer, gpio,
spi, ...

We already have this accurately laid out in the device tree hierarchy:
/pci/isa/ has a child node for each of the above mentioned things
(e.g. /pci/isa/timer , /pci/isa/rtc and so on)

So, the /pci/isa node nicely matches the vx855-mfd driver, so we can
assign its of_node to that. Then, the vx855-gpio driver can consult
the parent and then look at its children in order to find the of_node
for the gpio controller. I think this nicely crosses with Mark's
request that the ability to have constant mfd definitions isn't broken
any more than it is already, and with Grant's preference that the
parent resource has some contribution in helping the child gpio
controller driver find its of_node. How does the attached patch look?

Grant, what do you think of this, and the rest of the discussion so far?

Daniel (just trying to make our gpio-based HDD LED go blinky blink...)

--20cf30050d72b549b004aded5153
Content-Type: text/plain; charset=US-ASCII; name="vx855.txt"
Content-Disposition: attachment; filename="vx855.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt2zys1y0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3Bpby9ncGlvLXZ4ODU1LmMgYi9kcml2ZXJzL2dwaW8vZ3Bp
by12eDg1NS5jCmluZGV4IGVmNWFhYmQuLmZkMjQyMTMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3Bp
by9ncGlvLXZ4ODU1LmMKKysrIGIvZHJpdmVycy9ncGlvL2dwaW8tdng4NTUuYwpAQCAtMzEsNiAr
MzEsNyBAQAogI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgogI2luY2x1ZGUgPGxp
bnV4L3BjaS5oPgogI2luY2x1ZGUgPGxpbnV4L2lvLmg+CisjaW5jbHVkZSA8bGludXgvb2YuaD4K
IAogI2RlZmluZSBNT0RVTEVfTkFNRSAidng4NTVfZ3BpbyIKIApAQCAtMjAxLDcgKzIwMiwyNyBA
QCBzdGF0aWMgY29uc3QgY2hhciAqdng4NTVncGlvX25hbWVzW05SX1ZYODU1X0dQXSA9IHsKIAki
Vlg4NTVfR1BJTzEyIiwgIlZYODU1X0dQSU8xMyIsICJWWDg1NV9HUElPMTQiCiB9OwogCi1zdGF0
aWMgdm9pZCB2eDg1NWdwaW9fZ3Bpb19zZXR1cChzdHJ1Y3Qgdng4NTVfZ3BpbyAqdmcpCitzdGF0
aWMgdm9pZCB2eDg1NWdwaW9fc2V0X29mX25vZGUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
diwKKwkJCQkgIHN0cnVjdCBncGlvX2NoaXAgKmMpCit7CisjaWZkZWYgQ09ORklHX09GCisJc3Ry
dWN0IGRldmljZV9ub2RlICpwYXJlbnRfbm9kZSA9IHBkZXYtPmRldi5wYXJlbnQtPm9mX25vZGU7
CisJc3RydWN0IGRldmljZV9ub2RlICpjaGlsZDsKKworCWlmICghcGFyZW50X25vZGUpCisJCXJl
dHVybjsKKworCWZvcl9lYWNoX2NoaWxkX29mX25vZGUocGFyZW50X25vZGUsIGNoaWxkKSB7CisJ
CWlmIChvZl9kZXZpY2VfaXNfY29tcGF0aWJsZShjaGlsZCwgInZpYSx2eDg1NS1ncGlvIikpIHsK
KwkJCWMtPm9mX25vZGUgPSBjaGlsZDsKKwkJCWJyZWFrOworCQl9CisJfQorI2VuZGlmCit9CisK
K3N0YXRpYyB2b2lkIHZ4ODU1Z3Bpb19ncGlvX3NldHVwKHN0cnVjdCB2eDg1NV9ncGlvICp2ZywK
KwkJCQkgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIHsKIAlzdHJ1Y3QgZ3Bpb19jaGlw
ICpjID0gJnZnLT5ncGlvOwogCkBAIC0yMTYsNiArMjM3LDcgQEAgc3RhdGljIHZvaWQgdng4NTVn
cGlvX2dwaW9fc2V0dXAoc3RydWN0IHZ4ODU1X2dwaW8gKnZnKQogCWMtPm5ncGlvID0gTlJfVlg4
NTVfR1A7CiAJYy0+Y2FuX3NsZWVwID0gMDsKIAljLT5uYW1lcyA9IHZ4ODU1Z3Bpb19uYW1lczsK
Kwl2eDg1NWdwaW9fc2V0X29mX25vZGUocGRldiwgYyk7CiB9CiAKIC8qIFRoaXMgcGxhdGZvcm0g
ZGV2aWNlIGlzIG9yZGluYXJpbHkgcmVnaXN0ZXJlZCBieSB0aGUgdng4NTUgbWZkIGRyaXZlciAq
LwpAQCAtMjY0LDcgKzI4Niw3IEBAIHN0YXRpYyBfX2RldmluaXQgaW50IHZ4ODU1Z3Bpb19wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWVsc2UKIAkJdmctPmdwb19yZXNlcnZl
ZCA9IHRydWU7CiAKLQl2eDg1NWdwaW9fZ3Bpb19zZXR1cCh2Zyk7CisJdng4NTVncGlvX2dwaW9f
c2V0dXAodmcsIHBkZXYpOwogCiAJcmV0ID0gZ3Bpb2NoaXBfYWRkKCZ2Zy0+Z3Bpbyk7CiAJaWYg
KHJldCkgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZmQvdng4NTUuYyBiL2RyaXZlcnMvbWZkL3Z4
ODU1LmMKaW5kZXggZDY5ODcwMy4uYWVlOWE1ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZmQvdng4
NTUuYworKysgYi9kcml2ZXJzL21mZC92eDg1NS5jCkBAIC0zMCw2ICszMCw3IEBACiAjaW5jbHVk
ZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+CiAjaW5jbHVkZSA8bGludXgvcGNpLmg+CiAjaW5j
bHVkZSA8bGludXgvbWZkL2NvcmUuaD4KKyNpbmNsdWRlIDxsaW51eC9vZi5oPgogCiAvKiBvZmZz
ZXQgaW50byBwY2kgY29uZmlnIHNwYWNlIGluZGljYXRpbmcgdGhlIDE2Yml0IHJlZ2lzdGVyIGNv
bnRhaW5pbmcKICAqIHRoZSBwb3dlciBtYW5hZ2VtZW50IElPIHNwYWNlIGJhc2UgKi8KQEAgLTkw
LDYgKzkxLDEwIEBAIHN0YXRpYyBfX2RldmluaXQgaW50IHZ4ODU1X3Byb2JlKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2LAogCQlnb3RvIG91dDsKIAl9CiAKKyNpZmRlZiBDT05GSUdfT0YKKwlwZGV2LT5k
ZXYub2Zfbm9kZSA9IG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlKE5VTEwsIE5VTEwsICJ2aWEsdng4
NTUtaXNhIik7CisjZW5kaWYKKwogCS8qIG1hc2sgb3V0IHRoZSBsb3dlc3Qgc2V2ZW4gYml0cywg
YXMgdGhleSBhcmUgYWx3YXlzIHplcm8sIGJ1dAogCSAqIGhhcmR3YXJlIHJldHVybnMgdGhlbSBh
cyAweDAxICovCiAJZ3Bpb19pb19vZmZzZXQgJj0gMHhmZjgwOwo=
--20cf30050d72b549b004aded5153--
