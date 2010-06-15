Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0FORwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:52:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:49934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0FORwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:52:00 -0400
Message-ID: <4C17BD94.6080601@kernel.org>
Date: Tue, 15 Jun 2010 19:51:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 06/12] irq: implement irq_schedule_poll()
References: <1276443098-20653-1-git-send-email-tj@kernel.org>	<1276443098-20653-7-git-send-email-tj@kernel.org> <20100615114058.32e58afd@bike.lwn.net>
In-Reply-To: <20100615114058.32e58afd@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 17:51:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 07:40 PM, Jonathan Corbet wrote:
> On Sun, 13 Jun 2010 17:31:32 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Implement and use irq_schedule_poll() to schedule desc->poll_timer
>> instead of calling mod_timer directly.  irq_schedule_poll() is called
>> with desc->lock held and schedules the timer iff necessary - ie. if
>> the timer is offline or scheduled to expire later than requested.
>> This will be used to share desc->poll_timer.
> 
> One quick question...
> 
>> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
>> index 0bce0e3..0b8fd0a 100644
>> --- a/kernel/irq/spurious.c
>> +++ b/kernel/irq/spurious.c
>> @@ -23,6 +23,8 @@ enum {
>>  
>>  	/* IRQ polling common parameters */
>>  	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
>> +
>> +	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
>>  };
> 
> Why would IRQ_POLL_SLACK be anything other than zero for HZ < 1000?
> It seems like you'd get no slack at all on most systems.  Am I missing
> something?

Jiri questioned the same thing.  I'll bump it to HZ / 250 so that it
at least has one tick slack on 250HZ configuration which is pretty
common these days.

Thanks.

-- 
tejun
