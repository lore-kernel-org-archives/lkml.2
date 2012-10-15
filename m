Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2JOWFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:05:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51953 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:05:09 -0400
Message-ID: <507C888C.7040903@gmail.com>
Date: Tue, 16 Oct 2012 09:05:00 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/6 v3] gpio: Add a block GPIO API to gpiolib
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-2-git-send-email-stigge@antcom.de> <507B9D05.1000204@gmail.com> <507C45EF.7080203@antcom.de>
In-Reply-To: <507C45EF.7080203@antcom.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/12 04:20, Roland Stigge wrote:
> Hi Ryan,
> 
> thank you for your feedback, I will include it, except for some points
> noted below:

>>> +		gbc->mask |= BIT(bit);
>>> +
>>> +		/* collect gpios that are specified together, represented by
>>> +		 * neighboring bits
>>> +		 */
>>> +		remap = &gbc->remap[gbc->nremap - 1];
>>
>> This looks broken. If gbc was re-alloced above (index < 0) then
>> gbc->remap == NULL and this will oops?
> 
> No, because I took care that even though index can be < 0, the resulting
> pointer is never dereferenced for -1.

Ah, I see. I think its a bit non-obvious and flaky though, since it
looks like you are both dereferencing a potentially NULL pointer, and
indexing an array with -1.

Even changing it to this I think makes it a bit more clear:

	if (gbc->remap == 0 ||
            bit - i != gbc->remap[gbc->nremap - 1].offset)
		gbc->nremap++;
		gbc->remap = krealloc(...);
		...

If you want to keep your way, at the very least I think it deserves a
comment, since it is easy to misread.

>> The remap functionality isn't very well explained
> 
> Documenting now in gpio.h like this:
> 
> /*
>  * struct gpio_remap - a structure for describing a bit mapping
>  * @mask:       a bit mask
>  * @offset:     how many bits to shift to the left (negative: to the
>  *              right)
>  *
>  * When we are mapping bit values from one word to another (here: from
>  * GPIO block domain to GPIO driver domain), we first mask them out
>  * with mask and shift them as specified with offset. More complicated
>  * mappings are done by grouping several of those structs and adding
>  * the results together.
>  */
> struct gpio_remap {
>         int     mask;
>         int     offset;
> };

Looks good. Thanks.

> If you find an issue, please let me know. Works fine for me. Have you
> tried? :-)

No, I was just looking at the code, and misread it.

>>> +unsigned gpio_block_get(const struct gpio_block *block)
>>> +{
>>> +	struct gpio_block_chip *gbc;
>>> +	int i, j;
>>> +	unsigned values = 0;
>>> +
>>> +	for (i = 0; i < block->nchip; i++) {
>>> +		unsigned remapped = 0;
>>> +
>>> +		gbc = &block->gbc[i];
>>> +
>>> +		if (gbc->gc->get_block) {
>>> +			remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
>>> +		} else { /* emulate */
>>> +			unsigned bit = 1;
>>> +
>>> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
>>> +				if (gbc->mask & bit)
>>
>> A proper bitmask might be more ideal for this. It would remove the
>> sizeof(unsigned) restriction and allow you to use for_each_set_bit for
>> these loops.
> 
> In a previous version of these patches, I actually had a generic bit
> mask which was in turn awkward to handle, especially for the bit
> remapping. Stijn brought me to the idea that for pragmatic reasons, 32
> bit access is fully sufficient in most cases.
> 
> I also needed userland access (via sysfs), so there was no way of
> accessing a block except via an int.
> 
> When there are GPIO drivers where we seriously need (and can handle
> simultaneously) more than 32 bits, we can still extend the API. For now,
> the cases where it is used is typically creating 8/16/32 bit busses with
> GPIO lines, and on 64bit architectures even 64bit busses.
> 
> For this, the current API is working fine, even enabling userland access
> via sysfs.

Fair enough. I didn't see the first round of patches. You probably can
still use for_each_set_bit though (maybe convert the mask to unsigned
long first to match the bitops API):

	for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
		...

>>> +			unsigned bit = 1;
>>> +
>>> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
>>> +				if (gbc->mask & bit)
>>> +					gbc->gc->set(gbc->gc, gbc->gc->base + j,
>>> +						     (remapped >> j) & 1);
>>> +			}
>>
>> This doesn't clear pins which are set to zero?
> 
> It does. gbc->mask only masks which bits to set and clear. remapped
> contains the actual bit values to set. 0 or 1.

Ugh, for some reason I was thinking that the gpio set function only
drove bits that were set in the mask (and had an analogous clear
function). Ignore me :-).

~Ryan

