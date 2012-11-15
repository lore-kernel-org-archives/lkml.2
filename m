Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702Ab2KOHCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:02:30 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39022 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992548Ab2KOHC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:02:28 -0500
MIME-Version: 1.0
In-Reply-To: <87fw4f5g70.fsf@devron.myhome.or.jp>
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
	<CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
	<87k3tr5g8v.fsf@devron.myhome.or.jp>
	<87fw4f5g70.fsf@devron.myhome.or.jp>
Date: Thu, 15 Nov 2012 16:02:26 +0900
Message-ID: <CAKYAXd84jVdb99qAqda_NGEDUg1G1F9aLGQV+Kj3xcTBN=FxwQ@mail.gmail.com>
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

2012/11/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>>>> What was difference with XFS, FAT, and MSDOS?
>>> Okay, the description of patch was lacked, So I will resend patch with
>>> specifical test reseult with other filesystem.
>>>>
>>>> BTW, I recall I checked this, and yes, it is strange. But it is
>>>> historical.
>>> "historical" means It is difficult to change ?
>>
>> The timestamp handling was not same with unix fs from initial, and FAT
>> doesn't have inode change timestamp.  This historical reason it is not
>> better to change to same with unix fs, and never be possible to support
>> inode change timestamp cleanly.
>
> I.e. the user visible change without strong reason is the wrong.

1)If we consider the code for FAT and MSDOS to be same with respect to
timing updates - there there is difference in code as mentioned below:
a) For:vfat_rmdir()
	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
   For:msdos_rmdir()
		inode->i_ctime = CURRENT_TIME_SEC;
		
b) For: vfat_unlink()
		inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
   For: msdos_unlink()
   		inode->i_ctime = CURRENT_TIME_SEC;

So, atleast the uniformity in the code is missing for MSDOS and VFAT.

2) Regarding timings information
Original timings on VFAT:
#> mkdir parent
#> stat parent
File type:                directory
I-node number:            30
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Thu Jan  1 00:01:29 2012
Last file access:         Thu Jan  1 00:01:29 2012
Last file modification:   Thu Jan  1 00:01:29 2012
#>
#> echo "hello" > parent/childfile
#> stat parent
File type:                directory
I-node number:            30
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Thu Jan  1 00:01:45 2012
Last file access:         Thu Jan  1 00:01:45 2012
Last file modification:   Thu Jan  1 00:01:45 2012
#>
#> mkdir parent/childdir
#> stat parent
File type:                directory
I-node number:            30
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Thu Jan  1 00:01:56 2012
Last file access:         Thu Jan  1 00:01:56 2012
Last file modification:   Thu Jan  1 00:01:56 2012
#> rm parent/childfile
#> stat parent
File type:                directory
I-node number:            30
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Thu Jan  1 00:01:56 2012
Last file access:         Thu Jan  1 00:02:12 2012
Last file modification:   Thu Jan  1 00:02:12 2012
#> rm -rf parent/childdir
#> stat parent
File type:                directory
I-node number:            30
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Thu Jan  1 00:01:56 2012
Last file access:         Thu Jan  1 00:02:24 2012
Last file modification:   Thu Jan  1 00:02:24 2012


For timing information comparison after changes in VFAT -> for VFAT ,
EXT4 and XFS
########################################################################
VFAT Filesystem with timestamp patch
########################################################################
#> mkdir parent
#> stat parent
File type:                directory
I-node number:            29
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:11:10 2012
Last file access:         Sun Jan  1 00:11:10 2012
Last file modification:   Sun Jan  1 00:11:10 2012
#>
#> echo "hello" parent/childfile
hello parent/childfile
#> echo "hello" > parent/childfile
#> stat parent
File type:                directory
I-node number:            29
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:12:22 2012
Last file access:         Sun Jan  1 00:11:10 2012
Last file modification:   Sun Jan  1 00:12:22 2012
#>
#>
#> mkdir parent/childdir
#> stat parent
File type:                directory
I-node number:            29
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:13:10 2012
Last file access:         Sun Jan  1 00:11:10 2012
Last file modification:   Sun Jan  1 00:13:10 2012
#>
#> rm parent/childfile
#> stat parent
File type:                directory
I-node number:            29
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:13:38 2012
Last file access:         Sun Jan  1 00:11:10 2012
Last file modification:   Sun Jan  1 00:13:38 2012
#> rm parent/childdir
rm: parent/childdir: is a directory
#> rm -rf parent/childdir
#> stat parent
File type:                directory
I-node number:            29
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:13:59 2012
Last file access:         Sun Jan  1 00:11:10 2012
Last file modification:   Sun Jan  1 00:13:59 2012
#>


