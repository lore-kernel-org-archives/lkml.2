Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2EDMUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:20:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2EDMUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120504120455.GB4413@somewhere.redhat.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-2-git-send-email-gilad@benyossef.com>
	<20120504120455.GB4413@somewhere.redhat.com>
Date: Fri, 4 May 2012 14:20:16 +0200
Message-ID: <CAFTL4hzSPbtTbL8gHy2SEnBv3rqWdk2UQL0uBUedqm2mmpHKiQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] timer: make __next_timer_interrupt explicit about
 no future event
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/4 Frederic Weisbecker <fweisbec@gmail.com>:
> On Thu, May 03, 2012 at 05:55:57PM +0300, Gilad Ben-Yossef wrote:
>> @@ -1317,9 +1322,15 @@ unsigned long get_next_timer_interrupt(unsigned long now)
>>       if (cpu_is_offline(smp_processor_id()))
>>               return now + NEXT_TIMER_MAX_DELTA;
>>       spin_lock(&base->lock);
>> -     if (time_before_eq(base->next_timer, base->timer_jiffies))
>> -             base->next_timer = __next_timer_interrupt(base);
>> -     expires = base->next_timer;
>> +     if (time_before_eq(base->next_timer, base->timer_jiffies)) {
>> +
>> +             if (__next_timer_interrupt(base, &expires))
>> +                     base->next_timer = expires;
>> +             else
>> +                     expires = now + NEXT_TIMER_MAX_DELTA;
>
> I believe you can update base->next_timer to now + NEXT_TIMER_MAX_DELTA,
> so on any further idle interrupt exit that call tick_nohz_stop_sched_tick(),
> we won't get again the overhead of __next_timer_interrupt().

Ah forget that, I was confused. If we do that we actually get the useless timer
at now + NEXT_TIMER_MAX_DELTA.

So I think the patch is fine.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
