Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GSOwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:52:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39817 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2GSOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120627110512.734751587@openvz.org>
References: <20120627110116.201735815@openvz.org>
	<20120627110512.734751587@openvz.org>
Date: Thu, 19 Jul 2012 07:52:41 -0700
Message-ID: <CA+RrjuUDR1ZFFQq3tT2K0W0u_KDufOn2rfepndWYVqH6Zqz3bg@mail.gmail.com>
Subject: Re: [rfc 5/7] fs, epoll: Add procfs fdinfo helper
From: Matthew Helsley <matt.helsley@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 4:01 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> This allow us to print out eventpoll target file descriptor,
> events and data, the /proc/pid/fdinfo/fd consists of
>
>  | pos: 0
>  | flags:       02
>  | tfd:        5 events:       1d data: ffffffffffffffff
>
> This feature is CONFIG_CHECKPOINT_RESTORE only.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>
> ---
>  fs/eventpoll.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>
> Index: linux-2.6.git/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.git.orig/fs/eventpoll.c
> +++ linux-2.6.git/fs/eventpoll.c
> @@ -38,6 +38,8 @@
>  #include <asm/io.h>
>  #include <asm/mman.h>
>  #include <linux/atomic.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>
>  /*
>   * LOCKING:
> @@ -1897,6 +1899,83 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
>         return error;
>  }
>
> +#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
> +
> +struct epitem_fdinfo {
> +       struct epoll_event      ev;
> +       int                     fd;
> +};
> +
> +static struct epitem_fdinfo *
> +seq_lookup_fdinfo(struct proc_fdinfo_extra *extra, struct eventpoll *ep, loff_t num)
> +{
> +       struct epitem_fdinfo *fdinfo = extra->priv;
> +       struct epitem *epi = NULL;
> +       struct rb_node *rbp;
> +
> +       mutex_lock(&ep->mtx);
> +       for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
> +               if (num-- == 0) {
> +                       epi = rb_entry(rbp, struct epitem, rbn);
> +                       fdinfo->fd = epi->ffd.fd;
> +                       fdinfo->ev = epi->event;
> +                       break;

This will be incredibly slow. epoll was designed to scale to tens of
thousands of file descriptors. This algorithm is O(N^2) because each
time we show a new epoll item we walk through the whole rb tree again
(we're not doing a search so it isn't O(NlogN)).

Also, we could miss one or more later items if one of the earlier
items is removed from the epoll set in between "seq_lookup_fdinfo"
calls. This isn't a problem for checkpoint because we assume the task
(and everything with this eventpoll file in its fd table) is frozen.
However it means the file will be worse than useless for almost any
other purpose because they are unlikely to realize they need to freeze
all the task(s) to get consistent data.

Cheers,
    -Matt Helsley
