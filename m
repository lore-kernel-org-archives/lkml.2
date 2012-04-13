Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2DMGfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 02:35:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:10669 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2DMGfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 02:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="130437486"
Message-ID: <1334299108.2544.68.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v1 0/3] do not use s_dirt in FAT FS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 13 Apr 2012 09:38:28 +0300
In-Reply-To: <20120412171257.a0fc35b4.akpm@linux-foundation.org>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
	 <20120412171257.a0fc35b4.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AHz44SS62o243yF5e0ly"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AHz44SS62o243yF5e0ly
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew, thanks for feed-back! CCing Al.

On Thu, 2012-04-12 at 17:12 -0700, Andrew Morton wrote:
> hm, I hadn't actually noticed the arrival of the sync_supers kernel
> thread.

It arrived when Jens added per-block device BDI threads.

> I don't think that the old scheme of calling sync_supers() via the
> writeback (kudate) code was really appropriate.

Sure.

> > TODO: affs, exofs, hfs, hfsplus, jffs2, reiserfs, sysv, udf, ufs
>=20
> That's a lot of work.

Well, may be. But notice:

1. These are baroque file-systems. Modern ones do not use this: xfs,
   btrfs, jfs. Jan Kara has patches which make ext2 stop using
   '->write_super()'. We also sent patches to Ted which make ext4 stop
   using it when it is in non-journal mode (in journal mode it does not
   use it already).

2. Some FSes in the list may not even need '->write_super()'.

Indeed, many file-systems use '->write_super()' to write-out
non-essential optional information, which can be done opportunistically
on unmount/remount/sync_fs instead.

In fact, I think FAT FS is also among those. We do not really need any
timer and it is enough to write out the FSINFO block opportunistically.
Or we may do this in 'fat_write_inode()' when we are writing out the
'fat_inode' which represent the FAT table - seems to make sense because
the FSINFO contains only 2 useful pieces of information about the FAT
table: free clusters and the next free cluster.

I will try this approach.

> I don't really like the implementation.  It implies that we'll be
> copying and pasting quite a lot of boilerplate delayed-work code into
> many different filesystems.  Surely there is a way of hoisting the
> common code up into the vfs library layer.

So basically, my point is:

s/many different filesystems/several baroque file-systems/

> That implies that we retain ->write_super, probably in a modified form.
> Modified to permit the VFS to determine whether the superblock needs
> treatment, if ->s_dirt doesn't suffice.

I tried this approach and it was vetoed by Al Viro. Although it is
simpler to me to resurrect my old patches, I agree with Al that killing
'->write_super()' is a better approach. We do not want to serve a whole
kernel thread in the generic code for few baroque citizens.

Please, see this thread for the reference:
http://lkml.org/lkml/2010/7/22/96

> The code as you've proposed it will cause more wakeups than needed - if
> multiple filesystems are mounted and active, their timers will get out
> of sync.  Which rather defeats the intent of the whole work!  This
> problem should be addressable via some new centralised way of managing
> things.

I do not think this is an issue. If we have many file-systems, and all
of them are actively used so that the super block becomes dirty, which
most probably means there is also write-back - so be it, it is ok to arm
many timers. And if we make them deferrable for most of the FSes (which
we can not do for the generic timer, because we do not know FSes needs)
- then this is not an issue at all.

Also, if you look at this from the angle that only few old FSes will
have this, it becomes not that bad. I assume I will change this
patch-set and won't use delayed works here.

--=20
Best Regards,
Artem Bityutskiy

--=-AHz44SS62o243yF5e0ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPh8nkAAoJECmIfjd9wqK0SXwQALGSpixqZG0HR6RxHbrpwRpG
ZjdNr53PsCI/6TWk2f3im940Syxoi3F81puFhRsR87wpwJwXt5897Gg9uskoMGEs
MWwXnSoVTI04U/B4HUuu9+YKQgw411prSe+eFOqZ8cEFh2e49fz8xgf3s6BoHdk2
rJItCK0ZAM+D4rXpjrNBrG/eOXXzrpXzPyQdxRXFy41dQQGaQs3xWeV+XRLq/txD
OVzJrxBOqG/eKnhu15+zEepjVQoeTjkJ73jiFQEfXU1H/ei8sc+ZReo5ErvhfXkW
ulb4GUS3sNcOA2Ymws1+z/Q0o7I0qWz1M/U9XdA9y2pTLseFSrDtchdcv9YfkOWr
ExvkYvhrZwSJKDpyy687W0IhVNgBsWbUkucgmWDc5miqGoD2cxdtqnVkgRrJT9/f
suwoRoaPALQ8tN6ysmfJBK8FvnT0py9dHQ7N25hDreUUbGBNEn5mOxOPAj9kEW04
h7gH/YyKVq4o33fv+KOEN7gP5ksmonnarM+Z2SFE3dLF9qPN0nAA1ZGfaiw12CD5
b0WO5mzryyp1m80IIf/Q5WMyj6rhYfHzJX+Ma43aCikIe2stHM+zLdgqS0t0Uz6P
yzN4BUX/Xga/VInP0+Zi3A7PmlOOcmv/RDVNn+/jW+oujcgyWhyaw3Ngv6rLqJID
jQZfrLon4t0+jI1eEGat
=t2xY
-----END PGP SIGNATURE-----

--=-AHz44SS62o243yF5e0ly--

