Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1CHTYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:24:21 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:47598 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1CHTYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:24:19 -0500
Date: Tue, 8 Mar 2011 20:23:42 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Milan Broz <mbroz@redhat.com>
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] dm-crypt: Performance Regression 2.6.37 ->
 2.6.38-rc8
Message-ID: <20110308192341.GA8356@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Milan Broz <mbroz@redhat.com>, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	Alasdair G Kergon <agk@redhat.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <4D7668C5.5050100@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <4D7668C5.5050100@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 08, 2011 at 06:35:01PM +0100, Milan Broz wrote:
> On 03/08/2011 05:45 PM, Mario 'BitKoenig' Holbe wrote:
> > dm-crypt in 2.6.38 changed to per-CPU workqueues to increase it's
> > performance by parallelizing encryption to multiple CPUs.
> > This modification seems to cause (massive) performance drops for
> > multiple parallel dm-crypt instances...
> Well, it depends. I never suggested this kind of workaround because
> you basically hardcoded (in device stacking) how many parallel instances
> (=3D=3Dcpu cores ideally) of dmcrypt can run effectively.

Yes. But it was the best to get :)

> With current design the IO is encrypted by the cpu which submitted it.
=2E..
> If you use one dmcrypt instance over RAID0, you will now get probably
> much more better throughput. (Even with one process generating IOs
> the bios are, surprisingly, submitted on different cpus. But this time
> it runs really in parallel.)

Mh, not really. I just tested this with kernels fresh booted into
emergency and udev started to create device nodes:

# cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo1 =
/dev/sdc
=2E..
# cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo4 =
/dev/sdf
# mdadm -B -l raid0 -n 4 -c 256 /dev/md/foo /dev/mapper/foo[1-4]
# dd if=3D/dev/md/foo of=3D/dev/null bs=3D1M count=3D20k

2.6.37: 291MB/s		2.6.38: 139MB/s

# mdadm -B -l raid0 -n 4 -c 256 /dev/md/foo /dev/sd[c-f]
# cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo /=
dev/md/foo
# dd if=3D/dev/mapper/foo of=3D/dev/null bs=3D1M count=3D20k

2.6.37: 126MB/s		2.6.38: 138MB/s

So... performance drops on .37 (as expected) and nothing changes on .38
(unlike expected).

Those results, btw., differ dramatically when using tmpfs-backed
loop-devices instead of hard disks:

raid0 over crypted loops:
2.6.37: 285MB/s		2.6.38: 324MB/s
crypted raid0 over loops:
2.6.37: 119MB/s		2.6.38: 225MB/s

Here we have indeed changing results - even if they are not what one
would expect.

All those constructs are read-only and hence can be tested on any
somewhat available block device. Setting devices read-only would
probably be a good idea to compensate being short on sleep or whatever.

> Maybe we can find some compromise but I basically prefer current design,
> which provides much more better behaviour for most of configurations.

Hmmm...


regards
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXaCPRS+e2HeSPbpAQJhhQf8CWQgV/tzEpHg/AFUzGSD3Q3BXrniAsML
ZDOE1MtBJz2MprcefMhCptl9Fof66pZnqO5r/KBSfyaEG33EDsI7PglSKvqZcpVg
JZPrAlUAoYjt9PQhZoiP6ggQwtcDwzkoV7y4fwnIyMJLaguZbHvylee4iroxxVR2
X6y1/ud46C14e473HMx6z6Lm7trhHcMT7eMEaL8h6gYeITXGCS4Ng8ivDewyS2Se
1jxxOYQy/I4nfcpiHdt6iiQZMBpeqsMgz+RABhq9oVD2gKkbFAoD/ojacRTZivUq
WB4qW5klmulMVqLsPUyCnVMqqj1WmIHtNVKBpxNg1ZFD7d39JM/6zg==
=ZH0K
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
