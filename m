Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282Ab1ETOZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:25:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48483 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ETOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=a4sGq1rna0NSiV5q3JE8Ckd2qIlG43MAs+SQIDBfDo/F2SaNuaqecgJoJP/3ouIoOz
         BP7GQoBM5u9N0oZiW4Pq/OUEyrdaToQEPd6EPdeIhvFQZu5dkdpnRMq6poFbC+ycCCM9
         fqniKYNXjQ30icybk3bLYc0jAAMRWWu8njGo0=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
	<D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
	<B0729E4C-D581-4EAB-A175-A6B8B34692B5@fsl.cs.sunysb.edu>
Date: Fri, 20 May 2011 16:25:38 +0200
In-Reply-To: <B0729E4C-D581-4EAB-A175-A6B8B34692B5@fsl.cs.sunysb.edu> (Erez
	Zadok's message of "Fri, 20 May 2011 01:55:12 -0400")
Message-ID: <87ipt5mot9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:
> Niklos, I forgot to mention that I had to apply a small fix to a VFS
> bug in fs/namei.c:1362, where a mix of symlinks and renames, using
> racer, triggers an BUG_ON at the VFS layer (very reproducible).
> Without this fix, racer oopses in the VFS well before it gets to
> trigger overlayfs bugs.  It's a pity 2.6.39 was released with this
> very reproducible *VFS* level bug (doesn't anyone run racer+fsx+ltp
> before releasing a new kernel?)
>
> Anyway, here's the small patch here.  Clearly viro/hch need to review
> this "fix" b/c I'm not sure it's really the right one

Patch looks good to me.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

If you've got a patch fixing a serious bug, you'd better send it to
Linus and Andrew (as well as the VFS maintainers), where it'll get more
prompt evaluation.

You can still do that, also adding "CC: stable@kernel.org" to the SOB
block in the patch so that the fix quickly makes it into the 2.6.39
stable series.

Thanks,
Miklos


>
> VFS: move BUG_ON test for symlink nd->depth after current->link_count test
>
> This solves a bug in nested_symlink (which was rewritten from
> do_follow_link), and follows the order of depth tests that existed before.
> The bug triggers a BUG_ON in fs/namei.c:1346, when running racer with
> symlink and rename ops.
>
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> diff --git a/fs/namei.c b/fs/namei.c
> index 017c3fa..7a93387 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1343,12 +1343,12 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
>  {
>  	int res;
>  
> -	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
>  	if (unlikely(current->link_count >= MAX_NESTED_LINKS)) {
>  		path_put_conditional(path, nd);
>  		path_put(&nd->path);
>  		return -ELOOP;
>  	}
> +	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
>  
>  	nd->depth++;
>  	current->link_count++;
