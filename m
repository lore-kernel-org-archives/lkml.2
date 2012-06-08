Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2FHAHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:07:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2FHAHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:07:23 -0400
Date: Thu, 7 Jun 2012 17:07:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Message-Id: <20120607170721.474bd8d8.akpm@linux-foundation.org>
In-Reply-To: <2325453.OX7ktP55U1@vlad>
References: <2325453.OX7ktP55U1@vlad>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 14:58:42 +0300
Vlad Zolotarov <vlad@scalemp.com> wrote:

> From: Shai Fultheim <shai@scalemp.com>
> 
> bh_cachep is only written to once on initialization, so move it to the
> __read_mostly section.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> ---
>  fs/buffer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ad5938c..838a9cf 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3152,7 +3152,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
>  /*
>   * Buffer-head allocation
>   */
> -static struct kmem_cache *bh_cachep;
> +static struct kmem_cache *bh_cachep __read_mostly;
>  

hm, I thought I replied to this earlier, but I can't find that email.

Yes, bh_cachep is read-mostly.  In fact it's write-once.  But the same
is true of all kmem_cache*'s.  I don't see any particular reason for
singling out bh_cachep.


Alas, I don't see a smart way of addressing this.  It's either a
patchset which adds __read_mostly to all kmem_cache*'s, or a patchset
which converts all the definitions to use some nasty macro which
inserts the __read_mostly.



And I still have theoretical concerns with __read_mostly.  As we
further sort the storage into read-mostly and write-often sections, the
density of writes in the write-mostly section increases.  IOW, removing
the read-mostly padding *increase* cross-CPU traffic in the write-often
scction.  IOW2, leaving the read-mostly stuff where it is provides
beneficial padding to the write-often fields.  I don't think it has
been shown that there will be net gains.
