Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2AaGaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:30:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60154 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2AaGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:30:21 -0500
X-AuditID: 9c930197-b7ba2ae000000eab-d2-4f278a7a0023
Message-ID: <4F278A78.8080300@gmail.com>
Date: Tue, 31 Jan 2012 15:30:16 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.device-mapper.devel
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <4F263B01.4050103@gmail.com> <20120130170548.GA3355@google.com>
In-Reply-To: <20120130170548.GA3355@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-31 2:05 AM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 03:38:57PM +0900, Namhyung Kim wrote:
>> 2012-01-29 6:41 PM, Namhyung Kim wrote:
>>> The block_bio_complete() TP has been missed so long, so that bio-based
>>> drivers haven't been able to trace its IO behavior. Add it.
>>>
>>> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
>>> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
>>>
>>
>> Now I see that it seems TRACE_EVENT_CONDITION() can protect event
>> tracing from such condition, but what about other users of the TP
>> like blktrace? I think it'll still get NULL pointer dereference on
>> bdev_get_queue() after the change, right? If so, convert to T_E_C()
>> looks meaningless IMHO. Do I miss something?
>
> Not really following, but the whole point of using
> TRACE_EVENT_CONDITION() is avoiding the conditional jump when the TP
> is disabled.  Whether the TP users need to test again / more isn't too
> important.
>
> Thanks.
>

Right, but the point is it could make a NULL pointer dereference during 
evaluation of the argument of the TP AFAICS. I'm not sure about the TP 
implementation though, I think I was wrong - T_E_C() cannot protect us 
from it because it happens just before jumping to the TP, right?

So I think we need a conditional jump (with the "likely" annotation) for 
this even when the TP is disabled.

Thanks,
Namhyung
