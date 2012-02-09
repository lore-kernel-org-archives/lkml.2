Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2BIRP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:15:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12965 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab2BIRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:15:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Feb 2012 09:15:54 -0800
Message-ID: <4F33FEE7.9080608@nvidia.com>
Date: Thu, 9 Feb 2012 22:44:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: add bulk_write() for non-volatile register
 set
References: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com> <20120209121704.GF3058@opensource.wolfsonmicro.com> <4F33BFDE.7020006@nvidia.com> <20120209125505.GI3058@opensource.wolfsonmicro.com>
In-Reply-To: <20120209125505.GI3058@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 February 2012 06:25 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 09, 2012 at 06:15:18PM +0530, Laxman Dewangan wrote:
>> On Thursday 09 February 2012 05:47 PM, Mark Brown wrote:
>>> On Thu, Feb 09, 2012 at 05:42:11PM +0530, Laxman Dewangan wrote:
>>>> +	if (vol || map->cache_type == REGCACHE_NONE) {
>>>> +		ret = _regmap_raw_write(map, reg, val, val_bytes * val_count);
>>> You still need to do the byte swap here.
>> I saw the regmap_raw_write() and it is using the same way without
>> byte swapping.
> That's the whole point with the difference between the bulk and raw APIs
> though, the raw API skips the byte swapping and the bulk does it.
>
Ok, re-going through the apis again about the byte swapping, what I 
understand is that raw_read or raw_write always happen in bing-endian 
regardless of cpu. And bulk read/write supported the data which is in 
the cpu-endianess.
So we need to convert the data from cpu_to_bexx if we want to call 
raw_write from bulk_write. Similarly we need to convert the data from 
bexx_to_cpu when we read from raw-read which is called from bulk_read().
If this is case then if we want the data in integer type from bulk_write 
data pointer then just memcpy will be fine like
unsigned int ival;
memcpy(&ival, bulk_val_ptr, val_bytes);
and for calling raw_write, it need to call format_val() so this will do 
byte swapping. This require to duplicate the data pointer to new pointer 
and then do manipulation. Once we do this then we will be able to call 
raw_write() with the new duplicated pointer.

if the register writes are broken in multiple transaction then only get 
the integer_val using memcpy and call regmap_write(), need not to format it.

This may be require mem alloc/free on every call. It can be avoided by 
allocating memory for size (val_bytes + max_register) in advance during 
init..
Is it correct?

>> Want to use the same function as it is.. I am not sure why do we
>> require byte-swapping in this case. Required things will be done by
>> _regmap_raw_write only.
> The byte swapping is important for any device which has more than 8 bit
> register values, it's only not an issue for you because you have 8 bit
> registers.
>
>> This api just break the transfer in register-wise if any of the
>> register is cached..
> Well, there's no fundamental reason why we can't support cache on raw
> operations too.  It's not implemented because there's no need for it
> with any current users rather than because it's impossible.
>
Now if we want to support the caching from raw-write then we need to 
either do caching first or device write first.
I am seeing one issue with this approach:
Whichever is first, if we do caching (which is in loop) and if it fails 
in between inside loop then we may not able to revert it
or it will be complicate to implement the reversal of old values.
Also if it is stored in cache first and later if write fails then also 
it will be difficult to revert it.

If above error is not the issue then possibly following is the solution:

- remove the warnings from raw-write...
- Let allow the reg_write as what it is already  there.
- Then parse input val pointer and put in cache register by register
                for (i = 0; i < val_len / map->format.val_bytes; i++) {
                   memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
                   ival = map->format.parse_val(map->work_buf);
                   ret = regcache_write(map, reg + i, ival);
                   if (ret != 0)
                       dev_warn("Unable to cache register %d\n", reg +i);
                }

It seems modifying raw_write() looks simple if we are able to ignore the 
caching error..
Let me know your opinion?

Thanks,
Laxman


>>>> +	} else {
>>>> +		for (i = 0; i<   val_count; i++) {
>>>> +			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
>>>> +			ival = map->format.parse_val(map->work_buf);
>>> They're currently symmetric but really this should use format_val().
>>>
>> The format_val is require integer argument and issue is that I dont
>> have this otherwise I need not to parse, can use directly.
>>
>> Am I missing something here?
>>
>>
>>> * Unknown Key
>>> * 0x6E30FDDD
> * Unknown Key
> * 0x6E30FDDD

