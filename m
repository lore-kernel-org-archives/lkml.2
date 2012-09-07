Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2IGPsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:48:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2IGPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:48:01 -0400
Message-ID: <504A172B.5020005@canonical.com>
Date: Fri, 07 Sep 2012 17:47:55 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "Justin M. Forbes" <jmforbes@linuxtx.org>, Matt Wilson <msw@amazon.com>,
        xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com> <5049F4E9.9050306@canonical.com> <504A1A950200007800099D4C@nat28.tlf.novell.com> <20120907142251.GA20096@linuxtx.org> <504A32800200007800099E40@nat28.tlf.novell.com>
In-Reply-To: <504A32800200007800099E40@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig1CE0EE74CDFE79A5EB5D6AA5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1CE0EE74CDFE79A5EB5D6AA5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07.09.2012 17:44, Jan Beulich wrote:
>>>> On 07.09.12 at 16:22, "Justin M. Forbes" <jmforbes@linuxtx.org> wrot=
e:
>> On Fri, Sep 07, 2012 at 03:02:29PM +0100, Jan Beulich wrote:
>>>>>> On 07.09.12 at 15:21, Stefan Bader <stefan.bader@canonical.com> wr=
ote:
>>>> On 07.09.2012 14:33, Jan Beulich wrote:
>>>>>>>> On 07.09.12 at 13:40, Stefan Bader <stefan.bader@canonical.com> =
wrote:
>>>>>> When writing unsupported flags into CR4 (for some time the
>>>>>> xen_write_cr4 function would refuse to do anything at all)
>>>>>> older Xen hypervisors (and patch can potentially be improved
>>>>>> by finding out what older means in version numbers) would
>>>>>> crash the guest.
>>>>>>
>>>>>> Since Amazon EC2 would at least in the past be affected by that,
>>>>>> Fedora and Ubuntu were carrying a hack that would filter out
>>>>>> X86_CR4_OSXSAVE before writing to CR4. This would affect any
>>>>>> PV guest, even those running on a newer HV.
>>>>>>
>>>>>> And this recently caused trouble because some user-space was
>>>>>> only partially checking (or maybe only looking at the cpuid
>>>>>> bits) and then trying to use xsave even though the OS support
>>>>>> was not set.
>>>>>>
>>>>>> So I came up with a patch that would
>>>>>> - limit the work-around to certain Xen versions
>>>>>> - prevent the write to CR4 by unsetting xsave and osxsave in
>>>>>>   the cpuid bits
>>>>>>
>>>>>> Doing things that way may actually allow this to be acceptable
>>>>>> upstream, so I am sending it around, now.
>>>>>> It probably could be improved when knowing the exact version
>>>>>> to test for but otherwise should allow to work around the guest
>>>>>> crash while not preventing xsave on Xen 4.x and newer hosts.
>>>>>
>>>>> Before considering a hack like this, I'd really like to see evidenc=
e
>>>>> of the described behavior with an upstream kernel (i.e. not one
>>>>> with that known broken hack patched in, which has never been
>>>>> upstream afaict).
>>>>
>>>> This is the reason I wrote that Fedora and Ubuntu were carrying it. =
It=20
>> never=20
>>>> has
>>>> been send upstream (the other version) because it would filter the C=
R4=20
>> write=20
>>>> for
>>>> any PV guest regardless of host version.
>>>
>>> But iirc that bad patch is a Linux side one (i.e. you're trying to fi=
x
>>> something upstream that isn't upstream)?
>>>
>> Right, so the patch that this improves upon, and that Fedora and Ubunt=
u are
>> currently carrying is not upstream because:
>>
>> a) It's crap, it cripples upstream xen users, but doesn't impact RHEL =
xen
>> users because xsave was never supported there.
>>
>> b) The hypervisor was patched to make it unnecessary quite some time a=
go,
>> and we hoped EC2 would eventually pick up that correct patch and we co=
uld
>> drop the crap kernel patch.
>>
>> Unfortunately this has not happened. We are at a point where EC2 reall=
y is
>> a quirk that has to be worked around. Distros do not want to maintain
>> a separate EC2 build of the kernel, so the easiest way is to cripple
>> current upstream xen users.  This quirk is unfortunately the best poss=
ible
>> solution.  Having it upstream also makes it possible for any user to b=
uild
>> an upstream kernel that will run on EC2 without having to dig a random=

