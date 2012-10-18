Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2JRNoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab2JRNoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:44:10 -0400
Date: Thu, 18 Oct 2012 09:43:53 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch for-3.7] fs, xattr: fix bug when removing a name not in
 xattr list
Message-ID: <20121018134353.GM29956@redhat.com>
References: <20121018024317.GA25407@localhost>
 <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 08:41:15PM -0700, David Rientjes wrote:
> Commit 38f38657444d ("xattr: extract simple_xattr code from tmpfs") moved
> some code from tmpfs but introduced a subtle bug along the way.
> 
> If the name passed to simple_xattr_remove() does not exist in the list of
> xattrs, then it is possible to call kfree(new_xattr) when new_xattr is
> actually initialized to itself on the stack via uninitialized_var().
> 
> This causes a BUG() since the memory was not allocated via the slab
> allocator and was not bypassed through to the page allocator because it
> was too large.
> 
> Initialize the local variable to NULL so the kfree() never takes place.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/xattr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -846,7 +846,7 @@ static int __simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
>  			      const void *value, size_t size, int flags)
>  {
>  	struct simple_xattr *xattr;
> -	struct simple_xattr *uninitialized_var(new_xattr);
> +	struct simple_xattr *new_xattr = NULL;
>  	int err = 0;
>  
>  	/* value == NULL means remove */

I think Sasha Levin was working on that (Cc'd) along with the smatch fix.
Anyway, __simple_xattr_set is too confusing and rewriting it is in my TODO list
which will shut up smatch too.

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

