Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1C1SOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:14:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1C1SOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:14:33 -0400
Date: Mon, 28 Mar 2011 19:14:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Propagate uA_load requirements up
	supply chain
Message-ID: <20110328181415.GD31457@n2100.arm.linux.org.uk>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org> <1301326482-6547-3-git-send-email-collinsd@codeaurora.org> <20110328180255.GA28494@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328180255.GA28494@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 07:02:55PM +0100, Mark Brown wrote:
> On Mon, Mar 28, 2011 at 08:34:42AM -0700, David Collins wrote:
> > regulator_set_optimum_mode currently only determines the load
> > on the specified regulator.  Physically however, this current
> > must be provided by regulators further up the supply chain.
> > Add code to handle uA_load propagation up through the regulator
> > supply chain.
> 
> We can't do this - current doesn't map 1:1 through a regulator, the
> power consumption will map through but obviously there's a voltage
> change involved and the regulators will not be 100% efficient so there
> will also be some overhead from the chipld regulator.  The child
> regulator needs to do the mapping in a regulator specific fashion.

That's not true.  Firstly, *all* regulators are not 100% efficient.  They
lose *power* in the form of heat.  So power into the regulator will always
be more than power out.

For linear regulators, the current flowing into a regulator is the sum
of the output current and the regulators operating current (which may
itself depend on the output current.)  The input voltage will always be
greater than the output voltage.  Therefore, from P=IV, power in will
always be greater than power out.  So, if you have a 5V regulator
connected to a 10V supply, supplying 1A to a load, then:

Power out = 5V * 1A = 5W
Power in = 10V * (1A + operating current) = >10W
Power lost = >10W - 5W = >5W which will be in the form of heat.

For switching regulators, you have power lost again in the form of heat,
generated from the current required to run the regulators electronics
and the need to charge and discharge capacitances.  Although these are
much more efficient than linear regulators, they don't get you to 100%
efficiency.

Note that also because P=IV, if the current doesn't map 1:1 through a
regulator, the power certainly won't either.
