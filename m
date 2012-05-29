Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2E2BVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:21:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59226 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2E2BVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:21:23 -0400
Date: Tue, 29 May 2012 10:21:15 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: Avoid missed wakeup in request waitqueue
Message-ID: <20120529012115.GE20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
 <1338254100-13336-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338254100-13336-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 09:15:00AM +0800, Asias He wrote:
> After hot-unplug a stressed disk, I found that rl->wait[] is not empty
> while rl->count[] is empty and there are theads still sleeping on
> get_request after the queue cleanup. With simple debug code, I found
> there are exactly nr_sleep - nr_wakeup of theads in D state. So there
> are missed wakeup.
> 
>   $ dmesg | grep nr_sleep
>   [   52.917115] ---> nr_sleep=1046, nr_wakeup=873, delta=173
>   $ vmstat 1
>   1 173  0 712640  24292  96172 0 0  0  0  419  757  0  0  0 100  0
> 
> To quote Tejun:
> 
>   Ah, okay, freed_request() wakes up single waiter with the assumption
>   that after the wakeup there will at least be one successful allocation
>   which in turn will continue the wakeup chain until the wait list is
>   empty - ie. waiter wakeup is dependent on successful request
>   allocation happening after each wakeup.  With queue marked dead, any
>   woken up waiter fails the allocation path, so the wakeup chaining is
>   lost and we're left with hung waiters. What we need is wake_up_all()
>   after drain completion.
> 
> This patch fixes the missed wakeup by waking up all the theads which
> are sleeping on wait queue after queue drain.
> 
> Changes in v2: Drop waitqueue_active() optimization
> 
> Signed-off-by: Asias He <asias@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Jens, this one wants Cc: stable.

Thanks.

-- 
tejun
