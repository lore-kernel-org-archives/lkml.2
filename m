Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0D1BvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:51:18 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:46074 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348Ab0D1BvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:51:16 -0400
Date: Wed, 28 Apr 2010 11:50:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] XFS: Let the broken fiemap work in query mode.
Message-ID: <20100428015035.GC9783@dastard>
References: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 02:17:45PM +0800, Tao Ma wrote:
> According to Documentation/filesystems/fiemap.txt, If fm_extent_count
> is zero, then the fm_extents[] array is ignored (no extents will be
> returned), and the fm_mapped_extents count will hold the number of
> extents needed.
> 
> But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
> bmv_count to the caller's input buffer, this number query function can't
> work any more. As this commit is written to change bmv_count from
> MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
> set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
> much extents the file has, a big number may cause ENOMEM, while a small
> one will mask the real extent no.
> 
> So this patch try to resolve this problem by adding a temporary getbmapx
> in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
> the "out" either. Instead, every time we want to use 'out', use '&tmp'
> instead.
>
> I know this solution is a bit ugly, but I can't find a way to resolve
> this issue while not changing the codes too much. So any good suggestion
> is welcomed.

I don't see a need to change xfs_getbmap() to fix this. We can limit
the maximum allocation size to something realistic just by setting
bm.bmv.count to something sane. e.g, in xfs_vn_fiemap:

-	bm.bmv_count = fieinfo->fi_extents_max + 1;
+	bm.bmv.count = !fieinfo->fi_extents_max ? MAXEXTNUM :
+					fieinfo->fi_extents_max - 1;
+	bm.bmv_count = MIN(bm.bmv_count,
				(PAGE_SIZE * 16 / sizeof(struct getbmapx)));

Unless I'm missing something, that should also prevent the case of
an application providing a really large fi_extents_max from
triggering ENOMEM in most cases as well.

FWIW, how did you find this? Is it possible for you to add a test
for this regression into xfstests so that we don't break it again
in future?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
