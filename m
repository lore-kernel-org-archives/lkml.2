Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359Ab2CODH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:07:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab2CODHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:07:40 -0400
Date: Thu, 15 Mar 2012 14:07:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan E Brassow <jbrassow@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: manual merge of the md tree with the device-mapper tree
Message-Id: <20120315140730.760e0eb9842d0cccb834b95b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_14_07_30_+1100_KqK_BWGjkVmaGBB4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_14_07_30_+1100_KqK_BWGjkVmaGBB4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got a conflict in
drivers/md/dm-raid.c between commit 43390ddd7f36 ("The dm-raid code
currently fails to create a RAID array if any of the") from the
device-mapper tree and commit 760e35d7e573 ("md: tidy up rdev_for_each
usage") from the md tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/dm-raid.c
index f03e423,c5a875d..0000000
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@@ -857,27 -855,11 +857,27 @@@ static int super_validate(struct mddev=20
  static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
  {
  	int ret;
 +	unsigned redundancy =3D 0;
 +	struct raid_dev *dev;
- 	struct md_rdev *rdev, *freshest, *tmp;
+ 	struct md_rdev *rdev, *freshest;
  	struct mddev *mddev =3D &rs->md;
 =20
 +	switch (rs->raid_type->level) {
 +	case 1:
 +		redundancy =3D rs->md.raid_disks - 1;
 +		break;
 +	case 4:
 +	case 5:
 +	case 6:
 +		redundancy =3D rs->raid_type->parity_devs;
 +		break;
 +	default:
 +		ti->error =3D "Unknown RAID type";
 +		return -EINVAL;
 +	}
 +
  	freshest =3D NULL;
- 	rdev_for_each(rdev, tmp, mddev) {
+ 	rdev_for_each(rdev, mddev) {
  		if (!rdev->meta_bdev)
  			continue;
 =20

--Signature=_Thu__15_Mar_2012_14_07_30_+1100_KqK_BWGjkVmaGBB4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYVzyAAoJEECxmPOUX5FE2QQQAIYHq5H9SFPcFu3rjtmTibrt
OTc+VIxMpwDKyTTty3IOh4eSpYXHXk20jMkbDJj0tJQKb6inOiSRYBZDa8rKEoyH
B/RhB7QFQo7dW71dkxhmbn5XlslrzXeS+9uP1nWSn/DXbiWpm5KDQ5EaWczTW6rM
1ZNK8+/Nuzc3Jyn5qdhClIbNmCSwRjNaPd7IYSmOq3LWkyF9qF6PGKXaCUPVa4XZ
u8430ugk9BhZSPhPlc+CaUDsC4F7N/+dTUK1NTH1ZxAwL9IUYXI6aMA26Rf3DJhc
0o6yKsw1Q0BfXKHpuqH0Op4RDo6xD16ZwsraIRH2nR6pt9cTFlbJbht/+Z7h/21w
EQl9ECt4l7ax8oA2OD8e7Af3latdrqLs/k9tj25Dmbt5KD1wO13OzUNChk3VmSjb
bTrxPyblob5tmrBDWBZqQJabx8wfb8uwF3Bf6krYxoUXMscoOgFG1Luj02gvxkLt
9PUxBMnnpsvNeDCL1akUgv9V1B7VkVP4fJ/V51yaLtOUp4G++FONI6CGkQO/KM2f
q8awygCr2vxxyI2DWqD5lHRDgKFJs+i8QeO0X9kGLEyY6p+yV7z6ZMG53EPvL7BH
w5k6XF3h5flXE/bun4uQtbczny15rXNRnRdFKtIDvoRg3lmZx9ij++ebuWGAmxgr
9AtTv9DbyH7EDU6TXXLC
=ALzl
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_14_07_30_+1100_KqK_BWGjkVmaGBB4--
