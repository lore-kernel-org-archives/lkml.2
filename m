Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2GZM53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:57:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2GZM52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:57:28 -0400
Date: Thu, 26 Jul 2012 14:57:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] time: Cleanup offs_real/wall_to_mono and
 offs_boot/total_sleep_time updates
Message-ID: <20120726125721.GE24672@gmail.com>
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
 <1342660753-10382-3-git-send-email-john.stultz@linaro.org>
 <20120719093305.GA27086@gmail.com>
 <500DA6A4.1000009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500DA6A4.1000009@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 07/19/2012 02:33 AM, Ingo Molnar wrote:
> >* John Stultz <john.stultz@linaro.org> wrote:
> >
> >>+static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
> >>+{
> >>+	/* Verify consistency before modifying */
> >>+	WARN_ON_ONCE(tk->offs_boot.tv64 !=
> >>+				timespec_to_ktime(tk->total_sleep_time).tv64);
> >asserts like this can be put into a single line - we rarely need
> >to read them if they don't trigger - and making them
> >non-intrusive oneliners is a bonus.
> 
> Ack.
> 
> >>  @@ -456,8 +478,8 @@ int timekeeping_inject_offset(struct timespec *ts)
> >>  	tk_xtime_add(&timekeeper, ts);
> >>-	timekeeper.wall_to_monotonic =
> >>-				timespec_sub(timekeeper.wall_to_monotonic, *ts);
> >>+	tk_set_wall_to_mono(&timekeeper,
> >>+			timespec_sub(timekeeper.wall_to_monotonic, *ts));
> >There's a *lot* of unnecessary ugliness here and in many other
> >places in kernel/time/ due to repeating patterns of
> >"timekeeper.", which gets repeated many times and blows up line
> >length.
> >
> >Please add this to the highest level (system call, irq handler,
> >etc.) code:
> >
> >	struct timekeeper *tk = &timekeeper;
> >
> >and pass that down to lower levels. The tk-> pattern will be the
> >obvious thing to type in typical time handling functions.
> >
> >This increases readability and clarifies the data flow and might
> >bring other advantages in the future.
> 
> Sounds good. Are you ok if this is done in a follow-on patch?

Yeah, sure - the code is going in the right direction in 
general, so no hurry.

Thanks,

	Ingo
