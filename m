Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab1DVXcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:32:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58587 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1DVXcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T8FQHrr9DWf5eFWSG5ouPsprHeR6ttgAL/hwqZg/1zDWKeGXRBaATFe9UcR1b7eCb9
         /AH3zidPcrq/BEwp5DspXMnDxef5SQQlzpuuXSVBB1A+Pj/oyrFDY+ztt2zGqGJKsv/e
         w08V67rcBUQjR91iIZo7z6yePeHqBGKzfqczU=
Date: Sat, 23 Apr 2011 01:32:04 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110422233204.GB1576@mtj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303202686.3981.216.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

> +	list_splice_init(&q->flush_queue[q->flush_running_idx], &proceed_list);
> +	/*
> +	 * If queue doesn't support queueable flush request, we can push the
> +	 * pending requests to the next stage too. For such queue, there are no
> +	 * normal requests running when flush request is running, so this still
> +	 * guarantees the correctness.
> +	 */
> +	if (!blk_queue_flush_queueable(q))
> +		list_splice_tail_init(&q->flush_queue[q->flush_pending_idx],
> +			&proceed_list);

I can't see how this is safe.  Request completion is decoupled from
issue.  What prevents low level driver from take in other requests
before control hits here?  And even if that holds for the current
implementation, that's hardly something which can be guaranteed from
!flush_queueable.  Am I missing something?

This kind of micro optimization is gonna bring very painful bugs which
are extremely difficult to reproduce and track down.  It scares the
hell out of me.  It's gonna silently skip flushes where it shouldn't.

If you wanna optimize this case, a much better way would be
implementing back-to-back flush optimization properly such that when
block layer detects two flushes back-to-back and _KNOWS_ that no
request has been issued inbetween, the second one is handled as noop.
Mark the queue clean on flush, dirty on any other request and if the
queue is clean all flushes can be completed immediately on issue which
would also allow us to avoid the whole queue at the front or back
issue without bothering low level drivers at all.

Thanks.

-- 
tejun
