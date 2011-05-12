Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1ELCAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:00:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34956 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1ELCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:00:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 12 May 2011 10:53:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] oom: kill younger process first
Message-Id: <20110512105351.a57970d7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTi=ya1rAqC+nMPHkBaMsoXpsCeHH=w@mail.gmail.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com>
	<20110510171335.16A7.A69D9226@jp.fujitsu.com>
	<20110510171641.16AF.A69D9226@jp.fujitsu.com>
	<20110512095243.c57e3e83.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=ya1rAqC+nMPHkBaMsoXpsCeHH=w@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 10:30:45 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi Kame,
> 
> On Thu, May 12, 2011 at 9:52 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 10 May 2011 17:15:01 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >> This patch introduces do_each_thread_reverse() and
> >> select_bad_process() uses it. The benefits are two,
> >> 1) oom-killer can kill younger process than older if
> >> they have a same oom score. Usually younger process
> >> is less important. 2) younger task often have PF_EXITING
> >> because shell script makes a lot of short lived processes.
> >> Reverse order search can detect it faster.
> >>
> >> Reported-by: CAI Qian <caiqian@redhat.com>
> >> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >
> > IIUC, for_each_thread() can be called under rcu_read_lock() but
> > for_each_thread_reverse() must be under tasklist_lock.
> 
> Just out of curiosity.
> You mentioned it when I sent forkbomb killer patch. :)
> From at that time, I can't understand why we need holding
> tasklist_lock not rcu_read_lock. Sorry for the dumb question.
> 
> At present, it seems that someone uses tasklist_lock and others uses
> rcu_read_lock. But I can't find any rule for that.
> 

for_each_list_rcu() makes use of RCU list's characteristics and allows
walk a list under rcu_read_lock() without taking any atomic locks.

list_del() of RCU list works as folllowing.

==
 1) assume  A, B, C, are linked in the list.
	(head)<->(A) <-> (B)  <-> (C)

 2) remove B.
	(head)<->(A) <-> (C)
		        /
                     (B)

 Because (B)'s next points to (C) even after (B) is removed, (B)->next
 points to the alive object. Even if (C) is removed at the same time,
 (C) is not freed until rcu glace period and (C)'s next points to (head)

Then, for_each_list_rcu() can work well under rcu_read_lock(), it will visit
only alive objects (but may not be valid.)

==

please see include/linux/rculist.h and check list_add_rcu() ;)

As above implies, (B)->prev pointer is invalid pointer after list_del().
So, there will be race with list modification and for_each_list_reverse under
rcu_read__lock()

So, when you need to take atomic lock (as tasklist lock is) is...

 1) You can't check 'entry' is valid or not...
    In above for_each_list_rcu(), you may visit an object which is under removing.
    You need some flag or check to see the object is valid or not.

 2) you want to use list_for_each_safe().
    You can't do list_del() an object which is under removing...

 3) You want to walk the list in reverse.

 3) Some other reasons. For example, you'll access an object pointed by the
    'entry' and the object is not rcu safe.

make sense ?

Thanks,
-Kame


> Could you elaborate it, please?
> Doesn't it need document about it?
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

