Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2GBPkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:40:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54695 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GBPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:40:11 -0400
Message-ID: <4FF1C0D6.3010108@wwwdotorg.org>
Date: Mon, 02 Jul 2012 09:40:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v2] regulator: fixed: support deferred probe for DT GPIOs
References: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org> <20120701182300.GE28922@opensource.wolfsonmicro.com>
In-Reply-To: <20120701182300.GE28922@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 12:23 PM, Mark Brown wrote:
> On Fri, Jun 29, 2012 at 10:33:15AM -0600, Stephen Warren wrote:
> 
>> of_get_named_gpio() needs the driver hosting the GPIO that the
>> DT property references to have been probed. Detect this specific
>> failure, and defer the probe of the whole regulator until this
>> API can complete.
> 
> I've applied this but...

Thanks.

>> +	/* +	 * of_get_named_gpio() currently returns ENODEV rather
>> than +	 * EPROBE_DEFER. This code attempts to be compatible with
>> both +	 * for now; the ENODEV check can be removed once the API
>> is fixed.
> 
> ...this just seems rubbish, why aren't we just fixing the device
> tree code and why are we doing this at the device tree level rather
> than as a general gpiolib thing?

It is being fixed in the DT code:

https://lkml.org/lkml/2012/6/18/468

However, it seemed best to make the regulator code work both before
and after that patch.

This issue can't be fixed only in gpio_request(); of_get_named_gpio()
needs the GPIO driver to be probed/registered to even be able to parse
the GPIO ID out of the DT; it makes a call into the GPIO driver as
part of the parsing. So, the DT code will always have to handle
deferred probe, as well as gpio_request() (for the case where the GPIO
ID came from platform data and hence there was no earlier point where
deferred probed would be detected).
