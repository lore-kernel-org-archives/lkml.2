Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1KPQeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:34:01 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1184 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755472Ab1KPQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:34:00 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7425
Message-ID: <4EC3E619.70503@metafoo.de>
Date: Wed, 16 Nov 2011 17:34:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 5/7] regmap: Check if a register is writable instead of
 readable in regcache_read
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-5-git-send-email-lars@metafoo.de> <20111116161631.GK29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116161631.GK29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:16 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 04:28:20PM +0100, Lars-Peter Clausen wrote:
> 
>> Currently regcache checks whether a register is readable when performing a
>> cached read and returns an error if not. Change this check to test whether the
>> register is writable. This makes more sense, since reading from the cache when
>> the register is not readable allows the operation described above, but if the
>> register is not writable there shouldn't  be a value for it in the cache anyway.
> 
> This logic doesn't entirely follow - one can have registers which are
> volatile but could be read once at startup.  Plus...

Hm? The use case here is chips which do not support readback. So we never
want to fallback to a hardware read but still want to be able to do a cached
read.

> 
>> @@ -206,7 +206,7 @@ int regcache_read(struct regmap *map,
>>  
>>  	BUG_ON(!map->cache_ops);
>>  
>> -	if (!regmap_readable(map, reg))
>> +	if (!regmap_writeable(map, reg))
>>  		return -EIO;
> 
> ...the code winds up just looking like an obvious bug.

Why? If a register is not writable we won't have anything in the cache for
it. So reading from the cache for a register which is not writable doesn't
make any sense.
