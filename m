Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab2EOBiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:38:07 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39532 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2EOBiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:38:05 -0400
Message-ID: <4FB1B37A.5050501@gmail.com>
Date: Mon, 14 May 2012 21:38:02 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com> <871umsdbm0.fsf@rustcorp.com.au> <4FAB2B5B.4020902@gmail.com> <87vck4bppw.fsf@rustcorp.com.au> <4FAB6363.4080808@gmail.com> <87zk9btqmu.fsf@rustcorp.com.au>
In-Reply-To: <87zk9btqmu.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This code still slow than original. when calling reclaim path, new allocation is almost always
>> fail. then, your code almost always invoke all cpu batch invalidation. i.e. many ipi.
>
> I don't know this code.  Does that happen often?Do we really need to
> optimize the out-of-memory path?

we don't need optimize out-of-memory path. but it's not out-of-memory path. our reclaim code
has two steps 1) purge small file cache (try_to_free_pages) 2) get new page (get_page_from_freelist).
but if you have smp box, it's racy. To success 1) doesn't guarantee to success 2). then, drain_all_pages()
is called frequently than you expected.



> But I should have used on_each_cpu_cond() helper which does this for us
> (except it falls back to individial IPIs) which would make this code
> neater.

Ah, yes. that definitely makes sense.


>>>> 2) When CONFIG_CPUMASK_OFFSTACK=n and NR_CPUS is relatively large, cpumask on stack may
>>>> cause stack overflow. because of, alloc_pages() can be called from
>>>> very deep call stack.
>>>
>>> You can't have large NR_CPUS without CONFIG_CPUMASK_OFFSTACK=y,
>>> otherwise you'll get many other stack overflows, too.
>>
>> Original code put cpumask bss instead stack then. :-)
>
> Yes, and this is what it looks like if we convert it directly, but I
> still don't want to encourage people to do this :(
>
> Cheers,
> Rusty.
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1179,7 +1179,7 @@ void drain_all_pages(void)
>   	 * Allocate in the BSS so we wont require allocation in
>   	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
>   	 */
> -	static cpumask_t cpus_with_pcps;
> +	static DECLARE_BITMAP(cpus_with_pcps, NR_CPUS);
>
>   	/*
>   	 * We don't care about racing with CPU hotplug event
> @@ -1197,11 +1197,12 @@ void drain_all_pages(void)
>   			}
>   		}
>   		if (has_pcps)
> -			cpumask_set_cpu(cpu,&cpus_with_pcps);
> +			cpumask_set_cpu(cpu, to_cpumask(cpus_with_pcps));
>   		else
> -			cpumask_clear_cpu(cpu,&cpus_with_pcps);
> +			cpumask_clear_cpu(cpu, to_cpumask(cpus_with_pcps));
>   	}
> -	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
> +	on_each_cpu_mask(to_cpumask(cpus_with_pcps),
> +			 drain_local_pages, NULL, 1);
>   }

Looks good to me. thanks.

   Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





