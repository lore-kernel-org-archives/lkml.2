Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0D0VsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:48:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab0D0VsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:48:01 -0400
Date: Tue, 27 Apr 2010 14:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page
Message-Id: <20100427144723.a8c3d997.akpm@linux-foundation.org>
In-Reply-To: <1272351858.24125.14.camel@yhuang-dev.sh.intel.com>
References: <1272351858.24125.14.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 15:04:18 +0800
Huang Ying <ying.huang@intel.com> wrote:

> With this patch, the caller of __get_user_pages can distinguish
> HWPOISON page from general FAULT page. This is needed by KVM, where
> UCR MCE should be relayed to guest for HWPOISON page, while
> instruction emulation and MMIO will be tried for general FAULT page.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  include/asm-generic/errno.h |    2 ++
>  mm/memory.c                 |    5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/include/asm-generic/errno.h
> +++ b/include/asm-generic/errno.h
> @@ -108,4 +108,6 @@
>  
>  #define ERFKILL		132	/* Operation not possible due to RF-kill */
>  
> +#define EHWPOISON	133	/* Memory page has hardware error */
> +
>  #endif
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1432,9 +1432,10 @@ int __get_user_pages(struct task_struct
>  				if (ret & VM_FAULT_ERROR) {
>  					if (ret & VM_FAULT_OOM)
>  						return i ? i : -ENOMEM;
> -					if (ret &
> -					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
> +					if (ret & VM_FAULT_SIGBUS)
>  						return i ? i : -EFAULT;
> +					if (ret & VM_FAULT_HWPOISON)
> +						return i ? i : -EHWPOISON;
>  					BUG();
>  				}
>  				if (ret & VM_FAULT_MAJOR)
> 

This will cause various code paths (eg: fs/direct-io.c) to return
-EHWPOISON to userspace, will it not?

