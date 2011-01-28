Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1A1RyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:54:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1A1RyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ckapvdsfu64/nk18BV/LA7NJ5Q6PLtEarSIDBbGgbbq01uPdsjTJ4nWn7VDic3n88F
         w9VaU1xvg9RTHrloDnl58Gsafa/6tGsmiCM2Kw1SQcq3fITy59BU0WCSALo85A1Dt3vS
         5D3Wr8qCx1YjhDWtQ3D6r5nDfJy7kiALIdlq0=
Date: Fri, 28 Jan 2011 18:54:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Subject: Re: [PATCH 2/2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110128175410.GB1761@nowhere>
References: <AANLkTi=hQpCVJWZ_Op4mhnehufcBg2=h_=q4xXD66tGb@mail.gmail.com>
 <20110126173241.GD1757@nowhere>
 <AANLkTikEvEyMZgmCozw_yt1enRJ2+GTvd02BY30hUJt0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikEvEyMZgmCozw_yt1enRJ2+GTvd02BY30hUJt0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:04:09AM +0100, Vincent Guittot wrote:
> On 26 January 2011 18:32, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Jan 25, 2011 at 09:54:59AM +0100, Vincent Guittot wrote:
> >> Please find below a new proposal for adding trace events for cpu hotplug.
> >> The goal is to measure the latency of each part (kernel, architecture)
> >> and also to trace the cpu hotplug activity with other power events. I
> >> have tested these traces events on an arm platform.
> >>
> >> Subject: [PATCH 1/2] add cpu hotplug tracepoints
> >>
> >> this patch adds new events for cpu hotplug tracing
> >>  * plug/unplug sequence
> >>  * core and architecture latency measurements
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/cpu.c |   17 +++++++++++++++++
> >>  1 files changed, 17 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/cpu.c b/kernel/cpu.c
> >> index 156cc55..f04e9cf 100644
> >> --- a/kernel/cpu.c
> >> +++ b/kernel/cpu.c
> >> @@ -16,6 +16,9 @@
> >>  #include <linux/mutex.h>
> >>  #include <linux/gfp.h>
> >>
> >> +#define CREATE_TRACE_POINTS
> >> +#include <trace/events/cpu_hotplug.h>
> >> +
> >>  #ifdef CONFIG_SMP
> >>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> >>  static DEFINE_MUTEX(cpu_add_remove_lock);
> >> @@ -200,7 +203,9 @@ static int __ref take_cpu_down(void *_param)
> >>       int err;
> >>
> >>       /* Ensure this CPU doesn't handle any more interrupts. */
> >> +     trace_cpu_hotplug_arch_disable_start((unsigned int)(param->hcpu));
> >>       err = __cpu_disable();
> >> +     trace_cpu_hotplug_arch_disable_end((unsigned int)(param->hcpu));
> >
> > You should create a cpu var instead of doing that not very beautiful cast
> > twice.
> >
> 
> OK
> 
> > Probably we should eventually rename arch_disable into just disable.
> >
> > And same for die, because otherwise the name is quite long.
> >
> 
> If we remove the arch extension of these names, we will have
> trace_cpu_hotplug_arch_up for __cpu_up (trace_cpu_hotplug_up is
> already used) and trace_cpu_hotplug_disable for __cpu_disable. would
> that be acceptable ?

You're right.

Well, we could rename cpu_hotplug_arch_up into cpu_hotplug_enable,
but the overall result makes it confusing.

Let's keep it that way.
