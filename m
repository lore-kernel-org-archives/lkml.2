Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1AXVGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:06:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab1AXVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:06:40 -0500
Date: Mon, 24 Jan 2011 13:05:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        menage@google.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v7 1/3] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-Id: <20110124130529.903d9832.akpm@linux-foundation.org>
In-Reply-To: <20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
References: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
	<20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
	<20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010 07:09:51 -0500
Ben Blum <bblum@andrew.cmu.edu> wrote:

> Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch adds an rwsem that lives in a threadgroup's signal_struct that's
> taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
> the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
> ifdefs should be changed to a higher-up flag that CGROUPS and the other system
> would both depend on.
> 
> This is a pre-patch for cgroup-procs-write.patch.
> 
> ...
>
> +/* See the declaration of threadgroup_fork_lock in signal_struct. */
> +#ifdef CONFIG_CGROUPS
> +static inline void threadgroup_fork_read_lock(struct task_struct *tsk)
> +{
> +	down_read(&tsk->signal->threadgroup_fork_lock);
> +}
> +static inline void threadgroup_fork_read_unlock(struct task_struct *tsk)
> +{
> +	up_read(&tsk->signal->threadgroup_fork_lock);
> +}
> +static inline void threadgroup_fork_write_lock(struct task_struct *tsk)
> +{
> +	down_write(&tsk->signal->threadgroup_fork_lock);
> +}
> +static inline void threadgroup_fork_write_unlock(struct task_struct *tsk)
> +{
> +	up_write(&tsk->signal->threadgroup_fork_lock);
> +}
> +#else

Risky. sched.h doesn't include rwsem.h.

We could make it do so, but almost every compilation unit in the kernel
includes sched.h.  It would be nicer to make the kernel build
finer-grained, rather than blunter-grained.  Don't be afraid to add new
header files if that is one way of doing this!


