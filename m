Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2KPKNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:13:00 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53510 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KPKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <87txsr49m8.fsf@devron.myhome.or.jp>
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
	<CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
	<87k3tr5g8v.fsf@devron.myhome.or.jp>
	<87fw4f5g70.fsf@devron.myhome.or.jp>
	<CAKYAXd84jVdb99qAqda_NGEDUg1G1F9aLGQV+Kj3xcTBN=FxwQ@mail.gmail.com>
	<87txsr49m8.fsf@devron.myhome.or.jp>
Date: Fri, 16 Nov 2012 19:12:57 +0900
Message-ID: <CAKYAXd-4LeGC1o-VbhCWxHxefDV-9YVBoecBuan0Vh2gKS98Kw@mail.gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> 1)If we consider the code for FAT and MSDOS to be same with respect to
>> timing updates - there there is difference in code as mentioned below:
>> a) For:vfat_rmdir()
>> 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>>    For:msdos_rmdir()
>> 		inode->i_ctime = CURRENT_TIME_SEC;
>> 		
>> b) For: vfat_unlink()
>> 		inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>>    For: msdos_unlink()
>>    		inode->i_ctime = CURRENT_TIME_SEC;
>>
>> So, atleast the uniformity in the code is missing for MSDOS and VFAT.
>
> MSDOS doesn't have atime.
>
>> 2) Regarding timings information
>> Original timings on VFAT:
>> #> mkdir parent
>> #> stat parent
>> File type:                directory
>> I-node number:            30
>> Mode:                     40755 (octal)
>> Link count:               2
>> Ownership:                UID=0   GID=0
>> Preferred I/O block size: 4096 bytes
>> File size:                4096 bytes
>> Blocks allocated:         8
>> Last status change:       Thu Jan  1 00:01:29 2012
>> Last file access:         Thu Jan  1 00:01:29 2012
>> Last file modification:   Thu Jan  1 00:01:29 2012
>
> [...]
>
>> As can be seen from the 'stat' information - the timing information
>> appears same for VFAT like EXT4/XFS after changes.
>> Please let me know your opinion.
>
> You have to think about compatibility with other FAT, not unix fs.

Agreed, ctime is creation time, and there are comptability issues with
the patch.

But there is confusion about 'ctime' usage in the default code. When
referring the code I found many instances except 'fat_fill_inode'
where 'ctime' is updated as if it is 'change time' instead of
'creation time' like in functions: fat_write_end(), fat_cont_expend(),
fat_free(), vfat_add_entry().

As a case when I check using a simple case:
dd if=/dev/zero of=./samplefile bs=4096 count=10
=> check file timings
wait for 2minutes
Now, append to this file
echo "this is simple string to be appended" >> samplefile
=> check file timings

I can see - it resulted in change in 'ctime' and 'mtime'.
Now, when Connecting this Drive to Windows - it shows the time of
'second write' as the CREATION time as well as "Modification time".
If you agree that this is a strange/problem. I can try to fix the
timestamp of linux FAT checking this compatability pattern to the
nearest.
Let me know your opinion.

Thanks.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
