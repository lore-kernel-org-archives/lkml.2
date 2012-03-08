Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2CHLqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:46:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63855 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2CHLqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:46:33 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	<20120307093026.GM17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	<20120307103112.GP17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	<20120307124620.GT17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	<20120307142634.GA18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	<20120307162755.GB18787@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	<1331188201.4657.51.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203080902170.29847@axis700.grange>
Date: Thu, 8 Mar 2012 12:46:32 +0100
Message-ID: <CACRpkdY4y6Dj+G0zNoeY5DGWW1CRXez4pVCju2SXc=9oNyzdGw@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 11:16 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

>(...) our case can be handled _very_ easily:
>
> 1. a client requests a channel of a specific type
> 2. one of channels of that type, residing on one of compatible
>   controllers, is allocated, configured and handed in to the client
>
> That's it. No filtering, no post-allocation configuration - at least so
> far. And penalising such a simple case by forcing it to use virtual
> channels and filter through some unnatural mappings doesn't seem very
> productive to me.

But you do realize that this increases the complexity of the
dmaengine and means more maintenance burden for the
subsystem maintainer that will after this have to think in two
different sematic ways about channel retrieveal - yeah this one
passes that as parameter and this one has a config struct
provided, then this one use a filter function still - etc.

That is, of course, unless you convert all the existing DMA
engines to do it the same way, then it's redesigning proper.

In that case I am much more positive to the change, even
if it doesn't take us all the way to the new channel mappings
we want to have.

You haven't stated whether you will go in and rewrite the other
drivers to use this scheme or whether you will just add this one
kludge to handle this one DMA controller, then just update
all others to ignore the parameter. (You'd obviously have to
do that to get this to even compile...)

So the *proper* way to refactor to using this scheme would
be to introduce this new scheme *and* remove the filter
function from all the other drivers and DMA engine at large,
so it's not needed anymore. Which means a bit of refactoring.

Currently drivers have to pass a filter function from
platform data to filter out relevant channels, and with
the new style (this patch plus removing all filter functions)
it will be passing something else instead. That's all
fine, and actually an improvement, because passing around
a filter function is not as good as passing some struct
with data.

So does RFC patch mean you will fix this up for everyone
or does it mean something else?

If you're not also planning to get rid of the filter functions
for all other drivers I don't see this going anywhere right
now. It is not beneficial for dmaengine, the only benefit
is one more kludgy driver to maintain.

Yours,
Linus Walleij
