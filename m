Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0H0X15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:27:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:39958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab0H0X1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:27:55 -0400
Message-ID: <4C784A1C.8030602@kernel.org>
Date: Sat, 28 Aug 2010 01:28:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/4] dm: implement REQ_FLUSH/FUA support
References: <1282929060-23663-1-git-send-email-tj@kernel.org> <1282929060-23663-3-git-send-email-tj@kernel.org> <20100827202403.GD23680@redhat.com>
In-Reply-To: <20100827202403.GD23680@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 23:27:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/27/2010 10:24 PM, Mike Snitzer wrote:
>> * As __blk_rq_prep_clone() copies REQ_FUA, just advertising FUA
>>   support is enough to pass through REQ_FUA to targets.
> 
> You're doing blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA); in 2
> places:
> 1) generic dm_init_md_queue -- used for bio-based and request-based
> 2) request-based specific dm_init_request_based_queue.

Well, there are two places creating queues.

> Interestingly, we never used the old blk_queue_ordered() method for
> bio-based DM yet it is now using blk_queue_flush().

Yeap, because now __make_request() filters out REQ_FLUSH bio's.

> But how can we blindly assume/advertise REQ_FUA?
>
> Should we be taking more care to check each block device that DM
> consumes to see if FUA is supported and only then advertise REQ_FUA?
> DM already does this for discard support (see:
> dm_table_supports_discards).

Nope, REQ_FUA will be interpreted by queues lower in the stack.
Drivers in the middle just need to pass them through.

>> Lightly tested linear, stripe, raid1, snap and crypt targets.
> 
> I tested the bio-based code with the LVM2 test suite and all tests
> passed.
> 
>> Please proceed with caution as I'm not familiar with the code base.
> 
> As I shared in an earlier (private) mail, I'm unfortunately having
> problems with request-based DM (when all patches in this series are
> applied).  I'll be working on that more.

Heh... I probably should set up a simple dm-mpath and test it.  I'll
do it this weekend.

> BTW, we can eliminate the dm_rq_is_flush_request() wrapper right?  I
> think hch mentioned this at some point in one of the various threads.

Sure, that's a rather silly wrapper at this point.

Thanks.

-- 
tejun
