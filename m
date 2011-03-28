Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1C1Ptz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:49:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1C1Pty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:49:54 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1301324275.4859.25.camel@twins>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com>  <1301324275.4859.25.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 17:49:28 +0200
Message-ID: <1301327368.4859.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 16:57 +0200, Peter Zijlstra wrote:
> > 
> > Wait... Yes, we have to clear ctx->is_active, otherwise we break, say,
> > perf_install_in_context().
> > 
> > But if we clear ->is_active we break perf_event_enable(). Suppose we
> > are doing ioctl(PERF_EVENT_IOC_DISABLE) + ioctl(PERF_EVENT_IOC_ENABLE).
> > PERF_EVENT_IOC_DISABLE can sched_out the last event, but _IOC_ENABLE
> > treats ctx->is_active == F as "it is not running".
> 
> Right, same for the tick, if say we can only schedule 1 event at a time
> and we close the 1 event that is active, the tick will not rotate a new
> event in. 

Another fun race, suppose we do properly remove task_ctx and is_active,
but then the task gets scheduled back in before free_event() gets around
to disabling the jump_label..


