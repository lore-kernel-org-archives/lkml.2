Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0LJAoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:44:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533Ab0LJAox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:44:53 -0500
Date: Thu, 9 Dec 2010 16:44:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2 3/4] kthread: NUMA aware kthread_create_on_cpu()
Message-Id: <20101209164438.fae1ba4c.akpm@linux-foundation.org>
In-Reply-To: <1291043695.3435.980.camel@edumazet-laptop>
References: <1290972833.29196.90.camel@edumazet-laptop>
	<20101128224024.GA12300@basil.fritz.box>
	<1290984712.29196.100.camel@edumazet-laptop>
	<20101128230146.GB12300@basil.fritz.box>
	<1290987424.29196.128.camel@edumazet-laptop>
	<20101129090510.GA15763@basil.fritz.box>
	<1291023532.3435.29.camel@edumazet-laptop>
	<1291043695.3435.980.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 16:14:55 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> All kthreads being created from a single helper task, they all use
> memory from a single node for their kernel stack and task struct.
> 
> This patch suite creates kthread_create_on_cpu(), adding a 'cpu'
> parameter to parameters already used by kthread_create().
> 
> This parameter serves in allocating memory for the new kthread on its
> memory node if possible.

The name "kthread_create_on_cpu" is pretty misleading.

One would expect such a function to create a kthread which is bound to
that CPU.  But what it in fact does is to create a kthread which is
bound to all CPUs and whose stack, task_struct and thread_info were
allocated from the node which contains `cpu'.

Also, a saner interface would be one which takes the numa_node_id, not
the cpu number.

>
> ...
>
>  /**
> - * kthread_create - create a kthread.
> + * kthread_create_on_cpu - create a kthread.
>   * @threadfn: the function to run until signal_pending(current).
>   * @data: data ptr for @threadfn.
> + * @cpu: cpu number.
>   * @namefmt: printf-style name for the thread.
>   *
>   * Description: This helper function creates and names a kernel
>   * thread.  The thread will be stopped: use wake_up_process() to start
>   * it.  See also kthread_run().
>   *
> + * If thread is going to be bound on a particular cpu, give its number
> + * in @cpu, to get NUMA affinity for kthread stack, or else give -1.

This is a bit presumptuous.  The caller might wish to later bind this
thread to some or all of the CPUs on the node, rather than to a single
CPU (eg, kswapd()).


So what to do?  Maybe add a new kthread_create_node() which prepares a
kthread whose memory is bound to that node, then add a
kthread_create_cpu() convenience wrapper around that?

>
> ...
>
