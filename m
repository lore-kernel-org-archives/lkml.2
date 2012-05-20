Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab2ETCrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:47:24 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:28074
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757879Ab2ETCrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:47:23 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sun, 20 May 2012 11:06:54 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
Message-ID: <20120520030653.GB5810@S2100-06.ap.freescale.net>
References: <4FB80F32.5090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB80F32.5090309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 04:22:58PM -0500, Rob Herring wrote:
> Grant Likely (2):
>       clk: add DT clock binding support

I just checked your branch and found that a couple of comments that
I put on this patch haven't get addressed.  The most notable one would
be the "clocks" property of clock consumers.

+==Clock consumers==
+
+Required properties:
+clocks:                List of phandle and clock specifier pairs, one pair
+               for each clock input to the device.  Note: if the
+               clock provider specifies '0' for #clock-cells, then
+               only the phandle portion of the pair will appear.
+
+Optional properties:
+clock-names:   List of clock input name strings sorted in the same
+               order as the clocks property.  Consumers drivers
+               will use clock-names to match clock input names
+               with clocks specifiers.

As I said, any clock in the clock tree except root clock is not only
a clock provider but also a consumer.  If you define "clocks" as a
required property for clock consumers, you are essentially asking users
to either define the whole clock tree in the device tree or stay away
from device tree completely.

Are you sure this is the right thing to do?  If I remember correctly,
Grant's position is it should be pretty reasonable to have most of
the clock tree defined in clock driver and only define those leaf
clocks which are very likely to become the clock providers for other
peripherals.

Let me put a terrible example here.  Since clock tree is actually SoC
specific, I can reasonably choose to define the entire imx6q clock tree
and all the clk lookups for imx6q peripherals in clk-imx6q driver.
On imx6q-sabrelite board, the audio codec sgtl5000 uses cko (an imx6q
clock available on pad) as the clock source.  That said, I need a board
specific clk lookup here, which should be the best user of clock DT
bindings.  But sadly, with the current bindings, I can not give the
required "clocks" property for sgtl5000 node.

-- 
Regards,
Shawn

