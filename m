Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab0DMRPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:15:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:54992 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0DMRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:15:29 -0400
Message-ID: <4BC4A6B2.1090906@colorfullife.com>
Date: Tue, 13 Apr 2010 19:15:30 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
In-Reply-To: <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,


On 04/12/2010 08:49 PM, Chris Mason wrote:
>   /*
> + * when a semaphore is modified, we want to retry the series of operations
> + * for anyone that was blocking on that semaphore.  This breaks down into
> + * a few different common operations:
> + *
> + * 1) One modification releases one or more waiters for zero.
> + * 2) Many waiters are trying to get a single lock, only one will get it.
> + * 3) Many modifications to the count will succeed.
> + *
>    
Have you thought about odd corner cases:
Nick noticed the last time that it is possible to wait for arbitrary values:
in one semop:
     - decrease semaphore 5 by 10
     - wait until semaphore 5 is 0
     - increase semaphore 5 by 10.

>   SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>   		unsigned, nsops, const struct timespec __user *, timeout)
>   {
> @@ -1129,6 +1306,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>   	struct sem_queue queue;
>   	unsigned long jiffies_left = 0;
>   	struct ipc_namespace *ns;
> +	struct sem *blocker = NULL;
> +	LIST_HEAD(pending);
>
>   	ns = current->nsproxy->ipc_ns;
>
> @@ -1168,6 +1347,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>   			alter = 1;
>   	}
>
> +	/*
> +	 * try_atomic_semop takes all the locks of all the semaphores in
> +	 * the sops array.  We have to make sure we don't deadlock if userland
> +	 * happens to send them out of order, so we sort them by semnum.
> +	 */
> +	if (nsops>  1)
> +		sort(sops, nsops, sizeof(*sops), sembuf_compare, NULL);
> +
>    
Does sorting preserve the behavior?
