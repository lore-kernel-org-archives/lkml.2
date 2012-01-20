Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2ATWzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:55:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2ATWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:55:46 -0500
Date: Fri, 20 Jan 2012 14:55:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] proc:  speedup /proc/stat handling
Message-Id: <20120120145545.bcf5c76f.akpm@linux-foundation.org>
In-Reply-To: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 16:59:24 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096
> bytes, and is slow :
> 
> # strace -T -o /tmp/STRACE cat /proc/stat | wc -c
> 5826
> # grep "cpu " /tmp/STRACE
> read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>
> 
> 
> Thats partly because show_stat() must be called twice since initial
> buffer size is too small (4096 bytes for less than 32 possible cpus)
> 
> Fix this by :
> 
> 1) Taking into account nr_irqs in the initial buffer sizing.
> 
> 2) Using ksize() to allow better filling of initial buffer.
> 
> 3) Reduce the bloat on "intr ..." line :
>    Dont output trailing " 0" values at the end of irq range.

This one is worrisome.  Mainly because the number of fields in the
`intr' line can now increase over time (yes?).  So if a monitoring program
were to read this line and use the result to size an internal buffer
then after a while it might start to drop information or to get buffer
overruns.

> An alternative to 1) would be to remember the largest m->count reached
> in show_stat()
> 
>
> ...
>
> @@ -157,14 +171,17 @@ static int show_stat(struct seq_file *p, void *v)
>  
>  static int stat_open(struct inode *inode, struct file *file)
>  {
> -	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
> +	unsigned size = 1024 + 128 * num_possible_cpus();
>  	char *buf;
>  	struct seq_file *m;
>  	int res;
>  
> +	/* minimum size to display a 0 count per interrupt : 2 bytes */
> +	size += 2 * nr_irqs;
> +
>  	/* don't ask for more than the kmalloc() max size */
> -	if (size > KMALLOC_MAX_SIZE)
> -		size = KMALLOC_MAX_SIZE;
> +	size = min_t(unsigned, size, KMALLOC_MAX_SIZE);

The change looks reasonable, however the use of KMALLOC_MAX_SIZE in the
existing code is worrisome.  If `size' ever gets that large then
there's a decent chance that the kmalloc() will simply fail and a
better chance that it would cause tons of VM scanning activity,
including disk writeout.

But I've never seen anyone report problems in this area, so shrug.

