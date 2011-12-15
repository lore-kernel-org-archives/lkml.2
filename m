Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab1LOWTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:19:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:19:46 -0500
Date: Thu, 15 Dec 2011 14:19:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
Message-Id: <20111215141945.add405d5.akpm@linux-foundation.org>
In-Reply-To: <1323917052-480-1-git-send-email-walken@google.com>
References: <1323917052-480-1-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 18:44:12 -0800
Michel Lespinasse <walken@google.com> wrote:

> binary_sysctl() calls sysctl_getname() which allocates from
> names_cache slab usin __getname()
> 
> The matching function to free the name is __putname(), and not
> putname() which should be used only to match getname() allocations.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  kernel/sysctl_binary.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index e8bffbe..2ce1b30 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -1354,7 +1354,7 @@ static ssize_t binary_sysctl(const int *name, int nlen,
>  
>  	fput(file);
>  out_putname:
> -	putname(pathname);
> +	__putname(pathname);
>  out:
>  	return result;
>  }

I think the patch is correct but the description is misleading?

I see no memory leak here.  Calling __putname() directly simply
bypasses some audit-related stuff.
