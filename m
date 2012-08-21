Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2HUFTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:19:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44541 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2HUFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120820205231.GG5779@fieldses.org>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
	<CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	<20120820205231.GG5779@fieldses.org>
Date: Tue, 21 Aug 2012 14:19:46 +0900
Message-ID: <CAKYAXd8fkV5x454vtXvwM6LN3Hb2dLgemhJdNFKyxnwweNq75A@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: Namjae Jeon <linkinjeon@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/21, J. Bruce Fields <bfields@fieldses.org>:
> On Mon, Aug 20, 2012 at 01:19:51PM +0900, Namjae Jeon wrote:
>> 2012/8/18, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> > Al Viro <viro@ZenIV.linux.org.uk> writes:
>> >
>> >> On Sat, Aug 18, 2012 at 05:41:39AM -0400, Namjae Jeon wrote:
>> >>> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>>
>> >>> This patch-set eliminates the client side ESTALE errors when
>> >>> a FAT partition exported over NFS has its dentries evicted
>> >>> from the cache.
>> >>>
>> >>> One of the reasons for this error is lack of permanent inode
>> >>> numbers on FAT which makes it difficult to construct persistent
>> >>> file handles.This can be overcome by using the on-disk location
>> >>> of the directory entries (i_pos) as the inode number.
>> >>
>> >> The hell it can.  You've just made them unstable on rename(2).
>> >
>> > As more hint. We can't use i_pos as the inode number.
>> >
>> > E.g. inode is unlinked but is still opened (orphaned inode), the dir
>> > entry is free and you can create the inode on same i_pos. After that,
>> > both inodes have same i_pos (so inode number).
>> >
>> > Thanks.
>> Hi. Ogawa.
>> Thanks for specific explanation. I will check it.
>
Hi Bruce.
> Fo somebody that knows more about fat than me--is there really any hope
> of making it play well with nfs?

I think that this patch is only solution to fix estale issue from
inode cache eviction.
In case FAT - it makes use of iunique() to get unique inode number
-which is just based upon getting an incremented value from unique
counter variable. So, there is no way to reconstruct the inode based
upon inode numbers - like in case of other filesystems

We can check it easily like this.

1. ls -al /directory on nfs client.
2. echo 3 > /proc/sys/vm/drop_caches
3. ls -al /directory on nfs client again. estale error will be occurred.

There is no estale issue from reclaim with this patch.

And.. Hi Ogawa.
I checked other filesystem about unlink - inode issue. but I found
Ext4 have same issue.
Although other filesysm is having this issue, Can we think It could be
only FAT issue ?
>
> --b.
>
