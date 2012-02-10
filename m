Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2BJJPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 04:15:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12222 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab2BJJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 04:15:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 Feb 2012 01:15:26 -0800
Message-ID: <4F34DFC7.3020208@nvidia.com>
Date: Fri, 10 Feb 2012 14:43:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: add bulk_write() for non-volatile register
 set
References: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com> <20120209121704.GF3058@opensource.wolfsonmicro.com> <4F33BFDE.7020006@nvidia.com> <20120209125505.GI3058@opensource.wolfsonmicro.com> <4F33FEE7.9080608@nvidia.com> <20120209181224.GK3058@opensource.wolfsonmicro.com>
In-Reply-To: <20120209181224.GK3058@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 February 2012 11:42 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 09, 2012 at 10:44:15PM +0530, Laxman Dewangan wrote:
>
>> If this is case then if we want the data in integer type from
>> bulk_write data pointer then just memcpy will be fine like
>> unsigned int ival;
>> memcpy(&ival, bulk_val_ptr, val_bytes);
>> and for calling raw_write, it need to call format_val() so this will
>> do byte swapping. This require to duplicate the data pointer to new
>> pointer and then do manipulation. Once we do this then we will be
>> able to call raw_write() with the new duplicated pointer.
> Indeed, taking a copy of the data and modifying it will do the trick.
>
So I am going to allocate buffer for some size, initially min(val_bytes 
* max_register, 128) bytes, and in bulk_write(), if require buffer is 
more than 128 then re-alloc buffer which is now (req_size + 128).
And then copy the data into this buffer, modify it and send to device.

>> This may be require mem alloc/free on every call. It can be avoided
>> by allocating memory for size (val_bytes + max_register) in advance
>> during init..
>> Is it correct?
> val_bytes * max_register, and obviously the worst case on that is rather
> large.
>
We can allocate dynamically now based on requirements, start with 
min(val_bytes * max_register, 128)..

I still think bulk_write will be helpful as it deals with cpu-endianness 
and it avoid reformatting of data.
Case if register is 16 bit wide then
u16 regvals[10];
setting regvals with the desired one is easy as
regvals[0] = xxxx
regvals[1] = yyyy

and then just call bulk_write(,,regvals,..)
The data will be stored in cpu endiness and will go to device in big 
endiness.
This will also make the sync with bulk_read.

But this should be in different patch.
>>> Well, there's no fundamental reason why we can't support cache on raw
>>> operations too.  It's not implemented because there's no need for it
>>> with any current users rather than because it's impossible.
>> Now if we want to support the caching from raw-write then we need to
>> either do caching first or device write first.
> Yes.
>
>> I am seeing one issue with this approach:
>> Whichever is first, if we do caching (which is in loop) and if it
>> fails in between inside loop then we may not able to revert it
>> or it will be complicate to implement the reversal of old values.
>> Also if it is stored in cache first and later if write fails then
>> also it will be difficult to revert it.
> I'm not overly worried about failed writes, they should essentially
> never happen and if they do happen we can always resync with the device
> by either reading the registers or discarding the cache (assuming we
> didn't completely loose track of the device).  Doing something really
> expensive isn't too bad for rare events, and practically speaking if we
> fail to write once we'll never succeed.
>
> Besides, when we do get an error we have no way of telling what exactly
> the hardware did - even if we see that it got an error on the nth byte
> we don't know if it might've done something with that before it
> complained or if there was damage to some of the earlier data too.
> Upper layers are going to have to implement recovery mechanisms if they
> want them.
>
Just for now, lets return error in this case so that client will take 
care of this.
>> - remove the warnings from raw-write...
>> - Let allow the reg_write as what it is already  there.
>> - Then parse input val pointer and put in cache register by register
>>                 for (i = 0; i<  val_len / map->format.val_bytes; i++) {
>>                    memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
>>                    ival = map->format.parse_val(map->work_buf);
>>                    ret = regcache_write(map, reg + i, ival);
>>                    if (ret != 0)
>>                        dev_warn("Unable to cache register %d\n", reg +i);
>>                 }
> Hrm, we also need to handle cache bypass and cache only in here - and
> for consistency with vanilla write we need to cache before write.
> Indeed, we'll need to push all the cache handling down into
> _regmap_raw_write() from regmap_reg_write() as that's where writes from
> regmap_reg_write() end up.
>
regmap_reg_write() supports format_write() case which does not ends with 
the  _regmap_raw_write() and so need to keep caching here without too 
much changes. However the caching on this function will be done only if 
there is format_write() otherwise not and hence it will be done in 
_regmap_raw_write().
I will send the patch for this.
