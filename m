Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HNPlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:41:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55830 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1HNPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:41:13 -0400
Date: Sun, 14 Aug 2011 19:39:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        David Chinner <david@fromorbit.com>,
        containers@lists.linux-foundation.org, Hugh Dickins <hughd@google.com>,
        James Bottomley <JBottomley@parallels.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] parse options in the vfs level
Message-ID: <20110814153930.GA3996@albatros>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313334832-1150-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Glauber,

On Sun, Aug 14, 2011 at 19:13 +0400, Glauber Costa wrote:
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
> +	int option;
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

What if there are 2 passed options and the second fails?

   mount -o vfs_dcache_size=XXX,vfs_dcache_size=CRAP <dev> <mntpoint>

In this case you leave the second option and pass it to the fs option
parser (as you already set ret=0), which is wrong.  I think you should
explicitly return 1 where you know the option is related to VFS, but you
failed to parse it.  It would look even simplier than current code.

(Yes, this is a rare situation, but I can imagine some program that
automatically adds mount options to the existing list and passes it to
mount.)

> +			if (option < DCACHE_MIN_SIZE) {
> +				printk(KERN_INFO "dcache size %d smaller than "
> +				       "minimum (%d)\n", option, DCACHE_MIN_SIZE);
> +				option = DCACHE_MIN_SIZE;
> +			}
> +
> +			ops->vfs_dcache_size = option;
> +
> +			/*
> +			 * The actual filesystems don't expect any option
> +			 * they don't understand to be received in the option
> +			 * string. So we strip off anything we processed, and
> +			 * give them a clean options string.
> +			 */
> +			ret = 0;
> +			if (!opt) /* it is the last option listed */
> +				*(options + (p - start)) = '\0';
> +			else
> +				strcpy(options + (p - start), opt);
> +			break;
> +		default:
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	kfree(start);
> +	return ret;
> +}

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
