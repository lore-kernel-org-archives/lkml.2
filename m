Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0FRX3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:29:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab0FRX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:29:29 -0400
Date: Fri, 18 Jun 2010 16:28:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/23] pagemap: Avoid unused-but-set variable
Message-Id: <20100618162851.c0878f22.akpm@linux-foundation.org>
In-Reply-To: <20100610111039.ED2B2B1A2B@basil.firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
	<20100610111039.ED2B2B1A2B@basil.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 13:10:39 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Avoid quite a lot of warnings in header files in a gcc 4.6 -Wall builds
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/pagemap.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.35-rc2-gcc/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/include/linux/pagemap.h
> +++ linux-2.6.35-rc2-gcc/include/linux/pagemap.h
> @@ -423,8 +423,10 @@ static inline int fault_in_pages_readabl
>  		const char __user *end = uaddr + size - 1;
>  
>  		if (((unsigned long)uaddr & PAGE_MASK) !=
> -				((unsigned long)end & PAGE_MASK))
> +				((unsigned long)end & PAGE_MASK)) {
>  		 	ret = __get_user(c, end);
> +			(void)c;
> +		}
>  	}
>  	return ret;
>  }

urgh.  In fact I'd urgh the whole patchset.

Problem is, anyone who looks at all these random (void) casts is going
to have a hard time working out why they're there.  This is worsened by
the long-standing practice wherein some people put unneeded (void) casts all
over the place due to being traumatised by lint 15 years ago (I think).

Wouldn't it be better to make this stuff self-documenting, so anyone
who reads the code can immediately see what it's doing, rather than
scratching their heads over random, seemingly-unneeded casts?

#define gcc_46_is_a_pita(expr)	((void)(expr))

?
