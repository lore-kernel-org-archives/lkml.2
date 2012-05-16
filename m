Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2EPHXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:23:35 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58146 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2EPHXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120516010919.GA1295@codeaurora.org>
References: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
	<20120511174112.D9EEE3E0791@localhost>
	<20120516010919.GA1295@codeaurora.org>
Date: Wed, 16 May 2012 09:23:33 +0200
Message-ID: <CACRpkdYWfmwAZS=KAFkUO1RSV5=YD-PnO3cHfs=P+eoQDZCsZA@mail.gmail.com>
Subject: Re: [PATCH] gpio/msm-v1: re-read IRQ flags on each iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 3:09 AM, David Brown <davidb@codeaurora.org> wrote:
> On Fri, May 11, 2012 at 11:41:12AM -0600, Grant Likely wrote:

>> I'll need an ack from an msm developer before applying this.
>
> I though I saw Jeff Ohlstein reply, but I'm not finding that message.

He was replying to a similar patch affecting the DMA controller
interrupt-like construct.

> I believe this patch is actually incorrect.  The register needs to
> only be read once, and the bits walked through.  If another interrupt
> comes in during the loop, the interrupt will remain asserted, and we
> will re-enter the irq handler.  I suppose it could be wrapped in yet
> another loop, but I'm not sure it is worth it.

OK the code doesn't say really. (It did say something like that
in the DMA controller). It's quite uncommon with these type of
latched-clear registers (reading IRQ status clears the flags) type
of hardware so maybe it should be commented.

> I'm pretty sure the code works as it is, since it is the same as the
> code in the Android kernel.

The problem with this bug is that it often works until you get a
demanding case. On the VIC I guess it wasn't noticed until tested with
a device that raised a storm of IRQs so the handler started missing
them.

On a GPIO this would be the case where a GPIO IRQ is asserted
in real quick succession, like the same IRQ being asserted while
the previous IRQ on the same line is being handled and where
missing one of these IRQs creates problems.

It's gonna be error phenomena of the type "it looks like we're
missing some IRQs from our touchscreen". etc.

Yours,
Linus Walleij
