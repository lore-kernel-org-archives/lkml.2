Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0DTVTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:19:15 -0400
Received: from mail.copilotco.com ([216.105.40.123]:49350 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0DTVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:19:14 -0400
Date: Tue, 20 Apr 2010 14:19:13 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
       xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420211913.GV5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
 <20100420200004.GQ5660@tracyreed.org>
 <20100420202519.GB9220@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ghfi4GlmwTrWkODx"
Content-Disposition: inline
In-Reply-To: <20100420202519.GB9220@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ghfi4GlmwTrWkODx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 04:25:19PM -0400, Konrad Rzeszutek Wilk spake thusl=
y:
> The DomU disk from the Dom0 perspective is using 'phy' which means
> there is no caching in Dom0 for that disk (but it is in DomU).

That is fine. I don't particularly want caching in dom0.

> Caching should be done in DomU in that case - which begs the question -
> how much memory do you have in your DomU? What happens if you
> give to both Dom0 and DomU the same amount of memory?

4G in domU and 1G in dom0.=20

> OK. That is possibly caused by the fact that you are caching the data.
> Look at your buffers cache (and  drop the cache before this) and see
> how it grows.

I try to use large amounts of data so cache is less a factor but I
also drop the cache before each test using:

echo 1 > /proc/sys/vm/drop_caches.=20

I had to start doing this not only to ensure accurate results but also
because the way it was caching the reads was really confusing when I
would see a test start out apparently fine and writing at good speed
according to iostat and then suddenly start hitting the disk with
reads when it ran into data which it did not already have read into
cache.

> How do you know this is a mis-aligned sectors issue? Is this what your
> AOE vendor is telling you ?

No AoE vendor involved. I am using the free stuff. I think it is a
misalignment issue because during a purely write test it is doing
massive amounts of reading according to iostat.

Also note that there are several different kinds of misalignment which
can occur:

- Disk sector misalignment

- RAID chunk size misalignment

- Page cache misalignment

Would the first two necessarily show up in iostat? I'm not sure if
disk sector misalignment is dealth with automatically in the hardware
or if the kernel aligns it for us. RAID chunk size misalignment seems
like it would be dealth with in the RAID card if using hardware
RAID. But I am not. So the software RAID implementation might cause
reads to show up in iostat.

Linux page cache size is 4k which is why I am using 4k block size in
my dd tests.

> I was thinking of first eliminating caching from the picture and seeing
> the speeds you get when you do direct IO to the spindles. You can do this=
 using
> a tool called 'fio' or 'dd' with the oflag=3Ddirect. Try doing that from
> both Dom0 and DomU and see what the speeds are.

I have never been quite clear on the purpose of oflag=3Ddirect. I have
read in the dd man page tht it is supposed to bypass cache. But
whenever I use it performance is horrible beyond merely just not
caching. I am doing the above dd with oflag=3Ddirect now as you
suggested and I see around 30 seconds of nothing hitting the disks and
then two or three seconds of writing in iostat on the target. I just
ctrl-c'd the dd and it shows:

#dd if=3D/dev/zero of=3D/dev/etherd/e6.1 oflag=3Ddirect bs=3D4096
count=3D3000000
1764883+0 records in
1764883+0 records out
7228960768 bytes (7.2 GB) copied, 402.852 seconds, 17.9 MB/s

But even on my local directly attached SATA workstation disk when
doing that same dd on an otherwise idle machine I see performance
like:

$ dd if=3D/dev/zero of=3Dfoo.test bs=3D4096 count=3D4000000
C755202+0 records in
755202+0 records out
3093307392 bytes (3.1 GB) copied, 128.552 s, 24.1 MB/s

which again suggests that oflag=3Ddirect isn't doing quite what I expect.

--=20
Tracy Reed
http://tracyreed.org

--Ghfi4GlmwTrWkODx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLzhpR9PIYKZYVAq0RAp8GAJ40PXCsIWrHoMCHPyvUn/4G0iqR2QCdHE/Y
pGGqecVkP3EmRG10xdRoZ3k=
=+zYV
-----END PGP SIGNATURE-----

--Ghfi4GlmwTrWkODx--
