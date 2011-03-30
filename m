Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab1C3V1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:27:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:53974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab1C3V1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:27:21 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110330163730.GA6038@redhat.com>
References: <1301157483.2250.366.camel@laptop>
	 <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com>
	 <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com>
	 <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins>
	 <20110328165648.GA9304@redhat.com>
	 <20110330130951.GA2124@jolsa.brq.redhat.com>
	 <1301496684.4859.192.camel@twins>  <20110330163730.GA6038@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 23:26:45 +0200
Message-ID: <1301520405.4859.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 18:37 +0200, Oleg Nesterov wrote:
> > +static void perf_sched_events_dec(void)
> > +{
> > +     jump_label_dec(&perf_sched_events_in);
> > +     JUMP_LABEL(&perf_sched_events_in, no_sync);
> > +     synchronize_sched();
> > +no_sync:
> > +     jump_label_dec(&perf_sched_events_out);
> > +}
> 
> Nice! I didn't realize we can simply use JUMP_LABEL() directly and then
> the code doesn't depend on HAVE_JUMP_LABEL. 

Yeah, avoids having to sprinkle tons of #ifdef goo around ;-)

Anyway how about we do the partial revert below that should get us back
to a working kernel and is a nice small patch to send -stable wards.

After that we can try and be clever with clearing ->task_ctx from things
like remove_from_context and the like.


---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 311b4dc..04d75a8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1086,7 +1086,7 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	__perf_event_task_sched_out(task, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);

