Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2JRMnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:43:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42496 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2JRMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
References: <20121018024317.GA25407@localhost>
	<alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
Date: Thu, 18 Oct 2012 20:43:03 +0800
Message-ID: <CAJd=RBAeUs9qSHjL09Qe4RphuvfLyn=bcp=c4heSb+d15Gnh-g@mail.gmail.com>
Subject: Re: [patch for-3.7] fs, xattr: fix bug when removing a name not in
 xattr list
From: Hillf Danton <dhillf@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>,
        Li Zefan <lizefan@huawei.com>, Aristeu Rozanski <aris@redhat.com>,
        Tejun Heo <tj@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-sec@jasper.es,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Oct 18, 2012 at 11:41 AM, David Rientjes <rientjes@google.com> wrote:
> Commit 38f38657444d ("xattr: extract simple_xattr code from tmpfs") moved
> some code from tmpfs but introduced a subtle bug along the way.
>
That commit is fine but you did revert commit b9d6cfdeaf67(xattr: mark
variable as uninitialized to make both gcc and smatch happy), too late
to spin?

Hillf
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
>                               const void *value, size_t size, int flags)
>  {
>         struct simple_xattr *xattr;
> -       struct simple_xattr *uninitialized_var(new_xattr);
> +       struct simple_xattr *new_xattr = NULL;
>         int err = 0;
>
>         /* value == NULL means remove */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
