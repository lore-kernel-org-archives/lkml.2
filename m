Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1KKMUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:20:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65199 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1KKMUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:20:24 -0500
Message-ID: <4EBD1303.9040402@gmail.com>
Date: Fri, 11 Nov 2011 13:20:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
References: <4EB98A83.3040101@linux.vnet.ibm.com> <4EBA75F2.4080800@linux.vnet.ibm.com> <20111109155342.GA1260@google.com> <20111109165201.GI5075@redhat.com> <20111109165925.GC1260@google.com> <20111109170248.GD1260@google.com> <20111109172942.GJ5075@redhat.com> <20111109180900.GF1260@google.com> <20111109181925.GN5075@redhat.com> <20111109183447.GG1260@google.com> <20111109194047.GO5075@redhat.com>
In-Reply-To: <20111109194047.GO5075@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 08:40 PM, Andrea Arcangeli wrote:
> On Wed, Nov 09, 2011 at 10:34:47AM -0800, Tejun Heo wrote:
>> know.  My instinct tells me to strongly recommend use of
>> wait_event_freezable_timeout() and run away.  :)
> 
> Passing false wasn't so appealing to me but ok. Jiri can you test this
> with some suspend? (beware builds but untested)
> 
> ===
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: thp: reduce khugepaged freezing latency
> 
> Use wait_event_freezable_timeout() instead of
> schedule_timeout_interruptible() to avoid missing freezer wakeups. A
> try_to_freeze() would have been needed in the
> khugepaged_alloc_hugepage tight loop too in case of the allocation
> failing repeatedly, and wait_event_freezable_timeout will provide it
> too.
> 
> khugepaged would still freeze just fine by trying again the next
> minute but it's better if it freezes immediately.
> 
> Reported-by: Jiri Slaby <jslaby@suse.cz>

Tested-by: Jiri Slaby <jslaby@suse.cz>

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  mm/huge_memory.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4298aba..fd925d0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2259,12 +2259,9 @@ static void khugepaged_do_scan(struct page **hpage)
>  
>  static void khugepaged_alloc_sleep(void)
>  {
> -	DEFINE_WAIT(wait);
> -	add_wait_queue(&khugepaged_wait, &wait);
> -	schedule_timeout_interruptible(
> -		msecs_to_jiffies(
> -			khugepaged_alloc_sleep_millisecs));
> -	remove_wait_queue(&khugepaged_wait, &wait);
> +	wait_event_freezable_timeout(khugepaged_wait, false,
> +				     msecs_to_jiffies(
> +					     khugepaged_alloc_sleep_millisecs));
>  }
>  
>  #ifndef CONFIG_NUMA
> @@ -2313,14 +2310,11 @@ static void khugepaged_loop(void)
>  		if (unlikely(kthread_should_stop()))
>  			break;
>  		if (khugepaged_has_work()) {
> -			DEFINE_WAIT(wait);
>  			if (!khugepaged_scan_sleep_millisecs)
>  				continue;
> -			add_wait_queue(&khugepaged_wait, &wait);
> -			schedule_timeout_interruptible(
> +			wait_event_freezable_timeout(khugepaged_wait, false,
>  				msecs_to_jiffies(
>  					khugepaged_scan_sleep_millisecs));
> -			remove_wait_queue(&khugepaged_wait, &wait);
>  		} else if (khugepaged_enabled())
>  			wait_event_freezable(khugepaged_wait,
>  					     khugepaged_wait_event());

thanks,
-- 
js
