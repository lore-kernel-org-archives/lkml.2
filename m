Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1JQM1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:27:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:30282 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1JQM1K convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Mon, 17 Oct 2011 08:27:10 -0400
Message-Id: <4E9C3B39020000780005BA5D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 17 Oct 2011 13:27:05 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <hch@infradead.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka
	 old-style BARRIER requests.
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> We emulate the barrier requests by draining the outstanding bio's
> and then sending the WRITE_FLUSH command. To drain the I/Os
> we use the refcnt that is used during disconnect to wait for all
> the I/Os before disconnecting from the frontend. We latch on its
> value and if it reaches either the threshold for disconnect or when
> there are no more outstanding I/Os, then we have drained all I/Os.
> 
> Suggested-by: Christopher Hellwig <hch@infradead.org>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |   37 +++++++++++++++++++++++++++++++++-
>  drivers/block/xen-blkback/common.h  |    5 ++++
>  drivers/block/xen-blkback/xenbus.c  |   18 +++++++++++++++++
>  3 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c 
> b/drivers/block/xen-blkback/blkback.c
> index e0dab61..184b133 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -452,6 +452,23 @@ static void xen_blk_discard(struct xen_blkif *blkif, 
> struct blkif_request *req)
>  	make_response(blkif, req->id, req->operation, status);
>  }
>  
> +static void xen_blk_drain_io(struct xen_blkif *blkif)
> +{
> +	atomic_set(&blkif->drain, 1);
> +	do {
> +		wait_for_completion_interruptible_timeout(
> +				&blkif->drain_complete, HZ);
> +
> +		if (!atomic_read(&blkif->drain))
> +			break;
> +		/* The initial value is one, and one refcnt taken at the
> +		 * start of the xen_blkif_schedule thread. */
> +		if (atomic_read(&blkif->refcnt) <= 2)
> +			break;

Shouldn't this test be done the very first thing in the loop? It looks
racy the way it's placed now, and it would incur a 1 sec stall if this
was the only request currently being processed (as no completion
of ane earlier request could signal completion).

Jan

> +	} while (!kthread_should_stop());
> +	atomic_set(&blkif->drain, 0);
> +}


