Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2IGNVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:21:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2IGNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:21:50 -0400
Message-ID: <5049F4E9.9050306@canonical.com>
Date: Fri, 07 Sep 2012 15:21:45 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Wilson <msw@amazon.com>, xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com>
In-Reply-To: <504A05B00200007800099C7B@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigFEC341DE9F4CC3FEA7524E82"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEC341DE9F4CC3FEA7524E82
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07.09.2012 14:33, Jan Beulich wrote:
>>>> On 07.09.12 at 13:40, Stefan Bader <stefan.bader@canonical.com> wrot=
e:
>> When writing unsupported flags into CR4 (for some time the
>> xen_write_cr4 function would refuse to do anything at all)
>> older Xen hypervisors (and patch can potentially be improved
>> by finding out what older means in version numbers) would
>> crash the guest.
>>
>> Since Amazon EC2 would at least in the past be affected by that,
>> Fedora and Ubuntu were carrying a hack that would filter out
>> X86_CR4_OSXSAVE before writing to CR4. This would affect any
>> PV guest, even those running on a newer HV.
>>
>> And this recently caused trouble because some user-space was
>> only partially checking (or maybe only looking at the cpuid
>> bits) and then trying to use xsave even though the OS support
>> was not set.
>>
>> So I came up with a patch that would
>> - limit the work-around to certain Xen versions
>> - prevent the write to CR4 by unsetting xsave and osxsave in
>>   the cpuid bits
>>
>> Doing things that way may actually allow this to be acceptable
>> upstream, so I am sending it around, now.
>> It probably could be improved when knowing the exact version
>> to test for but otherwise should allow to work around the guest
>> crash while not preventing xsave on Xen 4.x and newer hosts.
>=20
> Before considering a hack like this, I'd really like to see evidence
> of the described behavior with an upstream kernel (i.e. not one
> with that known broken hack patched in, which has never been
> upstream afaict).

This is the reason I wrote that Fedora and Ubuntu were carrying it. It ne=
ver has
been send upstream (the other version) because it would filter the CR4 wr=
ite for
any PV guest regardless of host version.

Gathering the evidence is a bit of a problem: First you need a host which=
 has
the xsave support, then that has to run the affected Xen version (which I=
 do not
know) and lastly run a PV guest kernel trying to write OSXSAVE into CR4
(probably 2.6.28 onwards, we were facing those random early crashes with =
2.6.32
on EC2 in some cases).

-Stefan

>=20
> Jan
>=20
>> From dff8885934d4e1274a69c4cedd28a4d18a1255e8 Mon Sep 17 00:00:00 2001=

