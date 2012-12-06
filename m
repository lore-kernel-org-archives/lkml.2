Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2LFJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:25:26 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45914 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2LFJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:24:54 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
	<CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
	<87obia17zr.fsf@devron.myhome.or.jp>
	<CAKYAXd-8ay4m6vsH1ztmomOrnXN+ThDi3w+jASyyUGOO12v6YA@mail.gmail.com>
	<871uf4yizs.fsf@devron.myhome.or.jp>
	<CAKYAXd_T2yGRXd3bk5HXXuVhx_ikO1xzinOy0d8TobokyiCRsA@mail.gmail.com>
	<87pq2owvf9.fsf@devron.myhome.or.jp>
	<CAKYAXd-CAhBDNYRTF22Yh8iGDb1_6+0V-U2wJsSuAjU3Q4q-SQ@mail.gmail.com>
Date: Thu, 06 Dec 2012 18:24:48 +0900
In-Reply-To: <CAKYAXd-CAhBDNYRTF22Yh8iGDb1_6+0V-U2wJsSuAjU3Q4q-SQ@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 6 Dec 2012 16:37:41 +0900")
Message-ID: <87mwxrttwf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> I know encode_fh(). But NFS is network protocol, and network can input
>> any data, and I guess the userland interface (open_by_handle()?) can be
>> any too.
>>
>> And generic_fh_to_dentry()'s input verify choose to check the minimum
>> length only. But your logic choose the exact length.
>>
>> I think the both is sane and correct. But I wonder why did you changed it.
> There was no particular reason for us to put those conditions. It is
> just we knew what fh lengths we have chosen for the 2 cases
> WITH/WITHOUT parent.
> i.e., we checked with encoded length.
> Now, when I check the export functions of other filesystems(btrfs,
> nilfs2, udf). They also adopt the same method of checking the exact
> length and type.
> If there is any particular reason, we will look into that and can also
> updated on that.

OK. Then, just cleanup code, and let's use strict checking version.

Removing strange fallthrou, something like the following.

static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
					       struct fid *fh, int fh_len,
					       int fh_type)
{
	struct inode *inode = NULL;
	struct fat_fid *fid = (struct fat_fid *)fh;
	loff_t i_pos;

	switch (fh_type) {
	case FILEID_FAT_WITHOUT_PARENT:
		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
			return NULL;
		break;
	case FILEID_FAT_WITH_PARENT:
		if (fh_len < FAT_FID_SIZE_WITH_PARENT)
			return NULL;
		break;
	default:
		return NULL;
	}

	i_pos = fid->i_pos_hi;
	i_pos = (i_pos << 32) | (fid->i_pos_low);
	inode = __fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);

	return d_obtain_alias(inode);
}


-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
