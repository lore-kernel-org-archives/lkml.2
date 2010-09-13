Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0IMIIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:08:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab0IMIIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:08:36 -0400
Message-ID: <4C8DDBEC.3010900@kernel.org>
Date: Mon, 13 Sep 2010 10:08:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Florian Mickler <florian@mickler.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
References: <4C87AE52.70401@kernel.org> <4C87B101.2080608@kernel.org> <20100909100229.250900f0@schatten.dmk.lab> <4C88B55E.90203@kernel.org> <20100909205056.1ac7989a@schatten.dmk.lab> <4C8A07B3.1050603@kernel.org> <20100910162658.254b224a@schatten.dmk.lab> <4C8A46D9.5020303@kernel.org> <20100913005151.GB411@dastard>
In-Reply-To: <20100913005151.GB411@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 08:08:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/13/2010 02:51 AM, Dave Chinner wrote:
> We talked about this for XFS w.r.t. the xfslogd IO completion
> work items to be promoted ahead of data IO completion items and
> that has worked fine. This appears to gives us only two
> levels of priority, or from an user point of view, two levels of
> dependency between workqueue item execution.

It's not priority per-se.  It's basically a bypass switch for
workqueue work deferring mechanism.

> Thinking about the XFS situation more, we actually have three levels
> of dependency: xfslogd -> xfsdatad -> xfsconvertd. That is, we defer
> long running, blocking items from xfsdatad to xfsconvertd so we
> don't block the xfsdatad from continuing to process data IO
> completion items. How do we guarantee that the xfsconvertd work
> items won't prevent/excessively delay processing of xfsdatad items?

What do you mean by "long running"?  Do you mean it would consume a
lot of CPU cycles or it would block for locks and IOs a lot?  It's the
latter, right?  There isn't much to worry about.

>> +@max_active determines the maximum number of execution contexts per
>> +CPU which can be assigned to the work items of a wq.  For example,
>> +with @max_active of 16, at most 16 work items of the wq can be
>> +executing at the same time per CPU.
> 
> I think the reason you were seeing XFS blow this out of the water is
> that every IO completion for a write beyond EOF (i.e. every single
> one for an extending streaming write) will require inode locking to
> update file size. If the inode is locked, then the item will
> delay(1), and the cmwq controller will run the next item in a new
> worker. That will then block in delay(1) 'cause it can't get the
> inode lock, as so on....
> 
> As such, I can't see that increasing the max_active count for XFS is
> a good thing - all it will do is cause larger blockages to occur....

>From the description above, it looks like xfs developed its own way of
regulating work processing involving multiple workqueues and yielding
queue positions with delay.  For now, it probably would be best to
just keep things running as they are but in the long run it might be
beneficial to replace those explicit mechanisms.

>> +6. Guidelines
>> +
>> +* Do not forget to use WQ_RESCUER if a wq may process work items which
>> +  are used during memory reclaim.  Each wq with WQ_RESCUER set has one
>> +  rescuer thread reserved for it.  If there is dependency among
>> +  multiple work items used during memory reclaim, they should be
>> +  queued to separate wq each with WQ_RESCUER.
>> +
>> +* Unless strict ordering is required, there is no need to use ST wq.
>> +
>> +* Unless there is a specific need, using 0 for @nr_active is
>                                                   max_active?

Oops, thanks.  Updated.

-- 
tejun
