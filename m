Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab0HJFcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 01:32:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43576 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0HJFcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 01:32:32 -0400
Message-ID: <4C60E48A.5090608@vflare.org>
Date: Tue, 10 Aug 2010 11:02:58 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] Use percpu buffers
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-5-git-send-email-ngupta@vflare.org> <AANLkTin7_fKxTzE2rngh1Ew5Ss8F_Aw0s9Gz6ySug6SX@mail.gmail.com> <4C60D9E6.3050700@vflare.org> <4C60DE0E.2000707@kernel.org>
In-Reply-To: <4C60DE0E.2000707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/10/2010 10:35 AM, Pekka Enberg wrote:
> On 10.8.2010 7.47, Nitin Gupta wrote:
>> On 08/10/2010 12:27 AM, Pekka Enberg wrote:
>>> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta<ngupta@vflare.org>  wrote:
>>>> @@ -303,38 +307,41 @@ static int zram_write(struct zram *zram, struct bio *bio)
>>>>                                 zram_test_flag(zram, index, ZRAM_ZERO))
>>>>                         zram_free_page(zram, index);
>>>>
>>>> -               mutex_lock(&zram->lock);
>>>> +               preempt_disable();
>>>> +               zbuffer = __get_cpu_var(compress_buffer);
>>>> +               zworkmem = __get_cpu_var(compress_workmem);
>>>> +               if (unlikely(!zbuffer || !zworkmem)) {
>>>> +                       preempt_enable();
>>>> +                       goto out;
>>>> +               }
>>> The per-CPU buffer thing with this preempt_disable() trickery looks
>>> overkill to me. Most block device drivers seem to use mempool_alloc()
>>> for this sort of thing. Is there some reason you can't use that here?
>>>
>> Other block drivers are allocating relatively small structs using
>> mempool_alloc(). However, in case of zram, these buffers are quite
>> large (compress_workmem is 64K!). So, allocating them on every write
>> would probably be much slower than using a pre-allocated per-cpu buffer.
> The mempool API is precisely for that - using pre-allocated buffers instead of allocating every time. The preempt_disable() games make the code complex and have the downside of higher scheduling latencies so why not give mempools a try?
> 

mempool_alloc() first calls alloc_fn with ~(__GFP_WAIT | __GFP_IO)
and *then* falls down to pre-allocated buffers. So, it will always
be slower than directly using pre-allocated buffers as is done
currently.

One trick we can use is to have alloc_fn such that it always returns
failure with ~__GFP_WAIT and do actual allocation otherwise. But still
it seems like unnecessary cost.

Thanks,
Nitin
 


