Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2IKMAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 08:00:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34193 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab2IKMAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <87har6kmfx.fsf@devron.myhome.or.jp>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	<CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	<1347020137.2223.13.camel@iscandar.digidescorp.com>
	<87oblfpmnb.fsf@devron.myhome.or.jp>
	<87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	<87har6kmfx.fsf@devron.myhome.or.jp>
Date: Tue, 11 Sep 2012 21:00:07 +0900
Message-ID: <CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/10, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Yes, It is  true(current VFAT of -mm tree is not stable). Although we
>> set lookupcache=none while mounting, ESTALE error can still occur in
>> rename case.
>> So there still remain ESTALE error issue from rename case on current -mm
>> tree.
>> plz See the step as the following
>> 1. on client write to file.
>> 2. on client, move/rename file.
>> 3. on server, do drop_caches. etc to somehow evict indoe number so
>> that it gets new inode number
>> 4. on client, resume the program to write to file. write will fail
>> (write: Stale NFS file handle)
>
Hi OGAWA.
> Since rename() will be disabled on stable ino patches, this will be
> unfixable, so rather maybe it is worse.
Currently with our patchset : only rename issue (could not find any
correct approach to ignore this. If we do not update this immediately
at i_pos change – it is just delaying the problem). And we can return
EBUSY when rename is called while process is opening file with rename
limitation. Without our patchset also - the rename issue can occur
over NFS file access - when the inode is evicted from the SERVER
cache.
>
> Did you checked why it returns -ESTALE?  Or rename() issue also is
> unfixable on -mm?
It is reproducible regardless of lookupcache is enable or disable.
The inode is not found in server inode cache. So when
d_obtain_alias(inode) is called, it returns ESTALE.
Call path like this.
fh_verify()-->nfsd_set_fh_dentry()-->exportfs_decode_fh()-->nop->fh_to_dentry()-->fat_fh_to_dentry()-->generic_fh_to_dentry()-->get_inode()-->fat_nfs_get_inode()

static struct inode *fat_nfs_get_inode(struct super_block *sb,
                                       u64 ino, u32 generation)
{
......
        inode = ilookup(sb, ino); ->This looks up in inode cache and
returns null
        if (inode && generation && (inode->i_generation != generation)) {
                iput(inode);
                inode = NULL;
         }
        return inode;
}

I think that it is unfixable because we can not know i_pos of inode
changed by rename.
And even though we know it, there is no rebuild inode routine in -mm.
And It even can not fix in our patches.

>
>> And ......
>> If we mount NFS with lookupcache=none, FAT file lookup performance is
>> severely dropped.
>> LOOKUP performance is very poor on slow network and slow device. I do
>> not recommend to disable lookup cache on NFS.
>> And that is why reconstructing inode is already implemented in other
>> filesystem (e.g. EXT4, XFS etc..)
>> Currently lookupcache is enabled by default in NFS, it means users
>> already have disclosed and experienced ESTALE issues on NFS over VFAT.
>>
>> I agree wth you to make NFS over VFAT read-only filesystem to avoid all
>> issues.
>> Eventually we can make it writable with rename limitation when we
>> decide that it is pretty stable in mainline.
>> So, I suggest to add 'nfs_ro' mount option instead of 'nfs' option.
>
> -mm seems to be more stable than I thought. As he said, sounds like
> rename() is an only known issue on -mm, true?
Yes, There is only rename issue in stability if we use lookcache is disable.
But performance will severely be dropped
But If lookup cache is enable, there are estale and rename issue in -mm.
>
> And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
> like to improve performance by enabling lookupcache.
We checked this patches when facing estale issue in -mm.
But It is no use, these patches just retry system call one more when
estale error.

> I'd like to be knowing the critical reason we have to replace it.
I arrange to help your decision as the following.

1. lookup cache is enable at default in NFS. So estale error can be
easily occurred in -mm.
2. If lookup cache is disable, there is rename issue and file lookup
performance is dropped in -mm.
4. If we use our patches, there is rename issue. but we can use VFAT
over NFS with lookup cache enable.
5. If we use read-only with our patches, there is no issue.

Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
