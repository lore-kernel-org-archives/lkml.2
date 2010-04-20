Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0DTTjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:39:54 -0400
Received: from mail.copilotco.com ([216.105.40.123]:60473 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0DTTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:39:52 -0400
Date: Tue, 20 Apr 2010 12:39:52 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420193952.GP5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>,
	Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWPcrH1o85ekjD8l"
Content-Disposition: inline
In-Reply-To: <20100420084955.GV1878@reaktio.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWPcrH1o85ekjD8l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi K=E4rkk=E4inen spake thusly:
> Please paste your domU partition table:
> sfdisk -d /dev/xvda

I have tried many different things including dd straight to the raw
unpartitioned device. That should not be affected by
partitioning/lvm/filesystem problems right?

> Are you using filesystems on normal partitions, or LVM in the domU?=20
> I'm pretty sure this is a domU partitioning problem.

I have done all of the above. Here I am an xvdg device in my domU to
which I am directly doing a dd to, no partitioning or anything:

# dd if=3D/dev/zero of=3D/dev/xvdg bs=3D4096 count=3D3000000
3000000+0 records in
3000000+0 records out
12288000000 bytes (12 GB) copied, 449.109 seconds, 27.4 MB/s

# /sbin/sfdisk -d /dev/xvdg

sfdisk: ERROR: sector 0 does not have an msdos signature
 /dev/xvdg: unrecognized partition table type
No partitions found

and running iostat on the target shows the following:

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgq=
u-sz   await  svctm  %util
sda               0.00  3474.60 1070.60 46.40  4311.20 13680.00    32.21   =
  2.08    1.83   0.49  54.32
sdb               0.00  3376.00 1060.20 45.60  4289.60 13686.40    32.51   =
  2.46    2.23   0.53  58.12

Or I can partition it with a geometry of 248 heads and 56 sectors
which is a multiple of 8 which should avoid the misalignment due to
the extra partition table (there is a partition on the physical disk
on the target already then I create a logical volume to export to the
initiator which then puts its own partition in it which causes
misalignment):

dd if=3D/dev/zero of=3D/dev/xvdg1 bs=3D4096 count=3D3000000
3000000+0 records in
3000000+0 records out
12288000000 bytes (12 GB) copied, 445.338 seconds, 27.6 MB/s

# /sbin/sfdisk -d /dev/xvdg
# partition table of /dev/xvdg
unit: sectors

/dev/xvdg1 : start=3D       56, size=3D566227592, Id=3D8e
/dev/xvdg2 : start=3D        0, size=3D        0, Id=3D 0
/dev/xvdg3 : start=3D        0, size=3D        0, Id=3D 0
/dev/xvdg4 : start=3D        0, size=3D        0, Id=3D 0

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgq=
u-sz   await  svctm  %util
sda               0.00  3472.20 1188.20 51.00  4805.60 14097.60    30.51   =
  2.71    2.13   0.52  64.02
sdb               0.00  3472.40 1187.00 52.00  4784.00 14092.80    30.47   =
  2.82    2.22   0.56  68.80

Or I can take a standard partition geometry and set it to start at 64
instead of 63 like so many RAID alignment pages talk about:

It is taking even longer this time and I am tired of waiting for dd
before sending off this email but suffice it to say it is painfully
slow.

# /sbin/sfdisk -d /dev/xvdg
# partition table of /dev/xvdg
unit: sectors

/dev/xvdg1 : start=3D       64, size=3D566226926, Id=3D83
/dev/xvdg2 : start=3D        0, size=3D        0, Id=3D 0
/dev/xvdg3 : start=3D        0, size=3D        0, Id=3D 0
/dev/xvdg4 : start=3D        0, size=3D        0, Id=3D 0

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgq=
u-sz   await  svctm  %util
sda               0.00  1832.73 1234.73 30.94  4991.62  7864.27    20.31   =
  1.52    1.23   0.47  59.82
sdb               0.00  1835.13 1219.76 30.54  4916.57  7839.52    20.40   =
  1.27    1.04   0.45  56.67

I would not be at all surprised if you are right about it being a domU
partitioning problem. But every scheme I have tried has failed to work
properly. Appreciate any pointers.

--=20
Tracy Reed
http://tracyreed.org

--uWPcrH1o85ekjD8l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLzgMI9PIYKZYVAq0RAhACAKCIbTkIGq7sLc3JjYaKTLoFHSdeCACdF5P5
5Fym0WynhRd2N862I4Op6ys=
=Ae0P
-----END PGP SIGNATURE-----

--uWPcrH1o85ekjD8l--
