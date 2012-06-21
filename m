Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2FUBhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:37:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53755 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2FUBhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:37:36 -0400
X-AuditID: 9c930179-b7befae000006417-e5-4fe27adc6c81
Message-ID: <4FE27AE8.2080906@kernel.org>
Date: Thu, 21 Jun 2012 10:37:44 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm,gmane.linux.kernel.stable
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        gregkh@linuxfoundation.org, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, tim.bird@am.sony.com,
        frank.rowand@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com, aaditya.kumar@ap.sony.com
Subject: Re: [PATCH] mm: offlining memory may block forever
References: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
In-Reply-To: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 01:23 AM, Aaditya Kumar wrote:

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

Reviewed-by: Minchan Kim <minchan@kernel.org>

Nitpick: We can remove kthread_should_stop check earlier in kswapd_try_to_sleep.
         But it's no biggie. And I hope you change patch title 
	 
	 Title : Fix loss of kswapd wakeup in kswapd_stop
	 Description: Offlining memory may block forever because blah, blah, blah.

-- 
Kind regards,
Minchan Kim
