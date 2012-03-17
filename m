Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423023Ab2CQBQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 21:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2CQBQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 21:16:12 -0400
Date: Fri, 16 Mar 2012 21:16:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Will Drewry <wad@chromium.org>
cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dm: remake of the verity target
In-Reply-To: <CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203152149190.20644@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com> <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
 <CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185242623-2024785336-1331922882=:20644"
Content-ID: <Pine.LNX.4.64.1203161434530.9000@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185242623-2024785336-1331922882=:20644
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1203161434531.9000@file.rdu.redhat.com>

Hi Will


On Wed, 14 Mar 2012, Will Drewry wrote:

> Hi Mikulas,
>=20
> This is a nice rewrite and takes advantage of your dm-bufio layer. I
> wish it'd existed (and or we wrote it :) in 2009 when we started this
> work!  Some comments below:
>=20
> > ---
> > +static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_i=
o *io)
> > +{
> > + =A0 =A0 =A0 int i;
> > + =A0 =A0 =A0 for (i =3D v->levels - 2; i >=3D 0; i--) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_start;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_end;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block, i, &ha=
sh_block_start, NULL);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block + io->n=
_blocks - 1, i, &hash_block_end, NULL);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!i) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned cluster =3D pref=
etch_cluster;
> > + =A0 =A0 =A0 =A0/* barrier to stop GCC from re-reading prefetch_cluste=
r again */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster >>=3D v->data_dev=
_block_bits;
>=20
> Would:
>   unsigned cluster =3D prefetch_cluster >> v->data_dev_block_bits;
> not have similar behavior without a barrier?  (Yeah yeah I could
> compile and see, but I was curious if you already had.)
>=20
> Since the max iterations here is 61 in a worst-case, I don't think
> it's a big deal to barrier() each time, just thought I'd ask.
>=20
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!cluster))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no_p=
refetch_cluster;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(cluster & (c=
luster - 1)))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster =
=3D 1 << (fls(cluster) - 1);
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_start &=3D ~(s=
ector_t)(cluster - 1);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_end |=3D clust=
er - 1;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(hash_block_e=
nd >=3D v->hash_blocks))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_bloc=
k_end =3D v->hash_blocks - 1;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > +no_prefetch_cluster:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bufio_prefetch(v->bufio, hash_block_st=
art,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 hash_block_end - hash_block_start + 1);

The problem here is this. If you look at the code, you think that after=20
the clause "if (unlikely(!cluster)) goto no_prefetch_cluster;", cluster=20
can't be zero. But this assumption is wrong. The C compiler is allowed to=
=20
transform the above code into:

unsigned cluster;
if (!(prefetch_cluster >> v->data_dev_block_bits))
=09goto no_prefetch_cluster;
cluster =3D prefetch_cluster >> v->data_dev_block_bits;
if (unlikely(cluster & (cluster - 1)))
=09cluster =3D 1 << (fls(cluster) - 1);

I know it's suboptimal, but the C compiler is just allowed to perform this=
=20
transformation. Now, if you know that "prefetch_cluster" can change=20
asynchronously by another thread running simultaneously, the condition "if=
=20
(!(prefetch_cluster >> v->data_dev_block_bits))" is useless ---=20
prefetch_cluster may change just after this condition and we won't catch=20
the zero value. (if the cluster value is zero in the above code, it ends=20
up in hash_block_end being ORed with -1 and the prefetch goes wild over=20
the whole hash device).

That's why I put that "barrier()" there. It would be better to declare=20
"prefetch_cluster" as volatile, but the module param macros issue warnings=
=20
if the variable is volatile.

Or maybe I can change it this way:
"unsigned cluster =3D *(volatile unsigned *)&prefetch_cluster", it could be=
=20
better than the "barrier()".

> > + =A0 =A0 =A0 case STATUSTYPE_TABLE:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("%u %s %s %llu %u %s ",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->data_dev->name,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->hash_dev->name,
>=20
> I understand the new approach is to use major:minor instead of the
> device name.  I don't care which, but I believe agk@ requested that.

All the device mappers report dm_dev->name in their status routine, so I=20
do it this way too.

> > +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long arg)
> > +{
> > + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> > + =A0 =A0 =A0 int r =3D 0;
> > +
> > + =A0 =A0 =A0 if (v->data_start ||
> > + =A0 =A0 =A0 =A0 =A0 ti->len !=3D i_size_read(v->data_dev->bdev->bd_in=
ode) >> SECTOR_SHIFT)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D scsi_verify_blk_ioctl(NULL, cmd);
> > +
>=20
> Is it worth supporting ioctl at all given these hoops?  Nothing stops
> a privileged user from directly running the ioctl on the underlying
> device/devices, it's just very inconvenient :)

I don't know. The other dm targets attempt to pass-thru ioctls too.

You need ioctl pass-thru if you want to run it over a cd-rom because=20
the iso9660 filesystem needs to send an ioctl to find its superblock.=20
Other than that I don't know if other filesystems need ioctls.

> > + =A0 =A0 =A0 if (ti->len > i_size_read(v->data_dev->bdev->bd_inode) >>=
 SECTOR_SHIFT) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device si too small";
>=20
> s/si/is
>=20
> Should this also check ti->start + ti->len to ensure it isn't reading
> off the end or do you just rely on the requests failing?

ti->start is the offset in the target table --- so it shouldn't be checked=
=20
here (for example, you can map a verity device having 1024 blocks to a=20
sector offset 1000000 in the table --- so ti->start =3D=3D 1000000 and ti->=
len=20
=3D=3D 1024 --- in this case, you have test that the underlying device has =
at=20
least 1024 blocks, but you shouldn't test it for 1000000 sectors ---=20
1000000 is offset in the table, not required device size.

But this reminds me that I had the size test wrong in verity_map ...=20
fixed.

> > +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
>=20
> As per linux/module.h, I'd welcome additional authors as per the
> lkml/patch lineage:
> MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
> MODULE_AUTHOR("Will Drewry <wad@chromium.org>");

OK, I added you there.

> Regardless, I'll just be happy to see this functionality merge.
>=20
> > +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity che=
cking");
> > +MODULE_LICENSE("GPL");
> > +
> > Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c
>=20
> This should be in a separate patch I think.

Yes, it is a separate patch.

> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0b->hold_count++;
>=20
> Are these hold_counts safe on architectures with weak memory models?
> Should they be atomic_ts?   I haven't looked at them in context, but
> based on what I see here they make me a bit nervous.
>=20
> Thanks for jumping in to the fray!  None of my comments are blocking,
> so I believe the following is appropriate (if not
> s/Signed-off/Reviewed-by/).
>=20
> Signed-off-by: Will Drewry <wad@chromium.org>
>=20
> cheers!
> will

hold_count is read or changed only when we hold dm_bufio_client->lock, so=
=20
it doesn't have to be atomic.

Mikulas
--185242623-2024785336-1331922882=:20644--
