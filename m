Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0GGQVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:21:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56259 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0GGQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:21:13 -0400
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
From: john stultz <johnstul@us.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       oleg@redhat.com
In-Reply-To: <20100707104709.GA2710@jolsa.brq.redhat.com>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com>
	 <AANLkTilE3sd7SSLVCN87rpJ5iSm-sYd-n6nJnzlByfRK@mail.gmail.com>
	 <1278457900.1715.9.camel@localhost>
	 <20100707104709.GA2710@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 09:20:38 -0700
Message-ID: <1278519638.1774.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 12:47 +0200, Jiri Olsa wrote:
> On Tue, Jul 06, 2010 at 04:11:40PM -0700, john stultz wrote:
> > [PATCH] x86: Fix vtime/file timestamp inconsistencies
> > 
> > Due to vtime calling vgettimeofday(), its possible that an application
> > could call  time();create("stuff",O_RDRW);  only to see the file's
> > creation timestamp to be before the value returned by time.
> > 
> > The proper fix is to make vtime use the same time value as
> > current_kernel_time() (which is exported via update_vsyscall) instead of
> > vgettime().
> 
> hm, this would be solution for the time() call.
> 
> But I think the issue still stays for gettimeofday and clock_gettime
> (CLOCK_REALTIME/CLOCK_MONOTONIC) because they call vread from
> clocksource to get the real time.
> 
> Thats where I'm not sure if this race is that "bad", compared either
> to performance hit or inaccuracy of user time calls.. which are possible
> solutions..

Right, so as long as the file timestamps are tick-granular (like other
tick-granular interfaces: current_kernel_time(), time(),
CLOCK_REALTIME_COARSE) you will have the possibility of inconsistencies
against the clocksource resolution interfaces (gettimeofday(),
CLOCK_REALTIME, etc).

But that is to be expected as a constraint of the granularity. So I
don't really see this as an issue.

Folks may want to increase the granularity of filesystem timestamps, but
that will come at the possibly very expensive cost of reading the
clocksource hardware (which can have different access latencies between
architectures and even machines of the same arch). I suspect its not
worth it.

The concerning issue here that you pointed out are the inconsistencies
could be seen between vsyscall time() and time() (or filesystem
timestamps). That is a problem, and my patch should resolve that one.

thanks
-john






