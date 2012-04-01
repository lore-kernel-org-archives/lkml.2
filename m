Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2DAHfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:35:30 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:5372
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925Ab2DAHf3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:35:29 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzc89bh1dbaL1432N98dK148cMzz1202hzzz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1SIEZ-01-3BD-02
X-M-MSG: 
Date: Sun, 1 Apr 2012 23:34:35 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafeal J. Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120401153434.GA3268@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
 <1333258053.2939.22.camel@minggr>
 <20120401055603.GA11505@localhost.amd.com>
 <1333263819.2387.94.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1333263819.2387.94.camel@rui.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Apr 2012 07:35:17.0320 (UTC) FILETIME=[FBF6FC80:01CD0FD9]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 01, 2012 at 03:03:39PM +0800, Zhang Rui wrote:
> First of all, I agree that we must evaluate _PS3 when setting device to
> either D3_HOT or D3_COLD.
Good.

> 
> And here is my understanding about D3/D3_HOT/D3_COLD,
> 
> if _PR3 exists, it means the devices supports both D3_HOT and D3_COLD.
Agree.

> 
> if only _PS3 exists, we can only say that the state after evaluating
> _PS3 is D3, it could either be D3_HOT or D3_COLD, and this is device
> specific, which in your case, is D3_COLD.
I prefer Rafeal's definition, let's just *assume* the device is at D3
cold after its _PS3 is executed. Unless it has _PR3, in which case, we
have a chance to put the device into D3 hot instead.

> 
> BTW, here is the description of _S0W in ACPI spec,
> If OSPM has not indicated that it supports _PR3 through the OSPM
> Platform-Wide Capabilities (see Section 6.2.10.2), then the value "3"
> corresponds to D3. If it has indicated _PR3 support, the value "3"
> represents D3hot and the value "4" represents D3cold.
> 
> So IMO, the _S0W should return 3 in AMD's implementation as it does not
> have _PR3.
OK, sounds like a firmware bug.
Thanks for identifying this.

> 
> > And the ACPI does have some words like:
> > 
> > ------
> > Platform/drivers must assume that the device will have power completely
> > removed when the device is place into “D3” via _PS3
> > ------
> > 
> I think this means OS can not access device any more after evaluating
> _PS3, and it should re-enumerate the device when transiting back to D0.
> 
> > This is in section 7.2.11: _PR3.
> > 
> > > 
> > > Another problem:
> > > 
> > > With your patch, both D3hot and D3cold will evaluate _PS3, right?
> > > 
> > Yes.
> > 
> > > Will it have problem on AMD platform if you try to put ODD into D3hot
> > > state? _PS3 is evaluated, so it actually enters D3Cold state.
> > 
> > There is no D3 hot support for this device(from the firmware's
> > perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> > _PS3).
> > 
> I was trying to make a cleanup of the D3/D3_HOT/D3_COLD support in
> Linux, and this gives me some clue.
This is great, and I would like to help as much as I can.

> 
> How about this?
> 
> We should use the term "D3" in general in Linux.
> Without _PR3, OS should *assume* that the power is removed, although it
> may be not true.
> With _PR3, OS can *assure* that the power is removed, because it knows
> how to remove thw power (evaluating _PR3._OFF).
> 
> So the difference is that OS need to make sure whether to evaluate
> _PR3._OFF when _PR3 exists. For example, a device has _PR3, but _S0W
> returns 3, OS should not evaluate _PR3._OFF when the device sleeps with
> remote wakeup support.
> 
> what do you think?
I agree with Rafeal's ideas.

-Aaron


