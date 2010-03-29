Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0C2RUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:20:53 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:60372 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0C2RUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AOIOPQOi95qm6H3jfrrlPMq86Vn1x+kGl4bVxc3xiWt2Rv1Ts8SPlfqrAYQxT7jYHJ
         /yHGxPhpU2lvVf2fpJW/bNmhlJnFcG2HOfQkonrHyhMJqQfocGjVwcnuWBrDgiSBCC1L
         o4HlD0US8b0pCKbSpAco18sh7dPE9OrK88GZo=
MIME-Version: 1.0
In-Reply-To: <1269873718.12097.342.camel@laptop>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <1269873718.12097.342.camel@laptop>
Date: Mon, 29 Mar 2010 13:20:50 -0400
X-Google-Sender-Auth: 35ff4c9074a90646
Message-ID: <40ec3ea41003291020v24dd234el1300291e6bb54d9d@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-03-29 at 09:41 -0400, Chase Douglas wrote:
>> There's a period of 10 ticks where calc_load_tasks is updated by all the
>> cpus for the load avg. Usually all the cpus do this during the first
>> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
>> However, if they wake up calc_load_tasks is not incremented. Thus, if
>> cpus go idle during the 10 tick period, calc_load_tasks may be
>> decremented to a non-representative value. This issue can lead to
>> systems having a load avg of exactly 0, even though the real load avg
>> could theoretically be up to NR_CPUS.
>>
>> This change defers calc_load_tasks accounting after each cpu updates the
>> count until after the 10 tick period.
>
> >From reading the above changelog it seems to me there should be a
> callback from leaving nohz mode, your proposed patch has no such thing.

I believe what you're implying is that there should be a corresponding
call for when a cpu is awakened to counter the accounting when a cpu
goes to sleep during the 10 tick window. I don't think this is the
correct approach because the load avg should be a snapshot in time. If
there were 10 runnable tasks at the beginning of the load calculation
window, then we should account for 10 tasks. If they all get serviced
and the cpu goes to sleep, then wakes back up with one runnable task,
we would account for only one task instead of the original 10. What if
9 more tasks then get added to the cpu's rq during the 10 tick update
period? None of them would be accounted for either.

-- Chase
