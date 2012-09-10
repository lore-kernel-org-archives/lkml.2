Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2IJMDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:03:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41613 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2IJMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <87k3w3ph8d.fsf@devron.myhome.or.jp>
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
Date: Mon, 10 Sep 2012 21:03:46 +0900
Message-ID: <CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/9, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> What is your use case?  I'm assuming current NFS support of FAT
>> is still unstable behavior even with your patches. Is this true?
Hi. OGAWA.

Yes, It is  true(current VFAT of -mm tree is not stable). Although we
set lookupcache=none while mounting, ESTALE error can still occur in
rename case.
So there still remain ESTALE error issue from rename case on current -mm tree.
plz See the step as the following
1. on client write to file.
2. on client, move/rename file.
3. on server, do drop_caches. etc to somehow evict indoe number so
that it gets new inode number
4. on client, resume the program to write to file. write will fail
(write: Stale NFS file handle)
-----

As I know, I think that Steve patch tried to fix ESTALE error on best-effort.
And Steve said also his patch can perfectly not avoid ESTLE error. And
The aim of Steve's patch can be just improved under memory
pressure(dentry eviction) on best-effort.
------------------------------------------------------------------------------
Under memory pressure, the system may evict dentries from cache.
When the FAT driver receives a NFS request involving an evicted dentry,
it is unable to reconnect it to the filesystem root.
This causes the request to fail, often with ENOENT.
.....
Note that while this patch set improves FAT's NFS support, it does not
eliminate ESTALE errors completely.
The following should be considered for NFS clients who are sensitive to ESTALE:
* Mounting with lookupcache=none
  Unfortunately this can degrade performance severely, particularly for deep
  filesystems.
* Incorporating VFS patches to retry ESTALE failures on the client-side,
  such as https://lkml.org/lkml/2012/6/29/381
* Handling ESTALE errors in client application code
-------------------------------------------------------------------------------------

And ......
If we mount NFS with lookupcache=none, FAT file lookup performance is
severely dropped.
LOOKUP performance is very poor on slow network and slow device. I do
not recommend to disable lookup cache on NFS.
And that is why reconstructing inode is already implemented in other
filesystem (e.g. EXT4, XFS etc..)
Currently lookupcache is enabled by default in NFS, it means users
already have disclosed and experienced ESTALE issues on NFS over VFAT.

I agree wth you to make NFS over VFAT read-only filesystem to avoid all issues.
Eventually we can make it writable with rename limitation when we
decide that it is pretty stable in mainline.
So, I suggest to add 'nfs_ro' mount option instead of 'nfs' option.

Let me know your opinion.
Thanks.

>
> s/is not unstable/is still unstable/
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
