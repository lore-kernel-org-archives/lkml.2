Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2JPEtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:49:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2JPEtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:49:19 -0400
Date: Tue, 16 Oct 2012 15:49:26 +1100
From: NeilBrown <neilb@suse.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Cc: =?UTF-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 05/16] f2fs: add checkpoint operations
Message-ID: <20121016154926.7936a6df@notabene.brown>
In-Reply-To: <1350056946.2299.82.camel@kjgkr>
References: <000c01cda2f0$dfb82350$9f2869f0$%kim@samsung.com>
	<20121011092412.2576f1f0@notabene.brown>
	<1350056946.2299.82.camel@kjgkr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DPFCBmVxoTwd/bCcAZZhJfW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DPFCBmVxoTwd/bCcAZZhJfW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Oct 2012 00:49:06 +0900 Jaegeuk Kim <jaegeuk.kim@gmail.com> wrot=
e:

> 2012-10-11 (=EB=AA=A9), 09:24 +1100, NeilBrown:
> > On Fri, 05 Oct 2012 20:59:29 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk=
.kim@samsung.com> wrote:
> >=20
> > > +static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > > +{
> > > +	struct f2fs_checkpoint *ckpt =3D F2FS_CKPT(sbi);
> > > +	nid_t last_nid =3D 0;
> > > +	int nat_upd_blkoff[3];
> > > +	block_t start_blk;
> > > +	struct page *cp_page;
> > > +	unsigned int data_sum_blocks, orphan_blocks;
> > > +	void *kaddr;
> > > +	__u32 crc32 =3D 0;
> > > +	int i;
> > > +
> > > +	/* Flush all the NAT/SIT pages */
> > > +	while (get_pages(sbi, F2FS_DIRTY_META))
> > > +		sync_meta_pages(sbi, META, LONG_MAX);
> > > +
> > > +	next_free_nid(sbi, &last_nid);
> > > +
> > > +	/*
> > > +	 * modify checkpoint
> > > +	 * version number is already updated
> > > +	 */
> > > +	ckpt->elapsed_time =3D cpu_to_le64(get_mtime(sbi));
> > > +	ckpt->valid_block_count =3D cpu_to_le64(valid_user_blocks(sbi));
> > > +	ckpt->free_segment_count =3D cpu_to_le32(free_segments(sbi));
> > > +	for (i =3D 0; i < 3; i++) {
> > > +		ckpt->cur_node_segno[i] =3D
> > > +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
> > > +		ckpt->cur_node_blkoff[i] =3D
> > > +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_NODE));
> > > +		nat_upd_blkoff[i] =3D NM_I(sbi)->nat_upd_blkoff[i];
> > > +		ckpt->nat_upd_blkoff[i] =3D cpu_to_le16(nat_upd_blkoff[i]);
> > > +		ckpt->alloc_type[i + CURSEG_HOT_NODE] =3D
> > > +				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
> > > +	}
> > > +	for (i =3D 0; i < 3; i++) {
> > > +		ckpt->cur_data_segno[i] =3D
> > > +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_DATA));
> > > +		ckpt->cur_data_blkoff[i] =3D
> > > +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_DATA));
> > > +		ckpt->alloc_type[i + CURSEG_HOT_DATA] =3D
> > > +				curseg_alloc_type(sbi, i + CURSEG_HOT_DATA);
> > > +	}
> > > +
> > > +	ckpt->valid_node_count =3D cpu_to_le32(valid_node_count(sbi));
> > > +	ckpt->valid_inode_count =3D cpu_to_le32(valid_inode_count(sbi));
> > > +	ckpt->next_free_nid =3D cpu_to_le32(last_nid);
> > > +
> > > +	/* 2 cp  + n data seg summary + orphan inode blocks */
> > > +	data_sum_blocks =3D npages_for_summary_flush(sbi);
> > > +	if (data_sum_blocks < 3)
> > > +		ckpt->ckpt_flags |=3D CP_COMPACT_SUM_FLAG;
> > > +	else
> > > +		ckpt->ckpt_flags &=3D (~CP_COMPACT_SUM_FLAG);
> > > +
> > > +	orphan_blocks =3D (sbi->n_orphans + F2FS_ORPHANS_PER_BLOCK - 1)
> > > +					/ F2FS_ORPHANS_PER_BLOCK;
> > > +	ckpt->cp_pack_start_sum =3D 1 + orphan_blocks;
> > > +	ckpt->cp_pack_total_block_count =3D 2 + data_sum_blocks + orphan_bl=
ocks;
> >=20
> > This looks a bit weird to me, though I might be misunderstanding someth=
ing.
> >=20
> > data_sum_blocks is either 1, 2, or 3.
> > "3" actually means "at least 3".
> >=20
> > If it is 3, you choose not to set CP_COMPACT_SUM_FLAG.  In that case th=
e NAT
> > and SIT journal entries go into SSA blocks, not into the checkpoint at =
all.
> > So in that case, zero blocks of the checkpoint are used for journalling=
.  Yet
> > you still add data_sum_blocks (=3D=3D3) to the cp_pack_total_block_coun=
t (and
> > later to the start block).
> > Is that really what you want to do?  Leave 3 empty blocks?
> >=20
> > I would suggest changing npages_for_summary_flush to return 0 if the nu=
mber
> > of blocks needed would be more than three, and set CP_COMPACT_SUM_FLAG =
only
> > when data_sum_blocks > 0.
> >=20
> > I don't know if you would need to make a corresponding change to the re=
covery
> > code, I haven't fully examined that yet.
>=20
> Ok, let me explain about CP_COMPACT_SUM_FLAG.
> Let's assume that there are some journal entries and data summaries.
> Note that this scenario is not from the umount procedure.
>=20
> Basically f2fs writes three data summary blocks for current active logs
> inside the checkpoint pack.
> And NAT and SIT journal entries are stored in hot and cold data summary
> blocks.
> So, if the CP_COMPACT_SUM_FLAG is not set, f2fs writes the checkpoint
> pack like this.
>=20
> [CP 0]
> [Orphan blocks]
> [Hot sum block w/ NAT journal]
> [Warm sum block]
> [Cold sum block w/ SIT journal]
> [CP 0']
>=20
> But, if the CP_COMPACT_SUM_FLAG is set, the checkpoint pack consists of
> 1 or 2 summary blocks as follows.
>=20
> [CP 0]
> [Orphan blocks]
> [summary entries w/ NAT and SIT journal]
> [CP 0']
>=20
> or,
>=20
> [CP 0]
> [Orphan blocks]
> [summary entries]
> [summary entries w/ NAT and SIT journal]
> [CP 0']
>=20
> So, I think it needs no change.
> Any idea?
> Thanks,

I see.  I missed the fact that the current data summary blocks are always
written to the checkpoint area - I assumed they were being written back to
the SSA.

So it makes sense now and you are right - no change needed.

Thanks,
NeilBrown


>=20
> >=20
> > Regards,
> > NeilBrown
>=20


--Sig_/DPFCBmVxoTwd/bCcAZZhJfW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHznVjnsnt1WYoG5AQJAbA//VDjP79qMuBUFnD9N5X94fh0PPERIxIkE
4oz04Koi0iHMTJoxBsnMhbANJRxBBJCm9EpHa6TxdanlikzvBZkBx1Q3fZ4VxM23
uOjLfJrWdpcTSqlEjDmEjP24Ozr6HU20dfAePjn/ubn6pGp1UzsBxA9l6qP8DnpN
5qze6yjQKzMx/qRUSRxQQiMd7QCJLM8hInDcCEaqj2rqQeK1nGWVt6O540KifCYl
2Lt1B/n/RDiT5AkOBOjbsEMPqcYUJVkTRl85jGVdqSaZWpGEGNHsGAA0uQNB4vam
Jf8noJ9IQq2GgSsPoG7iP77hWwPsH0PPHgiDqlwoQMhnN/npe6gbW8dGskPUmpUa
cuSCxMZuLY3bjM/nXQ7rbpQjeQyv/5Hebo6W5fAfcRpTKgHzyGb28CY+72+xKVi7
lMK5tV2CG9wwtjNLq/3MhQ4nk7hoph+ehFckBi0dcThs5Hakb4MJnfraiNk7acGV
x1jeKNpE8lGhLuJgKOmMS1X2UXl2hZhVlXeRqFkvc47qCiI2flOwSY9G6hwqsL0F
LADb2siu3ol8xz57P4OHqVpgG2vXqPkLd4EwjfaE0/tMRxW4o+TCeFRrV6+2/ADx
cVNJJY3B06W5dsiy4WUF0FRPwyno2KJwQIshthm6yOTSWQIbmHYQ+TzdX+uyp9vH
fRjiTgVH3r0=
=8fcy
-----END PGP SIGNATURE-----

--Sig_/DPFCBmVxoTwd/bCcAZZhJfW--
