Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0DNUCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:02:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57940 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0DNUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:02:17 -0400
Subject: Re: [PATCH] jfs: fix diAllocExt error in resizing filesystem
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1271275001-20015-1-git-send-email-wfp5p@virginia.edu>
References: <1271275001-20015-1-git-send-email-wfp5p@virginia.edu>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 14 Apr 2010 15:02:05 -0500
Message-Id: <1271275325.4936.30.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 15:56 -0400, Bill Pemberton wrote:
> Resizing the filesystem would result in an diAllocExt error in some
> instances because changes in bmp->db_agsize would not get noticed if
> goto extendBmap was called.

Awesome!   This bug has been frustrating me for a while, but I hadn't
chased it down to the root cause.  I'll give a bit of a test and push it
upstream!

Thanks,
Shaggy

> 
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> ---
>  fs/jfs/resize.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
> index 7f24a0b..1aba003 100644
> --- a/fs/jfs/resize.c
> +++ b/fs/jfs/resize.c
> @@ -81,6 +81,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>  	struct inode *iplist[1];
>  	struct jfs_superblock *j_sb, *j_sb2;
>  	uint old_agsize;
> +	int agsizechanged = 0;
>  	struct buffer_head *bh, *bh2;
> 
>  	/* If the volume hasn't grown, get out now */
> @@ -333,6 +334,9 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>  	 */
>  	if ((rc = dbExtendFS(ipbmap, XAddress, nblocks)))
>  		goto error_out;
> +
> +	agsizechanged |= (bmp->db_agsize != old_agsize);
> +
>  	/*
>  	 * the map now has extended to cover additional nblocks:
>  	 * dn_mapsize = oldMapsize + nblocks;
> @@ -432,7 +436,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
>  	 * will correctly identify the new ag);
>  	 */
>  	/* if new AG size the same as old AG size, done! */
> -	if (bmp->db_agsize != old_agsize) {
> +	if (agsizechanged) {
>  		if ((rc = diExtendFS(ipimap, ipbmap)))
>  			goto error_out;
> 
-- 
Dave Kleikamp
IBM Linux Technology Center

