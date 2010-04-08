Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab0DHXnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:43:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33416 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978Ab0DHXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H4LrkTOzX+poL4Nx3m+e1VBR05w+nQML2vyQYAdoH5V7yoNxkjbhe7HeuT5ZKQubVQ
         M5uyQZamabPlfLfUc4AQjPnzdTkhrO9WKV6bCtKBQk0x/R6A5bXK7Jv5dsUusmvRdTYt
         BK5s4sOattY2HAQZblzMiGFNb8Vp3ZJnBeyoM=
Date: Fri, 9 Apr 2010 01:42:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/7] ring-buffer: Add lost event count to end of sub
	buffer
Message-ID: <20100408234242.GA6672@nowhere>
References: <20100401031735.683626160@goodmis.org> <20100401031820.590115556@goodmis.org> <20100401061343.GA5207@nowhere> <1270124616.19685.8829.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270124616.19685.8829.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 08:23:36AM -0400, Steven Rostedt wrote:
> On Thu, 2010-04-01 at 08:13 +0200, Frederic Weisbecker wrote:
> > On Wed, Mar 31, 2010 at 11:17:42PM -0400, Steven Rostedt wrote:
> 
> > If you don't have enough room to put lost_events in the end of
> > the buffer, you could keep as is cpu_buffer->last_overrun,
> > so the next time you swap the reader page, the new delta
> > will be added to the previous that you couldn't transmit.
> > 
> > That way you ensure the user always know when you lose events.
> 
> When is not the issue since we set the MISSING_EVENTS flag already. It's
> how many were lost at that time that we do not store.


Ah ok.


 
> I actually found in most cases there is room, and trace-cmd can report
> it. When there is no room, it just says events were dropped without
> reporting the actual number.
> 
> 
> This is what it shows when the number can be stored:
> 
>        trace-cmd-4980  [002] 32784.303699: lock_acquire:         0xffff88003ebf0e08 &(&sbi->s_rsv_window_lock)->rlock
>        trace-cmd-4980  [002] 32784.303700: lock_release:         0xffff88003ebf0e08 &(&sbi->s_rsv_window_lock)->rlock
> CPU:1 [415 EVENTS DROPPED]
>        trace-cmd-4981  [001] 32784.303701: lock_release:         0xffff88000c49d7d0 &ei->truncate_mutex
>        trace-cmd-4981  [001] 32784.303704: lock_acquire:         0xffffffff816591e0 read rcu_read_lock
>        trace-cmd-4980  [002] 32784.303705: lock_acquire:         0xffff88003c0719d8 &(&bgl->locks[i].lock)->rlock
> 
> This is what it shows when the number can not:
> 
>           <idle>-0     [002] 32784.304459: lock_acquire:         0xffffffff816591e0 read rcu_read_lock
>           <idle>-0     [002] 32784.304464: lock_release:         0xffffffff816591e0 rcu_read_lock
> CPU:1 [EVENTS DROPPED]
>               ls-4984  [001] 32784.304471: lock_acquire:         0xffff88003f8b8018 &(&base->lock)->rlock
>               ls-4984  [001] 32784.304471: lock_release:         0xffff88003f8b8018 &(&base->lock)->rlock
>               ls-4984  [001] 32784.304471: softirq_exit:         vec=1 [action=TIMER]
> 
> 
> The problem with storing it later is that there is no guarantee that it
> will be stored later. How far should the output look for that number. By
> delaying when to print it, the output would need to search for that
> number.
> 
> What happens if events were lost again before we found the number? Do we
> add them together? Then we wont know how many events were lost between
> the two spots where the events were lost. That is, if 448 events were
> lost but we could not store the number, and then 318 events were lost,
> and now we can store the number, do we add them together and report 766
> events lost?


This is what I thought about yeah, adding them.



> The end of the report still gives the total number lost, as it has
> always done. Now I'm trying to report where they are lost.


Ok.


 
> Also note, in practice, the majority of the time we can record the
> number:
> 
>   $ trace-cmd report | grep EVENTS
> CPU:1 [82 EVENTS DROPPED]
> CPU:0 [79 EVENTS DROPPED]
> CPU:2 [75 EVENTS DROPPED]
> CPU:1 [86 EVENTS DROPPED]
> CPU:0 [87 EVENTS DROPPED]
> CPU:2 [EVENTS DROPPED]
> CPU:0 [87 EVENTS DROPPED]
> CPU:0 [79 EVENTS DROPPED]
> CPU:1 [177 EVENTS DROPPED]
> CPU:0 [78 EVENTS DROPPED]
> CPU:0 [73 EVENTS DROPPED]
> CPU:1 [163 EVENTS DROPPED]
> CPU:2 [86 EVENTS DROPPED]
> CPU:0 [75 EVENTS DROPPED]
> CPU:2 [89 EVENTS DROPPED]
> CPU:0 [EVENTS DROPPED]
> CPU:0 [75 EVENTS DROPPED]
> CPU:1 [EVENTS DROPPED]
> CPU:2 [EVENTS DROPPED]
> CPU:0 [77 EVENTS DROPPED]
> CPU:0 [EVENTS DROPPED]
> CPU:0 [78 EVENTS DROPPED]
> CPU:1 [90 EVENTS DROPPED]
> CPU:2 [86 EVENTS DROPPED]
> CPU:1 [87 EVENTS DROPPED]
> CPU:2 [84 EVENTS DROPPED]
> CPU:2 [82 EVENTS DROPPED]
> CPU:1 [90 EVENTS DROPPED]
> CPU:1 [89 EVENTS DROPPED]
> CPU:2 [EVENTS DROPPED]
> CPU:0 [EVENTS DROPPED]
> CPU:2 [164 EVENTS DROPPED]
> CPU:1 [EVENTS DROPPED]
> CPU:0 [79 EVENTS DROPPED]
> CPU:0 [89 EVENTS DROPPED]
> 
> 
> If we really want this number every time, then we need to add it to the
> sub buffer header, and not hope there was room to store it.


Yeah. My biggest worry was that the user may not be reported of some
lost events. But as far as we have the total and also a flag that at
least reports we missed events (whatever the number there), then
it's fine.

Thanks.

