Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0FLQZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:25:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37831 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0FLQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m+R/Sj+dmh5BHzqiLqgUPsMHNd+ZfYPLyg2Rb6vF3A3Ql7GHG/q89zk8G1X+FHTQYf
         zbua5qo/v/zTr74GZz4iK0zFZo0EOI+hZEdCaaRDblzlmgTLLSQKlRwHJbZDzJduM9Xk
         F8l/ENaTBrPMMtB53kE2MlV6b/lK/4oIauP68=
Date: Sat, 12 Jun 2010 18:25:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
	events
Message-ID: <20100612162551.GA5235@nowhere>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com> <1276328098-24114-2-git-send-regression-fweisbec@gmail.com> <1276335791.2077.3095.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276335791.2077.3095.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 11:43:11AM +0200, Peter Zijlstra wrote:
> On Sat, 2010-06-12 at 09:34 +0200, Frederic Weisbecker wrote:
> > In order to introduce new context exclusions, software events will
> > have to eventually stop when needed. We'll want perf_event_stop() to
> > act on every events.
> > 
> > To achieve this, remove the stub stop/start pmu callbacks of software
> > and tracepoint events that fixed a race in perf_adjust_period, and do
> > an explicit check to only reset the hardware event using the
> > start/stop callbacks.
> 
> I really object to this,. its just too ugly to live.


Several propositions of alternatives then, please tell me if one
looks more palatable to you:

- Having an argument on ->stop() and ->start() callback which
  would be reset_period. If reset_period is true, then the event
  knows the goal is to reprogram the interrupt.

  FWIW, that's my prefered solution, software pmus can just check
  this and return immediately. This avoids all the race between
  concurrent stat and stop plus the wasteful/useless hlist
  manipulation.

- Having a nesting level control on stop and start, so that
  we only call stop/start on nesting level 0. That solves the race.

- Having a flag in the pmu that tells if it wants to reprogram
  on period reset. Then we know if we need the start/stop against
  this flag. I just propose this one for the fun, I already
  know it sucks :)

Thanks.

