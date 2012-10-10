Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2JJWYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:24:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab2JJWYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:24:09 -0400
Date: Thu, 11 Oct 2012 09:24:12 +1100
From: NeilBrown <neilb@suse.de>
To: =?utf-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 05/16] f2fs: add checkpoint operations
Message-ID: <20121011092412.2576f1f0@notabene.brown>
In-Reply-To: <000c01cda2f0$dfb82350$9f2869f0$%kim@samsung.com>
References: <000c01cda2f0$dfb82350$9f2869f0$%kim@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ltais7Z=d.QU61i8EhAF86h"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ltais7Z=d.QU61i8EhAF86h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Oct 2012 20:59:29 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk.kim=
@samsung.com> wrote:

> +static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> +{
> +	struct f2fs_checkpoint *ckpt =3D F2FS_CKPT(sbi);
> +	nid_t last_nid =3D 0;
> +	int nat_upd_blkoff[3];
> +	block_t start_blk;
> +	struct page *cp_page;
> +	unsigned int data_sum_blocks, orphan_blocks;
> +	void *kaddr;
> +	__u32 crc32 =3D 0;
> +	int i;
> +
> +	/* Flush all the NAT/SIT pages */
> +	while (get_pages(sbi, F2FS_DIRTY_META))
> +		sync_meta_pages(sbi, META, LONG_MAX);
> +
> +	next_free_nid(sbi, &last_nid);
> +
> +	/*
> +	 * modify checkpoint
> +	 * version number is already updated
> +	 */
> +	ckpt->elapsed_time =3D cpu_to_le64(get_mtime(sbi));
> +	ckpt->valid_block_count =3D cpu_to_le64(valid_user_blocks(sbi));
> +	ckpt->free_segment_count =3D cpu_to_le32(free_segments(sbi));
> +	for (i =3D 0; i < 3; i++) {
> +		ckpt->cur_node_segno[i] =3D
> +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
> +		ckpt->cur_node_blkoff[i] =3D
> +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_NODE));
> +		nat_upd_blkoff[i] =3D NM_I(sbi)->nat_upd_blkoff[i];
> +		ckpt->nat_upd_blkoff[i] =3D cpu_to_le16(nat_upd_blkoff[i]);
> +		ckpt->alloc_type[i + CURSEG_HOT_NODE] =3D
> +				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
> +	}
> +	for (i =3D 0; i < 3; i++) {
> +		ckpt->cur_data_segno[i] =3D
> +			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_DATA));
> +		ckpt->cur_data_blkoff[i] =3D
> +			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_DATA));
> +		ckpt->alloc_type[i + CURSEG_HOT_DATA] =3D
> +				curseg_alloc_type(sbi, i + CURSEG_HOT_DATA);
> +	}
> +
> +	ckpt->valid_node_count =3D cpu_to_le32(valid_node_count(sbi));
> +	ckpt->valid_inode_count =3D cpu_to_le32(valid_inode_count(sbi));
> +	ckpt->next_free_nid =3D cpu_to_le32(last_nid);
> +
> +	/* 2 cp  + n data seg summary + orphan inode blocks */
> +	data_sum_blocks =3D npages_for_summary_flush(sbi);
> +	if (data_sum_blocks < 3)
> +		ckpt->ckpt_flags |=3D CP_COMPACT_SUM_FLAG;
> +	else
> +		ckpt->ckpt_flags &=3D (~CP_COMPACT_SUM_FLAG);
> +
> +	orphan_blocks =3D (sbi->n_orphans + F2FS_ORPHANS_PER_BLOCK - 1)
> +					/ F2FS_ORPHANS_PER_BLOCK;
> +	ckpt->cp_pack_start_sum =3D 1 + orphan_blocks;
> +	ckpt->cp_pack_total_block_count =3D 2 + data_sum_blocks + orphan_blocks;

This looks a bit weird to me, though I might be misunderstanding something.

data_sum_blocks is either 1, 2, or 3.
"3" actually means "at least 3".

If it is 3, you choose not to set CP_COMPACT_SUM_FLAG.  In that case the NAT
and SIT journal entries go into SSA blocks, not into the checkpoint at all.
So in that case, zero blocks of the checkpoint are used for journalling.  Y=
et
you still add data_sum_blocks (=3D=3D3) to the cp_pack_total_block_count (a=
nd
later to the start block).
Is that really what you want to do?  Leave 3 empty blocks?

I would suggest changing npages_for_summary_flush to return 0 if the number
of blocks needed would be more than three, and set CP_COMPACT_SUM_FLAG only
when data_sum_blocks > 0.

I don't know if you would need to make a corresponding change to the recove=
ry
code, I haven't fully examined that yet.

Regards,
NeilBrown

--Sig_/Ltais7Z=d.QU61i8EhAF86h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHX1jDnsnt1WYoG5AQK9Iw//bAIWWl+KP3M6gvROaGLy+AtRpH2Q2nT5
Rt2lbjByUNqu8d1cE5hcTURAuz7hdgskrjHZcdCUx0ziKuKxUUqHy3hKUmaktx0K
TzvjNjCe63wDiwonjipWbB8x5wtkwyahEkr/ZodifNCcgz5/4R1XaRvJcfjxbh7o
ft3GC0MHqV9MhVG7G14W0p9t+NZsJc6ug7NXAMFQwz8DnI9jtMaQN0HWVvuz0/lo
A6BE/wv1g0o6zFc5Afb6I6eauTm57coGOMeakfPYjB/68z8Z7JQk8OahrFjljSsh
gvepTa1bd2CdRgN0vOEdGN2ShRjQpy+89PszFR9An5qjQeFDF0EPuoduv8dLnBRO
qP6mJPgPVM9vrOvAgO3LMEievgq/9VXr8chDDk7xbMvR+hYfs7tmJj+yIrWsg6ko
2BrdkNWiz1RqoNDCvQ63RSSKwRY09G4lq3aCl7bUgcD25nSsFUM8RZbN0tsKPTda
G60wqckwTN3OBjIgHdCZricoKNWgXpWdRZH4xAlLyTTQu5s78pwx4kBX6wi3fYza
mqgu+AoVfzZTsAuFoAljfKPR3VEdUt+P5BqSgJ5TKtCatNbslUZzvHoxuvHFFoo+
aF8TiebJIkR0odFbJS8g+dvUsi9OsxBfIkfOBFD0hU4+y/eBCMl9tFmqVq1el8Ls
z/nlwcnJFkw=
=tS8e
-----END PGP SIGNATURE-----

--Sig_/Ltais7Z=d.QU61i8EhAF86h--
