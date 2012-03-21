Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2CUIYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:24:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:57487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab2CUIYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="131393779"
Message-ID: <1332318411.14983.4.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v1 7/9] ext4: stop using VFS for dirty superblock
 management
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 21 Mar 2012 10:26:51 +0200
In-Reply-To: <1332254489-2300-8-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <1332254489-2300-8-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZOG/P0njyzNfG5WVqdWr"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZOG/P0njyzNfG5WVqdWr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-03-20 at 16:41 +0200, Artem Bityutskiy wrote:
> +       INIT_DELAYED_WORK(&sbwork->dwork, write_super);
> +       sbwork->sb =3D sb;
> +       delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);
> +       queue_delayed_work(sbi->dio_unwritten_wq, &sbwork->dwork, delay);=
=20

I've just realized that the side-effect of using DIO workqueue is that
'syncfs()' will also synchronize the superblock because it flushes the
workqueue:

static int ext4_sync_fs(struct super_block *sb, int wait)
{
 	...
        flush_workqueue(sbi->dio_unwritten_wq);
	...
}

But before my change, it seems the superblock was not flushed on
'syncfs()', at least I do no see how this would be done. However, I
think it is OK because I think it is correct to write the dirty
superblock out on 'syncfs()', right?

--=20
Best Regards,
Artem Bityutskiy

--=-ZOG/P0njyzNfG5WVqdWr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPaZDLAAoJECmIfjd9wqK0ilsP/12GqiQABuWbxgXJGR4lSgJF
VdzQDBJTMfnTuA4TAmwW3zHUNS4yE5jPShiIIXqfvYOMay3MXjJytvjTgbaprDdL
up87SoXy9YoKnsHM2w1BgJ6hHU2t+jPb9w1q779QIKDC7yhFHq9OLbAufx6VwYkR
sGDC27e2/wlXFPkYTIa43iRhXupZliMIKZU+N2af3XZZQjV15mBRFIZ4e2tEmxnH
Jz0Mrvc6HSR9mw/VOJ4MmVWUrN5fcfJJGUsmQM/vBY4+QIt+GgqnSyUx6GHzb3YY
FDhFvZ7bjiRMNPPn/GKFg8jV3+gFBX7qP0yUukLEvwTPmSQbqRe3L4katMe/GmFL
o8kTpgGTNDp4iLeebOn0awEOCWaDE4L7R8tIwF2wQW293l46WE3HU1yR1LbHNZ8A
xshVMPRvUUmoPIMCY+iphL3PnzYfNKTwB49BMTvyM1pbqfJSjNVWBJhB0Sx9klM2
fRHabqbNk7JGddZ+NqvMlzjiEp6cfsJzNBDxfbJHIb8wJutWZi4ayiXehjMwkUcD
SVbdVPtGa9GH/SWEXj17hkXm5eRveFDNzH4jUMLaoAjVq47q2X1RFCwdjUXnskn9
wt4+B2XcjhwEKWmsegj4ZHldIjfj+YmPimCfNQ9G0SaepDXLn9JMAejEOTvwtPjk
oO3xxou86KzxD2l31Kbs
=81ES
-----END PGP SIGNATURE-----

--=-ZOG/P0njyzNfG5WVqdWr--

