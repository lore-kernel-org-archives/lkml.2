Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1C2Iox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:44:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54716 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751202Ab1C2Iov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:44:51 -0400
Date: Tue, 29 Mar 2011 17:44:59 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: Propagate uA_load requirements up
 supply chain
Message-ID: <20110329084458.GD29330@opensource.wolfsonmicro.com>
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
 <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:53:52PM -0700, David Collins wrote:
> regulator_set_optimum_mode currently only determines the load
> on the specified regulator.  Physically however, this current
> must be provided by regulators further up the supply chain.

This isn't actually true - it's very common for the system to be
designed such that all the regulators are supplied from a single
unregulated system power rail, especially with modern PMICs.

> Add code to handle uA_load propagation up through the regulator
> supply chain in both regulator_set_optimum_mode and drms_uA_update.

So, my main concern here is essentially the same thing I said with
regard to your original posting about the locking - this all seems
like it's the wrong approach and if we just treated supplies the same as
other consumers life would get a lot simpler.  This is adding a lot more
special cases for supplies which feels like it's making the code more
complicated.  Supplied regulators are essentially just consumers and
this is adding more code that diverges the two and makes it hard to
follow what's going on - ideally when dealing with the parent regulator
you shouldn't have to worry about child regulators at all, they should
just look like all the other consumers.

> Add a new regulator operation callback function named
> get_current_required to struct regulator_ops to assist in this
> propagation.  get_current_required will return the input current
> required for a given regulator based on input voltage, output
> voltage, and output current.  It should be able to capture all
> hardware specific current characteristics of a regulator.
> The input current required for a typical linear and switching
> regulator would be simple to describe in this callback.

The other issue here is that I'm concerned about the direction this
appears to be heading given that it seems like in order for this to do
something useful we'd need to start supplying current drain information
from consumers.  We're not doing that at the minute and I'm not terribly
optimistic that we'd ever get enough useful information to make it
generally worthwhile.

Besides, the interesting stuff tends to be around response to sudden
changes in load and that's basically all been pushed down into hardware
as there's no way for software to propagate the information fast enough.
For software you tend to have to assume the worst case load but that
will usually be a massive overestimate, and of course transients will be
absorbed by the passives to a certain extent which complicates matters
further.

Perhaps if you could explain your use case for this things might become
clearer?
