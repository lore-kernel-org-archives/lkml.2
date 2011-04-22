Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1DVAKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:10:53 -0400
Received: from shutemov.name ([188.40.19.243]:45460 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab1DVAKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:10:52 -0400
Date: Fri, 22 Apr 2011 03:10:50 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] um: Adjust current_thread_info() for gcc-4.6
Message-ID: <20110422001050.GA468@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302908593-4374-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 01:03:13AM +0200, Richard Weinberger wrote:
> In some cases gcc-4.6 will optimize away current_thread_info().
> To prevent gcc from doing so the stack address has to be obtained
> via inline asm.
> 
> LKML-Reference: http://marc.info/?i=201104132150.05623.richard@nod.at
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

Also reproducible with gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4).

> ---
>  arch/um/include/asm/thread_info.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
> index e2cf786..5bd1bad 100644
> --- a/arch/um/include/asm/thread_info.h
> +++ b/arch/um/include/asm/thread_info.h
> @@ -49,7 +49,10 @@ static inline struct thread_info *current_thread_info(void)
>  {
>  	struct thread_info *ti;
>  	unsigned long mask = THREAD_SIZE - 1;
> -	ti = (struct thread_info *) (((unsigned long) &ti) & ~mask);
> +	void *p;
> +
> +	asm volatile ("" : "=r" (p) : "0" (&ti));
> +	ti = (struct thread_info *) (((unsigned long)p) & ~mask);
>  	return ti;
>  }
>  
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
