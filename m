Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2CGJqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:46:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39604 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2CGJqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
	<Pine.LNX.4.64.1203021341590.913@axis700.grange>
	<1331022623.24656.191.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203060935460.9300@axis700.grange>
	<1331035739.24656.201.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203061339330.9300@axis700.grange>
	<1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
Date: Wed, 7 Mar 2012 10:46:38 +0100
Message-ID: <CACRpkda7F9ajf=LkPdJMP3WsZ94CrP3indO=WcE3v8UBX_BBGQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:18 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> [Vinod]
>> I like the approach outlined by Linus W [1], where we can get the
>> information from platform (DT, FW,....) and its presented to dmaengine.
>
> I still don't see an answer to the very same question, that we've been
> discussing over multiple threads and mails now: how do we use that, if
> it's not a 1-to-1 mapping? I.e., many channels on many controllers can be
> run-time configured for use with different client devices. Also the above
> idea from Linus W doesn't directly address this.

True, it's a new problem space.

However I see nothing wrong in the basic idea that the platform data
and/or device tree should supply a number of mappings with constraints
to dmaengine, that eventually helps it to select and enable a proper
channel.

For example in the regulator framework we have voltage constraints on
the rails, and the subsystem infers the voltage from these constraints.
Constraints in platform data are nice.

So the way forward in my simple opinion is to get the core dmaengine
to be aware of the applicable constraints and hand out DMA channels
or NACK channel requests if these constraints cannot be satisfied.

So when you write:

> Whereas doing a reverse mapping: for each (potential)
> DMA user reference a list of channels, that it can use - would be really
> clumsy.

I basically disagree. I think the knowledge of available channels
and their characteristics should be known to the dmaengine
core, and the core shall select what channel to use.

Else I fear we end up with a lot of logic distributed all over the
place with no consolidation in sight, it will just grow everywhere
with each new DMA controller.

However it may need to have a different form given what Russell
says: many drivers tend to have a number of arbitrable channels
and the constraints is really about which event line (burst/single
request line) to mux in for that one channel. So the platform
data may need to take a form that better reflects this, which in
turn necessitates that the dmaengine core and channel request
interface be refactored to be aware of this kind of DMAC slaves.

It requires a bit of upfront code but I think this is the way forward.
Besides, Russell says he's already working on refactoring one
part of the problem (virtual channels / request lines) if I understand
him correctly.

Yours,
Linus Walleij
