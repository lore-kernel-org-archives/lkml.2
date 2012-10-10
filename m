Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2JJWuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:50:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab2JJWum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:50:42 -0400
Date: Thu, 11 Oct 2012 09:50:44 +1100
From: NeilBrown <neilb@suse.de>
To: =?utf-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 03/16] f2fs: add superblock and major in-memory
 structures
Message-ID: <20121011095044.6c88e3d4@notabene.brown>
In-Reply-To: <000a01cda2f0$a2375b40$e6a611c0$%kim@samsung.com>
References: <000a01cda2f0$a2375b40$e6a611c0$%kim@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/adwKK_znefaVZjOzCqV5X_m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/adwKK_znefaVZjOzCqV5X_m
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Oct 2012 20:57:46 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk.kim=
@samsung.com> wrote:


> +static inline unsigned int curseg_segno(struct f2fs_sb_info *sbi,
> +		int type)
> +{
> +	struct curseg_info *curseg =3D CURSEG_I(sbi, type);
> +	unsigned int segno;
> +	mutex_lock(&curseg->curseg_mutex);
> +	segno =3D curseg->segno;
> +	mutex_unlock(&curseg->curseg_mutex);
> +	return segno;
> +}
> +
> +static inline unsigned char curseg_alloc_type(struct f2fs_sb_info *sbi,
> +		int type)
> +{
> +	struct curseg_info *curseg =3D CURSEG_I(sbi, type);
> +	unsigned char a_type;
> +	mutex_lock(&curseg->curseg_mutex);
> +	a_type =3D curseg->alloc_type;
> +	mutex_unlock(&curseg->curseg_mutex);
> +	return a_type;
> +}
> +
> +static inline unsigned short curseg_blkoff(struct f2fs_sb_info *sbi, int=
 type)
> +{
> +	struct curseg_info *curseg =3D CURSEG_I(sbi, type);
> +	unsigned short blkoff;
> +	mutex_lock(&curseg->curseg_mutex);
> +	blkoff =3D curseg->next_blkoff;
> +	mutex_unlock(&curseg->curseg_mutex);
> +	return blkoff;
> +}

Taking a mutex just to extract a small number from a structure is pointless.
alloc_type, next_blkoff and segno are char, short, and int.  All of these c=
an
be read atomically, so a lock gains you nothing.

In checkpoint.c we have
	for (i =3D 0; i < 3; i++) {
		ckpt->cur_node_segno[i] =3D
			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
		ckpt->cur_node_blkoff[i] =3D
			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_NODE));
		nat_upd_blkoff[i] =3D NM_I(sbi)->nat_upd_blkoff[i];
		ckpt->nat_upd_blkoff[i] =3D cpu_to_le16(nat_upd_blkoff[i]);
		ckpt->alloc_type[i + CURSEG_HOT_NODE] =3D
				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
	}

which will take and drop that same lock 3 times in quick succession, and th=
en
do it again for 3 other locks (And there is another loop which does it for
the other 3 cursegs).

If you do need some locking here, I think you need to take the lock once per
loop iteration so the 3 values are consistent, not once for each value.


Regards,
NeilBrown


