Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132Ab2JLObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:31:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40941 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2JLObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:31:11 -0400
Message-ID: <1350052261.2299.31.camel@kjgkr>
Subject: Re: [PATCH 03/16] f2fs: add superblock and major in-memory
 structures
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Fri, 12 Oct 2012 23:31:01 +0900
In-Reply-To: <20121011095044.6c88e3d4@notabene.brown>
References: <000a01cda2f0$a2375b40$e6a611c0$%kim@samsung.com>
	 <20121011095044.6c88e3d4@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-11 (목), 09:50 +1100, NeilBrown:
> On Fri, 05 Oct 2012 20:57:46 +0900 김재극 <jaegeuk.kim@samsung.com> wrote:
> 
> 
> > +static inline unsigned int curseg_segno(struct f2fs_sb_info *sbi,
> > +		int type)
> > +{
> > +	struct curseg_info *curseg = CURSEG_I(sbi, type);
> > +	unsigned int segno;
> > +	mutex_lock(&curseg->curseg_mutex);
> > +	segno = curseg->segno;
> > +	mutex_unlock(&curseg->curseg_mutex);
> > +	return segno;
> > +}
> > +
> > +static inline unsigned char curseg_alloc_type(struct f2fs_sb_info *sbi,
> > +		int type)
> > +{
> > +	struct curseg_info *curseg = CURSEG_I(sbi, type);
> > +	unsigned char a_type;
> > +	mutex_lock(&curseg->curseg_mutex);
> > +	a_type = curseg->alloc_type;
> > +	mutex_unlock(&curseg->curseg_mutex);
> > +	return a_type;
> > +}
> > +
> > +static inline unsigned short curseg_blkoff(struct f2fs_sb_info *sbi, int type)
> > +{
> > +	struct curseg_info *curseg = CURSEG_I(sbi, type);
> > +	unsigned short blkoff;
> > +	mutex_lock(&curseg->curseg_mutex);
> > +	blkoff = curseg->next_blkoff;
> > +	mutex_unlock(&curseg->curseg_mutex);
> > +	return blkoff;
> > +}
> 
> Taking a mutex just to extract a small number from a structure is pointless.
> alloc_type, next_blkoff and segno are char, short, and int.  All of these can
> be read atomically, so a lock gains you nothing.
> 
> In checkpoint.c we have
> 	for (i = 0; i < 3; i++) {
> 		ckpt->cur_node_segno[i] =
> 			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
> 		ckpt->cur_node_blkoff[i] =
> 			cpu_to_le16(curseg_blkoff(sbi, i + CURSEG_HOT_NODE));
> 		nat_upd_blkoff[i] = NM_I(sbi)->nat_upd_blkoff[i];
> 		ckpt->nat_upd_blkoff[i] = cpu_to_le16(nat_upd_blkoff[i]);
> 		ckpt->alloc_type[i + CURSEG_HOT_NODE] =
> 				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
> 	}
> 
> which will take and drop that same lock 3 times in quick succession, and then
> do it again for 3 other locks (And there is another loop which does it for
> the other 3 cursegs).
> 
> If you do need some locking here, I think you need to take the lock once per
> loop iteration so the 3 values are consistent, not once for each value.
> 

Definitely it's right.
Thank you.

> 
> Regards,
> NeilBrown
> 
> 
[snip]

-- 
Jaegeuk Kim
Samsung

