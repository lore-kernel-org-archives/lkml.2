Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1IIJgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:36:42 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:58385 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1IIJgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:36:40 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E69E019.6060601@cam.ac.uk>
Date: Fri, 09 Sep 2011 10:44:57 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Support half writes and padding between register
 and value.
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk> <1315490964-25718-2-git-send-email-jic23@cam.ac.uk> <20110908162715.GB3098@opensource.wolfsonmicro.com>
In-Reply-To: <20110908162715.GB3098@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/11 17:27, Mark Brown wrote:
> On Thu, Sep 08, 2011 at 03:09:23PM +0100, Jonathan Cameron wrote:
> 
>> Note half writes currently assume address numbers are even only.
>> That's a pain for caching so other suggestions welcome.  I could set
>> it as a 7 bit address and increase the padding to 9 bits.  That makes
>> the write bit a little strange though as it will be going into the
>> padding.
> 
> This needs more documentation somewhere explaining what a half write is
> and/or a better name for half write but doesn't look too invasive so I
> think this approach can work.  If we come up with something better later
> then we can always change things, there shouldn't be too many users to
> update if that happens.
Agreed. I'll document it thoroughly and explain the restricted use case.
> 
>> -	map->format.reg_bytes = config->reg_bits / 8;
>> +	map->format.buf_size = (config->reg_bits +
>> +				config->reg_pad_bits +
>> +				config->val_bits) / 8;
>> +	map->format.reg_bytes = (config->reg_bits + config->reg_pad_bits)/ 8;
> 
> Please do a patch adding padding separately - that does seem like a
> useful thing to have in general, with the option of having it both
> before and after the register.
Happy to do it separately, but not sure the padding before the register
address is a real use case.  You pad after to give the device time to
respond, before doesn't make much sense to me on a register based device...
I'll change the naming to make it explicit that it is after the register though
so as to leave room for this to be added in future.

> 
>> -	if (val == map->work_buf + map->format.reg_bytes)
>> -		ret = map->bus->write(map->dev, map->work_buf,
>> -				      map->format.reg_bytes + val_len);
>> -	else if (map->bus->gather_write)
>> +	if (val == map->work_buf + map->format.reg_bytes) {
>> +		if (map->format.half_write) {
>> +			ret = map->bus->write(map->dev, map->work_buf,
>> +					      (map->format.reg_bytes +
>> +					       val_len) >> 1);
>> +			if (ret >= 0)
>> +				ret = map->bus->write(map->dev,
>> +						      map->work_buf +
>> +						      ((map->format.reg_bytes +
>> +							val_len) >> 1),
>> +						      (map->format.reg_bytes +
>> +						       val_len) >> 1);
>> +		} else {
>> +			ret = map->bus->write(map->dev, map->work_buf,
>> +					      map->format.reg_bytes + val_len);
>> +		}
> 
> This code is getting very complicated...  I think it'd be clearer to
> have a special case at the head of the function that does the half write
> stuff.  It also feels like the half bit needs parameterisation, but I
> can't immediately think of how to do that sensibly.
Likewise. It's a very specific case. In theory there are two parameters that
I can think of.

write_length (bits per write)
address_mangler (one for each write needed?)

I'll clean it up and repost.
> 

