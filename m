Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab2IXKaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:30:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38215 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2IXK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:29:59 -0400
MIME-Version: 1.0
In-Reply-To: <87392768dj.fsf@devron.myhome.or.jp>
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	<87ipb45914.fsf@devron.myhome.or.jp>
	<CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
	<87ehls53ug.fsf@devron.myhome.or.jp>
	<87a9wg53mc.fsf@devron.myhome.or.jp>
	<CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
	<87392768dj.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 19:29:58 +0900
Message-ID: <CAKYAXd_fJwoPrX4zKW0sBDGsBGDWUj-_TtkFYws7z3xvgsnuRw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
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

2012/9/24, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> This means - which code returns error?
>> Sorry, My explanation may be insufficient.
>>
>> nfs_update_inode()-> on NFS client
>> if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid !=
>> fattr->fileid) {
>> 		printk(KERN_ERR "NFS: server %s error: fileid changed\n"
>> 			"fsid %s: expected fileid 0x%Lx, got 0x%Lx\n",
>> 			NFS_SERVER(inode)->nfs_client->cl_hostname,
>> 			inode->i_sb->s_id, (long long)nfsi->fileid,
>> 			(long long)fattr->fileid);
>> 		goto out_err;
>> 	}
>>
>> that the problem in that case will occur with the file handle on NFS
>> Client because the file handle on NFS client is still referring the
>> old inode number even though the i-pos is same
>
> I see. fileid seems to be stat.ino on nfsd4. inode->i_ino is actually
> just a hash key of inode hash (exception is only in audit, iirc).
>
> So, what happens if we set "stat->ino = i_pos" on fat_getattr().
>
> int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
> *stat)
> {
> 	struct inode *inode = dentry->d_inode;
> 	generic_fillattr(inode, stat);
> 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
> 	if (opts->nfs == FAT_NFS_LIMITED) {
> 		/* Use i_pos for ino. This is used as fileid of nfs. */
> 		stat->ino = MSDOS_SB(inode->i_sb)->i_pos;
> 	}
> 	return 0;
> }
Okay, Thanks for your help.
I will share the result after checking.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
