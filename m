Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab0D3Syo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:54:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758531Ab0D3RI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:29 -0400
Date: Thu, 29 Apr 2010 16:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] padata: Flush the padata queues actively
Message-Id: <20100429161112.f4bb67a3.akpm@linux-foundation.org>
In-Reply-To: <20100429124426.GK5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
	<20100429124426.GK5275@secunet.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 14:44:26 +0200
Steffen Klassert <steffen.klassert@secunet.com> wrote:

> +static void padata_flush_queues(struct parallel_data *pd)
> +{
> +	int cpu;
> +	struct padata_queue *queue;
> +
> +	for_each_cpu(cpu, pd->cpumask) {
> +		queue = per_cpu_ptr(pd->queue, cpu);
> +		flush_work(&queue->pwork);
> +	}
> +
> +	del_timer_sync(&pd->timer);
> +
> +	if (atomic_read(&pd->reorder_objects))
> +		padata_reorder(pd);

padata_reorder() can fail to do anything, if someone else is holding
pd->lock.  What happens then?


> +	for_each_cpu(cpu, pd->cpumask) {
> +		queue = per_cpu_ptr(pd->queue, cpu);
> +		flush_work(&queue->swork);
> +	}
> +	BUG_ON(atomic_read(&pd->refcnt) != 0);
> +}

Are we safe against cpu hot-unplug in this code?
