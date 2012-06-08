Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab2FHDZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:25:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41104 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2FHDZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:25:34 -0400
Message-ID: <4FD170AA.10705@gmail.com>
Date: Thu, 07 Jun 2012 23:25:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
References: <20120601122118.GA6128@lizard> <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/1/12 8:24 AM), Anton Vorontsov wrote:
> We'll need to use smp_function_call() in the sampling routines, and the
> call is not supposed to be called from the bottom halves. So, let's
> convert vmevent to dffered workqueues.
> 
> As a side effect, we also fix the swap reporting (we cannot call
> si_swapinfo from the interrupt context), i.e. the following oops should
> be fixed now:
> 
>   =================================
>   [ INFO: inconsistent lock state ]
>   3.4.0-rc1+ #37 Not tainted
>   ---------------------------------
>   inconsistent {SOFTIRQ-ON-W} ->  {IN-SOFTIRQ-W} usage.
>   swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>    (swap_lock){+.?...}, at: [<ffffffff8110449d>] si_swapinfo+0x1d/0x90
>   {SOFTIRQ-ON-W} state was registered at:
>     [<ffffffff8107ca7f>] mark_irqflags+0x15f/0x1b0
>     [<ffffffff8107e5e3>] __lock_acquire+0x493/0x9d0
>     [<ffffffff8107f20e>] lock_acquire+0x9e/0x200
>     [<ffffffff813e9071>] _raw_spin_lock+0x41/0x50
>     [<ffffffff8110449d>] si_swapinfo+0x1d/0x90
>     [<ffffffff8117e7c8>] meminfo_proc_show+0x38/0x3f0
>     [<ffffffff81141209>] seq_read+0x139/0x3f0
>     [<ffffffff81174cc6>] proc_reg_read+0x86/0xc0
>     [<ffffffff8111c19c>] vfs_read+0xac/0x160
>     [<ffffffff8111c29a>] sys_read+0x4a/0x90
>     [<ffffffff813ea652>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Anton Vorontsov<anton.vorontsov@linaro.org>

As I already told you, vmevent shouldn't deal a timer at all. It is
NOT familiar to embedded world. Because of, time subsystem is one of
most complex one on linux. Our 'time' is not simple concept. time.h
says we have 5 possibilities user want, at least.

include/linux/time.h
------------------------------------------
#define CLOCK_REALTIME			0
#define CLOCK_MONOTONIC			1
#define CLOCK_MONOTONIC_RAW		4
#define CLOCK_REALTIME_COARSE		5
#define CLOCK_MONOTONIC_COARSE		6

And, some people want to change timer slack for optimize power 
consumption.

So, Don't reinventing the wheel. Just use posix tiemr apis.







