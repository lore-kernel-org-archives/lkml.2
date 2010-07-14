Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0GNQTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:19:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58825 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0GNQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:19:34 -0400
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
From: john stultz <johnstul@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100714113527.EA8A.A69D9226@jp.fujitsu.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
	 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
	 <20100714113527.EA8A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 09:19:04 -0700
Message-ID: <1279124344.1831.13.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > Due to vtime calling vgettimeofday(), its possible that an application
> > could call  time();create("stuff",O_RDRW);  only to see the file's
> > creation timestamp to be before the value returned by time.
> 
> Just dumb question.
> 
> Almost application are using gettimeofday() instead time(). It mean
> your fix don't solve almost application.

Correct,  filesystem timestamps and gettimeofday can still seem
inconsistently ordered. But that is expected.

Because of granularity differences (one interface is only tick
resolution, the other is clocksource resolution), we can't interleave
the two interfaces (time and gettimeofday, respectively) and expect to
get ordered results.

This is why the fix I'm proposing is important: Filesystem timestamps
have always been tick granular, so when vtime() was made clocksource
granular (by using vgettime internally) we broke the historic
expectation that the time() interface could be interleaved with
filesystem operations.

Side note: For full nanosecond resolution of the tick-granular
timestamps, check out the clock_gettime(CLOCK_REALTIME_COARSE, ...)
interface.


> So, Why can't we fix vgettimeofday() vs create() inconsistency?
> This is just question, I don't intend to disagree you.

The only way to make gettimeofday and create consistent is to use
gettimeofday clocksource resolution timestamps for files. This however
would potentially cause a large performance hit, since each every file
timestamp would require a possibly expensive read of the clocksource.

thanks
-john


