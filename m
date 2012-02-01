Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab2BACSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:18:39 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48389 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2BACSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:18:38 -0500
X-AuditID: 9c93016f-b7c20ae000005067-9e-4f28a0fbc497
Message-ID: <4F28A0F9.9070603@gmail.com>
Date: Wed, 01 Feb 2012 11:18:33 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.device-mapper.devel
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <4F263B01.4050103@gmail.com> <20120130170548.GA3355@google.com> <4F278A78.8080300@gmail.com> <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
In-Reply-To: <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-31 7:39 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jan 30, 2012 at 10:30 PM, Namhyung Kim<namhyung@gmail.com>  wrote:
>> Right, but the point is it could make a NULL pointer dereference during
>> evaluation of the argument of the TP AFAICS. I'm not sure about the TP
>> implementation though, I think I was wrong - T_E_C() cannot protect us from
>> it because it happens just before jumping to the TP, right?
>>
>> So I think we need a conditional jump (with the "likely" annotation) for
>> this even when the TP is disabled.
>
> Hmmm... still not following. Where the said NULL dereference happen?
> TEC conditional is equivalent to "if (COND) TP;".  If you don't use
> TEC, it'll be "if (COND) if (TP enabled) TP;".  With TEC, it will be
> "if (TP enabled) if (COND) TP;".  There's no other difference.
>
> Thanks.
>

I've made a quick investigation on TP implementation, and finally 
figured out what I was wrong - I thought the COND would be checkd in a 
probe, but it's not. Thanks for pointing it out.

However, for some reason, it seems gcc generated code that evaluates the 
arguments - bdev_get_queue() in this case - before checking the COND. 
Simple test module below caused a NULL pointer dereference when I used 
TRACE_EVENT_CONDITION(), but not for conditional jump:

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/bio.h>

static int __init init_mod(void)
{
         struct bio *bio = bio_alloc(GFP_KERNEL, 0);
         bio_endio(bio, 0);
         bio_put(bio);
         return 0;
}

static void __exit exit_mod(void)
{
}

module_init(init_mod);
module_exit(exit_mod);


Thanks,
Namhyung
