Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2IGCeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:34:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2IGCeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:34:04 -0400
Date: Fri, 7 Sep 2012 12:33:48 +1000
From: NeilBrown <neilb@suse.de>
To: clplayer <cl.player@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Content Of Files May Be Changed After One Disk Is Failed In
 RAID5
Message-ID: <20120907123348.798dfc28@notabene.brown>
In-Reply-To: <CAOHz1948UduxDDvpA33T9BaM4QoMpwF1wAQKjY3UgSSOOy6k8g@mail.gmail.com>
References: <CAOHz1948UduxDDvpA33T9BaM4QoMpwF1wAQKjY3UgSSOOy6k8g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ptq4e9bOnk.3LKbjUM.0Dta"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ptq4e9bOnk.3LKbjUM.0Dta
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Sep 2012 09:40:18 +0800 clplayer <cl.player@gmail.com> wrote:

> I am stressing the RAID5 functions on my desktop.
>=20
> I installed 8 hard disks which 4 were on the internal SATA ports and
> the others were connected via eSATA.
>=20
> The operating system on the desktop is Ubuntu 12.04.1 LTS 64-bit.
>=20
> I have made a script to check the files in the raid while there are
> disks becoming failed.
>=20
> The actions are as below:
>=20
> 1. creating an 8-disk raid, one of the 8 disks is set as the spare.
> 2. making a ext4 file system on the raid and mounting that raid.
> 3. generating a file from /dev/urandom in the root file system, and
> the size of the file is 1GB.
> 4. calculating the checksum of the file by the command "cksum."
> 5. making 10 duplicates of the file and store in the raid, and then
> calculating the checksums of each duplicate.
> 6. setting one of the disks in the raid to be failed after the 10
> duplicates are stored and checked.
> 7. parallelly calculating the checksums of the duplicates again immediate=
ly.
>=20
> Curiously, there are usually several files changed and the checksums
> are not consistent.
>=20
> Then I tried the same senario with the 8-disk reaid with no spare, and
> the results is the same.
>=20
> I have also tried with RAID1 and RAID6, and the checksums are
> consistent with the two algorithms.
>=20
> It looks like there are something wrong within the raid5 functions. I
> am tracing the file raid5.c but I can not figure out the
>=20
> root causes yet.
>=20
> Would someone please suggest any ideas? Thank you very much.
>=20
> My script is attached below:
>=20
> #!/bin/sh
>=20
> TESTSEQ=3D"0 1 2 3 4 5 6 7 8 9"
>=20
> mdadm --create /dev/md0 --level=3Draid5 --raid-devices=3D7
> --spare-devices=3D1 /dev/sd[a-h]3 --assume-clean -z 10485760 -f -R

--assume-clean is not safe with RAID5 unless the array actually is clean.
It is safe with RAID1 and RAID6 due to details of the specific implementati=
on.
So I suspect that is the cause of the corruption.

NeilBrown

>=20
> mkfs.ext4 /dev/md0
>=20
> mount /dev/md0 /mnt
>=20
> #duplicating the source file and calculating the checksum
> for ITEM in $TESTSEQ
> do
>         echo "copying 1Gr.${ITEM}..."
>         cp /1Gr /mnt/1Gr.${ITEM}
>=20
>         cksum /mnt/1Gr.${ITEM} >> /tmp/cksum_org.${ITEM}
>         cat /tmp/cksum_org.${ITEM} | while read tmpline
>         do
>                 orgcksum=3D${tmpline%% *}
>                 echo "checksum is ${orgcksum}"
>         done
> done
>=20
> sync
>=20
> sleep 10
>=20
> mdadm -f /dev/md0 /dev/sdb3
>=20
> echo "producing checksum..."
> for ITEM in $TESTSEQ
> do
>         cksum /md0/1Gr.${ITEM} > /tmp/cksum_out.${ITEM} &
> done
>=20
> #wait for the 10 cksum process being done
> sleep 120
>=20
> echo "checking the result..."
> for ITEM in $TESTSEQ
> do
>         cat /tmp/cksum_out.${ITEM} | while read line
>         do
>                 item=3D${line%% *}
>=20
> 		#the value 2606882893 was pre-calculated manually
>                 if [ x"$item" !=3D "x2606882893" ]
>                 then
>                         echo "get wrong cksum on ${ITEM}"
>                 else
>                         rm /tmp/cksum_out.${ITEM}
>                 fi
>         done
> done
>=20
> Thanks.
> Peng.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/ptq4e9bOnk.3LKbjUM.0Dta
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEldDDnsnt1WYoG5AQL5lg//SVMSL1EBFbQJjS+2KgHgWfCfe1huh5h3
pDIKhnCoJLVWtWHt+33Dehn6bBnB8l92aOD5PlINhD0c18k5jqgoDvHucOQaZuX3
WnsK35RCedi4MEpSY2Mj5oCxJa5ry9vLmTTWIsXpMTz49MmtqhVDPdZed3iW5prt
9dtLz3SAUelb8qA080YiW8/ijwYfCBz9gMf6l6f+mZ0/qis9/BGMGV0KHmfYYdzV
8AkKh/mMFw7GFyDDt2WTcsSaWCZFF8lpdL1ylEiXq+q/hSbv3MTe6YO26EAUJlID
6r88ERNB72F7QYLhq/sN63ejrUu5dQSPr/k4X0kgDZ043b5qb0DoUxAlqExvgc29
Xx3kCd8ELkpe3LPUTSZHXGwE/sBwEhYotho/9YDeyj/CUi0YLr0xq8y2gE9H2+vd
yS9gwD2s979uxAtKm5Z6/EuujrLSIAUPeqUDHOEm+HbicbNhiQbtwY6pCyCIRtuD
ub4p7Q5wBnPn9iNK0kTi06qWRwDOnXkxMw8sPSoEjC87Ldi7I2yzZPxtvpDjtgyB
ervOevrEH3izAzBSqq0VWLGp87LFw927MFMlz1aBvT1nGaM1G6xpC0XbiKFFTA23
7NoKseWW1Cn8lYd4UADbPmxe9tJVEVOFrW31YUbZXm7yrinPEPvOf+gwn/TYh96u
eqC3SZxfFU0=
=Ji4W
-----END PGP SIGNATURE-----

--Sig_/ptq4e9bOnk.3LKbjUM.0Dta--
