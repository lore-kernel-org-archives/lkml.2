Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab1CaKct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1CaKcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:32:47 -0400
Date: Thu, 31 Mar 2011 12:32:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx value
Message-ID: <20110331103230.GA2011@jolsa.brq.redhat.com>
References: <20110326173545.GA22919@redhat.com>
 <1301164168.2250.370.camel@laptop>
 <20110328133033.GA8254@redhat.com>
 <1301324275.4859.25.camel@twins>
 <1301327368.4859.28.camel@twins>
 <20110328165648.GA9304@redhat.com>
 <20110330130951.GA2124@jolsa.brq.redhat.com>
 <1301496684.4859.192.camel@twins>
 <20110330163730.GA6038@redhat.com>
 <1301520405.4859.213.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301520405.4859.213.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:26:45PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-03-30 at 18:37 +0200, Oleg Nesterov wrote:
> > > +static void perf_sched_events_dec(void)
> > > +{
> > > +     jump_label_dec(&perf_sched_events_in);
> > > +     JUMP_LABEL(&perf_sched_events_in, no_sync);
> > > +     synchronize_sched();
> > > +no_sync:
> > > +     jump_label_dec(&perf_sched_events_out);
> > > +}
> > 
> > Nice! I didn't realize we can simply use JUMP_LABEL() directly and then
> > the code doesn't depend on HAVE_JUMP_LABEL. 
> 
> Yeah, avoids having to sprinkle tons of #ifdef goo around ;-)
> 
> Anyway how about we do the partial revert below that should get us back
> to a working kernel and is a nice small patch to send -stable wards.
> 
> After that we can try and be clever with clearing ->task_ctx from things
> like remove_from_context and the like.
> 
> 
> ---
>  include/linux/perf_event.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 311b4dc..04d75a8 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1086,7 +1086,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
>  {
>  	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
>  
> -	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
> +	__perf_event_task_sched_out(task, next);
>  }
>  
>  extern void perf_event_mmap(struct vm_area_struct *vma);
> 
works for me, passed my tests ;)

jirka
