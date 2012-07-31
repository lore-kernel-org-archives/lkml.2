Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2GaJya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:54:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58435 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2GaJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
Date: Tue, 31 Jul 2012 10:54:26 +0100
Message-ID: <CAAMvbhGnNAChs+6mzdRduzgYmWRXQexsbS=w0wgrRhAKrdL6QA@mail.gmail.com>
Subject: Re: [PATCH 0/2][RFC] Better handling of insane CMOS values
From: James Courtier-Dutton <james.dutton@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2012 07:35, John Stultz <john.stultz@linaro.org> wrote:
> So CAI Qian noticed recent boot trouble on a machine that had its CMOS
> clock configured for the year 8200.
> See: http://lkml.org/lkml/2012/7/29/188
>
> While running with a crazy CMOS clock isn't advised, and a simple
> "don't do that" might be reasonable, the behavior has in effect
> regressed recently due to changes in the hrtimer/timekeeping
> interactions.
>
Would it not be easier to work out which CMOS clock values we can
handle correctly, and then do input value validation on the CMOS
values, and if a value is outside the acceptable range, assume a value
equal to the minimum acceptable value.

Also, surely all timer use within the kernel should use the monotonic
time source for timer expiry, and not depend on CMOS time.
I.e. If we want a thread to wake up once every 30 seconds, use the
monotonic time source for that.
conversion to local time should only be needed for timestamps.
We might need a compile/boot time option to assign useable ranges to
local time values.
E.g. For this boot, local time is between year 2000 and 2100
For next boot, local time is between year 2050 and 2150.
Obviously, make the range as wide as we can sensibly handle, so the
setting does not need to be changed very often.
The range will be determined by the amount of bits in the time values.
User space can work on much wider ranges for historical date storage,
but for accessing the current time, smaller ranges are workable.

Kind Regards

James








> This patchset tries to resolve this issue in two ways:
> 1) Change ktime_get_update_offsets to match ktime_get and avoid
> possible precision loss with extremely large timespecs.
>
> 2) Catch any stop attempt to set the time to a value (circa the
> year 2264) large enough to overflow ktime_t.
>
> The end fix here might be an either/or/both combination of these
> two changes, so I wanted to send them out for comment. I'm also
> looking at further ways to test and improve robustness around
> these more extreme time values.
>
> I've also only been able to lightly test. If you want to try this out
> you can add the following to timekeeping_init after the
> read_persistent_clock() call:
>
>         now.tv_sec = 196469280000LL;
>
> thanks
> -john
>
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Zhouping Liu <zliu@redhat.com>
> Cc: CAI Qian <caiqian@redhat.com>
>
>
> John Stultz (2):
>   [RFC] time: Fix problem with large timespecs &
>     ktime_get_update_offsets
>   [RFC] time: Limit time values that would overflow ktime_t
>
>  kernel/time/timekeeping.c |   40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
