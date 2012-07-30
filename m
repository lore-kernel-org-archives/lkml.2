Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2G3RFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:05:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2G3RFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:05:11 -0400
Message-ID: <5016BEC4.5000600@wwwdotorg.org>
Date: Mon, 30 Jul 2012 11:05:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: convert to regmap_add_irq_chips
References: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org> <20120729203854.GF4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729203854.GF4384@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 02:38 PM, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:02:56PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The Arizona chip contains a single interrupt that represents the unified
>> output of multiple internal interrupt controllers. This pattern has been
>> factored out into regmap-irq, so convert the Arizona driver to use the
>> new regmap-irq code.
> 
> So, I didn't like the patch this depends on but anyway..
> 
>> 1) regmap_add_irq_chips() calls regmap_add_irq_chip() with irq==0 rather
>>    than -1, so in turn irq_domain_add_linear() is called rather than
>>    irq_domain_add_legacy(). This change could be avoided by providing an
>>    irq_bases array to regmap_add_irq_chips().
> 
> This is a problem.

OK, can you explain why? Is the problem the difference between the two
types of IRQ domain? I would have assumed this was an internal detail of
the driver hence not an issue. I assume there's no issue with
known/static IRQ numbers, since both 0 and -1 end up dynamically
allocating the IRQ bases IIRC.

>> 2) regmap_add_irq_chips() requests the top-level interrupt itself, so this
>>    happens before the Arizona driver hooks the child BOOT_DONE and
>>    CTRLIF_ERR interrupts. In the original, all the IRQ chips were created
>>    first, and then the top-level IRQ was requested. This may cause a
>>    functional difference if those interrupts are pending at probe() time.
> 
> Boot done is very likely to be asserted.

Hmmm. Perhaps that means regmap_add_irq_chips() should be split into two
parts; one to create all the IRQ chips and hook everything together, and
the second to actually enable the interrupt.
