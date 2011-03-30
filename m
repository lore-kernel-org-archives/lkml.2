Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1C3WzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:55:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab1C3WzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N2P9ONO2Tvo+zkkDPhnT/S2EATQdOKe+AC69GSv/h89X3atgXftqt/oZteg4K8ADAQ
         un+iWGHGWJW/1/U/kU/oLc2hThgGF87vggd4ExmhztCfm/upVYY9+F/0QamQdvKkJQXG
         ULZ21FtDyeo6e1WzRoYkQwTiZh29jskqZstJo=
MIME-Version: 1.0
In-Reply-To: <20110330143617.3d57aad2.akpm@linux-foundation.org>
References: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
	<20110330143617.3d57aad2.akpm@linux-foundation.org>
Date: Thu, 31 Mar 2011 07:54:59 +0900
Message-ID: <BANLkTimybBbs0XMwxKPTF-sr+UUEwD9XFg@mail.gmail.com>
Subject: Re: [PATCH] Accelerate OOM killing
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 6:36 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 24 Mar 2011 18:52:33 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> When I test Andrey's problem, I saw the livelock and sysrq-t says
>> there are many tasks in cond_resched after try_to_free_pages.
>
> __alloc_pages_direct_reclaim() has two cond_resched()s, in
> straight-line code.  So I think you're concluding that the first
> cond_resched() is a no-op, but the second one frequently schedules
> away.
>
> For this to be true, the try_to_free_pages() call must be doing
> something to cause it, such as taking a large amount of time, or
> delivering wakeups, etc.  Do we know?

Andrey's test case is forkbomb. When many parallel reclaiming
processes give big memory pressure to VM,  try_to_free_pages takes a
very long time.

>
> The patch is really a bit worrisome and ugly.  If the CPU scheduler has
> decided that this task should be preempted then *that* is the problem,
> and we need to work out why it is happening and see if there is anything
> we should fix.  Instead the patch simply ignores the scheduler's
> directive, which is known as "papering over a bug".

I think patch doesn't ignore scheduler's directive.
In normal case, try_to_free_pages does *did_some_progress* so
cond_resched after checking if (*did_some_progres) is still effective.

But like andrey's case(ex forkbomb), too many processes takes long
time in try_to_free_pages and at last a process reaches
!did_some_progress after consuming much time in try_to_free_pages.
Unfortunately scheduler decide it should be preempted and it is
scheduled out. Then another task repeat above scenario until
zone->all_unreclaimed is set.

I think it's a trade-off between schedule latency VS OOM latency.
Forkbomb already ruin the system so in that case, OOM latency is more
important than schedule's one.

>
> IOW, we should work out why need_resched is getting set so frequently
> rather than just ignoring it (and potentially worsening kernel
> scheduling latency).

I think do_try_to_free_pages's time consuming of parallel many processes.

>
>> If did_some_progress is false, cond_resched could delay oom killing so
>> It might be killing another task.
>>
>> This patch accelerates oom killing without unnecessary giving CPU
>> to another task. It could help avoding unnecessary another task killing
>> and livelock situation a litte bit.
>
> Well...  _does_ it help?  What were the results of your testing of this
> patch?
>
>

I thought fast killing of non-progress-reclaimed task would prevent
another task killing and help OOM latency. But in andrey's case, only
this patch itself cannot solve the problem completely.

Fundamental solution is basically 1. we prevent the livelock which is
trying by KOSAKI then, 2. prevent forkbomb which is trying by Kame and
me.
Okay. I don't mind you hold this patch.

I will look at the situation after applying KOSAKI's patch and
forkbomb killer. Maybe the patch would be okay to drop, then.

Thanks, Andrew.

-- 
Kind regards,
Minchan Kim
