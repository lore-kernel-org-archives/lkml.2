Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1FUAr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:47:28 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42145 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab1FUAr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:47:26 -0400
Message-ID: <4DFFE9C1.5060003@metafoo.de>
Date: Tue, 21 Jun 2011 02:45:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register access
 API
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com> <4DFFD486.7020901@metafoo.de> <20110621001438.GD1905@opensource.wolfsonmicro.com>
In-Reply-To: <20110621001438.GD1905@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 02:14 AM, Mark Brown wrote:
> 
>>> +static void regmap_format_4_12_write(struct regmap *map,
>>> +				     unsigned int reg, unsigned int val)
>>> +{
>>> +	u16 *out = map->work_buf;
>>> +	*out = cpu_to_be16((reg << 12) | val);
>>> +}
> 
>>> +static void regmap_format_7_9_write(struct regmap *map,
>>> +				    unsigned int reg, unsigned int val)
>>> +{
>>> +	u16 *out = map->work_buf;
>>> +	*out = cpu_to_be16((reg << 9) | val);
>>> +}
> 
>> It would make sense to keep val_bits around and implement these two generically:
>> 	*out = cpu_to_be16((reg << map->format.val_bits) | val);
> 
> I'm not sure it's worth it for the two cases we know about, and as with
> passing the map into these I like keeping the byte oriented assumption
> in the interfaces as much as possible as it makes things easier to think
> about.

Hm, ok I guess we can wait with this until there are actually other similar
formats which follow this scheme.

> 
>>> +struct regmap *regmap_init(struct device *dev, struct regmap_config *config)
> 
>> regmap_alloc would in my opinion be a better name.
> 
> I like init, especially considering the plan to add cache support as
> there's more work in setting that up once you start doing the advanced
> caches.

If you take a look at other kernel apis _alloc is usually used if the structure
is allocated (and initialized) inside the function and _init is used when the
function initializes an already existing structure. And it also matches better
with regmap_free.

> 
>>> +	/*
>>> +	 * Some buses flag reads by setting the high bit in the
>>> +	 * register addresss; since it's always the high bit for all
>>> +	 * current formats we can do this here rather than in
>>> +	 * formatting.  This may break if we get interesting formats.
>>> +	 */
>>> +	if (map->bus->read_flag_in_reg)
>>> +		u8[0] |= 0x80;
> 
>> This is rather specific. Making this a per device mask or bit offset, would
>> make more sense in my opinion. I have for example one SPI codec device which
>> uses the 7th bit to indicate a read. And I also have devices on a custom bus,
> 
> Can you say what device this is?  I'm just going on the devices we've
> seen in the kernel so far here...  Still easy enough to do.
> 

The ad1836 for example really only uses 10 bits for data instead of 12.
The 11th bit is reserved and the 12th bit is used to indicate whether it is an
read or write. Though since gaps between register and data are not supported
data was made 12 bits wide and the upper 2 bits are always set to 0.

The adav801, which is going to be submitted upstream soon, uses a similar
scheme. First seven bits are register address, then 1 bit which indicates
read/write and then 8 bits data. We are currently using the same trick here and
made data 9 bits wide.

>>> +struct regmap_config {
>>> +	int reg_bits;
>>> +	int val_bits;
> 
>> size_t for both?
> 
> It doesn't seem particularly appropriate as we're working with a bit
> count not the usual byte count where size_t gets used and I can't see it
> ever making any difference.

I suggested it because the byte count in the regmap_format struct is size_t and
it calculated from the bit count.
