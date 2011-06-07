Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1FGKc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:32:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55093
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab1FGKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:32:58 -0400
Date: Tue, 7 Jun 2011 06:32:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: bug in xfs: can't recovery metadata log
Message-ID: <20110607103252.GA15140@infradead.org>
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:20:23PM +0800, Drunkard Zhang wrote:
> The log recovery failure happened after a hard reboot, I did "mount
> /dev/lg/log /mnt/temp/" twice, but the similar dmesg error.
> 
> The xfs lives on LVM, with 4x2TB SATA II disk.
> 
> The first time:
> [ 1479.130446] XFS mounting filesystem dm-0
> [ 1479.226525] Starting XFS recovery on filesystem: dm-0 (logdev: internal)
> [ 1506.217842] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8

[...]

> [ 1506.220989] RIP: 0010:[<ffffffff81235f9c>]  [<ffffffff81235f9c>]
> xfs_cmn_err+0x6b/0x92


[...]

> [ 1506.226301]  [<ffffffff8122922b>] ? kmem_zone_zalloc+0x1f/0x30
> [ 1506.226549]  [<ffffffff812098b5>] xfs_error_report+0x39/0x40
> [ 1506.226805]  [<ffffffff811e8340>] ? xfs_free_extent+0x8e/0xae
> [ 1506.227056]  [<ffffffff811e75cf>] xfs_free_ag_extent+0x3e7/0x70b
> [ 1506.227306]  [<ffffffff811e8340>] xfs_free_extent+0x8e/0xae

It looks like you hit one of the XFS_WANT_CORRUPTED_GOTO checks in
xfs_error_report, and we hit something in there that isn't initialized
that early during the mount process.  My guess it's actually the
mp->m_fsname dereference in xfs_fs_vcmn_err.  It's fixed by the message
rework in 2.6.39+, but that will only prevent the crash, you'll still
get an error and the log recovery will be aborted.  If you can get a
more recent kernel on the box I'd be curious what the output form it is.

Did you run older kernels on this machine before?  Before 2.6.33 device
mapper support for barriers (aka cache flushes) was incomplete and
frequently led to free space corruption if people left the volatile
write caches on.  For MD underneath it event took a bit longer.

If you just want to continue using the filesystem you can nuke the
log using xfs_repair -L.

