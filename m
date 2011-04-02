Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1DBCuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 22:50:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39052 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299Ab1DBCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 22:50:05 -0400
Date: Sat, 2 Apr 2011 11:50:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: pm8921-regulator: Add regulator driver
 for PM8921
Message-ID: <20110402025012.GD25424@opensource.wolfsonmicro.com>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
 <1301523432-6017-1-git-send-email-collinsd@codeaurora.org>
 <20110330234613.GA21487@opensource.wolfsonmicro.com>
 <4D93DAD2.5080501@codeaurora.org>
 <20110331234359.GD21726@opensource.wolfsonmicro.com>
 <4D965F9D.3060907@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D965F9D.3060907@codeaurora.org>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 04:28:29PM -0700, David Collins wrote:

> the device while asleep.  However, the regulator would need to be
> configured for pin control to ensure that it is enabled when the second
> consumer expects it to be.  It is also normal to mask off pin control if
> the second consumer is to be disabled.

This all seems fairly standard and like many other regulators except for
the the masking off the pin control.  The only unusual thing is that the
hardware control is being managed by software at runtime, usually it's
set up and then left alone by software.

The first thing I'm thinking here is that this maps fairly well onto a
semi-virtual regulator where the operations map onto the control for the
hardware mode.  The enable/disable control via the pin is totally
orthogonal to the control via the regular register interface, and it
sounds like the mode control is too though that was less clear to me.
Enabling would then translate into turning pin control on rather than
actually enabling but that seems OK.  Does that sound like it'd work?

> >> We consider this to be the native PMIC 8921 regulator driver because it
> >> accesses the PMIC directly.  There will be a subsequent PMIC 8921
> >> regulator driver which issues requests to a separate processor which
> >> aggregates our requests with those of other SOC processors.

> > That's not an issue - the regulator API won't write to the regulators
> > unless the machine driver explicitly tells it that this is OK so all
> > that will happen is that we'll be able to read back the state of the
> > regulators directly.  If your driver is modifying the state of the
> > regulators without the API telling it to then we should fix that as the
> > no-write behaviour is an important safety feature.

> The regulator probe function reads the regulator register values to figure
> out the initial hardware state.  It also sets some regulator controls not
> handled by other regulator framework callback functions; e.g.: pull down

That just sounds like platform data which could just work in the same
way as the regulator core - no platform data would mean nothing gets
changed.

> enable.  I'm not sure if this could be moved into an init_data
> regulator_init callback because that pointer would need to be specified in
> the board file where the function would be unknown.

I'm sorry, I don't understand what you're saying here.  Could you
clarify?

> Also, it would pollute the system with unusable devices if all natively
> controlled regulator devices were registered if the shared driver was
> being used for many regulators.

Depends if you view it as pollution or not; also note that the devices
aren't totally unusuable as you can still use them for readback.

> I guess I will change the set voltage callbacks so that they round up the
> vprog value:
> 	vprog = (min_uV - band_min_uV + step_size - 1) / step_size
> instead of
> 	vprog = (min_uV - band_min_uV) / step_size
> It will also check that the resulting output voltage is <= max_uV.

That sounds right, yes.
