Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0DTV7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:59:00 -0400
Received: from mail.copilotco.com ([216.105.40.123]:53253 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab0DTV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:58:59 -0400
Date: Tue, 20 Apr 2010 14:58:59 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: pasik@iki.fi, xen-devel@lists.xensource.com,
       Aoetools-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420215859.GW5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>, pasik@iki.fi,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
 <20100420200004.GQ5660@tracyreed.org>
 <20100420204151.GH1708@kremvax.cs.ubc.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3m6ZAtymzEdXvUYk"
Content-Disposition: inline
In-Reply-To: <20100420204151.GH1708@kremvax.cs.ubc.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3m6ZAtymzEdXvUYk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 01:41:51PM -0700, Brendan Cully spake thusly:
> You could also be limited by the size of the block request ring (I
> believe the ring is normally only one page) -- the ring needs to be
> large enough to handle the bandwidth delay product, and AoE means the
> delay is probably higher than normal.

Interesting. Any easy way to increase this as a test?

> Do you get better performance against a local partition?

You mean a local partition on local disk in the dom0 given to a domU
as xvd? Let's see...

I just created a 20G logical volume on the dom0:

# /usr/sbin/lvcreate -n test -L20G sysvg

Added it to the domain config file to be /dev/xvdi and rebooted.

         "phy:/dev/sysvg/test,xvdi,w"

I know you can attach block devices on the fly but this has not been
entirely reliable for me in the past so I reboot now.

In domU against xvdi which is /dev/sysvg/test in dom0:

# dd if=3D/dev/zero of=3D/dev/xvdi bs=3D4096 count=3D1000000
1000000+0 records in
1000000+0 records out
4096000000 bytes (4.1 GB) copied, 99.3749 seconds, 41.2 MB/s

And iostat on dom0 shows:
Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sda               0.00   824.00  4.00 101.00    16.00 39936.00
760.99     3.19   31.31   9.52 100.00

In dom0 against the local disk to demonstrate native performance:

# dd if=3D/dev/zero of=3D/dev/sysvg/test bs=3D4096 count=3D1000000
1000000+0 records in
1000000+0 records out
4096000000 bytes (4.1 GB) copied, 84.9047 seconds, 48.2 MB/s

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sda               7.00 11104.00  5.00 96.00    48.00 48144.00   954.30
133.92 1172.40   9.94 100.40

Virtually no reads happening. This disk seems a bit slow (older 80G
sata disk) but otherwise normal. I don't see anything indicating
alignment issues.

--=20
Tracy Reed
http://tracyreed.org

--3m6ZAtymzEdXvUYk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLziOj9PIYKZYVAq0RAkp7AJ45PvbdgQX1g1OJ3ke75DXKB+NyhwCgn1ZM
HSNBTA4Ev01HfpVOu8Z6Pbo=
=JNhH
-----END PGP SIGNATURE-----

--3m6ZAtymzEdXvUYk--
