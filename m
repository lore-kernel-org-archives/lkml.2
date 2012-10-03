Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2JCW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:29:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2JCW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:29:55 -0400
Date: Wed, 3 Oct 2012 15:29:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 3/5] rapidio: run discovery as an asynchronous process
Message-Id: <20121003152953.79aecece.akpm@linux-foundation.org>
In-Reply-To: <1349291923-22860-4-git-send-email-alexandre.bounine@idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
	<1349291923-22860-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Oct 2012 15:18:41 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Modify mport initialization routine to run the RapidIO discovery process
> asynchronously. This allows to have an arbitrary order of enumerating and
> discovering ports in systems with multiple RapidIO controllers without
> creating a deadlock situation if enumerator port is registered after a
> discovering one.
> 
> Making netID matching to mportID ensures consistent net ID assignment in
> multiport RapidIO systems with asynchronous discovery process (global counter
> implementation is affected by race between threads).
> 
>
> ...
>
> +static void __devinit disc_work_handler(struct work_struct *_work)
> +{
> +	struct rio_disc_work *work = container_of(_work,
> +						  struct rio_disc_work, work);

There's a nice simple way to avoid such ugliness:

--- a/drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-process-fix
+++ a/drivers/rapidio/rio.c
@@ -1269,9 +1269,9 @@ struct rio_disc_work {
 
 static void __devinit disc_work_handler(struct work_struct *_work)
 {
-	struct rio_disc_work *work = container_of(_work,
-						  struct rio_disc_work, work);
+	struct rio_disc_work *work;
 
+	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
 	rio_disc_mport(work->mport);
_

> +	pr_debug("RIO: discovery work for mport %d %s\n",
> +		 work->mport->id, work->mport->name);
> +	rio_disc_mport(work->mport);
> +
> +	kfree(work);
> +}
> +
>  int __devinit rio_init_mports(void)
>  {
>  	struct rio_mport *port;
> +	struct rio_disc_work *work;
> +	int no_disc = 0;
>  
>  	list_for_each_entry(port, &rio_mports, node) {
>  		if (port->host_deviceid >= 0)
>  			rio_enum_mport(port);
> -		else
> -			rio_disc_mport(port);
> +		else if (!no_disc) {
> +			if (!rio_wq) {
> +				rio_wq = alloc_workqueue("riodisc", 0, 0);
> +				if (!rio_wq) {
> +					pr_err("RIO: unable allocate rio_wq\n");
> +					no_disc = 1;
> +					continue;
> +				}
> +			}
> +
> +			work = kzalloc(sizeof *work, GFP_KERNEL);
> +			if (!work) {
> +				pr_err("RIO: no memory for work struct\n");
> +				no_disc = 1;
> +				continue;
> +			}
> +
> +			work->mport = port;
> +			INIT_WORK(&work->work, disc_work_handler);
> +			queue_work(rio_wq, &work->work);
> +		}
> +	}

I'm having a lot of trouble with `no_disc'.  afacit what it does is to
cease running async discovery for any remaining devices if the workqueue
allocation failed (vaguely reasonable) or if the allocation of a single
work item failed (incomprehensible).

But if we don't run discovery, the subsystem is permanently busted for
at least some devices, isn't it?

And this code is basically untestable unless the programmer does
deliberate fault injection, which makes it pretty much unmaintainable.

So...  if I haven't totally misunderstood, I suggest a rethink is in
order?

> +	if (rio_wq) {
> +		pr_debug("RIO: flush discovery workqueue\n");
> +		flush_workqueue(rio_wq);
> +		pr_debug("RIO: flush discovery workqueue finished\n");
> +		destroy_workqueue(rio_wq);
>  	}
