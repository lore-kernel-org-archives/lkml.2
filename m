Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0H0UYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab0H0UYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:24:31 -0400
Date: Fri, 27 Aug 2010 16:24:04 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/4] dm: implement REQ_FLUSH/FUA support
Message-ID: <20100827202403.GD23680@redhat.com>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
 <1282929060-23663-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282929060-23663-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27 2010 at  1:10pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts dm to support REQ_FLUSH/FUA instead of now
> deprecated REQ_HARDBARRIER.

Thanks for your continued work on this!

> * As __blk_rq_prep_clone() copies REQ_FUA, just advertising FUA
>   support is enough to pass through REQ_FUA to targets.

You're doing blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA); in 2
places:
1) generic dm_init_md_queue -- used for bio-based and request-based
2) request-based specific dm_init_request_based_queue.

Interestingly, we never used the old blk_queue_ordered() method for
bio-based DM yet it is now using blk_queue_flush().

But how can we blindly assume/advertise REQ_FUA?

Should we be taking more care to check each block device that DM
consumes to see if FUA is supported and only then advertise REQ_FUA?
DM already does this for discard support (see:
dm_table_supports_discards).

> Lightly tested linear, stripe, raid1, snap and crypt targets.

I tested the bio-based code with the LVM2 test suite and all tests
passed.

> Please proceed with caution as I'm not familiar with the code base.

As I shared in an earlier (private) mail, I'm unfortunately having
problems with request-based DM (when all patches in this series are
applied).  I'll be working on that more.

BTW, we can eliminate the dm_rq_is_flush_request() wrapper right?  I
think hch mentioned this at some point in one of the various threads.

Mike
