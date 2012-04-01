Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2DAHDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:03:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:6595 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2DAHDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148326389"
Message-ID: <1333263819.2387.94.camel@rui.sh.intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Zhang Rui <rui.zhang@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafeal J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Date: Sun, 01 Apr 2012 15:03:39 +0800
In-Reply-To: <20120401055603.GA11505@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <1333258053.2939.22.camel@minggr>
	 <20120401055603.GA11505@localhost.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2012-04-01 at 13:56 +0800, Aaron Lu wrote:
> Hi,
> 
> On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> > > -		if (device->power.states[state].flags.explicit_set) {
> > > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > > +		if (state == ACPI_STATE_D3_COLD) {
> > > +			explicit_set = (ps - 1)->flags.explicit_set;
> > > +			object_name[3] -= 1;
> > > +		}
> > 
> > I'm not sure whether this works or not.
> > 
> > From ACPI spec,
> > 
> > _PS3 "is used to put the specific device into its D3hot or D3 state"
> > 
> > D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> > D3cold were introduced.
> I guess D3 has to mean something, right? :-)
> 
> Here is the problem, there is no _PR3 in AMD's implementation, just _PS3.
> And since _S0W evaluates 4, I've to put this device into D3 cold state
> with _PS3.
> 
First of all, I agree that we must evaluate _PS3 when setting device to
either D3_HOT or D3_COLD.

And here is my understanding about D3/D3_HOT/D3_COLD,

if _PR3 exists, it means the devices supports both D3_HOT and D3_COLD.

if only _PS3 exists, we can only say that the state after evaluating
_PS3 is D3, it could either be D3_HOT or D3_COLD, and this is device
specific, which in your case, is D3_COLD.

BTW, here is the description of _S0W in ACPI spec,
If OSPM has not indicated that it supports _PR3 through the OSPM
Platform-Wide Capabilities (see Section 6.2.10.2), then the value "3"
corresponds to D3. If it has indicated _PR3 support, the value "3"
represents D3hot and the value "4" represents D3cold.

So IMO, the _S0W should return 3 in AMD's implementation as it does not
have _PR3.

> And the ACPI does have some words like:
> 
> ------
> Platform/drivers must assume that the device will have power completely
> removed when the device is place into “D3” via _PS3
> ------
> 
I think this means OS can not access device any more after evaluating
_PS3, and it should re-enumerate the device when transiting back to D0.

> This is in section 7.2.11: _PR3.
> 
> > 
> > Another problem:
> > 
> > With your patch, both D3hot and D3cold will evaluate _PS3, right?
> > 
> Yes.
> 
> > Will it have problem on AMD platform if you try to put ODD into D3hot
> > state? _PS3 is evaluated, so it actually enters D3Cold state.
> 
> There is no D3 hot support for this device(from the firmware's
> perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> _PS3).
> 
I was trying to make a cleanup of the D3/D3_HOT/D3_COLD support in
Linux, and this gives me some clue.

How about this?

We should use the term "D3" in general in Linux.
Without _PR3, OS should *assume* that the power is removed, although it
may be not true.
With _PR3, OS can *assure* that the power is removed, because it knows
how to remove thw power (evaluating _PR3._OFF).

So the difference is that OS need to make sure whether to evaluate
_PR3._OFF when _PR3 exists. For example, a device has _PR3, but _S0W
returns 3, OS should not evaluate _PR3._OFF when the device sleeps with
remote wakeup support.

what do you think?

thanks,
rui

