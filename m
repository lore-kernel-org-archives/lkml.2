Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2EUTOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:14:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48188 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2EUTOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:14:05 -0400
Date: Mon, 21 May 2012 21:13:43 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120521191343.GB19812@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA879E.5070603@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA879E.5070603@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:21:18AM -0700, John Stultz wrote:
> On 05/18/2012 07:09 AM, Richard Cochran wrote:
> >This patch introduces time keeping variables to track the next
> >mini-epoch between the UTC and TAI timescales. A leap second occurs
> >one second before a mini-epoch. When no leap second is pending, then
> >the epoch is set to the far future, LONG_MAX.
> >
> >This code will become useful later on for providing correct time
> >surrounding a leap second.
> >
> >Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> >---
> >  kernel/time/timekeeping.c |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> >
> >diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> >index d66b213..ac04de4 100644
> >--- a/kernel/time/timekeeping.c
> >+++ b/kernel/time/timekeeping.c
> >@@ -70,6 +70,19 @@ struct timekeeper {
> >  	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
> >  	struct timespec raw_time;
> >
> >+	/* The current TAI - UTC offset */
> >+	time_t tai_offset;
> >+	/* The UTC time of the next leap second epoch */
> >+	time_t utc_epoch;
> >+	/* Tracks where we stand with regard to leap the second epoch. */
> >+	enum {
> >+		LEAP_IDLE,
> >+		LEAP_INS_PENDING,
> >+		LEAP_INS_DONE,
> >+		LEAP_DEL_PENDING,
> >+		LEAP_DEL_DONE,
> >+	} leap_state;
> >+
> One other thing, I'd rather you break this patch set up logically as:
> 1) Move tai offset management into timeekeeping core

** see below

> 2) Move leap_state managment into timekeeping core.
> 
> Instead of:
> 1) Add unused values to timekeeper for tai and leapstate
> 2) Convert NTP code to use both these new values

I can combine these two into one, no problem.

** But it does not make sense to move the tai offset by itself in one
   patch, since that would mean adding an access method in one patch
   and then removing again in the next.

Thanks,
Richard
