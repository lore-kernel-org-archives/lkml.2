Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2KUIb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:31:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KUIb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:31:57 -0500
Date: Wed, 21 Nov 2012 00:31:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Derek Basehore <dbasehore@chromium.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, msb@chromium.orq,
        bleung@chromium.org, taysom@chromium.org
Subject: Re: [PATCH v2 1/2] block: Remove deadlock in disk_clear_events
Message-Id: <20121121003151.0d125ef5.akpm@linux-foundation.org>
In-Reply-To: <1353377222-19541-1-git-send-email-dbasehore@chromium.org>
References: <1353377222-19541-1-git-send-email-dbasehore@chromium.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 18:07:01 -0800 Derek Basehore <dbasehore@chromium.org> wrote:

> In disk_clear_events, do not put work on system_nrt_freezable_wq. Instead, put
> it on system_nrt_wq.
> 
> There is a race between probing a usb and suspending the device. Since probing a
> usb calls disk_clear_events, which puts work on a frozen workqueue, probing
> cannot finish after the workqueue is frozen. However, suspending cannot finish
> until the usb probe is finished, so we get a deadlock.

um,

- this is identical to v1

- ten days ago Jens said "thanks, applied" to v1, but it isn't in linux-next.

- At that time Jens asked you whether a -stable backport was
  warranted but I see no reply on that topic.

> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1571,7 +1571,13 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
>  
>  	/* uncondtionally schedule event check and wait for it to finish */
>  	disk_block_events(disk);
> -	queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
> +	/* We need to put the work on system_nrt_wq here since there is a

Like this:

	/*
	 * We need to ...

> +	 * deadlock that happens while probing a usb device while suspending. If
> +	 * we put work on a freezable worqueue here, a usb probe will wait here

s/worqueue/workqueue/

> +	 * until the workqueue is unfrozen during suspend. Since suspend waits
> +	 * on all probes to complete, we have a deadlock
> +	 */
> +	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
>  	flush_delayed_work(&ev->dwork);
>  	__disk_unblock_events(disk, false);

