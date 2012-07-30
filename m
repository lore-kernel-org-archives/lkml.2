Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2G3RKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:10:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52959 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2G3RKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:10:33 -0400
Message-ID: <5016C006.80008@wwwdotorg.org>
Date: Mon, 30 Jul 2012 11:10:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/3] regmap: implement irq chip suspend/resume operations
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org> <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org> <20120729210410.GM4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729210410.GM4384@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 03:04 PM, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:01:55PM -0600, Stephen Warren wrote:
> 
>> When suspending, we set up the wake mask registers as required. Some
>> chips don't have separate wake mask registers, so they set mask_base
>> equal to wake_base. In that case, when resuming, we re-program the
> 
> No, they shouldn't be doing that at all - that's at best confused.  The
> two registers do different things and if the two ranges are set the same
> then I'd not expect things to work.  Supporting that would make the code
> more complex and I'm not sure what benefit we might gain from it.

So this change was re" your comment "This loop we should just port over
into the regmap code." at http://lkml.org/lkml/2012/7/26/466.

I believe the idea is that the chip has an interrupt output from n
sources. Only some of those n sources should trigger a wakeup from
sleep. Hence, the max8907 driver was writing out the "sleep enables" to
the enable registers whenever entering sleep, so that any other IRQ
sources within the chip didn't trigger the chip's interrupt output and
hence exit sleep. If we are to port that code into the regmap-irq core,
it seems to make sense to have enable_base==wake_base, since the same
register truly is being used for both enable/wakeup-enable, just
time-multiplexed.

Or, perhaps the IRQ core already disables all non-wake interrupts for
us, so the driver doesn't have to do this, and we can just drop that
code completely?
