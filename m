Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0ICJde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:33:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:43588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0ICJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:33:32 -0400
Message-ID: <4C80C0D6.4030405@kernel.org>
Date: Fri, 03 Sep 2010 11:33:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk
 as the original
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FE251.2020003@kernel.org> <4C808BF8.7060402@ct.jp.nec.com>
In-Reply-To: <4C808BF8.7060402@ct.jp.nec.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 09:33:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/03/2010 07:47 AM, Kiyoshi Ueda wrote:
> Ah, I see, thank you for the quick fix!
> I confirmed no panic occurs with this patch.
> 
> Tested-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Great, thanks for testing.

> By the way, I had been considering a block-layer interface which remaps
> struct request and its bios to a block device such as:
> void blk_remap_request(struct request *rq, struct block_device *bdev)
> {
> 	rq->rq_disk = bdev->bd_disk;
> 
> 	__rq_for_each_bio(bio, rq) {
> 		bio->bi_bdev = bdev->bd_disk;
> 	}
> }
> 
> If there is such an interface and remapping drivers use it, then these
> kind of issues may be avoided in the future.

I think the problem is more with request initialization.  After all,
once bios are packed into a request, they are (or at least should be)
just data containers.  We now have multiple request init paths in
block layer and different ones initialize different subsets and it's
not very clear which fields are supposed to be initialized to what by
whom.

But yeah I agree removing discrepancy between request and bio would be
nice to have too.  It's not really remapping tho.  Maybe just
blk_set_rq_q() or something like that (it should also set rq->q)?

Thanks.

-- 
tejun
