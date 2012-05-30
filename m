Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2E3Bre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:47:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49610 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab2E3Brd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:47:33 -0400
Message-ID: <4FC57BF9.5010608@linaro.org>
Date: Tue, 29 May 2012 18:46:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com> <4FBA84EF.5040506@linaro.org> <20120521190815.GA19812@netboy.at.omicron.at> <20120522173953.GA4177@netboy.at.omicron.at> <4FBBD591.1000103@linaro.org> <20120523082916.GA15627@localhost.localdomain> <4FBD1545.4070408@linaro.org> <20120523191747.GA2348@netboy.at.omicron.at> <4FBD4613.7040003@linaro.org> <20120524064340.GA2180@netboy.at.omicron.at> <20120524065726.GB2180@netboy.at.omicron.at>
In-Reply-To: <20120524065726.GB2180@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053001-1976-0000-0000-00000DA62686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 11:57 PM, Richard Cochran wrote:
> On Thu, May 24, 2012 at 08:43:40AM +0200, Richard Cochran wrote:
>> BTW you can use the program I have been using to test this at
>>
>>     git://github.com/richardcochran/leap.git
> That program exposes another leap second bug, too, I think. It reads
> the time via adjtimex in a tight loop, optionally sleeping using
>
> 	clock_nanosleep(CLOCK_MONOTONIC, 0,&ts, NULL);
>
> The program does not wake from this call during a leap second. It is
> my expectation that CLOCK_MONOTONIC should always work. Why doesn't
> it?

Sorry for being slow here, just got a chance to look at this.

Does the following patch solve this issue for you?

thanks
-john


Make sure we update wall_to_monotonic when adding a leapsecond. This 
could otherwise cause discontinuities in CLOCK_MONOTONIC.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..fb95654 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
  		timekeeper.xtime.tv_sec++;
  		leap = second_overflow(timekeeper.xtime.tv_sec);
  		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic -= leap;
  	}

  	/* Accumulate raw time */

