Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0GGP1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:27:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:44006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab0GGP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:27:09 -0400
Date: Thu, 8 Jul 2010 01:27:06 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 05/11] vfs: Support null pathname in readlink
Message-ID: <20100707152706.GT11732@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1276621981-2774-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276621981-2774-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:42:55PM +0530, Aneesh Kumar K.V wrote:
> From: NeilBrown <neilb@suse.de>
> 
> This enables to use readlink to get the link target name
> from a file descriptor point to the link. This can be used
> with open_by_handle syscall that returns a file descriptor for a link.
> We can then use this file descriptor to get the target name.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/stat.c |   30 ++++++++++++++++++++++--------
>  1 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index c4ecd52..49b95a7 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -284,26 +284,40 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
>  SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
>  		char __user *, buf, int, bufsiz)
>  {
> -	struct path path;
> -	int error;
> +	int error = 0;
> +	struct path path, *pp;
> +	struct file *file = NULL;
>  
>  	if (bufsiz <= 0)
>  		return -EINVAL;
>  
> -	error = user_path_at(dfd, pathname, 0, &path);
> +	if (pathname == NULL && dfd != AT_FDCWD) {
> +		file = fget(dfd);
> +
> +		if (file)
> +			pp = &file->f_path;
> +		else
> +			error = -EBADF;
> +	} else {
> +		error = user_path_at(dfd, pathname, 0, &path);
> +		pp = &path;
> +	}

This (and all the others) is really ugly overloading of syscall
arguments IMO, and the changelog is seriously lacking for such changes.

This also changes the the syscall API of existing calls; from reading
the path at NULL, to switching to a completely different syscall.
Perhaps you're assuming nobody relies on SIGSEGV / mmapped NULL address
there, but even then you surely need to document the changed semantics
somewhere (and document the new syscall semantics properly).
