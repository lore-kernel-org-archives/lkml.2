Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0ELTgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:36:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab0ELTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:36:43 -0400
Date: Wed, 12 May 2010 12:36:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CacheFiles: Fix error handling in
 cachefiles_determine_cache_security()
Message-Id: <20100512123629.41139fd5.akpm@linux-foundation.org>
In-Reply-To: <20100512143403.2722.29652.stgit@warthog.procyon.org.uk>
References: <20100512143403.2722.29652.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 15:34:03 +0100
David Howells <dhowells@redhat.com> wrote:

> cachefiles_determine_cache_security() is expected to return with a security
> override in place.  However, if set_create_files_as() fails, we fail to do
> this.  In this case, we should just reinstate the security override that was
> set by the caller.
> 
> Furthermore, if set_create_files_as() fails, we should dispose of the new
> credentials we were in the process of creating.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/cachefiles/security.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cachefiles/security.c b/fs/cachefiles/security.c
> index b5808cd..039b501 100644
> --- a/fs/cachefiles/security.c
> +++ b/fs/cachefiles/security.c
> @@ -77,6 +77,8 @@ static int cachefiles_check_cache_dir(struct cachefiles_cache *cache,
>  /*
>   * check the security details of the on-disk cache
>   * - must be called with security override in force
> + * - must return with a security override in force - even in the case of an
> + *   error
>   */
>  int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
>  					struct dentry *root,
> @@ -99,6 +101,8 @@ int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
>  	 * which create files */
>  	ret = set_create_files_as(new, root->d_inode);
>  	if (ret < 0) {
> +		abort_creds(new);
> +		cachefiles_begin_secure(cache, _saved_cred);
>  		_leave(" = %d [cfa]", ret);
>  		return ret;
>  	}

The changelog makes it hard for civilians to work out what the
user-visible effect of this bug was.

Should this fix be backported into -stable?
