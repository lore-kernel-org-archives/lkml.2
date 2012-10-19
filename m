Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2JSX6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:58:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2JSX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:58:19 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Krzysztof Halasa <khc@pm.waw.pl>, Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC] ARM: sched_clock: update epoch_cyc on resume
Organization: Deep Root Systems, LLC
References: <1342567672-29071-1-git-send-email-ccross@android.com>
	<CAGsJ_4z_tF3LKy-vygr=kwah7q7U03Y2K2XKAkZTB1QC2pSYmw@mail.gmail.com>
Date: Fri, 19 Oct 2012 16:58:36 -0700
In-Reply-To: <CAGsJ_4z_tF3LKy-vygr=kwah7q7U03Y2K2XKAkZTB1QC2pSYmw@mail.gmail.com>
	(Barry Song's message of "Tue, 24 Jul 2012 14:43:28 +0800")
Message-ID: <87r4ouggk3.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Barry Song <21cnbao@gmail.com> writes:

> 2012/7/18 Colin Cross <ccross@android.com>:
>> Many clocks that are used to provide sched_clock will reset during
>> suspend.  If read_sched_clock returns 0 after suspend, sched_clock will
>> appear to jump forward.  This patch resets cd.epoch_cyc to the current
>> value of read_sched_clock during resume, which causes sched_clock() just
>> after suspend to return the same value as sched_clock() just before
>> suspend.
>>
>> In addition, during the window where epoch_ns has been updated before
>> suspend, but epoch_cyc has not been updated after suspend, it is unknown
>> whether the clock has reset or not, and sched_clock() could return a
>> bogus value.  Add a suspended flag, and return the pre-suspend epoch_ns
>> value during this period.
>
> Acked-by: Barry Song <21cnbao@gmail.com>
>
> this patch should also fix the issue that:
> 1. launch some rt threads, rt threads sleep before suspend
> 2. repeat to suspend/resume
> 3. after resuming, waking up rt threads
>
> repeat 1-3 again and again, sometimes all rt threads will hang after
> resuming due to wrong sched_clock will make sched_rt think rt_time is
> much more than rt_runtime (default 950ms in 1s). then rt threads will
> lost cpu timeslot to run since the 95% threshold is there.

Re-visiting this in light of a related problem.

I've run into a similar issue where IRQ threads are prevented from
running during resume becase the RT throttling kicks because RT
runtime is accumulated during suspend.  Using the 'needs_suspend'
version fixes this problem too.

However, because of the RT throttling issue, it seems like *all*
platforms should be using the 'needs_suspend' version always.  But, as
already pointed out, that makes the timed printk output during
suspend/resume rather unhelpful.

Having to choose between useful printk times during suspend/resume and
functioning IRQ threads during suspend/resume isn't a choice I want to
make.   I'd rather have both.  Any ideas?

Kevin
