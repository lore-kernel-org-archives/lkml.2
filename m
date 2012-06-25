Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2FYSuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:50:08 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:45525 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2FYSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:50:06 -0400
Message-ID: <4FE8B2D1.3070600@corelatus.se>
Date: Mon, 25 Jun 2012 20:49:53 +0200
From: Thomas Lange <thomas@corelatus.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
References: <4FE74F1B.6070803@corelatus.se>	 <1340617541.2507.50.camel@laptop> <1340620706.2507.51.camel@laptop>
In-Reply-To: <1340620706.2507.51.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-25 12:38, Peter Zijlstra wrote:
> On Mon, 2012-06-25 at 11:45 +0200, Peter Zijlstra wrote:
>> On Sun, 2012-06-24 at 19:32 +0200, Thomas Lange wrote:
>>> Bug was introduced in 2.6.35.12 and is still present in linux-2.6.35.y HEAD.
>>
>> Ok, so nobody cares about that.. what does something recent like 3.5-rc4
>> do?

I haven't tested yet. I will try to find the time to do that.

>> If that's fixed, find the patch that fixes it. If not, we'll have a
>> look.

Commit fe44d62 removed the if-clause that caused the problem. Most likely, this
solved the problem.

> 
> 
> If anything, I think something like the below ought to cure things.

I agree. Either we make sure that sched_clock() never wraps or if it wraps,
that it wraps shortly after boot to catch problems early.

> 
> ---
>  kernel/sched/clock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> index c685e31..a1a128a 100644
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -74,7 +74,7 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> +	return (unsigned long long)(get_jiffies_64() - INITIAL_JIFFIES)
>  					* (NSEC_PER_SEC / HZ);
>  }
>  EXPORT_SYMBOL_GPL(sched_clock);

/Thomas
