Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab0EDW2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:28:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab0EDW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:28:31 -0400
Date: Tue, 4 May 2010 15:27:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v2] fs: use kmalloc() to allocate fdmem if possible
Message-Id: <20100504152713.0c72a087.akpm@linux-foundation.org>
In-Reply-To: <1272826920-8899-1-git-send-email-xiaosuo@gmail.com>
References: <1272826920-8899-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 May 2010 03:02:00 +0800
Changli Gao <xiaosuo@gmail.com> wrote:

> use kmalloc() to allocate fdmem if possible.
> 
> vmalloc() is used as a fallback solution for fdmem allocation. A new helper
> function __free_fdtable() is introduced to reduce the lines of code.
> 
> A potential bug, vfree() a memory allocated by kmalloc(), is fixed.
> 

Seems a reasonable thing to do.  It might also be reasonable to make
vmalloc() try kmalloc() first, but that's a separate exercise.

> ----
>  fs/file.c |   55 ++++++++++++++++++++++---------------------------------
>  1 file changed, 22 insertions(+), 33 deletions(-)
> diff --git a/fs/file.c b/fs/file.c
> index 34bb7f7..9af31ae 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -39,28 +39,27 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
>   */
>  static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
>  
> -static inline void * alloc_fdmem(unsigned int size)
> +static inline void *alloc_fdmem(unsigned int size)
>  {
> -	if (size <= PAGE_SIZE)
> -		return kmalloc(size, GFP_KERNEL);
> -	else
> -		return vmalloc(size);
> +	void *data;
> +
> +	data = kmalloc(size, GFP_KERNEL);

This most definitely should have __GFP_NOWARN.

> +	if (data != NULL)
> +		return data;
> +
> +	return vmalloc(size);
>  }
>  
> -static inline void free_fdarr(struct fdtable *fdt)
> +static inline void free_fdmem(void *ptr)
>  {
> -	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
> -		kfree(fdt->fd);
> -	else
> -		vfree(fdt->fd);
> +	is_vmalloc_addr(ptr) ? vfree(ptr) : kfree(ptr);
>  }
>  
> -static inline void free_fdset(struct fdtable *fdt)
> +static inline void __free_fdtable(struct fdtable *fdt)
>  {
> -	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
> -		kfree(fdt->open_fds);
> -	else
> -		vfree(fdt->open_fds);
> +	free_fdmem(fdt->fd);
> +	free_fdmem(fdt->open_fds);
> +	kfree(fdt);
>  }

And these should be uninlined - they're too large to be inlined.

My version of gcc seems to just uninline them anyway, but forcing them
to be inlined with __always_inline indeed causes 70-80 bytes more text,
and we figure that larger text generally causes a slower kernel due to
cache eviction effects.


