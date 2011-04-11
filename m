Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1DKOnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:43:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab1DKOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <4DA2FFB6.3040209@gaisler.com>
References: <4DA2FFB6.3040209@gaisler.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Apr 2011 07:42:13 -0700
Message-ID: <BANLkTikqB2tr-jNTaqVtTpBkH5O1iYQS-Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] PCI: refactor io size calculation code
To: Daniel Hellstrom <daniel@gaisler.com>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Kristoffer Glembo <kristoffer@gaisler.com>
Content-Type: multipart/mixed; boundary=bcaec51d29b0fc5cdd04a0a595f4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51d29b0fc5cdd04a0a595f4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 11, 2011 at 6:18 AM, Daniel Hellstrom <daniel@gaisler.com> wrot=
e:
>In commit 13583b16592a ("PCI: refactor io size calculation code"):
>>
>> refactor =A0code =A0that =A0calculates =A0the =A0io =A0size in pbus_size=
_io()
>> and pbus_mem_io() into separate functions.
>>
>> Signed-off-by: Ram Pai <linuxram@xxxxxxxxxx>
>> ---
>> drivers/pci/setup-bus.c | =A0 66
>> ++++++++++++++++++++++++++++++-----------------
>> 1 files changed, 42 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 66cb8f4..2121215 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -404,6 +404,43 @@ static struct resource *find_free_bus_resource(stru=
ct
>> pci_bus *bus, unsigned lon
>> =A0 =A0 =A0 =A0return NULL;
>> }
>>
> ...
>
>> +
>> +static resource_size_t calculate_memsize(resource_size_t size,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 resource_size_t min_size,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 resource_size_t size1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 resource_size_t old_size,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 resource_size_t align)
>> +{
>> + =A0 =A0 =A0 if (size < min_size)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D min_size;
>> + =A0 =A0 =A0 if (old_size =3D=3D 1 )
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 old_size =3D 0;
>> + =A0 =A0 =A0 if (size < old_size)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D old_size;
>> + =A0 =A0 =A0 size =3D ALIGN(size + size1, align);
>> + =A0 =A0 =A0 return size;
>> +}
>> +
>> /* Sizing the IO windows of the PCI-PCI bridge is trivial,
>> =A0 since these windows have 4K granularity and the IO ranges
>> =A0 of non-bridge PCI devices are limited to 256 bytes.
>>
>>
>
> ...
>
>> @@ -516,14 +542,6 @@ static int pbus_size_mem(struct pci_bus *bus,
>> unsigned long mask,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mem64_mask &=3D r->flags =
& IORESOURCE_MEM_64;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 if (size < min_size)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D min_size;
>> - =A0 =A0 =A0 old_size =3D resource_size(b_res);
>> - =A0 =A0 =A0 if (old_size =3D=3D 1)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 old_size =3D 0;
>> - =A0 =A0 =A0 if (size < old_size)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D old_size;
>> -
>> =A0 =A0 =A0 =A0align =3D 0;
>> =A0 =A0 =A0 =A0min_align =3D 0;
>> =A0 =A0 =A0 =A0for (order =3D 0; order <=3D max_order; order++) {
>> @@ -537,7 +555,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsign=
ed
>> long mask,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_align =3D align1 >> 1=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0align +=3D aligns[order];
>> =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 size =3D ALIGN(size, min_align);
>> + =A0 =A0 =A0 size =3D calculate_memsize(size, min_size, 0, resource_siz=
e(b_res),
>> align);
>>
>
> On my SPARC32/LEON4 PCI system I get overlapped areas, double mapped
> resources. Some BARs on PCIBUS0 are in the same non-prefetchable memory
> range as the secondary bus PCIBUS1. Changing align to min_align in the ab=
ove
> call to calculate_memsize() fixes the problem, and the memory allocation =
is
> the same as with 2.6.36.4 kernel.
>
> I belive this is just a typo.

It does seem that way. The original code used 'min_align' and 'align'
itself is meaningless in that place.

Can you confirm that the patch you talk about as fixing things is the attac=
hed?

                  Linus

--bcaec51d29b0fc5cdd04a0a595f4
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmdigz7e0

IGRyaXZlcnMvcGNpL3NldHVwLWJ1cy5jIHwgICAgNCArKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9z
ZXR1cC1idXMuYyBiL2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCmluZGV4IDg5ZDBhNmE4OGRmNy4u
ZWJmNTFhZDFiNzE0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYworKysgYi9k
cml2ZXJzL3BjaS9zZXR1cC1idXMuYwpAQCAtNjc2LDEwICs2NzYsMTAgQEAgc3RhdGljIGludCBw
YnVzX3NpemVfbWVtKHN0cnVjdCBwY2lfYnVzICpidXMsIHVuc2lnbmVkIGxvbmcgbWFzaywKIAkJ
CW1pbl9hbGlnbiA9IGFsaWduMSA+PiAxOwogCQlhbGlnbiArPSBhbGlnbnNbb3JkZXJdOwogCX0K
LQlzaXplMCA9IGNhbGN1bGF0ZV9tZW1zaXplKHNpemUsIG1pbl9zaXplLCAwLCByZXNvdXJjZV9z
aXplKGJfcmVzKSwgYWxpZ24pOworCXNpemUwID0gY2FsY3VsYXRlX21lbXNpemUoc2l6ZSwgbWlu
X3NpemUsIDAsIHJlc291cmNlX3NpemUoYl9yZXMpLCBtaW5fYWxpZ24pOwogCXNpemUxID0gIWFk
ZF9zaXplID8gc2l6ZSA6CiAJCWNhbGN1bGF0ZV9tZW1zaXplKHNpemUsIG1pbl9zaXplK2FkZF9z
aXplLCAwLAotCQkJCXJlc291cmNlX3NpemUoYl9yZXMpLCBhbGlnbik7CisJCQkJcmVzb3VyY2Vf
c2l6ZShiX3JlcyksIG1pbl9hbGlnbik7CiAJaWYgKCFzaXplMCAmJiAhc2l6ZTEpIHsKIAkJaWYg
KGJfcmVzLT5zdGFydCB8fCBiX3Jlcy0+ZW5kKQogCQkJZGV2X2luZm8oJmJ1cy0+c2VsZi0+ZGV2
LCAiZGlzYWJsaW5nIGJyaWRnZSB3aW5kb3cgIgo=
--bcaec51d29b0fc5cdd04a0a595f4--
