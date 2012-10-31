Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965735Ab2JaVLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:11:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50748 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501Ab2JaVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:11:09 -0400
Date: Wed, 31 Oct 2012 14:11:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] fs: xattr: rewrite simple_xattr_set()
Message-ID: <20121031211104.GY2945@htj.dyndns.org>
References: <20121025152613.GF14085@redhat.com>
 <20121025173326.GH11442@htj.dyndns.org>
 <20121025175412.GG14085@redhat.com>
 <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
 <20121025183018.GI14085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025183018.GI14085@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the delay.

Just one nitpick.

On Thu, Oct 25, 2012 at 02:30:18PM -0400, Aristeu Rozanski wrote:
> +static int __simple_xattr_remove(struct simple_xattrs *xattrs,
> +				 const char *name)
> +{
> +	struct simple_xattr *xattr;
> +
> +	xattr = __find_xattr(xattrs, name);
>  	if (xattr) {
> +		list_del(&xattr->list);
>  		kfree(xattr->name);
>  		kfree(xattr);
> +		return 0;
>  	}
> -	return err;
>  
> +	return -ENODATA;
> +}
> +
> +/*
> + * xattr REMOVE operation for in-memory/pseudo filesystems
> + */
> +int simple_xattr_remove(struct simple_xattrs *xattrs, const char *name)
> +{
> +	int rc;
> +
> +	spin_lock(&xattrs->lock);
> +	rc = __simple_xattr_remove(xattrs, name);
> +	spin_unlock(&xattrs->lock);
> +
> +	return rc;

Do we need these two functions?  Can't you either collapse
__simple_xttar_remove() into simple_xattr_remove() or just call
__simple_xattr_remove() directly from simple_xattr_set() with locking
handled there?  Also, why doesn't simple_xattr_remove() have static?

Thanks.

-- 
tejun
