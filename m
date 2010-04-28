Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0D1DBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:01:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27912 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0D1DBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:01:37 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com,
       Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>
Subject: [PATCH v2] XFS: Let the broken fiemap work in query mode.
Date: Wed, 28 Apr 2010 11:00:25 +0800
Message-Id: <1272423625-20142-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100428023058.GD9783@dastard>
References: <20100428023058.GD9783@dastard>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD7A4FB.004B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Wed, Apr 28, 2010 at 10:00:01AM +0800, Tao Ma wrote:
>> Hi Dave,
>>
>> Dave Chinner wrote:
>>> On Tue, Apr 27, 2010 at 02:17:45PM +0800, Tao Ma wrote:
>>>> According to Documentation/filesystems/fiemap.txt, If fm_extent_count
>>>> is zero, then the fm_extents[] array is ignored (no extents will be
>>>> returned), and the fm_mapped_extents count will hold the number of
>>>> extents needed.
>>>>
>>>> But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
>>>> bmv_count to the caller's input buffer, this number query function can't
>>>> work any more. As this commit is written to change bmv_count from
>>>> MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
>>>> set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
>>>> much extents the file has, a big number may cause ENOMEM, while a small
>>>> one will mask the real extent no.
>>>>
>>>> So this patch try to resolve this problem by adding a temporary getbmapx
>>>> in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
>>>> the "out" either. Instead, every time we want to use 'out', use '&tmp'
>>>> instead.
>>>>
>>>> I know this solution is a bit ugly, but I can't find a way to resolve
>>>> this issue while not changing the codes too much. So any good suggestion
>>>> is welcomed.
>>> I don't see a need to change xfs_getbmap() to fix this. We can limit
>>> the maximum allocation size to something realistic just by setting
>>> bm.bmv.count to something sane. e.g, in xfs_vn_fiemap:
>>>
>>> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
>>> +	bm.bmv.count = !fieinfo->fi_extents_max ? MAXEXTNUM :
>>> +					fieinfo->fi_extents_max - 1;
>>> +	bm.bmv_count = MIN(bm.bmv_count,
>>> 				(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
>>>
>>> Unless I'm missing something, that should also prevent the case of
>>> an application providing a really large fi_extents_max from
>>> triggering ENOMEM in most cases as well.
>> I just worry about one thing: What if the real extent number is
>> larger than the PAGE_SIZE * 16 / sizeof(struct getbmapx)? In this
>> case, we will give up the wrong extent number to the user space.
> 
> Applications need to handle mappings changing from query to getting
> the mapping, so this should not be a major issue. Especially as the
> method of fiemap indicating there are more extents to be extracted
> from the inode in the case the kernel can't allocate a buffer large
> enough is already documented.
> 
> Realistically though, xfs_getbmap() needs a complete rewrite so
> right now I'd prefer just to do the minimum to fix the reported
> problem that continue to make it into even more of a mess than it is
> now...
Fair enough. Here is the updated patch.

btw, I am working on adding the test cases in xfstests.

Regards,
Tao

>From e5d32636c907be106d55d63c253d1750a4a898d7 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 28 Apr 2010 10:25:33 +0800
Subject: [PATCH v2] XFS: Let the broken fiemap work in query mode.

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
bmv_count to the caller's input buffer, this number query function can't
work any more. As this commit is written to change bmv_count from
MAXEXTNUM because of ENOMEM.

This patch just try to set bm.bmv.count to something sane.
Thanks to Dave Chinner <david@fromorbit.com> for the suggestion.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 2259460..24ccad9 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -662,7 +662,10 @@ xfs_vn_fiemap(
 		bm.bmv_length = BTOBB(length);
 
 	/* We add one because in getbmap world count includes the header */
-	bm.bmv_count = fieinfo->fi_extents_max + 1;
+	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
+					fieinfo->fi_extents_max + 1;
+	bm.bmv_count = MIN(bm.bmv_count,
+			   (__s32)(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
-- 
1.6.3.3.334.g916e1.dirty

