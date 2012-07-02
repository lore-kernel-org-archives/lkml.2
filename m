Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2GBQ7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:59:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55476 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab2GBQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:59:11 -0400
Message-ID: <4FF1D33D.90703@us.ibm.com>
Date: Mon, 02 Jul 2012 09:58:37 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
References: <4FF06CAB.9020800@redhat.com> <4FF08154.3050407@redhat.com> <4FF088B9.1000308@us.ibm.com> <20120702101606.GA16008@localhost.localdomain>
In-Reply-To: <20120702101606.GA16008@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070216-1780-0000-0000-000007072706
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00153166; UDB=6.00034621; UTC=2012-07-02
 16:59:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 03:16 AM, Richard Cochran wrote:
> On Sun, Jul 01, 2012 at 10:28:25AM -0700, John Stultz wrote:
>> Reworking the patch now.
> John,
>
> I know you didn't like my (originally Michael Hack's) idea of keeping
> time in TAI, but wouldn't changing to an internal, continuous time
> scale (not necessary TAI) solve these sorts of timer issues?
So first, I don't think keeping a different time base would have avoided 
this particular issue.
Its really an issue where the hrtimer code has in-effect a cache of 
timekeeping state that, since clock_was_set() wasn't called, didn't get 
updated when we applied the leapsecond.

Second, I'm not opposed to reworking how the internal system keeps track 
of time.  I just wasn't fond of specifics in your implementation (mostly 
around mixing cleanups with behavioural changes).

I wouldn't be opposed to something like:
     CLOCK_TAI = CLOCK_MONOTONIC + monotonic_to_tai
     CLOCK_REALTIME = CLOCK_TAI + tai_to_utc

Also, some of your suggested changes to move some of the NTP state into 
the timekeeper struct made sense as well, but just needed  some slight 
tweaks.

> There have been a number of clock/timer/leap bugs over the last
> years. Some of these might have been avoided by using a continuous
> scale, since no special timer actions would be needed during a leap
> second.
Unfortunately the other issues have been locking related, so I don't 
think changing the internal time scale would have helped.

Regardless, I do hope you rework and resend your proposed changes. 
Clearly we could use more eyes in this area.

thanks
-john


