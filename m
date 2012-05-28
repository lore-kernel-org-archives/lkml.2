Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2E1COW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 22:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2E1COU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 22:14:20 -0400
Message-ID: <4FC2DFB6.6080701@redhat.com>
Date: Mon, 28 May 2012 10:15:18 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix lock unbalance caused by lock disconnect
References: <1337911859-22913-1-git-send-email-asias@redhat.com> <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 08:07 AM, Tejun Heo wrote:
> On Fri, May 25, 2012 at 10:10:59AM +0800, Asias He wrote:
>> Commit 777eb1bf15b8532c396821774bf6451e563438f5 disconnects externally
>> supplied queue_lock before blk_drain_queue(). This would introduce lock
>> unbalance because theads which have taken the external lock might unlock
>> the internal lock in the during the queue drain.
>>
>> This patch fixes this by disconnecting the lock after the queue drain.
>
> I don't think the patch description is correct.  The lock switcihng is
> inherently broken and the patch doesn't really fix the problem
> although it *might* make the problem less likely.  Trying to switch
> locks while there are other accessors of the lock is simply broken, it
> can never work without outer synchronization.

Since the lock switching is broken, is it a good idea to force all the 
drivers to use the block layer provided lock? i.e. Change the API from
blk_init_queue(rfn, driver_lock) to blk_init_queue(rfn). Any reason not 
to use the block layer provided one.

> Your patch might make
> the problem somewhat less likely simply because queue draining makes a
> lot of request_queue users go away.

Who will use the request_queue after blk_cleanup_queue()?

> So, can you please update the commit description?  It doesn't really
> *fix* anything but I think we're still better off with the change.

Sure. Will send v2.

-- 
Asias
