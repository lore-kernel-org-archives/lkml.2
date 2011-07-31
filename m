Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1GaBfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:35:06 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27055 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab1GaBfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:35:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUDAI2uNE55LCkBgWdsb2JhbABBp2MVAQEWJiWBQAEBBAEnExwjBQsIAw4KLhQlAyETh2y/AQ6GNASjcQ
Date: Sun, 31 Jul 2011 11:34:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 4/4] parse options in the vfs level
Message-ID: <20110731013456.GM5404@dastard>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
 <1311947059-17209-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311947059-17209-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 05:44:19PM +0400, Glauber Costa wrote:
> This patch introduces a simple generic vfs option parser.
> Right now, the only option we have is to limit the size of the dcache.
> 
> So any user that wants to have a dcache entries limit, can specify:
> 
>   mount -o whatever_options,vfs_dcache_size=XXX <dev> <mntpoint>
> 
> It is supposed to work well with remounts, allowing it to change
> multiple over the course of the filesystem's lifecycle.
> 
> I find mount a natural interface for handling filesystem options,
> so that's what I've choosen. Feel free to yell at it at will if
> you disagree.

IMO, the whole point of having a configurable cache size maximum is
that is can be changed at runtime. Tying it to mount options is a
painful way to acheive that because the only way to change it would
be via a remount command.

I'm not sure what the best API is, but I'd prefer something that is
specific to a superblock, not a vfs mount. Perhaps something in
/sys/fs?

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> ---
>  fs/namespace.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 22bfe82..11ce45d 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -31,6 +31,7 @@
>  #include <linux/idr.h>
>  #include <linux/fs_struct.h>
>  #include <linux/fsnotify.h>
> +#include <linux/parser.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
>  #include "pnode.h"
> @@ -2271,6 +2272,82 @@ int copy_mount_string(const void __user *data, char **where)
>  	return 0;
>  }
>  
> +static const match_table_t tokens = {
> +	{1, "vfs_dcache_size=%u"},
> +};
> +
> +struct vfs_options {
> +	unsigned long vfs_dcache_size;
> +};
> +
> +/**
> + * Generic option parsing for the VFS.
> + *
> + * Since most of the filesystems already do their own option parsing, and with
> + * very few code shared between them, this function strips out any options that
> + * we succeed in parsing ourselves. Passing them forward would just give the
> + * underlying fs an option it does not expect, leading it to fail.
> + *
> + * We don't yet have a pointer to the super block as well, since this is
> + * pre-mount. We accumulate in struct vfs_options whatever data we collected,
> + * and act on it later.
> + */
> +static int vfs_parse_options(char *options, struct vfs_options *ops)
> +{
> +	substring_t args[MAX_OPT_ARGS];
> +	unsigned int option;
> +	char *p;
> +	char *opt;
> +	char *start = NULL;
> +	int ret;
> +	
> +	if (!options)
> +		return 0;
> +
> +	opt = kstrdup(options, GFP_KERNEL);
> +	if (!opt)
> +		return 1;
> +	
> +	ret = 1;
> +
> +	start = opt;
> +	while ((p = strsep(&opt, ",")) != NULL) {
> +		int token;
> +		if (!*p)
> +			continue;
> +
> +		/*
> +		 * Initialize args struct so we know whether arg was
> +		 * found; some options take optional arguments.
> +		 */
> +		args[0].to = args[0].from = 0;
> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case 1:
> +			if (!args[0].from)
> +				break;
> +
> +			if (match_int(&args[0], &option))
> +				break;
> +			else

No need fo the else.

> +				ops->vfs_dcache_size = option;

Bounds checking? What are valid values? e.g. setting it to a
negative number would be bad, as would a number that is too small
(e.g. 1)....

> +
> +			ret = 0;
> +			if (!opt) /* it is the last option listed */
> +				*(options + (p - start)) = '\0';
> +			else
> +				strcpy(options + (p - start), opt);

What's this for? I don't see any of the other mount option code
doing this sort of thing...

> @@ -2350,6 +2434,11 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
>  	else
>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>  				      dev_name, data_page);
> +
> +	if (!retval)
> +		vfs_set_dcache_size(path.mnt->mnt_sb,
> +				    vfs_options.vfs_dcache_size);
> +			

Hmmmm -  doesn't that mean bind mounts will override the value for
the original, underlying filesytem mount? Isn't that a bad thing to
do? i.e. the limiting is supposed to be per-sb, not per-vfsmnt?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
