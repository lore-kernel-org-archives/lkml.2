Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2DECb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 22:31:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:57217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab2DECbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 22:31:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="128845859"
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@amd.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
In-Reply-To: <201204010923.18330.rjw@sisk.pl>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <20120401055603.GA11505@localhost.amd.com>
	 <1333261737.2939.84.camel@minggr>  <201204010923.18330.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Apr 2012 10:31:20 +0800
Message-ID: <1333593080.11327.22.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 09:23 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Sorry for the delayed response, I've been travelling recently.
> 
> On Sunday, April 01, 2012, Lin Ming wrote:
> > On Sun, 2012-04-01 at 13:56 +0800, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> > > > > -		if (device->power.states[state].flags.explicit_set) {
> > > > > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > > > > +		if (state == ACPI_STATE_D3_COLD) {
> > > > > +			explicit_set = (ps - 1)->flags.explicit_set;
> > > > > +			object_name[3] -= 1;
> > > > > +		}
> > > > 
> > > > I'm not sure whether this works or not.
> > > > 
> > > > From ACPI spec,
> > > > 
> > > > _PS3 "is used to put the specific device into its D3hot or D3 state"
> > > > 
> > > > D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> > > > D3cold were introduced.
> > > I guess D3 has to mean something, right? :-)
> 
> Well, not necessarily.
> 
> The problem is what state the _PS3 method puts the device into: D3_hot or
> D3_cold.
> 
> Unfortunately, as far as I can say, ACPI 4.0 didn't specify any "official"
> mapping between the "old" D3 and the "new" D3_{hod|cold} states, so we need to
> figure out something.  In my opinion, the only reasonable approach is to
> assume that the state _PS3 puts the device into is always D3_cold, becuase
> _PS3 may remove power completely from the device.  It may not do that, but
> we _must_ assume it does that in general.
> 
> > > Here is the problem, there is no _PR3 in AMD's implementation, just _PS3.
> > > And since _S0W evaluates 4, I've to put this device into D3 cold state
> > > with _PS3.
> > > 
> > > And the ACPI does have some words like:
> > > 
> > > ------
> > > Platform/drivers must assume that the device will have power completely
> > > removed when the device is place into “D3” via _PS3
> 
> Exactly.  What it means is basically "always reinitialize the device from
> scratch if you have run _PS3 on it".  And that's what we should do.
> 
> > > ------
> > > 
> > > This is in section 7.2.11: _PR3.
> > > 
> > > > 
> > > > Another problem:
> > > > 
> > > > With your patch, both D3hot and D3cold will evaluate _PS3, right?
> > > > 
> > > Yes.
> > > 
> > > > Will it have problem on AMD platform if you try to put ODD into D3hot
> > > > state? _PS3 is evaluated, so it actually enters D3Cold state.
> > > 
> > > There is no D3 hot support for this device(from the firmware's
> > > perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> > > _PS3).
> > 
> > But this is the generic code. We can't only consider some special
> > device.
> > 
> > Maybe we need some flag to tell which D3 state _PS3 is used for.
> 
> No, please.  As I said above, we need to reinitialize devices that _PS3 was
> executed on, which is equivalent to saying that those devices were put into
> D3_cold.
> 
> The only situation where a device can be put into ACPI D3_hot (which is not
> the same as PCI D3_hot, mind you) is when:
> 
> (1) There is _PR3 listing some of the device's power resources as "on".
> (2) The power resources listed by the _PR3 as "off" are turned off and the
>     power resources listed by the _PR3 as "on" are left in the "on" state.

I don't understand item (2):

If the power resource is listed as "off", which means it's already
turned off. Then why should it be turned off again?

Let's see an example

Assume a device "dev0" depends on 5 power resources:

pr1, pr2, pr3, pr4, pr5

_PR3 lists 3 power resources: pr3, pr4, pr5

Device(dev0)
{
	Name(_PR3, Package (0x03)
	{
		pr3,
		pr4,
		pr5
	})
}

If dev0 is put into ACPI D3_hot and pr1 and pr2 are not referenced by
other devices, then it requires:

- pr1 and pr2 are off
- pr3, pr4 and pr5 are on

right?

Thanks,
Lin Ming

> 
> Our generic code should reflect that.
> 
> Thanks,
> Rafael


