Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2ITRcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:32:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54600 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2ITRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <1348151508.13080.66.camel@gandalf.local.home>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <1348151508.13080.66.camel@gandalf.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Sep 2012 10:32:01 -0700
Message-ID: <CALCETrUpZ24iwdzTgXEUf+KhZZSY28EHcUN5combyEZD=+OiNw@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <john.stultz@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 7:31 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-09-17 at 16:49 -0700, Andy Lutomirski wrote:
>
>> I haven't looked in any great detail, but the approach looks sensible
>> and should slow down the vsyscall code.
>>
>> That being said, as long as you're playing with this, here are a
>> couple thoughts:
>>
>> 1. The TSC-reading code does this:
>>
>>       ret = (cycle_t)vget_cycles();
>>
>>       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
>>
>>       if (likely(ret >= last))
>>               return ret;
>>
>> I haven't specifically benchmarked the cost of that branch, but I
>> suspect it's a fairly large fraction of the total cost of
>> vclock_gettime.  IIUC, the point is that there might be a few cycles
>> worth of clock skew even on systems with otherwise usable TSCs, and we
>> don't want a different CPU to return complete garbage if the cycle
>> count is just below cycle_last.
>>
>> A different formulation would avoid the problem: set cycle_last to,
>> say, 100ms *before* the time of the last update_vsyscall, and adjust
>> the wall_time, etc variables accordingly.  That way a few cycles (or
>> anything up to 100ms) or skew won't cause an overflow.  Then you could
>> kill that branch.
>>
>
> I'm curious... If the task gets preempted after reading ret, and doesn't
> get to run again for another 200ms, would that break it?

Only if cycle_last changes while preempted (or from a different CPU).
That case is covered by the seqlock in do_realtime and do_monotonic.

--Andy
