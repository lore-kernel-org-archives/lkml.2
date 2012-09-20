Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2ITObw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:31:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2ITObu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:31:50 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UpNdDaqHjpYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vf-gB0X8UnYA:10 a=QhcPvl6xG_X7ph4a8PIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348151508.13080.66.camel@gandalf.local.home>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 20 Sep 2012 10:31:48 -0400
In-Reply-To: <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
	 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 16:49 -0700, Andy Lutomirski wrote:

> I haven't looked in any great detail, but the approach looks sensible
> and should slow down the vsyscall code.
> 
> That being said, as long as you're playing with this, here are a
> couple thoughts:
> 
> 1. The TSC-reading code does this:
> 
> 	ret = (cycle_t)vget_cycles();
> 
> 	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
> 
> 	if (likely(ret >= last))
> 		return ret;
> 
> I haven't specifically benchmarked the cost of that branch, but I
> suspect it's a fairly large fraction of the total cost of
> vclock_gettime.  IIUC, the point is that there might be a few cycles
> worth of clock skew even on systems with otherwise usable TSCs, and we
> don't want a different CPU to return complete garbage if the cycle
> count is just below cycle_last.
> 
> A different formulation would avoid the problem: set cycle_last to,
> say, 100ms *before* the time of the last update_vsyscall, and adjust
> the wall_time, etc variables accordingly.  That way a few cycles (or
> anything up to 100ms) or skew won't cause an overflow.  Then you could
> kill that branch.
> 

I'm curious... If the task gets preempted after reading ret, and doesn't
get to run again for another 200ms, would that break it?

-- Steve


