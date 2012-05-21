Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2EUTI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:08:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51890 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2EUTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:08:27 -0400
Date: Mon, 21 May 2012 21:08:15 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120521190815.GA19812@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
 <4FBA84EF.5040506@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA84EF.5040506@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:09:51AM -0700, John Stultz wrote:
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
> 
> How about leap_utc_epoch just to be more clear?

Okay

> 
> >+	/* Tracks where we stand with regard to leap the second epoch. */
> >+	enum {
> >+		LEAP_IDLE,
> >+		LEAP_INS_PENDING,
> >+		LEAP_INS_DONE,
> >+		LEAP_DEL_PENDING,
> >+		LEAP_DEL_DONE,
> >+	} leap_state;
> >+
> For continuity,  would it make more sense for these to named closer
> to the NTP time_state values, or maybe reworked to make use of them?
> Not sure if its worth having separate state machines in the
> timekeeping code and the ntp code, but maybe I'm not seeing a
> necessary detail here?

Actually, the two state machines are _essential_ in making this
work. The first patch idea which you nixed (keep continuous time and
compute discontinuous UTC on demand) would make it all simple and
logical.  But having to deal with the time basis jumping around (and
at the wrong time, too late, at the tick) forces us to keep extra
state.

For example In order to know TIME_OOP, you need to know

1. the UTC time of the epoch
2. from that, the UTC time of the leap second (before the jump)
3. whether or not the leap second correction has occurred

I don't think I am explaining this very well. I will try again to make
it clear using a table or something later on.

Thanks,
Richard
