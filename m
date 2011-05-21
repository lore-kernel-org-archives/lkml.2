Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1EUOid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:38:33 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:35349 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1EUOia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:38:30 -0400
Message-ID: <4DD7CE60.4020707@web.de>
Date: Sat, 21 May 2011 16:38:24 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>, Kalle Valo <kvalo@adurom.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci, dmar: flush IOTLB before exit domain
References: <4DC34B21.9040203@oracle.com>	 <1304952530.30435.16.camel@i7.infradead.org>	 <1305558798.3146.48.camel@x201>  <1305661262.29268.27.camel@x201> <1305683845.29268.34.camel@x201>
In-Reply-To: <1305683845.29268.34.camel@x201>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig178CBB5F75545248D0B3A4FE"
X-Provags-ID: V01U2FsdGVkX18cWggzznOttN93mIKMWM9EvbvOrkRDYBWIGgNx
	xxy+z7iAqfxG3+AzfZ5rYD8mLg50CIq4FWhwkLF+q/73pJbEXU
	tsOdIvSkk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig178CBB5F75545248D0B3A4FE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2011-05-18 03:57, Alex Williamson wrote:
> On Tue, 2011-05-17 at 13:41 -0600, Alex Williamson wrote:
>> On Mon, 2011-05-16 at 09:13 -0600, Alex Williamson wrote:
>>> On Mon, 2011-05-09 at 15:48 +0100, David Woodhouse wrote:
>>>> On Thu, 2011-05-05 at 18:13 -0700, Yinghai Lu wrote:
>>>>> @@ -3252,6 +3252,9 @@ static int device_notifier(struct notifi
>>>>>                 return 0;
>>>>> =20
>>>>>         if (action =3D=3D BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_=
through) {
>>>>> +               /* before we remove dev with domain, flush IOTLB */=

>>>>> +               flush_unmaps();
>>>>> +
>>>>>                 domain_remove_one_dev_info(domain, pdev);
>>>>> =20
>>>>>                 if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) =
&&=20
>>>>
>>>> That calls flush_unmaps() without the async_umap_flush_lock held,
>>>> doesn't it? A few days ago I asked someone else to test this candida=
te
>>>> patch for a similar issue:
>>>>
>>>> http://david.woodhou.se/flush-unmaps-on-unbind.patch
>>>
>>> Copying here:
>>>
>>>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>>>> index d552d2c..7e606d6 100644
>>>> --- a/drivers/pci/intel-iommu.c
>>>> +++ b/drivers/pci/intel-iommu.c
>>>> @@ -3256,8 +3259,10 @@ static int device_notifier(struct notifier_bl=
ock *nb,
>>>> =20
>>>>  		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
>>>>  		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
>>>> -		    list_empty(&domain->devices))
>>>> +		    list_empty(&domain->devices)) {
>>>> +			flush_unmaps_timeout(0);
>>>>  			domain_exit(domain);
>>>> +		}
>>>>  	}
>>>> =20
>>>>  	return 0;
>>>> @@ -3587,6 +3592,7 @@ static void intel_iommu_domain_destroy(struct =
iommu_domain *domain)
>>>>  	struct dmar_domain *dmar_domain =3D domain->priv;
>>>> =20
>>>>  	domain->priv =3D NULL;
>>>> +	flush_unmaps_timeout(0);
>>>>  	vm_domain_exit(dmar_domain);
>>>> }
>>>
>>> David, would it be worthwhile to push the unmaps into the
>>> {vm_}domain_exit() functions to avoid races like this in the future? =
 I
>>> can verify the above resolves a panic after unbinding a device from
>>> snd_hda_intel that I hit recently.  Do you plan to push this for .39?=

>>
>> BTW, is this second chunk really needed?  VM iommu mappings don't seem=

>> to use the lazy unmap path.  Thanks,
>=20
> David, what do you think of this instead?  Thanks,
>=20
> Alex
>=20
> intel-iommu: Flush unmaps at domain_exit
>=20
> From: Alex Williamson <alex.williamson@redhat.com>
>=20
> We typically batch unmaps to be lazily flushed out at
> regular intervals.  When we destroy a domain, we need
> to force a flush of these lazy unmaps to be sure none
> reference the domain we're about to free.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>=20
>  drivers/pci/intel-iommu.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
>=20
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index d552d2c..b04f84e 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1416,6 +1416,10 @@ static void domain_exit(struct dmar_domain *doma=
in)
>  	if (!domain)
>  		return;
> =20
> +	/* Flush any lazy unmaps that may reference this domain */
> +	if (!intel_iommu_strict)
> +		flush_unmaps_timeout(0);
> +
>  	domain_remove_dev_info(domain);
>  	/* destroy iovas */
>  	put_iova_domain(&domain->iovad);
>=20
>=20

Can we get this resolved for 2.6.39.1? Via David's patch, or Alex's
(which works for me), or whatever. It's a really annoying regression of
=2E39 when you want to run with IOMMU enabled.

Thanks,
Jan


--------------enig178CBB5F75545248D0B3A4FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3XzmMACgkQitSsb3rl5xRhlQCgkPkzMZGlE7+W4CdMv+htYx34
xtIAoOJzAykenXIXvi4AIR0ev/btw60q
=gCeY
-----END PGP SIGNATURE-----

--------------enig178CBB5F75545248D0B3A4FE--
