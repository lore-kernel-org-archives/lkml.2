Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2K1VGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:06:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab2K1VGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:06:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <50B6395B.806@calxeda.com>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
 <20121128023240.GA28170@S2100-06.ap.freescale.net>
 <50B60E9C.9000405@calxeda.com>
 <20121128145759.GB28170@S2100-06.ap.freescale.net>
 <20121128151741.GC28170@S2100-06.ap.freescale.net>
 <20121128160115.21126.3841@nucleus> <50B6395B.806@calxeda.com>
Message-ID: <20121128210552.21126.90710@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank cpufreq
Date: Wed, 28 Nov 2012 13:05:52 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Langsdorf (2012-11-28 08:18:35)
> On 11/28/2012 10:01 AM, Mike Turquette wrote:
> > Quoting Shawn Guo (2012-11-28 07:17:44)
> >> On Wed, Nov 28, 2012 at 10:58:02PM +0800, Shawn Guo wrote:
> >>> On Wed, Nov 28, 2012 at 07:16:12AM -0600, Mark Langsdorf wrote:
> >>>> I'd
> >>>> have to move most of the logic of hb_set_target() into
> >>>> clk_highbank.c:clk_pll_set_rate() and then add extra logic for when
> >>>> cpufreq is not enabled/loaded.
> >>>
> >>> You only need to move hb_voltage_change() into cpu clock's .set_rate()
> >>> hook with no need of checking if cpufreq is enabled or not.
> >>>
> >> Need to also check whether frequency or voltage should be changed first
> >> in .set_rate() though.
> >>
> >> Shawn
> >>
> > 
> > The notifiers in the clk framework might be a better place for this than
> > just simply hacking the logic into the .set_rate callback.
> 
> Unless the clk notifiers are different than the cpufreq notifiers, they
> don't handle returning error conditions very well. And given that the
> voltage change operation can fail (though it almost always succeeds on a
> retry) I need to be able to handle and detect that error condition.
> 

The notifier handler can handle the case where the transition fails (and
needs to be retried).

Also you should check out the clk notifiers.  I think they handle
failure decently.  If a notifer returns an error code then everything
unrolls and the clk_set_rate operation aborts.

Regards,
Mike

> > I haven't looked at the definition of hb_voltage_change but does the
> > call graph make any clk api calls?  Are you talking over i2c to a
> > regulator?  If so then you'll probably hit the same reentrancy problem I
> > hit when trying to make a general solution.
> 
> I'm talking over a pl320 Interprocessor Communication Mailbox to a
> separate core running it's own RTOS. The RTOS might speak i2c to a
> regulator but it's a black box to me.
> 
> hb_voltage_change() doesn't make any clk api calls. It changes the
> voltages, and then hb_set_target() makes clk api calls to change the
> frequency.
> 
> --Mark Langsdorf
> Calxeda, Inc.
