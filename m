Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2IMIdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:33:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38345 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2IMIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:33:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	<871ui84l4l.fsf@devron.myhome.or.jp>
	<CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
	<20120912143227.GE3009@fieldses.org>
	<87vcfjfa14.fsf@devron.myhome.or.jp>
	<20120912171128.GG3009@fieldses.org>
	<87r4q7f8fw.fsf@devron.myhome.or.jp>
	<20120912174556.GH3009@fieldses.org>
	<87ipbjf54f.fsf@devron.myhome.or.jp>
	<CAKYAXd-5CQrE=232NKk9pRjzP3q8OBryeLt9mH==f=zrKdjzNg@mail.gmail.com>
Date: Thu, 13 Sep 2012 17:33:02 +0900
In-Reply-To: <CAKYAXd-5CQrE=232NKk9pRjzP3q8OBryeLt9mH==f=zrKdjzNg@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 13 Sep 2012 17:11:54 +0900")
Message-ID: <87txv2cog1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> I see. So, client can't solve the ESTALE if inode cache was evicted,
>> right? (without application changes)
>
> There can be situation where we may get not only ESTALE but EIO also.
>
> For example,
> -------------------------------
> fd = open(“foo.txt”);
> while (1) {
>        sleep(1);
>        write(fd..);
> }
> --------------------------------
>
> Here “write” may fail when inode number of “foo.txt” is changed at
> server due to cache eviction under memory pressure.
> When we tried a similar test, we found that “write” is retuning “EIO”
> instead of “ESTALE”
>
> ---------------------------------------------------------------------------------------------------------
> #> ./write_test_dbg bbb 1000 0
> FILE : bbb, SIZE : 1048576000 , FSYNC : OFF , RECORD_SIZE = 4096
> 106264 -rwxr-xr-x 1 root 0 0 Jan 1 00:14 bbb
> write failed after 60080128 bytes:, errno = 5: Input/output error
> ---------------------------------------------------------------------------------------------------------
>
>  As we get EIO instead of ESTALE, it may be difficult to decide when
> "restart from LOOKUP” in such situation.
> Also, as per Bruce opinion, we can not avoid ESTALE from inode number
> change in rebooted server case.
> In reboot case, it is worst as it may attempt to write in a different
> file if NFS handle at NFS client match with inode number of some other
> file at NFS server.

I see.

>> Grepping around... Documentation/sysctl/vm.txt mentions a
>> vfs_cache_pressure parameter.
>> Yeah. And dirty hack will be possible to adjust sb->s_shrink.batch.
> I am worrying if it could lead to OOM condition on embedded
> system(short memory(DRAM) and support 3TB HDD disk of big size.)
>
> Please let me know if any issues or queries.

So, now I think stable inode number may be useful if there are users of
it. And I guess those functionality is no collisions with -mm. And I
suppose we can add two modes for "nfs" option (e.g. nfs=1 and nfs=2).

If nfs=1, works like current -mm without no limited operations.
If nfs=2, try to make stable FH and limit some operations

(option name doesn't matter here.)

Does this work fine?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
