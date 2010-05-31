Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0EaTXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:23:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36418 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0EaTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:23:00 -0400
Message-ID: <4C040C98.8000105@vflare.org>
Date: Tue, 01 Jun 2010 00:53:04 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Support generic I/O requests
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org>	 <1274710685-2351-2-git-send-email-ngupta@vflare.org> <1275320471.15980.24.camel@barrios-desktop>
In-Reply-To: <1275320471.15980.24.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 05/31/2010 09:11 PM, Minchan Kim wrote:
> 
> On Mon, 2010-05-24 at 19:48 +0530, Nitin Gupta wrote:
<snip>
>>
>>  - Scalability: There is only one (per-device) de/compression
>> buffer stats. This can lead to significant contention, especially
>> when used for generic (non-swap) purposes.
> 
> Later, we could enhance it by per-cpu counter. 
> 

Yes, currently we effectively use just 1 core due to a single
compression buffer. So, per-cpu buffers and counters should
really help.
  
>> -static int handle_zero_page(struct bio *bio)
>> +static void handle_zero_page(struct page *page, u32 index)
> 
> It doesn't use index. 
>

Ok, I will remove this argument.
 
>>  
>> -	/* Page is stored uncompressed since it's incompressible */
>> -	if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED)))
>> -		return handle_uncompressed_page(rzs, bio);
>> +		/* Requested page is not present in compressed area */
>> +		if (unlikely(!rzs->table[index].page)) {
>> +			pr_debug("Read before write on swap device: "
>                                                          ^^^^
> It's not ramzswap any more. It is zram. :)
>

I will correct this :)

 
>> +		/*
>> +		 * Page is incompressible. Store it as-is (uncompressed)
>> +		 * since we do not want to return too many swap write
>> +		 * errors which has side effect of hanging the system.
>> +		 */
>> +		if (unlikely(clen > max_zpage_size)) {
>> +			clen = PAGE_SIZE;
>> +			page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
>> +			if (unlikely(!page_store)) {
>> +				mutex_unlock(&rzs->lock);
> 
> What's purpose of rzs->lock?
> Please, Document it. 
>


Ok. I intentionally deferred much of the documentation for later patches
to reduce "side noise" for these patches. Anyways, I will document this
lock in "v2" patches.
 
> And please, take care of "swap" mentioned in comments. 
> 

Old habits die hard :)  I will clean them up.

> I think code doesn't have big problem. 
> But my feel is we can clean up some portion of codes. But it's not a big
> deal. It doesn't have any problem to work. 
> So I want to add zram into linux-next, too. 
> 

I will be sending patch series with code commentary, cleanups and minor
fixes once this much enters linux-next.

Thanks for the review.
Nitin
