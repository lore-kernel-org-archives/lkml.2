Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2HFPRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:17:33 -0400
Received: from verein.lst.de ([213.95.11.211]:34071 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2HFPRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:17:32 -0400
Date: Mon, 6 Aug 2012 17:17:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Asias He <asias@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Shaohua Li <shli@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V5 4/4] virtio-blk: Add REQ_FLUSH and REQ_FUA support
	to bio path
Message-ID: <20120806151731.GA23220@lst.de>
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <1343888757-25723-5-git-send-email-asias@redhat.com> <20120802062742.GA23573@lst.de> <501A2178.3000906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501A2178.3000906@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 02:43:04PM +0800, Asias He wrote:
>> Even if it has a payload waiting is highly suboptimal and it should
>> use a non-blocking sequencing like it is done in the request layer.
>
> So, for REQ_FLUSH, what we need is that send out the VIRTIO_BLK_T_FLUSH and 
> not to wait.

If it's REQ_FLUSH without data a VIRTIO_BLK_T_FLUSH should be sent out only,
if it's a REQ_FLUSH that has data a VIRTIO_BLK_T_FLUSH should be sent out,
but instead of waiting for it to finish the I/O completion handler should
then submit the actual write.

> We still need to wait until the actual write is finished here?
> Like,
>
> REQ_FUA is emulated by:
> 1. Send the actual write
> 2. Wait until the actual write is finished
> 3. Send VIRTIO_BLK_T_FLUSH to device
> 4. Signal the end of the write to upper layer

Remove step 2 and run step 3 from the I/O completion handler.

