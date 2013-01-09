Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab3AIVhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:37:05 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39615 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281Ab3AIVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:37:02 -0500
Message-ID: <50EDE2FA.3060308@kernel.org>
Date: Wed, 09 Jan 2013 21:36:58 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
References: <1357752671-30222-1-git-send-email-lars@metafoo.de> <50EDC309.5010104@kernel.org> <50EDD96A.5080900@metafoo.de>
In-Reply-To: <50EDD96A.5080900@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 08:56 PM, Lars-Peter Clausen wrote:
> On 01/09/2013 08:20 PM, Jonathan Cameron wrote:
>> On 01/09/2013 05:31 PM, Lars-Peter Clausen wrote:
>>> Quite often the pattern used for setting up and transferring a synchronous SPI
>>> transaction looks very much like the following:
>>>
>>> 	struct spi_message msg;
>>> 	struct spi_transfer xfers[] = {
>>> 		...
>>> 	};
>>>
>>> 	spi_message_init(&msg);
>>> 	spi_message_add_tail(&xfers[0], &msg);
>>> 	...
>>> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
>>>
>>> 	ret = spi_sync(&msg);
>>>
>>> This patch adds two new helper functions for handling this case. The first
>>> helper function spi_message_init_with_transfers() takes a spi_message and an
>>> array of spi_transfers. It will initialize the message and then call
>>> spi_message_add_tail() for each transfer in the array. E.g. the following
>>>
>>> 	spi_message_init(&msg);
>>> 	spi_message_add_tail(&xfers[0], &msg);
>>> 	...
>>> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
>>>
>>> can be rewritten as
>>>
>>> 	spi_message_init_with_transfers(&msg, xfers, ARRAY_SIZE(xfers));
>>>
>>> The second function spi_sync_transfer() takes a SPI device and an array of
>>> spi_transfers. It will allocate a new spi_message (on the stack) and add all
>>> transfers in the array to the message. Finally it will call spi_sync() on the
>>> message.
>>>
>>> E.g. the follwing
>>>
>>> 	struct spi_message msg;
>>> 	struct spi_transfer xfers[] = {
>>> 		...
>>> 	};
>>>
>>> 	spi_message_init(&msg);
>>> 	spi_message_add_tail(&xfers[0], &msg);
>>> 	...
>>> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
>>>
>>> 	ret = spi_sync(spi, &msg);
>>>
>>> can be rewritten as
>>>
>>> 	struct spi_transfer xfers[] = {
>>> 		...
>>> 	};
>>>
>>> 	ret = spi_sync_transfer(spi, xfers, ARRAY_SIZE(xfers));
>>>
>>> The patch also adds a new cocci script which can detect such sequences as
>>> described above and transform them automatically to use the new helper
>>> functions.
>>>
>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>
>> Principle looks good to me and some nice little duplication removal
>> savings.
>>
>> My coccinelle isn't really up to checking that, but for the functions
>> Acked-by: Jonathan Cameron <jic23@kernel.org>
>>
>> When all comments are in on the code we'll have to think about how to
>> merge this.  If you have much else planned that will hit those iio drivers
>> then things will get uggly unless it goes through that tree.
>>
>> Guess it all depends on whether others like the patch though ;)
> 
> The IIO patches can easily wait another release until the spi has made it's way
> up into mainline. I just didn't want to send out the helper functions without
> any realworld examples on how they can be used.
> 
Good point, though obviously send them again after this patch has merged
given the fine nature of my memory ;)
