Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0LRAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:14:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105Ab0LRAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:13:58 -0500
Date: Fri, 17 Dec 2010 16:13:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 07/16] pps: move idr stuff to pps.c
Message-Id: <20101217161328.457ac8e6.akpm@linux-foundation.org>
In-Reply-To: <8f66dc7613bb4a7d34e6d76465df3bf6bb2f66a8.1292604060.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<8f66dc7613bb4a7d34e6d76465df3bf6bb2f66a8.1292604060.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 22:54:31 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> Since now idr is only used to manage char device id's and not used in
> kernel API anymore it should be moved to pps.c. This also makes it
> possible to release id only at actual device freeing so nobody can
> register a pps device with the same id while our device is not freed
> yet.
> 
> ...
>
>  int pps_register_cdev(struct pps_device *pps)
>  {
>  	int err;
>  	dev_t devt;
>  
> +	/* Get new ID for the new PPS source */
> +	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
> +		return -ENOMEM;
> +
> +	/* Now really allocate the PPS source.
> +	 * After idr_get_new() calling the new source will be freely available
> +	 * into the kernel.
> +	 */
> +	spin_lock_irq(&pps_idr_lock);
> +	err = idr_get_new(&pps_idr, pps, &pps->id);
> +	spin_unlock_irq(&pps_idr_lock);
> +
> +	if (err < 0)
> +		return err;

The IDR interface really sucks :(

What this code should be doing is

retry:
	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
		return -ENOMEM;
	spin_lock_irq(&pps_idr_lock);
	err = idr_get_new(&pps_idr, pps, &pps->id);
	spin_unlock_irq(&pps_idr_lock);
	if (err < 0) {
		if (err == -EAGAIN)
			goto retry;
		return err;
	}

this way it correctly handles the case where the idr_pre_get()
succeeded in precharging the pool, but some other task cam in and stole
your reservation.


