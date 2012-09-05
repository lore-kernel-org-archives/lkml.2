Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2IEOIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:08:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55366 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2IEOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120904161747.GJ23464@ZenIV.linux.org.uk>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
Date: Wed, 5 Sep 2012 23:08:11 +0900
Message-ID: <CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, hirofumi@mail.parknet.co.jp
Cc: akpm@linux-foundation.org, bfields@fieldses.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5, Al Viro <viro@zeniv.linux.org.uk>:
> On Wed, Sep 05, 2012 at 12:57:44AM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> All the files on a FAT partition have an on-disk directory entry.
>> The location of these entries, i_pos, is unique and is constructed by the
>> fat_make_i_pos() function.We can use this as the inode number making it
>> peristent across remounts.
>
>> --- a/fs/fat/namei_vfat.c
>> +++ b/fs/fat/namei_vfat.c
>> @@ -954,6 +954,8 @@ static int vfat_rename(struct inode *old_dir, struct
>> dentry *old_dentry,
>>  	new_dir->i_version++;
>>
>>  	fat_detach(old_inode);
>> +	if (MSDOS_SB(sb)->options.nfs)
>> +		old_inode->i_ino = new_i_pos;
>
A brief background to this patch-set : We are using FAT over NFS  in our
environment. While App just is browsing files(ls -lR, etc..) on the client
we observed a numerous times when the server cache was evicted.

Our purpose was same as mentioned by Neil Brown also -> "that it is
important to maintain support for NFS export of VFAT on a best-effort basis.

With the patch series we are able to provide a 100% safe solution ->
there is no ESTALE issues at least for the normal user scenarios (i.e,
rename, unlink do not happen while the file is open). After the review comments
from you, we proposed a new solution which takes care of 'unlink' also.

> Sigh...  Inode numbers are reported by fstat() in stat.st_ino.  They must
> 	* remain constant from open() to close(), even if file gets
> unlinked or renamed.
> 	* be equal for two simultaneously opened descriptors with the same
> st_dev *ONLY* if those descriptors refer to the same file (i.e. if writing
> through one of those would change the data read through another, etc.)
>
> And yes, the userland code does depend on those properties.  There's a damn
> good reason why we had gone for all those convolutions with separate hash,
> etc.
>
> inode->i_ino on a live struct inode is _never_ changed.  Period.
Hi Al.
Even without these patches, when a file is opened at the client and is
still 'live',
it is possible for the inode number to change due to cache eviction at server.
(because each read/write NFS transaction from client is translated into a open->
read/write->close operation and in between such transactions, the server cache
may be evicted). This is why we updated the i_ino in vfat_rename() immediately,
as it helps rebuild the inode in such cases.
But to comply with your explanation(constant i_ino from open() till close() ),
I can remove this change.

And
Hi. OGAWA.
In this long discusstion about the FAT acceptance over NFS, our belief
is still that
the objective should be to reduce errors as much as possible and then
if there are
certain scenarios - at least that could be highlighted as a limitation
in Documentation
 instead of completely discarding the usage of FAT over NFS.
So how about puttting rename scenario as a limitation ? In ideal
scenario how many
times this is going to happen ?

Thanks.
>