>> patch out of a vendor kernel.
>=20
> All of this still doesn't provide evidence that a plain upstream
> kernel is actually having any problems in the first place. Further,
> if you say EC2 has a crippled hypervisor patch - is that patch
> available for looking at somewhere?

It was not a hypervisor patch. It was one for the guest. This was the hac=
k:

=46rom 57bb316c938a9ad65a8093f0584fd22eda88521f Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Tue, 27 Jul 2010 06:06:07 -0700
Subject: [PATCH] UBUNTU: SAUCE: fix pv-ops for legacy Xen

Import fix_xen_guest_on_old_EC2.patch from fedora 14

Legacy hypervisors (RHEL 5.0 and RHEL 5.1) do not handle guest writes to
cr4 gracefully. If a guest attempts to write a bit of cr4 that is
unsupported, then the HV is so offended it crashes the domain. While
later guest kernels (such as RHEL6) don't assume the HV supports all
features, they do expect nicer responses. That assumption introduced
code that probes whether or not xsave is supported early in the boot. So
now when attempting to boot a RHEL6 guest on RHEL5.0 or RHEL5.1 an early
crash will occur.

This patch is quite obviously an undesirable hack. The real fix for this
problem should be in the HV, and is, in later HVs. However, to support
running on old HVs, RHEL6 can take this small change. No impact will
occur for running on any RHEL HV (not even RHEL 5.5 supports xsave).
There is only potential for guest performance loss on upstream Xen.

All this by way of explanation for why is this patch not going upstream.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
---
 arch/x86/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1f92865..9043464 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -806,6 +806,7 @@ static void xen_write_cr4(unsigned long cr4)
 {
 	cr4 &=3D ~X86_CR4_PGE;
 	cr4 &=3D ~X86_CR4_PSE;
+	cr4 &=3D ~X86_CR4_OSXSAVE;

 	native_write_cr4(cr4);
 }
--=20
1.7.9.5

>=20
> Jan
>=20



--------------enig1CE0EE74CDFE79A5EB5D6AA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQShcrAAoJEOhnXe7L7s6jFYQQAI7ZytEr9xU0BgscmruP4EAK
nqFeGDmjCwY2NBBq5O+oLVUAxchSMPmmcu7Lfm46abYxdmOiXJRLyIY3rc8k7DV3
7RKszXVgzZ8+56Y5ier6oXCSERPqYHtx0Iw6fn4s/XexWtBHe7YeFmOUVF3XXSv0
gqycW770GhpIPOynIfuCe9XGdnUcDS3UBdSAHF6z39qD6hOx1Zywv1MArcPXFTbq
LOnZr39Gowu+WrEKgvSu4IB7jNvz0184uplrgZlBilL1MO2znG9AOEZB+OZIf0PV
oiVEfolQztHOPZ9juDBU65IWUWqlqcJ/YQ5KGXIAN7V0YeJ5Hwfnl7jNe4nBVZVh
BQHKysCgiyPFj3pt7JQAlTz/VRl+4dxGmjl21EhuNfvMYy4nriIytslXUCwXzG8Z
yFl+xKegHbI3lybkFu/VMDYuARkjZdK3X7OYaP8123L6PRUs96xhqJVvP7MF1dBu
cqe4rh0rBJQFOvh+H2zl4V48GUhpV2qQK0rxE9o+wwi8EPC82UMSZ3oICbiuROBK
zWb5uYbQY2T6IiZtyTvLVzGyYkoBmbIXrDoQt7gYjwlF09UoFW12dYeR0zAmLdT9
iM2T6Ss3+9F5mkJkGPC0Cx2mT2XlLv09YqGppxeHY1fGE3EFvQ8+jy7Go6EdGMtD
fIXR2mXNMOigfH4Lo81Y
=rjU0
-----END PGP SIGNATURE-----

--------------enig1CE0EE74CDFE79A5EB5D6AA5--
