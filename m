Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1CHCGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:06:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1CHCGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:06:41 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=ABoCb2N1DRQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=zb5_ILVmYcTN2S5kA3MA:9 a=LQj4ebXQw0seyOYTyXAA:7 a=imCJT4yra4hDmiEL_nYp63LZxhwA:4 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2] trace: adding unstable sched clock note to the
 warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu
In-Reply-To: <20110307104513.GB3661@jolsa.redhat.com>
References: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
	 <20110218145219.GD2604@jolsa.brq.redhat.com>
	 <20110307104513.GB3661@jolsa.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 07 Mar 2011 21:06:38 -0500
Message-ID: <1299549998.20306.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 11:45 +0100, Jiri Olsa wrote:
> hi,
> any feedback?

I could pull it in.

Thanks,

-- Steve

> 
> thanks,
> jirka
> 
> On Fri, Feb 18, 2011 at 03:52:19PM +0100, Jiri Olsa wrote:
> > hi,
> > 
> > warning "Delta way too big" warning might appear on a system with
> > unstable shed clock right after the system is resumed and tracing
> > was enabled during the suspend.
> > 
> > Since it's not realy bug, and the unstable sched clock is working
> > fast and reliable otherwise, Steven suggested to keep using the
> > sched clock in any case and just to make note in the warning itself.
> > 
> > v2 changes:
> > - added CONFIG_HAVE_UNSTABLE_SCHED_CLOCK dependency
> > 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/ring_buffer.c |   12 ++++++++++--
> >  1 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index bd1c35a..37c4d3e 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -2162,11 +2162,19 @@ rb_reserve_next_event(struct ring_buffer *buffer,
> >  	if (likely(ts >= cpu_buffer->write_stamp)) {
> >  		delta = diff;
> >  		if (unlikely(test_time_stamp(delta))) {
> > +			int local_clock_stable = 1;
> > +#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
> > +			local_clock_stable = sched_clock_stable;
> > +#endif
> >  			WARN_ONCE(delta > (1ULL << 59),
> > -				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
> > +				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n%s",
> >  				  (unsigned long long)delta,
> >  				  (unsigned long long)ts,
> > -				  (unsigned long long)cpu_buffer->write_stamp);
> > +				  (unsigned long long)cpu_buffer->write_stamp,
> > +				  local_clock_stable ? "" :
> > +				  "If you just came from a suspend/resume,\n"
> > +				  "please switch to the trace global clock:\n"
> > +				  "  echo global > /sys/kernel/debug/tracing/trace_clock\n");
> >  			add_timestamp = 1;
> >  		}
> >  	}
> > -- 
> > 1.7.1
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


