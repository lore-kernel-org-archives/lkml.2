Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2DDF6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 01:58:43 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:64493 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2DDF6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 01:58:42 -0400
Message-ID: <4F7BE30B.9020603@permonline.ru>
Date: Wed, 04 Apr 2012 11:58:35 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Ethernet drivers for WIZnet chips
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333450726-24455-1-git-send-email-msink@permonline.ru> <1333453170.18626.65.camel@edumazet-glaptop> <4F7AE9D3.80204@permonline.ru> <1333456156.18626.93.camel@edumazet-glaptop>
In-Reply-To: <1333456156.18626.93.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.04.2012 18:29, Eric Dumazet написал:
> On Tue, 2012-04-03 at 18:15 +0600, Mike Sinkovsky wrote:
>> 03.04.2012 17:39, Eric Dumazet написал:
>>> On Tue, 2012-04-03 at 16:58 +0600, Mike Sinkovsky wrote:
>>>> Based on original driver from chip manufacturer, but nearly full rewite.
>>>> Tested and used in production with Blackfin BF531 embedded processor.
>>>>
>>>> Signed-off-by: Mike Sinkovsky<msink@permonline.ru>
>>>> ---
>>>> v6:
>>>>    - remove (S0_TX_FSR<   skb->len) check in TX handler, it doesn't work
>>>>      anyway. Chip can transmit only one frame with MTU 1500 at a time,
>>>>      and tx buffer size is bigger.
>>>
>>> So what happens if XXX frames are given to start_xmit() in a flood ?
>>>
>>> You removed any flow control, how can this work ?
>>>
>>> Device has an infinite queue ?
>>
>> As I understand from datasheet, device doesn't have tx queue at all.
>> It have tx buffer, processor must save transmitted frame to it, and then
>> save SEND command to command register. When transmission completed,
>> SENDOK bit in interrupt register will be set to '1', and interrupt
>> handler will be called.
>>
>> So, according to datasheet, driver must stop queue in start_xmit()
>> routine, and wake in interrupt handler of SENDOK bit.
>> I tried this, and it basically works, but SOMETIMES, very rare, I see
>> tx_timeout().
>>
>> And without any flow control - driver works perfectly.
>> Weird, don't know why.
>
> Really this should be fixed, since your driver makes qdisc flow control
> impossible (unless adding a rate limiter like HTB/CBQ)
>
> You probably had a race on your xmit routine, and interrupt routine.
>
> You need proper synchronization : A spinlock to make this easy, or a
> smart barrier game.

I can at least make it configurable from Kconfig with default 'y', and 
disable for our boards.
Would it be acceptable?

About races - I can't see any, in this very simple procedure.
But maybe I missed something..


-- 
Mike

