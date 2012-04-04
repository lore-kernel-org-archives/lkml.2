Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2DDXPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:15:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2DDXPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:15:46 -0400
Message-ID: <4F7CD61E.8000609@wwwdotorg.org>
Date: Wed, 04 Apr 2012 17:15:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] regmap: add MMIO bus support
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org> <1333576113-13196-4-git-send-email-swarren@wwwdotorg.org> <20120404225915.GH10787@opensource.wolfsonmicro.com>
In-Reply-To: <20120404225915.GH10787@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 04:59 PM, Mark Brown wrote:
> On Wed, Apr 04, 2012 at 03:48:31PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> This is a basic memory-mapped-IO bus for regmap. It has the following
>> features and limitations:
> 
> I applied these up to here but it was painful as patch 2 didn't apply
> cleanly to -rc1 and git am couldn't find the blobs to use for
> resolution.  Please check things worked out OK but I'm pretty sure they
> did.

The result of merging your topic/mmio and for-next branches is the same
as my local copy of patch 4 I sent, modulo that my local copy still has
regmap_open_file(), but that's not related.

So yes, I think the patches applied fine.

>> * Registers themselves may be 8, 16, 32, or 64-bit. 64-bit is only
>>   supported on 64-bit platforms.
>> * Register offsets are limited to precisely 32-bit.
>> * IO is performed using readl/writel, with no provision for using the
>>   __raw_readl or readl_relaxed variants.
> 
> Also limited native endian register I/O.  It would have been much better
> to fix this in the core - please consider producing followup patches to
> push the code there, though it's far from essential.

I assume the solution here is to:

* Always use __raw_readl/__raw_writel in regmap-mmio.c so that there's
never any endianness conversion, and don't use the endianness conversion
macros when reading/writing the work buffer.
* Implement alternative formatters that format in LE instead of BE
* Add a field to regmap_config indicating which endianness the data
should be in, and use this flag to select the LE/BE formatters.

Does that sound about right?

>> +static int regmap_mmio_gather_write(void *context,
>> +				    const void *reg, size_t reg_size,
>> +				    const void *val, size_t val_size)
>> +{
>> +	struct regmap_mmio_context *ctx = context;
>> +	u32 offset;
>> +
>> +	if (reg_size != 4)
>> +		return -EIO;
> 
> Given that you constrain on registration too this should be BUG_ON(),
> we're seriously confused if we're specifying a different register size
> here and -EIO is going to be a bit obscure.

I wondered about that. I would have been quite happy to repost with that
change. Do you want an incremental patch?
