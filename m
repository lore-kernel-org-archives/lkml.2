Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2IQO2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:28:06 -0400
Received: from fieldses.org ([174.143.236.118]:59867 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab2IQO2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:28:04 -0400
Date: Mon, 17 Sep 2012 10:28:00 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 5/5] Documentation: update nfs option in
 filesystem/vfat.txt
Message-ID: <20120917142800.GH30673@fieldses.org>
References: <1347798200-2765-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347798200-2765-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 08:23:20AM -0400, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> update nfs option in filesystem/vfat.txt
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  Documentation/filesystems/vfat.txt |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
> index de1e6c4..3371b8e 100644
> --- a/Documentation/filesystems/vfat.txt
> +++ b/Documentation/filesystems/vfat.txt
> @@ -141,13 +141,22 @@ discard       -- If set, issues discard/TRIM commands to the block
>  		 device when blocks are freed. This is useful for SSD devices
>  		 and sparse/thinly-provisoned LUNs.
>  
> -nfs           -- This option maintains an index (cache) of directory
> -		 inodes by i_logstart which is used by the nfs-related code to
> -		 improve look-ups.
> -
> -		 Enable this only if you want to export the FAT filesystem
> +nfs=full_unstable|limited_stable

You still want to accept just "nfs" (defaulting to "full_unstable"
behavior), for backwards compatibility.

Also I don't find this full_unstable/limited_stable terminology very
intuitive.  "stable" and "limited" could mean too many different things.

Maybe "nostale_ro|stale_rw" ?

> +	      -- Enable this only if you want to export the FAT filesystem
>  		 over NFS
>  
> +		 full_unstable:This option maintains an index (cache) of
> +		 directory inodes by i_logstart which is used by
> +		 the nfs-related code to improve look-ups.Full file operations
> +		 (read/write) over NFS is supported but with cache eviction
> +		 at NFS server, this could result in ESTALE issues.
> +
> +		 limited_stable:This options makes NFS support for FAT as
> +		 read-only and provides stable inode based on the on-disk
> +		 location of the MS-DOS directory entry.This helps in
> +		 reconstruction of the inodes in case of lookup failure,
> +		 making FAT behaviour stable with respect to ESTALE issues.

This option still scares me a little.  Maybe a little more explanation:

		This option bases the inode number and filehandle on
		the location of an file in the MS-DOS directory entry.
		This ensures that ESTALE will not be returned after a
		file is evicted from the inode cache.  However, it means
		that operations such as rename, create, and unlink could
		cause filehandles that previously pointed at one file to
		point at a different file, potentially causing data
		corruption.  For this reason, this option also mounts
		the filesystem readonly.

--b.

> +
>  <bool>: 0,1,yes,no,true,false
>  
>  TODO
> -- 
> 1.7.9.5
> 
