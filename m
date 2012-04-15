Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2DOUGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:06:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40814 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2DOUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUsQjUNeW1sa_mQL6MEaDhxvoMhFaN9wLPAqOXzh+AXPQ@mail.gmail.com>
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
	<CAE9FiQUsQjUNeW1sa_mQL6MEaDhxvoMhFaN9wLPAqOXzh+AXPQ@mail.gmail.com>
Date: Sun, 15 Apr 2012 13:06:18 -0700
X-Google-Sender-Auth: 3VNG-YsgW5d1iZxVWCdV6GDSlhI
Message-ID: <CAE9FiQVzC2YCkXtFDPkCMVMcMqt9c0t8hKVvpgFpwjRdBen0Uw@mail.gmail.com>
Subject: Re: PCI resources above 4GB
From: Yinghai Lu <yinghai@kernel.org>
To: Steven Newbury <steve@snewbury.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, Dave Airlie <airlied@linux.ie>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8ff1cc401c5e3404bdbd3d42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1cc401c5e3404bdbd3d42
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 15, 2012 at 1:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, Apr 15, 2012 at 10:31 AM, Steven Newbury <steve@snewbury.org.uk> =
wrote:
>>>>>>>>
>>>>>>>> pci 0000:03:08.0: BAR 15: can't assign mem pref (size
>>>>>>>> 0x18000000)
>>>>>>> Ah! Not enough space for the bridge window!:(
>>>>>>>
>>>
>>>>>> please append pci=3Dnorom ...
>>>
>>>>> That worked. =A0Except of course the radeon driver can't POST the
>>>>> =A0card without the ROM! :-P
>>>> Can the ROM resource be mapped above 4G?
>>> I didn't really think that through, obviously it can't because
>>> it's not on a 64-bit capable bridge. =A0I wonder though, could it be
>>> shadowed then disabled early before the IOMEM?
>> I see there's "#if 0"'d helper functions for exactly that in rom.c.
>> They've been disabled since 2007!
>
> solution could be one of three:
> 1. when bridge support 64bit pref, will not allocate rom bar in bridge
> pref resource.
> =3D=3D=3D=3D> patch: rom_pref.patch
>
> 2. unconditionally to make rom bar allocation in bridge non-pref range.
> =3D=3D=3D=3D> patch: rom_no_pref.patch

missed attach rom_no_pref.patch

> Looks like BIOS and at least one of other OSes is doing that.
>
> I can not find the the history why ROM res is with PREFETCH bit set.
> Maybe Linus has some idea about that.
>
> 3. use pci_bus_allocate_resource in drm/radeon driver ... =3D=3D=3D> but
> that could fail.
> =A0 so could hack it like a. disable bar 0x10 and steal BAR address,
> then set 0x30 to that address then copy ROM to ram.
> =A0 after that, disable rom again and set back address to 0x10.
> =A0 You try to update radeon_get_bios() to achieve that.
>
> =A0 =A0 =A0Yinghai

--e89a8ff1cc401c5e3404bdbd3d42
Content-Type: application/octet-stream; name="rom_no_pref.patch"
Content-Disposition: attachment; filename="rom_no_pref.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h12iyy9k1

U3ViamVjdDogW1BBVENIXSBQQ0k6IERvbid0IGFsbG9jYXRlIHJvbSBiYXIgaW4gYnJpZGdlIHBy
ZWYgcmVzb3VyY2UKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9y
Zz4KCi0tLQogZHJpdmVycy9wY2kvcHJvYmUuYyB8ICAgIDUgKystLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZl
cnMvcGNpL3Byb2JlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kv
cHJvYmUuYworKysgbGludXgtMi42L2RyaXZlcnMvcGNpL3Byb2JlLmMKQEAgLTMzNiw5ICszMzYs
OCBAQCBzdGF0aWMgdm9pZCBwY2lfcmVhZF9iYXNlcyhzdHJ1Y3QgcGNpX2RlCiAJaWYgKHJvbSkg
ewogCQlzdHJ1Y3QgcmVzb3VyY2UgKnJlcyA9ICZkZXYtPnJlc291cmNlW1BDSV9ST01fUkVTT1VS
Q0VdOwogCQlkZXYtPnJvbV9iYXNlX3JlZyA9IHJvbTsKLQkJcmVzLT5mbGFncyA9IElPUkVTT1VS
Q0VfTUVNIHwgSU9SRVNPVVJDRV9QUkVGRVRDSCB8Ci0JCQkJSU9SRVNPVVJDRV9SRUFET05MWSB8
IElPUkVTT1VSQ0VfQ0FDSEVBQkxFIHwKLQkJCQlJT1JFU09VUkNFX1NJWkVBTElHTjsKKwkJcmVz
LT5mbGFncyA9IElPUkVTT1VSQ0VfTUVNIHwgSU9SRVNPVVJDRV9SRUFET05MWSB8CisJCQkJSU9S
RVNPVVJDRV9DQUNIRUFCTEUgfCBJT1JFU09VUkNFX1NJWkVBTElHTjsKIAkJX19wY2lfcmVhZF9i
YXNlKGRldiwgcGNpX2Jhcl9tZW0zMiwgcmVzLCByb20pOwogCX0KIH0K
--e89a8ff1cc401c5e3404bdbd3d42--
