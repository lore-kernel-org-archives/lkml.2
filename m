Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2HAGwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 02:52:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48297 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2HAGwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 02:52:44 -0400
Date: Wed, 1 Aug 2012 08:52:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 1/2] [RFC] time: Fix problem with large timespecs &
 ktime_get_update_offsets
In-Reply-To: <1343716548-38742-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.02.1208010850510.32033@ionos>
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org> <1343716548-38742-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, John Stultz wrote:
> There's currently a slight difference in ktime_get_update_offsets()
> vs ktime_get() which can result in boot time crashes when booting
> with insane CMOS clock values larger then ~2264.
> 
> ktime_get() does basically the following:
>         return timespec_to_ktime(timespec_add(xtime, wall_to_monotonic))
> 
> Where as ktime_get_update_offsets does approximately:
>         return ktime_sub(timespec_to_ktime(xtime), realtime_offset);
> 
> The problem is, at boot we set xtime = year 8200 and
> wall_to_monotonic = year -8200,  ktime_get adds both values, mostly
> nulling the difference out (leaving only how long the system has been
> up), then converts that relatively small value to a ktime_t properly
> without losing any information.
> 
> ktime_get_update_offsets however, since it converts xtime (again set
> to some value greater then year 8200), to a ktime, it gets clamped at
> KTIME_MAX, then we subtract realtime_offset, which is _also_ clamped
> at KTIME_MAX, resulting in us always returning almost[1] zero. This
> causes us to stop expiring timers.
> 
> Now, one of the reasons Thomas and I changed the logic was that using
> the precalculated realtime_offset was slightly more efficient then
> re-adding xtime and wall_to_monotonic's components separately. But
> how valuable this unmeasured slight efficiency is vs extra
> robustness for crazy time values is questionable.
> 
> So switch back to the ktime_get implementation for
> ktime_get_update_offsets

NAK.

You're papering over the real problem: Using crap values without
sanity checking them in the first place.

All your patch does is papering over the problem. Heck, year 8200 is
obvious bullshit, so we can detect and reject it.

Thanks,

	tglx

 
