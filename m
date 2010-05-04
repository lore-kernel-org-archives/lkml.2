Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab0EDMqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:46:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0EDMqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:46:33 -0400
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <4BDFC9FB.4020607@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-4-git-send-email-tj@kernel.org>
	 <1272893192.5605.122.camel@twins>  <4BDFC9FB.4020607@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 14:45:59 +0200
Message-ID: <1272977159.5605.171.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 09:17 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> > On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
> >> @@ -2909,7 +2912,9 @@ redo:
> >>                         }
> >>                         raw_spin_unlock_irqrestore(&busiest->lock, flags);
> >>                         if (active_balance)
> >> -                               wake_up_process(busiest->migration_thread);
> >> +                               stop_one_cpu_nowait(cpu_of(busiest),
> >> +                                       active_load_balance_cpu_stop, busiest,
> >> +                                       &busiest->active_balance_work); 
> > 
> > So who guarantees busiest->active_balance_work isn't already enqueued by
> > some other cpu's load-balancer run?
> > 
> 
> Hmmm... maybe I'm mistaken but isn't that guaranteed by
> busiest->active_balance which is protected by the rq lock?
> active_load_balance_cpu_stop is scheduled iff busiest->active_balance
> was changed from zero and only active_load_balance_cpu_stop() can
> clear it at the end of its execution at which point the
> active_balance_work is safe to reuse.

Ah, indeed. It wasn't obvious from looking at the patch, but when
looking at the full code it fairly easy to see.