>> From: Stefan Bader <stefan.bader@canonical.com>
>> Date: Fri, 15 Jun 2012 11:54:59 +0200
>> Subject: [PATCH] xen: Mask xsave cpu capability on Xen host < 4
>>
>> Older Xen hypervisors (like RHEL5 versions found to be used
>> on Amazon's EC2) did have a bug which would crash the domain
>> when trying to write unsupported CR4 values.
>> Newer versions of the Xen hypervisor do handle this correctly.
>> But when a 2.6.28 or later kernel (those seem to have
>> xen_write_cr4 and xsave support) is booted as a PV guest on EC2,
>> it potentially crashes when hitting the right CPU and the wrong
>> hypervisor.
>>
>> We were using a patch (taken from Fedora) that did always filter
>> the OSXSAVE off the values written to CR4 when running as Xen PV
>> guest. While not completely wrong this creates an inconsistency
>> between the cpuid bits a guest sees and the CR4 settings.
>> But it prevents any use of xsave even on recent Xen hypervisors.
>> And this did recently cause problems because user-space was not
>> testing all bits when deciding to use certain features.
>>
>> This patch will actually mask off the cpuid bits for XSAVE and
>> OSXSAVE, so generic code will not even try to set CR4. It is
>> limited to PV guests and (since we do not actually know the
>> exact version) Xen hypervisors before version 4.
>>
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>> ---
>>  arch/x86/xen/enlighten.c |   17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index 9642d4a..4241055 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -210,6 +210,18 @@ void xen_vcpu_restore(void)
>>  	}
>>  }
>> =20
>> +/*
>> + * Older (with no clear statement about what old means) Xen hyperviso=
rs
>> + * will crash a PV guest that tries to store OSXSAVE into CR4.
>> + * To prevent this, we force the feature bits related to this off in =
the
>> + * xen cpuid call. This inline function serves as a centralized test
>> + * on whether the quirk should be done.
>> + */
>> +static inline needs_xsave_quirk(unsigned version)
>> +{
>> +	return (xen_pv_domain() && ((version >> 16) < 4)) ? 1 : 0;
>> +}
>> +
>>  static void __init xen_banner(void)
>>  {
>>  	unsigned version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
>> @@ -221,6 +233,8 @@ static void __init xen_banner(void)
>>  	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
>>  	       version >> 16, version & 0xffff, extra.extraversion,
>>  	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-=
AD)" :=20
>> "");
>> +	if (needs_xsave_quirk(version))
>> +		printk(KERN_INFO "Forcing xsave off due to Xen version.\n");
>>  }
>> =20
>>  #define CPUID_THERM_POWER_LEAF 6
>> @@ -351,6 +365,7 @@ static bool __init xen_check_mwait(void)
>>  }
>>  static void __init xen_init_cpuid_mask(void)
>>  {
>> +	unsigned version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
>>  	unsigned int ax, bx, cx, dx;
>>  	unsigned int xsave_mask;
>> =20
>> @@ -371,7 +386,7 @@ static void __init xen_init_cpuid_mask(void)
>>  		(1 << (X86_FEATURE_OSXSAVE % 32));
>> =20
>>  	/* Xen will set CR4.OSXSAVE if supported and not disabled by force *=
/
>> -	if ((cx & xsave_mask) !=3D xsave_mask)
>> +	if (((cx & xsave_mask) !=3D xsave_mask) || needs_xsave_quirk(version=
))
>>  		cpuid_leaf1_ecx_mask &=3D ~xsave_mask; /* disable XSAVE & OSXSAVE *=
/
>>  	if (xen_check_mwait())
>>  		cpuid_leaf1_ecx_set_mask =3D (1 << (X86_FEATURE_MWAIT % 32));
>> --=20
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org=20
>> http://lists.xen.org/xen-devel=20
>=20
>=20
>=20
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>=20



--------------enigFEC341DE9F4CC3FEA7524E82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQSfTpAAoJEOhnXe7L7s6jEdkP/0/UK0Ybd9uHcfShLGFtAsxP
veyXp3Ac2AQpneuevLZGDLjlkRzn14O2bbB5TewrF+2sSUWz5tOC0tsoS9V2ZVNC
PCfAGMptjNPbVK1S3e9nMuEz0qOeL02cW6rv0nupkmA76gFMcNdTwDq5wpxkA2cC
CzWiIk3pJ6fGo/gQfOu+4rzAO+VlZY8TZP0zyAc09oZhoJuAxyh2Iw5/4I/Fi0d9
DYtI5rhNhKRia6YcuAP7jUlk5T6+j6gcGT2ewdbu+03YMjuLaDFuWaTfMx1iAre4
yF3BnZKKf6D+y+N2vtgpA6XGuwUwWLrxY6do073J0Rr8kOi3m5SD0V/gxGFe+qz+
gIjC6IPIp0Gqbr+4icqa/hSF++YUnsitvOFXMAi1y+ox2AUQcO6N1SSwIVvfmGBO
ytwT4EQ9P7GCr1L6HnAoZys+vP6OrtiirJhj0yw1Zxk0Ae/y1vqutButGzey7eFa
RiSkVJgZ0kDDTs4fBKNMxXj1ZRByrerb/8Ih14flL9wK3ILbROYhq/Dt9Ebr0xGp
OXnlXicWyWu2qHECoPdGMrowRlVpYzOLoB3HX56Lm7x5FbPbFX1BdYr0pEabKNgg
Z4vNyyo3LlOVUlDvEz/6POV62yeKRDaJKUuQf8BbvsUEvO6jiczAYPcLvSzdfCtG
O8alNGMm9R7ngXLFdVOA
=wXZf
-----END PGP SIGNATURE-----

--------------enigFEC341DE9F4CC3FEA7524E82--
