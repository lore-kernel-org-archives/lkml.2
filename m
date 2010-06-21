Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0FUUfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:35:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46759 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab0FUUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:35:52 -0400
Date: Mon, 21 Jun 2010 13:33:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       mst@redhat.com, samudrala.sridhar@gmail.com
Subject: Re: [PATCH] kthread: implement kthread_worker
Message-Id: <20100621133321.6215b85b.randy.dunlap@oracle.com>
In-Reply-To: <4C1CE813.8080701@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
	<20100617161619.d3ebd73d.akpm@linux-foundation.org>
	<4C1B1D3F.8030509@kernel.org>
	<20100618003127.10d9e6c8.akpm@linux-foundation.org>
	<4C1B29BF.7080404@kernel.org>
	<20100618100228.093ec17b.akpm@linux-foundation.org>
	<4C1BACC6.5020602@kernel.org>
	<4C1CE813.8080701@kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C1FCC9D.00E3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 17:53:55 +0200 Tejun Heo wrote:

>  include/linux/kthread.h |   63 +++++++++++++++++++++++++
>  kernel/kthread.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
> 
> Index: work/kernel/kthread.c
> ===================================================================
> --- work.orig/kernel/kthread.c
> +++ work/kernel/kthread.c

> @@ -247,3 +249,119 @@ int kthreadd(void *unused)
> 
>  	return 0;
>  }
> +
> +/**
> + * kthread_worker_fn - kthread function to process kthread_worker
> + * @data: pointer to initialized kthread_worker

s/data/worker_ptr/

> + *
> + * This function can be used as @threadfn to kthread_create() or
> + * kthread_run() with @data argument pointing to an initialized

ditto.

> + * kthread_worker.  The started kthread will process work_list until
> + * the it is stopped with kthread_stop().  A kthread can also call
> + * this function directly after extra initialization.
> + *
> + * Different kthreads can be used for the same kthread_worker as long
> + * as there's only one kthread attached to it at any given time.  A
> + * kthread_worker without an attached kthread simply collects queued
> + * kthread_works.
> + */
> +int kthread_worker_fn(void *worker_ptr)
> +{
> +	struct kthread_worker *worker = worker_ptr;
> +	struct kthread_work *work;
> +
> +	WARN_ON(worker->task);
> +	worker->task = current;
> +repeat:


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
