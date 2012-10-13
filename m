Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2JMJ16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:27:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50244 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2JMJ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:27:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 13 Oct 2012 18:27:54 +0900
In-Reply-To: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 7 Oct 2012 04:32:44 -0400")
Message-ID: <877gqu90x1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
> +		parent_logstart = fat_get_start(sbi, de);
>  		parent_inode = fat_dget(sb, parent_logstart);
> +		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
> +			goto out;
> +		if (!parent_logstart)
> +			/*logstart of dotdot entry is zero if
> +			* if the directory's parent is root
> +			*/
> +			parent_inode = sb->s_root->d_inode;

get_parent() should not be called for root dir, right?

> +			blknr = fat_clus_to_blknr(sbi, parent_logstart);
> +			parent_bh = sb_bread(sb, blknr);
> +			if (!parent_bh) {
> +				fat_msg(sb, KERN_ERR,
> +					"NFS:unable to read cluster of parent directory");
> +				goto out;
> +			}
> +			de = (struct msdos_dir_entry *) parent_bh->b_data;
> +			clus_to_match = fat_get_start(sbi, &de[0]);
> +			search_clus = fat_get_start(sbi, &de[1]);
> +			if (!search_clus)
> +				search_clus = sbi->root_cluster;
> +			brelse(parent_bh);
> +			do {
> +				parent_inode =  fat_traverse_cluster(sb,
> +						search_clus, clus_to_match);
> +				if (IS_ERR(parent_inode) || parent_inode)
> +					break;
> +				search_clus = fat_read_next_clus(sb,
> +								search_clus);
> +				if (search_clus < 0)
> +					break;
> +			} while (search_clus != FAT_ENT_EOF);
> +		}

Please make this part as own function at least. And this is doing same
thing with readdir, so we will have to clean this up as I said before.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
