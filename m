Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1ISJfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:35:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37300 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1ISJfj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Mon, 19 Sep 2011 05:35:39 -0400
Message-Id: <4E7729040200007800056A2F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 19 Sep 2011 10:35:32 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <axboe@kernel.dk>, <stable@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 3/3] xen-blkfront: If no barrier or
	 flush is supported, use invalid operation.
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
 <1315593060-20031-3-git-send-email-konrad.wilk@oracle.com>
 <4E6DD8750200007800055ADA@nat28.tlf.novell.com>
 <20110916191514.GA31818@phenom.oracle.com>
In-Reply-To: <20110916191514.GA31818@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.09.11 at 21:15, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Sep 12, 2011 at 09:01:25AM +0100, Jan Beulich wrote:
>> >>> On 09.09.11 at 20:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > By default we would set the info->flush_op=0, and zero maps
>> > to BLKIF_OP_READ request code. So if the backend did not support
>> > either barrier ('feature-barrier') or flush ('feature-flush-cache')
>> > we would end up using that opcode for the flush/barrier request, meaning
>> > we actually do a READ request. Fortunatly for us, __generic_make_request
>> > checks q->flush_flags and realizes that we don't do FLUSH and removes
>> > the REQ_FLUSH | REQ_FUA so we never end up issuing a READ request
>> > for a flush request. However, other third party implementations of
>> > __make_request might not be so smart, so lets fix this up.
>> 
>> Wouldn't it be better to simply have blkif_queue_request() fail in that
>> case (and then it doesn't matter whether flush_op is set to 0 or -1)?
>> Not the least because older (forward-port) backends stall the incoming
>> queue and are possibly verbose for invalid requests seen.
> 
> So like this:

Yes, this looks small and neat.

Acked-by: Jan Beulich <jbeulich@suse.com>

> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 468bfec..e9d301c 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -380,7 +380,9 @@ static void do_blkif_request(struct request_queue *rq)
>  
>  		blk_start_request(req);
>  
> -		if (req->cmd_type != REQ_TYPE_FS) {
> +		if ((req->cmd_type != REQ_TYPE_FS) ||
> +		    ((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> +		    !info->flush_op)) {
>  			__blk_end_request_all(req, -EIO);
>  			continue;
>  		}