########################################################################
EXT4 Filesystem
########################################################################
#> cd /dtv/usb/sdb2
#> pwd
/dtv/usb/sdb2
#>
#> mkdir parent
#> stat parent
File type:                directory
I-node number:            12
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:14:44 2012
Last file access:         Sun Jan  1 00:14:44 2012
Last file modification:   Sun Jan  1 00:14:44 2012
#>
#> echo "hello" > parent/childfile
#> stat parent
File type:                directory
I-node number:            12
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:15:04 2012
Last file access:         Sun Jan  1 00:14:44 2012
Last file modification:   Sun Jan  1 00:15:04 2012
#> mkdir parent/childdir
#> stat parent
File type:                directory
I-node number:            12
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:15:34 2012
Last file access:         Sun Jan  1 00:14:44 2012
Last file modification:   Sun Jan  1 00:15:34 2012
#>
#> rm parent/childfile
#> stat parent
File type:                directory
I-node number:            12
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:15:53 2012
Last file access:         Sun Jan  1 00:14:44 2012
Last file modification:   Sun Jan  1 00:15:53 2012
#>
#> rm -rf parent/childdir
#> stat parent
File type:                directory
I-node number:            12
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                4096 bytes
Blocks allocated:         8
Last status change:       Sun Jan  1 00:16:09 2012
Last file access:         Sun Jan  1 00:14:44 2012
Last file modification:   Sun Jan  1 00:16:09 2012
#>





####################################################################
XFS
####################################################################
#> mkdir parent
#> stat parent
File type:                directory
I-node number:            131
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                6 bytes
Blocks allocated:         0
Last status change:       Sun Jan  1 00:17:06 2012
Last file access:         Sun Jan  1 00:17:06 2012
Last file modification:   Sun Jan  1 00:17:06 2012
#>
#> echo "hello" > parent/childfile
#> stat parent
File type:                directory
I-node number:            131
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                22 bytes
Blocks allocated:         0
Last status change:       Sun Jan  1 00:17:22 2012
Last file access:         Sun Jan  1 00:17:06 2012
Last file modification:   Sun Jan  1 00:17:22 2012
#>
#> mkdir parent/childdir
#> stat parent
File type:                directory
I-node number:            131
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                37 bytes
Blocks allocated:         0
Last status change:       Sun Jan  1 00:17:36 2012
Last file access:         Sun Jan  1 00:17:06 2012
Last file modification:   Sun Jan  1 00:17:36 2012
#>
#>
#> rm parent/childfile
#> stat parent
File type:                directory
I-node number:            131
Mode:                     40755 (octal)
Link count:               3
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                21 bytes
Blocks allocated:         0
Last status change:       Sun Jan  1 00:17:51 2012
Last file access:         Sun Jan  1 00:17:06 2012
Last file modification:   Sun Jan  1 00:17:51 2012
#>
#> rm -rf parent/childdir
#> stat parent
File type:                directory
I-node number:            131
Mode:                     40755 (octal)
Link count:               2
Ownership:                UID=0   GID=0
Preferred I/O block size: 4096 bytes
File size:                6 bytes
Blocks allocated:         0
Last status change:       Sun Jan  1 00:17:58 2012
Last file access:         Sun Jan  1 00:17:06 2012
Last file modification:   Sun Jan  1 00:17:58 2012
#>

As can be seen from the 'stat' information - the timing information
appears same for VFAT like EXT4/XFS after changes.
Please let me know your opinion.

Thanks.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
