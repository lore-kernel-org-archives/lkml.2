Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab2FTStU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:49:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab2FTStS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:49:18 -0400
Message-ID: <4FE21B21.6070608@jp.fujitsu.com>
Date: Wed, 20 Jun 2012 14:49:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: aaditya.kumar.30@gmail.com
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        gregkh@linuxfoundation.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, mhocko@suse.cz,
        tim.bird@am.sony.com, frank.rowand@am.sony.com,
        takuzo.ohara@ap.sony.com, kan.iibuchi@jp.sony.com,
        aaditya.kumar@ap.sony.com
Subject: Re: [PATCH] mm: offlining memory may block forever
References: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
In-Reply-To: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2012 12:23 PM, Aaditya Kumar wrote:
> Offlining memory may block forever, waiting for kswapd() to wake up because
> kswapd() does not check the event kthread->should_stop before sleeping.
> 
> The proper pattern, from Documentation/memory-barriers.txt, is:
>    ---  waker  ---
>    event_indicated = 1;
>    wake_up_process(event_daemon);
> 
>    ---  sleeper  ---
>    for (;;) {
>       set_current_state(TASK_UNINTERRUPTIBLE);
>       if (event_indicated)
>          break;
>       schedule();
>    }
> 
>    set_current_state() may be wrapped by:
>       prepare_to_wait();
> 
> In the kswapd() case, event_indicated is kthread->should_stop.
> ---  offlining memory (waker)  ---

Please avoid "---". This is used for a separator between a patch
description and code.

Other than that,
 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


>    kswapd_stop()
>       kthread_stop()
>          kthread->should_stop = 1
>          wake_up_process()
>          wait_for_completion()
> 
> 
> ---  kswapd_try_to_sleep (sleeper)  ---
>    kswapd_try_to_sleep()
>       prepare_to_wait()
>            .
>            .
>       schedule()
>            .
>            .
>       finish_wait()
> 
>    The schedule() needs to be protected by a test of kthread->should_stop,
>    which is wrapped by kthread_should_stop().
> 
> Reproducer:
>    Do heavy file I/O in background.
>    Do a memory offline/online in a tight loop
> 
> 
> Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
> 
> ---
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index eeb3bc9..b60691e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2688,7 +2688,10 @@ static void kswapd_try_to_sleep(pg_data_t
> *pgdat, int order, int classzone_idx)
>  		 * them before going back to sleep.
>  		 */
>  		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
> -		schedule();
> +
> +		if (!kthread_should_stop())
> +			schedule();
> +
>  		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
>  	} else {
>  		if (remaining)
> 

