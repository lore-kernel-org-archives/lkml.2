Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0EBRby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068Ab0EBRbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:31:52 -0400
Message-ID: <4BDDB6E9.4060703@redhat.com>
Date: Sun, 02 May 2010 20:31:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
References: <Alexander Viro <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2010 07:46 PM, Changli Gao wrote:
> use kmalloc() to allocate fdmem if possible.
>
> vmalloc() is used as a fallback solution for fdmem allocation. Two members are
> added into the hole of the structure fdtable to indicate if vmalloc() is used
> or not.
>
>
> diff --git a/fs/file.c b/fs/file.c
> index 34bb7f7..f71dd85 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -39,28 +39,34 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
>    */
>   static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
>
> -static inline void * alloc_fdmem(unsigned int size)
> +static inline void *alloc_fdmem(unsigned int size, unsigned short *use_vmalloc)
>   {
> -	if (size<= PAGE_SIZE)
> -		return kmalloc(size, GFP_KERNEL);
> -	else
> -		return vmalloc(size);
> +	void *data;
> +
> +	data = kmalloc(size, GFP_KERNEL);
> +	if (data != NULL) {
> +		*use_vmalloc = 0;
> +		return data;
> +	}
> +	*use_vmalloc = 1;
> +
> +	return vmalloc(size);
>   }
>    

Perhaps vmalloc() should do this by itself?  vfree() can examine the 
pointer and call kfree() if it isn't within the vmalloc address range.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

