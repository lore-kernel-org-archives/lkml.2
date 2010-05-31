Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0EaJaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:30:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51746 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0EaJav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iRvpweYGGFErAwIuz3LGioFrPqrCN20aRSR5sKIbu7Ohefgwr1cMuyk3xlpjlH53uU
         sl1bDyraxkMyk6o3nsEhxKekGm4q+idNgM3/jr0ER5YQPTc8hHIkDk6GgjvQhUarslrl
         ztDIuOSc4/2N6juis/m/dzZM+R/A6JWN2Rb7U=
MIME-Version: 1.0
In-Reply-To: <20100531162552.f7439bc0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100529125136.62CA.A69D9226@jp.fujitsu.com>
	<AANLkTimg3PuUAmUUib2pdXNyEeniccLSCEvAm9jtKNji@mail.gmail.com>
	<20100531152424.739D.A69D9226@jp.fujitsu.com>
	<AANLkTilYtODW-8Ey2IUTT2lRR3sy0kgSOO7rN32rjvux@mail.gmail.com>
	<20100531162552.f7439bc0.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 31 May 2010 18:30:50 +0900
Message-ID: <AANLkTimL9P8WBNHmblGf5YOfPriwi1ZuxD2JVjs7jK1d@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 4:25 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 31 May 2010 16:05:48 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Mon, May 31, 2010 at 3:35 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Hi
>> >
>> >> Hi, Kosaki.
>> >>
>> >> On Sat, May 29, 2010 at 12:59 PM, KOSAKI Motohiro
>> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > Hi
>> >> >
>> >> >> oom-killer: give the dying task rt priority (v3)
>> >> >>
>> >> >> Give the dying task RT priority so that it can be scheduled quickly and die,
>> >> >> freeing needed memory.
>> >> >>
>> >> >> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
>> >> >
>> >> > Almostly acceptable to me. but I have two requests,
>> >> >
>> >> > - need 1) force_sig() 2)sched_setscheduler() order as Oleg mentioned
>> >> > - don't boost priority if it's in mem_cgroup_out_of_memory()
>> >>
>> >> Why do you want to not boost priority if it's path of memcontrol?
>> >>
>> >> If it's path of memcontrol and CONFIG_CGROUP_MEM_RES_CTLR is enabled,
>> >> mem_cgroup_out_of_memory will select victim task in memcg.
>> >> So __oom_kill_task's target task would be in memcg, I think.
>> >
>> > Yep.
>> > But priority boost naturally makes CPU starvation for out of the group
>> > processes.
>> > It seems to break cgroup's isolation concept.
>> >
>> >> As you and memcg guys don't complain this, I would be missing something.
>> >> Could you explain it? :)
>> >
>> > So, My points are,
>> >
>> > 1) Usually priority boost is wrong idea. It have various side effect, but
>> >   system wide OOM is one of exception. In such case, all tasks aren't
>> >   runnable, then, the downside is acceptable.
>> > 2) memcg have OOM notification mechanism. If the admin need priority boost,
>> >   they can do it by their OOM-daemon.
>>
>> Is it possible kill the hogging task immediately when the daemon send
>> kill signal?
>> I mean we can make OOM daemon higher priority than others and it can
>> send signal to normal process. but when is normal process exited after
>> receiving kill signal from OOM daemon? Maybe it's when killed task is
>> executed by scheduler. It's same problem again, I think.
>>
>> Kame, Do you have an idea?
>>
> This is just an idea and I have no implementaion, yet.
>
> With memcg, oom situation can be recovered by "enlarging limit temporary".
> Then, what the daemon has to do is
>
>  1. send signal (kill or other signal to abort for coredump.)
>  2. move a problematic task to a jail if necessary.
>  3. enlarge limit for indicating "Go"
>  4. After stabilization, reduce the limit.
>
> This is the fastest. Admin has to think of extra-room or jails and
> the daemon should be enough clever. But in most case, I think this works well.

I think it is very hard that how much we have to make extra-room since
we can't expect how many tasks are stuck to allocate memory.
But tend to agree that system-wide OOM problem is more important than
memcg's one.
And memcg's guy doesn't seem to have any problem. So I am not against
this patch any more.

Thanks, Kosaki and Kame.

> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
