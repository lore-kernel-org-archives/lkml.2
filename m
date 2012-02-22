Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2BVKXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:23:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab2BVKXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:23:20 -0500
Date: Wed, 22 Feb 2012 11:23:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: hardlink creation restriction cleanup
Message-ID: <20120222102301.GC30339@elte.hu>
References: <20120222012103.GA13295@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222012103.GA13295@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> Clean-up of hardlink restriction logic, as suggested by Andrew Morton.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/namei.c |   59 +++++++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 41 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 8ed4e00..a4a21a5 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -693,46 +693,69 @@ static inline int may_follow_link(struct path *link)
>  }
>  
>  /**
> + * safe_hardlink_source - Check for safe hardlink conditions
> + * @inode: the source inode to hardlink from
> + *
> + * Return false if at least one of the following conditions:
> + *    - inode is not a regular file
> + *    - inode is setuid
> + *    - inode is setgid and group-exec
> + *    - access failure for read and write
> + *
> + * Otherwise returns true.
> + */
> +static bool safe_hardlink_source(struct inode *inode)
> +{
> +	mode_t mode = inode->i_mode;
> +
> +	/* Special files should not get pinned to the filesystem. */
> +	if (!S_ISREG(mode))
> +		return false;
> +	/* Setuid files should not get pinned to the filesystem. */
> +	if (mode & S_ISUID)
> +		return false;
> +	/* Executable setgid files should not get pinned to the filesystem. */
> +	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
> +		return false;
> +	/* Hardlinking to unreadable or unwritable sources is dangerous. */
> +	if (inode_permission(inode, MAY_READ | MAY_WRITE))
> +		return false;
> +
> +	return true;

A really minor nitpick, could we use this form please:

static bool safe_hardlink_source(struct inode *inode)
{
	mode_t mode = inode->i_mode;

	/* Special files should not get pinned to the filesystem. */
	if (!S_ISREG(mode))
		return false;

	/* Setuid files should not get pinned to the filesystem. */
	if (mode & S_ISUID)
		return false;

	/* Executable setgid files should not get pinned to the filesystem. */
	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
		return false;

	/* Hardlinking to unreadable or unwritable sources is dangerous. */
	if (inode_permission(inode, MAY_READ | MAY_WRITE))
		return false;

	return true;
}

Those separate blocks of comments and conditions stand out much 
nicer this way, making it way easier on the eyes - to my eyes at 
least ;-)

Thanks,

	Ingo
