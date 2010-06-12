Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0FLQoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:44:39 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48354 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0FLQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=POvg3FpuLu+4Gbb2mh296C1eDDSd42+Mppx0IEFwJ1sVcZfkgRCocfIfVc6mVB3OqE
         YQUxXkQnu62eGjLONpOW/ExuQAxxEgw/yaGLKUQiivRs8zYMBV0yipJQqcHON/cgHSH0
         zhLcQmBnQkbmh3dKGh6cemScFZmZyDfnNlMPM=
Date: Sat, 12 Jun 2010 18:44:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] perf: Ability to enable in a paused mode
Message-ID: <20100612164437.GB5235@nowhere>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com> <1276328098-24114-4-git-send-regression-fweisbec@gmail.com> <1276335866.2077.3097.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276335866.2077.3097.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 11:44:26AM +0200, Peter Zijlstra wrote:
> On Sat, 2010-06-12 at 09:34 +0200, Frederic Weisbecker wrote:
> >  struct pmu {
> >         int (*enable)                   (struct perf_event *event);
> > +       /*
> > +        * Reserve acts like enable, except the event must go in a "pause"
> > +        * state. Ie: it is scheduled but waiting to be started
> > +        * with the ->start() callback.
> > +        */
> > +       int (*reserve)                  (struct perf_event *event);
> >         void (*disable)                 (struct perf_event *event); 
> 
> Urgh, so then we have, enable(), reserve() and start(), that's just too
> much. Also, you need to visit all pmu implementations if you touch
> struct pmu like that.


No, in fact that's convenient way not to need to check every pmus.
Only those I know and could test got this reserve implemented. Those that
haven't a reserve will fallback to enable and won't enter this PAUSED
state, task exclusion will then miss the first slice between schedule
and the next interrupt, but it's not dangerous. It's just that if
one wants to support a given pmu, he needs to check this pmu to provide
a relevant implementation.

It was the most convenient way as I don't need to check every pmus,
and I suspect I'm going to be quite useless on sparc, powerpc or arm
as I can't event test these archs (I have no more access to a sparc box).

But yeah I understand your worries about adding a new callback for that.

If you prefer I can provide a flag on enable() and return -ENOSYS for
those I can't test or audit. In fact this is probably more sane, and
we could even not fallback to a normal enable() in case of no support
for the paused mode, and put the event in an error state in this case.
The user requested task exclusion anyway, it's better to tell him we
can't rather than half doing it.


On software events I can just return immediately, on x86 I can maintain
an internal state that gets checked on hw_perf_*able() but the generic
state is convenient enough for that, so I will likely reuse it unless
there are oppositions about this, in which case I can maintain a
duplicate internal paused state for x86 events.


Please tell me what you think about this.

Thanks.

