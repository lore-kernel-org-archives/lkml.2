Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1IZPPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:15:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1IZPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:15:47 -0400
Message-ID: <4E8098B2.8000705@colorfullife.com>
Date: Mon, 26 Sep 2011 17:22:26 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 3/3] [RFC] ipc/sem.c: replace busy loop with completion
References: <1316885838-12026-1-git-send-email-manfred@colorfullife.com> <1317024050.9084.62.camel@twins>
In-Reply-To: <1317024050.9084.62.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 10:00 AM, Peter Zijlstra wrote:
> On Sat, 2011-09-24 at 19:37 +0200, Manfred Spraul wrote:
>
> 	sma = sem_lock(ns, semid);
>
>> @@ -1456,8 +1414,17 @@ sleep_again:
>>          /*
>>           * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
>>           */
>> -       error = get_queue_result(&queue);
>> -
>> +       error = queue.status;
>> +       if (error != -EINTR) {
>> +               /* If there is a return code, then we can leave immediately. */
>> +               if (!IS_ERR(sma)) {
>> +                       sem_unlock(sma);
>> +               }
>> +               /* Except that we must wait for the hands-off */
>> +               wait_for_completion(&queue.done);
>> +               goto out_free;
> 		you just lost a sem_unlock() in the IS_ERR() case.
>
>> +       }
If IS_ERR(), then sem_lock() failed - thus there must be no unlock.

--
     Manfred
