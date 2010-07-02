Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0GBKsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:48:24 -0400
Received: from verein.lst.de ([213.95.11.210]:59466 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0GBKsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:48:22 -0400
Date: Fri, 2 Jul 2010 12:48:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: add sd_unprep_fn to free discard page
Message-ID: <20100702104801.GA26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sd_unprep() uses rq->buffer to free discard page allocated in
> sd_prepare_discard().

Eeek.  Accessing it using the bio in both haves seems a lot cleaner than
abusing this.  Especially as we don't really need a mapped page anyway
at least for WRITE SAME implementation.

> -	return scsi_setup_blk_pc_cmnd(sdp, rq);
> +	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> +	rq->buffer = page_address(page);
> +	return ret;

In addition I don't think this is quite correct.  You still need to undo
the payload addition manually if scsi_setup_blk_pc_cmnd fails, as we
haven't marked the request as REQ_DONTPREP at that point - it's only
done by scsi_prep_return for the BLKPREP_OK case.

