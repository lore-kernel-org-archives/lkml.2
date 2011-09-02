Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab1IBJaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:30:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44162 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1IBJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:30:50 -0400
Date: Fri, 2 Sep 2011 11:30:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
In-Reply-To: <1314661157-22173-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109021120450.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Now this is the main reason I wrote the whole patchkit: previously
> there was no limit on the maximum number of POSIX timers a process
> could allocate.  This limits the amount of unswappable kernel memory
> a process can pin down this way.
> 
> With the POSIX timer ids being per process we can do this limit
> per process now without allowing one process DoSing another.
> 
> I implemented it as a sysctl, not a rlimit for now, because
> there was no clear use case for rlimit.

rlimit please.

>  /*
>   * we assume that the new SIGEV_THREAD_ID shares no bits with the other
>   * SIGEV values.  Here we put out an error if this assumption fails.
> @@ -572,6 +574,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>  
>  	it_id_set = IT_ID_SET;
>  	new_timer->it_id = (timer_t) new_timer_id;
> +
> +	if (new_timer_id >= sysctl_max_posix_timers) {
> +		error = -EMFILE;  /* better error? */

EPERM might work as well

Thanks,

	tglx
