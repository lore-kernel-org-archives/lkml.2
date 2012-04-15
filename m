Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2DOUFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:05:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2DOUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:05:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F8B0609.8010603@snewbury.org.uk>
References: <1333968563.5678.19.camel@infinity>
	<4F848357.3060007@snewbury.org.uk>
	<CAE9FiQXTgh3X4x+xD1T0ipsEbhbPtctYucfGeuWK=cq7kHeZ1Q@mail.gmail.com>
	<4F848E10.1090703@snewbury.org.uk>
	<CAE9FiQXvwYrJhLi91VDVtD4+OOfbGQ1U20-Cap+8tBZUt7QCkA@mail.gmail.com>
	<1334089568.4083.2.camel@Nokia-N900>
	<CAE9FiQWnvB2VbBQQaEnDE0nf+Zwy6nyoGrEuVrUesQEzgYfbvA@mail.gmail.com>
	<4F84A3EC.6030903@snewbury.org.uk>
	<CAE9FiQU+EEtBWrc66Sw4GFQjSy9Vh9fyFvhgQUheev_aVpAzrw@mail.gmail.com>
	<1334229754.30606.7.camel@Nokia-N900>
	<CAE9FiQXhzAOErMeQxz6U-BSYAK1LirHMpiFH90iRoXxwduPhPw@mail.gmail.com>
	<1334248841.2910.6.camel@Nokia-N900>
	<4F89B5E8.3040906@snewbury.org.uk>
	<4F89BC84.50308@snewbury.org.uk>
	<4F89C513.3000006@snewbury.org.uk>
	<4F89CB16.2000908@snewbury.org.uk>
	<4F89CE43.7040200@snewbury.org.uk>
	<CAE9FiQVwDNM9MkqG_g139LDf6Ypjx0uygzVqosDe=fF=c_Y3gA@mail.gmail.com>
	<4F8AA0DC.6010902@snewbury.org.uk>
	<4F8AB312.7060606@snewbury.org.uk>
	<4F8B04A4.4070507@snewbury.org.uk>
	<4F8B0609.8010603@snewbury.org.uk>
Date: Sun, 15 Apr 2012 13:05:11 -0700
X-Google-Sender-Auth: ENaRBSVtx3P_lOnqKXSfIv7xPcM
Message-ID: <CAE9FiQUsQjUNeW1sa_mQL6MEaDhxvoMhFaN9wLPAqOXzh+AXPQ@mail.gmail.com>
Subject: Re: PCI resources above 4GB
From: Yinghai Lu <yinghai@kernel.org>
To: Steven Newbury <steve@snewbury.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, Dave Airlie <airlied@linux.ie>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b339bb51d66c604bdbd3960
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b339bb51d66c604bdbd3960
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 15, 2012 at 10:31 AM, Steven Newbury <steve@snewbury.org.uk> wr=
ote:
>>>>>>>
>>>>>>> pci 0000:03:08.0: BAR 15: can't assign mem pref (size
>>>>>>> 0x18000000)
>>>>>> Ah! Not enough space for the bridge window!:(
>>>>>>
>>
>>>>> please append pci=3Dnorom ...
>>
>>>> That worked. =A0Except of course the radeon driver can't POST the
>>>> =A0card without the ROM! :-P
>>> Can the ROM resource be mapped above 4G?
>> I didn't really think that through, obviously it can't because
>> it's not on a 64-bit capable bridge. =A0I wonder though, could it be
>> shadowed then disabled early before the IOMEM?
> I see there's "#if 0"'d helper functions for exactly that in rom.c.
> They've been disabled since 2007!

solution could be one of three:
1. when bridge support 64bit pref, will not allocate rom bar in bridge
pref resource.
=3D=3D=3D=3D> patch: rom_pref.patch

2. unconditionally to make rom bar allocation in bridge non-pref range.
=3D=3D=3D=3D> patch: rom_no_pref.patch
Looks like BIOS and at least one of other OSes is doing that.

I can not find the the history why ROM res is with PREFETCH bit set.
Maybe Linus has some idea about that.

3. use pci_bus_allocate_resource in drm/radeon driver ... =3D=3D=3D> but
that could fail.
   so could hack it like a. disable bar 0x10 and steal BAR address,
then set 0x30 to that address then copy ROM to ram.
   after that, disable rom again and set back address to 0x10.
   You try to update radeon_get_bios() to achieve that.

      Yinghai

--047d7b339bb51d66c604bdbd3960
Content-Type: application/octet-stream; name="rom_pref.patch"
Content-Disposition: attachment; filename="rom_pref.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h12iezge0

U3ViamVjdDogW1BBVENIXSBQQ0k6IERvbid0IGxldCBST00gYmFyIHJlZHVjZSBjaGFuY2UgdG8g
cHJlZiBtZW02NAoKTm93IHJvbSByZXNvdXJjZSBpcyBzZXQgdG8gUFJFRkVUQ0gsIGJ1dCBpcyBu
b3QgTUVNXzY0LCBTbyBpdCB3b3VsZAptYWtlIHRoZSB3aG9sZSBicmlkZ2Ugbm90IHVzZSBwcmVm
IGFib3ZlIDRnLgoKSW4gdGhhdCBjYXNlLCBqdXN0IGNsZWFyIFBSRUZFVENIIGZvciB0aGF0IHJv
bSByZXNvdXJjZSwgYW5kIHB1c2ggaXQKdG8gYnJpZGdlIHJlc291cmNlIHdpdGhvdXQgcHJlZi4K
ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KLS0tCiBkcml2
ZXJzL3BjaS9zZXR1cC1idXMuYyB8ICAgMTAgKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKKysr
IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwpAQCAtODEwLDYgKzgxMCwxNiBAQCBz
dGF0aWMgaW50IHBidXNfc2l6ZV9tZW0oc3RydWN0IHBjaV9idXMKIAogCQkJaWYgKHItPnBhcmVu
dCB8fCAoci0+ZmxhZ3MgJiBtYXNrKSAhPSB0eXBlKQogCQkJCWNvbnRpbnVlOworCisJCQkvKiBE
b24ndCBsZXQgUk9NIHB1bGwgZG93biBwcmVmNjQgKi8KKwkJCWlmIChzaXplb2YocmVzb3VyY2Vf
c2l6ZV90KSA+PSA4ICYmCisJCQkgICAgaSA9PSBQQ0lfUk9NX1JFU09VUkNFICYmCisJCQkgICAg
KHR5cGUgJiBJT1JFU09VUkNFX1BSRUZFVENIKSAmJgorCQkJICAgIChtZW02NF9tYXNrICYgSU9S
RVNPVVJDRV9NRU1fNjQpKSB7CisJCQkJci0+ZmxhZ3MgJj0gfklPUkVTT1VSQ0VfUFJFRkVUQ0g7
CisJCQkJY29udGludWU7CisJCQl9CisKIAkJCXJfc2l6ZSA9IHJlc291cmNlX3NpemUocik7CiAj
aWZkZWYgQ09ORklHX1BDSV9JT1YKIAkJCS8qIHB1dCBTUklPViByZXF1ZXN0ZWQgcmVzIHRvIHRo
ZSBvcHRpb25hbCBsaXN0ICovCg==
--047d7b339bb51d66c604bdbd3960--
