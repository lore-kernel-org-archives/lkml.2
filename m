Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0IQHwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:52:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0IQHwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xtNj8lRJhZ5iUHk3Q/NgPrRajgriMA+GMHTZe+cvWc9xsdSQWiR12ZenM4ckIJTwWR
         3Tv9tOD//dMjqR3WBCo5JLkKZZoWS8MHNaFoFTln9H+GxTLWFBwKeTQ0GIp7IcYW+nzi
         8xdNmgjAy3GGhKCwXTGa8tpTSywRopH2yWwXg=
Date: Fri, 17 Sep 2010 09:52:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Posix CLOCK_RTC interface proof of concept
Message-ID: <20100917075207.GA12438@riccoc20.at.omicron.at>
References: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 12:41:32PM -0700, John Stultz wrote:
> Exposing multiple RTCs via the posix clock interface has some tradeoffs.
> 
> a) Some application programmers may really want to see the underlying
> hardware and be sophisticated enough to deal with the multiple,
> possibly unsynchronized, time domains.
> 
> b) Some application programmers may not care about the hardware, and
> just want a interface that works like CLOCK_REALTIME, but fires
> wakeup alarms if the system is suspended.

I like the idea of offering the high-level posix clock API for various
hardware clocks. Also, keeping low-level access for specialists makes
sense, as long as there is a way to enforce correct access control. If
we make the posix clocks truly dynamic (with removal, too), then one
could offer a low level funtion to grab the clock before use.

> Exposing all the RTC devices in a somewhat raw manner is probably
> the most straight forward. Some extra infrastructure, like
> the dynamic posix-clockid allocation Richard Cochran has
> started to look into will be needed. More concerning is that
> this will probably cause some grief if someone creates a cron-like
> tool that uses the RTC where the RTC isn't exactly synced with
> system time. When the user specified a job for 6am, do they mean
> 6am system time, or RTC?
> 
> And note: on many PCs, the RTC is synchronized, but kept in local
> time, not UTC. So the unsynched RTC case is likely to be common.

We could also advertise the clocks properties (eg timescale) via sysfs
(or clockfs, as Greg K.H. put it).

> 3) Adding the posix time interface makes it easier to have finer
> grained capability management to decide what applications can
> set a alarm timer. While this is great for creating applications
> that can wake servers up from suspend mode, and simplifying the
> wakeup infrastructure on cell phones, some systems may not
> want applications being able to set wakeup timers. I can
> imagine the "laptop in well insulated carry-on luggage" case
> that comes up occasional being one of them. So some additional
> thought and policy may be needed to decide when non-user-triggered
> wake events should be masked or not in suspend.

Again, implementing dynamic clocks would allow the sysdadmin to just
remove the clock whenever it might cause trouble.

Overall:

I only took a quick look at the patch, but I like the general idea.

You introduce posix timers that are *not* based on the hrtimer code,
but rather on a second implementation. I wonder whether one could
abstract the timer management code to work with different clocks.

I have been thinking about that for the PTP hardware clock stuff and
will soon post a new round of patches.

Thanks,
Richard
