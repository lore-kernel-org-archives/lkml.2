Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0I3Ri5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:38:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab0I3Ri4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:38:56 -0400
Date: Thu, 30 Sep 2010 10:39:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
Message-Id: <20100930103926.e60f3099.akpm@linux-foundation.org>
In-Reply-To: <1285867685.2615.865.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-16-git-send-email-david@fromorbit.com>
	<20100929215312.5fcb6976.akpm@linux-foundation.org>
	<1285824982.5211.675.camel@edumazet-laptop>
	<1285833189.2615.31.camel@edumazet-laptop>
	<20100930011417.6ca16ed7.akpm@linux-foundation.org>
	<1285842136.2615.251.camel@edumazet-laptop>
	<20100930094558.97c9afa2.akpm@linux-foundation.org>
	<1285867685.2615.865.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 19:28:05 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 30 septembre 2010 __ 09:45 -0700, Andrew Morton a __crit :
> 
> > Could eliminate `p' I guess, but that would involve using
> > __get_cpu_var() as an lval, which looks vile and might generate worse
> > code.
> > 
> 
> Hmm, I see, please check this new patch, using the most modern stuff ;)
> 
> > Readers of this code won't know why last_ino_get() was marked noinline.
> > It looks wrong, really.
> 
> Oops sorry, this was a temporary hack of mine to ease disassembly
> analysis. Good catch !
> 
> Here is the new generated code on i686 (with the noinline) : 
> pretty good ;)
> 
> c02e5930 <last_ino_get>:
> c02e5930:	55                   	push   %ebp
> c02e5931:	89 e5                	mov    %esp,%ebp
> c02e5933:	64 a1 44 29 7d c0    	mov    %fs:0xc07d2944,%eax
> c02e5939:	a9 ff 03 00 00       	test   $0x3ff,%eax
> c02e593e:	74 09                	je     c02e5949 <last_ino_get+0x19>
> c02e5940:	40                   	inc    %eax
> c02e5941:	64 a3 44 29 7d c0    	mov    %eax,%fs:0xc07d2944
> c02e5947:	c9                   	leave  
> c02e5948:	c3                   	ret    
> c02e5949:	b8 00 04 00 00       	mov    $0x400,%eax
> c02e594e:	f0 0f c1 05 80 c8 92 c0	lock xadd %eax,0xc092c880
> c02e5956:	eb e8                	jmp    c02e5940 <last_ino_get+0x10>
> 

That uniprocessor, PREEMPT=n I guess.

> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -624,6 +624,45 @@ void inode_add_to_lists(struct super_block *sb, struct inode *inode)
>  }
>  EXPORT_SYMBOL_GPL(inode_add_to_lists);
>  
> +#define LAST_INO_BATCH 1024
> +
> +/*
> + * Each cpu owns a range of LAST_INO_BATCH numbers.
> + * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
> + * to renew the exhausted range.
> + *
> + * This does not significantly increase overflow rate because every CPU can
> + * consume at most LAST_INO_BATCH-1 unused inode numbers. So there is
> + * NR_CPUS*(LAST_INO_BATCH-1) wastage. At 4096 and 1024, this is ~0.1% of the
> + * 2^32 range, and is a worst-case. Even a 50% wastage would only increase
> + * overflow rate by 2x, which does not seem too significant.
> + *
> + * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
> + * error if st_ino won't fit in target struct field. Use 32bit counter
> + * here to attempt to avoid that.
> + */
> +static DEFINE_PER_CPU(unsigned int, last_ino);
> +
> +static unsigned int last_ino_get(void)
> +{
> +	unsigned int res;
> +
> +	get_cpu();
> +	res = __this_cpu_read(last_ino);
> +#ifdef CONFIG_SMP
> +	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
> +		static atomic_t shared_last_ino;
> +		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
> +
> +		res = next - LAST_INO_BATCH;
> +	}
> +#endif
> +	res++;
> +	__this_cpu_write(last_ino, res);
> +	put_cpu();
> +	return res;
> +}

Looks good ;)


