Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0CTHXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:23:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:34872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0CTHXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:23:16 -0400
Message-ID: <4BA44315.6030108@kernel.org>
Date: Sat, 20 Mar 2010 12:37:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LKML] Re: Infinite loop on boot in free_early_partial due to
 start==end on tip/master
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com> <20100319182807.GA14985@phenom.dumpdata.com> <4BA3CAB8.7000702@kernel.org> <1269027289.23584.0.camel@localhost.localdomain> <20100319200409.GE31908@phenom.dumpdata.com> <4BA3E9CD.70203@kernel.org>
In-Reply-To: <4BA3E9CD.70203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Mar 2010 07:22:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/20/2010 06:17 AM, Yinghai Lu wrote:
>>   #ifdef CONFIG_NO_BOOTMEM
>>   	u64 start = __pa(ptr);
>>   	u64 end = start + size;
>> -	free_early_partial(start, end);
>> +	if (start<  end)
>> +		free_early_partial(start, end);
>
> it seems we could remove this line
>
> Tejun, how this could happen? free zero range ?

Well, the generic code assumes that the arch free callback can handle
zero length free, so on rare cases where the amount of used percpu
area in the first chunk equals the unit size, it happily call
free_fn() with zero length expecting the free function to ignore it.
Hmmm... well, given that it's a arch dependent callback and occurrence
of zero length free would be fairly rare, I think it would be better
to make the generic code avoid calling free with zero length.

Does the following patch fix the problem?

diff --git a/mm/percpu.c b/mm/percpu.c
index 768419d..d8d3f70 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1929,7 +1929,9 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
  			}
  			/* copy and return the unused part */
  			memcpy(ptr, __per_cpu_load, ai->static_size);
-			free_fn(ptr + size_sum, ai->unit_size - size_sum);
+			if (ai->unit_size > size_sum)
+				free_fn(ptr + size_sum,
+					ai->unit_size - size_sum);
  		}
  	}

-- 
tejun
