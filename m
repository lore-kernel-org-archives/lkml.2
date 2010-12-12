Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0LLNNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:13:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55381 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751752Ab0LLNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:13:17 -0500
Date: Sun, 12 Dec 2010 13:13:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: skannan@codeaurora.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Call into regulator driver only when
 voltage min/max really changes.
Message-ID: <20101212131328.GF15189@opensource.wolfsonmicro.com>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
 <20101212121842.GC15189@opensource.wolfsonmicro.com>
 <d681667c87585c281d0330c030c97025.squirrel@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d681667c87585c281d0330c030c97025.squirrel@codeaurora.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 04:41:04AM -0800, skannan@codeaurora.org wrote:
> > On Sun, Dec 12, 2010 at 02:55:40AM -0800, Saravana Kannan wrote:

> > Out of interest do we have any examples of consumers that do this
> > sufficiently often and/or in paths sufficiently performance critical for
> > it to be an issue?  Sounds like there might be room for optimisation in
> > those consumers.

> Wouldn't it be better to optimize in one location (the core), instead of
> optimizing in several consumers?

It's certainly good to optimise in the core, which is why I acked your
patch, but it strikes me that if these consumers are regularly setting
the regulator voltage to the same thing over and over again they may
well also be doing whatever else goes along with setting the voltage
over and over again and there's room for optimisation there also.

> > The down side of doing this is that if the regulator state changes
> > underneath us we've now got no way of recovering from that situation.
> > This is something that's only partially supported by the API at the
> > minute but it's nice to have a story about how drivers can work with
> > this.  I'll send a patch adding an explicit sync API.

> Would this be a problem irrespective of this optimization?

At the minute this can be handled at the consumer level since if the
consumer knows that the voltage got changed underneath it (and if it
cares about the voltage then it probably ought to know about this
otherwise something is going to get upset) it can reconfigure the
voltage by calling set_voltage() again.

> Btw, after sending this patch, I just realized there might be another
> "bug" in the existing code (not my changes). What's the meaning of the
> "voltage change" event? It appears to be sent even if the regulator driver
> fails to set the voltage. It would be correct if the event just means
> "someone called set_voltage", but that seems like an unlikely definition.

It's an indication to other consumers that they might want to reread the
voltage.  Overnotification doesn't really hurt here, though it'd be nice
to avoid it.

> Let me know if I should send in a patch for that too.

It'd probably coollide with the update I'm doing for syncing voltages.
