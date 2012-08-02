Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2HBG1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:27:45 -0400
Received: from verein.lst.de ([213.95.11.211]:55509 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2HBG1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:27:43 -0400
Date: Thu, 2 Aug 2012 08:27:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>, Shaohua Li <shli@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V5 4/4] virtio-blk: Add REQ_FLUSH and REQ_FUA support
	to bio path
Message-ID: <20120802062742.GA23573@lst.de>
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <1343888757-25723-5-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343888757-25723-5-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 02:25:56PM +0800, Asias He wrote:
> We need to support both REQ_FLUSH and REQ_FUA for bio based path since
> it does not get the sequencing of REQ_FUA into REQ_FLUSH that request
> based drivers can request.
> 
> REQ_FLUSH is emulated by:
> 1. Send VIRTIO_BLK_T_FLUSH to device
> 2. Wait until the flush is finished

There is no need to wait for the flush to finish if the REQ_FLUSH
request has no data payload.

Even if it has a payload waiting is highly suboptimal and it should
use a non-blocking sequencing like it is done in the request layer.

> 
> REQ_FUA is emulated by:
> 1. Send the actual write
> 2. Wait until the actual write is finished
> 3. Send VIRTIO_BLK_T_FLUSH to device
> 4. Wait until the flush is finished
> 5. Signal the end of the write to upper layer

The same comment about not blocking applies here as well.

