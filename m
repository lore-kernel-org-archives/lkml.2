Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0IANvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:51:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:40050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab0IANvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:51:13 -0400
Message-ID: <4C7E5A38.9050001@kernel.org>
Date: Wed, 01 Sep 2010 15:50:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/5] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-3-git-send-email-tj@kernel.org> <20100901134343.GA25260@redhat.com>
In-Reply-To: <20100901134343.GA25260@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Sep 2010 13:50:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/01/2010 03:43 PM, Mike Snitzer wrote:
> On Mon, Aug 30 2010 at  5:58am -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
>> This patch converts bio-based dm to support REQ_FLUSH/FUA instead of
>> now deprecated REQ_HARDBARRIER.
>>
>> * -EOPNOTSUPP handling logic dropped.
> 
> Can you expand on _why_ -EOPNOTSUPP handling is no longer needed?  And
> please at it to the final patch header.

It just doesn't happen anymore.  If the underlying device doesn't
support FLUSH/FUA, the block layer simply make those parts noop.  IOW,
it no longer distinguishes between writeback cache which doesn't
support cache flush at all and writethrough cache.  Devices which have
WB cache w/o flush very difficult to come by these days and there's
nothing much we can do anyway, so it doesn't make sense to require
everyone to implement -EOPNOTSUPP.

One scheduled feature is to implement falling back to REQ_FLUSH when
the device advertises REQ_FUA but fails to process it, but one way or
the other, the goal is encapsulating REQ_FLUSH/FUA support in block
layer proper.  If FLUSH/FUA can be retried using a different strategy,
it should be done inside request_queue proper instead of pushing retry
logic to all its users.

Thanks.

-- 
tejun
