Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2JVLK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:10:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:51118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2JVLK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:10:57 -0400
Message-ID: <1350904240.2768.95.camel@twins>
Subject: Re: [PATCH v2 1/3] sched: introduce distinct per-cpu load average
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 22 Oct 2012 13:10:40 +0200
In-Reply-To: <1350759962-7092-2-git-send-email-andrea@betterlinux.com>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
	 <1350759962-7092-2-git-send-email-andrea@betterlinux.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 21:06 +0200, Andrea Righi wrote:
> @@ -383,13 +383,7 @@ struct rq {
>         struct list_head leaf_rt_rq_list;
>  #endif
>  

> +       unsigned long __percpu *nr_uninterruptible; 

This is O(nr_cpus^2) memory..


> +unsigned long nr_uninterruptible_cpu(int cpu)
> +{
> +       struct rq *this = cpu_rq(cpu);
> +       unsigned long val = 0;
> +       int i;
> +
> +       for_each_online_cpu(i)
> +               val += per_cpu(*this->nr_uninterruptible, i);
> +
> +       return val;
> +}
> 
> 
I suspect you've got an accounting leak here on hot-plug.
> 
>  unsigned long nr_uninterruptible(void)
>  {
>         unsigned long i, sum = 0;
>  
>         for_each_possible_cpu(i)
> -               sum += cpu_rq(i)->nr_uninterruptible;
> +               sum += nr_uninterruptible_cpu(i);
>  
>         /*
>          * Since we read the counters lockless, it might be slightly

And this makes O(n^2) runtime!


