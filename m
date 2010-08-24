Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0HXXq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:46:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932767Ab0HXXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:46:54 -0400
Date: Tue, 24 Aug 2010 16:46:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] avoiding the same resource to be inserted
Message-Id: <20100824164622.a3b2c1ed.akpm@linux-foundation.org>
In-Reply-To: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 23:55:38 +0800
Huang Shijie <shijie8@gmail.com> wrote:

>   If the same resource is inserted to the resource tree
> (maybe not on purpose), a dead loop will be created. In this situation,
> The kernel does not report any warning or error	:(
> 
>   The command below will show a endless print.
>   #cat /proc/iomem

OK, we shouldn't do that.

>   So, adding the check for the same resource is needed for the stability
> and reliability of the kernel.
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  kernel/resource.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 7b36976..60daab4 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -451,7 +451,7 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
>  		if (!first)
>  			return first;
>  
> -		if (first == parent)
> +		if (first == parent || first == new)
>  			return first;

However, inserting the same thing twice _is_ a bug, and we shouldn't
silently accept it like this.  We should tell the programmer!

But we can recover from the situation so let's not kill the box.  How
does this look?

--- a/kernel/resource.c~kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource
+++ a/kernel/resource.c
@@ -453,6 +453,8 @@ static struct resource * __insert_resour
 
 		if (first == parent)
 			return first;
+		if (WARN_ON(first == new))	/* duplicated insertion */
+			return first;
 
 		if ((first->start > new->start) || (first->end < new->end))
 			break;
_

