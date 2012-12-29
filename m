Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2L2XcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 18:32:09 -0500
Received: from sandeen.net ([63.231.237.45]:43024 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2L2XcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 18:32:07 -0500
Message-ID: <50DF7D7C.50104@sandeen.net>
Date: Sat, 29 Dec 2012 17:32:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sergei Trofimovich <slyfox@gentoo.org>
CC: xfs@oss.sgi.com, Alex Elder <elder@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Phil White <pwhite@sgi.com>
Subject: Re: [PATCH] xfs: return -EINVAL instead of -EUCLEAN when mounting
 non-xfs
References: <20121230015615.6cc9e03c@sf> <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
In-Reply-To: <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/12 5:16 PM, Sergei Trofimovich wrote:
> It fixes boot panic when trying to boot from btrfs filesystem.
> kernel tries to mount as xfs and gets fatal -EUCLEAN:
> 
> [    0.170000] VFS: Cannot open root device "ubda" or unknown-block(98,0): error -117
> [    0.170000] Please append a correct "root=" boot option; here are the available partitions:
> [    0.170000] 6200         1048576 ubda  driver: uml-blkdev
> [    0.170000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(98,0)
> 
> init/do_mounts.c expects only -EINVAL as 'retry another' option.
> Fixes regression introduced by commit 98021821a502db347bd9c7671beeee6e8ce07ea6

yeah, that should work; great minds think alike ;)  Our patches
crossed in the ether I guess.

XFS uses EWRONGFS as an alias for EINVAL internally in these cases,
so maybe we should stick with that for consistency, *shrug*

-Eric

> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> CC: Ben Myers <bpm@sgi.com>
> CC: Alex Elder <elder@kernel.org>
> CC: xfs@oss.sgi.com
> CC: linux-kernel@vger.kernel.org
> CC: Dave Chinner <dchinner@redhat.com>
> CC: Phil White <pwhite@sgi.com>
> ---
>  fs/xfs/xfs_mount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index da50846..379cac1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -641,41 +641,41 @@ xfs_sb_read_verify(
>  /*
>   * We may be probed for a filesystem match, so we may not want to emit
>   * messages when the superblock buffer is not actually an XFS superblock.
>   * If we find an XFS superblock, the run a normal, noisy mount because we are
>   * really going to mount it and want to know about errors.
>   */
>  static void
>  xfs_sb_quiet_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_sb	sb;
>  
>  	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
>  
>  	if (sb.sb_magicnum == XFS_SB_MAGIC) {
>  		/* XFS filesystem, verify noisily! */
>  		xfs_sb_read_verify(bp);
>  		return;
>  	}
>  	/* quietly fail */
> -	xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	xfs_buf_ioerror(bp, EINVAL);
>  }
>  
>  static void
>  xfs_sb_write_verify(
>  	struct xfs_buf	*bp)
>  {
>  	xfs_sb_verify(bp);
>  }
>  
>  const struct xfs_buf_ops xfs_sb_buf_ops = {
>  	.verify_read = xfs_sb_read_verify,
>  	.verify_write = xfs_sb_write_verify,
>  };
>  
>  static const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
>  	.verify_read = xfs_sb_quiet_read_verify,
>  	.verify_write = xfs_sb_write_verify,
>  };
>  
>  /*
> 

