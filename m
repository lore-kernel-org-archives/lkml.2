Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2KEMWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:22:35 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57576 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2KEMWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:22:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 4/5] fat: (exportfs) move code to rebuild directory-inode to separate function
References: <1351389207-2592-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 21:22:31 +0900
In-Reply-To: <1351389207-2592-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 28 Oct 2012 10:53:27 +0900")
Message-ID: <87zk2wkznc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>  /*
> + * Rebuild the parent for a directory that is not connected
> + * to the filesystem root
> + */
> +static
> +struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
> +{
> +	int search_clus, clus_to_match;
> +	struct msdos_dir_entry *de;
> +	struct inode *parent;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
> +	struct buffer_head *parent_bh = sb_bread(sb, blknr);
> +
> +	if (!parent_bh) {
> +		fat_msg(sb, KERN_ERR,
> +			"NFS:unable to read cluster of parent directory");
> +		return NULL;
> +	}
> +	de = (struct msdos_dir_entry *) parent_bh->b_data;
> +	clus_to_match = fat_get_start(sbi, &de[0]);
> +	search_clus = fat_get_start(sbi, &de[1]);
> +	if (!search_clus)
> +		search_clus = sbi->root_cluster;
> +	brelse(parent_bh);
> +	do {
> +		parent =  fat_traverse_cluster(sb,
> +					search_clus, clus_to_match);
> +		if (IS_ERR(parent) || parent)
> +			break;
> +		search_clus = fat_read_next_clus(sb, search_clus);

fat_read_next_clus() only supports FAT32? Looks strange.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
