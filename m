Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2IXENU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:13:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36237 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2IXENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <87haqq8et5.fsf@devron.myhome.or.jp>
References: <1347798163-2697-1-git-send-email-linkinjeon@gmail.com>
	<87haqq8et5.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 13:13:17 +0900
Message-ID: <CAKYAXd8Zpe8sAfMs-GVBaiafJSU7jO4Yj=qRmFo2w+ho9GD5sQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] fat (exportfs): rebuild inode if ilookup() fails
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

2012/9/22, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED) {
>> +		struct buffer_head *bh = NULL;
>> +		struct msdos_dir_entry *de ;
>> +		loff_t i_pos = (loff_t)ino;
>> +		int bits = MSDOS_SB(sb)->dir_per_block_bits;
>> +		loff_t blocknr = i_pos >> bits;
>> +		bh = sb_bread(sb, blocknr);
>> +		if (!bh) {
>> +			fat_msg(sb, KERN_ERR,
>> +				 "unable to read block(%llu) for building NFS inode",
>> +				(llu)blocknr);
>> +			return inode;
>> +		}
>> +		de = (struct msdos_dir_entry *)bh->b_data;
>> +		/* If a file is deleted on server and client is not updated
>> +		 * yet, we must not build the inode upon a lookup call.
>> +		 */
>> +		if (de[i_pos&((1<<bits)-1)].name[0] == DELETED_FLAG)
>
> IS_FREE() would be better.
Okay~ I will change.
>
>> +
>> +			inode = NULL;
>> +		else
>> +			inode = fat_build_inode(sb, &de[i_pos&((1<<bits)-1)],
>> +					i_pos);
>> +		brelse(bh);
>> +	}
>>
>>  	return inode;
>>  }
>
> 1 << bits == sbi->dir_per_block
>
> It would be better to add helper to decode i_pos to blocknr and offset.
> And it should be shared on fat_write_inode and this.
Okay, I will change.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
