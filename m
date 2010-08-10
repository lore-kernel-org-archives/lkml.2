Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0HJHgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:36:44 -0400
Received: from freeflow.nu ([178.79.134.28]:43858 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0HJHgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:36:39 -0400
Message-ID: <4C610184.7070909@kernel.org>
Date: Tue, 10 Aug 2010 10:36:36 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: ngupta@vflare.org, jaxboe@fusionio.com
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] Use percpu buffers
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-5-git-send-email-ngupta@vflare.org> <AANLkTin7_fKxTzE2rngh1Ew5Ss8F_Aw0s9Gz6ySug6SX@mail.gmail.com> <4C60D9E6.3050700@vflare.org> <4C60DE0E.2000707@kernel.org> <4C60E48A.5090608@vflare.org>
In-Reply-To: <4C60E48A.5090608@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On 8/10/10 8:32 AM, Nitin Gupta wrote:
> Other block drivers are allocating relatively small structs using
>>> mempool_alloc(). However, in case of zram, these buffers are quite
>>> large (compress_workmem is 64K!). So, allocating them on every write
>>> would probably be much slower than using a pre-allocated per-cpu buffer.
>>>        
>> The mempool API is precisely for that - using pre-allocated buffers instead of allocating every time. The preempt_disable() games make the code complex and have the downside of higher scheduling latencies so why not give mempools a try?
>>      
> mempool_alloc() first calls alloc_fn with ~(__GFP_WAIT | __GFP_IO)
> and *then* falls down to pre-allocated buffers. So, it will always
> be slower than directly using pre-allocated buffers as is done
> currently.
>
> One trick we can use is to have alloc_fn such that it always returns
> failure with ~__GFP_WAIT and do actual allocation otherwise. But still
> it seems like unnecessary cost.
>    
We can always extend the mempool API with mempool_prealloc() function if 
that turns out to be a problem. The per-CPU buffer with 
preempt_disable() trickery isn't really the proper thing to do here. It 
doesn't make much sense to disable preemption for compression that's 
purely CPU bound.

                     Pekka
