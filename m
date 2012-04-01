Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2DAIBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:01:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:52175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab2DAIBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125723106"
Message-ID: <1333267314.2387.122.camel@rui.sh.intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>,
        "Moore, Robert" <robert.moore@intel.com>
Date: Sun, 01 Apr 2012 16:01:54 +0800
In-Reply-To: <201204010947.27234.rjw@sisk.pl>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <1333263819.2387.94.camel@rui.sh.intel.com>
	 <20120401153434.GA3268@localhost.amd.com> <201204010947.27234.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2012-04-01 at 09:47 +0200, Rafael J. Wysocki wrote:
> On Sunday, April 01, 2012, Aaron Lu wrote:
> > Hi,
> > 
> > On Sun, Apr 01, 2012 at 03:03:39PM +0800, Zhang Rui wrote:
> > > First of all, I agree that we must evaluate _PS3 when setting device to
> > > either D3_HOT or D3_COLD.
> > Good.
> > 
> > > 
> > > And here is my understanding about D3/D3_HOT/D3_COLD,
> > > 
> > > if _PR3 exists, it means the devices supports both D3_HOT and D3_COLD.
> > Agree.
> > 
> > > 
> > > if only _PS3 exists, we can only say that the state after evaluating
> > > _PS3 is D3, it could either be D3_HOT or D3_COLD, and this is device
> > > specific, which in your case, is D3_COLD.
> > I prefer Rafeal's definition, let's just *assume* the device is at D3
> > cold after its _PS3 is executed. Unless it has _PR3, in which case, we
> > have a chance to put the device into D3 hot instead.
> > 
> > > 
> > > BTW, here is the description of _S0W in ACPI spec,
> > > If OSPM has not indicated that it supports _PR3 through the OSPM
> > > Platform-Wide Capabilities (see Section 6.2.10.2), then the value "3"
> > > corresponds to D3. If it has indicated _PR3 support, the value "3"
> > > represents D3hot and the value "4" represents D3cold.
> > > 
> > > So IMO, the _S0W should return 3 in AMD's implementation as it does not
> > > have _PR3.
> > OK, sounds like a firmware bug.
> > Thanks for identifying this.
> 
> I don't think this is a bug.  It actually may return either 3 or 4, because
> there is no difference between them if there's no _PR3 (i.e. the action to
> carry out by software would only be different if _PR3 were present).
> 
I mean, surely that software should handle this case.
But this is still a violation of ACPI spec, as the device has only one
D3 state, instead of D3_HOT/D3_COLD,, thus _S0W should return 3 instead.

thanks,
rui
> > > > And the ACPI does have some words like:
> > > > 
> > > > ------
> > > > Platform/drivers must assume that the device will have power completely
> > > > removed when the device is place into “D3” via _PS3
> > > > ------
> > > > 
> > > I think this means OS can not access device any more after evaluating
> > > _PS3, and it should re-enumerate the device when transiting back to D0.
> > > 
> > > > This is in section 7.2.11: _PR3.
> > > > 
> > > > > 
> > > > > Another problem:
> > > > > 
> > > > > With your patch, both D3hot and D3cold will evaluate _PS3, right?
> > > > > 
> > > > Yes.
> > > > 
> > > > > Will it have problem on AMD platform if you try to put ODD into D3hot
> > > > > state? _PS3 is evaluated, so it actually enters D3Cold state.
> > > > 
> > > > There is no D3 hot support for this device(from the firmware's
> > > > perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> > > > _PS3).
> > > > 
> > > I was trying to make a cleanup of the D3/D3_HOT/D3_COLD support in
> > > Linux, and this gives me some clue.
> > This is great, and I would like to help as much as I can.
> > 
> > > 
> > > How about this?
> > > 
> > > We should use the term "D3" in general in Linux.
> > > Without _PR3, OS should *assume* that the power is removed, although it
> > > may be not true.
> > > With _PR3, OS can *assure* that the power is removed, because it knows
> > > how to remove thw power (evaluating _PR3._OFF).
> > > 
> > > So the difference is that OS need to make sure whether to evaluate
> > > _PR3._OFF when _PR3 exists. For example, a device has _PR3, but _S0W
> > > returns 3, OS should not evaluate _PR3._OFF when the device sleeps with
> > > remote wakeup support.
> > > 
> > > what do you think?
> > I agree with Rafeal's ideas.
> 
> Good. :-)
> 
> Thanks,
> Rafael


