Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2JWHem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:34:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33510 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab2JWHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <877gqu90x1.fsf@devron.myhome.or.jp>
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
Date: Tue, 23 Oct 2012 16:34:39 +0900
Message-ID: <CAKYAXd9Bv4Vv1sk0u9t0d3UubUy8DvTty=WNOFyDxwRuQh=CxA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/13, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
>> +		parent_logstart = fat_get_start(sbi, de);
>>  		parent_inode = fat_dget(sb, parent_logstart);
>> +		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
>> +			goto out;
>> +		if (!parent_logstart)
>> +			/*logstart of dotdot entry is zero if
>> +			* if the directory's parent is root
>> +			*/
>> +			parent_inode = sb->s_root->d_inode;
>
> get_parent() should not be called for root dir, right?
>
>> +			blknr = fat_clus_to_blknr(sbi, parent_logstart);
>> +			parent_bh = sb_bread(sb, blknr);
>> +			if (!parent_bh) {
>> +				fat_msg(sb, KERN_ERR,
>> +					"NFS:unable to read cluster of parent directory");
>> +				goto out;
>> +			}
>> +			de = (struct msdos_dir_entry *) parent_bh->b_data;
>> +			clus_to_match = fat_get_start(sbi, &de[0]);
>> +			search_clus = fat_get_start(sbi, &de[1]);
>> +			if (!search_clus)
>> +				search_clus = sbi->root_cluster;
>> +			brelse(parent_bh);
>> +			do {
>> +				parent_inode =  fat_traverse_cluster(sb,
>> +						search_clus, clus_to_match);
>> +				if (IS_ERR(parent_inode) || parent_inode)
>> +					break;
>> +				search_clus = fat_read_next_clus(sb,
>> +								search_clus);
>> +				if (search_clus < 0)
>> +					break;
>> +			} while (search_clus != FAT_ENT_EOF);
>> +		}
>
Hi. OGAWA.
I have a question.
> Please make this part as own function at least.
Okay, I will make own function.
>And this is doing same
> thing with readdir, so we will have to clean this up as I said before.
When I checked, I didn't understand about same thing readdir and this
function yet. Because even though minor conditions match but
functionality wise both are different.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
