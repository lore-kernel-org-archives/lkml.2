Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1DNQYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:24:03 -0400
Received: from postman.teamix.net ([194.150.191.120]:52112 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415Ab1DNQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:24:01 -0400
X-Greylist: delayed 1298 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 12:24:00 EDT
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Understanding buffers / buffer cache
Date: Thu, 14 Apr 2011 14:16:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.2-tp42-snapshot-p1+2-dirty; KDE/4.6.1; i686; ; )
Cc: linux-mm@vger.kernel.org, Mega Maddin <maddin@megamaddin.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2420646.9ufc8KacDd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104141417.10748.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2420646.9ufc8KacDd
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Please keep either linux-kernel or my address as cc, as I am only subscribe=
d=20
to linux-kernel, not linux-mm.


Hi!

In this weeks Linux performance analysis and tuning course that I hold ther=
e=20
have been detailed questions about what the Linux kernel uses the memory fo=
r=20
that free displays under "buffers".

I know as much:

=2D it is for buffers that have to be written to disk at some time (opposed=
 to=20
caches which are for reads)

=2D it is somewhat related to pdflush / flush-major:minor threads, XFS does=
n't use=20
these (but uses xfsbufd / xfsyncd) instead

=2D observation is, that it doesn't increase much on a simple dd, but does=
=20
increase much more on a tar -xf linux-x.y.tar.gz (after a echo 3 >=20
/proc/sys/vm/drop_caches)

=2D the data to be written via dd instead displays with Dirty: and then=20
Writeback and /proc/meminfo


Thus I thought buffers were mainly related to metadata stuff.


But one course member (on cc) digged into the kernel source and found it wi=
th:

=2D fs/block_dev.c:

=2D long nr_blockdev_pages(void)
{
        struct block_device *bdev;
        long ret =3D 0;
        spin_lock(&bdev_lock);
        list_for_each_entry(bdev, &all_bdevs, bd_list) {
                ret +=3D bdev->bd_inode->i_mapping->nrpages;
        }
        spin_unlock(&bdev_lock);
        return ret;
}

=2D include/fs.h:

struct block_device {
        dev_t                   bd_dev;  /* not a kdev_t - it's a search ke=
y=20
*/
        struct inode *          bd_inode;       /* will die */

[...]

struct inode {
        /* RCU path lookup touches following: */
[...]
        struct address_space    *i_mapping;


=2D And then this in lots of places:

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.38/linux-2.6.38.y> find -n=
ame=20
"*.c" -or -name "*.h" | xargs grep i_mapping
=2E/include/linux/fs.h:   struct address_space    *i_mapping;
=2E/include/linux/fs.h:           invalidate_mapping_pages(inode->i_mapping=
, 0,=20
=2D1);
=2E/include/trace/events/ext4.h:          __entry->writeback_index =3D inod=
e-
>i_mapping->writeback_index;
=2E/include/trace/events/ext4.h:          __entry->writeback_index =3D inod=
e-
>i_mapping->writeback_index;
=2E/kernel/cgroup.c:              inode->i_mapping->backing_dev_info =3D=20
&cgroup_backing_dev_info;
=2E/arch/powerpc/platforms/cell/spufs/file.c:             ctx->local_store =
=3D=20
inode->i_mapping;
=2E/arch/powerpc/platforms/cell/spufs/file.c:             ctx->cntl =3D ino=
de-
>i_mapping;
[...]
=2E/arch/tile/kernel/smp.c:static unsigned long __iomem *ipi_mappings[NR_CP=
US];
=2E/arch/tile/kernel/smp.c:               ipi_mappings[cpu] =3D=20
ioremap_prot(offset, PAGE_SIZE, pte);
=2E/arch/tile/kernel/smp.c:       ((unsigned long __force *)ipi_mappings[cp=
u])
[IRQ_RESCHEDULE] =3D 0;
[...]

including various filesystems where it seems to be used related to metadata=
=20
*and* file I/O as well as "journal" / cow I/O. For example:

=2E/fs/btrfs/inode.c:             page =3D find_get_page(inode->i_mapping,
=2E/fs/btrfs/inode.c:                                        inode->i_mappi=
ng,=20
start,
=2E/fs/btrfs/inode.c:             inode->i_mapping->a_ops =3D &btrfs_aops;
=2E/fs/btrfs/inode.c:             inode->i_mapping->backing_dev_info =3D &r=
oot-
>fs_info->bdi;
[...]
=2E/fs/btrfs/ordered-data.c:          !mapping_tagged(inode->i_mapping,=20
PAGECACHE_TAG_DIRTY)) {
=2E/fs/btrfs/ordered-data.c:                              filemap_flush(ino=
de-
>i_mapping);
=2E/fs/btrfs/ordered-data.c:              filemap_fdatawrite_range(inode-
>i_mapping, start, end);
=2E/fs/btrfs/ordered-data.c:      filemap_fdatawrite_range(inode->i_mapping=
,=20
start, orig_end);
=2E/fs/btrfs/ordered-data.c:      filemap_fdatawrite_range(inode->i_mapping=
,=20
start, orig_end);
=2E/fs/btrfs/ordered-data.c:      filemap_fdatawait_range(inode->i_mapping,=
=20
start, orig_end);
[...]
=2E/fs/btrfs/file.c:              pages[i] =3D grab_cache_page(inode->i_map=
ping,=20
index + i);
=2E/fs/btrfs/file.c:      current->backing_dev_info =3D inode->i_mapping-
>backing_dev_info;
=2E/fs/btrfs/file.c:                              filemap_fdatawrite_range(=
inode-
>i_mapping, pos,
=2E/fs/btrfs/file.c:                                                      i=
node-
>i_mapping,
=2E/fs/btrfs/file.c:                      invalidate_mapping_pages(inode-
>i_mapping,
=2E/fs/btrfs/file.c:                      filemap_flush(inode->i_mapping);




So what exactly are buffers used for? Is there any up-to-date and detailed=
=20
documentation or howto or explaination available? Most hits I found on sear=
ch=20
engine are either quite short and vague or relate to really old kernel=20
versions.

Is there any detailed explaination available on how - as in which steps - t=
he=20
Linux kernel writes certain kinds of data like

=2D inode / metadata traffic
=2D dirty pages (ok, via pdlush / flush, as long as one process doesn't ove=
ruse=20
it)
=2D I/O from processes by using system functions like write()
=2D direct i/o

Or do you have any hints on what source files to read in order to understan=
d=20
more regarding these questions?

Thanks,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart2420646.9ufc8KacDd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk2m5bkACgkQHhDFkwOZrpDLbACgiYeJYVCIS+nKPAZbF415qLGk
GZwAniY5XuuqzXblUdvHbz7AOPY6QKrH
=ZQu3
-----END PGP SIGNATURE-----

--nextPart2420646.9ufc8KacDd--
