Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2JRD4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:56:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41974 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2JRDz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:55:58 -0400
Date: Wed, 17 Oct 2012 20:55:49 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, Li Zefan <lizefan@huawei.com>,
        Aristeu Rozanski <aris@redhat.com>, Tejun Heo <tj@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [patch for-3.7] fs, xattr: fix bug when removing a name not in
 xattr list
In-Reply-To: <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.00.1210172052420.20979@eggly.anvils>
References: <20121018024317.GA25407@localhost> <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com> <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, David Rientjes wrote:

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

Acked-by: Hugh Dickins <hughd@google.com>

Thank you both: a fine example of the danger of uninitialized_var()!

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
> 
