Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1I1All (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:41:41 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52619
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1I1Alk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:41:40 -0400
Message-ID: <4E826D3B.7080805@kernel.dk>
Date: Tue, 27 Sep 2011 18:41:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 3.1-rc
References: <4E79D65A.6070406@kernel.dk> <CA+55aFxWHBEBaWfWcdOHucAiMHnTH+y1WRq6gik+=NGA1FNh=Q@mail.gmail.com>
In-Reply-To: <CA+55aFxWHBEBaWfWcdOHucAiMHnTH+y1WRq6gik+=NGA1FNh=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-27 17:52, Linus Torvalds wrote:
> On Wed, Sep 21, 2011 at 5:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Final round of patches for 3.1.
> 
> Apparently better not.
> 
> The "block layer oopses on USB device removal" is still there, it seems.
> 
> I can even find a patch from it from Alan Stern:
> 
>    https://lkml.org/lkml/2011/9/18/63
> 
> and the reason I found that was that my wife's machine just saw what
> looks very much like that bug in elv_put_request().
> 
> The call chain on that particular machine was:
> 
>  - __blk_put_request
>   blk_put_request
>   scsi_execute
>   scsi_execute_req
>   sd_check_events
>   disk_events_workfn
>   process_one_work
> 
> in one of the kthread helpers. It sounds like something either
> generates disk events after the unplug event (despite a "safely
> remove" thing), or doesn't properly wait for the disk events to have
> flushed before the elevator is cleared.
> 
> The "things go oops at USB removal" reports have been with us for a
> *loong* time now. Can we please get this fixed already, and have
> somebody really look at it?
> 
> And if you can't figure out why it happens, at least apply Alan's
> patch (or ack it).

The whole thing is a bit of a mess, it was introduced by changes meant
to clean it up, which didn't get to the root of the problem (and
seemingly only made it worse). We need the queue clearly referenced and
released, not just pointed to. That would be the more invasive and real
fix. I will apply Alan's fix for a happier 3.1.

-- 
Jens Axboe

