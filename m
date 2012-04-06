Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2DFKWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:22:45 -0400
Received: from twin.jikos.cz ([89.185.236.188]:58490 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2DFKWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:22:43 -0400
Date: Fri, 6 Apr 2012 12:22:32 +0200
From: David Sterba <dave@jikos.cz>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allow mount -o remount,compress=no
Message-ID: <20120406102232.GH14256@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Arnd Hannemann <arnd@arndnet.de>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333568777-16986-1-git-send-email-arnd@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333568777-16986-1-git-send-email-arnd@arndnet.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 09:46:17PM +0200, Arnd Hannemann wrote:
> Btrfs allows to turn on compression on a mounted and used filesystem
> by issuing mount -o remount,compress=lzo.
> This patch allows to turn compression off again
> while the filesystem is mounted.

I agree it makes sense to allow for turning off the compression via
remount. Currently the mount flag FORCE_COMPRESS implies COMPRESS and
your code may lead to FORCE_COMPRESS without COMPRESS. To fix that
clear the force option as well.

For completeness, there should be also possibility of

  -o remount,compress-force=no

doing exactly the same, just a different syntax. Proposed fix below.

> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -394,15 +394,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			    strcmp(args[0].from, "zlib") == 0) {
>  				compress_type = "zlib";
>  				info->compress_type = BTRFS_COMPRESS_ZLIB;
> +				btrfs_set_opt(info->mount_opt, COMPRESS);
>  			} else if (strcmp(args[0].from, "lzo") == 0) {
>  				compress_type = "lzo";
>  				info->compress_type = BTRFS_COMPRESS_LZO;
> +				btrfs_set_opt(info->mount_opt, COMPRESS);
> +			} else if (strncmp(args[0].from, "no", 2) == 0) {
> +				compress_type = "no";
> +				info->compress_type = BTRFS_COMPRESS_NONE;
> +				btrfs_clear_opt(info->mount_opt, COMPRESS);

				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
				compress_force = false;

>  			} else {
>  				ret = -EINVAL;
>  				goto out;
>  			}
>  
> -			btrfs_set_opt(info->mount_opt, COMPRESS);
>  			if (compress_force) {
>  				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
>  				pr_info("btrfs: force %s compression\n",
