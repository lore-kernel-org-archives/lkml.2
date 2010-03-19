Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0CSHav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:30:51 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59463 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0CSHat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DOLoXHadggfQlPGPvHQk5pAShHld/yrrqsF9b/poYu4ATGkwjSCMyRxD7WvD86W6+c
         1u75uS7csXF7OYkSHafpc6jwVlb2dvhX3N5k4RM5pfwaYOu3Mc2mepJBxO0zabK5qS/r
         6lzG1h+1Cv9JzoKBI1D3SpboAsXDjJFi5XtTc=
MIME-Version: 1.0
In-Reply-To: <87d3z1unm9.fsf@tac.ki.iif.hu>
References: <87vdcwv139.fsf@tac.ki.iif.hu> <87ljdsibqe.fsf@macbook.be.48ers.dk>
	 <87r5nhziss.fsf@tac.ki.iif.hu>
	 <bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	 <87d3z1unm9.fsf@tac.ki.iif.hu>
Date: Fri, 19 Mar 2010 07:30:47 +0000
Message-ID: <bffbecbb1003190030x4236abere54649131408cacc@mail.gmail.com>
Subject: Re: RFC: direct MTD support for SquashFS
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 1:05 AM, Ferenc Wagner <wferi@niif.hu> wrote:
> Ferenc Wagner <wferi@niif.hu> writes:
>
>> Phillip Lougher <phillip.lougher@gmail.com> writes:
>>
>>> On Thu, Mar 18, 2010 at 4:38 PM, Ferenc Wagner <wferi@niif.hu> wrote:
>>>
>>> +static int fill_bdev_super(struct super_block *sb, void *data, int silent)
>>> +{
>>> +    struct squashfs_sb_info *msblk;
>>> +    struct squashfs_bdev *bdev;
>>> +    int err = squashfs_fill_super2(sb, data, silent, &squashfs_bdev_ops);
>>> +    if (err)
>>> +            return err;
>>> +
>>> +    bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
>>> +    if (!bdev)
>>> +            return -ENOMEM;
>>> +
>>> +    bdev->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
>>> +    bdev->devblksize_log2 = ffz(~bdev->devblksize);
>>> +
>>> +    msblk = sb->s_fs_info;
>>> +    msblk->backend_data = bdev;
>>> +    return 0;
>>> +}
>>>
>>> This function looks rather 'back-to-front' to me.  I'm assuming that
>>> squashfs_fill_super2() will be the current fill superblock function?
>>
>> Yes, with the extra parameter added.
>>
>>> This function wants to read data off the filesystem through the
>>> backend, and yet the backend (bdev, mblk->backend_data) hasn't been
>>> initialised when it's called...
>>
>> It can't be, because msblk = sb->s_fs_info is allocated by
>> squashfs_fill_super().  Now it will be passed the ops, so after
>> allocating msblk it can also fill out the ops.  After that it can read,
>> and squashfs_read_data() will call the init, read and free operations of
>> the backend.
>
> And here we indeed have a rather fundamental problem.  This isn't
> specific to the discussed plugin system at all.  Even in the current
> code, to set msblk->block_size squashfs_fill_super() calls
> squashfs_read_table() to read the superblock, which in turn calls
> squashfs_read_data(), which uses msblk->block_size to allocate enough
> buffer heads, but msblk->block_size just can't be set at this point.
> msblk->bytes_used is preset with a dummy value to make the read
> possible, but msblk->block_size is not.  Fortunately, one buffer head is
> allocated each time nevertheless.  I wonder what a correct solution
> would look lke..

Block_size is known to be zero (the structure has been zeroed out at
alloc), and so it is known that the one block alloced in this case
will be correct.

Congratulations you've managed to really piss me off in your third or so email.

Cheers

Phillip

> --
> Regards,
> Feri.
>