> +
> +static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned in=
t segno)
> +{
> +	unsigned int end_segno =3D SM_I(sbi)->segment_count - 1;
> +	BUG_ON(segno > end_segno);
> +}
> +
> +/*
> + * This function is used for only debugging.
> + * NOTE: In future, we have to remove this function.
> + */
> +static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t b=
lk_addr)
> +{
> +	struct f2fs_sm_info *sm_info =3D SM_I(sbi);
> +	block_t total_blks =3D sm_info->segment_count << sbi->log_blocks_per_se=
g;
> +	block_t start_addr =3D sm_info->seg0_blkaddr;
> +	block_t end_addr =3D start_addr + total_blks - 1;
> +	BUG_ON(blk_addr < start_addr);
> +	BUG_ON(blk_addr > end_addr);
> +}
> +
> +/**
> + * Summary block is always treated as invalid block
> + */
> +static inline void check_block_count(struct f2fs_sb_info *sbi,
> +		int segno, struct f2fs_sit_entry *raw_sit)
> +{
> +	struct f2fs_sm_info *sm_info =3D SM_I(sbi);
> +	unsigned int end_segno =3D sm_info->segment_count - 1;
> +	int valid_blocks =3D 0;
> +	int i;
> +
> +	/* check segment usage */
> +	BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg);
> +
> +	/* check boundary of a given segment number */
> +	BUG_ON(segno > end_segno);
> +
> +	/* check bitmap with valid block count */
> +	for (i =3D 0; i < sbi->blocks_per_seg; i++)
> +		if (f2fs_test_bit(i, raw_sit->valid_map))
> +			valid_blocks++;
> +	BUG_ON(GET_SIT_VBLOCKS(raw_sit) !=3D valid_blocks);
> +}
> +
> +static inline pgoff_t current_sit_addr(struct f2fs_sb_info *sbi,
> +						unsigned int start)
> +{
> +	struct sit_info *sit_i =3D SIT_I(sbi);
> +	unsigned int offset =3D SIT_BLOCK_OFFSET(sit_i, start);
> +	block_t blk_addr =3D sit_i->sit_base_addr + offset;
> +
> +	check_seg_range(sbi, start);
> +
> +	/* calculate sit block address */
> +	if (f2fs_test_bit(offset, sit_i->sit_bitmap))
> +		blk_addr +=3D sit_i->sit_blocks;
> +
> +	return blk_addr;
> +}
> +
> +static inline pgoff_t next_sit_addr(struct f2fs_sb_info *sbi,
> +						pgoff_t block_addr)
> +{
> +	struct sit_info *sit_i =3D SIT_I(sbi);
> +	block_addr -=3D sit_i->sit_base_addr;
> +	if (block_addr < sit_i->sit_blocks)
> +		block_addr +=3D sit_i->sit_blocks;
> +	else
> +		block_addr -=3D sit_i->sit_blocks;
> +
> +	return block_addr + sit_i->sit_base_addr;
> +}
> +
> +static inline void set_to_next_sit(struct sit_info *sit_i, unsigned int =
start)
> +{
> +	unsigned int block_off =3D SIT_BLOCK_OFFSET(sit_i, start);
> +
> +	if (f2fs_test_bit(block_off, sit_i->sit_bitmap))
> +		f2fs_clear_bit(block_off, sit_i->sit_bitmap);
> +	else
> +		f2fs_set_bit(block_off, sit_i->sit_bitmap);
> +}
> +
> +static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
> +{
> +	uint32_t d =3D divisor;
> +
> +	if (divisor > 0xffffffffUll) {
> +		unsigned int shift =3D fls(divisor >> 32);
> +		d =3D divisor >> shift;
> +		dividend >>=3D shift;
> +	}
> +
> +	if (dividend >> 32)
> +		do_div(dividend, d);
> +	else
> +		dividend =3D (uint32_t) dividend / d;
> +
> +	return dividend;
> +}
> +
> +static inline unsigned long long get_mtime(struct f2fs_sb_info *sbi)
> +{
> +	struct sit_info *sit_i =3D SIT_I(sbi);
> +	return sit_i->elapsed_time + CURRENT_TIME_SEC.tv_sec -
> +						sit_i->mounted_time;
> +}
> +
> +static inline void set_summary(struct f2fs_summary *sum, nid_t nid,
> +			unsigned int ofs_in_node, unsigned char version)
> +{
> +	sum->nid =3D cpu_to_le32(nid);
> +	sum->ofs_in_node =3D cpu_to_le16(ofs_in_node);
> +	sum->version =3D version;
> +}
> +
> +static inline block_t start_sum_block(struct f2fs_sb_info *sbi)
> +{
> +	return __start_cp_addr(sbi) +
> +		le32_to_cpu(F2FS_CKPT(sbi)->cp_pack_start_sum);
> +}
> +
> +static inline block_t sum_blk_addr(struct f2fs_sb_info *sbi, int base, i=
nt type)
> +{
> +	return __start_cp_addr(sbi) +
> +		le32_to_cpu(F2FS_CKPT(sbi)->cp_pack_total_block_count)
> +				- (base + 1) + type;
> +}


--Sig_/adwKK_znefaVZjOzCqV5X_m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHX7xDnsnt1WYoG5AQL/Gg/6AvzfYfeRB4VONWQmEaC0g9XQGxJB1exf
7HUuI8TdFc8mCf9De4Qm77fCJbNc/Q2JT9rev7oPRCopOu7C5hm/7HcOq9MA3SR6
EWEfAsq1UugV9gpRJhe89NR3nZ2tpQ41FK27VCH8zNIlosZKlFz/k+koekcz/TYJ
bqWRUbtaAInbjDu2I3OH66LbIFIVz6pMxp4xMRrHgdxI3ggnCNsamVaIe/SNJiT9
NHRhxiUhNSLoQw5dk2wnsfnIhXvA0s3sNsPZ7SOd7Z18hTadM0UAO3zPaaOd9SE0
fiYgwt3v8nWBlYW+JD0q3zXGHcW16zUKjQU9EfqoV3cOCVfA/ugm8YofxvF/UEYb
B8u0q0R+oYigwPi3c0nAjlDuIWPUGoJt84pJy8XtO1kXtUPoKXvGr6yGISYp0eWY
gZRGSz8JbjXEKT+Coqy+EAz7DttyVoZUuNOuLcmEKACP8jQhiyOHRkIXzc0srcu7
4S5enAPP2yQKtVWUlPWLMmW1leazdwF9x9Bb4nyHuIqntdEZdH4yhOJ2BFSQ0VZi
AMXysBpEixC3VO7np8h4EQ+xo9J0JtyoDWlDPR4p62NEpo9tT5wMQuFuw6axnX/K
2SbBLRvfJDXZF8yhkGkj1oHCAp+sHuDS4zkHIh5Dxwj/Hqd1lHiLM0lzxaoncUZl
6hE23/Sd1mo=
=p8Y9
-----END PGP SIGNATURE-----

--Sig_/adwKK_znefaVZjOzCqV5X_m--
